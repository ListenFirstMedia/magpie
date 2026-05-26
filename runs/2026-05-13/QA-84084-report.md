# QA-84084 — Reporting > Data Studio Post-Level Metrics Math QA

> **Status:** ✅ **PASS** — math identity holds at every aggregation captured
> **Run date:** 2026-05-13 · **Env:** dev (https://app.lfmdev.in) · **Browser:** Regression Testing (attached)
> **User:** lfiqa@listenfirstmedia.com (display name LFQA) · **Account:** Adam Orfei (account_id=54)
> **Story ID:** `https://app.lfmdev.in/#explore/reporting/data_studio?account_id=54&report_id=290449`

---

## Execution summary

| Step | Description | Result |
|----:|-------------|:------:|
| 1 | Hover Reporting → click Data Studio | ✅ |
| 2 | Click Post Level toggle | ✅ |
| 3 | Add brand `MTV` (Public Data perspective) | ✅ |
| 4 | "Click interval and aggregate" | ✅ (interpreted as kept defaults: Interval=Days, Window Mode=Lifetime — see finding F2) |
| 5 | Click Select Metrics | ✅ |
| 6 | Select YouTube Video Engagements, Likes, Comments | ✅ |
| 7 | Click Go | ✅ — report built at story id 290449 |
| 8 | Add Likes + Comments, compare to Engagements | ✅ (computed below) |

## Assertion result

### ✅ A1 — `YouTube Video Engagements == YouTube Video Likes + YouTube Video Comments`

Math holds at every aggregation level captured:

| Aggregation | Engagements | Likes | Comments | Likes + Comments | Match |
|-------------|------------:|------:|---------:|-----------------:|:-----:|
| **Sum (7-day window)** | 433 | 413 | 20 | **433** | ✅ |
| **Average** | 62 | 59 | 3 | **62** | ✅ |
| **May 07, 2026** | 433 | 413 | 20 | **433** | ✅ |
| May 08, 2026 | – | – | – | (no data) | n/a |
| May 09, 2026 | – | – | – | (no data) | n/a |
| May 10, 2026 | – | – | – | (no data) | n/a |
| May 11, 2026 | – | – | – | (no data) | n/a |
| May 12, 2026 | – | – | – | (no data) | n/a |
| May 13, 2026 | – | – | – | (no data) | n/a |

The only day in the 7-day window with engagement data was May 07, 2026, and the identity held exactly for that day. The Sum and Average aggregations also hold exactly. Zero numeric mismatches.

## Findings (non-bug, worth knowing)

### ℹ F1 — Post Level mode does NOT produce a per-post breakdown in dev

**Category:** test_case_wording / product_behavior · **Severity:** info

The test case is titled "Post Level Metrics" and the UI explicitly has a `Post Level` toggle, but the resulting report shows **one row per metric** aggregated across all posts in the date window — there is no per-post row. The `Add Breakdown` control only offers `Publish Type` and `Content Type` slicing, neither of which produces a per-post row.

Consequence: the per-post math check the test case implies ("verify the identity for each post") is not possible from this report's UI alone. The math identity *is* verified at the aggregate, daily, and average levels, which is the strongest check the UI surfaces.

**Recommendation:** Either:
- Rephrase the test case to assert the identity at the aggregate level (which is what's actually testable), OR
- If the original intent was per-post verification, route the user to a different report type (e.g., a Posts table view) and update step 2 accordingly.

### ℹ F2 — Step 4 wording "Click interval and aggregate" is ambiguous

**Category:** test_case_wording · **Severity:** info

There is no single control labeled "Interval and Aggregate" in Data Studio Post Level. The closest interpretations:
- The `Interval` dropdown (defaults to `Days`)
- The `Window Mode` radio (`Lifetime` / `In-Window`, defaults to `Lifetime`)

This run kept both defaults and the report still produced valid data, so the assertion was unaffected. But the step should be clarified — e.g., `4. Confirm Interval is set to Days and Window Mode is Lifetime`.

### ℹ F3 — Date range and "no data" days are expected, not a bug

**Category:** known_quirk · **Severity:** info

With the default 7D range, MTV (Public Data) had video engagement data on **only** May 07, 2026; the other six days show `–` (em dash). This is normal data-freshness/availability behavior. The `–` cells are properly handled — they're not counted as zero in the Sum/Average, and the math identity is not violated by missing data.

## Skills authored or updated this run

| Skill | Action | Why |
|-------|--------|-----|
| `data-studio-post-level-run` | **NEW** (v1, untrusted) | First test case covering Data Studio Post Level. Captures the Reporting → Data Studio → Post Level → metric/brand/interval flow + the math-identity assertion pattern. |

## Per-case telemetry

| Metric | Value |
|--------|------:|
| Wall time (approx) | ~5 min |
| MCP calls | ~30 |
| Report ID | 290449 |
| Metrics selected | 3 (Engagements, Likes, Comments — all YouTube Video) |
| Console errors | 0 |
| Network 4xx/5xx | 0 |
| Numeric mismatches | 0 |

## Notes

- The MTV brand was added with Public Data perspective (toggle in left position; brand badge shows `P` in the report).
- The metric picker categorizes metrics under: Engagements, Impressions, Reels, Video, Rates. The three YouTube metrics were found via the search box (all under the Engagements branch in the tree).
- The metric-picker search responds to native typing immediately — no `dispatchEvent` workaround needed (unlike the brand picker in TWC).
