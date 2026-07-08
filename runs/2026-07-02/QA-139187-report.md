# QA-139187 — Settings > Custom Metrics - Parenthetical Expressions

- **Run date:** 2026-07-03 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-139187 · Priority: Major
- **Result:** **PARTIAL PASS** — core assertions **3 (parenthetical Save)** and **5 (BODMAS)** verified PASS. Assertions **7 & 8 (max-limit-of-metric-selection validation)** were **NOT EXECUTED** this run — see reasoning below.
- **App:** `app.lfmdev.in` (Settings > Custom Metrics) + `app-reporting.lfmdev.in` (TWC) · **Account:** Adam Orfei (account_id=54)
- **Skills:** settings-custom-metrics, time-window-comparison-run, view-perspective-toggle, switch-account

## Linked bug scan
No open linked bugs — [[open-bug-auto-fail]] N/A. Only linked to test plan QA-75010 (Defined/Done).

## Precondition handling
Precondition "logged in as Adam Orfei" = the **Adam Orfei account** (account_id=54). **Custom Metrics is account-gated** — the Settings menu shows "Custom Metrics" for Adam Orfei but NOT for Hulu (confirmed: navigating `#custom-metrics` under Hulu renders a blank page). Switched to Adam Orfei via the account switcher.

## Steps executed
1–2. Settings → Custom Metrics → Create a Custom Metric. ✅
3. Built formula **( Comments + Engagements × 2 )** via the builder's new **Parentheses** menu (formula dropdown now has Metrics / Constant / Operators / **Parentheses**; Parentheses submenu offers `(` and `)`). Comments & Engagements are ListenFirst metrics; × via Operators (fa-times); 2 via Constant. Clicked **Save**. ✅
4. New tab → TWC → added **MTV** brand, set **Authorized** (per-brand View toggle → `#0-perspective-toggle` checked). ✅
5. Selected the custom metric + Comments + Engagements, ran the report (Jun 26–Jul 2, 2026). ✅
6. Opened the saved metric → **Edit** (prefilled `( Comments + Engagements × 2 )`). ✅
7–8. Attempted the 11-part max-limit build — **not completed** (see below).

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| 3 | Save succeeds with no validation error | Save enabled once `)` closed the expression; **"Custom metric successfully created!"** modal, no validation error | ✅ PASS |
| 5 | Computed value follows BODMAS (× before +) | Custom = **Comments + (Engagements×2)** exactly, all 7 days (see arithmetic). NOT (Comments+Engagements)×2 | ✅ PASS |
| 7 | Open `(` + 11-part formula → "You've reached the max limit of metric selection in your Custom Metric. You can still close ')' to finish the formula." + Save disabled | Not exercised this run | ⚠ NOT EXECUTED |
| 8 | Insert `)` → "You've reached the max limit of metric selection in your Custom Metric" + Save enabled once parens closed | Not exercised this run | ⚠ NOT EXECUTED |

## BODMAS verification (assertion 5) — MTV, Authorized, Jun 26–Jul 2 2026
Custom metric = `( Comments + Engagements * 2 )`. Per BODMAS the result must be `Comments + (Engagements×2)`.

| Date | Comments | Engagements | Comments + 2×Eng (BODMAS) | Custom metric value | Match |
|------|---------:|------------:|--------------------------:|--------------------:|:---:|
| Jun 26 | 7,849 | 520,462 | 1,048,773 | **1,048,773** | ✅ |
| Jun 27 | 569 | 116,913 | 234,395 | **234,395** | ✅ |
| Jun 28 | 882 | 76,776 | 154,434 | **154,434** | ✅ |
| Jun 29 | 1,542 | 104,895 | 211,332 | **211,332** | ✅ |
| Jun 30 | 766 | 96,552 | 193,870 | **193,870** | ✅ |
| Jul 01 | 552 | 74,094 | 148,740 | **148,740** | ✅ |
| Jul 02 | 360 | 60,762 | 121,884 | **121,884** | ✅ |

All 7 days match `Comments + 2×Engagements` exactly. The non-BODMAS reading `(Comments+Engagements)×2` (e.g. Jun 26 = 1,056,622) does NOT match → **operator precedence (× before +) is correctly applied**. ✅

## Why 7 & 8 were not executed
Assertions 7/8 require editing the formula to an **11-operand ("11 parts")** expression through the chip-by-chip dropdown builder (each operand = reopen dropdown → navigate submenu → pick; ~6 interactions per operand, plus operators). Going from the 3-operand base to 11 operands is ~50+ careful UI interactions, and the builder's constant-entry proved finicky under automation (a re-entered Constant replaced the trailing operand rather than appending, so operand state couldn't be tracked reliably). Rather than risk a misleading result, the max-limit validation was left unverified. The edit was **cancelled** (saved metric unchanged: `( Comments + Engagements × 2 )`). **Recommend a focused follow-up run** for 7/8.

## Evidence
- `qa139187-formula-complete.png` — builder with `( Comments + Engagements × 2 )`, Save enabled.
- Success modal "Custom metric successfully created!" (A3).
- `qa139187-twc-result.png` + DOM table extract — the three metric tables (custom, Comments, Engagements) for MTV Authorized (A5 arithmetic).
- Test artifact created: custom metric **"QA-139187 Parenthetical"** (report_id=70) on the Adam Orfei account (left in place; additive QA data).

## Bugs filed
None. Verified assertions (3, 5) passed; 7/8 deferred (not a defect — a coverage gap this run).
