# QA-137557 — Settings > Custom Metrics - Multiplication & Division Operators - Create & Save

- **Source:** Custom Metrics × ÷ operator create flow
- **Run date:** 2026-07-16
- **Track:** Playwright MCP (`feature/playwright-mcp`)
- **Skill used:** `skills/settings-custom-metrics/SKILL.md` (v3)
- **Account:** Adam Orfei (account_id=54)
- **Result: PASS** (8/8 assertions)

## Steps executed
1. Settings > Custom Metrics → Create a Custom Metric.
2. Confirmed Save disabled on open.
3. Name: `Automation - Mult Div Metric`, Description: `Mult and div operator coverage`.
4. Formula input → Metrics → Facebook → Post Comments.
5. Formula input → Operators → confirmed exactly 4 icons (`fa-plus`, `fa-minus`, `fa-times`, `fa-divide`) → clicked `×` (fa-times). Formula row: `[Post Comments, ×]`.
6. Formula input → Metrics → Facebook → Post Likes. Formula row: `[Post Comments, ×, Post Likes]`.
7. Formula input → Operators → `÷` (fa-divide). Formula row: `[Post Comments, ×, Post Likes, ÷]`.
8. Formula input → Metrics → ListenFirst → Shares. Formula row: `[Post Comments, ×, Post Likes, ÷, Shares]` (5 chips).
9. Save enabled — clicked Save. Success popup: "Custom metric successfully created!" → Ok.
10. Confirmed listing table contains row `Automation - Mult Div Metric`.

**Playwright-MCP gotcha found:** the formula-input dropdown menu (Metrics/Constant/Operators/Parentheses) only opens on a genuine focus-transition click — clicking the already-focused formula input again (or via a JS `.click()` while it still has focus) does NOT reopen the menu. The reliable pattern: click a *different* field (e.g. the Description input) to blur the formula input first, then click the formula input again to re-trigger the menu.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| 2 | Save disabled on open | Confirmed `disabled` class + attribute | PASS |
| 7-A | Operators dropdown lists exactly `+`, `−`, `×`, `÷` (4 options) | Confirmed via icon classes `fa-plus/fa-minus/fa-times/fa-divide`, no others | PASS |
| 7-B | After selecting `×`, formula row contains operator chip `×` | Confirmed `fa-times` chip present | PASS |
| 9 | Formula row contains operator chip `÷` | Confirmed `fa-divide` chip present | PASS |
| 10 | Formula row 5 chips: [Post Comments, ×, Post Likes, ÷, Shares] | Exact match | PASS |
| 11 | Save enabled | Confirmed `disabled: false` | PASS |
| 13-A | Success popup text = "Custom metric successfully created!" | Exact match | PASS |
| 13-B | Listing table contains row `Automation - Mult Div Metric` | Confirmed present | PASS |

## Bugs filed
None.

## Skill maintenance
`settings-custom-metrics` (v3) reconfirmed — × ÷ operator dropdown (4-icon FontAwesome enumeration) re-verified end-to-end via Create flow. New Playwright-MCP gotcha documented: formula-input dropdown requires a genuine blur→refocus click cycle to reopen, not a repeated click while already focused.
