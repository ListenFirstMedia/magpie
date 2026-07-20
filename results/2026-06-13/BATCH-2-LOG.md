# QA-22296 Re-run — Batch 2/12 — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **User:** LFQA · **Data Last Updated:** 06-12-2026 04:25 PM
- **Members:** QA-947, QA-2042, QA-6315, QA-18940, QA-19950 (test-set order 6–10)

| QA | Title | Result | Open-bug verdict |
|----|-------|--------|------------------|
| QA-6315 | Brand > Conversation - Basic view | ❌ FAIL | **LFMP-31800 REPRODUCED** — "Click here to load Tweets" navigates to Listening page |
| QA-947 | Brand Video Tab - Hovering | 🚫 BLOCKED | **Brand>Video renderer hang reproduced (2×)**; LFMP-31781 carry-forward (still open) |
| QA-2042 | Facebook Content - Post Hovering | ✅ PASS (5/5) | n/a |
| QA-18940 | Brand > Video - Favourites | 🚫 BLOCKED | Brand>Video renderer hang; favourite mechanic PASS carry-forward (2026-06-05) |
| QA-19950 | Brand Content CSV All Data set Impressions | ✅ PASS | **LFMP-31979 NOT reproduced** (FB thumbs OK; Pinterest N/A on UCLA) — **upgrades prior BLOCKED** |

## Headline
- 2 PASS (QA-2042; QA-19950 upgraded from BLOCKED), 1 FAIL (QA-6315 bug repro), 2 BLOCKED by Brand>Video renderer hang.
- Open-bug movement: LFMP-31800 REPRODUCED (keep open); LFMP-31979 NOT reproduced (FB half — candidate to narrow/close); LFMP-31781 carry-forward open.

## Stability events
- **Brand>Video froze the renderer twice** (MTV), each time wedging the Chrome MCP CDP pipeline (>45s timeouts on screenshot/JS/tab-close). Recovery = create fresh tab + close frozen tab. Also one transient "Browser connection unavailable" drop mid-batch (extension reconnected; session tab group reset, re-created).
- Brand>Content skeleton >15s first-paint on several navigations (UCLA, APV-family); recovered with waits/reload.

## Cleanup
- No mutations. UCLA Impressions export queued (harmless). Frozen Brand>Video tab abandoned (auto-cleaned).
