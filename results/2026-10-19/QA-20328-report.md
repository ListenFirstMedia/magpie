# QA-20328 — Brand Content > Twitter Only: Engagements & Follows Data Set > Past date range data test

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** Jan. 01, 2024 – Dec. 31, 2024 · **Channel:** Twitter only · **Data set:** Twitter Only: Engagements & Follows
**Verdict: PASS (1/1) — Organic + Paid User Follows = User Follows on all 170 evaluable posts of the 200 rendered (of 709); 30 posts show "–" for User Follows; Sum row 1,002 + – = 1,002 ✓**

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Organic User Follows + Paid User Follows = User Follows | 170/170 (most tweets 0 + – = 0; Sum row Organic 1,002 = User Follows 1,002, Paid "–" since no paid tweets). 30 rows "–" (no follow attribution for those tweets) | ✅ PASS |

## Known bugs checked
- **LFMP-32088** (Open, "User follows data is not available" after March 2026) — does **not** affect the 2024 range: User Follows data is present here, unlike the current-week case QA-19705 where every post was "–". This supports the bug being a recent collection gap rather than a display defect.

Evidence: `.playwright-out/QA-20328/01-tw-follows-2024.png` · Bugs filed: none · Cleanup: none.
