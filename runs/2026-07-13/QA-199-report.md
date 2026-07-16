# QA-199 — TWC - TSV Exports - Relative Dates

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Status:** ❌ FAIL-with-finding (re-confirms 2026-06-05 / 2026-06-13 Chrome-MCP finding, now also reproduced on Playwright MCP and shown to affect the in-app report itself, not just the export)

## Steps executed
1. Reporting → Time Window Comparison (`https://app-reporting.lfmdev.in/#/time_window_comparison`).
2. Clicked **Relative Dates** tab.
3. Added brand **Hulu** (typed "Hulu", selected exact-match "Hulu" from Results, not Recent Searches — Rule 1).
4. Set Key Date via **Select Key Date** button on the Hulu row → Calendar view rendered directly (no Filter/Season-Episode tabs, since Hulu isn't a TV-show/film brand) → picked **July 7, 2026** as the Event date.
5. Set **Start = 7** (Before Event, default direction), **End = 1** (After Event, default direction).
6. Selected data point **Facebook New Fans** (Audience & Growth → Fan Growth).
7. Clicked **Run Report** → built story `155905` ("Hulu — Time Window Comparison (7 Days Out - 1 Day Post)").
8. Export → **TSV** → downloaded `Hulu - Time Window Comparison - 7 Days Out - 1 Day Post.tsv`.
9. Export → **CSV** → downloaded `Hulu - Time Window Comparison - 7 Days Out - 1 Day Post.csv`.
10. Export → **XLS** → downloaded `Hulu - Time Window Comparison - 7 Days Out - 1 Day Post.xlsx`.
11. Google Sheets export **skipped** — out of scope for this track per `config/env.md` (Google 2FA on separate auth surface).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 (built report) | Report renders Relative Dates with concrete absolute-date X-axis labels | Chart + table render **relative labels**: `7 Days Out, 6 Days Out, 5 Days Out, 4 Days Out, 3 Days Out, 2 Days Out, 1 Day Out, Event Day, 1 Day Post` — no absolute dates anywhere in the built report, not even on hover | ❌ FAIL |
| A2 | 6 | TSV downloads with `.tsv` extension, tab-separated payload | Confirmed: `Hulu - Time Window Comparison - 7 Days Out - 1 Day Post.tsv`, tab-delimited, verified on disk | ✅ PASS |
| A3 | 6 | TSV header rows contain Brand + Metric labels matching the report | Header: `Perspective  Brand  Date  Facebook New Fans` — matches | ✅ PASS |
| A4 | 6 | TSV date column contains absolute dates derived from the relative range (no `Last 7 Days`-style placeholder) | Date column contains the same relative labels as A1 (`7 Days Out` … `1 Day Post`), not absolute calendar dates | ❌ FAIL |
| A5 | 6 | TSV numeric cells match rendered TWC tile values | `1739, 2524, 4283, 4655, 7302, 4020, 3420, 3956, 3865` — exact match to on-screen table | ✅ PASS |
| A6 | 6 | En-dash (`–`) absent in TSV cells | No em-dash present; all 9 rows populated (Data Last Updated 07-12-2026 covers the full window) | ✅ PASS |
| A7 | 7–9 | CSV / XLS payloads numerically match TSV | CSV: identical values, comma-quoted, same relative-label Date column. XLS (`.xlsx`, verified via `sharedStrings.xml` + `sheet1.xml`): same header + same relative labels + same 9 numeric values (1739…3865). Full 3-way parity — including the defect. | ✅ PASS (parity holds, but propagates the same defect) |

## Finding

**TWC Relative-Dates reports — both the on-screen story AND all three export formats (TSV/CSV/XLS) — render relative offset labels ("N Days Out" / "Event Day" / "N Day(s) Post") in the Date column instead of concrete absolute calendar dates.** This confirms and extends the 2026-06-05/2026-06-13 Chrome-MCP finding (which was scoped to the export files) — under Playwright MCP the same defect is visible in the **built report UI itself**, before any export happens. Filename generation also inherits the relative labels (`... - 7 Days Out - 1 Day Post.tsv`), which is a reasonable/arguably-correct behavior for a filename but reinforces that absolute dates are never resolved anywhere downstream of the Relative Dates picker.

This is a candidate product bug (or a spec-wording issue if "absolute date X-axis labels" was never actually intended for Relative Dates mode — re-read the spec's intent before filing). Per Rule 5, recommend the reporting team confirm intent before this is escalated as a new Jira bug (no bug ticket number found tied to this in `bug-history.md` beyond the informal "candidate Bug or spec rewrite" note from 2026-06-13).

## Bugs filed

None (re-confirms known unfiled finding; recommend filing "TWC Relative Dates never renders absolute calendar dates, in-app or exported" if not already tracked).

## Cleanup

Not applicable — read-only report + exports, no mutation. Story `155905` is harmless and can be left in place or deleted.
