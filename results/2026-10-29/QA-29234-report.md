# QA-29234 — Brand Content > Video Views Data Set > Past date range data test - (Twitter/Instagram)

**Verdict: BLOCKED** (test-data gap on leg 1, no evaluable video data on leg 2, dev render hang on leg 3). No leg produced a non-trivial pass/fail on the spec configuration, and nothing contradicted the spec formulas.

- Run: 2026-10-29 (Thursday), unattended headless (Playwright MCP), dev `app.lfmdev.in`, user `lfiqa@listenfirstmedia.com` (Cognito "With existing account").
- Weekday row (Description table, authoritative): Thursday = Accounts **Spotify / Sony Pictures / Ralph Lauren**, Brands **Spotify News / Sony Pictures Television / Ralph Lauren**. The case `## Notes` line ("Thu Spotify/Conde Nast") disagrees with the table; the table was used (same call as the 10-27 and 10-28 runs). The "Amazon Prime Video on alternative days" note has no Thursday row, so it was not run.
- Skill: `brand-content-grid-math` (Table View DOM scrape via `_shared/playwright-helpers/devprod-helpers.js`). Open-bug screen (Rule 7): case says "None open", so it ran normally.

| Leg | Account | Brand | Result |
|---|---|---|---|
| 1 | Spotify (account_id 1030) | Spotify News | BLOCKED (test-data): the spec brand is not findable on dev |
| 2 | Sony Pictures (account_id 51) | Sony Pictures Television (brand_id 129863) | Ran on spec. Only 1 post per channel and neither has evaluable video-view data (see assertions) |
| 3 | Ralph Lauren | Ralph Lauren (brand_id 7000) | BLOCKED (render-hang): Brand > Content never initialised, even after one reload |

## Steps executed
1. Logged in. Account menu > Search Account > clicked the exact `Results` entry for each leg's account. Hovered **Brand** > **Content** (`#explore/brand/content`).
2. **Leg 1 (Spotify).** Account Spotify (1030) landed on brand "Star Wars". Brand typeahead, typed slowly (150 ms/char, up to 18 s wait): `Spotify` returned 60+ Spotify brands (Africa … for Podcasters, Cares, Design, Live, Platform, Podcasts, …) but no "Spotify News". `Spotify News` returned 0 results. `Spotify New` returned only "New (Spotify)", "Spotify (Australia/New Zealand)" and "synecdoche new york (Spotify)". `News` returned unrelated brands (News Corp, Newsweek, …). Account search for `Spotify` shows only one account. Rule 1: no substitute used. Screenshots: `L1-01..L1-04`.
3. **Leg 2 (Sony Pictures Television).** Steps 1–2: the brand selector showed the exact name "Sony Pictures Television" (brand_id=129863, account_id=51). Data Set dropdown (visible one) > exact option **Video Views** (`table_data_set=video_views`). Step 3: date picker START DATE = Jan 01, 2023, END DATE = Jan 10, 2023 (read back from `.date-range-fields`), **Ok** (URL `from=2023-01-01&to=2023-01-10`). The page then sat on skeleton for roughly 6 minutes (about 200 s of polling, then 100 s more), with a transient "failed to load" flag and the Reload link clicked by the poller, before the table and `Table View` control rendered (`Posts (2)` with all channels on).
4. Step 4 (Twitter only): trusted channel-ghost clicks, DOM check `enabled: ["twitter"]`, **Apply** (URL `channels=twitter`). Waited about 49 s for the re-render, switched to **Table View**, scraped the post row and the Sum row (`L2-06-twitter-table.png`).
5. Step 7 (Instagram only): enabled Instagram, disabled Twitter, verified `enabled: ["instagram"]`, **Apply** (URL `channels=instagram`). Table View scrape (`L2-07-instagram-table.png`).
6. **Leg 3 (Ralph Lauren).** The account switch worked and `Brand > Content` loaded the exact brand "Ralph Lauren" (brand_id=7000), but the page stayed on header-only skeleton: no Data Set dropdown, no channels, no `Posts (N)`. The URL had only `brand_id=7000` (no `account_id`, no date params). Polled about 150 s, then reloaded once and polled about 200 s more (`L3-02-hang.png`, `L3-02b-after-reload.png`). Network log: `https://dsp-api.lfmdev.in/tracked_brands?use_account_scope=false` (×2) and `https://dsp-api.lfmdev.in/brand_sets?limit=1&summary_set=true` ended `net::ERR_FAILED`; the console shows "blocked by CORS policy: No 'Access-Control-Allow-Origin' header". The brand/account calls (`brands/7000`, `accounts`, `recent_brand_views`) returned 200. Per the 5-minute step budget this leg is BLOCKED (render-hang). Steps 3–9 were not reachable.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5-Spotify-Twitter | 2–5 | Brand Spotify News; Organic Views + Paid Views = Video Views per post | Spec brand "Spotify News" does not exist in the brand typeahead (see step 2) | BLOCKED (test-data gap) |
| A6-Spotify-Twitter | 2–6 | Engagements / Video Views = Video Response Rate | Same | BLOCKED (test-data gap) |
| A8-Spotify-Instagram | 2, 7–8 | Instagram only; Organic + Paid = Video Views | Same | BLOCKED (test-data gap) |
| A9-Spotify-Instagram | 2, 7–9 | Engagements / Video Views = Rate | Same | BLOCKED (test-data gap) |
| A5-Sony-Twitter | 3–5 | Organic + Paid = Video Views per post | 1 post, Mon Jan. 09, 2023 06:00: Organic 0 + Paid "–" (0) + Unclassified 0 = Video Views 0. Sum row: 0 + – = 0. The identity holds, but only trivially (zero video views) | PASS (trivial, 0 = 0) |
| A6-Sony-Twitter | 3–6 | Engagements / Video Views = Video Response Rate | Engagements 20 / Video Views 0 is undefined; the Rate cell shows "–", and the Sum row shows "N/A" by design. Nothing to compare | BLOCKED (no evaluable data) |
| A8-Sony-Instagram | 3, 7–8 | Organic + Paid = Video Views per post | 1 post, Mon Jan. 09, 2023 05:01 AM (Type: Video, "escape reality and spend the night at fantasyislandtv…"): Organic "–", Paid "–", Video Views "–". Sum row also all "–". "–" total = no data, not evaluable | BLOCKED (no evaluable data) |
| A9-Sony-Instagram | 3, 7–9 | Engagements / Video Views = Rate | Engagements 81, Video Views "–", Rate "–"; Sum row Rate "N/A" | BLOCKED (no evaluable data) |
| A5/6/8/9-RalphLauren | 3–9 | Video Views, Jan 01–10 2023, Twitter then Instagram | Brand > Content never rendered (dev-api CORS/ERR_FAILED), steps 3–9 unreachable | BLOCKED (render-hang) |

