# QA-99531 — Brand > Content - Threads - Hovering functionality — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV (4018) · **Channel:** Threads · **Window:** Mar 16–22 2025 (window WITH Threads posts)
- **Result:** ✅ PASS — **upgrades prior 2026-06-05 BLOCKED** (prior window had 0 Threads posts; this window has 2)

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Hover opens embedded tooltip | Threads post type hover → tooltip | Hovering post #1 (gallery) Threads type → embed renders `mtv ✓ · 16/03/2025` + text "These girlies taught me… "HOT" 🔥 @le_sserafim" | ✅ |
| One tooltip / renders content | Single embed, not empty | Exactly 1 Threads embed iframe; populated after ~4s | ✅ |
| Close | X dismisses tooltip | After X click, Threads iframe count → 0 | ✅ |

## Bugs filed
_None._ (Used Mar 2025 window to get hoverable Threads posts on MTV — Rule 1 brand kept, only date adjusted to a window with data.)
