# QA-79142 — Brand Content - Public Data Set - Aggregate - Video Response Rate

**Verdict: BLOCKED** (spec brand "Spotify News" does not exist on dev; test-data gap, no substitute used per Rule 1)

- Run: 2026-10-29 (Thursday), unattended headless via Playwright MCP, env app.lfmdev.in (user lfiqa@listenfirstmedia.com)
- Weekday rotation: the Thursday row of the Description table. Account **Spotify**, Brand **Spotify News** (first Thursday entry, consistent with prior runs on 10-20, 10-26, 10-27 and 10-28, which each used the first entry of the day's row).
- Skill used: `brand-content-grid-math` plus shared helper `devprod-helpers.js` (login, account switch, navigation, typeahead). No skill/REGISTRY edits (deferred to harvest.sh).
- Rule 7 screen: case file "Open linked bugs" = None open, so the case was run.

## Steps executed
1. Logged in via the Cognito "existing account" form. The session landed on `ACCOUNT: MICHAEL KORS`.
2. Switched account to **Spotify** via the account menu (`account_id=1030`; account search for "Spotify" returns exactly one account, "Spotify"). Hovered **Brand** in the top nav, clicked **Content** -> `#explore/brand/content`. The page opened on brand **Star Wars** (`brand_id=36465`), the account default (`01-brand.png`).
3. Step 2 ("Add a Brand"): opened the brand selector and searched for the exact spec brand **Spotify News**. **No result** (details below). The run stopped here. Steps 3-9 (Video content-type filter; Facebook, Twitter and TikTok only; Sum/Average reads) were NOT executed, because they need the spec brand.

## Brand search evidence (Rule 1)
Brand typeahead on account Spotify (the typeahead works: "Star Wars" returns the exact brand, so it is not stale or broken):

| Query | Result |
|-------|--------|
| `Spotify` | 66 options (under the 100-result cap): `Spotify (Africa)` ... `Spotify (Vietnam)`, `Spotify - GOSS`, `Spotify Cares`, `Spotify Design`, `Spotify Engineering`, `Spotify K-Pop`, `Spotify Live`, `Spotify Platform`, `Spotify Podcasts`, `Spotify Policy`, `Spotify Songwriting`, `Spotify Sub-Handles Roll-Up`, `Spotify Wrapped 2025`, `Spotify for Advertisers`, `Spotify for Artists`, `Spotify for Creators`, `Spotify for Podcasters`. No `Spotify News`; alphabetically it would sit between `Spotify Live` and `Spotify Platform`. |
| `Spotify News` (typed in full) | 0 options (`02-spotify-news-no-results.png`) |
| `Spotify New` | `New (Spotify)`, `Spotify (Australia/New Zealand)`, `synecdoche new york (Spotify)` |
| `Spotify Ne` | `New (Spotify)`, `Next of Kin (Spotify)`, `Shane (Spotify)`, `Spotify (Indonesia)`, `Spotify (Netherlands)`, `Spotify (Philippines)`, `Spotify Engineering`, `shane. (Spotify)` |
| `News` (100-result cap hit) | 100 options, none containing "Spotify" (cap makes this inconclusive on its own; the `Spotify` query above is conclusive) |

Rule 1 checklist for "exact-name brand doesn't appear":
1. Spec drift: consistent with the evidence. No brand named "Spotify News" is visible to this user on dev.
2. Wrong account: ruled out. The only Spotify account is "Spotify" (account-search for "Spotify" returns one result, `03-account-search.png`) and the typeahead was searched under it.
3. Stale typeahead: ruled out. Retyped 3 times with slow typing and 8-9 s waits; control query "Star Wars" returned its exact brand.
4. ACL: cannot be excluded from the UI. If "Spotify News" exists but is not granted to lfiqa, LFIQA must grant it.

No substitute brand (for example `Spotify (Global)`, `Spotify (United States)` or `Spotify Sub-Handles Roll-Up`) was used, per Rule 1.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 (Facebook only) | Sum Engagements / Sum Video Views = Average Video Response Rate | Not evaluated: brand "Spotify News" not findable on dev | BLOCKED |
| A7 | 7 (Twitter only) | same | Not evaluated: same reason | BLOCKED |
| A9 | 9 (TikTok only) | same | Not evaluated: same reason | BLOCKED |

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed).
- bug-history.md: no entries for QA-79142 (pre-fetched).
- known-quirks.md: the earlier "QA-79142 still hangs on its TikTok leg" note concerns the Monday/Tuesday/Wednesday brands. It is not relevant here, because the run never reached the TikTok leg.
- No linked or related bug explains the missing brand. Searching `knowledge-base`, `cases` and `results` for "Spotify News" found only Description tables in other cases and no prior result, so this is the first Thursday run of this case.

## Notes for follow-up
- Other cases that use the same Thursday row (QA-29123, QA-29234, QA-29116, QA-20537, QA-24278 and others) name "Spotify News" too and will likely hit the same gap.
- Action needed from LFIQA/test-data owners: confirm whether "Spotify News" was renamed or removed, or grant it to lfiqa, then update the Thursday row (or the case Notes line, which currently says "Thu Spotify/Conde Nast") accordingly.
- The other Thursday brands ("Sony Pictures Television", "Ralph Lauren") also return nothing on the Spotify account's typeahead. That is expected, since they belong to their own accounts. Their existence on dev was not verified, because the run was not switched to those accounts.

## Evidence
Screenshots (`.playwright-out/QA-79142/`): `01-brand.png`, `01b-typeahead-spotify.png`, `01c-typeahead-Spotify_News.png`, `01c-typeahead-News.png`, `01c-typeahead-Spotify_Ne.png`, `02-spotify-news-no-results.png`, `03-account-search.png`. Older files in the folder (`r2-*`, `03-final-render-hang.png` and similar) are from earlier runs and not evidence for this verdict.

## Bugs filed
None. This is a test-data gap, not a product defect.
