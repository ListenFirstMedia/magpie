# QA-31513 — Brand Content > Data Test > FB > Reels Impressions

**Verdict: PASS**

- Run: 2026-10-30, headless/unattended (`claude -p`), Playwright MCP, env app.lfmdev.in
- Case file: `cases/QA-31513.md` (pre-ingested; no Jira fetch)
- Skill used: `brand-content-grid-math` (Table View DOM scrape, Sum/Average toggle) + date-picker mechanics from `brand-content-native-post-check`
- Open-bug screen (Rule 7): case file says "None open" -> ran normally.

## Steps executed

| # | Step | How performed | Result |
|---|------|---------------|--------|
| 0 | Login | Cognito "With existing account" form, creds from config/.env | App loaded; account was UCLA |
| 0b | Precondition (Amazon Prime Video) | LFQA menu -> Search Account -> typed "Amazon Prime Video" -> clicked the exact result "Amazon Prime Video" (not "...India") | Header `ACCOUNT: AMAZON PRIME VIDEO`, `account_id=342` |
| 1 | Hover Brand in top nav -> Content | Hovered "Brand", clicked Content | `#explore/brand/content`, brand_id=25864 |
| 2 | Add Amazon Prime Video brand | Opened brand selector, typed "Amazon Prime Video" into the `Search for a Brand` textarea, clicked exact-match `.lfm-ta-option[title="Amazon Prime Video"]` (Rule 1; first of 60+ similarly named results) | Brand header "Amazon Prime Video", `brand_id=25864` |
| 3 | Facebook only; 1 Jan 2025 - 10 Jan 2025 | Clicked off Twitter/Instagram/TikTok/LinkedIn/Threads ghosts, verified only `facebook enabled`, clicked Apply; opened date picker, START = Jan 01 2025, END = Jan 10 2025 (field text verified), Ok | URL `channels=facebook&from=2025-01-01&to=2025-01-10` |
| 4 | Impressions data set | Visible data-set dropdown -> "Impressions" | URL `table_data_set=impressions` |
| 5 | Filter "Publish Type: Reel" | Filter Select -> Publish Type -> Reel -> Apply Filter | URL filter `content_post_class` = `reel`; Posts (4) |
| 6 | Engagements / Impressions x 100 | Table View; Sum row Engagements 16,499, Impressions 1,546,300; toggled to Average row to read Engagement Rate | calc 1.0670% vs displayed 1.07% |
| 7 | Note aggregate Impressions | Sum row | **1,546,300** |
| 8 | Reels data set | Data-set dropdown -> "Reels" (Reel filter persisted, Posts (4)) | URL `table_data_set=reels` |
| 9 | Note aggregate Plays | Table View; aggregate toggle was still on Average (Plays 386,575 = 1,546,300 / 4), toggled back to Sum | Plays Sum **1,546,300** |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 | Reel posts have Impressions data | All 4 Reel posts have a numeric Impressions value: 746,373 / 257,737 / 509,388 / 32,802 (none "–"); sum of the four = 1,546,300 = Sum row | PASS |
| A6 | 6 | 16,499 / 1,546,300 x 100 equals the Engagement Rate value | 16,499 / 1,546,300 x 100 = 1.0670%; aggregate Engagement Rate (Average row; Sum row shows N/A) = 1.07%. Per-post rates also match: 11,414/746,373 = 1.53%, 2,500/257,737 = 0.97%, 2,441/509,388 = 0.48%, 144/32,802 = 0.44% | PASS |
| A9 | 9 | Impressions value equals Plays value | Impressions Sum 1,546,300 = Plays Sum 1,546,300; per-post Plays 746,373 / 257,737 / 509,388 / 32,802 match per-post Impressions exactly | PASS |

## Evidence

Screenshots in `.playwright-out/QA-31513/` (this run):
- `01-user-menu.png`, `02-account-search.png` (account switch; both "Amazon Prime Video" and "...India" listed, exact one chosen)
- `03-brand-content.png`, `04-brand-dropdown.png`, `05-date-picker.png`
- `10-impressions-reel-sum.png` (Impressions, Reel filter, Sum row)
- `11-impressions-average.png` (Average row, Engagement Rate 1.07%)
- `12-reels-plays-sum.png` (Reels data set, Plays Sum)

Reels data set Sum row: Engagements 16,499, Reactions 14,905, Comments 814, Shares 780, Plays 1,546,300, Initial Plays 1,216,104, Reel Replays 330,196, Follows 439.

## Known bugs checked

- Case file "Open linked bugs": none. `bug-history.md` / `known-quirks.md` had no entry for QA-31513 (pre-fetched).
- No known bug reproduced or interfered with the assertions.
- A "Facebook Data Collection Disruption 9/27" banner was visible; it did not affect the Reel posts in this window (all had full Impressions values).

## Observations (not assertion failures, not filed)

- Reel #4 (Jan 07 11:00 AM) shows Reach 36,520 > Impressions/Plays 32,802 and Follows = -11 in the Reels data set. Neither is covered by this case's assertions.
- Aggregate Engagement Rate (1.07%) equals total engagements / total impressions, not the mean of per-post rates.
- The aggregate Sum/Average toggle persists across data-set changes; after switching to Reels it was still on Average, so Plays read 386,575 until toggled back to Sum.
- The brand search box is a `textarea[placeholder="Search for a Brand"]`, not an `input`.

## Bugs filed

None.
