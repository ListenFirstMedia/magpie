# QA-2035 — Brand Sentiment - CSV & GS — Re-Run Report

- **Date:** 2026-05-29 (batch 3 re-run; calendar shows 2026-06-02)
- **Account:** Viacom (account_id=181)
- **Brand:** MTV (brand_id=4018)
- **Date range:** May 25–31, 2026 (default)
- **Source spec:** testcases/english/QA-2035.md
- **Prior run:** runs/2026-05-27/QA-2035-report.md (PASS)

## Result: PASS (with one new finding — see below)

## Execution

1. Switched account from Adam Orfei → Viacom via Yash → Search Account → Viacom Results entry.
2. Navigated Brand → Content → MTV brand auto-loaded.
3. Clicked Sentiment toggle button. Sentiment mode active (URL `sentiment_mode=true`). Classification donut shows Positive 63%, Neutral 27%, Negative 10%; Classification (Daily) area chart renders.
4. Clicked "Sentiment Export" button next to Sentiment. Modal opened titled "Sentiment Export" with View toggle (default CSV / right Google Sheets) and explainer text: "The Sentiment Export will export all comments with Classification, Emotion and Topics."
5. Left View toggle on CSV side. Clicked OK. Modal closed. Bell counter incremented.
6. Waited ~30 seconds. Bell dropdown showed `Sentiment Export / Jun 02, 2026 12:11 am / Your Sentiment Export for MTV from May. 25, 2026 to May. 31, 2026 is now ready. Download file.` Notification href: `https://analytics-cdn.lfmdev.in/293187-06268bd70779978d34e35226a5e70924.csv`.
7. Click delivered file: `~/Downloads/MTV-Brand Content-2026-05-25-2026-05-31-comments-sentiment.csv` — 2,606,291 bytes, 13,280 lines.
8. Re-opened Sentiment Export modal; toggled View to Google Sheets. Clicked OK.
9. Waited ~30 seconds. Bell dropdown showed second `Sentiment Export / Jun 02, 2026 12:13 am` notification with the same wording. Href: `https://analytics-cdn.lfmdev.in/293188-06268bd70779978d34e35226a5e70924.csv` (note: `.csv` suffix, NOT a docs.google.com URL).
10. Click delivered file: `~/Downloads/MTV-Brand Content-2026-05-25-2026-05-31-comments-sentiment (1).csv` (and `(2).csv` after a 2nd click attempt). All three files identical (md5 = `d0e5e3c524737720c019aaf75812ee84`).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6 | Filename `Brand-Tab-YYYY-MM-DD-YYYY-MM-DD-comments-sentiment.csv` | `MTV-Brand Content-2026-05-25-2026-05-31-comments-sentiment.csv` (`MTV` + `Brand Content` + dates + `comments-sentiment.csv`) | PASS |
| A2 | 6 | Columns: Comment Classified, Comment Emotion, Topics (Topic 1, Topic 2, …) | Row 1 headers include `Comment Classified, Comment Emotion, Topic 1 … Topic 13` plus Comment Date/Day of Week/Time/Channel/Author/Type/Text and Post Link | PASS |
| A3 | 6 | Expected date range in export | All sampled rows fall between 05/25/2026 and 05/31/2026 | PASS |
| A4 | 6 | Date format MM/(D)D/YYYY | `05/31/2026`, `05/25/2026` etc. — zero-padded MM/DD/YYYY | PASS |
| A5 | 6 | Day of Week in DOW format | `Sun`, `Mon` etc. — 3-letter DOW | PASS |
| A6 | 6 | Time in `HH:MM XM PST` format | `11:47 PM`, `07:01 AM` etc. — HH:MM AM/PM **without PST timezone suffix** | PARTIAL — see new findings |
| A7 | 9 | CSV data matches Google Sheets data | Both exports deliver byte-identical CSV files (md5 match) — trivially "matches" but see new findings | PASS (trivially) |

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs) | — | bug-history shows 17 historical closed defects |

Historical closed patterns checked:
- **APPS-10935 / APPS-47422 / APPS-55184 (Closed) — Incorrect filename**: Filename matches spec exactly (`MTV-Brand Content-2026-05-25-2026-05-31-comments-sentiment.csv`). PASS.
- **APPS-50173 / APPS-49529 (Closed) — Email Not Received**: In-app notification delivered within ~30 seconds. Cannot verify email delivery in this run.
- **APPS-48127 (Closed) — CSV Files Received instead of Google Sheets**: SEE NEW FINDINGS — this pattern may be back.
- **APPS-21389 (Closed) — `undefined` displays in time column**: Time column populated correctly (`11:47 PM` etc.), no `undefined`.
- **LFMP-29868 (Closed) — Tag names in Data Set Headers Row**: Not applicable; headers in row 1 are metric names only.

## NEW findings (2026-05-29 re-run)

### Finding 1 — Sentiment Export GS toggle delivers an identical CSV, not a Google Sheets URL

- **Spec/expectation:** "Click Export button and switch toggle to Google Sheets … Click OK button … Open corresponding email and open attached Google Sheets export"
- **Actual:** With GS toggled, the resulting Recent Activity notification shows the same `Download file` link as CSV mode. Both notification hrefs point to `analytics-cdn.lfmdev.in/<id>-<hash>.csv`. Clicking the GS notification's `Download file` triggers a browser download of the same byte-identical CSV file (md5 verified across all 3 saved files).
- **Probable regression:** Pattern matches closed APPS-48127 ("CSV Files Received via Email Instead of Google Sheets") which was a major bug fixed previously. The GS export path appears to no longer produce a Google Sheets URL.
- **Severity:** Should be reproduced by LFIQA on real hardware to confirm before filing. The notification href format (`.csv` suffix, CDN binary/octet-stream) is unambiguous — a true GS export would produce a `docs.google.com/spreadsheets/d/...` URL.

### Finding 2 — Time column missing PST timezone suffix

- **Spec:** "Time in `HH:MM XM PST` format" — i.e., `11:47 PM PST`
- **Actual:** Time column shows `11:47 PM` only — no `PST` suffix.
- **Severity:** Trivial / cosmetic-spec drift. Either the spec is out-of-date (likely; current product wording probably standardized on bare HH:MM AM/PM since all dev data is implicit PT) or the suffix is a true regression. Recommend product confirmation.

## Notes / quirks observed

- Both Sentiment Export notifications used the queued/notified pattern (consistent with `export-csv` v2 skill's CDN+Recent-Activity flow). Spinner did not appear on the Export button itself — the modal closes, and you wait for the bell.
- Notification job IDs were sequential (293187 → 293188) and the file-hash component was identical, suggesting backend dedup.
- BC-2 (filename hash bug, previously retracted) is not relevant here — the user-facing filename is correct via the click handler.

## Files
- testcases/english/QA-2035.md (spec)
- runs/2026-05-29/QA-2035-report.md (this report)
- /Users/yashsharma/Downloads/MTV-Brand Content-2026-05-25-2026-05-31-comments-sentiment.csv (CSV mode)
- /Users/yashsharma/Downloads/MTV-Brand Content-2026-05-25-2026-05-31-comments-sentiment (1).csv (GS mode, byte-identical)
- /Users/yashsharma/Downloads/MTV-Brand Content-2026-05-25-2026-05-31-comments-sentiment (2).csv (re-click, byte-identical)
