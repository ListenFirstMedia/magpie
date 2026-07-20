# QA-947 — Brand Video Tab - Hovering Functionality — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** Hulu (spec) — Hulu brand_id=5670 redirected to Home on this account; loaded Brand>Video for MTV (4018) as the renderer probe
- **Result:** ❌ FAIL (carry-forward) — **Brand>Video renderer hang REPRODUCED**; LFMP-31781 carry-forward (consistent with 2026-06-05)

## Execution
1. Brand>Video for Hulu (brand_id=5670) → redirected to `#home` (Hulu sub-brand not resolvable on Adam Orfei — Rule 1 test-data note).
2. Brand>Video for MTV (4018) → page **froze the tab**: screenshot, JS eval (`Runtime.evaluate`), and tab-close all timed out (CDP renderer frozen >45s). Recovered only by creating a fresh tab + closing the frozen one.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A3–A9 | Stacked-bar / area chart hover tooltips (New Video Posts / Page Video Views / Video Engagement) with `Mon. DD, YYYY / icon channel: value`, hovered channel highlighted | NOT VERIFIED — Brand>Video renderer froze before charts became interactive | ⚠️ BLOCKED |

## Open-bug verdict
- **LFMP-31781 (Minor, Open) — Twitter legend icon color is blue:** **Carry-forward (still open).** Direct DOM-RGB read on `.legend__icon.twitter-legend` was blocked by the Brand>Video renderer freeze this session. Shared legend component with no fix-commit since the 2026-05-29 / 2026-06-05 reproductions; prior REPRODUCED verdict holds. (Corroborating: the Brand>Conversation legend this run renders Twitter in legacy blue.)

## Bugs filed
- **Brand>Video renderer hang (dev-stability family)** reproduced — froze the tab + wedged the Chrome MCP CDP pipeline (>45s timeouts on screenshot/JS/close). Recovery = fresh tab. Recommend a perf ticket (cf. APPS-55565). Documented in known-quirks.
- LFMP-31781 stays open (carry-forward).

## Cleanup
_None (read-only; frozen tab closed)._
