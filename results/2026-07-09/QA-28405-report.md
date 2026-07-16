# QA-28405 — Brand Content - CSV - All Data set - Video Views

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account:** Hulu (account_id=336) · Brand Hulu (brand_id=5670)
- **Channels:** all available (FB/Twitter/IG/LinkedIn/TikTok — Threads auto-dropped, no video views) · Jul 1–7 2026 · Data Set: Video Views

## Verdict: PASS

## Known bugs checked
Compact open-bug screen → empty. No open linked bug.

## Flow
Brand > Content (Hulu, 88 posts at default) → Data Set dropdown → **Video Views** → Export → CSV → OK → downloaded synchronously: `Hulu-Brand Content-2026-07-01-2026-07-07-posts.csv` (77 lines).

## CSV verified
- **Row 1** = "Data Set" label row; the only non-empty labels are `Data Set` + `Video Views` (labels the active data set — A6).
- **Row 2** = 34 column headers, including **`Video Views`** and **`Video Views (with Cross-Posts)`** (A5).
- **75 data rows** (posts with Video Views data).

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Data Set dropdown has Video Views (+ Public default) | present (Public/Impressions/Video Views/Clicks/Reels/…) | PASS |
| A2 | Posts(N) loads non-zero, no skeleton-hang | 88 posts (Public) → 75 rows with Video Views | PASS |
| A3 | Export enabled; export completes | CSV downloaded to disk | PASS |
| A4 | Filename `{Brand}-Brand Content-{from}-{to}-…csv` | `Hulu-Brand Content-2026-07-01-2026-07-07-posts.csv` | PASS |
| A5 | CSV has Video Views metric columns | `Video Views`, `Video Views (with Cross-Posts)` in header | PASS |
| A6 | Row 1 labels the active data set | Row 1 = "Data Set" + "Video Views" | PASS |

## Evidence
- `.playwright-out/Hulu-Brand-Content-2026-07-01-2026-07-07-posts.csv`

## Note
Hulu channels/data were fully available in the current window here (88 posts) — the "all channels disabled" state seen earlier in the QA-569 investigation did not recur; it appears to have been a transient/sub-view-specific condition.

## Bugs filed
None.
