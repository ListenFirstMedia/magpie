# QA-79142 — Brand Content - Public Data Set - Aggregate - Video Response Rate

**Verdict: PASS** (3/3 assertions)

- Run: 2026-10-26 (Monday), unattended headless via Playwright MCP, env app.lfmdev.in (user lfiqa@listenfirstmedia.com)
- Weekday rotation: Monday row of the Description table -> Account **HBO Max**, Brand **HBO Max** (account_id=657, brand_id=155614). The first Monday entry was used, consistent with the 2026-10-20 run, which used the first Tuesday entry. The other Monday accounts (Amazon Prime Video, Conde Nast) were not run.
- Date range: Oct 18 – Oct 24, 2026 (app default week), mode Lifetime. View toggle left at its default (`perspective=extended`). The "public dataset" step was implemented as Data Set dropdown = **Public**, as in the prior run.
- Skill used: `brand-content-grid-math` plus shared helpers `devprod-helpers.js`. No skill/REGISTRY edits (deferred to harvest.sh).

## Steps executed
1. Logged in via the Cognito form. The session landed on account AMAZON PRIME VIDEO. The account switch (`switchAccount`) searched "HBO Max", clicked the exact "Results" match, and the header confirmed `ACCOUNT: HBO MAX` (`01-account.png`).
2. Hovered **Brand** in the top nav and clicked **Content** -> `#explore/brand/content`. The brand selector already showed the exact name **HBO Max**, matching the spec brand (Rule 1; no substitute).
3. Data Set dropdown -> explicitly selected **Public** (visible dropdown shows "Public"; URL `table_data_set=public`). 208 posts across all channels (`02-brand-public.png`).
4. Filter -> **Content Type** -> **Video** -> **Apply Filter** (URL `content_types … ["Video"]`). 195 video posts across all enabled channels (`03-filter-open.png`, `04-video-selected.png`).
5. **Facebook only:** enabled Facebook, disabled all other channels, verified `.channel-ghost.enabled` = [facebook], URL `channels=facebook`, Apply. Posts (24). Switched to Table View, read the aggregate row in Sum mode, clicked the Sum<->Average toggle and read Average mode (`05-fb-table.png`).
6. **Twitter only:** enabled Twitter, disabled Facebook (enabled = [twitter], URL `channels=twitter`), Apply. Posts (10). Read Sum and Average rows (`06-twitter-table.png`).
7. **TikTok only:** enabled TikTok, disabled Twitter (enabled = [tiktok], URL `channels=tiktok`), Apply. Posts (126). Read Sum and Average rows (`07-tiktok-table.png`).

## Assertions
Formula 1 (Engagements / Video Views) was usable on all three channels, so formula 2 was not needed as a fallback.

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 (Facebook only) | Sum Engagements / Sum Video Views = Average Video Response Rate | Sum Eng **1,447,347** / Sum VV **20,302,006** = 7.129% -> **7.13%**; Average row VRR = **7.13%** | PASS |
| A7 | 7 (Twitter only) | same | Sum Eng **3,065** / Sum VV **154,227** = 1.987% -> **1.99%**; Average row VRR = **1.99%** | PASS |
| A9 | 9 (TikTok only) | same | Sum Eng **1,060,950** / Sum VV **46,411,992** = 2.286% -> **2.29%**; Average row VRR = **2.29%** | PASS |

## Evidence
Aggregate rows as displayed (Table View, Content Type = Video, Public data set):

| Channel | Posts | Sum Engagements | Sum Video Views | Avg Engagements | Avg Video Views | Avg Video Response Rate | Eng/VV |
|---------|-------|-----------------|-----------------|-----------------|-----------------|-------------------------|--------|
| Facebook | 24 | 1,447,347 | 20,302,006 | 60,306 | 845,916 | 7.13% | 7.129% |
| Twitter | 10 | 3,065 | 154,227 | 307 | 15,422 | 1.99% | 1.987% |
| TikTok | 126 | 1,060,950 | 46,411,992 | 8,420 | 368,349 | 2.29% | 2.286% |

- The Sum row shows "N/A" for Video Response Rate. The Average row carries the rate (Facebook 7.13%, Twitter 1.99%, TikTok 2.29%). Each equals the aggregate Engagements/Video Views ratio, rounded to 2 decimals.
- Per-post cross-check: summing the Engagements and Video Views columns of the scraped rows reproduces the Sum row exactly on Twitter (3,065 / 154,227) and TikTok (1,060,950 / 46,411,992). Facebook was not cross-checked per post; its Sum row was read directly.
- Informational only: the simple mean of the per-post Video Response Rate cells (formula 2) gives Twitter 3.661% over 10 posts and TikTok 3.679% over the 58 of 126 posts that show a rate. The app's Average row follows formula 1 (aggregate ratio), not the mean of per-post rates. This is not a failure, since the spec says to use formula 2 only if formula 1 does not work.
- 68 of 126 TikTok video posts show "–" for per-post Video Response Rate. This does not affect the Sum/Average rows evaluated.
- Console shows many dev API errors (pre-existing noise); none affected the rendered tables (`.playwright-out/console-2026-10-26T07-22-47-703Z.log`).

Screenshots (`.playwright-out/QA-79142/`): `01-account.png`, `02-brand-public.png`, `03-filter-open.png`, `04-video-selected.png`, `05-fb-table.png`, `06-twitter-table.png`, `07-tiktok-table.png`.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed).
- bug-history.md / known-quirks.md: no entries for QA-79142 (pre-fetched). No related bug reproduced; no assertion interference.

## Bugs filed
None.
