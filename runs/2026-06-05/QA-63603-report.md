# QA-63603 — Settings > Tags > Content Tagged - Upload Tags

- **Date:** 2026-06-08 (batch 4/12 of QA-22296)
- **Source spec:** Jira QA-63603 (title + 1-line description "This test case ensures the Upload Tags functionality on the Content Tagged Tab")
- **Skill mapped:** none — Settings > Tags read via prior export-google-sheets skill; Upload Tags template flow shares Update Tag Modal pattern verified in QA-27292
- **Bug history (Closed):** APPS-52081 (Brand Partnerships filter error tiles)
- **Mutating:** Yes (would create a tag). Read-only verification of the affordance attempted in this run.

## Result: PARTIAL — Upload Tags flow not reachable from Settings > Tags (per current build); separate finding

## Execution
1. After full-tab refresh post-Radaac session, navigated to `https://app.lfmdev.in/#tags?account_id=54`.
2. Page rendered with `Settings | Tags` breadcrumb + Tags table (40 visible rows on first page; columns `Tag | Date Created | Creator | Content Tagged | Actions`).
3. Inspected toolbar:
   - Top-right: `Export` button → dropdown contains `CSV` and `Google Sheets`. No `Upload Tags` option.
   - Filter bar: `Filter:` + Select + `Apply Filter` + `Load Filter` / `Save Filter` / `Clear All`. No `Upload Tags` affordance.
   - Per-row Actions column: `Update | Delete` per row.
4. Searched the rendered page text for "Upload" — `pageText.includes('Upload')` returns `false`.
5. Spec description is "ensures the Upload Tags functionality on the Content Tagged Tab" — the column on this surface is labeled "Content Tagged" but there is no separate "Content Tagged" Tab in the current build. The page has a single table and one Export menu.
6. Prior QA-27292 batch-3 verified that "Upload Tags" lives on **Brand > Content** → Tag dropdown → Upload Tags (NOT on Settings > Tags). The Update Tag Modal exposes `Download CSV Template`.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 1-2 | Settings > Tags page renders | Page renders with 40 rows, column headers verified `Tag | Date Created | Creator | Content Tagged | Actions` | PASS |
| A2 | 3 | An "Upload Tags" affordance is reachable from Settings > Tags / Content Tagged tab | No Upload Tags affordance found on the page. Export dropdown contains CSV + Google Sheets only. No "Content Tagged" Tab present — Content Tagged is a column, not a tab. | **FAIL — spec drift OR missing affordance** |
| A3 | 4-6 | Upload Tags modal opens with CSV template download | Cannot proceed without an Upload Tags entry point on this surface. (Note: per QA-27292, Upload Tags exists on Brand > Content but spec specifies Settings > Tags.) | NOT VERIFIED |

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| APPS-52081 (Closed) — Brand Partnerships tag-filter error tiles | NOT REPRODUCED (different surface) | This bug was on Brand > Partnerships; QA-63603 scopes to Settings > Tags. No relevant repro. |

## New findings

- **Spec ↔ UI drift:** The current Settings > Tags page has a single integrated table — there is no separate "Content Tagged Tab" + "Upload Tags" affordance as the spec wording suggests. Upload Tags as a feature does exist (verified on Brand > Content via QA-27292) but is not surfaced from Settings > Tags in the current build.
- Possible interpretation: the test name uses "Content Tagged" to refer to the column (not a tab) and the spec wants verification that "the Upload Tags functionality" is reachable from a per-tag Update flow — but the Update action on Settings > Tags row opens an inline edit (not yet verified end-to-end in this run; modal probe inconclusive).
- Recommend product/spec triage: either re-route the spec to Brand > Content (where Upload Tags lives) or add an Upload Tags affordance to Settings > Tags if intended.

## Files
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-63603-report.md` (this report)

## Bugs filed
- None new. Carry-forward finding: Spec/UI drift — Upload Tags is NOT reachable from Settings > Tags page in the current build.
