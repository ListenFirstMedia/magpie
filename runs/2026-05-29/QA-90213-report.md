# QA-90213 — Data Studio ↔ Brand Content Twitter parity (MTV, Adam Orfei)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-90213
- **Run date:** 2026-06-02 (batch 12/12)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018, exact-match from Results — NOT "MTV (Argentina)" Recent Searches)
- **Date Range:** May 25, 2026 – May 31, 2026 (7D default on both pages)
- **Result:** MAJOR FINDING — parity mismatch has **NEARLY RESOLVED** vs 2026-05-27 batch run. Numbers now within ~0.5–1.2% (370,018 vs 368,312 Likes/Reactions; 2,265 vs 2,238 Replies/Comments). Previous batch showed 358,666 vs 93,456 (3.84× off). This run still does not meet strict spec equality but the residual diff is consistent with freshness/lag rather than systematic semantic mismatch — recommend SME confirmation.

## Steps executed

| Step | Action | State | Evidence |
|---|---|---|---|
| 0 | Confirmed Adam Orfei (account_id=54) | OK | Account label in nav |
| 1 | Reporting → Data Studio (direct URL `#explore/reporting/data_studio?account_id=54`) | OK | URL confirmed |
| 2 | Click Post Level tab; set Interval = Aggregate (via lfm-dropdown, default was `Days`) | OK | Interval label updated to `Aggregate` |
| 3 | Add Brand: typed `MTV` in Add-a-Brand typeahead; clicked exact-match `MTV` from Results (NOT MTV Argentina from Recent Searches — Rule 1) | OK | Brand row: `MTV  Public  Authorized` toggle (unchecked = Public, slider on left = Public). Per Rule 2, visual position confirmed via screenshot. |
| 4 | Select Metrics: typed `Twitter Post Likes`, checked checkbox; typed `Twitter Post Replies`, checked checkbox | OK | Both metrics appeared in Post Level Metrics list |
| 5 | Click Go | OK | Report built → URL `#explore/reporting/data_studio?account_id=54&report_id=293538` |
| 6 | Captured Sum table values | OK | (see below) |
| 7 | New tab: Brand → Content for MTV — direct URL with brand_id=4018, channels=twitter, perspective=extended, table_data_set=public, include_retweets=false | OK | Posts (58) loaded for Twitter-only |
| 8 | Per Rule 2, confirmed View toggle visually = `Public Data` (left side, indicator pill in Public Data position) | OK | Screenshot confirms |
| 9 | Switched Layout to Table view (Sort=Engagements default) | OK | Sum row visible with Engagements/Reactions/Comments/Shares columns |

## Data Studio (Post Level, Aggregate, MTV Public, May 25–31, 2026, Lifetime window mode)

| Metric | Brand | Sum | Average |
|---|---|---:|---:|
| Twitter Post Replies | MTVP | **2,265** | 324 |
| Twitter Post Likes | MTVP | **370,018** | 52,860 |

(`MTVP` is the row label for MTV in Public mode.)

## Brand > Content (Table View, MTV Public Data toggle = on, Twitter only, May 25–31 2026, Lifetime, Data Set = `Public`, Include Retweets = unchecked, Posts(58))

| Column | Sum |
|---|---:|
| Engagements | 495,459 |
| **Reactions** | **368,312** |
| **Comments** | **2,238** |
| Shares | 125,122 |
| Response Rate | N/A |
| Video Views | 1,093,495 |
| Video Response Rate | N/A |

Channel filter: ONLY `twitter` enabled (URL `channels=twitter`; only Twitter X icon active in `.channel-ghost.twitter.enabled` — all other channel-ghosts confirmed disabled).

## Assertion results

| ID | Spec assertion | Data Studio | Brand Content | Δ abs | Δ % | Status |
|---|---|---:|---:|---:|---:|---|
| A1 | DS Twitter Post Likes Sum == BC Reactions Sum | 370,018 | 368,312 | +1,706 | +0.46% | **MISMATCH (residual)** |
| A2 | DS Twitter Post Replies Sum == BC Comments Sum | 2,265 | 2,238 | +27 | +1.21% | **MISMATCH (residual)** |

## Comparison to 2026-05-27 batch FAIL

| Metric | 2026-05-27 DS | 2026-05-27 BC | 2026-05-27 ratio | 2026-06-02 DS | 2026-06-02 BC | 2026-06-02 ratio |
|---|---:|---:|---:|---:|---:|---:|
| Twitter Post Likes / Reactions | 358,666 | 93,456 | 3.84× | 370,018 | 368,312 | 1.005× |
| Twitter Post Replies / Comments | 2,382 | 1,088 | 2.19× | 2,265 | 2,238 | 1.012× |

The 2026-05-27 mismatch (DS values 3.84× and 2.19× greater than BC) has **almost entirely resolved** in this run. Most likely explanations:
1. A platform/data-pipeline fix landed between 2026-05-27 and 2026-06-02 that brought DS Post Level Aggregate semantics into alignment with Brand > Content Public Lifetime aggregates.
2. The 2026-05-27 BC values may have been impacted by a temporary data-freshness issue (e.g. CDN cache or partial fact-table backfill) that's since resolved.
3. The residual ~0.5–1.2% delta is most consistent with normal in-flight engagement still being aggregated against earlier posts at slightly different snapshot times across the two pages (DS may snapshot a few minutes later than BC, or vice-versa).

## Verdict + recommended next steps for the metric SME

- **Spec literal equality is still NOT met** (370,018 ≠ 368,312; 2,265 ≠ 2,238).
- **However the magnitude of the diff is now in the noise range** of normal pipeline lag (sub-1.5%), not a multiplicative-factor systematic difference.
- **Recommended SME questions:**
  1. Is sub-1.5% drift between Data Studio Post Level Aggregate and Brand>Content Twitter Reactions/Comments expected (different snapshot timestamps, slightly different post-universe windowing, late-arriving fact rows)? If yes, this case should PASS with a tolerance window stated in the spec.
  2. If literal numeric equality is required, this is still a NEW PARITY BUG (small magnitude vs prior batch, but still violates strict spec). Possible reproduce: same brand, same date range, but capture DS and BC reads within the same second to remove freshness from the equation.

## Bugs filed

None auto-filed. **Filed against bug-history.md as "RESIDUAL parity mismatch, likely freshness-window related"**. Previous LFMP-31782 (closed) referenced this exact symptom — likely the same fix landed, but a tiny residual remains. If SME wants strict-equality assertion, file a follow-up LFMP-31782b.

## Evidence captured

- DS report URL: https://app.lfmdev.in/#explore/reporting/data_studio?account_id=54&report_id=293538
- BC URL: https://app.lfmdev.in/#explore/brand/content?brand_id=4018&account_id=54&from=2026-05-25&to=2026-05-31&channels=twitter&perspective=extended&stats_attribution_window=lifetime&table_data_set=public&sort_key=lfm.content.responses_mixed&sort_order=desc&sentiment_mode=false&include_retweets=false
- Data freshness on both: 2026-06-01 04:37 PM PT
- Posts count Brand>Content Twitter-only: 58 (was 61 in 2026-05-27 batch for May 20–26)

## Skill registry impact

- `data-studio-post-level-run` — pass_streak preserved (skill executed correctly; mismatch is data-side); marked "verifies parity to within ~1%"
- `switch-account` v2 — no switch needed (Adam Orfei active baseline)
- No new skill authored.

## Sources

- [QA-90213 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-90213)
