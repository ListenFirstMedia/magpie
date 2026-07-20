# QA-90213 — Data Studio ↔ Brand Content Twitter parity (MTV, Adam Orfei)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-90213
- **Run date:** 2026-05-27
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018, Public Data perspective on both pages)
- **Date Range:** May 20, 2026 – May 26, 2026 (7D default on both pages)
- **Result:** ⚠ **PARITY MISMATCH — Data Studio Post Level "Twitter Post Likes" Sum (358,666) does NOT match Brand>Content Reactions Sum (93,456); "Twitter Post Replies" Sum (2,382) does NOT match Brand>Content Comments Sum (1,088). Likely a metric-semantics mismatch (post-level lifetime accumulation vs. content-view in-window aggregation) — flagged for product clarification rather than filed as bug pending Data Studio metric definition review.**

## Steps executed

| Step | Action | State | Evidence |
|---|---|---|---|
| 0 | Switched account → Adam Orfei via Search Account Results | ✓ | account_id=54 |
| 1 | Reporting → Data Studio | ✓ | URL `/#explore/reporting/data_studio?account_id=54` |
| 2 | Click Post Level tab + Set Interval = Aggregate | ✓ | Post Level selected; Interval shows "Aggregate" |
| 3 | Add Brand: MTV (exact-match from typeahead Results, Rule 1) | ✓ | Brand list row: MTV (Public View toggle, default) |
| 4 | Select Metrics: Twitter Post Likes + Twitter Post Replies (both under Engagements: Likes & Reactions / Comments) | ✓ | Both metrics appear in post-level metric list with X icon |
| 5 | Click Go | ✓ | Report built → URL `/#explore/reporting/data_studio?account_id=54&report_id=292567` |
| 6 | (new tab) Brand → Content for MTV | ✓ | URL `/#explore/brand/content?brand_id=4018&account_id=54&from=2026-05-20&to=2026-05-26&...` |
| 7 | Search for `MTV` in top-nav, click exact-match `MTV` from live Results (Rule 1; NOT MTV Argentina from Recent Searches) | ✓ | brand_id=4018 confirmed |
| 8 | Select only Twitter channel (URL `channels=twitter`) | ✓ | Posts (61) loaded for Twitter-only |
| 9 | Verify the data | ✓ See assertions | |

## Assertion results

**Data Studio (Post Level, Aggregate interval, MTV Public, May 20-26, 2026, Lifetime Window Mode):**
| Metric | Sum | Average |
|---|---:|---:|
| Twitter Post Likes | **358,666** | 51,238 |
| Twitter Post Replies | **2,382** | 340 |

**Brand > Content (Table View totals, MTV Public, Twitter only, May 20-26 2026, Lifetime, Data Set = Public, include_retweets=false):**
| Metric | Sum | Average |
|---|---:|---:|
| Engagements | 116,247 | 1,906 |
| Reactions | **93,456** | 1,532 |
| Comments | **1,088** | 18 |
| Shares | 117,370 | 1,924 |

| ID | Spec assertion | Data Studio | Brand Content | Status |
|---|---|---:|---:|---|
| A1 | Twitter Post Likes = Reactions | 358,666 | 93,456 | ❌ MISMATCH (DS ≈ 3.84× BC) |
| A2 | Twitter Post Replies = Comments | 2,382 | 1,088 | ❌ MISMATCH (DS ≈ 2.19× BC) |

The ratios are *different* (3.84× vs 2.19×), so it isn't a single uniform scaling factor — this points to a metric-definition difference rather than a single computation error.

## Likely root cause (hypothesis, not confirmed)

Brand > Content has `include_retweets=false` and Data Set = "Public" — its column totals are aggregated only over posts created in the date window, with metric values reflecting current lifetime accumulation up to the data freshness cutoff (2026-05-27 05:05 AM PT) but bounded by the in-window publish set.

Data Studio Post Level with Interval = Aggregate sums the chosen metric for the brand across all Twitter posts whose engagement activity fell in the window — **including** retweets / quote tweets / replies from older posts, and including counts that accumulated AFTER the window cutoff via Lifetime mode. This naturally yields a much higher Sum than Brand > Content even though both pages call the metric "Twitter Post Likes" or "Twitter Post Replies".

Two specific knobs that probably explain the discrepancy:
- **Retweet inclusion:** Brand > Content has the Include Retweets checkbox unchecked; Data Studio Post Level doesn't expose that flag in the builder.
- **Post universe:** Brand > Content limits to posts *published* in the window (61 posts). Data Studio in Aggregate mode may sum activity (likes/replies) accumulated against any post that received engagement in the window.

## Bugs filed
None yet — the values clearly don't match, but this may be intentional semantic difference rather than a bug. Recommend product/engineering review before filing. If product confirms the spec ("Twitter Post Likes = Reactions") should literally hold, this would be a high-priority parity bug. If the spec wording is being interpreted strictly (which the test case wording suggests), then:

> **Potential bug:** Twitter Post Likes / Twitter Post Replies in Data Studio Post Level Aggregate do not match Brand>Content Reactions / Comments columns for the same brand, same Public perspective, and same date range. Tested MTV, May 20-26 2026.

## Evidence captured
- Data Studio report URL: https://app.lfmdev.in/#explore/reporting/data_studio?account_id=54&report_id=292567
- Brand>Content URL: https://app.lfmdev.in/#explore/brand/content?brand_id=4018&account_id=54&from=2026-05-20&to=2026-05-26&channels=twitter&perspective=extended&stats_attribution_window=lifetime&table_data_set=public&sort_key=lfm.content.responses_mixed&sort_order=desc&sentiment_mode=false&include_retweets=false
- Both pages have View / perspective = Public Data
- Both pages have date range May 20-26, 2026
- Data freshness on both pages: 2026-05-27 05:05 AM PT

## Skill registry impact
- `switch-account` v2 — pass_streak +1 (separate-day account switch worked first try)
- No new skill needed; existing patterns covered Data Studio Post Level setup + Brand>Content channel filtering
- Add a `known-quirks.md` note: the top-nav Brand picker's "Recent Searches" entry for "MTV" loads `MTV (Argentina)` (brand_id=70901), NOT the exact-match `MTV` (brand_id=4018). Confirms Rule 1 — never click Recent Searches; always type and pick from live Results.

## Recommended next step
- LFIQA: confirm whether the spec's parity claim is meant as literal numeric equality or as conceptual equivalence. If literal, file the parity bug. If conceptual, mark this test PASS with a documentation note.
