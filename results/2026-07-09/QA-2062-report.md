# QA-2062 — Pinterest Content - Post Hovering

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account:** Sephora

## Verdict: FAILED (blocked by open bug)

## Reason — open linked bugs (Rule 7: open-bug auto-fail)
Two OPEN linked defects:
- **LFMP-31979** (Bug, Open) — "Thumbnail Issue for Facebook and Pinterest Posts" — thumbnails not showing properly for some Pinterest posts in Brand > Content. This directly affects assertion **A1** (hover tooltip must show the pin **image** + caption + byline).
- **LFMP-32216** (Bug, Open) — "Brand > Content (Pinterest): Clicking on brand in any post is not navigating to its brand page" — Pinterest Brand-Content post interaction defect on the same surface.

Per the open-bug auto-fail rule, marked FAILED (blocked) **without running** until these are closed. LFMP-31979 in particular would contaminate the tooltip-image assertion.

## Bugs filed
None (LFMP-31979, LFMP-32216 already exist and are open).
