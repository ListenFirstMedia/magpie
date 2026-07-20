# QA-139187 — Settings > Custom Metrics - Parenthetical Expressions

- **Run date:** 2026-07-08 (headless, unattended, Playwright MCP track)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-139187
- **Account:** Adam Orfei (account_id=54) — Custom Metrics is account-gated; confirmed present
- **Brand (TWC):** MTV (exact typeahead match), Authorized perspective
- **Verdict:** **PASS** (A3, A5, A7, A8 all pass)
- **Open-bug screen:** "None open" → ran normally (Rule 7)

## Pre-flight
- Logged in via Cognito "With existing account" form (config/.env) → `#home` rendered ("Home - ListenFirst").
- Landed on account 657 (HBO Max); switched to **Adam Orfei (54)** via LFQA menu → Search Account → clicked the "Adam Orfei" Results row. Breadcrumb confirmed "Account: Adam Orfei".

## Steps executed
1. Settings → Custom Metrics (`#custom-metrics`) — list rendered.
2. Clicked "Create a Custom Metric" → `#custom-metrics/create`.
3. Built formula `( Comments + Engagements × 2 )` via the formula dropdown:
   - Parentheses → `(`; Metrics → ListenFirst → Comments; Operators → `+`; Metrics → ListenFirst → Engagements; Operators → `×`; Constant → `2`; Parentheses → `)`.
   - Verified formula-menu order **Metrics / Constant / Operators / Parentheses**; Operators correctly disabled at formula start and after each operator (strict alternation); `)` disabled until `(` present; Save disabled while `(` unclosed. Clicked Save.
4. Opened TWC in a new tab (Reporting → Time Window Comparison), entered brand **MTV** (exact Results match).
5. Set the MTV row's View toggle to **Authorized FIRST** (Rule 2 — explicit toggle click, verified `0-perspective-toggle` checked=true), then selected the custom metric **and** its component metrics (ListenFirst `Comments`, ListenFirst `Engagements`) via the Filter Metrics box (Custom 1/31, Content 2/263). Ran report (story 155750).
6. Custom Metrics list → row Actions (⋯) → **Edit** (`#custom-metrics/edit?report_id=65`); form prefilled Name/Description/formula.
7. Removed the closing `)` (paren re-open), then extended the formula with `+ Comments` operands until the max-limit validation fired, leaving the parenthesis open.
8. Inserted the closing `)` from the Parentheses dropdown.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A3 | 3 | Save succeeds with no validation error | "Custom metric successfully created!" success modal; row saved with formula `( comments_score_v5 + public_nvo_engagement_v5 * 2 )`, no error | **PASS** |
| A5 | 5 | Computed value follows BODMAS | All 7 daily rows satisfy `custom = Comments + 2×Engagements` (NOT `(Comments+Engagements)×2`) — precedence correct | **PASS** |
| A7 | 7 | Validation "You've reached the max limit of metric selection in your Custom Metric. You can still close ")" to finish the formula." and Save disabled | Exact message shown (verbatim), Save disabled while `(` open | **PASS** |
| A8 | 8 | Validation "You've reached the max limit of metric selection in your Custom Metric" and Save enabled once parentheses closed | On inserting `)`, message dropped the "close )" clause to exactly "You've reached the max limit of metric selection in your Custom Metric"; Save became enabled | **PASS** |

## Evidence

### A5 — BODMAS per-row (MTV, Authorized, Jul 1–7 2026)

| Date | Comments | Engagements | Custom (actual) | Comments + 2×Engagements | Match |
|------|----------|-------------|-----------------|--------------------------|-------|
| Jul 01 | 552 | 74,094 | 148,740 | 148,740 | ✓ |
| Jul 02 | 360 | 60,763 | 121,886 | 121,886 | ✓ |
| Jul 03 | 1,059 | 196,405 | 393,869 | 393,869 | ✓ |
| Jul 04 | 1,178 | 205,648 | 412,474 | 412,474 | ✓ |
| Jul 05 | 1,047 | 122,768 | 246,583 | 246,583 | ✓ |
| Jul 06 | 992 | 121,401 | 243,794 | 243,794 | ✓ |
| Jul 07 | 918 | 117,719 | 236,356 | 236,356 | ✓ |

(If precedence were wrong `(Comments+Engagements)×2` would give e.g. Jul 01 = 149,292 ≠ 148,740.)

### A7/A8 — max-limit behavior
- Max-limit message fired at **6 metric selections** (5 metrics + 1 constant) inside the parenthesis: `( Comments + Engagements × 2 + Comments + Comments + Comments`.
- With `(` open → A7 message + Save disabled (`step7-maxlimit-open-paren.png`).
- After inserting `)` → A8 message (shorter form) + Save enabled (`step8-maxlimit-closed-paren.png`).

### Screenshots (`.playwright-out/QA-139187/`)
- `step3-formula-open-paren.png` — formula mid-build with `(` open, Save disabled
- `step3-formula-complete.png` — `( Comments + Engagements × 2 )`, Save enabled
- `step3-save-success.png` — "Custom metric successfully created!" modal (A3)
- `step5-twc-bodmas.png` — TWC report (story 155750), MTV Authorized, 3 metric sections
- `step6-edit-prefill.png` — Edit form prefilled
- `step7-maxlimit-open-paren.png` — A7 message + Save disabled
- `step8-maxlimit-closed-paren.png` — A8 message + Save enabled

## Notes
- Component metrics: ListenFirst `Comments` = `lfm.post_engagement_score.comments_score_v5`; ListenFirst `Engagements` = `lfm.post_engagement_score.public_nvo_engagement_v5`.
- The max-limit edit (6-operand formula) was **not saved** (clicked Cancel) — A8 only requires Save to become enabled, not to persist. The A3 metric (`( Comments + Engagements × 2 )`, report_id=65) remains saved as a self-owned sandbox metric.
- GS steps: none in this case (N/A).
- This run **captures A7/A8** for the first time — the settings-custom-metrics skill previously noted them as "NOT YET CAPTURED". Max-limit threshold observed = **6 metric selections** per parenthetical.

## Bugs filed
None. All in-scope assertions passed; product behavior matches spec.
