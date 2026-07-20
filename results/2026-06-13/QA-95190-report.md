# QA-95190 — Brand > Channels - Threads Basic View — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV (4018) · **Window:** May 25–31 2026
- **Skills:** view-perspective-toggle, brand-content-data-set-selector
- **Result:** ✅ PASS — consistent with 2026-06-05; APPS-53076 / APPS-53104 (Closed) NOT reproduced

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Threads tile renders | Threads channel tile present with metrics | Threads tile: Total Followers **2,248,267**, New Followers –, Fan Growth Rate 0.00%, New Posts 0, Engagements 0, Engagement Rate 0.00%, Views 0 | ✅ |
| Total Followers populated | Non-empty follower value | 2,248,267 (exact match to prior run) | ✅ |
| Tile footer links | Insights / Content / Save to Dashboard | Present (same pattern as FB/Twitter/TikTok tiles) | ✅ |

## Open-bug verdict
- APPS-53076 / APPS-53104 (Closed) — Threads tile populates correctly; NOT reproduced.

## Bugs filed
_None._
