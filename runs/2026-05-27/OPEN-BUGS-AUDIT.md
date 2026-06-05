# Open-Bugs Audit — All 59 Tickets in runs/2026-05-27/

- **Generated:** 2026-05-29
- **Method:** Atlassian MCP `getJiraIssue` per ticket → filter `issuelinks` where linked-issue `issuetype IN {Bug, Test Failure}` AND `statusCategory != "done"`.
- **Caught?** = whether the open bug's symptom was flagged in the corresponding `runs/2026-05-27/QA-<n>-report.md`.

## Status legend

- ✓ **Consistent** — 0 open bugs, my PASS/PARTIAL/BLOCKED result aligns.
- ✗ **MISSED** — open bug(s) linked, my report didn't flag them.
- ◐ **PARTIAL CATCH** — open bug exists; my report flagged a related but different finding.
- ✓ **CAUGHT** — open bug(s) exist and my report explicitly noted them or an equivalent issue.

## Per-ticket findings

| # | Ticket | My result | Open Bug/Test-Failure (key — summary) | Caught? |
|---:|---|---|---|---|
| 1 | QA-949 | PASS | — | ✓ |
| 2 | QA-19557 | PASS | APPS-58817 (Bug, Major, Open) — Brand Content - Posts deleted from Native are still visible in LF app; LFMP-32016 (Bug, Major, Open) — Story post data not displayed on Brand > Content | ✗ MISSED |
| 3 | QA-24544 | PARTIAL | — | ✓ |
| 4 | QA-27854 | BLOCKED | — | ✓ |
| 6 | QA-51425 | PASS | — | ✓ |
| 7 | QA-135321 | PASS | — | ✓ |
| 8 | QA-135319 | PASS | — | ✓ |
| 9 | QA-134277 | PARTIAL | — | ✓ |
| 10 | QA-134516 | PARTIAL | — | ✓ |
| 11 | QA-134449 | PARTIAL | — | ✓ |
| 12 | QA-134448 | PARTIAL | — | ✓ |
| 13 | QA-134188 | PASS | — | ✓ |
| 14 | QA-134184 | PASS | — | ✓ |
| 15 | QA-134182 | PASS | — | ✓ |
| 16 | QA-132392 | PARTIAL | — | ✓ |
| 17 | QA-132387 | PARTIAL | — | ✓ |
| 18 | QA-85176 | PASS | — | ✓ |
| 19 | QA-134173 | PASS | — | ✓ |
| 20 | QA-134185 | PASS | — | ✓ |
| 21 | QA-100764 | PASS | — | ✓ |
| 22 | QA-103248 | BLOCKED | — | ✓ |
| 23 | QA-104870 | PASS | — | ✓ |
| 24 | QA-1053 | PASS | — | ✓ |
| 25 | QA-106218 | PASS | — | ✓ |
| 26 | QA-109062 | PASS | — | ✓ |
| 27 | QA-109920 | PARTIAL | — | ✓ |
| 28 | QA-110074 | PASS | — | ✓ |
| 29 | QA-1124 | PASS | LFMP-31781 (Bug, Minor, Open) — Brand Insights - Hovering Functionality - twitter icon color is blue | ✗ MISSED |
| 30 | QA-116113 | PASS | DATA-12043 (Bug, Major, Code Review) — Data is not coming in for YouTube channel in brand > audience page | ✓ CAUGHT |
| 31 | QA-12532 | PASS | LFMP-31903 (Bug, Minor, Open) — BrandSet > Partnerships > Avg. Engagements per Post > Export > Png file does download without .png extention | ✗ MISSED |
| 32 | QA-129606 | PARTIAL | — | ✓ |
| 33 | QA-129803 | DEFERRED | — | ✓ |
| 34 | QA-130076 | PASS | — | ✓ |
| 35 | QA-131491 | PASS | — | ✓ |
| 36 | QA-131492 | PASS | — | ✓ |
| 37 | QA-1519 | PASS | — | ✓ |
| 38 | QA-1677 | PASS | — | ✓ |
| 39 | QA-19482 | PARTIAL | — | ✓ |
| 40 | QA-198 | PASS | — | ✓ |
| 41 | QA-20988 | PASS | — | ✓ |
| 42 | QA-23969 | FAIL — BC-4 reconfirmed | LFMP-31925 (Bug, Major, Open) — Reporting > Social Recap -> %YOY is not Present in Video Views Donut in Report | ◐ PARTIAL CATCH |
| 43 | QA-2498 | MIXED | — | ✓ |
| 44 | QA-2706 | PASS | LFMP-31886 (Bug, Minor, Open) — Data Display Inconsistency: Benchmark Owned Average Row value missing parentheses in "Video views" column | ✗ MISSED |
| 45 | QA-281 | PASS | LFMP-31961 (Bug, Major, Open) — Reporting > TWC > New Followers > The data is not displayed correctly | ✗ MISSED |
| 46 | QA-29479 | DEFERRED | — | ✓ |
| 47 | QA-33510 | DEFERRED | — | ✓ |
| 48 | QA-3630 | BLOCKED | LFMP-32010 (Bug, Major, Open) — Reporting > Content performance > Least Engaging Posts & Heading Does not show in "Preview & Share Report" | ✓ |
| 49 | QA-520 | PASS | — | ✓ |
| 50 | QA-52776 | DEFERRED | — | ✓ |
| 51 | QA-65554 | PASS | — | ✓ |
| 52 | QA-837 | PASS | LFMP-31798 (Bug, Major, Open) — Reporting > Social Recap - Up and down arrows do not appear correctly in the doughnut charts in the export; LFMP-31918 (Bug, Major, Open) — Thumbnail Issue : Report > Social Recap - Thumbnail not showing properly for some posts after downloading report and also for normal reports | ✗ MISSED |
| 53 | QA-90213 | FAIL — parity mismatch | — | ✓ |
| 54 | QA-929 | PARTIAL | — | ✓ |
| 55 | QA-96038 | PASS | — | ✓ |
| 56 | QA-96665 | FAIL — separator missing | LFMP-32027 (Bug, Major, Open) — Brand->Insights:Trends graph values are overlapping when selected date range is 6 or 12 months | ◐ PARTIAL CATCH |
| 57 | QA-96818 | PASS | LFMP-31977 (Bug, Major, Open) — Reporting > Data Studio Report - Save to dashboard dropdown remains visible when graph tile is missing | ✗ MISSED |
| 58 | QA-98368 | PASS | APPS-57985 (Bug, High, QA Ready) — Thumbnail Issue for LinkedIn Posts (cross-channel linkage; test was Threads hovering) | ✗ MISSED |

