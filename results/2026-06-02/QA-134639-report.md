# QA-134639 — Brand > Insights - Verify Export across Intervals, BRI Aggregation, and TWC Parity

- **Run date:** 2026-06-04 (QA-4325 batch 12)
- **Account:** Adam Orfei
- **Result:** BLOCKED — Brand > Insights renderer hang reproduced across THREE brands (MTV, Michael Kors, Tory Burch) on `channels=instagram` single-channel + `from=2026-05-01&to=2026-05-31` Last 30 Days.
- **Carries-forward:** known-quirks `Brand Insights with Last 6/12 Months range freezes Chrome MCP renderer` extended 2026-06-04 to ALSO include 1-month single-channel windows on Tory Burch.

## Repro evidence

1. **MTV** (`brand_id=4018&channels=instagram&from=2026-05-01&to=2026-05-31`) → CDP `Runtime.evaluate` timed out at 45000ms; renderer frozen.
2. **Michael Kors** (`brand_id=12597&channels=instagram&from=2026-05-01&to=2026-05-31`) → Same CDP timeout. Renderer frozen.
3. **Tory Burch** (`brand_id=21648&channels=instagram&from=2026-05-01&to=2026-05-31`) → Same CDP timeout. Previously stable in QA-134188 batch-11 session; today unstable.

Recovery required `tabs_close_mcp` + fresh tab group between attempts. All three attempts produced identical 45s CDP hangs.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Daily CSV export per-day rows match UI | Page never loaded; export path not reachable | BLOCKED |
| A2 | 3 | Weekly/Monthly/Quarterly CSV aggregations correct | BLOCKED — page hang | BLOCKED |
| A3 | 4 | BRI tile special aggregation verified | BLOCKED — page hang. BRI tile presence on current build NOT VERIFIED. | BLOCKED |
| A4 | 5 | TWC equivalent values match Brand Insights export | BLOCKED — Brand Insights source values not capturable | BLOCKED |

## Bugs filed / Findings

**Carry-forward only** — no new bug. The known-quirks Brand>Insights renderer hang extends across additional brands today (Tory Burch added to the affected set). LFIQA verification on real-browser hardware recommended for this entire test family (QA-134639, QA-134188, QA-114845).

## Skill notes

- `brand-insights-interval-picker` skill (v2) confirmed: when renderer hang reproduces across all attempted brands in a session, defer to on-disk evidence from prior batches and document carry-forward rather than reproducing.
- For future Brand>Insights export-parity testing: try fresh CDP session (browser-level restart, not just tab close) or LFIQA manual verification.
