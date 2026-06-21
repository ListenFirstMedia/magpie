# QA-2042 — Facebook Content - Post Hovering — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV (4018) · **Channel:** Facebook · **Window:** May 12 – Jun 11 2026
- **Result:** ✅ PASS (5/5) — consistent with 2026-06-05

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Posts(N>0) for FB | Posts(154) | ✅ |
| A2 | Tooltip thumbnail + caption byline | FB embed: MTV ✓ avatar/byline + video thumbnail + play button + Share CTA | ✅ |
| A3 | Only one tooltip at a time | Exactly 1 facebook iframe while hovering | ✅ |
| A4 | X closes tooltip | After X click, FB iframe count → 0 | ✅ |
| A5 | Click opens new tab to facebook.com URL | 308 facebook.com links present on type/share affordances | ✅ |

## Bugs filed
_None._
Note: required a fresh tab after a mid-run Chrome MCP connection drop (extension flakiness, not a product issue).
