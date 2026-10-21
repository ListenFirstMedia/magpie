# QA-29236 — Brand Content > Video Views Data Set > Past date range data test - LinkedIn

**Run date:** 2026-10-19 · **Track:** Playwright MCP interactive · **Account:** UCLA (799) · **Brand:** University of California, Los Angeles (127756) · **Date range:** Oct. 01, 2022 – Sep. 30, 2023 (set via START/END picker; the picker states historical data is available back to Oct. 17, 2020, so the range is in retention) · **Channel:** LinkedIn only · **Data set:** Video Views
**Verdict: PASS (2/2) with a spec-wording note — 72 video posts; Video Views identity and Video Response Rate hold on all 72**

## Steps
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand>Content, brand UCLA, Data Set = Video Views | ✅ |
| 3 | Date range Oct 01 2022 – Sep 30 2023 | ✅ `from=2022-10-01&to=2023-09-30` |
| 4 | LinkedIn only | ✅ Posts (72) |
| 5–6 | Table View; all 72 rows scraped (Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views …) | ✅ |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A5 | Organic Views + Paid Views = Video Views | LinkedIn renders **Organic Views and Paid Views as "–" on every post**; the full value sits in **Unclassified Views** (column present in this data set but not named in this older spec). Organic + Paid + Unclassified = Video Views holds **72/72** (e.g. 56,255 / 41,596 / 175,663); Sum row Unclassified 891,633 = Video Views 891,633 ✓. Taken literally (en-dash = 0) Organic + Paid = 0 ≠ Video Views on all 72 — that is the channel's lack of an organic/paid split, not a data defect. Same behavior as QA-29127, whose newer wording includes Unclassified | ✅ PASS (spec wording stale: add "Unclassified Views" as in QA-29127) |
| A6 | Engagements / Video Views = Video Response Rate | 72/72 within display rounding (2,865/56,255 = 5.09% ✓; 2,119/41,596 = 5.09% ✓; 1,567/175,663 = 0.89% ✓) | ✅ PASS |

## Evidence
- `.playwright-out/QA-29236/01-linkedin-vv-2022-2023-table.png`

## Known bugs checked
- APPS-36745 (closed) not reproduced; no open linked bugs.

## Bugs filed
None. · **Cleanup:** none.
