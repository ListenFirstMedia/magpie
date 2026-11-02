# QA-19468 — LinkedIn Content - Impressions Table data set

**Verdict: PASS**

- **Run:** 2026-10-27, unattended headless (`claude -p`), Playwright MCP, dev (app.lfmdev.in)
- **Account:** UCLA (switched via the account menu from the default DISNEY AD SALES) · **Brand:** University of California, Los Angeles (brand_id 127756)
- **Range:** Jan. 25, 2025 – Jan. 25, 2025 · **Data set:** Impressions · **Channel:** LinkedIn only · **View:** Table View · **Perspective:** Authorized data (app default) · **Aggregate row mode:** Sum (toggle unchecked)

## Steps executed
| # | Step | Result |
|---|------|--------|
| P | Precondition: logged in as UCLA | Logged in as lfiqa, then switched account via the menu. Header shows `ACCOUNT: UCLA` (account_id=799). |
| 1 | Navigate to Brand > Content | Done via the Brand menu > Content (real nav links). |
| 2 | Type and select UCLA in the brand dropdown; set the date range | Typed `UCLA`. The typeahead returned 64 "UCLA …" brands and **no brand named exactly "UCLA"** (screenshot 03). The account's flagship brand is `University of California, Los Angeles`, which is the convention in prior UCLA runs. Typed that name and picked the exact match (the only other result was "… Police"). Dates were set through the START/END picker: button reads `Jan. 25, 2025 - Jan. 25, 2025`, URL `from=2025-01-25&to=2025-01-25`. Posts (4) across all channels. |
| 3 | Table Data Set dropdown > Impressions | Clicked the visible dropdown and picked `Impressions`. Dropdown shows Impressions, URL `table_data_set=impressions`. |
| 4 | Select only LinkedIn, click Apply | Enabled LinkedIn and disabled the other channels. `.channel-ghost.enabled` = [linkedin], Apply clicked, URL `channels=linkedin`, Posts (1). |
| 5 | Click Table View | `table.lfm-table` rendered (Rank header present): 1 post row plus the Sum aggregate row. |

## Table evidence (Table View)
Columns: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate, Actions.

Sum row: Engagements 130 · **Engagement Rate N/A** · Impressions 10,337 · Organic Impressions 10,337 · Paid Impressions – · **Reach N/A** · **Organic Reach N/A** · **Paid Reach N/A** · Engaged User Rate N/A

Post row 1 (Sat Jan. 25, 2025 06:01 PM PST, LinkedIn video, "Chancellor Frenk provides an update on current fires…"): Engagements 130, Engagement Rate 1.26%, Impressions 10,337, Organic Impressions 10,337, Paid Impressions –, Reach –, Organic Reach –, Paid Reach –, Engaged User Rate –.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | No lock symbol displayed | No lock icon in the viewport or the horizontally scrolled right-hand columns (screenshots 07, 08). Document-wide selector scan for `lock`, `fa-lock`, `[title*=lock]` and `[aria-label*=lock]` returned 0 elements. The table's outerHTML contains no "lock". | PASS |
| A2a | 5 | Sum row: Reach = N/A | `N/A` | PASS |
| A2b | 5 | Sum row: Engagement Rate = N/A | `N/A` | PASS |
| A2c | 5 | Sum row: Organic Reach = N/A | `N/A` | PASS |
| A2d | 5 | Sum row: Paid Reach = N/A | `N/A` | PASS |

The aggregate row was in Sum mode (`input#aggregate_row[data-aggfn=avg]` unchecked, so Sum is active). Screenshot 08 shows the row with N/A in those columns.

## Evidence (under .playwright-out/QA-19468/)
- 00-after-login.png, 01-account-ucla.png
- 02-ucla-dates.png, 03-typeahead-ucla.png, 04-brand-selected.png
- 05-impressions-selected.png, 06-linkedin-applied.png
- 07-table-view.png, 08-table-right-columns.png

## Notes / spec observations
- **Brand name:** the spec says "UCLA", but no brand has exactly that name. The typeahead lists UCLA sub-brands, and the account's top-level brand is `University of California, Los Angeles`. This is the same brand every prior UCLA data-test run used, so it is not a Rule 1 substitution.
- **Login:** the first login attempt bounced back to the Cognito sign-in page. A second `login()` call succeeded, and this is a known flaky pattern.
- **Banner:** the "Facebook Data Collection Disruption 9/27" banner overlays the page. It does not affect the LinkedIn view or the assertions.

## Known bugs checked
- Case file "Open linked bugs": None open, so the Rule 7 screen passed.
- Pre-fetched `bug-history.md` and `known-quirks.md` greps for QA-19468: no matches.
- No bug interfered with the steps or assertions, and nothing reproduced during the run.

## Bugs filed
None.
