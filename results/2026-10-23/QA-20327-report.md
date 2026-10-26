# QA-20327 — Brand Content > Facebook Only: Reactions Data Set > Past date range data test

**Run:** 2026-10-23 (Friday), headless `claude -p`, dev (app.lfmdev.in), user LFQA
**Verdict: PASS**

## Configuration (spec: Friday row = Account Hulu / Brand Hulu)
- Account: **Hulu** (account_id=336; breadcrumb "Account: Hulu")
- Brand: **Hulu** (brand_id=5670) — exact "Hulu" result picked from the brand typeahead Results (Rule 1)
- Date range: **Jan 01, 2024 – Dec 31, 2024** (URL `from=2024-01-01&to=2024-12-31`)
- Data set: **Facebook Only: Reactions** (`table_data_set=facebook_only:_reactions`), only the Facebook channel enabled
- View: Table View (`[title="Table View"]`), Posts (1,082); the grid renders the top 200 posts plus the Sum/Average row, with no pager or "load more"

## Steps executed
1. Hovered Brand in the top nav and clicked Content. Landed on `#explore/brand/content?brand_id=5670`.
2. Opened the brand chevron and typed "Hulu". Clicked the exact "Hulu" result. Opened the date picker and set START Jan 01, 2024 and END Dec 31, 2024 via the calendar, then Ok.
3. Opened the data-set dropdown and clicked "Facebook Only: Reactions" (a trusted click on the option, not a URL param). Facebook was the only enabled channel (all others greyed). Applied.
4. Switched to Table View. Scraped all 200 rendered rows and the Sum row via the DOM. For each post, evaluated Likes + Loves + Hahas + Wows + Sads + Angries + Others against Reactions.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A4a | 4 | Per post: Reactions = Likes + Loves + Hahas + Wows + Sads + Angries + Others | 200 / 200 rendered posts match exactly. 0 mismatches, 0 posts without Reactions data. | PASS |
| A4b | 4 | Same identity on the aggregate Sum row | Reactions 12,660,516 = 9,837,482 + 1,446,844 + 1,262,341 + 27,543 + 81,824 + 4,482 + 0 = 12,660,516. Exact match. | PASS |

## Evidence
- Post #1 (Sun Sep. 08, 2024, "Taxi" video): Reactions 1,544,491 = 1,346,823 + 59,895 + 134,811 + 2,817 + 66 + 79 + 0.
- Post #200 (Thu Apr. 25, 2024, #PromDatesHulu): Reactions 7,011 = 5,649 + 1,334 + 8 + 18 + 0 + 2 + 0.
- Sum row: Engagements 13,601,181; Reactions 12,660,516.
- Two posts (#96 and #164) show "–" in a component column (Others on both; also Sads on #164). They were treated as 0 per the skill's rule. Sums still matched exactly: #96 Reactions 27,589 = 24,896 + 905 + 1,758 + 27 + 1 + 2 + 0; #164 Reactions 9,693 = 7,313 + 2,353 + 18 + 8 + 0 + 1 + 0.
- Screenshots: `.playwright-out/QA-20327/01-brand-content-landing.png` (captured mid-load, so it only shows the spinner) and `.playwright-out/QA-20327/02-table-view-fb-reactions.png` (Table View after Apply).

## Known bugs checked
- Case file "Open linked bugs": none open, so the Rule 7 screen passed.
- `bug-history.md` and `known-quirks.md`: no QA-20327 entries (pre-fetched).
- During the run: the Facebook Data Collection Disruption (9/27) status banner is current-period only. It did not affect the 2024 data, and no reaction column was blank for a whole post. No known bug interfered.

## Notes
- The grid shows only the top 200 of 1,082 posts (sorted by Responses desc). The identity was verified on all 200 rendered posts plus the aggregate row. The other 882 posts are not rendered in Table View.
- The first brand-typeahead listing returned many "(Hulu)" sub-brands. The exact "Hulu" entry was chosen per Rule 1.

## Bugs filed
None.
