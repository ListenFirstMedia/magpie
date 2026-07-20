# QA-116140 — Brand Sentiment - Sentiment Export CTA — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV · **Channel:** Instagram · Sentiment mode ON
- **Result:** ✅ PASS — verified via the Sentiment Export run this session (see QA-109919)

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Sentiment Export CTA present + opens modal | "Sentiment Export" button in Sentiment mode | Present next to "Sentiment"; click opens "Sentiment Export" modal ("export all comments with Classification, Emotion and Topics"; CSV/Google Sheets toggle; email to lfiqa@listenfirstmedia.com) | ✅ |
| Export initiates | Ok queues the export | Export queued + surfaced (CSV fetched, 1,392 rows — see QA-109919) | ✅ |

## Bugs filed
_None._
