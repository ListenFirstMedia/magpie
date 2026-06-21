# QA-13903 — Embedded Post Tooltip - LinkedIn — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** University of California, Los Angeles (brand_id=127756) · **Channel:** LinkedIn · **Window:** Jan 1 – Jun 15 2026
- **Skills:** brand-content-table-view, brand-content-data-set-selector
- **Result:** ✅ PASS

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Posts(N>0) LinkedIn | LinkedIn posts present | Posts(643) | ✅ |
| Hover Type → embedded LinkedIn tooltip | tooltip renders post media + engagement | Hover post #1 (video) → LinkedIn embed renders video thumbnail ("GO BRUINS" UCLA campus) + play button + **476** reactions + **15 Comments** | ✅ |
| Tooltip anchored to hovered row | not viewport corner | Rendered anchored above post #1 (top-left) | ✅ |

## Bugs filed
_None._
