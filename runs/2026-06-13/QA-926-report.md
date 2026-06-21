# QA-926 — Embedded Post Tooltip - YouTube — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV (brand_id=4018) · **Channel:** YouTube · **Window:** May 12 – Jun 11 2026
- **Skills:** brand-content-data-set-selector, brand-content-table-view
- **Result:** ✅ PASS (6/6)

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Posts(N>0) for YT | Posts(11) | ✅ |
| A2 | Tooltip renders thumbnail + caption byline | Embed renders video thumbnail + red play button + "MTV" byline + title "What songs do the 'Off Campus' cast…" + "Watch on YouTube" CTA | ✅ |
| A3 | Only one tooltip open at a time | Exactly 1 YouTube embed iframe in DOM while hovering | ✅ |
| A4 | Close X removes tooltip | After X click, YouTube iframe count → 0 | ✅ |
| A5 | Type link opens youtube.com/watch?v= | 11 post Type links, all valid `youtube.com/watch?v=` hrefs | ✅ |
| A6 | Tooltip anchored to hovered row (not viewport corner) | Tooltip rendered anchored above post #1 (top-left), not corner | ✅ |

## Bugs filed
_None._
Reuse of brand-content-table-view embedded-tooltip pattern — re-confirmed PASS (consistent with 2026-06-05).
