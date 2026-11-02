# QA-19468 — LinkedIn Content - Impressions Table data set

**Verdict: PASS**

- Run: 2026-10-29, unattended headless (`claude -p`, Playwright MCP), dev `app.lfmdev.in`
- Test Set: QA-26183 "Daily Data Testing -2"
- Skills reused: `brand-content-grid-math` (data-set-before-channel, Table View scrape), `_shared/playwright-helpers/devprod-helpers.js` (login, switchAccount, navLink, setDates, setDS, setChannels, tableView, scrape)

## Open-bug screen (Rule 7)
Case file "Open linked bugs: None open" → screen passed, case executed.

## Steps executed
1. Logged in via Cognito "With existing account" (`config/.env`) → `#home`. Precondition **account = UCLA**: profile menu → Search Account "UCLA" → clicked exact `UCLA` result → header `ACCOUNT: UCLA` (`account_id=799`).
2. Top nav: hovered **Brand** → clicked **Content** (`#explore/brand/content`, default brand_id=127756).
3. Brand dropdown → typed `UCLA`: 68 options returned (UCLA - Ambassadors Roll-Up, UCLA Alumni, UCLA Bruins, UCLA Law, ...), **none named exactly "UCLA"**. Typed `University of California, Los` → `University of California, Los Angeles` and `... Police`; clicked the exact-name `University of California, Los Angeles` (brand_id 127756, the UCLA account's own default brand). No sub-brand substituted. Header showed the brand name after selection.
4. Date picker: START DATE → Jan 25, 2025, END DATE → Jan 25, 2025 → **Ok**. URL `from=2025-01-25&to=2025-01-25`; header "Jan. 25, 2025 - Jan. 25, 2025".
5. Data Set dropdown → clicked **Impressions** (`table_data_set=impressions`).
6. Channels: before = Facebook/X/Instagram/TikTok/LinkedIn/Threads enabled (YouTube/Pinterest disabled by default). Deselected all but LinkedIn, clicked **Apply** → URL `channels=linkedin`, `Posts (1)`, no load failure.
7. Clicked **Table View** (`[title="Table View"]`) → `table.lfm-table` with `Rank` header rendered; Sum/Average toggle on **Sum** (`#aggregate_row` unchecked, left label "Sum").

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | No lock symbol displayed | DOM query (`[class*=lock]`, `i.fa-lock`, `[title*=lock]`, `[data-icon*=lock]`, `[aria-label*=lock]`, `[data-ui-name*=lock]`) found only `i.status-badge-icon.fa-clock` (status badge outside the table, a clock, not a lock). Inside the table: 0 lock-class/title/icon matches, 0 svg/img with "lock", table text has no "lock". Screenshots `11-table-view.png` and `12-table-scrolled-right.png` show no lock on any column header or cell. | PASS |
| A2a | 5 | Reach = N/A on Sum row | Sum row `Reach` = **N/A** (DOM and screenshot 12) | PASS |
| A2b | 5 | Engagement Rate = N/A on Sum row | Sum row `Engagement Rate` = **N/A** | PASS |
| A2c | 5 | Organic Reach = N/A on Sum row | Sum row `Organic Reach` = **N/A** | PASS |
| A2d | 5 | Paid Reach = N/A on Sum row | Sum row `Paid Reach` = **N/A** | PASS |

## Evidence
Table headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate, Actions.

Sum row: Engagements 130 | Engagement Rate N/A | Impressions 10,337 | Organic Impressions 10,337 | Paid Impressions – | Reach N/A | Organic Reach N/A | Paid Reach N/A | Engaged User Rate N/A.

Only post (Rank 1): Sat Jan. 25, 2025 06:01 PM PST, University of California, Los Angeles, Video, Original Post, "Chancellor Frenk provides an update on current fires in the region…"; Engagements 130, Engagement Rate 1.26%, Impressions 10,337, Organic Impressions 10,337, Paid Impressions –, Reach –, Organic Reach –, Paid Reach –, Engaged User Rate – (per-post Reach values are "–", so the Sum row shows N/A).

Result is identical to the 2026-10-20, 10-26, 10-27 and 10-28 runs.

Screenshots (`.playwright-out/QA-19468/`): 02-after-switch, 03-brand-content, 04-brand-typeahead-UCLA, 04a-typeahead-UC, 05-brand-selected, 07-dates-picked, 08-impressions-selected, 09-channels-before-apply, 10-after-apply, 11-table-view, 12-table-scrolled-right.

## Known bugs checked
- Case file "Open linked bugs": none open. `knowledge-base/bug-history.md` and `known-quirks.md`: no QA-19468 entries (pre-fetched). No related bug reproduced or interfered with the assertions. The orange "Facebook Data Collection Disruption 9/27" banner is unrelated to the LinkedIn selection.

## Notes
- Rule 1: the literal brand name "UCLA" does not exist in the dev brand typeahead (68 sub-brands, none exact). The case's "UCLA" is the account, whose own default brand is `University of California, Los Angeles` (brand_id 127756, selected from an exact-name typeahead result). Consistent with sibling cases and prior runs. If a different brand was intended, the case needs data clarification.
- The helper bootstrap also opened/logged in a prod tab (unused by this case; all steps ran on dev).

## Bugs filed
None.