## Evidence
- Leg 2 Sum rows. Twitter: Engagements 20 | Video Views 0 | Organic 0 | Paid – | Unclassified 0 | Rate N/A | "Video Views (with Cross-Posts)" 216. Instagram: Engagements 81 | Video Views – | Organic – | Paid – | Unclassified – | Rate N/A.
- Table headers (both channels): Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views, Viewers, Video Duration, Watch Time (Minutes), Video Views (with Cross-Posts), Actions.
- Informational only: the Twitter post carries 216 "Video Views (with Cross-Posts)" but a plain Video Views of 0. I did not capture its Type/Text before switching channels.
- Screenshots in `.playwright-out/QA-29234/`: `L1-01-spotify-content.png`, `L1-02-brand-typeahead.png`, `L1-03-typeahead-*.png`, `L1-04-account-search-spotify.png`, `L2-01-sony-content.png`, `L2-02-ds-dates.png`, `L2-03-state.png`, `L2-04-after-wait.png` (skeleton after ~3.5 min), `L2-05-after-reload.png`, `L2-06-twitter-table.png`, `L2-07-instagram-table.png`, `L3-01-ralph-content.png`, `L3-02-hang.png`, `L3-02b-after-reload.png`, `L3-03-ds-dates.png`. Only `L2-04`, `L3-02` and the table state were inspected visually; the rest were verified through DOM text, class and URL checks.
- Console log: `.playwright-out/console-2026-10-29T08-18-20-276Z.log` (heavy pre-existing console-error noise on dev; only the Ralph Lauren `dsp-api` CORS/ERR_FAILED entries are relevant).

## Known bugs checked
- Case file "Open linked bugs": None open. Pre-fetched `bug-history.md` / `known-quirks.md` greps for QA-29234: none.
- One narrow `known-quirks.md` grep (Video Views / skeleton / CORS): the closest matches are the "Dev render hangs" quirk and the Hulu "Twitter Brand>Content In Window Video Views tile skeleton-hang" entry (line 665). Both are consistent with the Sony Pictures Television Video Views load delay (several minutes of skeleton) and the Ralph Lauren hang. Neither is a spec-assertion failure, and none of it is filed as a new bug.
- No known bug changed any verdict, and nothing observed is a regression.

## Bugs filed
None. Candidate for the spec owner or QA, not filed:
- Ralph Lauren: `dsp-api.lfmdev.in/tracked_brands` and `/brand_sets` fail with CORS/`ERR_FAILED` on Brand > Content, so the page never initialises. If this reproduces outside the batch load it is a dev API gateway problem.

## Notes for harvest / spec owner
- The "Spotify News" brand does not exist on dev under the only Spotify account (1030); correct the rotation or the brand name.
- The Jan 01–10, 2023 window for Sony Pictures Television has only 1 Twitter post (0 video views) and 1 Instagram video post with no view data, so A6/A8/A9 cannot be exercised on this brand. A brand or range with real video data would give a meaningful check.
- The case `## Notes` weekday line disagrees with the Description table.
- Re-run the Ralph Lauren leg when dev `dsp-api` is healthy.
