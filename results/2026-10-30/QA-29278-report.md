# QA-29278 — Brand Content - Impressions Dataset - Data Test - TikTok

**Date:** 2026-10-30 (Friday)
**Mode:** unattended / headless (`claude -p`), Playwright MCP, dev (`app.lfmdev.in`)
**Verdict: PASS** — Hulu / Hulu (Friday row), Impressions data set, TikTok only: all 48 posts show a Total Impressions value and en-dash for Organic and Paid Impressions.

## Setup

- Login: Cognito "With existing account" with `config/.env` (lfiqa@listenfirstmedia.com); landed on `#home`.
- Rotation: Friday row of the Description table = Account **Hulu**, Brand **Hulu**. Robinhood and PlayOn! Sports are listed as accounts but have no Brand 1 value in the table, so no brand could be tested for them without inventing one (Rule 1). They were not run. The "Also use Amazon Prime Video on alternative days" note was not applied.
- The Notes line in the case file ("Fri Hulu/Ralph Lauren") disagrees with the Description table. The Description table was followed.
- Date range: Oct. 22, 2026 - Oct. 28, 2026 (app default). Perspective: `extended` (Authorized data), the default. The spec sets no perspective.

## Steps executed

1. Switched account via the account menu search: typed "Hulu", clicked the exact "Hulu" result. Breadcrumb `ACCOUNT: HULU` (account_id=336). Hovered **Brand** > **Content** (`#explore/brand/content`). Default brand was already "Hulu" (brand_id=5670).
2. Opened the brand selector and typed "Hulu". Clicked the exact "Hulu" result (Rule 1); header "Hulu", brand_id=5670. Opened the visible Data Set dropdown and selected **Impressions** (URL `table_data_set=impressions`).
3. Enabled TikTok and disabled Facebook, X, Instagram, LinkedIn and Threads, then clicked **Apply**. DOM check: only `tiktok` enabled, URL `channels=tiktok`. `Posts (48)`.
4. Reviewed Total / Organic / Paid Impressions for every post. Scraped all 48 posts from Table View (skill `brand-content-grid-math`) and cross-checked the Grid View (layout toggle) header and aggregate row.

## Assertions

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| A1 | 4 | Total Impressions displays a value on every post | 48 of 48 posts show a numeric Impressions value (e.g. 3,000,000; 1,700,000; 7,800,000; 357,200). 0 posts show "–". | PASS |
| A2 | 4 | Organic Impressions and Paid Impressions are en-dash on every post | 48 of 48 posts have Organic Impressions "–" and Paid Impressions "–". 0 posts have a value. Distribution: `value\|–\|–` x 48. | PASS |

## Evidence

- Aggregate row (Table View and Grid View header): Sum Impressions 14,518,051, Organic "–", Paid "–". Average Impressions 302,459, Organic "–", Paid "–". Sum of the 48 per-post Impressions = 14,518,051, so it matches the displayed Sum exactly.
- Table View headers include Impressions, Organic Impressions, Paid Impressions. Every row's Brand = Hulu. Row count 48 = `Posts (48)`.
- Screenshots in `.playwright-out/QA-29278/`: `20-hulu-content-landing.png`, `21-brand-hulu-selected.png`, `22-impressions-selected.png`, `23-tiktok-only.png`, `24-table-view.png`, `25-grid-view.png` (Grid View with TikTok enabled and the Sum/Average row showing "–" for Organic and Paid Impressions).
- Console: only pre-existing dev errors (`.playwright-out/console-2026-10-30T06-41-33-892Z.log`), none tied to the content load. No "failed to load" or render hang occurred.

## Known bugs checked

- Case file "Open linked bugs": none open (Rule 7 screen passed).
- `bug-history.md`: no QA-29278 match (pre-fetched).
- `known-quirks.md` (pre-fetched): TikTok "–" Total Impressions was reproduced on HBO Max 10-26 and Apple Music 10-28. It did not reproduce on Hulu today: every post has a Total value. No bug interfered with the assertions.
- Hulu brand_id 5670 did not redirect to 11003 on this run (URL stayed `brand_id=5670`).

## Bugs filed

None.
