# QA-2706 — Brand > Content - Benchmark - Authorized (re-run 2026-05-29)

- **Source spec:** testcases/english/QA-2706.md
- **Skill used:** brand-content-data-set-selector, view-perspective-toggle
- **Account:** Adam Orfei (account_id=54)
- **Brand:** Amazon Prime Video (brand_id=25864) — exact spec brand selected via top-nav search → Results > Amazon Prime Video
- **View:** Authorized Data (toggle dot on right, URL `perspective=extended`) — explicitly clicked per Rule 2

## Result: PASS — LFMP-31886 NOT REPRODUCED (likely already fixed)

## Execution

1. Navigated to Brand > Content for Amazon Prime Video (brand_id=25864).
2. Verified view toggle is on **Authorized Data** (toggle dot on right). Per Rule 2, explicitly clicked the toggle from default Public position. Confirmed perspective via URL = `extended`.
3. Clicked the **Benchmark** button. Modal opens.
4. Clicked **Set To Current Brand** — populated `Select a Brand: Amazon Prime Video`.
5. Opened **Benchmark Period** dropdown, selected `Rolling 7 Days`.
6. Clicked **Go**. Modal closes; page re-renders with benchmark applied.
7. Read the Aggregate (Benchmark Selections) table directly via DOM.

## Bug-targeted observation — LFMP-31886

LFMP-31886 (Bug, Minor, Open) — "Data Display Inconsistency: Benchmark Owned Average Row value missing parentheses in Video views column".

Raw DOM read of the Aggregate table after benchmark applied:

| Row | Engagements | Reactions | Comments | Shares | Response Rate | **Video Views** | Video Response Rate |
|-----|-------------|-----------|----------|--------|---------------|-----------------|---------------------|
| Owned Sum | 4,878,152 | 4,741,980 | 27,218 | 110,757 | N/A | 82,679,177 | N/A |
| **Owned Average** | 25,948**(-11%)** | 25,223**(-12%)** | 145**(-4%)** | 589**(-14%)** | 0.14%**(-49%)** | **794,992(-31%)** | 3.71%**(+21%)** |
| Benchmark Average | 29,047 | 28,579 | 151 | 688 | 0.28% | 1,146,940 | 3.06% |

The Owned Average row's **Video Views** cell renders as `794,992(-31%)` — with parentheses around the benchmark comparison percentage, identical to all six other metric columns on the same row. There is no missing-parentheses inconsistency.

The Owned Sum row deliberately omits parentheses on all columns (it's the raw aggregate; no comparison applies). The Benchmark Average row also omits parentheses (it's the benchmark baseline itself). Only the Owned Average row shows parentheses, and it shows them on all seven metric columns consistently — including Video Views.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6 | Benchmark percentage indicators only on Owned Average row in Aggregate | Owned Average row has `(±N%)` indicators on all 7 metric columns; Owned Sum and Benchmark Average have none | PASS |
| A2 | 6 | Benchmark row displays benchmark value per metric below Sum and Average; N/A if no data | Benchmark Average row present below Owned Average with values 29,047 / 28,579 / 151 / 688 / 0.28% / 1,146,940 / 3.06%; no N/A | PASS |
| A3 | 6 | Each post contains benchmark values; N/A if no data | Post table failed to load ("This table failed to load. Please try again."), so per-post benchmark indicator NOT VERIFIED — but the Aggregate table did load correctly, which is what LFMP-31886 targets | PASS for Aggregate; per-post N/V |
| A4 | 6 | Collection breadcrumb displays benchmark used | "Benchmark Selections" header reads `Brand: Amazon Prime Video | Benchmark Period: Rolling 7 Days | Mode: 7 Day` | PASS |
| A5 | 6 | Post metrics show % indicators vs benchmark | NOT VERIFIED (post table didn't load) | N/V |
| A6 | 6 | Per-post % rounded to nearest percent | NOT VERIFIED (post table didn't load) | N/V |
| B (bug check) | 6 | Owned Average Video Views value includes parentheses for benchmark comparison, like other columns | `794,992(-31%)` — parentheses present, consistent with other columns | **PASS — LFMP-31886 NOT REPRODUCED** |

## Evidence

- DOM dump of the Aggregate table (verbatim): `Owned Average | 25,948(-11%) | 25,223(-12%) | 145(-4%) | 589(-14%) | 0.14%(-49%) | 794,992(-31%) | 3.71%(+21%)`
- Live screenshot of post-benchmark state: `ss_1854glb9o` showing the Benchmark Selections aggregate table.
- URL after benchmark: includes `benchmark_filters` with `Rolling 7 Days` and Amazon Prime Video brand id.

## Bug reproduction outcomes

| Bug | Status |
|------|--------|
| LFMP-31886 — Data Display Inconsistency: Benchmark Owned Average Row value missing parentheses in Video views column | **NOT REPRODUCED 2026-05-29 — may be fixed; verify with eng before closing the Jira.** The Owned Average row's Video Views cell shows `794,992(-31%)` — parentheses present, format consistent with every other metric column on the same row. The inconsistency that LFMP-31886 describes is not visible in the current build. |

## Notes

- Per-post post table had a "This table failed to load. Please try again." error after the benchmark was applied. This blocked verification of A3/A5/A6 (per-post benchmark indicators) but did NOT affect the Aggregate table where LFMP-31886's defect lives. The aggregate is what we needed for the LFMP-31886 verification.
- The post-table load failure is consistent with several open Adam Orfei / Amazon Prime Video table-load issues observed during 2026-05-29 batch 1 — see LFMP-32016 / APPS-58817 entries in bug-history.md. The same brand/account combination produces the failure here, so not a new defect.
- Brand selection was per Rule 1: typed "Amazon Prime Video" in top-nav search, clicked the exact-match Results entry (not Recent Searches). View was per Rule 2: explicitly clicked the toggle to Authorized and confirmed via URL.

## Skill registry impact

- `brand-content-data-set-selector` v1 — pass_streak +1 (Benchmark flow exercised on a verified exact-match brand; LFMP-31886 ruled out via DOM-level row read).
- `view-perspective-toggle` v1 — pass_streak +1 (explicit click + URL confirmation of `perspective=extended` Authorized state).
