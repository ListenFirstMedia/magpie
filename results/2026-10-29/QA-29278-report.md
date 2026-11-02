# QA-29278 — Brand Content - Impressions Dataset - Data Test - TikTok

**Date:** 2026-10-29 (Thursday)
**Mode:** unattended / headless (`claude -p`), Playwright MCP, dev (`app.lfmdev.in`)
**Verdict: BLOCKED** — Spotify / Spotify News not findable on dev (Rule 1); Sony Pictures / Sony Pictures Television blocked by a render-hang at step 4 (dev `data-api` `/content` returned HTTP 500). No assertion could be evaluated, so no partial PASS.

## Setup / account choice

- Login: Cognito "With existing account" with `config/.env` (lfiqa@listenfirstmedia.com); landed on `#home` (account_id=1030).
- Rotation (Thursday row of the Description table, authoritative over the Notes line, which wrongly lists "Conde Nast" for Thursday): Account 1 = **Spotify**, Brand 1 = **Spotify News**; further pairs: Sony Pictures / Sony Pictures Television, Ralph Lauren / Ralph Lauren.
- Date range: Oct. 21, 2026 - Oct. 27, 2026 (app default). Perspective: Spotify landed on Public data (`perspective=standard`); Sony Pictures on `perspective=extended`. The spec sets no perspective.

## Pair 1 — Spotify / Spotify News: BLOCKED (spec brand not findable on dev)

1. Account menu: typed "Spotify", clicked the exact result; breadcrumb `ACCOUNT: SPOTIFY` (account_id=1030). Brand > Content opened with default brand "Star Wars".
2. Brand selector typeahead:
   - "Spotify News" (typed slowly, polled ~36 s, retried twice) → no Results at all (panel stayed on "Recent Searches": Star Wars, ThisisSpotify, Hulu, Andrew Domink).
   - "Spotify" → alphabetical list truncated at 20+ entries (Spotify (Africa) … Spotify (India) …).
   - "Spotify Ne" (a short list, not truncated) → New (Spotify), Next of Kin (Spotify), Shane (Spotify), Spotify (Indonesia), Spotify (Netherlands), Spotify (Philippines), Spotify Engineering, shane. (Spotify). **No "Spotify News".**
   - Per Rule 1, no substitute brand was used for this pair. Possible reasons (Rule 1 list): brand renamed/removed on dev (spec drift), or visible only under a different account. Not resolvable unattended.

## Pair 2 — Sony Pictures / Sony Pictures Television (second pair of the same Thursday row)

Run because it is a pair named in the spec's own Thursday row, not an invented substitute.

1. Switched account to **Sony Pictures** (account_id=51, breadcrumb `ACCOUNT: SONY PICTURES`). Hovered **Brand** > **Content**. Brand selector exact result "Sony Pictures Television" clicked (brand_id=129863).
2. Opened the visible Data Set dropdown and selected **Impressions** (URL `table_data_set=impressions`).
3. Clicked off Facebook, X, Instagram, LinkedIn, Threads; DOM check: `tiktok enabled`; facebook/twitter/instagram/linkedin/threads/youtube/pinterest disabled. Apply → URL `channels=tiktok`.
4. **Could not review per-post values — post grid never rendered.**
   - Right after Apply: `Posts (10)` header + Sum/Average rows, but the post list showed "This table failed to load. Please try again. Reload".
   - Clicked **Reload** (`.error-data-link a`), waited ~2.5 min → still "failed to load".
   - One full page reload (per the 5-minute budget) → page stayed on skeleton placeholders (no post list, no `Posts (N)`) for ~5 min more (screenshot `11`, `12`).
   - Console: `data-api.lfmdev.in/content?request=…brand_ids [129863]…` → **HTTP 500**; `dsp-api.lfmdev.in` calls (`data_collection_status`, `brands`, `tracked_brands`, `brand_sets`) → `net::ERR_FAILED` / blocked by CORS (no `Access-Control-Allow-Origin`, typical of a 5xx from the gateway). This is a dev backend outage, not a UI/spec problem.
   - Call: render-hang / backend error → whole case BLOCKED at step 4.

Partial observation (NOT a verdict): before the hang, the aggregate rows read — Sum: Impressions 24,240, Organic Impressions "–", Paid Impressions "–"; Average: Impressions 2,424, Organic "–", Paid "–". These are aggregate rows only, may be stale relative to the TikTok-only Apply, and say nothing about each post's Total Impressions (A1), so they are not counted as a pass.

## Assertions

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| A1 | 4 | Total Impressions displays a value on every post | Pair 1: brand not findable. Pair 2: post grid never rendered (data-api `/content` 500). Not evaluated. | BLOCKED |
| A2 | 4 | Organic and Paid Impressions are en-dash on every post | Same. Aggregate row only shows "–" / "–" (see partial observation); per-post not evaluated. | BLOCKED |

## Evidence (`.playwright-out/QA-29278/`)

- `01-account-spotify.png`, `02-content-landing.png` — Spotify account, Brand > Content (brand "Star Wars").
- `03a-brand-typeahead-debug.png`, `03a-brand-typeahead-spotify-news.png`, `03b-brand-typeahead-retry.png` — "Spotify News" typeahead with no result.
- `05-account-sony-pictures.png`, `06-brand-sony-pictures-television.png` — account/brand set for pair 2.
- `07-impressions-selected.png`, `08-tiktok-only.png` — Impressions data set, TikTok only.
- `09-state-check.png`, `10-after-reload.png` — "This table failed to load" before/after Reload.
- `11-after-page-reload.png`, `12-final-wait.png` — skeleton placeholders after page reload and ~5 min wait.
- Console log `.playwright-out/console-2026-10-29T07-54-51-041Z.log` lines ~2339–2456 (the 500 and CORS/ERR_FAILED entries).

## Known bugs checked

- Case file "Open linked bugs": none open (Rule 7 screen passed).
- `bug-history.md`: no QA-29278 match (pre-fetched).
- `known-quirks.md` (pre-fetched): TikTok "–" Total Impressions reproduced on HBO Max 10-26 and Apple Music 10-28, passes on UCLA — not exercised today because no post grid rendered; no linked bug applies to the blocks above.

## Bugs filed

None in Jira (markdown-only policy). Candidates for triage:
1. Dev data-api `/content` returns HTTP 500 for Sony Pictures Television (brand_id=129863, account 51), Impressions data set, TikTok only, Oct 21–27 2026; dsp-api endpoints also failing with CORS/ERR_FAILED in the same window. Check whether dev was down/degraded at ~07:55–08:25 UTC (run time) before treating as brand-specific.
2. Test-data gap: brand "Spotify News" does not exist in the dev brand typeahead under account Spotify (account_id=1030).

## Notes

- Ralph Lauren / Ralph Lauren (third Thursday pair) was not run: the dev API was failing and the case defines the pairs per day without requiring all in one execution.
- The Notes section of `cases/QA-29278.md` has a stale rotation line ("Thu Spotify/Conde Nast"); the Description table says Thursday = Spotify / Sony Pictures / Ralph Lauren. Fixing the case file is left to the ingest step.
- Re-run suggestion: once dev `/content` recovers, re-run on Sony Pictures Television (and confirm with LFIQA where "Spotify News" lives on dev).
- Skill maintenance deferred to harvest.sh.
