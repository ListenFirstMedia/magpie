# QA-29127 — Brand Content - Video Views Dataset - Data Test - LinkedIn

**Run date:** 2026-10-19 · **Track:** Playwright MCP interactive · **Account:** UCLA (799) · **Brand:** University of California, Los Angeles (127756) · **Date range:** current default week Oct. 11 – Oct. 17, 2026 (video posts present, so the Aug 2022–Feb 2023 fallback was not needed) · **Channel:** LinkedIn only · **Data set:** Video Views (`table_data_set=video_views`)
**Verdict: PASS (2/2) — 7 video posts; Organic + Paid + Unclassified = Video Views on all 7 (LinkedIn shows Organic/Paid as en-dash, Unclassified carries the full value); Engagements / Video Views = Video Response Rate on all 7**

## Steps
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand>Content, brand UCLA, Data Set dropdown → **Video Views** (trusted click on the visible `.lfm-dropdown-select-box` "Public"; option list showed all cross-channel / channel-specific / custom sets) | ✅ |
| 3 | LinkedIn only | ✅ Posts (7) |
| 4–5 | Table View; per-post columns Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views (+ Viewers, Video Duration, Watch Time, VV with Cross-Posts) scraped via DOM | ✅ |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Organic Views + Paid Views + Unclassified Views = Video Views | Organic and Paid render **"–"** for every LinkedIn post (channel has no organic/paid split); Unclassified = Video Views on 7/7 (e.g. 8,163 / 2,317 / 1,387). With en-dash as 0 the identity holds 7/7. Sum row: Unclassified 17,917 = Video Views 17,917 ✓ | ✅ PASS (note en-dash) |
| A5 | Engagements / Video Views = Video Response Rate | 7/7 within display rounding (641/8,163 = 7.85% ✓; 107/2,317 = 4.62% ✓; 95/1,387 = 6.85% ✓) | ✅ PASS |

## Evidence
- `.playwright-out/QA-29127/01-linkedin-videoviews-table.png`

## Known bugs checked
- APPS-36745 (closed Test Failure on this case) — not reproduced. No open linked bugs.

## Bugs filed
None. · **Cleanup:** none.
