# QA-19468 — LinkedIn Content - Impressions Table data set

**Verdict: PASS**

- Run: 2026-10-20, unattended headless (`claude -p`, Playwright MCP), dev `app.lfmdev.in`
- Test Set: QA-26183 "Daily Data Testing -2"
- Skills reused: `switch-account` mechanics, `brand-content-grid-math` (data-set-before-channel, Table View scrape), `brand-content-native-post-check` (date picker)

## Open-bug screen (Rule 7)
Case file: "Open linked bugs: None open" → screen passed, case executed.

## Steps executed
1. Logged in via Cognito "With existing account" (config/.env). Precondition **account = UCLA**: profile menu → Search Account "UCLA" → real mouse click on the `UCLA` result (not "UCLA Law") → `ACCOUNT: UCLA`, `account_id=799`.
2. Top nav: hovered **Brand** → clicked **Content** (`#explore/brand/content`, default brand_id=127756).
3. Brand dropdown (chevron) → "Search for a Brand". Typing the literal `UCLA` returns only sub-brands ("UCLA Bruins", "UCLA Law", ... ~66 results) and **no brand named exactly "UCLA"**; the account's own brand is `University of California, Los Angeles` (listed under Recent Searches). Typed `University of California, Los` and clicked the exact-name result `University of California, Los Angeles` (brand_id 127756). This follows the established precedent for the UCLA account in this data set (QA-20318 etc.); no sub-brand was substituted. (Rule 1 note below.)
4. Date picker (`button.range-display`): START DATE → Jan 25, 2025, END DATE → Jan 25, 2025, **Ok**. URL `from=2025-01-25&to=2025-01-25`; header reads "Jan. 25, 2025 - Jan. 25, 2025".
5. Data Set dropdown → clicked **Impressions** (`table_data_set=impressions`).
6. Channels: enabled-state check before: all 6 enabled. Kept LinkedIn enabled, clicked off Facebook, X, Instagram, TikTok, Threads → only `linkedin enabled` (YouTube/Pinterest disabled-by-default). Clicked **Apply** → URL `channels=linkedin`, `Posts (1)`, no load failure.
7. Clicked **Table View** (`[title="Table View"]`) → `table.lfm-table` with Rank header rendered, Sum/Average toggle on **Sum**.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | No lock symbol displayed | No lock icon/element in the table or page: DOM query for `[class*=lock]`, `i.fa-lock`, `[title*=lock]`, `[data-icon*=lock]` returned only `i.fa-clock` (status-badge clock, outside the table, not a lock); table text has no "lock"/"locked"; screenshot `10-table-view.png` shows no lock on any column header/cell. | PASS |
| A2a | 5 | Reach = N/A on Sum row | Sum row `Reach` = **N/A** | PASS |
| A2b | 5 | Engagement Rate = N/A on Sum row | Sum row `Engagement Rate` = **N/A** | PASS |
| A2c | 5 | Organic Reach = N/A on Sum row | Sum row `Organic Reach` = **N/A** | PASS |
| A2d | 5 | Paid Reach = N/A on Sum row | Sum row `Paid Reach` = **N/A** | PASS |

## Evidence
Table headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate, Actions.

Sum row: Engagements 130 | Engagement Rate N/A | Impressions 10,337 | Organic Impressions 10,337 | Paid Impressions – | Reach N/A | Organic Reach N/A | Paid Reach N/A | Engaged User Rate N/A.

Only post (Rank 1): Sat Jan. 25, 2025 06:01 PM PST, University of California, Los Angeles, Video, Original Post, "Chancellor Frenk provides an update on current fires in the …"; Engagements 130, Engagement Rate 1.26%, Impressions 10,337, Organic Impressions 10,337, Paid Impressions –, Reach –, Organic Reach –, Paid Reach –, Engaged User Rate – (per-post values "–", so the aggregate Reach metrics show N/A).

Screenshots (`.playwright-out/QA-19468/`): 01-after-login, 02-brand-content, 03-brand-dropdown-click, 03-brand-typeahead, 04-brand-selected, 05-datepicker-open, 06-dates-picked, 07-impressions-selected, 08-channels-before-apply, 09-after-apply, 10-table-view.

## Known bugs checked
- Case file "Open linked bugs": none open. `knowledge-base/bug-history.md` and `known-quirks.md`: no QA-19468 entries (pre-fetched). No related bug reproduced or interfered with the assertions. The Facebook Posts Insights Disruption banner is unrelated to the LinkedIn selection.

## Notes
- Rule 1: the literal brand name "UCLA" does not exist in the brand typeahead on dev; the case's "UCLA" is the account, whose own brand is `University of California, Los Angeles`. Used that exact-name result (consistent with sibling cases). If the intent was a different brand, the case would need a data-clarification.
- Console showed many app errors (dev noise), none affecting the table.

## Bugs filed
None.
