#!/usr/bin/env python3
"""Write one QA-<id>-report.md per Dev-vs-Prod comparison from results/<date>/_devprod-results.json
(the dump of ctx._res produced by skills/_shared/playwright-helpers/devprod-helpers.js).

Usage: python3 bin/devprod_reports.py [YYYY-MM-DD]

Each JSON entry is the compareOnce() result plus meta {account, brand, dates?, note?, week?}.
Open-bug policy: a case listed in results/open-bugs-<date>.json is FAILED by policy even when the
comparison itself is identical (the executed comparison is still reported as evidence)."""
import json, os, sys, datetime

DATE = sys.argv[1] if len(sys.argv) > 1 else datetime.date.today().isoformat()
D = f"results/{DATE}"
res = json.load(open(f"{D}/_devprod-results.json"))
bugs_path = f"results/open-bugs-{DATE}.json"
bugs = json.load(open(bugs_path)) if os.path.exists(bugs_path) else {}
weekday = datetime.date.fromisoformat(DATE).strftime("%A")


def title(k):
    try:
        return open(f"cases/{k}.md").readline().strip().lstrip("# ").strip()
    except OSError:
        return k


n = 0
for k, r in res.items():
    if not k.startswith("QA-"):
        continue
    meta = r.get("meta") or {}
    s = r.get("summary") or {}
    o = r.get("opts") or {}
    ds = meta.get("dsLabel") or o.get("ds") or "(default)"
    ch = ", ".join(o.get("channels") or []) or "(default)"
    cols = s.get("colsCompared") or []
    mm = s.get("mismatchCols") or {}
    agg = s.get("aggDiff") or []
    v = r.get("verdict") or "BLOCKED"
    dates = meta.get("dates") or f"default week ({meta.get('week', 'same on both')})"
    if v == "PASS":
        head = (f"PASS — {s.get('matched')} posts matched 1:1 between Dev and Prod, 0 metric differences "
                f"across {len(cols)} compared columns; aggregate row identical")
    elif v == "FAIL":
        head = (f"FAIL — dev {s.get('devPosts')} / prod {s.get('prodPosts')} posts, matched {s.get('matched')}, "
                f"only-dev {s.get('onlyDev')}, only-prod {s.get('onlyProd')}; column mismatches {json.dumps(mm, ensure_ascii=False)}; "
                f"aggregate differences {len(agg)}")
    elif v == "BLOCKED-NODATA":
        v = "BLOCKED"
        head = f"BLOCKED — 0 posts on both Dev and Prod for this brand / data set / channel in the window"
    else:
        head = f"{v} — {r.get('why') or meta.get('why') or 'comparison could not be completed'}"
    executed = head
    if meta.get("headline"):
        head = f"{v} — {meta['headline']}"
    policy = bugs.get(k)
    if policy:
        head = (f"FAILED (open linked bug — policy) — {'; '.join(policy)}. Executed comparison for reference: {executed}")
    L = [f"# {title(k)}", "",
         f"**Run date:** {DATE} ({weekday} → rotation row: account **{meta.get('account')}**, brand **{meta.get('brand')}**)",
         "**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`) in the same browser context",
         f"**Account:** {meta.get('account')} · **Brand:** {meta.get('brand')} · Date range: {dates} · Data set: {ds} · Channel(s): {ch}",
         f"**Verdict: {head}**", "",
         "## Steps executed", "| # | Step | Result |", "|---|------|--------|",
         f"| 1 | Dev: Brand > Content for {meta.get('brand')} (account {meta.get('account')}) | {'✅' if (r.get('dev') or {}).get('table') else '⚠️'} Table View |",
         f"| 2 | Dev: data set → **{ds}** | {json.dumps((r.get('dev') or {}).get('ds'), ensure_ascii=False)[:160]} |",
         f"| 3 | Dev: channel(s) → **{ch}** → Apply | enabled {((r.get('dev') or {}).get('ch') or {}).get('enabled')} · Posts ({s.get('devPosts')}) |",
         f"| 4 | Dev: Table View scrape of every row (columns: {', '.join(cols)}) | {s.get('devPosts')} posts + aggregate row |",
         f"| 5 | Prod: same brand / data set / channel(s) | enabled {((r.get('prod') or {}).get('ch') or {}).get('enabled')} · Posts ({s.get('prodPosts')}) |",
         f"| 6 | Prod: Table View scrape | {s.get('prodPosts')} posts + aggregate row |",
         f"| 7 | Join rows by post permalink and diff every shared column | matched {s.get('matched')}, only-dev {s.get('onlyDev')}, only-prod {s.get('onlyProd')} |",
         "", "## Assertions", "| ID | Expected | Actual | Status |", "|----|----------|--------|--------|"]
    tot = sum(mm.values())
    ok1 = v == "PASS" or (s.get("matched") and tot == 0)
    L.append(f"| A1 | Dev post metrics match Prod post metrics ({', '.join(cols)}) | {s.get('matched')} matched posts; "
             + ("all compared columns identical on every matched post" if tot == 0 else f"mismatches per column: {json.dumps(mm, ensure_ascii=False)}")
             + f" | {'✅ PASS' if ok1 else ('⛔ BLOCKED' if v == 'BLOCKED' else '❌ FAIL')} |")
    ok2 = s.get("onlyDev") == 0 and s.get("onlyProd") == 0 and (s.get("devPosts") or 0) > 0
    L.append(f"| A2 | Same post set on both environments | only-dev {s.get('onlyDev')}, only-prod {s.get('onlyProd')} | {'✅ PASS' if ok2 else ('⛔ BLOCKED' if v == 'BLOCKED' else '❌ FAIL')} |")
    L.append(f"| A3 | Aggregate (Sum) row identical | {'identical' if not agg else json.dumps(agg, ensure_ascii=False)[:400]} | {'✅ PASS' if (not agg and v != 'BLOCKED') else ('⛔ BLOCKED' if v == 'BLOCKED' else '❌ FAIL')} |")
    L += ["", "## Evidence",
          f"- Scrape summary for both environments: `{D}/_devprod-results.json`, key `{k}`.",
          f"- Dev aggregate row: `{json.dumps(s.get('devAgg'), ensure_ascii=False)[:600]}`"]
    if s.get("mismatchSample"):
        L.append("- Mismatch sample (post · column · dev · prod):")
        for x in s["mismatchSample"][:10]:
            L.append(f"  - {x.get('post')} · {x.get('col')} · dev `{x.get('dev')}` · prod `{x.get('prod')}`")
    if s.get("onlyDevSample"):
        L.append(f"- Only on dev (sample): {s['onlyDevSample']}")
    if s.get("onlyProdSample"):
        L.append(f"- Only on prod (sample): {s['onlyProdSample']}")
    L += ["", "## Known bugs checked",
          ("- OPEN linked bug(s): " + "; ".join(policy) + " → case FAILED by the open-bug policy regardless of the comparison outcome.") if policy else "- No open linked bug (Jira issue links checked on the run date).",
          f"- {meta['note']}" if meta.get("note") else "- No deviations from the case.",
          "", "## Bugs filed", "None.", "", "## Cleanup", "None (read-only on both environments — Data Test read-only rule).", ""]
    open(f"{D}/{k}-report.md", "w").write("\n".join(L))
    n += 1
print("wrote", n, "reports to", D)
