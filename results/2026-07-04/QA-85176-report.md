# QA-85176 — Settings > Custom Metrics — Custom Metric Create Functionality

- **Run date:** 2026-07-04
- **Track:** Playwright MCP (headless, unattended), real Chrome, `app.lfmdev.in`
- **Account:** Adam Orfei (account_id=54) — precondition met (already active after login; no switch needed)
- **Skill reused:** `settings-custom-metrics` (v3)
- **Open-bug screen:** case file "Open linked bugs" = None open → ran normally
- **Verdict:** **PASS — 14/14 assertions**
- **Created metric (self-owned sandbox):** `QA-85176 Sample Metric 20260704-045101`

## Pre-flight
- Navigated to `app.lfmdev.in` → redirected to Cognito hosted UI.
- Filled the **"With existing account"** form (lfiqa@listenfirstmedia.com) and clicked that form's Sign in → `oauth_callback` → `#home` (title "Home - ListenFirst"). Login confirmed.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Settings → Custom Metrics (`#custom-metrics`) | List page rendered; columns Metric \| Description \| Created Date \| Creator \| Formula \| Actions; "Create a Custom Metric" button present |
| 2 | Click 'Create a Custom Metric' | Navigated to `#custom-metrics/create`; Save disabled; Name/Description/formula rows shown |
| 3 | Enter unique name + description | Name = `QA-85176 Sample Metric 20260704-045101`, Description = `QA-85176 automated regression test metric` |
| 4 | Click Formula input | Dropdown opened: Metrics / Constant / Operators (disabled) / Parentheses |
| 5 | Metrics → Facebook channel | Channel list shown; hovered Facebook → metric sub-list with icon + name + DCR key |
| 6 | Type + select 'Post Comments' | Typed "Post Comments"; matches shown; selected `facebook.page.total_post_comments_c`; chip added |
| 7 | Add '+' operator | Operators enabled; +/−/×/÷ shown; clicked +; `+` chip appended |
| 8 | Hover Metrics → ListenFirst → 'Shares' | ListenFirst sub-list of 15 metrics with scrollbar; selected `lfm.cross_channel_shares.public_shares_v5` |
| 9 | Type + select '−' operator and 'Post Likes' | Added `−` operator; typed "Post Likes"; selected `facebook.page.total_post_likes_c` |
| 10 | Click 'X' next to last metric | Post Likes chip removed |
| 11 | Click 'X' next to last operator | `−` operator chip removed → formula `[Post Comments] [+] [Shares]` |
| 12 | Click Save | Success modal appeared |
| 13 | Click OK in Success popup | Redirected to `#custom-metrics` list; new row present |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Save button initially disabled | Save `disabled` on fresh Create form | PASS |
| A2 | 4 | Dropdown shows Metrics, Constants, Operators; Operators initially disabled | Metrics / Constant / **Operators disabled** / Parentheses shown | PASS* |
| A3 | 5a | Channels in order: ListenFirst, Facebook, Twitter, YouTube, Instagram, TikTok, Wikipedia | Exact order matched | PASS |
| A4 | 5b | Facebook sub-dropdown shows metrics (channel icon, metric name, DCR key) | e.g. "Post Comments · facebook.page.total_post_comments_c" with FB icon | PASS |
| A5 | 6a | Typing metric name shows matching options | "Post Comments" → facebook.page.total_post_comments_c + tiktok.post.comments_c | PASS |
| A6 | 6b | Selecting metric adds it to formula row (channel icon + metric name only) | Chip = FB icon + "Post Comments" (no DCR key) | PASS |
| A7 | 7a | Selecting metric enables Operators, disables Metrics in dropdown | After metric: Operators enabled; Metrics/Constant/Parentheses disabled | PASS |
| A8 | 7b | + and − operators available | Operators submenu = + − × ÷ (both + and − present) | PASS* |
| A9 | 7c | + operator added to formula row | `+` chip (fa-plus) appended after Post Comments | PASS |
| A10 | 8 | Hover ListenFirst shows up to 10 metrics with scroll bar | 15 metrics; container overflow-y:auto, max-height 450px, clientH 448 < scrollH 756 → scrollbar; ~9 visible (item 50px) | PASS |
| A11 | 10 | Last metric removed from formula row | Post Likes removed; Save disabled (dangling operator) | PASS |
| A12 | 11 | Last operator removed from formula row | `−` removed → `[Post Comments] [+] [Shares]`; Save re-enabled | PASS |
| A13 | 12 | Success popup "Custom metric successfully created!" | Modal "Success" / "Custom metric successfully created!" + Ok | PASS |
| A14 | 13 | Page refreshes, shows saved metric name on Custom Metrics page | Row present: name, desc, Created "Jul. 04 2026", Creator "LFQA Testing", formula `facebook.page.total_post_comments_c + lfm.cross_channel_shares.public_shares_v5` | PASS |

\* Documented spec/UI drifts (not defects, per `settings-custom-metrics` skill + known-quirks):
- **A2:** UI shows "Constant" (singular) vs spec "Constants" (plural); a 4th option **Parentheses** is present (APPS-parentheses v3 feature). Operators-initially-disabled matches spec.
- **A8:** Operators submenu exposes 4 operators (+ − × ÷) via APPS-60358; spec names only + and −, both of which are present (superset).

## Evidence (screenshots under `.playwright-out/QA-85176/`)
- `01-list-page.png` — Custom Metrics list, account Adam Orfei, columns + Create button
- `02-formula-dropdown-initial.png` — Metrics/Constant/Operators(disabled)/Parentheses (A2)
- `03-metrics-channels.png` — channel order (A3)
- `04-facebook-metrics.png` — Facebook metric sub-list, icon+name+DCR key (A4)
- `05-formula-metric-plus.png` — `[Post Comments] [+]` (A9)
- `06-listenfirst-scroll.png` — ListenFirst 15-metric scrolling submenu (A10)
- `07-full-formula.png` — `[Post Comments] [+] [Shares] [−] [Post Likes]`
- `08-formula-after-removals.png` — `[Post Comments] [+] [Shares]` after X-removals (A11/A12)
- `09-success-modal.png` — Success modal (A13)
- `10-saved-row.png` — saved row on list page, search-filtered (A14)

## Scope notes
- No Google Sheets, CSV/TSV/XLS export, or email steps in this case — nothing skipped.
- All steps executed via real UI interaction (typeahead Results, trusted clicks/hovers, explicit chip X-removals). No URL-param shortcuts.

## Bugs filed
None. Product behavior matches spec on all 14 assertions; the two starred items are pre-documented spec/UI copy/feature drifts, not defects.
