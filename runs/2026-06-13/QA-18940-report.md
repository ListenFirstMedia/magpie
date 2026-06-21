# QA-18940 — Brand > Video - Favourites Functionality — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV (4018)
- **Result:** 🚫 BLOCKED — Brand>Video renderer hang (reproduced); favourite mechanic carry-forward PASS (2026-06-05, header-level/independent)

## Execution
- Navigated Brand>Video for MTV twice (full window, and narrow Jun 1–7 window). Both froze the page renderer — CDP `Runtime.evaluate` timed out >45s; the favourite (heart) control in the brand header could not be reached because the entire page renderer was frozen.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Heart toggle `fal fa-heart` → `fas fa-heart`; persists across Home↔Brand>Video | Favourite toggles + persists | NOT REACHABLE — Brand>Video renderer frozen | 🚫 BLOCKED |

## Notes
- Favourite functionality is a brand-header control (independent of the Video chart renderer) and **PASSED on 2026-06-05** — verdict carried forward; today's block is environmental (Brand>Video renderer hang), not a favourite-feature regression.
- Strengthens the **Brand>Video renderer-hang** finding (now frozen on MTV 2× this session, wedging the Chrome MCP CDP pipeline each time).

## Bugs filed
- Brand>Video renderer hang (dev-stability) — see QA-947 report + known-quirks.

## Cleanup
_None (no toggle applied; page never interactive)._
