# QA-30670 — Brand Insights - Cross-Channel Public Video Views Tile - Data QA

**Verdict: PASS**

- Run: 2026-10-30, headless Playwright MCP, env `app.lfmdev.in` (dev), login `lfiqa@listenfirstmedia.com`
- Account / brand tested: **Viacom / MTV** (exact "MTV" typeahead result; Insights brand_id=4018 Authorized, which the Public toggle remapped to brand_id=10765 `perspective=standard`), **Public data**
- Window: Absolute **Oct 22, 2026 – Oct 28, 2026** (the Insights default 7-day range; the TWC range was set to the same days by clicking the calendar cells)
- Open-bug screen (Rule 7): case file says "None open" -> ran normally.

## Interpretation notes
- Steps 5-6 ("Classic Reporting" -> "TWC Template") map to the current nav: Reporting -> **Time Window Comparison** (`app-reporting.lfmdev.in/#/time_window_comparison`). There is no "Classic Reporting" item or template picker in the current UI (same mapping as QA-30666).
- Step 2 "Add MTV Brand": the Insights page opened already on MTV (4018) for Viacom; I still re-selected it through the brand picker (chevron -> "Search for a Brand" -> typeahead Results -> exact `MTV`, not `MTV (FB)` / `MTV (Africa)` etc.).
- Step 3 channels: the Insights channel bar already had Facebook, Twitter(X), Instagram and TikTok enabled and nothing else (`.channel-ghost.enabled` = facebook/twitter/instagram/tiktok; URL `channels=` carried all four; Apply stayed disabled because there was no change to apply). I did not need to toggle any channel.

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Log in (Cognito "With existing account"), profile menu -> Search Account -> Results row `Viacom` | Breadcrumb `ACCOUNT: VIACOM` confirmed |
| 1 | Hover Brand -> Insights | `#explore/brand/insights` opened |
| 2 | Add MTV, select Public Data | Brand picker -> exact `MTV` clicked. View toggle was on **Authorized data** (`perspective=extended`); clicked the **Public data** button -> URL `perspective=standard`, `#perspective` checked=false, Public Video Views tile renders (screenshot 04/05/06) |
| 3 | Select Facebook, Twitter, Instagram, TikTok | All four enabled, others disabled (see note above) |
| 4 | Note Public Video Views tile | Heading `Public Video Views: 5.68M(-47%)`, exact `.count[title]` = **5,680,231** (screenshot 06) |
| 5-6 | Reporting -> Time Window Comparison | Builder opened |
| 7 | Add MTV (Public Data) | Typeahead -> clicked exact `MTV`; `#0-perspective-toggle` checked=false and visually on the Public Data side (screenshot 12) |
| 8 | Absolute Dates + Interval "Aggregate" | Interval dropdown -> Aggregate; `.from-calendar` day 22 (`range-start`) and `.to-calendar` day 28 (`range-end`), October 2026 (screenshot 09) |
| 9 | Click By Channel | Opened; filter bar `Public Video Views` |
| 10 | Select the 4 metrics | Facebook > Video > Public Video Views, Twitter > Video > Public Video Views, Instagram > Video > Public Video Views, TikTok > Video > Public Video Views; each `aria-checked=true`; counters Facebook 1/2, Twitter 1/1, Instagram 1/2, TikTok 1/1, Cross-Channel 0/2 (not selected) (screenshot 10) |
| 11 | Deselect Show Metrics Graphs | `aria-checked` true -> false (screenshot 11) |
| 12 | Run Report, sum the values | Story `#story/time_window_comparison/162041`, "Time Window Comparison (Oct 22, 2026 - Oct 28, 2026)", brand MTV; loaded first try |

## TWC result
| Channel metric | Value |
|---|---|
| Facebook Public Video Views | 325,971 |
| Twitter Public Video Views | 16,260 |
| Instagram Public Video Views | 2,651,073 |
| TikTok Public Video Views | 2,686,927 |
| **Sum** | **5,680,231** |

Arithmetic: 325,971 + 16,260 = 342,231; + 2,651,073 = 2,993,304; + 2,686,927 = 5,680,231.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A12 | 12 | Brand Insights Cross-Channel Public Video Views equals the sum of the 4 channel Public Video Views values in the TWC report | Insights tile = 5,680,231; TWC sum = 5,680,231; difference 0 | **PASS** |

## Evidence
- Screenshots (`.playwright-out/QA-30670/`): `01-insights-initial.png`, `03-brand-typeahead.png`, `04-public-toggle.png`, `05-public-view.png`, `06-public-video-views-tile.png`, `07-twc-initial.png`, `08-twc-brand-added.png`, `09-twc-dates.png`, `10-metric-filter.png`, `11-twc-options.png`, `12-twc-top.png`, `13-twc-report.png` (full page).
- Both surfaces showed the same data stamp "Data Last Updated (PT): 10-29-2026 05:01 PM", so there is no freshness skew.
- Insights Public tile list (same load): Total Followers 93.9M; Follower Growth -19.9K; New Posts 112; Engagements 993K; Views 2.01M (Twitter only); Public Video Views 5,680,231.

## Execution notes
- The first attempt to click the "Public data" label via text locator timed out (label not matched as visible text); a coordinate click on the toggle worked. The toggle change also swapped the URL brand_id 4018 -> 10765 (public record of MTV) while the displayed brand name stayed `MTV`.
- A mis-click on the favorites heart (brand header) occurred while locating the brand picker chevron (screenshots 02-after-brand-click vs 02-brand-open show the heart icon changed from filled to outlined, so the LFQA/Viacom MTV favorite flag may have been toggled off). It does not affect any data value or the assertion, but the favorite state of MTV on the Viacom account may differ from before the run.
- The Facebook Data Collection Disruption (9/27) banner was visible on Insights; both surfaces agree on the Facebook number, so it did not affect the result.

## Known bugs checked
- Case file "Open linked bugs": none. `knowledge-base/bug-history.md` and `known-quirks.md` had no QA-30670 entries (pre-grepped). No related bug on the Insights Public Video Views tile known.

## Bugs filed
None (markdown-only policy; nothing to file).
