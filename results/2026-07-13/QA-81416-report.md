# QA-81416 — Reporting > Data Studio - Report Table - CSV & Google Sheets Export Functionality

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54), Brand: MTV
**Status:** ✅ PASS (CSV); Google Sheets out of scope per `config/env.md`

## Steps executed
1. Reporting → Data Studio (Page Level). Added brand MTV.
2. Select Metrics → clicked "New Posts" quick-select header (expands per-channel checkboxes) → clicked the group's "On" toggle to select Posts/Facebook/Twitter/Instagram/YouTube/TikTok Posts.
3. Closed metrics modal → clicked **Go** → report_id=302483 built, table + line chart rendered (Posts Sum 73, 7-day breakdown).
4. Export → **CSV** → downloaded synchronously (`.export-button` → dropdown → `.lfm-option-label` "CSV").
5. Verified file on disk: `MTV-Data-Studio-Jul-05-2026-Jul-11-2026.csv`.
6. Google Sheets export **not attempted** — out of scope per `config/env.md` (Google 2FA on separate auth surface).

## Assertions

| Expected | Actual | Status |
|----------|--------|--------|
| CSV export downloads and matches on-screen table | Header: `Brand,View,Date,Posts,Facebook Posts,Twitter Posts,Instagram Posts,YouTube Posts,TikTok Posts`. 7 rows (Jul 5–11). Posts column sums to 73 (10+13+10+14+12+8+6) — exact match to UI's "Sum 73" | ✅ PASS |
| Google Sheets export works | Not tested — out of scope for this track | ⚠️ N/A (scoped out) |

## Bugs filed

None.

## Cleanup

Not applicable — no mutation.
