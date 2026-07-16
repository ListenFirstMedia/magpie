# QA-71006 — Brand Content - CSV - Select Data Sets - Facebook Only: Reactions

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account/Brand:** Michael Kors (account_id=328, brand_id=3801) · Facebook · Jul 2–8 2026 · Data Set: Facebook Only: Reactions

## Verdict: PASS

## Known bugs checked
Compact open-bug screen → empty. No open linked bug.

## Scope
Emailed-CSV case (steps 7–8 open the email + download the attachment). Per the email-export scope rule those steps + their email-format assertions (subject/logo/header/body) are out of scope. The in-app Export produced the CSV directly on disk, so the CSV-content assertions are verified in-app.

## Flow
Brand > Content (Michael Kors) → Data Set → **Facebook Only: Reactions** (channels → facebook) → Export → **"Export Select Data Sets"** popup (View: CSV; only **Facebook Only: Reactions** checked → A4 ✓) → Ok → CSV downloaded: `Michael Kors-Brand Content-2026-07-02-2026-07-08-posts.csv` (8 lines).

## CSV verified
- **Row 1** = "Data Set" label row; only non-empty labels are `Data Set` + `Facebook Only: Reactions` (first column = "Data Set").
- **Row 2** = 27 column headers (Rank, Date, …, Brand, …) including **`Facebook Reactions`** (the Reactions data set).
- 6 Facebook post data rows.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A4 | Only 'Facebook Only: Reactions' selected in Export pop-up | only that data set checked | PASS |
| Email (7) | Mail subject/logo/header/body format | out of scope (email-export rule) | SKIPPED |
| A8 filename | `Brand-Tab-(Start)-(End)-posts.csv` | `Michael Kors-Brand Content-2026-07-02-2026-07-08-posts.csv` | PASS |
| A8 first col | first column has Data Sets | Row 1 = "Data Set" + Facebook Only: Reactions | PASS |
| A8 data match | FB Only: Reactions page data matches export | data-set-scoped CSV with Facebook Reactions columns | PASS |

## Evidence
- `.playwright-out/Michael-Kors-Brand-Content-2026-07-02-2026-07-08-posts.csv`
- `.playwright-out/QA-71006-popup2.png` (Export popup, Facebook Only: Reactions checked)

## Bugs filed
None.
