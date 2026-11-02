# QA-79142 — Brand Content - Public Data Set - Aggregate - Video Response Rate

**Verdict: PASS** (3/3 assertions)

- Run: 2026-10-28 (Wednesday), unattended headless via Playwright MCP, env app.lfmdev.in (user lfiqa@listenfirstmedia.com)
- Weekday rotation: the Wednesday row of the Description table. Account **Apple Services** (account_id=409), Brand **Apple Music** (brand_id=31783). First Wednesday entry used, consistent with prior runs (10-20, 10-26, 10-27). NBCU Enterprises / CNBC / NBC News were not run. The case file's Notes line ("Wed Apple Services/Wasserman") disagrees with the Description table; the table was followed.
- Date range: Oct 20 – Oct 26, 2026 (app default week), attribution window lifetime. View toggle left at its default (`perspective=extended`). The "public dataset" step was implemented as Data Set dropdown = **Public**, as in prior runs.
- Skill used: `brand-content-grid-math` plus shared helpers `devprod-helpers.js`. No skill/REGISTRY edits (deferred to harvest.sh).
- Rule 7 screen: case file "Open linked bugs" = None open, so the case was run.

## Steps executed
1. Logged in via the Cognito "existing account" form. The session landed on `ACCOUNT: APPLE SERVICES`, the spec's Wednesday account (no switch needed).
2. Hovered **Brand** in the top nav, clicked **Content** -> `#explore/brand/content`. The brand selector showed the exact spec brand **Apple Music** (Rule 1; no substitute). Data Set dropdown explicitly set to **Public** (URL `table_data_set=public`; 60 posts across all channels) (`01-brand.png`, `02-filter-open.png`).
3. Filter -> **Content Type** -> **Video** -> **Apply**. URL carries `content_types ... ["Video"]`; 43 video posts across all enabled channels (`03a-video-checked.png`).
4. **Facebook only:** clicked the Facebook channel ghost, disabled all others, verified enabled = [facebook], URL `channels=facebook`. Posts (5).
5. Table View. Read the aggregate row in Sum mode, then clicked the Sum/Average toggle and read Average mode (`04-fb-table-sum.png`, `04b-fb-table-avg.png`).
6. **Twitter only:** enabled = [twitter], URL `channels=twitter`. Posts (3), confirmed stable (no Loading, no error banner).
7. Sum and Average rows read (`05-twitter-table-modeA.png`, `05b-twitter-table-modeB.png`).
8. **TikTok only:** enabled = [tiktok], URL `channels=tiktok`. Posts (20). Rendered on the first attempt, with no render-hang and no reload needed.
9. Sum and Average rows read (`06-tiktok-table-modeA.png`, `06b-tiktok-table-modeB.png`).

## Assertions
Formula 1 (Engagements / Video Views) was usable on all three channels, so formula 2 was not needed as a fallback.

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 (Facebook only) | Sum Engagements / Sum Video Views = Average Video Response Rate | Sum Eng **26,305** / Sum VV **527,449** = 4.987% -> **4.99%**; Average row VRR = **4.99%** | PASS |
| A7 | 7 (Twitter only) | same | Sum Eng **61,478** / Sum VV **5,774,627** = 1.0646% -> **1.06%**; Average row VRR = **1.06%** | PASS |
| A9 | 9 (TikTok only) | same | Sum Eng **229,285** / Sum VV **1,851,970** = 12.381% -> **12.38%**; Average row VRR = **12.38%** | PASS |

## Evidence
Aggregate rows as displayed (Table View, Content Type = Video, Public data set, Oct 20 – Oct 26):

| Channel | Posts | Sum Engagements | Sum Video Views | Avg Engagements | Avg Video Views | Avg Video Response Rate | Sum Eng / Sum VV |
|---------|-------|-----------------|-----------------|-----------------|-----------------|-------------------------|------------------|
| Facebook | 5 | 26,305 | 527,449 | 5,261 | 105,489 | 4.99% | 4.987% |
| Twitter | 3 | 61,478 | 5,774,627 | 20,493 | 1,924,875 | 1.06% | 1.0646% |
| TikTok | 20 | 229,285 | 1,851,970 | 11,464 | 92,598 | 12.38% | 12.381% |

- The Sum row shows "N/A" for Video Response Rate. The Average row carries the rate, which equals the aggregate Engagements/Video Views ratio rounded to 2 decimals. Avg Eng / Avg VV gives the same ratio (e.g. Twitter 20,493 / 1,924,875 = 1.0646%).
- Per-post cross-check: summing the Engagements and Video Views columns of the scraped rows reproduces the Sum row exactly on all three channels (FB 26,305 / 527,449; Twitter 61,478 / 5,774,627; TikTok 229,285 / 1,851,970).
- Informational only: the simple mean of the per-post Video Response Rate cells (formula 2) gives Facebook 5.05% (5 posts), Twitter 3.62% (3), TikTok 6.50% (15 posts with a rate). The app's Average row follows formula 1 (aggregate ratio), not the mean of per-post rates. This is not a failure, since the spec says to use formula 2 only if formula 1 does not work.
- TikTok: 5 of 20 posts have Video Views "–" or tiny (0 engagements; 3 with "–", 2 with 3 and 2 views), so their per-post rate is "–". They add 0 Engagements and negligible Video Views, so the Sum-based ratio is unaffected.
- Facebook: one of the 5 posts is typed "Live Video", which the Video content-type filter includes. Its values are in the sums above.
- Console shows many dev API errors (pre-existing noise); none affected the rendered tables (`.playwright-out/console-2026-10-28T10-57-33-940Z.log`).

Screenshots (`.playwright-out/QA-79142/`): `01-brand.png`, `02-filter-open.png`, `03a-video-checked.png`, `04-fb-table-sum.png`, `04b-fb-table-avg.png`, `05-twitter-table-modeA.png`, `05b-twitter-table-modeB.png`, `06-tiktok-table-modeA.png`, `06b-tiktok-table-modeB.png`.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed).
- bug-history.md: no entries for QA-79142 (pre-fetched).
- known-quirks.md: earlier notes said QA-79142 "still hangs on its TikTok leg" on dev. That did not reproduce today: the Apple Music TikTok table rendered with 20 posts on the first attempt. The 10-27 UCLA run also rendered all three legs. The hang looks load-dependent rather than brand- or case-specific.
- Earlier same-day attempts (screenshots `03-final-render-hang.png`, `r2-10*-tiktok-*.png`, 13:48–14:27 local; an `attempt1` report file does not exist for this case) left evidence of a TikTok-leg render hang with reload/wait retries. This run (about 16:30 local) rendered cleanly, so the hang is intermittent dev load, not a deterministic product defect. Today's verdict rests only on this run's observations.
- No related bug reproduced; no assertion interference.

## Bugs filed
None.
