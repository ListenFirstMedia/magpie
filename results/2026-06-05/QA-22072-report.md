# QA-22072 — Brand > Partnerships - Basic View data set (re-run 2026-06-05 batch-3)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-22072
- **Description (verbatim from Jira):** "This test case ensures the feature of Advanced Filter capability of Metrics in Basic view Data set"
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018)
- **Page:** `#explore/brand/partnerships?brand_id=4018&account_id=54&perspective=extended&stats_attribution_window=lifetime&from=2026-05-25&to=2026-05-31&channels=facebook&channels=twitter&channels=instagram&channels=tiktok&channels=youtube`

## Result: PARTIAL — Basic Data Set Filter has NO metric-based sub-filter (spec intent not met by current build)

## Steps executed

1. Navigated to Brand>Partnerships on MTV (default 5-channel multi-channel, Lifetime mode, May 25–31 2026, Authorized perspective).
2. Page rendered with Brand>Partnerships shell. All 4 tiles (Sponsored Posts, Engagements, Total Est. Media Value, Avg. Engagements per Post) populate as `There is no data available. Please select a different brand, brand set, or date range.` — MTV has no partnership data in this window (expected; test focus is filter widget, not data).
3. **Default Data Set:** `Basic` (the only data set option on Brand>Partnerships in current build).
4. **Filter dropdown:** Clicked `.shared-filters-add-filter-button` → opened popover `.shared-filters-filters-table`.
5. **Enumerated 10 filter sub-categories** (all `.option-row` items, full DOM dump): `Collaborated`, `Collaborated Total`, `Collaborator Name`, `Content Type`, `Publish Day`, `Publish Time`, `Publish Type`, `Sponsor Name`, `Tag`, `Text Search`.
6. **Search test for metric-based sub-filter:** Typed `engagement` into the Search input — returned **0 rows** (no match). The filter list contains no `Engagements`, `Impressions`, `Spend`, `Followers`, or any other metric sub-filter.
7. Cleared search; 10 sub-filter options reconfirmed.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2-3 | Brand>Partnerships loads on MTV; Default Data Set = Basic | Loaded; Data Set chip = `Basic` (only option) | PASS |
| A2 | 4-5 | Filter popover opens with sub-filter list | `.shared-filters-filters-table` opens with 10 `.option-row` entries | PASS |
| A3 | 5 | Filter list contains **metric-based** sub-filter (Engagements / Impressions / Total Est. Media Value / etc.) — required to verify "Advanced Filter capability of Metrics in Basic view" | **NO metric sub-filter present.** Only 10 dimension/text sub-filters: Collaborated, Collaborated Total, Collaborator Name, Content Type, Publish Day, Publish Time, Publish Type, Sponsor Name, Tag, Text Search | **FAIL (against spec intent)** |
| A4 | 6 | Search for "engagement" returns metric-based filter row | 0 rows returned | FAIL |

## Finding — possible spec drift or product gap

The Jira test description explicitly references "Advanced Filter capability of Metrics in Basic view Data set", but the current Brand>Partnerships Basic Data Set filter popover does not expose any metric-based sub-filter. The tiles on the page (Sponsored Posts, Engagements, Total Est. Media Value, Avg. Engagements per Post) ARE metric-based, but those are display tiles, not filter sub-categories.

Two possibilities:
1. **Spec drift:** The test case predates a UI redesign that removed metric filters from Brand>Partnerships. APPS-49013 (closed) was about Author/Partner column rename — confirms there has been Partnership redesign work.
2. **Product gap:** The "Advanced Filter capability of Metrics" was planned but never built, or was removed without spec update.

Recommend product triage. The 5 prior closed Bug/Test-Failure cases on this page (sweep-note tag) all reference posts-not-loading or count-discrepancy, NOT metric-filter absence — so no historical bug-history pre-context for the metric filter requirement.

## Bug reproduction outcomes
- No previously-open LFMP bugs on this ticket. No regression vs prior runs (no prior magpie run).

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-22072-report.md`

## Notes
- Brand>Partnerships UI on Adam Orfei dev today renders cleanly (no hang). Default brand `brand_id=4018` (MTV) — no URL hash rewrite.
- 10-row filter list is consistent with the `brand-content-filter` widget pattern used on Brand>Content and Brand Sets surfaces, minus the metric-filter sub-categories that don't exist on Partnerships.
