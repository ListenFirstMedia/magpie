# QA-4325 Batch 7 — Run Log (2026-06-04)

Members 26-30 of QA-4325.

## Per-ticket result

| # | QA-ID | Title | Result | Notes |
|---|---|---|---|---|
| 26 | QA-92841 | DS - Save Breakdown Table to Dashboard - PNG & GS Exports | **PASS (5/5)** | Full E2E rerun. Popup "We are fetching the data. Please wait." captured via MutationObserver → **LFMP-31814 NOT REPRODUCED** (contradicts batch-1 finding). Save-to-Dashboard ran to Yash dashboard 6095, PNG `MTV-Dashboard-Page-Engagements-Line-2026-05-27-2026-06-02.png` 115KB end-to-end on disk, GS `MTV-Dashboard-Page-Engagements-Data-Studio-May-27-2026-Jun-02-2026` opened. Cleanup verified (tiles 1→0). LFMP-31936 NOT VERIFIED (not exercised). |
| 27 | QA-94978 | Brand Audience LinkedIn PNG Export | **PASS (6/6)** | All 6 tile-level PNGs saved end-to-end on `~/Downloads`: Job Function 161KB, Industry 642KB, Seniority 63KB, Staff Count Range 72KB, Followers By Country 142KB, Followers By Region 154KB. APPS-58574 still observed. |
| 28 | QA-95067 | LinkedIn Followers By Country & Region tile Hovering | **PARTIAL** | Country tile hover PASS: `.al-geo-map-tooltip__container` "Canada Followers 1%" rendered. Region tile hover **NO TOOLTIP** for any tested coord (UCLA's data is metro-area-level — LA Metro 38% — which doesn't map to country-polygon-only world map widget). APPS-58574 RE-REPRODUCED. |
| 29 | QA-99380 | Brand>Content DPA Modal Graph Display & Behavior | **PASS (5/5)** | Adam Orfei brand top post (Michael Kors), May 29-Jun 02 2026, 5 metrics. Line graph 14 strokes + 25 circles + axis labels; tooltip `Jun. 01, 2026 / Video Views: 6,341`; Line→Bar switch verified (25 rect bars). |
| 30 | QA-99416 | Brand Sets>Content DPA Modal Table Display & Behavior | **PASS (5/5)** | Adam's Brand Set NBA top post May 30-Jun 02 2026. Table headers `Metric/Sum/Avg/4 days`. Endash `–` on May 31 for NBA — Sum 1,038,413 = 949,199+0+72,952+16,262 ✓, Avg 259,603 = Sum/4 ✓ (endash counted in denominator). |

## New bugs / findings (filed in this batch's reports)

| Source | Bug / Finding | Severity | Status |
|---|---|---|---|
| QA-92841 | LFMP-31814 popup reappears — was REPRODUCED batch 1, now NOT REPRODUCED batch 7. May be fixed or intermittent. | Major (Jira state Open) | Recommend eng confirmation |
| QA-94978 + QA-95067 | APPS-58574 — LinkedIn cards misaligned (UCLA) | Trivial | RE-REPRODUCED (already open in Jira) |
| QA-95067 | Region tile hover renders NO tooltip when brand's region data is metro-area-level (UCLA case). Region map widget uses country polygons but UCLA's region shares are LA Metro / SF Bay Area which don't match. Could be a structural design gap. | Minor (candidate) | Documented as carry-forward finding; retest needed on a brand with country-level region data before filing as a bug |
| QA-99416 | Endash `–` in Daily Post Analysis Table treated as 0 in Sum + counted in Avg denominator. Math is internally consistent but ambiguous (could be true 0 or missing data). | Trivial | Documented for eng review |

## Chrome state for batch 8

- Active browser tab: 1804438037 — final URL `app.lfmdev.in/#explore/competitive/content?brand_set_id=1738&account_id=54...` (Brand Sets Content Adam's Brand Set)
- Account: Adam Orfei (account_id=54). UCLA round-trip completed mid-batch for QA-94978/QA-95067.
- Dashboards: Yash only (cleanup verified — MTV Engagements tile removed end-of-QA-92841)
- Downloads dir `~/Downloads` mounted into session
- Recommend fresh tab close + create at start of batch 8 (per protocol)

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-92841-report.md` (rewritten for batch-7 PASS)
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-94978-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-95067-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-99380-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-99416-report.md`
- `/Users/yashsharma/git/magpie/runs/2026-06-02/BATCH-7-LOG.md`
- Test case specs created: QA-94978.md, QA-95067.md, QA-99380.md, QA-99416.md (proxy specs)
- Saved downloads:
  - `~/Downloads/MTV-Dashboard-Page-Engagements-Line-2026-05-27-2026-06-02.png`
  - `~/Downloads/University of California, Los Angeles-Audience-Followers Job Function-2025-01-01-2025-12-31.png`
  - `~/Downloads/University of California, Los Angeles-Audience-Followers Industry-2025-01-01-2025-12-31.png`
  - `~/Downloads/University of California, Los Angeles-Audience-Followers Seniority-2025-01-01-2025-12-31.png`
  - `~/Downloads/University of California, Los Angeles-Audience-Followers Staff Count Range-2025-01-01-2025-12-31.png`
  - `~/Downloads/University of California, Los Angeles-Audience-Followers By Country-2025-01-01-2025-12-31.png`
  - `~/Downloads/University of California, Los Angeles-Audience-Followers By Region-2025-01-01-2025-12-31.png`

## Summary
- 5 tickets re-executed. 4 PASS, 1 PARTIAL.
- LFMP-31814 verdict reversal: REPRODUCED batch-1 → NOT REPRODUCED batch-7. Recommend eng review (potential fix or intermittent).
- APPS-58574 still REPRODUCES on UCLA LinkedIn Audience.
- 1 new candidate finding: Region tile hover gap for metro-area-level brands (QA-95067).
- No Jira tickets created.
