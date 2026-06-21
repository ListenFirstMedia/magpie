# QA-569 — Facebook In Window Private Data QA — 2026-06-13

- **Env:** Dev · **Account:** Hulu · **Brand:** Hulu (5670) · **Channel:** Facebook · **Perspective:** Authorized
- **Skills:** view-perspective-toggle, brand-content-data-set-selector
- **Result:** ⚠️ PARTIAL (dev verified; stage parity not evaluable) — consistent with 2026-06-04

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Dev FB private (In-Window) renders | Authorized FB data loads with Impressions/Reach metrics | FB Authorized private data renders on dev (Posts(48), full Impressions/Reach column set) — same Hulu FB feed as QA-567 | ✅ (dev) |
| Dev vs Stage parity | Numbers match stage | **NOT VERIFIED** — no stage login (safety) | ⚠️ N/A |

## Bugs filed
_None._
