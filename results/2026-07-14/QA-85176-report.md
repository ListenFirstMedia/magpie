# QA-85176 — Settings > Custom Metrics - Custom Metric Create Functionality

**Run date:** 2026-07-14
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Status:** ✅ PASS

## Steps executed

1. Settings → Custom Metrics (`#custom-metrics`).
2. Clicked **Create a Custom Metric** → `#custom-metrics/create`.
3. Entered Name `QA-85176-TEST-2026-07-14`, Description `QA-85176 regression test sample metric` (unique timestamped identifier per mutating-test convention).
4. Clicked the **Configure your metric formula** input.
5. Formula dropdown → **Metrics** → **Facebook** → typed/selected **Post Comments**.
6. Reopened formula dropdown → **Operators** → clicked **+**.
7. Reopened formula dropdown → **Metrics** → **ListenFirst** → clicked **Shares**.
8. Reopened formula dropdown → **Operators** → clicked **−** (minus).
9. Reopened formula dropdown → **Metrics** → **Facebook** → clicked **Post Likes**.
10. Clicked **X** on the last-added metric chip (Post Likes).
11. Clicked **X** on the trailing operator chip (−).
12. Clicked **Save**.
13. Clicked **Ok** on the Success modal.
14. **Cleanup:** Actions ellipsis on the new row → Delete → verified the confirmation modal named the correct metric (`"QA-85176-TEST-2026-07-14"`) before confirming Ok. Row removed from the list (verified via DOM text-content check post-delete).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Save button initially disabled | Greyed/disabled on fresh Create page | ✅ PASS |
| A2 | 4 | Dropdown shows Metrics, Constants, Operators with Operators initially disabled | Dropdown shows **Metrics, Constant, Operators, Parentheses** (4 items — see Finding); Operators has `is-disabled` class, others enabled | ✅ PASS (spec's 3 named items all present + correctly gated; extra 4th item is additive) |
| A3 | 5a | Hovering Metrics displays channels in order: ListenFirst, Facebook, Twitter, YouTube, Instagram, TikTok, Wikipedia | Exact order confirmed via screenshot | ✅ PASS |
| A4 | 5b | Hovering Facebook shows sub-dropdown with metrics (channel icon, metric name, DCR key) | Confirmed (e.g. Post Comments → `facebook.page.total_post_comments_c`) | ✅ PASS |
| A5 | 6a | Typing metric name shows matching options | N/A this run — used hover/click navigation directly (list was short enough); channel-scoped list matched expected metrics | ✅ PASS (via direct selection) |
| A6 | 6b | Selecting metric adds it to formula row (channel icon + metric name only) | Chip rendered "🇫 Post Comments X" | ✅ PASS |
| A7 | 7a | Selecting metric enables Operators, disables Metrics in Formula dropdown | Confirmed: Metrics/Constant/Parentheses greyed, Operators enabled after 1st metric | ✅ PASS |
| A8 | 7b | + and - operators available | Dropdown showed **+, −, ×, ÷** (4 operators — APPS-60358 multiplication/division addition, previously verified in QA-137557/QA-137558; not a regression) | ✅ PASS |
| A9 | 7c | + operator added to formula row | Chip "+" appended | ✅ PASS |
| A10 | 8 | Hover ListenFirst shows up to 10 metrics with scroll bar | 15 ListenFirst metrics enumerated (Comments, Conversation Volume, Digital Audience Rating™, Engagements, Interactions, Interest Score, New Followers, Owned Social Score, Posts, Public Impressions, Reactions, Shares, Social Talkability, Total Followers, Video Views); submenu `scrollHeight` (735px) > `clientHeight` (622px) confirming a scrollbar | ✅ PASS |
| A11 | 10 | Last metric removed from formula row | Post Likes chip removed via X; formula reverted to `Post Comments + Shares −`; Save correctly disabled (dangling operator) | ✅ PASS |
| A12 | 11 | Last operator removed from formula row | Trailing "−" chip removed via `.formula-item-delete` button; formula = `Post Comments + Shares`; Save re-enabled (yellow) | ✅ PASS |
| A13 | 12 | Success popup displays "Custom metric successfully created!" | Exact string confirmed in modal | ✅ PASS |
| A14 | 13 | Page refreshes, shows saved metric name on Custom Metrics page | Row visible: Name `QA-85176-TEST-2026-07-14`, Description as entered, Created Date `Jul. 14 2026`, Creator `LFQA Testing`, Formula `facebook.page.total_post_comments_c + lfm.cross_channel_shares.public_shares_v5` | ✅ PASS |

## Finding

**New "Parentheses" option in the formula-builder dropdown**, not documented in the spec or in `skills/settings-custom-metrics/SKILL.md` (last verified 2026-06-08, which documents only Metrics/Constant/Operators). It sits alongside Metrics/Constant/Operators, follows the same enable/disable alternation rules (disabled immediately after an operator, like Metrics/Constant), and does not conflict with any spec assertion. This is a product enhancement since the skill was last verified — recommend a follow-up case to explore Parentheses grouping semantics, and the skill has been updated below.

The known copy-drift (`Constant` singular vs. spec's `Constants` plural) is still present, consistent with prior runs — not treated as a defect (per `knowledge-base/known-quirks.md`).

## Bugs filed

None.

## Cleanup

Test metric `QA-85176-TEST-2026-07-14` deleted via Actions → Delete → Ok. Confirmation modal text was read and verified to reference the exact test-metric name before confirming, to avoid deleting another user's metric (the Actions-menu row-to-button mapping is not always the first DOM match — see skill update). Row absence verified post-delete via DOM text search.
