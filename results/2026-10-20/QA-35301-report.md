# QA-35301 — Brand Content > Facebook Only: Reels Insights - Post - Data Test

**Verdict: BLOCKED — test-data gap (no Facebook Reels rows to evaluate; spec data set deprecated)**

- Run: 2026-10-20, headless `claude -p`, Playwright MCP, dev (`app.lfmdev.in`), user lfiqa@listenfirstmedia.com
- Account: Viacom (account_id=181) — switched from the default "Adam Orfei" via the profile menu Search Account → Results → Viacom (precondition met)
- Brand: MTV (brand_id=4018) — exact "MTV" row chosen from the typeahead Results (Rule 1); it was also the account default
- Skill used: `brand-content-grid-math` (Table View scrape) + `brand-content-native-post-check` (date picker). No skill drift.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Hover Brand → Content (top nav) | Done. `#explore/brand/content` loaded. Shot 02. |
| 2 | Add MTV brand | Done via brand chevron → "Search for a Brand" textarea → typed "MTV" → clicked the exact "MTV" result. Shot 04. |
| 3 | Data set dropdown → **Facebook Only: Reels Insights** | **Option does not exist.** Dropdown (shot 05) lists: Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, Facebook Only: Reactions, Facebook Only: Completed Video Views, Facebook Engagements Beta, Twitter Only: Engagements & Follows, Instagram Only: Insights/Action Types, Instagram Engagements Beta, YouTube Only: Basic/Insights/Premium/Subscribers & Playlists/Cards, Threads Only: Insights, Pinterest Only: Basic, Cross-Platform, Test Set, Engagements. This matches the case note ("metric is deprecated"). Followed the case's fallback: **"Reels" data set, Facebook channel only** (data set picked first, Instagram disabled, Facebook enabled, Apply; URL `channels=facebook&table_data_set=reels`). |
| 3b | Table View / read Reel Engagements + Reel Follows | **Not evaluable.** See below. |

## Evidence
- Reels + Facebook-only, default week Oct 12–18 2026: `Posts (0)` + "There is no data available" (shot 07, 09), polled >60 s, no "failed to load" error. One reload+retry done (reload resets the page to Public/all channels; selection redone) → still `Posts (0)` (shot 09).
- Same week, **Public** data set, Facebook-only: `Posts (14)` → MTV does have Facebook posts that week (shot 10), so this is not a brand/channel outage.
- Widened range (extra exploration; spec gives no dates) Sep 01–Oct 18 2026, Reels + Facebook-only: still `Posts (0)` (shot 13).
- Reels + Facebook+Instagram, Sep 01–Oct 18: `Posts (78)`, and **all 78 rows are Instagram, 0 Facebook** (DOM channel-icon classification, shot 15/16).
- Public, Facebook-only, Sep 01–Oct 18: `Posts (216)`; the top 200 rows (by engagements) are all `PublishType = Original Post`, 0 `Reel` (shot 17). MTV has essentially no Facebook Reels in the window, so an empty Facebook Reels data set is consistent with the data.
- The current "Reels" data set has no columns named **"Reel Engagements"** / **"Reel Follows"**. Its Table View columns: Engagements, Reactions, Comments, Shares, Reach, Plays, InitialPlays, ReelReplays, AvgTimeWatched(Minutes), VideoViewsTotalTime(Minutes), Follows, TotalReelInteractions (shot 16). The spec'd columns belonged to the deprecated "Facebook Only: Reels Insights" set.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A3 | 3 | Facebook Reel Engagements and Reel Follows values contain no en-dash ("–") | Cannot be evaluated: the spec'd data set no longer exists, and the fallback "Reels" data set returns 0 Facebook posts (default week and Sep 1–Oct 18) and has no "Reel Engagements"/"Reel Follows" columns. No Facebook cell exists to inspect. | BLOCKED |

## Side observation (Instagram, out of scope for this case — NOT used for the verdict)
In the Reels data set (Facebook+Instagram, Sep 1–Oct 18) the **"Follows" column is "–" on 78/78 Instagram reels**, while Engagements is populated on all 78 (aggregate row: Engagements 3,625,952; Follows "–"; InitialPlays "–"; ReelReplays "–"; AvgTimeWatched "N/A"). This is the same symptom class as APPS-60871 (en-dash across datasets, Instagram listed). Not attributable to Facebook, so it does not change this case's verdict.

## Known bugs checked
- **APPS-60871 (Open)** — "Data Rendering Issue: Endash (–) Displayed for Multiple Metrics Across Datasets (Twitter, Instagram, YouTube)". Rule 7 (open linked bug ⇒ auto-fail) was weighed against the saved policy "block only if the bug interferes with the assertions". It lists Twitter/Instagram/YouTube, not Facebook, so I ran the case. Outcome: the bug could not be confirmed or ruled out for Facebook because no Facebook Reels rows exist; the Instagram en-dash on Follows (above) is consistent with it. If a reviewer prefers strict Rule 7, the verdict would be "FAILED (blocked by open bug)"; either way the case is not a PASS.
- bug-history.md / known-quirks.md: no QA-35301 entries (pre-fetched). Dashboard banner "Facebook Posts Insights Disruption" was active during the run; Facebook-only Public still returned posts, so it does not explain the empty Reels view on its own.

## Bugs filed
None (markdown-only). Recommended follow-ups for the case owner: (1) update QA-35301 — "Facebook Only: Reels Insights" and its "Reel Engagements"/"Reel Follows" columns are gone; re-point the case to the "Reels" data set with a brand/date range that actually has Facebook Reels (MTV has none in Sep–Oct 2026); (2) decide whether "Follows" being "–" on all Instagram reels belongs under APPS-60871.

## Screenshots
`.playwright-out/QA-35301/` 01–17 (see Evidence for the key ones: 05 dropdown options, 07/09/13 Posts (0), 15/16 Reels FB+IG table, 17 Public FB post types).
