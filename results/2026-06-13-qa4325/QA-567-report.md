# QA-567 — Facebook Lifetime Private Data QA — 2026-06-13

- **Env:** Dev · **Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670) · **Channel:** Facebook · **Mode:** Lifetime · **Window:** Jun 8–14 2026 · **Perspective:** Authorized
- **Skills:** view-perspective-toggle, brand-content-data-set-selector
- **Result:** ⚠️ PARTIAL (dev verified; stage parity not evaluable) — consistent with 2026-06-04

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Dev FB Impressions (private) renders | Authorized FB private data loads | Posts(48); Impressions data set columns all present: Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate; no "data is private/log in" placeholder | ✅ (dev) |
| Dev vs Stage Impressions / Video Views / posts parity | Numbers match stage | **NOT VERIFIED** — stage requires a separate login the automation does not perform (safety) | ⚠️ N/A |

## Notes
- Required one `location.reload()` (Hulu Brand>Content skeleton >25s first paint). Stage-parity half is inherently un-runnable from a dev-only session — same limitation as prior.

## Bugs filed
_None._
