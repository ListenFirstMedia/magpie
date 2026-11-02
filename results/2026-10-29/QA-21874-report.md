# QA-21874 — Brand Content > Data Test > Response Rate Metric

**Verdict: FAIL — Instagram leg misses the spec equality by 0.01 pp (first post Response Rate 7.31% vs calculated 7.30%). Facebook and TikTok match. Twitter and LinkedIn are N/A (0 posts in the date range). The row-1 brand "Spotify News" does not exist on the Spotify account, so the Sony Pictures / Sony Pictures Television row was run instead.**

- Run: 2026-10-29 (Thursday), unattended headless, dev (app.lfmdev.in), user lfiqa@listenfirstmedia.com, Authorized data view (default `perspective=extended`), Data set Public.
- Date range (app default): Oct. 21 – Oct. 27, 2026 (compare Oct. 14 – Oct. 20); Mode Lifetime (Content); grid sort = `responses_mixed` desc; "first post" = Rank 1 / first Table View row.
- **Thursday row 1 — Spotify / Spotify News: not findable (Rule 1, test-data gap, no substitute used).** Account switch to SPOTIFY succeeded (`ACCOUNT: SPOTIFY`, account_id=1030). The brand picker showed "ThisisSpotify". Typing "Spotify News" returned no results for 30 s. "Spotify Ne" listed only `New (Spotify)`, `Next of Kin (Spotify)`, `Spotify (Indonesia)`, `Spotify (Netherlands)`, `Spotify (Philippines)`, `Spotify Engineering`. "Spotify Newsroom" returned nothing. This matches the 2026-10-22 finding that Spotify News is absent on dev and prod. Screenshot: thu-02-brand-picker-spotify.png.
- **Thursday row 2 — Sony Pictures / Sony Pictures Television** (account_id=51, brand_id=129863) is a spec-named Thursday row, not a substitute. Account reached via the profile-menu switcher (real mouse click, confirmed `ACCOUNT: SONY PICTURES`). The brand was re-selected from the typeahead Results by exact title match.
- Scope: Thursday row 3 (Ralph Lauren / Ralph Lauren) was not run, same single-row scoping as earlier runs of this case. The case Notes map Thursday to "Spotify/Conde Nast", which conflicts with the Description table. The table was treated as authoritative.

## Steps executed (per channel, spec order: Facebook, Instagram, Twitter, TikTok, LinkedIn)
1. Brand (top nav hover) > Content.
2. Add brand: opened the brand picker, typed "Sony Pictures Television", clicked the exact Results row.
3. Channels: clicked channel icons so only the channel under test was enabled (verified `.channel-ghost.enabled` == {channel}), clicked **Apply**. The selection resets whenever Content/Insights is opened from the nav, so it was redone on each page.
4. Table View: noted **Engagements** and **Response Rate** of Rank 1.
5. Brand (top nav hover) > Insights (nav menu, not URL).
6. Only the channel under test enabled, Apply.
7. Hovered the "Total Followers" big number (`h4 span.count`) and read the tooltip **Value**. The tooltip Value equals the element `title` on every channel.
8. Computed Engagements / Total Followers x 100 and compared it with the first post's Response Rate.

## Data captured
| Channel | Posts in range | First post (Rank 1) | Engagements | Response Rate (UI) | Total Followers (tooltip Value) | Tooltip comparison / change | Calculated Eng / TF x 100 |
|---|---|---|---|---|---|---|---|
| Facebook | 2 | Thu Oct 22, 09:00 AM PDT | 2 | <0.01% | 53,059 | 53,078 / -19 | 0.0038% (below the display floor, shown as "<0.01%") |
| Instagram | 8 | Mon Oct 26, 01:41 PM PDT | 21,370 | 7.31% | 292,651 | 290,617 / +2,034 | 7.3022% -> **7.30%** |
| Twitter | 0 | none | – | – | 35,381 | 35,392 / -11 | n/a |
| TikTok | 10 | Mon Oct 26, 01:44 PM PDT | 457 | 0.15% | 295,200 | 293,200 / +2,000 | 0.1548% -> 0.15% |
| LinkedIn | 0 | none | – | – | 46,757 | 45,998 / +759 | n/a |

Rank 2 spot-check (informational only; the assertion is on the first post): Instagram 4,047 / 1.38% (calculated 1.3829% -> 1.38%, match); TikTok 262 / 0.09% (calculated 0.0888% -> 0.09%, match); Facebook 0 / 0.00% (match).

Instagram Rank 1 detail: a displayed 7.31% implies a follower denominator between 292,139 and 292,539, against the Insights period-end Total Followers of 292,651. That is a gap of 112 to 512 followers (about 0.04% to 0.18%). It fits the Response Rate being computed on a follower snapshot taken before the period-end value, with the account gaining +2,034 followers over the week. This is the same follower-drift pattern seen on HBO Max on 2026-10-26.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A8-FB | 8 | Eng / TF x 100 == first post Response Rate | 2 / 53,059 = 0.0038%, which the UI floors to "<0.01%"; consistent with the displayed "<0.01%" | PASS (low-discrimination leg) |
| A8-IG | 8 | match | 21,370 / 292,651 = 7.3022% -> 7.30% vs UI 7.31% (0.01 pp gap) | **FAIL** |
| A8-TW | 8 | match | Sony Pictures Television has no Twitter posts in Oct 21–27 (Posts (0); Table View unavailable; Insights Total Followers 35,381). Nothing to compare. | N/A (data absence) |
| A8-TT | 8 | match | 457 / 295,200 = 0.1548% -> 0.15% == 0.15% | PASS |
| A8-LI | 8 | match | No LinkedIn posts in range (Posts (0)). Insights Total Followers 46,757. Nothing to compare. | N/A (data absence) |

The overall verdict is FAIL because A8-IG breaks the spec's "equal" requirement at the displayed 2-decimal precision. This is the same strict standard that produced the FAIL on 2026-10-26. The gap is rounding-scale, so a tolerance-bounded reading of the spec would pass it. Facebook is a weak check: any Response Rate below 0.01% displays as "<0.01%".

## Evidence (screenshots in .playwright-out/QA-21874/)
- thu-01-content-landing.png (Content landing, Sony Pictures Television)
- thu-02-brand-picker-spotify.png (Spotify brand picker; no "Spotify News")
- thu-content-{facebook,instagram,twitter,tiktok,linkedin}-table.png (Content, only that channel enabled)
- thu-facebook-insights.png, thu-{facebook,instagram,twitter,tiktok,linkedin}-followers-hover.png (Total Followers tooltip)
- All values were read from the DOM (table cells, tooltip text, `title` attribute). Screenshots were saved but not visually inspected.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). bug-history.md has no QA-21874 entry.
- known-quirks.md records Response Rate not equalling Eng / Total Followers as brand-specific follower drift (HBO Max FAIL on 2026-10-26; UCLA PASS on 2026-10-20 and 2026-10-27; Apple Music PASS on 2026-10-28). The Instagram miss here fits that pattern. No known bug is cited.

## Environment notes (not product verdicts)
- Login, account switches, Content and Insights loaded without reloads or render hangs. The brand-picker typeahead responded in under 10 s. Spotify News is absent from the results rather than slow.
- Twitter and LinkedIn legs: the spec's channel list is generic, and Sony Pictures Television has no posts on those channels this week. These are data-absence N/A results, not skipped steps.

## Bugs filed
None.
