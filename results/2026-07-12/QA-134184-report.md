# QA-134184 — Brand > Insights - Interval selection - Quarterly

- **Run:** 2026-07-12 (unattended, headless Playwright MCP, `feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134184
- **Skill reused:** `brand-insights-interval-picker` (v2, untrusted) + `switch-account` (v2)
- **Account / Brand:** Hulu (account_id=336) / Hulu (brand_id=5670)
- **Perspective:** Authorized (`perspective=extended`) — default on load; not material to this UI-behavior case
- **Priority:** Critical (P2)

## Verdict: **PASS** (8/8 assertions)

---

## Steps executed

1. Pre-flight: programmatic email/password login (lfiqa@listenfirstmedia.com) → `#home` rendered.
2. **Account precondition:** session landed on Adam Orfei (54); switched to **Hulu** via LFQA menu → Search Account → typed "Hulu" (React setter) → clicked the sole `.lfm-ta-option` Results row → reloaded on `account_id=336`.
3. **Step 1–2:** Brand top-nav → hovered → clicked **Insights** (`#explore/brand/insights?brand_id=5670`). Page rendered (no Insights renderer hang under Playwright).
4. **Step 3:** Clicked Date Range pill (`Jul. 04, 2026 - Jul. 10, 2026`) → overlay opened with two calendars (Start Date / End Date), Make a Selection = `Auto`, Interval = `Daily`, Select Mode = Active Posts, banner "Historical data is available back to **Jan. 10, 2019**" (Hulu floor).
5. Opened the **Interval** dropdown → options in order: **Daily, Weekly, Monthly, Quarterly** (custom `.lfm-dropdown-option` divs).
6. **Step 4:** Selected **Quarterly**. Both calendars switched to a **month-grid quarter selector** with a **year header (2026)** + `«` prev arrow. Banner rounded to "back to **Apr. 01, 2019**". Auto-selection landed on **Apr(range-start) / May(range) / Jun(range-end)** = Q2 2026 on both calendars; Jul–Dec 2026 `disabled`.
7. **Step 5:** Clicked **Jan** on the Start calendar → range became **Jan(range-start) → Jun(range-end)** = Q1 + Q2 (2026).
8. **Step 6:** Clicked **Feb** (Start) then **May** (End) → range resolved outward to **Jan(range-start) → Jun(range-end)** = full Q1 + Q2.
9. Navigated both calendars from 2026 → **2025** via a single `«` click each (one click = one year → year-granularity nav confirmed).
10. **Step 7:** Selected **Oct** (Start 2025) then **Dec** (End 2025) → range **Oct(range-start) → Dec(range-end)** = Q4 2025 only.
11. **Step 8:** Clicked **Sep** on the Start calendar → range-start auto-extended **backward to Jul** → **Jul(range-start) → Dec(range-end)** = Q3 + Q4 (2025).
12. **Step 9:** Clicked **Jul** (Start) explicitly → range stayed **Jul → Dec** = Q3 + Q4. Clicked **Ok** → applied `from=2025-07-01&to=2025-12-31`; chart X-axis rendered exactly **`Q3 2025`, `Q4 2025`**; date pill "Jul. 01, 2025 - Dec. 31, 2025".

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Quarterly option shown below Monthly | Interval options in order: Daily, Weekly, Monthly, **Quarterly** | PASS |
| A2 | 4a | Start/End date labels display as Quarters | On Quarterly, both calendars render a **month-grid quarter selector** with a **year header (2026)** navigable by year; applied chart X-axis labels quarters (`Q3 2025`, `Q4 2025`) | PASS |
| A3 | 4b | Selecting a quarter auto-selects last complete 3-month period (e.g., Jan–Mar) | On switch, auto-selected **Apr–Jun (Q2 2026)** = the last **complete** quarter (Q3 Jul–Sep in progress on 2026-07-12, disabled); single-month clicks snap to full quarter boundaries | PASS |
| A4 | 5 | Multiple quarters select correctly (Jan–Mar & Apr–Jun) | Jan→Jun selection = **Q1 (Jan–Mar) + Q2 (Apr–Jun)**; Jan=range-start, Feb–May=range, Jun=range-end | PASS |
| A5 | 6 | Partial quarter resolves to full quarters (Feb–May → Jan–Mar & Apr–Jun) | Feb→May resolved outward to **Jan(range-start) → Jun(range-end)** = full Q1 + Q2 | PASS |
| A6 | 7 | Only Q4 (Oct–Dec) displayed for 1 Oct–31 Dec range | Oct→Dec 2025 = **Q4 only** (Oct=range-start, Nov=range, Dec=range-end) | PASS |
| A7 | 8 | Q3 (Jul–Sep) & Q4 (Oct–Dec) for 1 Sep–31 Dec — range extends backward to include partial Q3 | Selecting Sep (start) auto-extended range-start **backward to Jul** → **Jul→Dec = Q3 + Q4** (NOT Q4-only) — matches Philip's APPS-58615 correction | PASS |
| A8 | 9 | Q3 (Jul–Sep) & Q4 (Oct–Dec) displayed for 1 Jul–31 Dec | Jul→Dec = **Q3 + Q4**; Ok applied `from=2025-07-01&to=2025-12-31`; chart X-axis = **`Q3 2025`, `Q4 2025`** | PASS |

## Evidence

- `.playwright-out/QA-134184/01-overlay-open.png` — date overlay, Interval=Daily default, banner Jan. 10 2019.
- `.playwright-out/QA-134184/02-interval-options.png` — Interval dropdown: Daily/Weekly/Monthly/Quarterly (A1).
- `.playwright-out/QA-134184/03-quarterly-selected.png` — Quarterly view; auto-selected Apr–Jun 2026; banner Apr. 01 2019 (A2/A3).
- `.playwright-out/QA-134184/04-jan-jun-two-quarters.png` — Jan→Jun = Q1+Q2 (A4).
- `.playwright-out/QA-134184/05-feb-may-resolves-full-quarters.png` — Feb→May resolved to Jan→Jun (A5).
- `.playwright-out/QA-134184/06-oct-dec-q4-only.png` — Oct→Dec 2025 = Q4 (A6).
- `.playwright-out/QA-134184/07-sep-dec-extends-to-q3q4.png` — Sep→Dec extended back to Jul→Dec (A7).
- `.playwright-out/QA-134184/08-jul-dec-q3q4.png` — Jul→Dec = Q3+Q4 (A8).
- `.playwright-out/QA-134184/09-chart-quarterly-axis.png` — applied chart, X-axis `Q3 2025` / `Q4 2025`.

DOM-level evidence captured per step (month cell classes `range-start`/`range`/`range-end`/`disabled`; year-header `.datepicker-switch`; applied URL `from=2025-07-01&to=2025-12-31`).

## Known bugs checked

- Case "Open linked bugs (2026-07-03): None open. Screen only — run normally." → Rule 7 screen PASS.
- `knowledge-base/bug-history.md` grep QA-134184: **0 open / 0 closed** bugs. Latest prior run 2026-06-04 QA-4325 batch-10 RECONFIRM PASS.
- APPS-58615 (Philip's Sep–Dec ≠ Q4-only correction) is the **spec basis** for A7, not an open defect — behavior reproduced correctly (Sep–Dec extends backward to full Q3).
- Brand>Insights renderer hang (Chrome-MCP-era quirk) did **not** reproduce under Playwright; page and chart rendered within budget.

## Bugs filed

None. All 8 assertions passed; no new defects observed.
