# QA-81494 — Data Studio Report Table - Export Functionality - PNG (PASS)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-81494
- **Run date:** 2026-06-04 (QA-4325 batch 5 re-run)
- **Env:** Dev (`app.lfmdev.in`); Adam Orfei account; Data Studio Page Level
- **Brands:** Food Network (Primary) + Disney Channel (both Public)
- **Metrics:** Fan Growth Rate (Graph Metric for export), Facebook Engagements, YouTube Engagements
- **Date range:** May 27, 2026 – Jun 02, 2026 (7D default; Interval = Days)
- **Report ID:** 294075
- **Result:** PASS (8/8 assertions verified end-to-end via PNG inspection on disk)

## Steps executed

| Step | Action | Result |
|---|---|---|
| 1 | Hovered "Reporting" top-nav | Dropdown opened |
| 2 | Clicked "Data Studio" in dropdown | Navigated to `app.lfmdev.in/#explore/reporting/data_studio?account_id=54`; default 7D + Days interval |
| 3 | Interval = "Days" (default) | Confirmed |
| 4 | Clicked "Add a Brand" textbox | Focus on typeahead |
| 5 | Typed "Food Network" → clicked the literal Results entry "Food Network" (Rule 1) | Row added with View toggle Public (default per known-quirk). Then typed "Disney Channel" → clicked exact "Disney Channel" Results entry. Two brand rows. |
| 6 | Clicked "Select Metrics", searched/toggled Facebook Engagements, YouTube Engagements (Engagements > Engagements sub-tree, FB + YT icons), and Fan Growth Rate (top-level under Followers > Follower Growth Rate parent — spec drift discussion below) | Metric tree showed all three as checked: ["Fan Growth Rate","Facebook Engagements","YouTube Engagements"] |
| 7 | Closed Select Metrics modal; clicked Go button | Report `report_id=294075` generated; Graph Metric dropdown defaulted to "Facebook Engagements" |
| 7a (spec adherence) | Switched Graph Metric dropdown to "Fan Growth Rate" (spec selected Fan Growth Rate FIRST in step 6) | Chart re-rendered Fan Growth Rate line plot for both brands |
| 8 | Clicked Export → PNG (Graph subsection) | Browser saved `~/Downloads/Food Network-Data-Studio-Fan Growth Rate-Line-2026-05-27-2026-06-02.png` (101,392 bytes) |

## Spec drift / naming-resolution notes

The spec writes "Fan Growth Rate" as both a metric name and a parent-node name. The current UI exposes:
- Top-level `Fan Growth Rate` leaf (aggregate; selected for this run)
- Plus `Facebook Fan Growth Rate`, `Twitter Follower Growth Rate`, `YouTube Subscriber Growth Rate`, `Instagram Follower Growth Rate`, `TikTok Follower Growth Rate` under the `Follower Growth Rate` `<details>` node
- Plus the note `Authenticated Data Unavailable for Public Perspectives`

Spec's "Fan Growth Rate Node" → UI's `Follower Growth Rate` `<details>` parent; spec's "Fan Growth Rate Metric under that node" → UI's top-level `Fan Growth Rate` leaf. Confirmed selection persisted across modal close + Go.

## Assertion results (PNG verified end-to-end on disk)

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 8 | File name `Food Network(Primary Brand Name)-Data-Studio-Graph Title(First metric name)-Line-YYYY-MM-DD-YYYY-MM-DD.png` | `Food Network-Data-Studio-Fan Growth Rate-Line-2026-05-27-2026-06-02.png` — exact pattern match (Primary Brand = Food Network; First metric name = Fan Growth Rate; type = Line; dates = `2026-05-27-2026-06-02`) | PASS |
| A2 | 8 | Report matches the PNG export | PNG line chart shape (Food Network blue trough + Disney Channel orange peak Day 4) matches the on-screen rendered chart | PASS |
| A3 | 8 | LISTENFIRST header with logo top-left of PNG | Logo + "LISTENFIRST" wordmark present at coordinates (top-left of PNG) | PASS |
| A4 | 8 | Header "Fan Growth Rate" under the LISTENFIRST header | "Fan Growth Rate" text below the logo | PASS |
| A5 | 8 | Legend: Food Network and Disney Channel | Legend strip shows "Legend: [blue swatch] Food Network [P] [orange swatch] Disney Channel [P]" — both brands present with Perspective badges | PASS |
| A6 | 8 | "Reporting Data Studio with Listenfirst icon" and "Date Range" under the table | PNG footer shows LF icon + "Reporting Data Studio" + "Date: May. 27, 2026 - Jun. 02, 2026" | PASS |
| A7 | 8 | Dates on X-axis | X-axis labels: May. 27, May. 28, May. 29, May. 30, May. 31, Jun. 01, Jun. 02 | PASS |
| A8 | 8 | Rate values on Y-axis | Y-axis labels: 0.00%, 0.01% (rate percentages with % suffix) | PASS |

## Evidence

```
ls -la ~/Downloads/'Food Network-Data-Studio-Fan Growth Rate-Line-2026-05-27-2026-06-02.png'
-rw------- 101392 Jun 4 06:26 'Food Network-Data-Studio-Fan Growth Rate-Line-2026-05-27-2026-06-02.png'
```

PNG visual inspection (rendered): LISTENFIRST logo top-left, "Fan Growth Rate" title, Legend with Food Network [P] + Disney Channel [P] swatches, line chart with Y-axis 0.00%/0.01% and X-axis dates May. 27 → Jun. 02, footer with LF icon "Reporting Data Studio" and "Date: May. 27, 2026 - Jun. 02, 2026".

## Bugs filed

None. All 8 assertions PASS end-to-end.

## Files

- `~/Downloads/Food Network-Data-Studio-Fan Growth Rate-Line-2026-05-27-2026-06-02.png` — 101,392 bytes
- `outputs/qa-81494-png/...png` — copy for evidence reading

## Skill registry impact

No existing `data-studio-page-level-export-png` skill. Mechanic differs from `audience-metrics-export` (which is single-tile Brand>Audience). Candidate for a future `data-studio-export-png` skill bundling: brand-typeahead-add → metric-tree-toggle → Go → Graph Metric switch → Export → PNG verification.
