# QA-79142 — Brand Content - Public Data Set - Aggregate - Video Response Rate

**Verdict: PASS** (3/3 assertions)

- Run: 2026-10-27 (Tuesday), unattended headless via Playwright MCP, env app.lfmdev.in (user lfiqa@listenfirstmedia.com)
- Weekday rotation: the Tuesday row of the Description table. Account **UCLA** (account_id=799), Brand **University of California, Los Angeles** (brand_id=127756). The first Tuesday entry was used, consistent with the prior runs (2026-10-20 first Tuesday entry; 2026-10-26 first Monday entry). Viacom/MTV and Wasserman/Gatorade were not run. Note: the case file's Notes line ("Tue UCLA/Sony Pictures") disagrees with the Description table; the table was followed.
- Date range: Oct 19 – Oct 25, 2026 (app default week), attribution window lifetime. View toggle left at its default (`perspective=extended`). The "public dataset" step was implemented as Data Set dropdown = **Public**, as in the prior runs.
- Skill used: `brand-content-grid-math` plus shared helpers `devprod-helpers.js`. No skill/REGISTRY edits (deferred to harvest.sh).

## Steps executed
1. Logged in via the Cognito "existing account" form. The account was switched to UCLA via the nav account search; the exact "UCLA" result was clicked and the header confirmed `ACCOUNT: UCLA` (`01-account.png`).
2. Hovered **Brand** in the top nav, clicked **Content** -> `#explore/brand/content`. The brand selector already showed the exact spec brand **University of California, Los Angeles** (Rule 1; no substitute).
3. Data Set dropdown -> explicitly selected **Public** (URL `table_data_set=public`; 150 posts across all channels, `02-brand-public.png`).
4. Filter -> **Content Type** -> **Video** -> **Apply** (URL `content_types … ["Video"]`). 48 video posts across all enabled channels (`03-video-selected.png`).
5. **Facebook only:** enabled Facebook, disabled all others, verified enabled = [facebook], URL `channels=facebook`. Posts (8). Table View; read the aggregate row in Sum mode, then clicked the Sum/Average toggle and read Average mode (`04-fb-table.png`).
6. **Twitter only:** URL `channels=twitter`, Posts (8); Sum and Average rows read (`05-twitter-table.png`).
7. **TikTok only:** URL `channels=tiktok`, Posts (7); Sum and Average rows read (`06-tiktok-table.png`).

## Assertions
Formula 1 (Engagements / Video Views) was usable on all three channels, so formula 2 was not needed as a fallback.

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 (Facebook only) | Sum Engagements / Sum Video Views = Average Video Response Rate | Sum Eng **2,326** / Sum VV **29,016** = 8.016% -> **8.02%**; Average row VRR = **8.02%** | PASS |
| A7 | 7 (Twitter only) | same | Sum Eng **463** / Sum VV **6,068** = 7.630% -> **7.63%**; Average row VRR = **7.63%** | PASS |
| A9 | 9 (TikTok only) | same | Sum Eng **1,283** / Sum VV **15,709** = 8.167% -> **8.17%**; Average row VRR = **8.17%** | PASS |

## Evidence
Aggregate rows as displayed (Table View, Content Type = Video, Public data set):

| Channel | Posts | Sum Engagements | Sum Video Views | Avg Engagements | Avg Video Views | Avg Video Response Rate | Eng/VV |
|---------|-------|-----------------|-----------------|-----------------|-----------------|-------------------------|--------|
| Facebook | 8 | 2,326 | 29,016 | 291 | 3,627 | 8.02% | 8.016% |
| Twitter | 8 | 463 | 6,068 | 58 | 758 | 7.63% | 7.630% |
| TikTok | 7 | 1,283 | 15,709 | 183 | 2,244 | 8.17% | 8.167% |

- The Sum row shows "N/A" for Video Response Rate. The Average row carries the rate. Each equals the aggregate Engagements/Video Views ratio, rounded to 2 decimals.
- Per-post cross-check: summing the Engagements and Video Views columns of the scraped rows reproduces the Sum row exactly on all three channels (FB 2,326 / 29,016; Twitter 463 / 6,068; TikTok 1,283 / 15,709).
- Informational only: the simple mean of the per-post Video Response Rate cells (formula 2) gives Facebook 6.196% (8 posts), Twitter 6.576% (8), TikTok 7.477% (7). The app's Average row follows formula 1 (aggregate ratio), not the mean of per-post rates. This is not a failure, since the spec says to use formula 2 only if formula 1 does not work.
- Console shows many dev API errors (pre-existing noise); none affected the rendered tables (`.playwright-out/console-2026-10-27T10-23-09-805Z.log`).

Screenshots (`.playwright-out/QA-79142/`): `01-account.png`, `02-brand-public.png`, `03-video-selected.png`, `04-fb-table.png`, `05-twitter-table.png`, `06-tiktok-table.png`.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed).
- bug-history.md / known-quirks.md: no entries for QA-79142 (pre-fetched). No related bug reproduced; no assertion interference.

## Bugs filed
None.
