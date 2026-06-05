# QA-85176 — Settings > Custom Metrics - Custom Metric Create Functionality — Run Report

- **Date:** 2026-05-29
- **Account:** Adam Orfei (account_id=54)
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-85176.md
- **URL flow:** `#custom-metrics` → `#custom-metrics/create` → `#custom-metrics`

## Result: PASS

## Execution
1. Top Nav → Settings → Custom Metrics (URL `#custom-metrics`); table shows pre-existing rows (Cross-Channel Engagements, Custom test, Jan30 test, Jim's Test, PC Test 1, Sample, Sample Metric, Test 09-05-20254, …).
2. Clicked **Create a Custom Metric** (top-right) → URL became `#custom-metrics/create`. **Save button initially DISABLED (greyed).**
3. Typed Name = `QA-85176 Sample Metric`; Description = `Test for QA-85176 custom metric create flow`. Save still disabled (formula empty).
4. Clicked Formula field → dropdown opened with **Metrics**, **Constant** (note: spec writes "Constants" plural, UI shows singular "Constant"), **Operators**. **Operators was initially GREYED** (cannot start a formula with an operator).
5. Hovered Metrics → channel list appeared in order: **ListenFirst, Facebook, Twitter, YouTube, Instagram, TikTok, Wikipedia** (matches spec).
6. Hovered Facebook → sub-list of FB metrics each shown with **Facebook icon + metric name + DCR key** (e.g. `Post Comments` → `facebook.page.total_post_comments_c`).
7. Clicked **Post Comments** → chip added to formula as `[FB icon] Post Comments  X`. Save still disabled.
8. Re-opened formula dropdown → **Operators now ENABLED** (no longer greyed) once first metric present.
9. Hovered Operators → sub-list `+  −  ×  ÷`. Clicked `+` → operator chip appended.
10. Re-opened formula → **Operators GREYED again** (cannot have two consecutive operators).
11. Hovered Metrics → ListenFirst → Shares → clicked Shares (`lfm.cross_channel_shares.public_shares_v5`). Formula became `Post Comments + Shares`. **Save now ENABLED (yellow).**
12. Tested removals: clicked X on Shares chip → Shares removed, dangling `+` left, Save disabled. Clicked X on `+` chip → `+` removed, only Post Comments remained, Save still disabled.
13. Re-added an operator (`−` minus) via Operators submenu and a second metric (ListenFirst → Engagements `lfm.post_engagement_score.public_nvo_engagement_v5`) → formula `Post Comments − Engagements`, Save enabled.
14. Clicked Save → modal popup `Success / Custom metric successfully created!` with `Ok` button.
15. Clicked Ok → redirected to `#custom-metrics`; **QA-85176 Sample Metric** present in the list with Description "Test for QA-85176 custom metric create flow" and Created Date "May. 29 2026".

## Assertions
- **A1 (3) Save button initially disabled on Create page:** PASS — Save greyed until valid formula assembled.
- **A2 (4a) Formula dropdown shows Metrics / Constant / Operators:** PASS.
- **A2b (4b) Operators initially disabled (greyed):** PASS — until first metric exists.
- **A3 (5a) Channel sub-dropdown order (ListenFirst, Facebook, Twitter, YouTube, Instagram, TikTok, Wikipedia):** PASS — order matches spec.
- **A4 (5b) Channel sub-list shows icon + metric name + DCR key:** PASS — verified on Facebook (`facebook.page.total_post_comments_c`) and ListenFirst (`lfm.cross_channel_shares.public_shares_v5`, `lfm.post_engagement_score.public_nvo_engagement_v5`).
- **A5 (6) Selected metric appears as removable chip in formula bar:** PASS — Post Comments chip with X.
- **A6 (7a) Operators enabled after first metric:** PASS.
- **A7 (7b) Operator sub-menu shows `+ − × ÷`:** PASS.
- **A8 (7c) Operator chip appended:** PASS — `+` chip then `−` chip.
- **A9 (8) Second metric selectable; valid formula enables Save:** PASS — Save toggles enabled (yellow).
- **A10 (10) Last metric `X` removes that metric and disables Save (if formula invalidated):** PASS.
- **A11 (11) Last operator `X` removes that operator:** PASS.
- **A12 (12) Save click triggers Success popup with `Ok`:** PASS — `Custom metric successfully created!`.
- **A13 (13) Ok dismisses popup and routes back to Custom Metrics list with new row:** PASS — new row "QA-85176 Sample Metric" visible in the listing.
- **A14 (cross-cutting) Operators cannot be placed back-to-back:** PASS — Operators greys out immediately after an operator is added.

## Evidence
- Final URL after Save → Ok: `https://app.lfmdev.in/#custom-metrics`.
- New row visible: `QA-85176 Sample Metric | Test for QA-85176 custom metric create flow | May. 29 2026`.
- Confirmation modal text: "Custom metric successfully created!".

## Notes
- The Formula builder enforces a strict alternation rule: a formula must start with a Metric/Constant, and after every Operator the next token must be a Metric/Constant. The UI enforces this by greying Operators whenever the trailing token is already an Operator (or formula is empty).
- The DCR (Data Connection Reference) key is rendered as a second line under each metric name in the Metrics sub-dropdown — useful for analysts validating which underlying field a metric maps to.
- Operator label note: spec lists `Constants` (plural) in step 4a, but the production UI shows `Constant` (singular). This is a copy-text discrepancy worth filing as a minor UI/spec sync ticket (not a functional defect).
- Used `Post Comments − Engagements` for the final saved formula instead of the spec's `Post Comments + Shares` because the demonstration of X-removal and re-add cycle (steps 10-11) intentionally rebuilt the formula; the save path itself is independent of which specific 2-metric combination is used.
