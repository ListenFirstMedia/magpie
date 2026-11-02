# QA-19468 — LinkedIn Content - Impressions Table data set

**Verdict: PASS**

- **Run:** 2026-10-30, unattended headless (`claude -p`), Playwright MCP, dev (app.lfmdev.in)
- **Account:** UCLA (switched via the account menu from the default VIACOM; header `ACCOUNT: UCLA`, account_id=799) · **Brand:** University of California, Los Angeles (brand_id 127756)
- **Range:** Jan. 25, 2025 – Jan. 25, 2025 · **Data set:** Impressions · **Channel:** LinkedIn only · **View:** Table View · **Perspective:** Authorized data (app default) · **Aggregate row mode:** Sum (toggle unchecked)

## Steps executed
| # | Step | Result |
|---|------|--------|
| P | Precondition: logged in as UCLA | Logged in as lfiqa (Cognito "With existing account"), landed on account VIACOM, then switched account to UCLA via the account menu. |
| 1 | Navigate to Brand > Content | Done via the Brand menu > Content (real nav link). |
| 2 | Type and select UCLA in the brand dropdown; set the date range | Typed `UCLA` slowly. The typeahead returned 68 "UCLA …" brands and **no brand named exactly "UCLA"** (screenshot 03). The account's flagship brand is `University of California, Los Angeles` (the account's default brand on Brand > Content; same convention as earlier UCLA runs, including this case's 2026-10-27 run). Typed that name and picked the exact match. Dates set through the START/END picker: button reads `Jan. 25, 2025 - Jan. 25, 2025`, URL `from=2025-01-25&to=2025-01-25`. |
| 3 | Table Data Set dropdown > Impressions | Clicked the Data Set dropdown and picked `Impressions`. Dropdown label reads `Impressions`, URL `table_data_set=impressions`, Posts (4) across all channels. |
| 4 | Select only LinkedIn, click Apply | Enabled LinkedIn, disabled all other channels. `.channel-ghost.enabled` = [linkedin], Apply clicked, URL `channels=linkedin`, Posts (1). |
| 5 | Click Table View | `table.lfm-table` rendered (Rank header present): 1 post row plus the aggregate row. |

## Table evidence (Table View)
Columns: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate, Actions.

Aggregate row (Sum mode): Engagements 130 · **Engagement Rate N/A** · Impressions 10,337 · Organic Impressions 10,337 · Paid Impressions – · **Reach N/A** · **Organic Reach N/A** · **Paid Reach N/A** · Engaged User Rate N/A

Post row 1 (Sat Jan. 25, 2025 06:01 PM PST, LinkedIn video, "Chancellor Frenk provides an update on current fires…"): Engagements 130, Engagement Rate 1.26%, Impressions 10,337, Organic Impressions 10,337, Paid Impressions –, Reach –, Organic Reach –, Paid Reach –, Engaged User Rate –.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | No lock symbol displayed | No lock icon in the table, in the left-hand view (screenshot 08) or after scrolling to the right-hand columns (screenshot 09, read visually). Strict selector scan (`.fa-lock`, `.fa-lock-alt`, `.fa-unlock`, `[class*=-lock]`, `[class*=lock-]`, SVG `use`/`svg` containing "lock") returned 0; the table's outerHTML contains no "lock"; no `title` containing "lock" in the table. A broader `[class*=lock]` scan matched 1 element, which is `fa-clock` in a header status badge (off-screen at y=-39), not a lock. | PASS |
| A2a | 5 | Aggregate row: Reach = N/A | `N/A` | PASS |
| A2b | 5 | Aggregate row: Engagement Rate = N/A | `N/A` | PASS |
| A2c | 5 | Aggregate row: Organic Reach = N/A | `N/A` | PASS |
| A2d | 5 | Aggregate row: Paid Reach = N/A | `N/A` | PASS |

The aggregate row was in Sum mode (`input#aggregate_row` unchecked, `data-aggfn=avg` is the Average option, so Sum is active).

## Evidence (under .playwright-out/QA-19468/)
- 01-content-landing.png (default brand MTV on VIACOM, before account switch)
- 02-brand-ucla.png, 03-typeahead-ucla.png (68 results, no exact "UCLA")
- 04-brand-dates.png (brand + date range set)
- 05-dataset-impressions.png, 06-linkedin-applied.png, 07-table-view.png
- 08-table-left.png, 09-table-right.png (aggregate row with N/A values, no lock icons)

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed).
- bug-history.md and known-quirks.md: no entries for QA-19468 (pre-fetched grep).
- Related surface: nothing reproduced. A "Facebook Data Collection Disruption 9/27" banner appeared on the page; it concerns Facebook and does not affect this LinkedIn-only view.

## Notes
- No exact "UCLA" brand exists on the UCLA account on dev (68 typeahead results, all "UCLA …"). The test-data convention is the account's flagship brand "University of California, Los Angeles". If the spec intends a brand literally named "UCLA", that is a test-data/spec gap; the case ran on the account's default UCLA brand, matching earlier runs.
- Result is identical to the 2026-10-27 run (Engagements 130, Impressions 10,337, same N/A pattern).

## Bugs filed
None (markdown-only; no Jira tickets created).
