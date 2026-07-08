# QA-281 — TWC report for Relative dates with long intervals

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-281 · Priority: Trivial (P5)
- **Result:** **PASS** (A1 — exports match the TWC report).
- **Account:** Disney Ad Sales (account_id=634) · TWC story `155510`
- **Skill:** time-window-comparison-run (+ keydate-picker)

## Known bugs checked (pre-run)
- **LFMP-31961 (Major, OPEN)** — "TWC New Followers data not displayed correctly": chart Y-axis floors at 0, negative net-follower values clipped to baseline (Wells Fargo, all-negative, renders flat). **This exact config** (Disney Channel + Disney Junior + Wells Fargo, 15→1 Weeks, New Followers).
- **Observed this run:** reproduced as expected — the chart clips negatives, but the **table + CSV values are correct** (Change column carries negatives). A1 checks export-vs-report data (table), so the bug does not fail A1. Attributed to LFMP-31961; NOT filed as new.
- 19 closed bugs (export-not-working, date-format, export-disappears) — none reproduced.

## Steps executed
1. Reporting → Time Window Comparison (Disney Ad Sales). ✅
2. Relative Dates. ✅  3. Interval = **Weeks**. ✅
4. Start **15** / End **1** (spinbuttons). Window computed: **15 Weeks Out → 1 Week Post (Oct 13 2024 – Feb 08 2025)**. ✅ *(see note)*
5. 3 brands (exact, Rule 1): Disney Channel, Disney Junior, Wells Fargo. ✅
6. **Key Date Feb 1, 2025 set per-brand** (one by one via each row's Select Key Date → calendar → Feb 1 2025). All 3 = "Feb 1, 2025". ✅
7. Metric: **New Followers**. ✅
8. Options: **Show Change, Show Share, Show Metrics Tables**. ✅
9. Generated report → "Choose the Ending Day of Weekly Intervals" modal → **Use the Weekday of Primary Brand's Key Date** (Feb 1 2025 = Saturday) → Ok. ✅
10. Report rendered (no reload-error tiles). ✅
11. Export → CSV, verified on disk. ✅

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Exports match TWC report | CSV cols `Perspective,Brand,Date,New Followers,Change,Change %,Share` (reflects the metric + Show Change/Share); 50 rows (3 brands × weekly periods); spot-checks 16788 / 20432 / 50437 / -14221 all present in the report; 0 en-dashes | ✅ PASS |

## Evidence
`.playwright-out/Disney-Channel---Time-Window-Comparison---15-Weeks-Out---1-Week-Post-Sunday-to-Saturday-.csv` (3.6 KB, 50 data rows). Weekly intervals end Saturday (primary key date weekday).

## Notes / findings
- **LFMP-31961 confirmed still open** — chart clips negatives; table/export correct. No new bug.
- **Weekly + key-date triggers a required "Choose the Ending Day of Weekly Intervals" modal** before the report runs (options: Each Brand's / Primary Brand's key-date weekday, or pick a day). Not in the old skill — worth adding to time-window-comparison-run / keydate-picker.
- Per-brand key date opens a **plain calendar** (unlike the bulk dialog's Filter view); navigate month-header → year arrows → month → day. Bulk Select Key Date's "Calendar" toggle did NOT switch (stuck) — use per-brand instead.
- **Needs human review:** the End direction resolved to "1 Week **Post**" (after) rather than "1 Week Out"; spec wording ("end 1 week") is ambiguous and A1 is direction-agnostic, but confirm the intended window if it matters.

## Bugs filed
None (LFMP-31961 is pre-existing/open).
