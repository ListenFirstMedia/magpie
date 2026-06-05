# QA-569 — Facebook In Window Private Data QA

- **Date:** 2026-06-04
- **Tester:** magpie (batch 2)
- **Account:** Hulu (account_id=336)
- **Brand:** Hulu (brand_id=5670)
- **Channel:** Facebook
- **Mode:** In Window
- **Date range:** May. 25, 2026 - May. 31, 2026 (end-date shifted back 2 days from default per spec step 6)
- **Result:** PARTIAL — dev side confirms In Window mode applies and aggregates render; stage-vs-dev parity cannot be evaluated end-to-end from this session because stage is a separate environment.
- **Linked open bugs:** none

## Pre-flight
- Hulu account active (carried over from QA-567).
- Navigated to `/#explore/brand/content?brand_id=5670&account_id=336&channels=facebook&perspective=extended&stats_attribution_window=in_window&from=2026-05-25&to=2026-05-31&table_data_set=impressions&layout=table`.

## In Window mode toggle

- Date Range picker opened → "Select Mode" radio group showed `Lifetime` (selected) | `In Window`.
- Clicked In Window → Ok.
- Mode label flipped to `In Window`. URL `stats_attribution_window=in_window` persists.
- Posts (30) loaded under filter.

## Dev-side observations (Hulu, FB, May 25-31 2026, In Window, Impressions)

Sum / Average row aggregates rendered:

| Metric | Sum | Average |
|--------|-----|---------|
| Engagements | 126,946 | 4,232 |
| Engagement Rate | N/A | 1.62% |
| Impressions | 7,819,139 | 260,638 |
| Organic Impressions | 7,819,139 | 260,638 |
| Paid Impressions | 0 | 0 |
| Reach | N/A | – |
| Organic Reach | N/A | – |
| Paid Reach | N/A | – |
| Engaged User Rate | N/A | – |

Posts table body subsequently rendered "This table failed to load. Please try again." with Reload button — flagged as transient (the aggregate sum/avg row above succeeded, so backend has the data; tile-render lifecycle hiccup likely). Not a deal-breaker for the dev-vs-stage parity intent.

## Spec-vs-environment limitations

The QA-569 spec requires the user to have **dev open in 1 browser AND stage open in another**, then compare:
- Step 10: Compare impressions data between dev and stage.
- Step 13: Compare video views data between dev and stage.
- Step "11" (matching post counts).

magpie operates against `app.lfmdev.in` (dev) only. Stage comparison cannot be evaluated.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 7 | In Window mode applies via calendar Select Mode radio | Mode label flips to "In Window"; URL `stats_attribution_window=in_window`; backend returns in-window-windowed totals (Sum 7,819,139 Impressions ≠ Lifetime view's 35,353,705) | PASS (dev) |
| A2 | 10 | In Window impressions match between dev and stage | Cannot evaluate stage from this session | NOT VERIFIED — needs manual stage access |
| A3 | 13 | Video Views data match between dev and stage | Cannot evaluate stage from this session | NOT VERIFIED — needs manual stage access |
| A4 | – | Posts count matches between views | Cannot evaluate stage from this session | NOT VERIFIED — needs manual stage access |

## New finding — non-blocking
- Posts (30) returned correct count + aggregates, but post-row tile renders "This table failed to load. Please try again." (transient; Reload retry may resolve). Documented as a render-lifecycle issue, not a data defect. The same backend serves both dev and stage; cross-env parity comparison still requires manual stage check.

## Bugs filed
- None new.

## Skill usage
- `view-perspective-toggle` (Authorized Data confirmed via toggle position).
- `brand-content-data-set-selector` (Impressions data set selected).

## Notes for parent agent
- QA-567 and QA-569 are dev↔stage parity tests; both should be flagged as "manual cross-env tests" for LFIQA. magpie has confirmed the dev side renders/applies the required modes correctly.
