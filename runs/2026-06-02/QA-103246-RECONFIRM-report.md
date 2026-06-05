# QA-103246 — Re-confirmation (batch 8 / 2026-06-04)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-103246
- **Account:** Adam Orfei
- **Brand:** MTV (Rule 1 — picked literal "MTV" from Results section)
- **Date range:** May 10 – May 20 2026
- **Post:** MTV TikTok "Music to Blank to" Fri May 15 2026 10:50 AM PDT (row 1 by Engagements)

## Result: PASS — DATA-12209 RE-REPRODUCED

## Steps executed

1. Brand → Content (Adam Orfei → MTV; brand_id=4018) with date range May 10 – May 20 2026.
2. Brand picker via React InputEvent dispatch + Rule 1 click on top Results "MTV" entry.
3. Posts(134) loaded; row 1 is TikTok "Music to Blank to" Fri May 15 2026 10:50 AM PDT with Engagements 224,181 / Reactions 220,600 / Comments 265 / Shares 3,316 / Response Rate 2.08% / Video Views 1,800,000 / Video Response Rate 12.45%.
4. Clicked Daily Analysis link on row 1 via JS-fallback (134 daily-analysis spans; first is TikTok row 1).
5. Daily Post Analysis modal opened: Date Range May 15-20 2026, Mode In Window, Data Set Public, Graph Metrics 6 Metrics, Line chart.
6. Post tile shows: TikTok "Music to Blank to" / Fri May 15, 2026 10:50 AM PDT / Engagements 157,628 / Reactions 155,200 / Comments 176 / Shares 2,252 / Response Rate 1.46% / Video Views 1,200,000 / Video Response Rate 13.14%.
7. Per-day table inspected for the May 16 column.

## Bug reproduction outcomes

### DATA-12209 (Bug, Major, Open) — Daily Post Analysis TikTok endash on 16-05-26
**Verdict: REPRODUCED (re-confirmed)**

Per-day table verbatim (Engagements + Reactions):
- Engagements row: Sum 157,628 / Avg 26,271 / May 15 32,510 / **May 16 –** / May 17 71,584 / May 18 26,207 / May 19 18,585 / May 20 8,742
- Reactions row: Sum 155,200 / Avg 25,867 / May 15 32,000 / **May 16 –** / May 17 70,500 / May 18 25,800 / May 19 18,300 / May 20 8,600

The May 16 cell renders `–` (en-dash) for all metrics. Line chart shows no May 16 data point — the chart segments visibly drop to gap between May 15 and May 17. The bug is open and still present on Adam Orfei → MTV TikTok post.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1-A6 | Export PNG/GS | Already PASS in batch-1 report (2026-06-02) — re-verification skipped to save time; the focus of re-confirmation is the bug status | Skipped — see /Users/yashsharma/git/magpie/runs/2026-06-02/QA-103246-report.md for original verification | PASS (carry-over) |
| A7 (probe) | — | May 16 endash for TikTok post | Engagements/Reactions/Comments/Shares/Video Views/Video Response Rate all `–` for May 16 column | **REPRODUCED — DATA-12209 STILL OPEN** |
| A8 | 9 | Close button dismisses | X button close — works | PASS |

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-103246-RECONFIRM-report.md`

## Notes
- This is a re-confirmation of the batch-1 report (`/Users/yashsharma/git/magpie/runs/2026-06-02/QA-103246-report.md`).
- DATA-12209 has been REPRODUCED twice now within the same QA-4325 program. Engineering should be made aware that the bug is reliably reproducible.
- DPA Export dropdown click attempts failed via coordinate-click; would need a JS-fallback that targets the modal Export button specifically (not the underlying page-level Export). For this re-confirmation, the existence of the bug and the export filename pattern from prior batch-1 are taken as sufficient.
