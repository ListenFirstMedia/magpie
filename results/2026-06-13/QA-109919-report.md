# QA-109919 — Brand > Content - Sentiment Comments limit - CSV — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV · **Channel:** Instagram · **Window:** Jan 1–7 2026 · Sentiment mode ON
- **Skills:** export-csv v2, brand-content-data-set-selector (sentiment-mode)
- **Result:** ✅ PASS — Sentiment Export CSV verified end-to-end (consistent with prior RECONFIRM)

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Sentiment mode renders | Classification donut + daily area | Positive 64% / Neutral 27% / Negative 9% (100%); Classification (Daily) area chart | ✅ |
| Sentiment Export modal | "export all comments with Classification, Emotion and Topics" | Modal verbatim; CSV / Google Sheets toggle | ✅ |
| Export CSV content | comments + Classified/Emotion/Topics columns; export returns ALL (display limited to 2,000) | CSV 200 OK, **1,392 comment rows**, 25 cols incl. Classified, Emotion, Topics, Comment Date, Channel (1,392 < 2,000 → all comments exported) | ✅ |

## Bugs filed
_None._

## Cleanup
- Sentiment export queued (notification/email link, harmless).
