# QA-199 — TWC - TSV Exports - Relative Dates — 2026-06-13

- **Env:** Dev (app-reporting.lfmdev.in) · **Account:** Adam Orfei · **User:** LFQA
- **Data Last Updated (PT):** 06-12-2026 04:25 PM
- **Skills:** time-window-comparison-run v5, export-csv v2
- **Story built:** 154573 — Hulu / Facebook New Fans / Relative Dates (3 Days Out – 1 Day Post), key date Jun 8 2026 (Start 3 Before / End 1 After)
- **Result:** FAIL-with-finding (A1 + A4) — relative labels rendered instead of absolute dates. **Reproduces the 2026-06-05 batch-2 finding.**

## Steps executed
1. Reporting → Time Window Comparison (app-reporting.lfmdev.in).
2. Selected Relative Dates (banner: "Please select a relative date range of 4,565 days or less").
3. Added brand **Hulu** (Rule 1 — exact match from Results).
4. Key Date Label = Event; Start 3 Before, End 1 After; per-brand Key Date = Jun 8 2026; metric = Facebook New Fans (Audience & Growth 1/36, Fan Growth 1/8).
5. Run Report → story 154573 rendered.
6. Export → TSV (blob captured + read in-page — Rule 6).
7. Export → CSV (parity).

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Report renders Relative Dates with concrete **absolute date** X-axis labels | X-axis labels are **relative**: "3 Days Out / 2 Days Out / 1 Day Out / Event Day / 1 Day Post" | ❌ FAIL |
| A2 | TSV downloads `.tsv` + tab-separated | Filename `Hulu - Time Window Comparison - 3 Days Out - 1 Day Post.tsv`; payload tab-separated | ✅ PASS |
| A3 | TSV header has Brand + Metric labels | Header `Perspective⇥Brand⇥Date⇥Facebook New Fans` | ✅ PASS |
| A4 | TSV Date column = absolute dates from relative range (no placeholder) | Date column = **relative labels** ("3 Days Out"…"1 Day Post"), NOT absolute dates | ❌ FAIL |
| A5 | TSV numerics match TWC tile values | 6577 / 5867 / 7125 / 6240 / 3806 = table 6,577 / 5,867 / 7,125 / 6,240 / 3,806 exact | ✅ PASS |
| A6 | No en-dash in TSV cells | None present | ✅ PASS |
| A7 | CSV/XLS/GS payloads match TSV | CSV exact match (quoted, comma-sep): same values + same relative-label Date column | ✅ PASS (CSV verified; XLS/GS not exhaustively re-run) |

## Evidence — TSV payload (blob read, actual downloaded content)
```
Perspective	Brand	Date	Facebook New Fans
Public	Hulu	3 Days Out	6577
Public	Hulu	2 Days Out	5867
Public	Hulu	1 Day Out	7125
Public	Hulu	Event Day	6240
Public	Hulu	1 Day Post	3806
```
CSV identical numerics, quoted/comma-separated.

## Bugs filed
- **FINDING (re-confirmed, candidate Bug or spec rewrite)** — TWC Relative-Dates exports (TSV **and** CSV) emit **relative labels** in the `Date` column ("3 Days Out … 1 Day Post") rather than the absolute calendar dates the spec (A4) requires. The on-chart X-axis is likewise relative. Same behavior found 2026-06-05 (batch 2). Existing closed APPS-43327 / APPS-42928 concerned week-alignment, not absolute-date resolution. Recommend product/spec triage: either resolve relative→absolute in exports, or rewrite QA-199 A1/A4 to expect relative labels.

## Cleanup
- TWC story 154573 created (harmless; delete at will).
