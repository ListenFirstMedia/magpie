# QA-29122 — Brand Content - Basic Data Set - Data Test (Twitter and Instagram)

- **Run date:** 2026-10-29 (Thursday) — unattended headless, dev (`app.lfmdev.in`), user `lfiqa@listenfirstmedia.com`
- **Rotation row used:** Thursday — accounts Spotify / Sony Pictures / Ralph Lauren → brands Spotify News / Sony Pictures Television / Ralph Lauren (Description table; the case's Notes line "Thu Spotify/Conde Nast" contradicts the Description table, so the spec table was followed)
- **Date range (default, not altered):** Oct. 21, 2026 – Oct. 27, 2026; perspective `extended` (Authorized); data set **Engagements Breakdown**
- **Skill:** `brand-content-grid-math` (Table View DOM scrape; identity evaluated in page JS for every post)

## Verdict: **BLOCKED** (Spotify leg — spec brand "Spotify News" not findable on dev). Legs that could run: Sony Pictures Television PASS, Ralph Lauren PASS.

Per spec-adherence Rule 1 the case is not judged PASS while one rotation leg cannot be executed on the exact spec brand; no substitute brand was used (the default `ThisisSpotify` brand that loads under the Spotify account was NOT counted).

## Steps executed (per leg)
1. Hover Brand → Content (`navLink`: hover `Brand` header, click `Content`).
2. Account switched via profile → Search Account → `Results` entry; Brand picker → exact brand typeahead result.
3. Data set dropdown → **Engagements Breakdown**; channel ghosts: Twitter enabled, all others disabled; Apply; Table View.
4. Scraped every post row: Reactions + Comments + Shares vs Engagements (per post), plus Sum row cross-check.
5. Instagram enabled alone (Twitter disabled), Apply, Table View.
6. Same per-post identity.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| Spotify-A4 | 4 (Twitter) | R+C+S = Engagements for every post, brand **Spotify News** | Brand cannot be selected: typeahead for `Spotify News` returns an empty list (also empty for `Spotify Studios`); `Spotify Ne` → only New (Spotify)/Next of Kin (Spotify)/Shane (Spotify)/Spotify (Netherlands)/shane. (Spotify); the full scrolled `Spotify` list (57 entries: Spotify (Africa) … Spotify for Podcasters) has no "Spotify News" | BLOCKED (test-data gap) |
| Spotify-A6 | 6 (Instagram) | same, Instagram | not reachable (brand missing) | BLOCKED (test-data gap) |
| Sony-A4 | 4 (Twitter) | R+C+S = Engagements | Brand `Sony Pictures Television` (brand_id 129863, account Sony Pictures): `Posts (0)` for Twitter in Oct 21–27 — no post table rendered; nothing to evaluate | N/A (no Twitter posts in range; vacuous) |
| Sony-A6 | 6 (Instagram) | R+C+S = Engagements | 8 posts, 8/8 match (0 mismatches). Shares = "–" on all 8 (Instagram has no Shares → counted as 0). Sum row: Engagements 29,445 = Reactions 29,253 + Comments 192 | PASS |
| Ralph-A4 | 4 (Twitter) | R+C+S = Engagements | brand `Ralph Lauren` (brand_id 7000, account 732): 13 posts, 13/13 match. Sum row: Engagements 40,250 = Reactions 26,017 + Comments 836 + Shares 13,397 | PASS |
| Ralph-A6 | 6 (Instagram) | R+C+S = Engagements | 1 post, 1/1 match. Shares "–" (IG → 0). Sum row: Engagements 9,410 = Reactions 9,295 + Comments 115 | PASS |

## Evidence
- Screenshots (`.playwright-out/QA-29122/`): `spotify-typeahead.png` (Spotify result list, no "Spotify News"), `sony-twitter.png` (Posts (0)), `sony-instagram.png`, `ralph-twitter.png`, `ralph-instagram.png`, `00-login.png`.
- URL confirmation per leg carried `table_data_set=engagements_breakdown` and a single `channels=` value (twitter / instagram) — toggles were clicked in the UI, not set by URL.
- Exact-brand check: `.brand-selector-name` read back `Sony Pictures Television` / `Ralph Lauren`; every scraped row's Brand column matched.
- Dev behaviour: Sony Pictures Television Content sat on the loading skeleton for >150 s on first load; one reload rendered it (transient, within the 5-min budget). Ralph Lauren's account switch triggered a full app reload and took ~1 min (first `switchAccount` call reported not-ok while the shell was reloading; the account was confirmed as `RALPH LAUREN` afterwards and the leg proceeded).
- Sony "–" Shares for Instagram is the structurally-absent case documented in the skill; Reactions and Comments were present on all rows.

## Known bugs checked
- Case file "Open linked bugs": none open → Rule 7 screen passed. `knowledge-base/bug-history.md`: no match for QA-29122. No known bug reproduced or interfered with the assertions.
- Related quirk (known-quirks, 2026-10 Wednesday-rotation note) covers the NBCU leg of the same case on Wednesdays; the Thursday "Spotify News" gap is the same class of issue (rotation brand not entitled/present on lfiqa dev) — not previously recorded for this brand.

## Bugs filed
- None (markdown-only). Test-data gap to raise with LFIQA: brand **"Spotify News"** is not available under the Spotify account on dev, so the Thursday Spotify leg of QA-29122 (and any sibling rotation case using it) cannot run; either entitle/restore the brand or trim the rotation row. Also: Sony Pictures Television has no Twitter posts in the default week (Oct 21–27), so its Twitter leg is vacuous until data exists or a date range with posts is specified.
