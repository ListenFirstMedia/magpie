# QA-31513 — Brand Content > Data Test > FB > Reels Impressions

**Verdict: PASS**

- Run: 2026-10-20, headless/unattended (`claude -p`), Playwright MCP, env app.lfmdev.in
- Case file: `cases/QA-31513.md` (pre-ingested; no Jira fetch)
- Skill used: `brand-content-grid-math` (Table View DOM scrape, Sum/Average toggle)
- Open-bug screen (Rule 7): case file says "None open" -> ran normally.

## Steps executed

| # | Step | How performed | Result |
|---|------|---------------|--------|
| 0 | Login | Cognito "With existing account" form from config/.env | `#home` rendered |
| 0b | Precondition (Amazon Prime Video) | Active account was UCLA (typeahead for "Amazon Prime Video" returned nothing within UCLA). Switched via LFQA user menu -> Search Account -> exact result "Amazon Prime Video" (not "...India") | Header `ACCOUNT: AMAZON PRIME VIDEO`, `account_id=342` |
| 1 | Hover Brand in top nav -> Content | Hovered "Brand", clicked Content | `#explore/brand/content?brand_id=25864` |
| 2 | Add Amazon Prime Video brand | Opened brand dropdown, typed "Amazon Prime Video", clicked the exact-match typeahead option `.lfm-ta-option[title="Amazon Prime Video"]` (Rule 1) | Brand header = "Amazon Prime Video" (`brand_id=25864`) |
| 3 | Facebook only; 1 Jan 2025 - 10 Jan 2025 | Clicked off Twitter/Instagram/TikTok/LinkedIn/Threads ghosts, verified only `facebook enabled`, clicked Apply; opened date picker, START = Jan 01 2025, END = Jan 10 2025, Ok | URL `channels=facebook&from=2025-01-01&to=2025-01-10` |
| 4 | Impressions data set | Visible data-set dropdown -> "Impressions" | URL `table_data_set=impressions` |
| 5 | Filter "Publish Type: Reel" | Filter select -> Publish Type -> Reel -> Apply Filter | Chip "Publish Type: Reel / Include"; Posts (4) |
| 6 | Aggregate: Engagements / Impressions x 100 | Table View; Sum row Engagements 16,499, Impressions 1,546,300; toggled to Average row to read Engagement Rate | calc 1.0670% vs displayed 1.07% |
| 7 | Note aggregate Impressions | Sum row | **1,546,300** |
| 8 | Reels data set | Data-set dropdown -> "Reels" (Reel filter persisted, Posts (4)) | URL `table_data_set=reels` |
| 9 | Note aggregate Plays | Table View Sum row | **1,546,300** |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 | Reel posts have Impressions data | All 4 Reel posts have a numeric Impressions value: 746,373 / 257,737 / 509,388 / 32,802 (none "–"); Sum row 1,546,300 = sum of the four | PASS |
| A6 | 6 | 16,499 / 1,546,300 x 100 equals the Engagement Rate value | 16,499 / 1,546,300 x 100 = 1.0670%; aggregate Engagement Rate (Average row; Sum row shows N/A) = 1.07%; per-post checks also hold: 11,414/746,373 = 1.53%, 2,500/257,737 = 0.97%, 2,441/509,388 = 0.48%, 144/32,802 = 0.44% (all match displayed rates) | PASS |
| A9 | 9 | Impressions value equals Plays value | Impressions Sum 1,546,300 = Plays Sum 1,546,300; per-post Plays 746,373 / 257,737 / 509,388 / 32,802 match per-post Impressions exactly | PASS |

## Evidence

Screenshots in `.playwright-out/QA-31513/`:
- `04-brand-typeahead.png` (no match in UCLA), `06-account-search.png` (account switch results), `08-brand-typeahead-apv.png` (brand typeahead)
- `10-impressions-reel-filter.png` (filter chip, Posts (4), aggregate row)
- `11-impressions-table-aggregate.png` (Table View, Average row: Engagement Rate 1.07%)
- `12-reels-dataset.png`, `13-reels-table-sum.png` (Plays Sum 1,546,300)

Reels data set Sum row (Table View): Engagements 16,499, Reactions 14,905, Comments 814, Shares 780, Plays 1,546,300, Initial Plays 1,216,104, Reel Replays 330,196.

## Known bugs checked

- Case file "Open linked bugs": none. `bug-history.md` / `known-quirks.md` had no entry for QA-31513 (pre-fetched).
- No known bug reproduced or interfered with the assertions.
- Context: "Facebook Posts Insights Disruption" banner was visible on the page; it did not affect the Reel posts in this window (all had full Impressions values).

## Observations (not assertion failures, not filed)

- Reel #4 (Jan 07 11:00 AM) shows Reach 36,520 > Impressions/Plays 32,802 and Follows = -11 in the Reels data set. Neither value is covered by this case's assertions; noted only.
- Aggregate Engagement Rate in the Average row (1.07%) equals total engagements / total impressions, not the mean of per-post rates (0.86%).
- Execution note: one mis-targeted click on a post author link opened an x.com tab; it was closed immediately and had no effect on the test.
- Brand search is scoped to the active account; the precondition account had to be switched first.

## Bugs filed

None.
