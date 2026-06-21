# QA-19950 — Brand Content - CSV - All Data set - Impressions — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** University of California, Los Angeles (brand_id=127756) · **Date:** Dec 25 2024 · **Data Set:** Impressions
- **Result:** ✅ PASS — **upgrades prior 2026-06-05 BLOCKED** (no sentiment-mode lock this run; export verified end-to-end). LFMP-31979 **NOT reproduced**.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Export includes Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate | CSV (8 rows, 27 cols) header row contains **all 8** columns (missing: none) | ✅ |
| A2 | Displayed metric data matches export | UI Impressions data set shows the same 8 columns (values N/A/– for UCLA public posts Dec 25 2024); CSV 8 data rows = Posts(8) | ✅ |

## Open-bug verdict
- **LFMP-31979 (Major, Open) — Thumbnail Issue for Facebook and Pinterest Posts:** **NOT REPRODUCED (FB).** UCLA Facebook posts render thumbnails normally (post #1 video thumbnail, post #5 group-photo image visible). **Pinterest not testable** — UCLA has no Pinterest channel (icon greyed/disabled). Recommend a Pinterest-enabled brand for the Pinterest half.

## Evidence
- Impressions data set applied (`table_data_set=impressions`), Posts(8).
- Export → CSV (Impressions data set) → queued export fetched in-page via `credentials:'include'` (Rule 6): status 200, 8 data rows, 27 columns, all 8 spec metric columns present.

## Cleanup
_None (read-only export)._
