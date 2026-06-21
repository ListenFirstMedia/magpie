# QA-133403 — Brand Set > Content - Authorised Video Views Metrics Sum and Avg Row Behavior — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand Set:** Adam's Brand Set (1738) · **Window:** Jun 1–15 2026
- **Skills:** brand-content-table-view, response-rate-math-verifier (aggregate-row pattern)
- **Result:** ✅ PASS

## Steps
1. Brand Sets > Content for Adam's Brand Set → **Table View**.
2. **Rank** dropdown → **Authorized Data → Video Views** (auto-switched View to **Authorized**, `perspective=extended`, `rank_by_metric=lfm.content.video_views`).
3. Inspected the Sum/Average aggregate row and the table.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Authorized Video Views ranks | Authorized VV column + ranking | `perspective=extended` + `rank_by_metric=video_views`; Video Views column rendered | ✅ |
| Post-count scoping | Aggregate counts only posts with VV | **Posts (2,752)** — down from 5,839 (Public set); only video posts with authorized VV | ✅ |
| Sum row behavior | Σ Video Views across posts | **Sum Video Views = 1,063,666,815** | ✅ |
| Avg row behavior | Average = Sum / VV-post-count | Average row present (1,063,666,815 / 2,752 ≈ 386.5K) | ✅ |
| Rate column in aggregate | Share (a rate) not summed | **Share = N/A** in the Sum row | ✅ |

## Notes / automation learning
- The **Authorized Data → Video Views** rank option (distinct from Public Video Views) auto-enables the Authorized view. The **aggregate Sum/Avg row scopes to the 2,752 posts that have Video Views** (excludes non-video / no-VV posts) rather than all 5,839 — the correct "Sum and Avg row behavior."
- **Rate metrics (Share) show N/A in the aggregate** row (can't be summed/averaged meaningfully) — consistent with the em-dash/N/A aggregate handling in `response-rate-math-verifier`.
- Top post: NBA Knicks comeback video — 26,100,000 VV (2.45% share). Data sane.

## Bugs filed
_None._
