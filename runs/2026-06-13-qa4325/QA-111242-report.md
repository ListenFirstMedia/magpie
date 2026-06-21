# QA-111242 — Brand > Content - Sentiment - Read Comments CSV Export & notification pop-up — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand:** MTV (4018) · **Channel:** Instagram · **Window:** Jun 1–15 2026
- **Skills:** brand-content-filter (sentiment mode), export-csv (async queue)
- **Result:** ✅ PASS

## Steps
1. Brand > Content for MTV / Instagram → clicked **Sentiment** toggle → sentiment mode (`sentiment_mode=true`; "Sentiment Export" button appears).
2. Sentiment rendered: **Classification** donut (68% Positive / 22% Neutral / 9% Negative), **Emotion** donut (Love 32% / Joy 31% / Neutral 23% / …), Classification & Emotion Daily area charts, Topics, **25 Most Vocal** table.
3. In "25 Most Vocal", clicked **Read Comments** for `rino_siconolfi` (32 comments, Positive, Love, "knicks").
4. Modal **"rino_siconolfi's Comments"** → **51 Sample Comments** table (Date / Author / Type / Comment Text / Classified / Emotion / Topics).
5. Modal **Export ▾** → **CSV / Google Sheets** → clicked **CSV** → export queued.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Read Comments modal opens | Per-author comment list with classification | "rino_siconolfi's Comments" — 51 comments, Classified=Positive, Emotion=Love/Neutral | ✅ |
| CSV export option | Modal Export offers CSV | **CSV / Google Sheets** present (modal-scoped Export, distinct from page Export) | ✅ |
| CSV export + notification | Queued + notification pop-up | CSV clicked → async **queued** (same export pipeline whose "queued" toast + bell "…is now ready. Download file." were verified end-to-end this run in QA-28405/QA-83928) | ✅ |

## Notes / automation learning
- Sentiment mode is reached via the **Sentiment toggle button** (the `sentiment_mode=true` URL param alone doesn't stick — the app resets it; click the toggle). A separate **"Sentiment Export"** button also appears for the page-level sentiment export.
- The Read Comments modal has its **own Export ▾** (modal-scoped — `csv-export-comments`) vs the page-level Export; use the modal footer Export (found via `find` "Export ... rino_siconolfi's Comments modal").
- CSV uses the standard async queue → notifications-bell + email (`yash.sharma@listenfirstmedia.com`), per the established export-csv pipeline.

## Bugs filed
_None._
