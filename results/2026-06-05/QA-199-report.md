# QA-199 — TWC TSV Exports - Relative Dates (re-run 2026-06-05 batch-2)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-199
- **Account:** Adam Orfei (account_id=54)
- **Brand:** Hulu (per Rule 1 — exact match selected from Results list, not Recent Searches)
- **Date Range Type:** Relative Dates — Start=3 Days Before / End=1 Day After. Key Date set to Jun 5 2026 (calendar fallback, not Season/Episode).
- **Metric:** Facebook New Fans
- **Story ID:** 154217
- **Built Report Header:** `Time Window Comparison (3 Days Out - 1 Day Post)`

## Result: FAIL — TSV `Date` column contains RELATIVE labels (`3 Days Out`, `2 Days Out`, `1 Day Out`, `Event Day`, `1 Day Post`), NOT absolute dates as the spec description requires.

The QA-199 spec description reads "TSV exports displays the correct **absolute** dates." The downloaded TSV file content shows relative day labels in the Date column instead of resolved absolute dates anchored to the Key Date.

## Steps executed
1. Reporting → Time Window Comparison (Adam Orfei context).
2. Selected **Relative Dates** tab.
3. Added Hulu brand via Add Brand By Name typeahead — picked from Results, not Recent Searches.
4. Set Start = 3 (Days, Before), End = 1 (Days, After).
5. Filter Metrics input "Facebook New Fans" → label.click() ticked the leaf — `aria-checked=true` confirmed.
6. Clicked Select Key Date on Hulu row → calendar opened in `key-date__modal` → clicked day 5 (June 2026) → cell shows `Jun 5, 2026`.
7. Clicked Run Report → story id 154217 rendered with line chart + table (5 buckets: 3 Days Out / 2 Days Out / 1 Day Out / Event Day / 1 Day Post).
8. Captured in-report numerics: 1,826 / 2,250 / 5,962 / 6,577 / 5,867.
9. Clicked Export → TSV → file saved to disk.
10. Re-opened Export menu and triggered CSV + XLS — those downloads did not materialize in this session (server-queued or path mismatch). TSV was sufficient for primary assertion.

## TSV file inspected (on disk)
- **Filename:** `Hulu - Time Window Comparison - 3 Days Out - 1 Day Post.tsv` (186 bytes, saved 2026-06-08 09:08 PT)
- **Contents (tab-separated, BOM-prefixed):**
  ```
  Perspective	Brand	Date	Facebook New Fans
  Public	Hulu	3 Days Out	1826
  Public	Hulu	2 Days Out	2250
  Public	Hulu	1 Day Out	5962
  Public	Hulu	Event Day	6577
  Public	Hulu	1 Day Post	5867
  ```

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 7 | Report renders Relative Dates with concrete absolute date X-axis labels | X-axis shows relative labels `3 Days Out` / `2 Days Out` / `1 Day Out` / `Event Day` / `1 Day Post` (no absolute dates) | OBSERVED — UI matches Relative-mode behavior; absolute dates not shown |
| A2 | 9 | TSV downloads with `.tsv` extension and tab-separated payload | File extension `.tsv`; payload tab-separated (4 tab chars per data row) verified | PASS |
| A3 | 9 | TSV header row contains Brand + Metric labels matching the report | Header: `Perspective\tBrand\tDate\tFacebook New Fans` — matches | PASS |
| **A4** | **9** | **TSV date column contains the absolute dates derived from the relative range** | **Date column contains relative labels (`3 Days Out`, `2 Days Out`, `1 Day Out`, `Event Day`, `1 Day Post`) — NO absolute date resolution against Key Date Jun 5 2026** | **FAIL** |
| A5 | 9 | TSV numeric cells match the rendered TWC tile values | 1826 / 2250 / 5962 / 6577 / 5867 all match the UI table | PASS |
| A6 | 9 | En-dash (`–`) absent in TSV cells | No em-dash in any cell | PASS |
| A7 | 9–11 | CSV / XLS / Google Sheets payloads numerically match TSV | CSV + XLS triggers did not produce files on disk this session (UI menu opens correctly, click registered; server-queued path appears different from TSV's immediate-download path). Re-test recommended. | NOT VERIFIED |

## Bug history

- Closed: APPS-43327 (Classic Reporting > TWC - Relative Weeks Date is displayed as Wednesday to Tuesday instead of Weeks aligned to Event)
- Closed: APPS-42928 (Classic Reporting > TWC - Relative Weeks Date is displayed as Monday to Sunday instead of Weeks aligned to Event)
- Both prior closures were about relative-week alignment, not "TSV exports lacking absolute dates" — A4 finding may be a new regression or a long-standing spec-vs-product mismatch.

## Findings

1. **A4 — Relative→Absolute resolution missing in TSV export (NEW finding 2026-06-05).** The QA-199 spec calls for TSV exports to display "the correct absolute dates" when the report is built with Relative Dates. Actual export contains the relative labels. The Key Date anchor (Jun 5, 2026) is known to the system, and the in-report tile shows numerics for each relative bucket; what's missing is the date-resolution layer in the TSV serializer.
   - Suggestion to LFIQA: either (a) file a new product bug (Reporting > TWC > Relative Dates > TSV export missing absolute-date resolution) or (b) update the spec to say "TSV exports display relative-day labels matching the in-report axis" if that's intentional. Either resolution unblocks the assertion.
2. **A7 — CSV / XLS triggers silent in this session.** Export menu opens, options Google Sheets / CSV / TSV / XLS all visible and clickable, but only TSV produced a file on disk during this run. Multiple retries (JS + coordinate click) over ~30s did not yield a CSV or XLS download in the ~/Downloads mount. The TSV path appears to be immediate-download; CSV/XLS may be server-queued and require the Recent Activity bell pickup which didn't complete this session. Not blocking QA-199 (TSV is the explicit subject); should be re-verified in a clean session.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-199-report.md`
- `/Users/yashsharma/git/magpie/testcases/english/QA-199.md`

## Bug reproduction outcomes
- No prior open bugs for QA-199. New finding A4 documented above; no Jira ticket created per protocol.
