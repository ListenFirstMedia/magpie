# QA-21874 — Brand Content > Data Test > Response Rate Metric

**Verdict: FAIL — the Instagram leg misses the spec equality by 0.01 pp (first-post Response Rate 2.43% vs calculated 2.42%). Facebook, Twitter and TikTok match. LinkedIn is N/A (0 posts in range, and LinkedIn is disabled on Hulu's Brand Insights page, so its Total Followers cannot be isolated).**

- Run: 2026-10-30 (Friday), unattended headless, dev (app.lfmdev.in), user lfiqa@listenfirstmedia.com, Authorized data view (default `perspective=extended`), Data Set Public.
- Account: **Hulu** (account_id=336, confirmed `ACCOUNT: HULU`, switched via the profile menu with a real mouse click on the Results option). Brand: **Hulu** (brand_id=5670), picked from the typeahead by exact title "Hulu". Friday row 1 of the Description table.
- Date range (app default): Oct. 22 – Oct. 28, 2026 (compare Oct. 15 – Oct. 21); Mode Lifetime; sort Engagements desc (`sort_key=lfm.content.responses_mixed`); "first post" = Rank 1, the first row of the Table View.
- Scope: Friday also lists Robinhood and PlayOn! Sports as accounts, but the Description table gives only "Hulu" as a brand. Only the Hulu row was run, the same single-row scoping as earlier runs of this case. The case Notes map Friday to "Hulu/Ralph Lauren", which conflicts with the Description table. The table was treated as authoritative.

## Steps executed (per channel, spec order: Facebook, Instagram, Twitter, TikTok, LinkedIn)
1. Brand (top-nav hover) > Content.
2. Add brand: opened the brand picker, typed "Hulu", clicked the exact Results row "Hulu".
3. Clicked the other channel icons off so only the channel under test was enabled (verified `.channel-ghost.enabled` == {channel}, and the URL had `channels=<channel>`), clicked **Apply**. The channel selection resets whenever Content or Insights is opened from the nav, so it was redone on each page.
4. Table View (Layout toggle): noted **Engagements** and **Response Rate** of Rank 1.
5. Brand (top-nav hover) > Insights (nav menu, not URL).
6. Only the channel under test enabled, Apply.
7. Hovered the "Total Followers" big number (`h4 span.count`) and read the tooltip **Value**. It equals the element `title` on every channel.
8. Computed Engagements / Total Followers x 100 and compared it with the first post's Response Rate.

## Data captured
| Channel | Posts in range | First post (Rank 1) | Engagements | Response Rate (UI) | Total Followers (tooltip Value) | Tooltip comparison / change | Calculated Eng / TF x 100 |
|---|---|---|---|---|---|---|---|
| Facebook | 57 | Fri Oct 23, 10:00 AM PDT (Video) | 78,353 | 1.18% | 6,665,382 | 6,626,887 / +38,495 | 1.1755% -> **1.18%** |
| Instagram | 59 | Mon Oct 26, 12:30 PM PDT (Gallery) | 78,678 | 2.43% | 3,245,637 | 3,228,988 / +16,649 | 2.4241% -> **2.42%** |
| Twitter | 46 | Wed Oct 28, 11:01 AM PDT (Video) | 629 | 0.02% | 3,576,273 | 3,582,459 / -6,186 | 0.0176% -> **0.02%** |
| TikTok | 48 | Fri Oct 23, 10:00 AM PDT (Video) | 110,076 | 1.72% | 6,400,000 | 6,400,000 / 0 | 1.7199% -> **1.72%** |
| LinkedIn | 0 | none | – | – | not isolable (see below) | – | n/a |

Rank 2 spot-check (informational only; the assertion is on the first post): Facebook 9,184 / 0.14%; Instagram 72,804 / 2.25% (calculated 2.2433%, 0.01 pp under the UI as well); Twitter 375 / 0.01%; TikTok 35,327 / 0.55%.

Instagram Rank 1 detail: a displayed 2.43% implies a follower denominator between 3,231,129 and 3,244,454, against the Insights period-end Total Followers of 3,245,637. That is a gap of 1,183 to 14,508 followers (about 0.04% to 0.45%). The comparison-period value is 3,228,988, so the Response Rate fits a follower snapshot taken before the period-end value, with the account gaining +16,649 followers over the week. This is the same follower-drift pattern recorded for HBO Max on 2026-10-26 and Sony Pictures Television on 2026-10-29.

LinkedIn detail: Brand > Content with only LinkedIn enabled shows Posts (0), and Table View is unavailable. On Brand > Insights the LinkedIn icon is `disabled` for Hulu, so it cannot be enabled. Clicking it did nothing, and the page stayed on the four enabled channels. The Total Followers value read in that state, 19,887,292, equals the sum of the four enabled channels (6,665,382 + 3,576,273 + 3,245,637 + 6,400,000), so it is not a LinkedIn number and was not used.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A8-FB | 8 | Eng / TF x 100 == first post Response Rate | 78,353 / 6,665,382 = 1.1755% -> 1.18% == UI 1.18% | PASS |
| A8-IG | 8 | match | 78,678 / 3,245,637 = 2.4241% -> 2.42% vs UI 2.43% (0.01 pp gap) | **FAIL** |
| A8-TW | 8 | match | 629 / 3,576,273 = 0.0176% -> 0.02% == UI 0.02% | PASS |
| A8-TT | 8 | match | 110,076 / 6,400,000 = 1.7199% -> 1.72% == UI 1.72% | PASS |
| A8-LI | 8 | match | No LinkedIn posts in range (Posts (0)); LinkedIn disabled on Hulu Insights. Nothing to compare. | N/A (data absence) |

The overall verdict is FAIL because A8-IG breaks the spec's "equal" requirement at the displayed 2-decimal precision. This is the same strict standard that produced the FAIL on 2026-10-26 and 2026-10-29. The gap is rounding-scale, so a tolerance-bounded reading of the spec would pass it.

## Evidence (screenshots in .playwright-out/QA-21874/)
- fri-00-home.png, fri-01-account-search.png, fri-03-content-landing.png, fri-04-brand-picker.png
- fri-05b-fb-loaded.png, fri-06-fb-table.png
- fri-content-{instagram,twitter,tiktok,linkedin}-table.png (Content, only that channel enabled; LinkedIn shows Posts (0))
- fri-08-fb-insights.png, fri-{facebook,instagram,twitter,tiktok,linkedin}-followers-hover.png (Total Followers tooltip; the LinkedIn shot is the four-channel state)
- All values were read from the DOM (table cells, tooltip text, `title` attribute). Only fri-00-home.png, fri-03-content-landing.png and fri-05b-fb-loaded.png were visually inspected.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). bug-history.md has no QA-21874 entry.
- known-quirks.md records Response Rate not equalling Eng / Total Followers as brand-specific follower drift (HBO Max FAIL 2026-10-26, Sony Pictures Television Instagram FAIL 2026-10-29, UCLA PASS 2026-10-20 and 2026-10-27, Apple Music PASS 2026-10-28). The Instagram miss here fits that pattern. No known bug is cited.

## Environment notes (not product verdicts)
- Login, the account switch, Content and Insights loaded without reloads or render hangs. Each channel's Posts count appeared on the first poll after Apply.
- The browser console shows many errors on every page. None blocked rendering and none were investigated.

## Bugs filed
None.
