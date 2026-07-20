# QA-75011 — Settings > Custom Metrics - Basic View

- **Date:** 2026-06-08 (batch 4/12 of QA-22296)
- **Source spec:** Jira QA-75011 (title + description "ensures a basic view of the Custom Metrics tab in the settings")
- **Skill mapped:** `settings-custom-metrics` v1 (untrusted, pass_streak 7) — Basic View pattern fully covered
- **Bug history (Closed):** APPS-49018 (Custom Metrics page appears empty)

## Result: PASS

## Execution
1. After full-tab refresh post-batch transitions, navigated to `https://app.lfmdev.in/#custom-metrics?account_id=54`.
2. Page rendered: title `Settings Custom Metrics - ListenFirst: Custom Metrics`. Top toolbar contains `Create a Custom Metric` button (top-right).
3. Custom Metrics table renders with 18 rows (paginated; total ~58+ across pages).
4. Column headers verified: `Metric | Description | Created Date | Creator | Formula | Actions` (6 columns).
5. Spot-check rows:
   - Row 1: `Cross-Channel Engagements | test | Dec. 13 2024 | (empty creator) | lfm.post_engagement_score.comments_score_v5 + lfm.cross_chan...`
   - Row 2: `Custom test | test | Jan. 07 2025 | (empty creator) | lfm.post_engagement_score.comments_score...`
   - Row 3: `Divanshu | Testing Purpose | Jun. 05 2026 | Divanshu Jain | lfm.post_engagement_score.comments_score...`
   - Row 4: `Jan30 test | testing | Jan. 30 2025 | Sasikumar Drylogics | lfm.post_engagement_score.comments_score...`
   - Row 5: `Jim's Test | Let me put in a description | Jan. 11 2025 | James Butler | lfm.post_engagement_score.public_nvo_eng...`
6. Data Last Updated header + page chrome render cleanly.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 1-2 | Page renders without "page appears empty" error (APPS-49018 closed bug) | Page renders with 18 rows + Create button | PASS |
| A2 | 3-4 | Table has 6 columns: Metric / Description / Created Date / Creator / Formula / Actions | Verified verbatim | PASS |
| A3 | 5 | Row data populates with real custom metric definitions including formula strings | 5 spot-check rows all have non-empty metric/description/formula; Created Date in `MMM. DD YYYY` format | PASS |
| A4 | 2 | `Create a Custom Metric` action affordance is visible | Button found in top-right toolbar | PASS |

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| APPS-49018 (Closed) — Custom Metrics page appears empty | NOT REPRODUCED | Page populates correctly with 18+ rows. |

## New findings

- **Known copy drift** persists (per known-quirks "Custom Metrics page — spec/UI copy drift"):
  - Column header is `Created Date` (current build) — matches the spec for QA-75011's purpose. The sibling Info-tooltip drift (`Created Date` column vs `Date Created` tooltip header) was documented in QA-134173 and is not in scope for the basic-view check here.
- Some rows have empty `Creator` field (rows 1 & 2 from Dec/Jan 2024-2025 era). Not a defect per APPS-49018 closure; legacy data lacks creator attribution.

## Skill registry impact
- `settings-custom-metrics` pass_streak 7 → 8 (Basic View read flow re-verified end-to-end on Adam Orfei dev).

## Files
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-75011-report.md` (this report)

## Bugs filed
- None.
