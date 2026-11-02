# QA-31513 — Brand Content > Data Test > FB > Reels Impressions

**Verdict: PASS**

- Run: 2026-10-27 (Tuesday), headless/unattended (`claude -p`), Playwright MCP, env app.lfmdev.in
- Case file: `cases/QA-31513.md` (pre-ingested; no Jira fetch)
- Skill used: `brand-content-grid-math` (Table View DOM scrape, Sum/Average toggle) + `_shared/playwright-helpers` (`devprod-helpers.js`; dev tab only, prod tab unused)
- Open-bug screen (Rule 7): case file "Open linked bugs" = None open -> ran normally.

## Steps executed

| # | Step | How performed | Result |
|---|------|---------------|--------|
| 0 | Login | Cognito "With existing account" from config/.env (dev session bounced to sign-in once; re-logged in) | `#home`, initial account SEPHORA |
| 0b | Precondition (Amazon Prime Video account) | Brand typeahead on Sephora returned no options for "Amazon Prime Video" (brand search is account-scoped). Switched via user menu -> Search Account -> "Amazon Prime Video" (real mouse click on `.lfm-ta-option`). The page spent ~2 min on "Loading..." after the switch, then rendered | Header `ACCOUNT: AMAZON PRIME VIDEO`, `account_id=342` |
| 1 | Hover Brand in top nav -> Content | Hovered "Brand", clicked "Content" | `#explore/brand/content`, 235 posts in the default week |
| 2 | Add Amazon Prime Video brand | Opened brand selector, typed "Amazon Prime Video", clicked the exact first typeahead result (Rule 1; the list also contained "(Australia)", "(Belgium)", "(Canada)" ... variants, none used) | Brand header "Amazon Prime Video", `brand_id=25864` |
| 4 (done before 3, per skill: data set before channel) | Impressions data set | Visible data-set dropdown -> "Impressions" | `table_data_set=impressions` |
| 3 | Facebook only; 1 Jan 2025 - 10 Jan 2025 | Enabled facebook ghost, disabled all others, verified `enabled: [facebook]`, Apply (Posts 65). Date picker START = Jan 01, 2025, END = Jan 10, 2025, Ok | `channels=facebook&from=2025-01-01&to=2025-01-10` |
| 5 | Filter "Publish Type: Reel" | Filter select -> Publish Type -> Reel -> Apply Filter | Chip "Publish Type: Reel"; URL `content_post_class: reel`; Posts (4) |
| 6 | Engagements / Impressions x 100 | Table View, Sum row; toggled to Average row to read Engagement Rate, toggled back | see A6 |
| 7 | Note aggregate Impressions | Sum row | **1,546,300** |
| 8 | Reels data set | Dropdown -> "Reels" (Reel filter persisted, Posts (4)) | `table_data_set=reels` |
| 9 | Note aggregate Plays | Table View Sum row | **1,546,300** |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 | Reel posts have Impressions data | All 4 Reel posts have a numeric Impressions value: 746,373 / 257,737 / 509,388 / 32,802 (none "–"); Sum row 1,546,300 = 746,373 + 257,737 + 509,388 + 32,802 | PASS |
| A6 | 6 | Engagements / Impressions x 100 equals the Engagement Rate value | 16,499 / 1,546,300 x 100 = 1.0670%; displayed aggregate Engagement Rate (Average row; Sum row shows N/A) = 1.07%. Per-post: 11,414/746,373 = 1.53% (shown 1.53%), 2,500/257,737 = 0.97% (0.97%), 2,441/509,388 = 0.48% (0.48%), 144/32,802 = 0.44% (0.44%) | PASS |
| A9 | 9 | Impressions value equals Plays value | Impressions Sum 1,546,300 = Plays Sum 1,546,300; per-post Plays 746,373 / 257,737 / 509,388 / 32,802 match per-post Impressions exactly | PASS |

## Evidence

Screenshots in `.playwright-out/QA-31513/`:
- `02-stuck-loading.png` (post-account-switch "Loading..." that cleared on its own)
- `04-brand-typeahead-pick.png` (exact-match brand result), `05-fb-dates-impressions.png` (Facebook only, Jan 01-10 2025, Impressions)
- `06-publish-type-options.png`, `07-reel-filter-applied.png` (chip + Posts (4))
- `08-impressions-sum-row.png`, `09-impressions-average-row.png` (Engagement Rate 1.07%)
- `10-reels-dataset-sum.png` (Plays Sum 1,546,300)

Impressions data set, Sum row: Engagements 16,499, Impressions 1,546,300, Organic/Paid Impressions "–", Reach N/A, Engagement Rate N/A.
Reels data set, Sum row: Engagements 16,499, Reactions 14,905, Comments 814, Shares 780, Plays 1,546,300, Initial Plays 1,216,104, Reel Replays 330,196, Follows 439.

## Known bugs checked

- Case file "Open linked bugs": none. `bug-history.md` / `known-quirks.md` had no entry for QA-31513 (pre-fetched).
- No known bug reproduced or interfered with the assertions.

## Observations (not assertion failures, not filed)

- Result is identical to the 2026-10-20 run (same 4 posts, same sums), so the Jan 2025 data is stable.
- Reel #4 (Jan 07 11:00 AM) shows Reach 36,520 > Impressions/Plays 32,802. Not covered by this case's assertions.
- The aggregate Engagement Rate (1.07%) equals total engagements / total impressions, not the mean of the per-post rates. The Average row shows Engagements 4,125 and Impressions 386,575 (per-post means).
- Dev infra: the dev session redirected to sign-in once at start, and the post-account-switch page stayed on "Loading..." for ~2 min. Both recovered (re-login / waiting) with no effect on results.
- Brand search is scoped to the active account, so the Amazon Prime Video account had to be switched to first.

## Bugs filed

None.
