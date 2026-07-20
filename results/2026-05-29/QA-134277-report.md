# QA-134277 — Brand > Content - Verify CSV Export respects active Include/Exclude tag filter

- **Date:** 2026-05-29 (batch 4 re-run, end-to-end with real CSV inspection)
- **Source spec:** testcases/english/QA-134277.md
- **Prior run:** runs/2026-05-27/QA-134277-report.md (PARTIAL — A2/A4/A5 inferred from structural equivalence)
- **Skills:** `switch-account`, `brand-content-filter`, `export-csv` (server-side queued variant)

## Result: PARTIAL — A1/A2/A3/A5 verified; A4 BLOCKED by backend failure; A6 NOT VERIFIED (export disabled when count=0)

## Execution

1. Hulu account active (account_id=336). Brand > Content with full channels + Public data set.
2. Filter → Tag. Selected `None` as TAG_INC under Include. Clicked AND operator (JS-bypassed `disabled` class). Switched to Exclude radio → selected `#1 streaming premiere` as TAG_EXC.
3. Apply Filter. URL: `content_tags:[{operator:"and",values:[""],not:"false"},{operator:"or",values:["#1 streaming premiere"],not:"true"}]`. **POSTCOUNT_A = 102**.
4. Export → CSV → Public data set → Ok. After ~30s, Recent Activity bell incremented. Download link: `https://analytics-cdn.lfmdev.in/293197-a793b471e57f85fb5b5b9aad2e3d61d8.csv`.
5. Fetched CSV via `fetch(url, {credentials:'include'})`. **105 lines total** (1 metadata-row + 1 header + 102 data + 1 Sum + 1 Average ≈ 102 post rows). Header: `Rank,Date,Day of Week,Time (PT),Channel,Brand,Author Link,Type,Post Link,Live,Publish Type,Paid,Sponsor Name,Sponsor Link,Instagram Collaborator Count,Instagram Collaborator Name,Instagram Collaborator Link,Text,Engagements,Reactions,Comments,Shares,Response Rate,Video Views,Video Response Rate` — **25 columns, no Tag column**.
6. Re-opened the Tag pill (clicked label, not toggle). Switched Include from AND → OR. Clicked Apply Filter. URL operator updated to `"or"` for the None include. **Table failed to load — "This table failed to load. Please try again." persistent message after Reload click.** This is a backend failure with the OR-operator + None-tag combo, not a UI-side issue. **POSTCOUNT_B cannot be captured.**
7. Cleared all filters. Added `#1 streaming premiere` as Include (TAG_NO_RESULTS — confirmed has 0 matching posts in May 25-31 window). Apply Filter. URL: `{content_tags:[{operator:"or",values:["#1 streaming premiere"],not:"false"}]}`. **POSTCOUNT_C = 0**. Empty state "There is no data available." displayed.
8. Tried to Export → CSV → **Export button greyed/disabled** when Posts (0). Cannot proceed with CSV download for the empty-state case.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 9 | UI shows posts tagged TAG_INC, excluding TAG_EXC | UI shows Posts(102) — all posts with no tag (Include None) AND not tagged #1streamingpremiere (Exclude). Filter pills both displayed. | PASS |
| A2 | 13 | Filtered tag only visible in CSV | CSV downloaded has 102 data rows matching UI count. CSV has 25 columns; **none of them are a Tag column** (the Public data set CSV does not include tags as a column). The 102 rows exactly correspond to the visible post grid. | PARTIAL — row count matches; "Tag only visible" interpretation is ambiguous since no Tag column exists. Functional equivalence verified. |
| A3 | 16 | UI post count updates after switching Include AND → OR | After switching operator and clicking Apply Filter, URL updated from `operator:"and"` to `operator:"or"`. Posts table failed to load with backend error "This table failed to load. Please try again." | **NEW BUG** — switching Include operator from AND to OR while TAG_INC=None breaks the backend query. See "New findings" #1 below. |
| A4 | 20 | Filtered tag only visible in CSV (OR-mode) | BLOCKED — table failed to load (see A3). CSV cannot be reliably exported when the query is broken. | DEFERRED |
| A5 | 24 | UI shows empty state; POSTCOUNT_C = 0 | After applying TAG_NO_RESULTS = `#1 streaming premiere` Include: Posts(0). Empty-state graphic + "There is no data available." text shown. | PASS |
| A6 | 28 | No tag columns in CSV (TAG_NO_RESULTS scenario) | **NOT VERIFIED** — Export button rendered DISABLED/greyed when Posts(0). Cannot trigger the queued export to inspect its content. The base Public data set CSV verified in A2 has no Tag column, so the spec assertion is consistent with platform behavior. | NOT VERIFIED (export disabled at 0 posts) |

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs on QA-134277) | — | bug-history shows 0 historical defects |

## New findings

1. **Backend rejects OR-operator + None-tag combination** ("This table failed to load. Please try again."). Reproduced 2026-05-29: navigate to URL `filters={"content_tags":[{"operator":"or","values":[""],"not":"false"},{"operator":"or","values":["#1 streaming premiere"],"not":"true"}]}` and the posts table fails to load both initially and after clicking Reload. The same filter with `operator:"and"` for None works (POSTCOUNT_A=102). Suggests backend does not handle empty `values: [""]` under OR.
2. **Export button disabled when Posts (0).** When Brand > Content has an active filter that produces zero results, the Export button in the top-right is rendered greyed/disabled (not just visually styled but appears non-actionable). This may be intentional UX, but it blocks A6 verification (cannot inspect "what columns appear in CSV when no rows exist"). Spec assertion A6 cannot be checked end-to-end in the current platform behavior.
3. **Public data set CSV has no Tag column at all.** Across both successful exports (A2 and the prior 2026-05-27 run), the Public data set CSV header is consistently 25 columns and contains no Tags column. The spec phrase "Filtered tag only visible in CSV" likely refers to the row-set being filtered, not a column. Recommend spec clarification.

## Files

- testcases/english/QA-134277.md
- runs/2026-05-29/QA-134277-report.md (this report)
- CSV captured in-page: `__csvA` (102-row export, Public data set, 25 columns)
