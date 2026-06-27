#!/usr/bin/env python3
"""Parse a saved getJiraIssue/searchJiraIssuesUsingJql JSON dump and write normalized
testcases/english/QA-<id>.md files from the Xray custom fields (Preconditions/Steps/Assertions)."""
import json, sys, os

SRC = sys.argv[1]
OUT = "testcases/english"
PRECOND, STEPS, ASSERT = "customfield_11100", "customfield_11101", "customfield_11103"

def adf_text(node, depth=0):
    """Recursively flatten an ADF doc to plain text. hardBreak->newline, list items->'- '."""
    if node is None:
        return ""
    t = node.get("type")
    if t == "text":
        return node.get("text", "")
    if t == "hardBreak":
        return "\n"
    if t in ("bulletList", "orderedList"):
        out = []
        for li in node.get("content", []):
            inner = "".join(adf_text(c) for c in li.get("content", [])).strip()
            out.append("- " + inner.replace("\n", "\n  "))
        return "\n".join(out)
    if t == "paragraph":
        return "".join(adf_text(c) for c in node.get("content", [])).strip()
    # doc / listItem / anything else: join children with blank lines for blocks
    parts = [adf_text(c) for c in node.get("content", [])]
    return "\n".join(p for p in parts if p)

data = json.load(open(SRC))
nodes = data.get("issues", {}).get("nodes", [])
written = []
for n in nodes:
    key = n["key"]
    f = n["fields"]
    summary = (f.get("summary") or "").strip()
    prio = (f.get("priority") or {}).get("name", "n/a")
    pre = adf_text(f.get(PRECOND)) or "- (none specified in Jira)"
    steps = adf_text(f.get(STEPS)) or "(no steps in Jira — explore per skill)"
    asrt = adf_text(f.get(ASSERT)) or "(no assertions in Jira)"
    path = os.path.join(OUT, f"{key}.md")
    if os.path.exists(path):
        print(f"skip {key} (exists)"); continue
    with open(path, "w") as fh:
        fh.write(f"# {key} — {summary}\n\n")
        fh.write(f"- **Source:** https://listenfirstmedia.atlassian.net/browse/{key}\n")
        fh.write(f"- **Priority:** {prio}\n")
        fh.write(f"- **Ingested:** 2026-06-27 from Jira (Xray custom fields)\n\n")
        fh.write(f"## Preconditions\n{pre}\n\n")
        fh.write(f"## Steps\n{steps}\n\n")
        fh.write(f"## Assertions\n{asrt}\n")
    written.append(key)
    print(f"wrote {key}: {summary}")
print(f"\n{len(written)} files written")
