# QA-581 — Twitter In Window Private Data QA

**Run date:** 2026-06-04 (QA-4325 batch-3 re-run)
**Account:** Hulu (account_id=336)
**Brand:** Hulu (brand_id=5670)
**Environment:** dev (`app.lfmdev.in`)
**Result:** **PARTIAL** — dev-side Impressions data collected; Twitter Video Views tile stuck in skeleton-loading state under In Window; stage parity NOT VERIFIED.

## Spec
See `/Users/yashsharma/git/magpie/testcases/english/QA-581.md` — Twitter analogue of QA-569 / QA-567 pattern.

## Configuration achieved (Rules 1 + 2 + 6)
- Brand: Hulu (brand_id=5670).
- Perspective: Authorized — `perspective=extended` + visual toggle handle on right.
- Channels: Twitter only — confirmed.
- Date range: May 25-27 2026.
- Mode: In Window — `stats_attribution_window=in_window`.
- Data Set: Impressions, then Video Views.

## Assertions table

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| In Window mode toggle | step 7 | Mode flips Lifetime → In Window | URL `stats_attribution_window=in_window` + Mode label "In Window" | PASS |
| Impressions data set | step 8 | Posts populate with Twitter Impressions In Window | Posts (6) — Sum Engagements 261; Sum Impressions 58,318; Sum Organic Impressions 58,318; Sum Paid Impressions –; Sum Reach –; Sum Organic Reach N/A; Sum Paid Reach N/A; Sum EUR N/A | PASS |
| Video Views data set | step 11 | Posts populate with Twitter Video Views In Window | **DEV-SIDE SKELETON HANG** — after switching Data Set to Video Views, the Posts tile stayed in skeleton-shimmer state for 45+ seconds with no error and no data. Apply-channels click did not re-trigger render | NOT VERIFIED |
| A10 (cross-env Impressions parity) | step 10 | Dev posts match stage | Stage NOT VERIFIED — dev only | NOT VERIFIED |
| A13 (cross-env Video Views parity) | step 13 | Dev posts match stage | Stage NOT VERIFIED — dev only, also dev tile skeleton | NOT VERIFIED |

## Aggregate detail — In Window May 25-27 2026 Authorized Twitter Hulu

### Impressions data set
- Posts (6) all Twitter (X) — 1 Original Post + 5 X Threads.
- Sum: Engagements 261 | ER N/A | Impressions 58,318 | Organic Impressions 58,318 | Paid Impressions – | Reach – | Organic Reach N/A | Paid Reach N/A | EUR N/A
- Avg: Engagements 44 | ER 0.45% | Impressions 9,720 | Organic Imp 9,720 | Paid Imp – | Reach – | Organic Reach – | Paid Reach – | EUR –

### Video Views data set
- Twitter Video Views tile stuck on skeleton for 45+ seconds without error message or data render. No `Reload` button surfaced; Apply-channels click did not retrigger fetch. Posts header label did not update from skeleton to `Posts (N)`. Possible causes: zero video posts in window OR backend slow path for Twitter video metrics.

## Bugs filed
_None — Video Views skeleton-hang is a render-lifecycle / backend timing observation, not deterministically reproducible enough to file._

## New findings
- Twitter Video Views tile under In Window mode hung in skeleton-shimmer state for 45+ s with no error message (unlike IG which hits "This table failed to load" + Reload). May warrant a follow-up if reproducible. Captured for known-quirks consideration: distinct from the IG render-lifecycle pattern.

## Skills reused
- `view-perspective-toggle`
- `brand-content-data-set-selector` (Impressions only — Video Views switch initiated but did not complete)
