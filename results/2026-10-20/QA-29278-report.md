# QA-29278 — Brand Content - Impressions Dataset - Data Test - TikTok

**Date:** 2026-10-20 (Tuesday)
**Mode:** unattended / headless (`claude -p`), Playwright MCP
**Verdict: PASS**

## Setup / account choice

- Login: Cognito "With existing account" using `config/.env` (lfiqa@listenfirstmedia.com), landed on `#home` (account_id=54).
- Weekday rotation (Tuesday row of the case Description table): Account 1 = **UCLA**, Brand 1 = **University of California, Los Angeles**. The table lists UCLA / Viacom / Wasserman with brands University of California, Los Angeles / MTV / Gatorade; the first pair was used. The case's Notes line ("Tue UCLA/Sony Pictures") does not match the table, so the table was treated as authoritative. Viacom/MTV and Wasserman/Gatorade were not run.
- The Description panel has no per-day credentials, so the single `config/.env` login was used with an account switch (LFQA menu hover > Search Account > Results row `UCLA`). Breadcrumb confirmed `ACCOUNT: UCLA` (account_id=799).

## Steps executed

1. Hovered the Brand top-nav menu and clicked **Content** (`#explore/brand/content`). Done.
2. Opened the brand typeahead and typed "University of California, Los Angeles". The Results list showed the exact match (plus "University of California, Los Angeles Police"); clicked the exact match (brand_id=127756, it was already the default brand). Opened the Data Set dropdown, selected **Impressions** (URL `table_data_set=impressions`). Done.
3. Clicked off Facebook, X, Instagram, LinkedIn and Threads one at a time; TikTok stayed enabled. Verified `.channel-ghost.tiktok.enabled` with all others `disabled`, clicked **Apply**. URL `channels=tiktok`, grid shows **Posts (11)**. Done.
4. Reviewed Total / Organic / Paid Impressions on every post. The default layout is Grid (middle layout icon active); values were scraped from Table View, which has one row per grid post, with the aggregate row also confirmed in grid view. Done.

Date range: Oct. 12, 2026 - Oct. 18, 2026 (app default). View: Authorized data (app default; the spec sets no perspective).

## Assertions

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| A1 | 4 | Total Impressions displays a value on every post | All 11 TikTok posts show a number: 1,943 / 1,488 / 2,036 / 1,384 / 1,664 / 1,544 / 1,454 / 1,227 / 1,274 / 1,163 / 774. Their sum is 15,951, which equals the Sum row (15,951); Average 1,450. | PASS |
| A2 | 4 | Organic Impressions and Paid Impressions are en-dash on every post | All 11 posts show "–" for both Organic Impressions and Paid Impressions. The Sum and Average rows also show "–" for both. | PASS |

Each of the 11 rows carries the `fa-tiktok` channel icon, so no other channel leaked into the set.

## Evidence

- `.playwright-out/QA-29278/01-content-landing.png` — Brand > Content landing, breadcrumb `ACCOUNT: UCLA`.
- `.playwright-out/QA-29278/02-brand-dropdown.png` — brand typeahead open.
- `.playwright-out/QA-29278/03-tiktok-impressions-grid.png` — Data Set Impressions, TikTok only, Posts (11); aggregate row Impressions 15,951, Organic Impressions –, Paid Impressions –.
- `.playwright-out/QA-29278/04-tiktok-impressions-table.png` — Table View.
- DOM scrape of `table.lfm-table` (Rank header): 12 rows (Sum/Average + 11 posts); Impressions values as listed in A1.

## Known bugs checked

- Case file "Open linked bugs": none open (Rule 7 screen passed).
- `knowledge-base/bug-history.md` and `known-quirks.md`: no QA-29278 matches (pre-fetched shell-side).
- Skill lookup: no skill matched the registry by test ID. `brand-content-grid-math` (the case Notes' pointer) was used for the Data Set / channel / Table View mechanics, and `switch-account` for the account switch.
- No known bug interfered with the assertions. The Facebook Posts Insights Disruption banner on the page concerns Facebook, which is not part of this TikTok-only case.

## Bugs filed

None.

## Notes

- Not run: the other Tuesday account/brand pairs (Viacom/MTV, Wasserman/Gatorade). The case text defines "Add a Brand" per day without saying all three should be run in one execution, and the Notes line mentions "also use Amazon Prime Video on alternate days" (not applicable on Tuesday per the table).
- The brand search box is a `<textarea placeholder="Search for a Brand">`, not an `<input>`; Results rows are `.option-label` elements. Skill maintenance is deferred to harvest.sh.
