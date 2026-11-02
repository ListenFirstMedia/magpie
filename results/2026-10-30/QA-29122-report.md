# QA-29122 — Brand Content - Basic Data Set - Data Test (Twitter and Instagram)

- **Run date:** 2026-10-30 (Friday) — unattended headless, dev (`app.lfmdev.in`), user `lfiqa@listenfirstmedia.com`
- **Rotation row used:** Friday — accounts Hulu / Robinhood / PlayOn! Sports → brands **Hulu** (the Description table lists only "Hulu" in the Brand column; the Robinhood and PlayOn! Sports brand cells are blank). The case's Notes line "Fri Hulu/Ralph Lauren" contradicts the Description table (Ralph Lauren is a Thursday brand), so the Description table was followed.
- **Account / brand:** account switched to `HULU` (account_id=336) via profile → Search Account → `Results` entry; brand `Hulu` (brand_id=5670) picked from the brand typeahead and read back from `.brand-selector-name`.
- **Date range (default, not altered):** Oct. 22, 2026 – Oct. 28, 2026; perspective `extended` (Authorized); data set **Engagements Breakdown**
- **Skill:** `brand-content-grid-math` (Table View DOM scrape; identity evaluated in page JS for every post)

## Verdict: **PASS**

Hulu: Twitter 46/46 posts and Instagram 59/59 posts satisfy Reactions + Comments + Shares = Engagements. Sum rows reconcile as well.

## Steps executed
1. Hover **Brand** → click **Content** in the top nav (`navLink`).
2. Brand picker → typed `Hulu` → clicked the exact `Hulu` typeahead result (brand_id=5670).
3. Data set dropdown → **Engagements Breakdown**; clicked the Twitter ghost so Twitter was the only enabled channel; Apply; **Table View**.
4. Scraped every post row and evaluated Reactions + Comments + Shares vs Engagements.
5. Enabled Instagram, disabled Twitter (so the last-channel rule was not violated), Apply; Table View.
6. Scraped every post row and evaluated the same identity.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A4 | 4 (Twitter only) | Reactions + Comments + Shares = Engagements for each post | 46 posts, 46/46 match, 0 mismatches, none skipped. Sum row: Engagements 3,737 = Reactions 3,067 + Comments 157 + Shares 513 (3,737). Organic 3,736 + Paid "–" is within the ±1 rounding noted in the skill | PASS |
| A6 | 6 (Instagram only) | Reactions + Comments + Shares = Engagements for each post | 59 posts, 59/59 match, 0 mismatches, none skipped. Shares = "–" on all 59 (Instagram has no Shares, counted as 0, per skill). Sum row: Engagements 644,280 = Reactions 640,660 + Comments 3,620 (+ Shares "–") | PASS |

## Evidence
- Screenshots in `.playwright-out/QA-29122/`: `00-login.png`, `hulu-brand.png`, `hulu-twitter-setup.png`, `hulu-twitter-table.png`, `hulu-instagram-table.png`.
- URL confirmation (read back after the UI clicks, not set by URL): Twitter leg `channels=twitter&…&table_data_set=engagements_breakdown`; Instagram leg `channels=instagram&…&table_data_set=engagements_breakdown`. Brand column of every scraped row = `Hulu`.
- Samples: Twitter rank 1 = 509 + 9 + 111 = 629; rank 2 = 342 + 4 + 29 = 375; Instagram rank 1 = 78,181 + 497 + "–" = 78,678; rank 2 = 72,617 + 187 = 72,804.
- Post counts: Engagements Breakdown set showed 105 posts across the default channels; 46 with Twitter only; 59 with Instagram only.
- No render hang; each page rendered within the step budget.

## Known bugs checked
- Case file "Open linked bugs": none open, so the Rule 7 screen passed. `knowledge-base/bug-history.md`: no match for QA-29122. No known bug reproduced or interfered with the assertions.
- The known-quirks Wednesday NBCU gap and the Thursday "Spotify News" gap do not apply to the Friday Hulu leg.

## Bugs filed
- None (markdown-only).
- Note for the case author: the Friday row lists Robinhood and PlayOn! Sports accounts but no brands for them, so those accounts were not tested (no brand to select; none substituted per Rule 1). The Notes line "Fri Hulu/Ralph Lauren" is stale vs the Description table.
