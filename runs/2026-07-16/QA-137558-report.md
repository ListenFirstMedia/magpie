# QA-137558 — Settings > Custom Metrics - All Operators (+ − × ÷) - Save & Verify in Time Window Comparison

- **Source:** Custom Metrics all-operators create + TWC integration verification
- **Run date:** 2026-07-16
- **Track:** Playwright MCP (`feature/playwright-mcp`)
- **Skill used:** `skills/settings-custom-metrics/SKILL.md` (v3), `skills/time-window-comparison-run/SKILL.md` (v5), `skills/view-perspective-toggle/SKILL.md` (v3)
- **Account:** Adam Orfei (account_id=54)
- **Result: PASS** (8/8 assertions) — 1 new bug finding (duplicate-metric-name causes an ungraceful 500 error)

## Steps executed
1. Settings > Custom Metrics → Create a Custom Metric. Name `Automation - All Operators Metric`, Description `Plus minus mult div coverage`.
2. Built formula via Metrics/Operators/Constant menus: Facebook→Post Comments, Operators→`+`, Facebook→Post Likes, Operators→`−`, ListenFirst→Shares, Operators→`×`, Constant→`2`, Operators→`÷`, Constant→`100`. Final formula row: **9 chips** `[Post Comments, +, Post Likes, −, Shares, ×, 2, ÷, 100]` — exact match to spec.
3. Save enabled — clicked Save.
4. **First Save attempt FAILED** with "Error: Unexpected internal server error. Please contact support." — reproduced identically on a 2nd retry with the same name. **Isolated the cause: a Custom Metric named exactly `Automation - All Operators Metric` already existed in this account** (created in a prior session per skill-registry history) — renaming to a unique `Automation - All Operators Metric 2026-07-16` and resaving succeeded immediately on the first attempt, confirming the duplicate name was the trigger.
5. Success popup "Custom metric successfully created!" → Ok. Confirmed listing contains the new row.
6. Navigated to Reporting > Time Window Comparison — **direct hash URL on `app.lfmdev.in` does not work** (TWC lives on the separate `app-reporting.lfmdev.in` subdomain); reached it via hovering the "Reporting" top-nav item → clicking the "Time Window Comparison" link.
7. Add Brand → typed `MTV` → selected plain `MTV` result.
8. Set MTV's per-brand View toggle to **Authorized Data** — first click on the toggle's outer text label did not register (checkbox stayed unchecked); the reliable click target is `.al-toggle__switch label.label`, consistent with the `view-perspective-toggle` skill's documented pattern. Verified via DOM (`input.checked === true`) rather than trusting the URL/label text alone.
9. Add Metric → Filter Metrics → typed `Automation - All Operators` → both existing Custom-category metrics appeared (`...Metric` and `...Metric 2026-07-16`) — selected the one just created.
10. Run Report → results loaded at `#story/time_window_comparison/156085`.
11. Verified: results table column header `Automation - All Operators Metric 2026-07-16` present; MTV row shows 7 daily calculated numeric values (e.g. Jul 8: 4,063.9 ... Jul 14: 4,518.04) — non-blank, non-error, numeric.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| 14-A | Operators dropdown exposes `+`, `−`, `×`, `÷` (4 options) | Confirmed (fa-plus/fa-minus/fa-times/fa-divide, no others) | PASS |
| 14-B | Formula row order = 9 chips `[Post Comments, +, Post Likes, −, Shares, ×, 2, ÷, 100]` | Exact match | PASS |
| 15 | Save enabled before click | Confirmed | PASS |
| 16-A | Success popup = "Custom metric successfully created!" | Exact match (on the retry with a unique name) | PASS |
| 16-B | Listing contains `Automation - All Operators Metric` | Confirmed (as `...Metric 2026-07-16` — see bug note) | PASS |
| 19 | TWC metric picker returns Custom result `Automation - All Operators Metric` | Confirmed present under "Custom" category | PASS |
| 21-A | Results table visible with column header `Automation - All Operators Metric` | Confirmed (exact name incl. the `2026-07-16` suffix used) | PASS |
| 21-B | Metric value cell for `MTV` is a calculated numeric value | Confirmed 7 daily numeric values, no error/blank | PASS |

## Bug filed

**CM-NEW-1 (Major, candidate): Creating a Custom Metric with a name that already exists returns an ungraceful "Unexpected internal server error" instead of a validation message.**
- **Repro:** Settings > Custom Metrics > Create a Custom Metric → use a Name that already exists for another metric on the account (e.g. `Automation - All Operators Metric`, which already existed from a prior QA session) → fill in a valid formula → Save.
- **Result:** `Error: Unexpected internal server error. Please contact support.` Reproduced 2/2 times with the exact duplicate name.
- **Isolation:** Renaming to a unique value (`Automation - All Operators Metric 2026-07-16`) and resaving with the identical formula/description succeeded immediately, confirming the duplicate name (not the formula or any other field) is the trigger.
- **Expectation:** the backend should either allow duplicate names (Custom Metrics do not appear to enforce global uniqueness elsewhere in the product) or return a friendly "a metric with this name already exists" validation error — not a generic 500.
- Filed here per project convention (markdown report only, no Jira auto-creation).

## Bugs filed
CM-NEW-1 documented above (candidate, not auto-filed to Jira).

## Skill maintenance
`settings-custom-metrics` (v3) — new finding: duplicate-name Save failure (CM-NEW-1); Constant input commits live (no explicit confirm button, blur/click-away is enough — value persists in the DOM as an inline editable `<input type=number>`, not a static chip). `time-window-comparison-run` (v5) reconfirmed — Custom metric column integration end-to-end. `view-perspective-toggle` (v3) reconfirmed — TWC per-brand View toggle needs `.al-toggle__switch label.label` click target, same as documented elsewhere; label-text click alone does not register.
