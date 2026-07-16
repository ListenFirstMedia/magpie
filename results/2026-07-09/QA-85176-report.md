# QA-85176 — Settings > Custom Metrics - Custom Metric Create Functionality

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account:** Adam Orfei (account_id=54; Custom Metrics is account-gated to Adam Orfei)
- **Type:** Mutating (creates a custom metric) → **surgical + revert**: the created metric was deleted at the end.

## Verdict: PASS

## Known bugs checked
Compact open-bug screen → empty. No open linked bug.

## Flow executed
Settings → Custom Metrics → Create a Custom Metric → Name "QA Automation Sample Metric 20260709" + Description → Formula: Facebook **Post Comments** → **+** → ListenFirst **Shares** → **−** → Facebook **Post Likes** → removed **Post Likes** → removed **−** → **Save** → **Ok**. Final formula = **Post Comments + Shares**. Then deleted the metric (cleanup).

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 (2) | Save initially disabled | Save `[disabled]` on open | PASS |
| A2 (4) | Dropdown: Metrics, Constant(s), Operators — Operators initially disabled | Metrics, Constant, **Operators `[disabled]`**, Parentheses | PASS |
| A3 (5a) | Channels order: ListenFirst, Facebook, Twitter, YouTube, Instagram, TikTok, Wikipedia | exact order matched | PASS |
| A4 (5b) | Facebook sub-dropdown: icon + metric name + DCR key | e.g. "Post Comments" / `facebook.page.total_post_comments_c`, icons present | PASS |
| A5 (6a) | Typing metric name shows matching options | typing "com" → Comments (lfm), Post Comments (FB), New Video Comments (YT), Organic Comments (IG), Post Comments (TikTok) | PASS |
| A6 (6b) | Selecting adds it to formula row (channel icon + name only) | "Post Comments" chip added (name only, no DCR key) | PASS |
| A7 (7a) | Selecting a metric enables Operators, disables Metrics in dropdown | after add: Metrics `disabled`, Operators `enabled` | PASS |
| A8 (7b) | + and − operators available | operators: **+ (fa-plus), − (fa-minus)**, × (fa-times), ÷ (fa-divide) | PASS |
| A9 (7c) | + operator added to formula row | "+" chip added after Post Comments | PASS |
| A10 (8) | ListenFirst shows up to 10 metrics with scroll bar | 15 metrics in a `menu` with `overflow-y:auto`, scrollHeight 756 > clientHeight 448 (scrollable) | PASS |
| A11 (10) | Last metric removed from row | Post Likes removed | PASS |
| A12 (11) | Last operator removed from row | "−" removed; row = Post Comments + Shares | PASS |
| A13 (12) | Success popup "Custom metric successfully created!" | "Success — Custom metric successfully created!" + Ok | PASS |
| A14 (13) | Page refreshes, shows saved metric on Custom Metrics page | listed with formula `facebook.page.total_post_comments_c + lfm.cross_channel_shares.public_shares_v5`, Created "Jul. 09 2026", Creator "LFQA Testing" | PASS |

## Cleanup (mutation revert)
Deleted "QA Automation Sample Metric 20260709" via row Actions → Delete → Ok. Row no longer present in the listing. No residual test data left.

## Harness notes
- The formula-builder dropdown is **nested-hover** and collapses between MCP calls. Reliable technique found: (1) click the formula input to open the top dropdown; (2) dispatch synthetic `mouseenter`/`pointerenter` on the submenu parent (Metrics/Operators/channel) — this keeps the submenu rendered across calls because React reads it as still-hovered; (3) match the target leaf by DCR key (metrics) or FontAwesome class (operators: `fa-plus`/`fa-minus`/`fa-times`/`fa-divide`); (4) **trusted `browser_click`** on the tagged leaf. Chip removal buttons and operator glyphs are icon-only (empty textContent) — match by `fa-*` class, not text.
- Typeahead (A5) requires **real keystrokes** (`browser_press_key`); `.fill()`/synthetic input events do not trigger the React autocomplete.

## Bugs filed
None.
