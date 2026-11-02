# QA-29278 — Brand Content - Impressions Dataset - Data Test - TikTok

**Date:** 2026-10-26 (Monday)
**Mode:** unattended / headless (`claude -p`), Playwright MCP
**Verdict: FAIL** — A1 fails (67 of 126 TikTok posts show an en-dash for Total Impressions). A2 passes.

## Setup / account choice

- Login: Cognito "With existing account" using `config/.env` (lfiqa@listenfirstmedia.com). The first `app.lfmdev.in` load sat on "Loading..." for over 2 minutes; a second navigation to `/#home` redirected to the hosted UI, and login landed on `#home`.
- Weekday rotation (Monday row of the case Description table): Account 1 = **HBO Max**, Brand 1 = **HBO Max**. The row also lists Amazon Prime Video / Vogue-US, and Conde Nast. The case Notes line ("Mon HBO Max/Viacom") does not match the table, so the table was treated as authoritative and the first pair was used (same convention as the 2026-10-20 run). Amazon Prime Video and Conde Nast/Vogue-US were not run.
- Account switch: LFQA menu > Search Account > Results row `HBO Max`. Breadcrumb confirmed `ACCOUNT: HBO MAX` (account_id=657).
- Date range: Oct. 18, 2026 – Oct. 24, 2026 (app default). View: Authorized data (app default; the spec sets no perspective). Data Last Updated (PT): 10-25-2026 04:46 PM.

## Steps executed

1. Hovered **Brand** in the top nav and clicked **Content** (`#explore/brand/content`). Done.
2. Opened the brand typeahead, typed "HBO Max", clicked the exact "HBO Max" result (brand_id=155614). Opened the Data Set dropdown and selected **Impressions** (URL `table_data_set=impressions`). Done.
3. Clicked the channel ghosts so that only **TikTok** is enabled (confirmed `.channel-ghost.tiktok.enabled` and all others disabled), then clicked **Apply**. URL `channels=tiktok`; grid shows **Posts (126)**. Done.
4. Reviewed Total / Organic / Paid Impressions on every post. Table View has one row per grid post, so all 126 rows were scraped from the DOM. Grid View was also screenshotted for the aggregate row and the lower tiles. Done.

## Assertions

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| A1 | 4 | Total Impressions displays a value on every grid post | 59 of 126 posts show a number (ranks 1–58 and 76). **67 of 126 posts (ranks 59–75 and 77–126) show "–"** for Total Impressions. The 59 numbers sum to 46,411,992, which equals the aggregate Sum row (46,411,992). | **FAIL** |
| A2 | 4 | Organic Impressions and Paid Impressions are en-dash on every post | All 126 posts show "–" for both Organic Impressions and Paid Impressions. The aggregate row also shows "–" for both. 0 exceptions. | PASS |

All 126 rows carry the `fa-tiktok` channel icon, so no other channel leaked into the set.

## Evidence

- `.playwright-out/QA-29278/20261026-01-content-landing.png` — Brand > Content landing on HBO Max.
- `.playwright-out/QA-29278/20261026-02-brand-set.png` — brand set to HBO Max.
- `.playwright-out/QA-29278/20261026-03-tiktok-impressions-grid.png` — Impressions data set, TikTok only, Posts (126).
- `.playwright-out/QA-29278/20261026-04-tiktok-impressions-table.png` — Table View.
- `.playwright-out/QA-29278/20261026-05-grid-top.png` — Grid View: aggregate Impressions 46,411,992, Organic Impressions "–", Paid Impressions "–".
- `.playwright-out/QA-29278/20261026-06-grid-lower-posts.png` — Grid View bottom: tiles with `Impressions –`, `Organic –`, `Paid –`; rank 126 (Fri Oct. 23, 2026 11:00 AM PDT) shows Engagements 0, Engagement Rate –, Impressions –.
- Table scrape (Table View header: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, ...):
  - Rows with a Total Impressions number: 59. Examples: rank 1 = 9,117,452; rank 2 = 748,357; rank 3 = 2,014,611; rank 4 = 1,299,061; rank 5 = 491,640; rank 58 = 6,904; rank 76 = 4,280.
  - Rows with "–" for Total Impressions: 67, spread across posts dated Oct. 18 (8), Oct. 19 (4), Oct. 20 (5), Oct. 22 (38), Oct. 23 (12).
  - Every one of the 67 also has Engagements 0 and Reach "–". None carries any metric, so they look like posts with no collected metrics. Rank 76 is the only 0-engagement post that has Impressions (4,280), so zero engagement alone does not explain the dash.
  - No data-collection banner is visible for TikTok. The only banner is "Facebook Data Collection Disruption 9/27", which concerns Facebook, not this TikTok-only case.
  - Aggregate Sum row: Impressions 46,411,992; Organic Impressions –; Paid Impressions –.

## Known bugs checked

- Case file "Open linked bugs": none open (Rule 7 screen passed).
- `knowledge-base/bug-history.md`: no QA-29278 matches (pre-fetched). `knowledge-base/known-quirks.md`: no QA-29278 match, and a TikTok keyword grep found no entry covering missing TikTok Total Impressions on posts.
- Skill lookup: no skill matched by test ID or flow keyword. The case Notes point to `brand-content-grid-math`, which was used for the Data Set, channel and Table View mechanics. `switch-account` mechanics were used for the account switch (via `_shared/playwright-helpers/devprod-helpers.js`).
- No known bug was attributed to the A1 failure.

## Bugs filed

None filed in Jira (markdown-only). Candidate for triage: on dev, Brand > Content > Impressions data set, TikTok only, HBO Max, Oct. 18–24 2026, 67 of 126 TikTok posts have Total Impressions "–" (and Engagements 0, Reach "–"), contrary to the spec expectation that Total Impressions always shows a value.

## Notes

- Judgment call: the spec asks for Total Impressions to "display a value" on each grid post. The 67 en-dash posts could be posts whose metrics were not collected, but the spec makes no exception for that, and a number appears on the other 59 posts. The case is therefore failed rather than passed with a caveat. The 2026-10-20 run on UCLA (11 posts, all with values) passed, so this looks specific to HBO Max's TikTok data.
- Not run: Amazon Prime Video and Conde Nast / Vogue-US (rest of the Monday row). A re-run on them would show whether the missing Total Impressions is HBO Max-specific.
- Skill and registry maintenance is deferred to harvest.sh.
