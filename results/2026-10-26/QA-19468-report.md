# QA-19468 — LinkedIn Content - Impressions Table data set

**Verdict: PASS**

- Run: 2026-10-26, unattended headless (`claude -p`, Playwright MCP), dev `app.lfmdev.in`
- Test Set: QA-26183 "Daily Data Testing -2"
- Skills reused: `brand-content-grid-math` (data-set-before-channel, Table View scrape), `brand-content-data-set-selector` (Impressions lock/N-A pattern), `brand-content-native-post-check` (date picker), `switch-account` mechanics; helper libs `devprod-helpers.js`

## Open-bug screen (Rule 7)
Case file "Open linked bugs: None open" → screen passed, case executed.

## Steps executed
0. Logged in via Cognito "With existing account" (config/.env LFM_EMAIL). Precondition **account = UCLA**: profile menu → Search Account "UCLA" → real mouse click on exact result `UCLA` → `ACCOUNT: UCLA`, `account_id=799`. (First attempt right after login failed — page was not ready; retried from `#home` and it succeeded.)
1. Top nav: hovered **Brand** → clicked **Content** (`#explore/brand/content`, default brand `University of California, Los Angeles`, brand_id=127756).
2. Brand dropdown (chevron) → "Search for a Brand". Typed literal `UCLA` → 68 results, all sub-brands (UCLA Alumni, UCLA Bruins, UCLA Law, ... UCLA Volunteer Center); **no result named exactly "UCLA"**. The account's own brand is `University of California, Los Angeles`; typed `University of California, Los` and clicked the exact-name result (brand_id 127756; the only other hit was "...Los Angeles Police", not chosen). No sub-brand substituted. Dates: START DATE Jan 25, 2025 / END DATE Jan 25, 2025 → Ok; URL `from=2025-01-25&to=2025-01-25`; header "Jan. 25, 2025 - Jan. 25, 2025".
3. Data Set dropdown → clicked **Impressions** (`table_data_set=impressions`; trigger label "Impressions").
4. Channels: before = Facebook, X, Instagram, TikTok, LinkedIn, Threads all enabled (YouTube/Pinterest disabled). Kept LinkedIn, clicked off the other five, clicked **Apply** → URL `channels=linkedin`, `Posts (1)`.
5. Clicked **Table View** (`[title="Table View"]`) → visible `table.lfm-table` with `Rank` header; aggregate toggle on **Sum**.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | No lock symbol displayed | DOM query (`[class*=lock]`, `i.fa-lock`, `[data-icon*=lock]`, `[title*=lock i]`, `[aria-label*=lock i]`) returned only `i.fa-clock` (status badge, outside the table, not a lock). No lock/svg elements inside the table; table text contains no "lock". Screenshot `08-table-view.png` shows no lock on any visible header/cell. | PASS |
| A2a | 5 | Reach = N/A on Sum | Sum row `Reach` = **N/A** | PASS |
| A2b | 5 | Engagement Rate = N/A on Sum | Sum row `Engagement Rate` = **N/A** | PASS |
| A2c | 5 | Organic Reach = N/A on Sum | Sum row `Organic Reach` = **N/A** | PASS |
| A2d | 5 | Paid Reach = N/A on Sum | Sum row `Paid Reach` = **N/A** | PASS |

## Evidence
Table headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate, Actions.

Sum row: Engagements 130 | Engagement Rate N/A | Impressions 10,337 | Organic Impressions 10,337 | Paid Impressions – | Reach N/A | Organic Reach N/A | Paid Reach N/A | Engaged User Rate N/A.

Only post (Rank 1): Sat Jan. 25, 2025 06:01 PM PST, University of California, Los Angeles, Video, Original Post, "Chancellor Frenk provides an update on current fires in the region…"; Engagements 130, Engagement Rate 1.26%, Impressions 10,337, Organic 10,337, Paid –, Reach –, Organic Reach –, Paid Reach –, Engaged User Rate – (per-post "–" → aggregate N/A). Identical to the 2026-10-20 run.

Screenshots (`.playwright-out/QA-19468/`): 01-after-login, 02-brand-content, 02a-account-switch, 03-brand-typeahead, 03b-brand-typeahead, 04-brand-selected, 05-dates-set, 06-impressions-selected, 07-linkedin-applied, 08-table-view. Note: the 08 viewport crops the right-hand columns (Reach etc.); those values were read from the DOM scrape.

## Known bugs checked
- Case file "Open linked bugs": none. Pre-fetched grep of `bug-history.md` / `known-quirks.md`: no QA-19468 entries. The Facebook Data Collection Disruption banner (9/27) is unrelated to the LinkedIn selection; no related bug reproduced or interfered.

## Notes
- Rule 1: the literal brand "UCLA" does not exist in the dev brand typeahead; the case's "UCLA" is the account, whose own brand is `University of California, Los Angeles` (consistent with the 2026-10-20 run and sibling cases). If a different brand was intended, the case needs data clarification.
- Many console errors are dev-app noise (see `.playwright-out/console-*.log`), none affecting the table.

## Bugs filed
None.
