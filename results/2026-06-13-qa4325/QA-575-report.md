# QA-575 — Instagram In Window Private Data QA — 2026-06-13

- **Env:** Dev · **Account:** Hulu · **Brand:** Hulu (5670) · **Channel:** Instagram · **Window:** Jun 8–14 2026 · **Data Set:** Impressions · **Perspective:** Authorized
- **Result:** ⚠️ PARTIAL (dev verified; stage parity N/A) — consistent with 2026-06-04

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Dev IG In-Window private renders | Authorized IG Impressions/Reach data | Posts(40); Engagement Rate, Impressions, Organic/Paid Impressions, Reach, Organic/Paid Reach all present; no private/login placeholder | ✅ (dev) |
| Dev vs Stage parity | match stage | NOT VERIFIED — no stage login (safety) | ⚠️ N/A |

## Notes
- Required one `location.reload()` (Hulu Brand>Content skeleton >20s first paint).

## Bugs filed
_None._