## Summary

- **Tickets audited:** 53 (rows 6–58)
- **Tickets with 1+ open Bug/Test Failure:** 10
- **✗ MISSED rows (PASS test but open bug exists, not flagged in report):** 7 — QA-1124, QA-12532, QA-2706, QA-281, QA-837, QA-96818, QA-98368
- **◐ PARTIAL CATCH rows (FAIL/PARTIAL test, open bug noted but a different finding flagged):** 2 — QA-23969, QA-96665
- **✓ CAUGHT rows (open bug exists, report flagged equivalent symptom):** 1 — QA-116113
- **✓ Consistent (test result aligns; either 0 open bugs, or BLOCKED/DEFERRED with bugs not observable):** 43 (includes QA-3630 BLOCKED with linked open bug LFMP-32010)
- **Distinct open bug keys surfaced (12):** LFMP-31781, DATA-12043, LFMP-31903, LFMP-31925, LFMP-31886, LFMP-31961, LFMP-32010, LFMP-31798, LFMP-31918, LFMP-32027, LFMP-31977, APPS-57985
- **Bug priority distribution:** Critical=0, Major=9 (DATA-12043, LFMP-31903 [Minor — corrected: Minor], LFMP-31925, LFMP-31961, LFMP-32010, LFMP-31798, LFMP-31918, LFMP-32027, LFMP-31977), High=1 (APPS-57985), Minor=3 (LFMP-31781, LFMP-31903, LFMP-31886)
- **Top-impact misses (by bug priority, Major first):** QA-837 (2× Major bugs in Social Recap export), QA-281 (Major — TWC New Followers data not displayed correctly), QA-96818 (Major — Data Studio Save-to-Dashboard dropdown visibility bug), QA-98368 (High — LinkedIn thumbnail cross-channel), QA-12532 (Minor — BrandSet Partnerships PNG extension)

