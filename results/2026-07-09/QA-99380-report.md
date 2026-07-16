# QA-99380 — Brand > Content - Daily Post Analysis Modal - Graph Display & Behavior

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account/Brand:** Adam Orfei (account_id=54) · MTV (brand_id=4018) · Brand > Content · 30-day range (Jun 9 – Jul 8, 2026)

## Verdict: PASS

## Known bugs checked
No open linked bug.

## Flow
Brand > Content (MTV, 30 days) → clicked a post's **Daily Analysis** button (`button.daily-analysis-button`) → **Daily Post Analysis** modal opened for an MTV TikTok video post (Jul 03, 2026; Engagements 252,006 / Video Views 1,300,000).

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Modal opens with a Line/Graph view | modal "Daily Post Analysis" opened with a **Line** graph (Line/Table toggle present) | PASS |
| A2 | Graph shows all in-range days with axis labels | Line chart over **Jul 03–08** (x-axis date labels), y-axis 0–550K; 6-metric legend (Engagements, Reactions, Comments, Shares, Video Views, Video Response Rate); Video Views peaks ~548K on Jul 04 | PASS |
| A3 | Hover tooltip displays values | hovering a data point shows **"Jul. 08, 2026 / Comments: 39"** (date + metric value) | PASS |
| A4 | Switching metric repopulates graph | unchecking **Reactions** in the Graph Metrics dropdown changed the label **"6 Metrics" → "5 Metrics"** and the graph repopulated | PASS |
| A5 | No unexpected endash for non-TikTok dates | per-day table all numeric (Comments 39/413/228/129/60/39; Video Views …/200,000/0); Video Response Rate **Sum = N/A** (rate not summable, expected); no stray endash | PASS |

## Data table (cross-check)
Metric / Sum / Avg / Jul03–08: Engagements 252,006 / 42,001 / 10,867·112,007·53,032·43,273·22,026·10,801 · Comments 908 / 151 / 39·413·228·129·60·39 · Video Views 1,300,000 / 216,667 / 58,500·547,900·282,400·211,200·200,000·0 · Video Response Rate N/A / 14.88% / 18.58%·20.44%·18.78%·20.49%·11.01%.

## Evidence
- `QA-99380-modal.png` (modal + Line graph + table), `QA-99380-hover.png` (data-point tooltip "Jul. 08, 2026 Comments: 39")

## Bugs filed
None.

## View state note
Account back on Adam Orfei (54). Daily Analysis modal is view-only (no persisted change).
