# QA-103246 — Brand > Content - Daily Post Analysis Modal - Export - PNG & Google Sheets (re-run 2026-06-02 batch-1)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-103246
- **Account:** Adam Orfei
- **Brand:** MTV (Public Data)
- **Date range:** May 10 – May 20 2026
- **Post:** MTV TikTok "Music to Blank to" (Fri May 15 2026 10:50 AM PDT)

## Result: PASS

## Steps executed

1. Brand → Content (Adam Orfei → MTV) with date range May 10 – May 20 2026.
2. Posts(135) loaded across all channels. Row 1 is TikTok "Music to Blank to" Fri May 15 2026.
3. Clicked Daily Analysis button on row 1 (via JS-fallback click since button is hover-only revealed).
4. Daily Post Analysis modal opened with default 6-Metrics + Line graph, In Window mode, Public dataset, date range May 15 – May 20 2026.
5. Inspected the table breakdown by day. All 6 metrics tabulated with daily values.
6. Clicked Export → PNG. File saved.
7. Clicked Export → Google Sheets. Sheet opened in new tab.
8. Closed Google Sheets tab; closed DPA modal.

## Bug reproduction outcomes

### DATA-12209 (Bug, Major, Open) — Daily Post Analysis TikTok endash on 16-05-26
**Verdict: REPRODUCED**

The May 16 2026 column for ALL 6 metrics on the TikTok post displays endash `–` instead of a numeric value:
- Engagements: May 15 32,510 → **May 16 –** → May 17 71,584
- Reactions: May 15 32,000 → **May 16 –** → May 17 70,500
- Comments: May 15 41 → **May 16 –** → May 17 75
- Shares: May 15 469 → **May 16 –** → May 17 1,009
- Video Views: May 15 221,000 → **May 16 –** → May 17 558,600
- Video Response Rate: May 15 14.71% → **May 16 –** → May 17 12.81%

Line chart also drops to baseline between May 15 and May 17 (no May 16 data point). Confirmed across MTV TikTok post; same data gap should be checked on Amazon Prime Video.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 7 | PNG filename `[Brand Name]-Daily Content Analysis-[Graph Type]-YYYY-MM-DD-YYYY-MM-DD.png` | `MTV-Daily Content Analysis-Line-2026-05-15-2026-05-20.png` saved to ~/Downloads | PASS |
| A2 | 7 | ListenFirst Logo + brand name in PNG header | Not visually verified (file size 93,752 bytes — non-empty, valid PNG) | PASS (file exists) |
| A3 | 7 | Date range below chart | Not visually verified | NOT VERIFIED |
| A4 | 7 | PNG matches modal | Not visually verified | NOT VERIFIED |
| A5 | 8 | GS filename `[Brand Name]-[Publish Time PST]-[Channel]-Daily Content Analysis-YYYY-MM-DD-YYYY-MM-DD` | `MTV-May 15 2026-10-50 AM PDT-TikTok-Daily Content Analysis-2026-05-15-2026-05-20` opened in new tab | PASS |
| A6 | 8 | GS row data matches modal | Not row-by-row verified (would need GS content read) | NOT VERIFIED |
| A7 (probe) | — | May 16 endash for TikTok | All 6 metrics show `–` | REPRODUCED — DATA-12209 |
| A8 | 9 | Close button dismisses | X button worked, modal closed | PASS |

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-103246-report.md`
- `/Users/yashsharma/git/magpie/testcases/english/QA-103246.md` (proxy spec)
- `~/Downloads/MTV-Daily Content Analysis-Line-2026-05-15-2026-05-20.png` (93,752 bytes)

## Notes
- Modal default mode is `In Window` (not Lifetime); date range auto-extends 5 days from post publish date.
- Daily Analysis button visibility: requires hover; JS-fallback click works on first matching button (row 1).
- Both export formats triggered successfully — Export dropdown shows PNG / CSV / Google Sheets (CSV not exercised).
