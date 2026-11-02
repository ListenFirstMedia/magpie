# QA-29278 — Brand Content - Impressions Dataset - Data Test - TikTok

**Date:** 2026-10-27 (Tuesday)
**Mode:** unattended / headless (`claude -p`), Playwright MCP
**Verdict: PASS**

## Setup / account choice

- Login: Cognito "With existing account" using `config/.env` (lfiqa@listenfirstmedia.com); landed on `#home` with `account_id=799`.
- Weekday rotation (Tuesday row of the Description table): Account 1 = **UCLA**, Brand 1 = **University of California, Los Angeles**. The first pair of the row was used; Viacom/MTV and Wasserman/Gatorade were not run. The case Notes line ("Tue UCLA/Sony Pictures") disagrees with the table, so the table was treated as authoritative (same call as the 2026-10-20 run).
- The login session already opened on UCLA; the breadcrumb was read and confirmed `ACCOUNT: UCLA` (account_id=799), so no account switch was needed.
- Date range: Oct. 19, 2026 - Oct. 25, 2026 (app default, last full week). View: Authorized data (`perspective=extended`, app default; the spec sets no perspective).

## Steps executed

1. Hovered the **Brand** top-nav menu and clicked **Content** (`#explore/brand/content`). Done.
2. Opened the brand selector and typed "University of California, Los Angeles". Results showed the exact match plus "University of California, Los Angeles Police"; clicked the exact match (brand_id=127756). Opened the visible Data Set dropdown and selected **Impressions** (URL `table_data_set=impressions`). Done.
3. Clicked off Facebook, X, Instagram, LinkedIn and Threads one at a time; TikTok stayed enabled. Verified by DOM that `.channel-ghost.tiktok` is `enabled` and facebook/twitter/instagram/linkedin/threads are `disabled` (YouTube/Pinterest were already disabled), clicked **Apply**. URL `channels=tiktok`, grid shows **Posts (9)**. Done.
4. Reviewed Total / Organic / Paid Impressions on every post. Values were scraped from Table View (one row per grid post, plus the Sum/Average aggregate row). Done.

## Assertions

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| A1 | 4 | Total Impressions displays a value on every post | All 9 TikTok posts show a number: 3,131 / 2,819 / 2,777 / 1,782 / 1,794 / 1,839 / 1,439 / 1,910 / 928. Their sum is 18,419, which equals the Sum row (18,419). | PASS |
| A2 | 4 | Organic Impressions and Paid Impressions are en-dash on every post | All 9 posts show "–" for both Organic Impressions and Paid Impressions. The Sum row also shows "–" for both. | PASS |

Every one of the 9 rows carries the `fa-tiktok` channel icon, so no other channel leaked into the set.

## Evidence

- `.playwright-out/QA-29278/01-content-landing.png` — Brand > Content landing, UCLA account.
- `.playwright-out/QA-29278/02-brand-dropdown.png` — brand typeahead open; Results: "University of California, Los Angeles", "University of California, Los Angeles Police".
- `.playwright-out/QA-29278/03-impressions-selected.png` — Impressions data set selected, all channels still enabled.
- `.playwright-out/QA-29278/04-tiktok-impressions-grid.png` — TikTok only, Posts (9), grid layout.
- `.playwright-out/QA-29278/05-tiktok-impressions-table.png` — Table View.
- DOM scrape of `table.lfm-table` (Rank header): 10 rows (Sum/Average + 9 posts). Columns read: Impressions, OrganicImpressions, PaidImpressions. Sum row: Impressions 18,419, Organic –, Paid –.

## Known bugs checked

- Case file "Open linked bugs": none open (Rule 7 screen passed).
- `knowledge-base/bug-history.md`: no QA-29278 match (pre-fetched). `known-quirks.md` has an entry noting 67/126 TikTok posts with "–" Total Impressions in a different account's wider run (APPS-60871 family); that did not reproduce here, since all 9 UCLA posts have a Total.
- Skill lookup: `brand-content-grid-math` (Table View scrape, data-set-before-channel ordering, last-channel rule) was used for the mechanics.
- No known bug interfered with the assertions.

## Bugs filed

None.

## Notes

- Not run: the other Tuesday account/brand pairs (Viacom/MTV, Wasserman/Gatorade); the case defines "Add a Brand" per day without requiring all three in one execution.
- Reach, Organic Reach and Paid Reach also show "–" on every post (Sum row N/A); outside this case's assertions.
- Brand search box is a `<textarea placeholder="Search for a Brand">` opened by clicking `.brand-selector-name`; Results rows are `.option-label`. Skill maintenance is deferred to harvest.sh.
