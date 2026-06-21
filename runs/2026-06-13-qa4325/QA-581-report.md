# QA-581 — Twitter In Window Private Data QA — 2026-06-13

- **Env:** Dev · **Account:** Hulu · **Brand:** Hulu (5670) · **Channel:** Twitter · **Window:** Jun 8–14 2026 · **Data Set:** Impressions · **Perspective:** Authorized
- **Result:** ⚠️ PARTIAL (dev verified; stage parity N/A) — consistent with 2026-06-04

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Dev Twitter In-Window private renders | Authorized Twitter Impressions/Reach data | Posts(51); Engagement Rate, Impressions, Organic/Paid Impressions, Reach, Organic/Paid Reach present | ✅ (dev) |
| Dev vs Stage parity | match stage | NOT VERIFIED — no stage login (safety) | ⚠️ N/A |

## Notes
- **Twitter table skeleton-hang on first paint** re-observed (>18s, no error) — recovered after `location.reload()`. Consistent with the prior 2026-06-04 finding (Twitter Video Views tile skeleton-hang). Recommend monitoring as part of the renderer-hang family.

## Bugs filed
- Twitter Brand>Content skeleton-hang transient re-observed (recovers on reload) — see known-quirks renderer-hang family.
