#!/usr/bin/env python3
"""Sync a batch run with the LIVE Xray Test Set: membership + case content.

The committed batches/<set>.txt and cases/*.md are point-in-time snapshots. Tests added to the
Test Set in Jira after ingestion never ran, removed ones kept running, and edited steps went
stale. This script queries Xray Cloud GraphQL (same client id/secret the pipeline already uses
for xray_report.py) and:

  1. writes the CURRENT member list (in set order) to the output batch file;
  2. ingests a cases/QA-<id>.md for every member that has no local case file;
  3. refreshes the Jira-owned sections (Description / Preconditions / Steps / Assertions + the
     header) of existing case files, PRESERVING every locally-added section verbatim
     (## Notes, ## Open linked bugs, ## Probes, ## Cleanup, ...).

Usage:  sync_set.py QA-4325 /path/to/out-batch.txt
Env:    XRAY_CLIENT_ID, XRAY_CLIENT_SECRET  (required)
        XRAY_BASE (optional, default https://xray.cloud.getxray.app)

Exit non-zero on any failure WITHOUT touching the output batch file, so the caller can fall
back to the committed snapshot. Diagnostics on stderr.
"""
import json, os, re, sys, urllib.request, urllib.error
from datetime import date

PRECOND, STEPS, ASSERT = "customfield_11100", "customfield_11101", "customfield_11103"
JIRA_FIELDS = ["key", "summary", "priority", "description", "updated", PRECOND, STEPS, ASSERT]
# Sections OWNED by Jira — regenerated on every sync. Anything else in a case file is a local
# annotation and is preserved verbatim.
CANONICAL = {"description", "preconditions", "steps", "assertions"}
CASES_DIR = "cases"

def log(*a): print(*a, file=sys.stderr)

def post(url, payload, token=None):
    hdrs = {"Content-Type": "application/json"}
    if token: hdrs["Authorization"] = f"Bearer {token}"
    req = urllib.request.Request(url, data=json.dumps(payload).encode(), headers=hdrs, method="POST")
    with urllib.request.urlopen(req, timeout=60) as r:
        return json.loads(r.read().decode())

def gql(base, token, query, variables):
    resp = post(f"{base}/api/v2/graphql", {"query": query, "variables": variables}, token)
    if resp.get("errors"):
        raise RuntimeError(f"GraphQL: {resp['errors']}")
    return resp["data"]

def adf_text(node, ordered_prefix=None):
    """Flatten ADF to markdown-ish text; ordered lists keep their numbers (reports cite 'step N')."""
    if node is None: return ""
    if isinstance(node, str): return node          # field came back as plain text / wiki markup
    t = node.get("type")
    if t == "text":      return node.get("text", "")
    if t == "hardBreak": return "\n"
    if t in ("bulletList", "orderedList"):
        out = []
        for i, li in enumerate(node.get("content", []), start=int(node.get("attrs", {}).get("order", 1)) if t == "orderedList" else 1):
            inner = "\n".join(p for p in (adf_text(c) for c in li.get("content", [])) if p).strip()
            mark = f"{i}. " if t == "orderedList" else "- "
            out.append(mark + inner.replace("\n", "\n" + " " * len(mark)))
        return "\n".join(out)
    if t == "paragraph":
        return "".join(adf_text(c) for c in node.get("content", [])).strip()
    parts = [adf_text(c) for c in node.get("content", [])]
    return "\n".join(p for p in parts if p)

def render_case(f, set_key):
    key, summary = f["key"], (f.get("summary") or "").strip()
    prio = (f.get("priority") or {}).get("name", "n/a")
    updated = (f.get("updated") or "")[:10]
    body  = f"# {key} — {summary}\n\n"
    body += f"- **Source:** https://listenfirstmedia.atlassian.net/browse/{key}\n"
    body += f"- **Priority:** {prio}\n"
    body += f"- **Synced:** {date.today().isoformat()} from Xray Test Set {set_key} (Jira updated {updated})\n\n"
    desc = adf_text(f.get("description")).strip()
    if desc:
        body += f"## Description\n{desc}\n\n"
    body += f"## Preconditions\n{adf_text(f.get(PRECOND)).strip() or '- (none specified in Jira)'}\n\n"
    body += f"## Steps\n{adf_text(f.get(STEPS)).strip() or '(no steps in Jira — explore per skill)'}\n\n"
    body += f"## Assertions\n{adf_text(f.get(ASSERT)).strip() or '(no assertions in Jira)'}\n"
    return body

