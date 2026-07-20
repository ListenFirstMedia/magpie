# QA-520 — Facebook Content - Table Data Set - Authorized & UnAuthorized

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-520 · Priority: Blocker
- **Result:** **PASS** — all assertions (A4, A5, A7) verified.
- **Account:** Adam Orfei (account_id=54) · **Brand:** Star Wars (brand_id=75007) · Facebook only · Impressions data set · Authorized perspective (Star Wars is unauthorized → data locked)
- **Skills:** brand-content-data-set-selector (stable), brand-content-table-view

## Known bugs checked (pre-run)
- 0 open bugs. Closed regressions to watch: APPS-60826 (Reach sum "-"), APPS-52583 (Public-brand reload tile), APPS-43226 (Paid-Impressions avg value). None reproduced (no reload tile; aggregate values as expected).

## Steps executed
1. Brand > Content (Adam Orfei). ✅
2. Brand → **Star Wars**; **Facebook only** (disabled the other 5 channels + Apply → `channels=facebook`). ✅
3. Data Set → **Impressions** (`table_data_set=impressions`). ✅
4. **Table View**. ✅
5–7. Reviewed aggregate Sum; toggled Average. ⚠ (see A7)

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Only Engagements shows a value; other metrics show Lock | Sum row: **Engagements 3,423**; all other metrics locked (32 `.fa-lock` icons; per-post only Engagements populated: 1,625 / 921 / 522…) | ✅ PASS |
| A5a | Engagement Rate, Reach, Organic Reach, Paid Reach, Engaged User Rate = **N/A** (sum) | All = **N/A** | ✅ PASS |
| A5b | Impressions, Organic Impressions, Paid Impressions = **"0" or "-"** (sum) | All = **–** | ✅ PASS |
| A7 | Aggregate **Average**: all metrics "-" except Engagements | Average row: **Engagements 856** (= 3,423 ÷ 4); all other metrics = **–** | ✅ PASS |

## Evidence
Aggregate Sum row (Impressions data set, Facebook, Star Wars, Authorized): `Engagements 3,423 | Engagement Rate N/A | Impressions – | Organic Impressions – | Paid Impressions – | Reach N/A | Organic Reach N/A | Paid Reach N/A | Engaged User Rate N/A`. 32 lock icons on the metric cells.

## Notes / findings (for skills)
- **Brand>Content brand change:** click the **chevron next to the heart** (`.brand-selector-dropdown-container i.fa-chevron-down`, trusted click) → a **`textarea.lfm-textarea` placeholder "Search for a Brand"** appears (set via React setter; NOT an `<input>`) → click the `.lfm-ta-option` result.
- **Channel selector:** `.channel-ghost.<name>.enabled` toggles need **trusted clicks** (synthetic no-op); after selecting, click **Apply**.
- **Data Set dropdown** (`.lfm-dropdown-select-box`) needs a **trusted click** to fully render the option list (synthetic click showed a truncated list); options include Impressions, Video Views, Clicks, etc.
- **Aggregate Sum/Average toggle only renders in TABLE VIEW.** It lives in `.aggregate-row-toggle-container` (labels "Sum"/"Average") — click its inner `label.toggle-switch-label` (trusted click) to flip Sum↔Average. Do NOT grab a global `.toggle-switch-label` — the FIRST one is the **Public/Authorized perspective** toggle (mis-clicking it changes perspective + resets data set/channels). Scope to `.aggregate-row-toggle-container`.
- Sum row (Impressions/FB/Star Wars/Authorized): Engagements 3,423, others N/A (rates) / – (impressions). Average row: Engagements 856, all others –.

## Bugs filed
None. All assertions passed.
