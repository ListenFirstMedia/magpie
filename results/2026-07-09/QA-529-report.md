# QA-529 — Facebook Content - Mixed Authorization - Impressions

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account:** Michael Kors (account_id=328)
- **Brand:** SS22 New York Fashion Week Roll-Up (brand_id=265946)
- **Channel:** Facebook only · Table view · Data Set: Impressions
- **Date range:** Oct. 18, 2024 – Oct. 18, 2024
- **Filter:** Brand = Tory Burch **OR** Michael Kors (content_brand_ids [21648, 3801])

## Verdict: PASS

## Known bugs checked
Compact open-bug screen (`linkedIssues("QA-529")` + Bug/Test Failure/Problem + not-Done) → **empty**. No open linked bug.

## In-app table (Posts (3))
| Rank | Brand | Type | Publish Type | Engagements | Eng Rate | Impressions | Organic Impr. |
|---|---|---|---|---|---|---|---|
| 1 | Michael Kors | Image | Original Post | 926 | 0.32% | 286,833 | 286,833 |
| 2 | Michael Kors | Video | Original Post | 538 | 0.59% | 91,228 | 91,228 |
| 3 | Tory Burch | Video | **Reel** | **–** (en-dash) | 🔒 | 🔒 | 🔒 |

## Exported CSV (in-app, on disk)
`SS22 New York Fashion Week Roll-Up-Brand Content-2024-10-18-2024-10-18-posts.csv` (Row 1 = "Data Set" / Impressions label row; Row 2 = headers; 3 data rows). Export downloaded **synchronously to disk** via the in-app Export → CSV flow (no email needed — in scope).
- Michael Kors rows: full numerics (926 / 0.00322835…; 538 / 0.00589731…; Impressions 286,833 / 91,228).
- **Tory Burch Reel row: Engagements, Engagement Rate, Impressions, Organic Impressions all BLANK** (locked/no-data points).
- Brand column contains only **Michael Kors** and **Tory Burch**.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A7a | 7 | Brand column shows only Tory Burch + Michael Kors | 3 posts: MK, MK, Tory Burch | PASS |
| A7b | 7 | Michael Kors posts display data | 926 / 538 engagements, impressions present | PASS |
| A7c | 7 | Tory Burch Reel posts display en-dash | Engagements = "–" on the Tory Burch Reel | PASS |
| A8a | 8 | Tory Burch posts show locks for private data points | 🔒 on Eng Rate / Impressions / Organic Impressions | PASS |
| A8b | 8 | Michael Kors posts show data for all metrics | all metrics populated | PASS |
| A12a | 12 | Export shows blank cells for lock data points | Tory Burch locked cells all blank in CSV | PASS |
| A12b | 12 | Only filtered brand names in CSV Brand column | only Michael Kors + Tory Burch | PASS |
| A12c | 12 | Facebook Reel posts included in export | Tory Burch FB Reel present (Publish Type = Reel) | PASS |

## Scope note
Steps 9–12 describe an *emailed* CSV. Per the email-export scope rule the emailed download is out of scope, but the in-app Export produced the CSV directly on disk, so all A12 CSV-content checks were verified in-app (stronger than skipping). Google Sheets option not used.

## Evidence
- `.playwright-out/QA-529-table-impressions.png` — mixed-auth table (locks + en-dash).
- `.playwright-out/SS22-...-2024-10-18-2024-10-18-posts.csv` — exported CSV.

## Findings (harness notes)
- Brand Content **Filter** values are `.option-row` entries with a FontAwesome check glyph (`i.far.fa-square` → `fa-check-square` when checked); ticking requires clicking that glyph (clicking the row text alone does not check it). Use the right-panel value Search + click the glyph, then Apply Filter (enables once ≥1 value checked). First blind attempt lost selections → verify the filter chip ("Brand: … Or … Include") before proceeding.

## Bugs filed
None.