def local_sections(path):
    """Return the non-canonical '## ' sections of an existing case file, verbatim and in order."""
    text = open(path).read()
    kept = []
    for m in re.finditer(r"(?ms)^## +([^\n]+)\n(.*?)(?=^## |\Z)", text):
        title = m.group(1).strip()
        if title.split(" (")[0].strip().lower() not in CANONICAL:
            kept.append(f"## {title}\n{m.group(2).rstrip()}\n")
    return kept

def strip_synced(s):  # ignore the dated Synced line when deciding whether a file actually changed
    return re.sub(r"(?m)^- \*\*Synced:\*\* .*\n", "", s)

def main():
    if len(sys.argv) != 3:
        log("usage: sync_set.py <TEST-SET-KEY> <out-batch-file>"); sys.exit(2)
    set_key, out_batch = sys.argv[1].upper(), sys.argv[2]
    cid, csec = os.environ.get("XRAY_CLIENT_ID", ""), os.environ.get("XRAY_CLIENT_SECRET", "")
    base = os.environ.get("XRAY_BASE", "https://xray.cloud.getxray.app").rstrip("/")
    if not (cid and csec):
        log("ERROR: XRAY_CLIENT_ID / XRAY_CLIENT_SECRET not set"); sys.exit(1)

    token = post(f"{base}/api/v2/authenticate", {"client_id": cid, "client_secret": csec})

    d = gql(base, token, """
      query ($jql: String) {
        getTestSets(jql: $jql, limit: 1) { total results { issueId jira(fields: ["key"]) } }
      }""", {"jql": f"key = {set_key}"})
    sets = d["getTestSets"]["results"]
    if not sets:
        log(f"ERROR: no Xray Test Set found for {set_key}"); sys.exit(1)
    set_issue_id = sets[0]["issueId"]

    tests, start = [], 0
    while True:
        d = gql(base, token, """
          query ($id: String!, $start: Int!, $fields: [String]!) {
            getTestSet(issueId: $id) {
              tests(limit: 100, start: $start) { total results { jira(fields: $fields) } }
            }
          }""", {"id": set_issue_id, "start": start, "fields": JIRA_FIELDS})
        page = d["getTestSet"]["tests"]
        tests += [t["jira"] for t in page["results"]]
        start += len(page["results"])
        if start >= page["total"] or not page["results"]: break
    if not tests:
        log(f"ERROR: Test Set {set_key} returned 0 tests — refusing to sync an empty run"); sys.exit(1)

    os.makedirs(CASES_DIR, exist_ok=True)
    new = updated = unchanged = 0
    for f in tests:
        path = os.path.join(CASES_DIR, f"{f['key']}.md")
        generated = render_case(f, set_key)
        if os.path.exists(path):
            merged = generated
            kept = local_sections(path)
            if kept: merged = generated.rstrip() + "\n\n" + "\n".join(kept)
            if strip_synced(merged) == strip_synced(open(path).read()):
                unchanged += 1; continue
            open(path, "w").write(merged); updated += 1
            log(f"   refreshed {f['key']} ({len(kept)} local section(s) preserved)")
        else:
            open(path, "w").write(generated); new += 1
            log(f"   NEW {f['key']}: {(f.get('summary') or '').strip()}")

    with open(out_batch, "w") as fh:
        fh.write(f"# synced from Xray Test Set {set_key} on {date.today().isoformat()}\n")
        for f in tests: fh.write(f["key"] + "\n")
    log(f">> {set_key}: {len(tests)} tests | {new} new, {updated} refreshed, {unchanged} unchanged")

    committed = os.path.join("batches", f"{set_key.lower()}.txt")   # drift vs the committed snapshot
    if os.path.exists(committed):
        old = {l.strip() for l in open(committed) if l.strip() and not l.startswith("#")}
        cur = {f["key"] for f in tests}
        added, removed = sorted(cur - old), sorted(old - cur)
        if added:   log(f">> added since committed snapshot: {' '.join(added)}")
        if removed: log(f">> removed since committed snapshot (will NOT run): {' '.join(removed)}")
        if not (added or removed): log(">> membership matches the committed snapshot")

if __name__ == "__main__":
    try:
        main()
    except urllib.error.HTTPError as e:
        log(f"ERROR: Xray HTTP {e.code}: {e.read().decode(errors='ignore')[:500]}"); sys.exit(1)
    except urllib.error.URLError as e:
        log(f"ERROR: Xray unreachable: {e.reason}"); sys.exit(1)
    except Exception as e:
        log(f"ERROR: {type(e).__name__}: {e}"); sys.exit(1)
