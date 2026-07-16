# QA-99380 — Brand > Content - Daily Post Analysis Modal - Graph Display & Behavior

- **Run:** 2026-07-11 (unattended, headless, Playwright MCP)
- **Verdict:** **PASS (5/5)**
- **Account:** Adam Orfei (account_id=54) — switched from default UCLA via LFQA menu → Search Account typeahead ("Results" header confirmed, Rule 1)
- **Brand:** MTV (brand_id=4018) — default brand on Adam Orfei; satisfies precondition ("Adam Orfei or MTV")
- **Surface:** Brand > Content, Public data set, In Window mode
- **Date Range:** Last 30 Days → Jun. 11, 2026 – Jul. 10, 2026 (page); DPA modal auto-extends per post
- **Skill reused:** `brand-content-dpa-modal` (v1) + `chart-hover-tooltip` (v3, al-area-chart data-circle tooltip)

## Steps executed

1. Logged in via Cognito "With existing account" form (config/.env). Landed on `/#home` (account 799 = UCLA).
2. Navigated to Brand > Content; auto-selected UCLA. Switched account to **Adam Orfei** via LFQA menu → Search Account → typed "Adam Orfei" slowly → Results header → clicked result. Reloaded to account_id=54.
3. Navigated to Brand > Content on Adam Orfei → default brand **MTV** (brand_id=4018).
4. Set Date Range picker → "Make a Selection" → **Last 30 Days** (Jun 11 – Jul 10, 2026). 247 posts loaded.
5. Opened Daily Post Analysis modal on the **top-ranked post** (TikTok, "Music to Blank to", Fri Jul 03 2026, 274,935 Engagements) via `button.daily-analysis-button[0]`.
6. Modal opened in **Line** view; header `Date Range: Jul. 03 – Jul. 10, 2026 / Mode: In Window / Data Set: Public / Graph Metrics: 6 Metrics`. Chart-type dropdown offers **Line / Area / Bar / Pie**.
7. Verified graph renders all 8 in-range days (Jul 03→Jul 10), X-axis date labels, Y-axis 0–550K.
8. Hovered the Jul 04 data point (synthetic mouseover/mousemove on `circle.data-circle.engagements-0`) → tooltip `.chart-tooltip__header "Jul. 04, 2026"` + `.chart-tooltip__row "Engagements: 112,007"` (matches table).
9. Switched metric via **Graph Metrics** dropdown: unchecked Engagements/Reactions/Comments/Shares/Video Response Rate → left **Video Views** only → label became "1 Metric", legend + line repopulated to a single Video Views series.
10. Switched chart type **Line → Bar** (chart-type dropdown → Bar) → per-day Video Views bars re-rendered (Jul 04 ~547K peak, Jul 08 = 0/no bar), axis labels persisted.
11. Closed modal. Opened a **non-TikTok (Facebook)** post's DPA modal (`daily-analysis-button[1]`, "…KNICKS IN FIVE", Sat Jun 13 2026) → window Jun 15 – Jul 10, 2026 (26 days). Read full table: **every day, every metric has real numerics — zero endash.**
12. Closed modal.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Open modal | Modal opens with a Line/Graph view option | Modal opened in Line view; chart-type dropdown exposes Line/Area/Bar/Pie | **PASS** |
| A2 | Graph render | Graph shows all in-range days with axis labels | TikTok post: 8 days Jul 03→10; FB post: 26 days Jun 15→Jul 10; X = `Mon. DD` date labels, Y = numeric ticks (0–550K / 0–1.1M) | **PASS** |
| A3 | Hover point | Tooltip displays date + metric value | Jul 04 point → `Jul. 04, 2026` / `Engagements: 112,007` (== table cell 112,007) | **PASS** |
| A4 | Switch metric | Graph repopulates | Graph Metrics 6→1 (Video Views only): legend + single line repopulated; Line→Bar re-rendered per-day bars matching table | **PASS** |
| A5 | Endash check | No unexpected endash for non-TikTok dates | FB post: 0 endash across all 26 days / 6 metrics. TikTok post: endash only on trailing incomplete day (Jul 10, data last updated 07-11 05:08 AM) + Video Response Rate on Jul 08 (Video Views=0 → undefined rate) — both expected, not spurious | **PASS** |

## Evidence

**TikTok top post (Music to Blank to, Jul 03 2026), In Window, Public — table:**

| Metric | Sum | Avg | Jul 03 | Jul 04 | Jul 05 | Jul 06 | Jul 07 | Jul 08 | Jul 09 | Jul 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| Engagements | 274,935 | 34,367 | 10,867 | 112,007 | 53,032 | 43,273 | 22,026 | 10,801 | 22,929 | – |
| Reactions | 266,200 | 33,275 | 10,500 | 108,300 | 51,300 | 42,000 | 21,400 | 10,500 | 22,200 | – |
| Comments | 999 | 125 | 39 | 413 | 228 | 129 | 60 | 39 | 91 | – |
| Shares | 7,736 | 967 | 328 | 3,294 | 1,504 | 1,144 | 566 | 262 | 638 | – |
| Video Views | 1,500,000 | 187,500 | 58,500 | 547,900 | 282,400 | 211,200 | 200,000 | 0 | 200,000 | – |
| Video Response Rate | N/A | 12.60% | 18.58% | 20.44% | 18.78% | 20.49% | 11.01% | – | 11.46% | – |

- Jul 10 endash (all metrics): trailing/most-recent day, full-day data not yet aggregated (Data Last Updated PT 07-11-2026 05:08 AM). Expected.
- Video Response Rate Jul 08 endash: Video Views = 0 that day → rate undefined. Expected (zero-denominator).

**Facebook post (KNICKS IN FIVE, Jun 13 2026), 26-day window Jun 15 – Jul 10:** all 6 metrics populated for every day, **no endash anywhere** (e.g. Engagements 18,147 … 3,182; Video Views 378,877 … 38,813; Video Response Rate 7.55% … 8.20%). Confirms A5.

Screenshots (`.playwright-out/QA-99380/`): `06-dpa-modal-open.png` (Line, 6 metrics), `07-tooltip-jul04.png` (A3 tooltip), `08-metrics-dropdown.png` (6 checkboxes), `09-single-metric-videoviews.png` (A4 repopulate), `10-bar-chart.png` (Line→Bar), `12-facebook-post-no-endash.png` (A5 non-TikTok).

## Known bugs checked

- **bug-history.md QA-99380:** "Open bugs (0) — None." Rule 7 open-bug screen → passed (no open linked bug).
- **DATA-12209** (Bug, Major, **Open**) — Daily Post Analysis TikTok metrics showing endash on **May 16, 2026** (Amazon Prime Video / MTV). **Out of scope this run:** the Last-30-Days window (Jun 11 – Jul 10, 2026) does not include May 16, so DATA-12209 cannot reproduce here. The endashes observed on the TikTok post are fully explained by trailing-incomplete-day + zero-video-views-rate and are NOT the DATA-12209 signature. Does not interfere with any assertion.

## Bugs filed

- None. All assertions passed.
- Minor note (not a product bug): a synthetic-hover tooltip injected during A3 persisted visually after the metric switch and into the second modal (stale "Jul. 04 / Engagements: 112,007" overlay). This is an artifact of the automated synthetic mouse-event injection, not user-visible product behavior — not filed.
