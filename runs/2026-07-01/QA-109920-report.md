# QA-109920 — Brand > Content - Sentiment Comments limit - Positive Classification Donut - CSV

- **Run date:** 2026-07-01
- **Skill used:** `chart-hover-tooltip` + `brand-content-data-set-selector` + `export-csv`
- **Account/Brand:** Amazon Prime Video (account_id=342, brand_id=25864 — switched via LFQA Search Account for the account since no cached account_id existed; brand via direct URL id per token-minimization instruction)
- **Date range:** Apr 01, 2025 – Apr 07, 2025 (fixed historical window)
- **Mode:** Sentiment ON (clicked the `sentiment` button; `sentiment_mode=true` confirmed via URL + click, not URL alone)

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 (6) | Click Read in popup | Pop-up opens | `.lfm-modal` opened with header "Positive Classification: 50%" | PASS |
| A2 (6) | — | Message: "2,000 Sample Comments. To view all possible comments, please export your result as on screen display is limited to 2,000" | Verbatim (plus trailing period): "2,000 Sample Comments. To view all possible comments, please export your result as on screen display is limited to 2,000." | PASS |
| A3 (8) | Export CSV | CSV has >2,000 comments | `Amazon-Prime-Video-Brand-Content-2025-04-01-2025-04-07-comments-sentiment.csv`, 1.18MB, **6,161 data rows** (6,162 lines incl. header), all sampled — confirmed on disk at `.playwright-out/` | PASS |

**Overall: 3/3 PASS.** This is a clean, better-than-prior-run result — the 2026-06-02 batch-8 run hit "This tile failed to load" on the Sample Comments popup body and could NOT verify A2. This run, the popup loaded real comment data with no failure.

## Notes / deviations from the written steps

1. **Donut hover required the synthetic-event fallback**, same as QA-1124's Total Followers donut — real `browser_hover` didn't render the sentiment tooltip; dispatching `mouseover`/`mousemove`/`mouseenter` directly on the `.arc path` did. Confirms this is a general Playwright-MCP-vs-donut-geometry issue, not specific to one page.
2. **Step 7/8 ("Click Export → CSV in dropdown" → "Click Ok on Sentiment Export Request pop-up") didn't match the observed UI exactly.** Inside the Read popup, "Export" is a single CSV-only action (class `csv lfm-button-dropdown-container`, no dropdown menu, no intermediate "Sentiment Export Request / Ok" confirmation dialog) — clicking it triggered an immediate direct-download CSV, not a queued export with a confirmation step. The queued-export-with-Ok-dialog pattern exists elsewhere in this app (page-level Export), but not on this modal's Export control. Documented as a spec/UI mismatch, not a bug — the end assertion (A3, CSV row count) was still fully verifiable.
3. Row count (6,161) is consistent with the prior run's 6,160 (off by ~1, negligible — same fixed historical window, no meaningful drift).

## Bugs
None found this run.

## Cleanup
No mutating actions — CSV export/download only. No cleanup required.
