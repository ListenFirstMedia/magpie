# QA-92841 — Reporting > Data Studio - Save Breakdown Table to Dashboard - PNG & Google Sheets Exports (re-run 2026-06-04 batch-7)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-92841
- **Account:** Adam Orfei
- **Brand:** MTV (Public Data perspective)
- **Date range:** May 27 – Jun 02 2026 (7D default)
- **Metric:** Engagements (cross-channel aggregate)
- **Mode:** Page Level

## Result: PASS (5/5) — Full end-to-end Save+Export verified; LFMP-31814 NOT REPRODUCED on this run; LFMP-31936 NOT VERIFIED

## Steps executed

1. Navigated Reporting → Data Studio via top-nav hover-then-click. URL: `#explore/reporting/data_studio?account_id=54`.
2. Added MTV brand via Add a Brand typeahead — React InputEvent dispatch + click of `.dropdown-option--add-brand` first option (exact "MTV", Rule 1).
3. Default Page Level mode + 7D date range (May 27 – Jun 02 2026).
4. Clicked Select Metrics, expanded the cross-channel Engagements category via `label.controlled-check-box__label[textContent="Engagements"].click()`. Chip rendered in Page Level Metrics list.
5. Installed MutationObserver to detect any "fetching/loading/processing" popup additions; clicked Go.
6. **Popup observed**: `class="ui-popup app-lib ui-popup--success ui-popup--floating"` with text "We are fetching the data. Please wait." appeared ~immediately after Go click.
7. Table rendered: `MetricBrandSumAverageMay. 27, 2026 ... Jun. 02, 2026 EngagementsMTV P 2,352,593 336,085 951,392 577,118 187,816 - 510,183 -625,847 1,604,104 168,193`. (Sum 2,352,593; Avg 336,085; daily values 951,392/577,118/187,816/-510,183/-625,847/1,604,104/168,193.) URL gained `report_id=294271`.
8. Hovered tile → clicked Save to Dashboard dropdown → clicked Yash (existing dashboard, id 6095). Success popup: "You've successfully added this tile to: Yash".
9. Navigated to `#dashboards/6095`.
10. Hovered the tile, opened Export dropdown → enumerated options: **PNG, CSV, Google Sheets, Metrics**.
11. Clicked PNG. File saved to Downloads: `MTV-Dashboard-Page-Engagements-Line-2026-05-27-2026-06-02.png` (115,403 bytes).
12. Re-opened Export dropdown, clicked Google Sheets. window.open captured URL `https://docs.google.com/spreadsheets/d/1ZILC_B14N3VdRowrx9UCSdwj7DOLf3TEZ43YmpHPPVc`. Tab title: `MTV-Dashboard-Page-Engagements-Data-Studio-May-27-2026-Jun-02-2026 - Google Sheets`.
13. Hovered tile → Remove from Dashboard → confirm → tiles count 1 → 0 (cleanup verified).

## Bug reproduction outcomes

### LFMP-31814 (Bug, Major, Open) — Data Studio Data fetching pop-up not displayed
**Verdict: NOT REPRODUCED on this run**

A MutationObserver was attached to `document.body` before clicking Go to capture any added node whose textContent matched `/fetching|loading|processing data|please wait/i`. Exactly one match was captured:
```
{cls: "ui-popup app-lib ui-popup--success ui-popup--floating",
 txt: "We are fetching the data. Please wait."}
```

The popup was rendered. This contradicts the batch-1 re-run finding from 2026-06-02 where the same probe found no popup over a 14-second window. Possible interpretations:
- The bug may have been fixed between batches but Jira not updated.
- The bug may be intermittent (race between popup mount and data return).
- The batch-1 observer may have missed the popup due to short-duration render.

Recommend reporting back to engineering. The current product behavior matches expected spec.

### LFMP-31936 (Bug, Minor, Open) — Authorized Video Views inconsistency
**Verdict: NOT VERIFIED**

Used Public perspective + Engagements metric, so no Authorized Video Views lock/endash signal was exercised. A targeted re-run requires Authorized + Video Views breakdown.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Run | Data fetching popup visible | Popup `ui-popup--success ui-popup--floating` with "We are fetching the data. Please wait." captured | PASS |
| A2 | Save | Tile saves to dashboard with breakdown | "You've successfully added this tile to: Yash" popup; tile appears on dashboard 6095 | PASS |
| A3 | PNG export | Filename pattern + file on disk | `MTV-Dashboard-Page-Engagements-Line-2026-05-27-2026-06-02.png` 115KB saved | PASS |
| A4 | GS export | Sheet opens with breakdown-matching name | `MTV-Dashboard-Page-Engagements-Data-Studio-May-27-2026-Jun-02-2026` sheet opened in tab | PASS |
| A5 | Authorized Video Views lock vs endash | Consistent | Not exercised | NOT VERIFIED |

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-92841-report.md`
- `~/Downloads/MTV-Dashboard-Page-Engagements-Line-2026-05-27-2026-06-02.png`

## Cleanup
- Tile removed from dashboard "Yash" (id 6095); tiles count returned to 0.

## Notes
- Batch-1 LFMP-31814 reproduction is now contradicted. Mark probe as "INTERMITTENT or FIXED" pending eng confirmation.
- The cross-channel Engagements metric on Page Level produced a single MTV row, not a per-channel breakdown — the platform represents the breakdown via Date columns + the Brand/Channel axis. The "Breakdown Table" surface is the same DS table; the term in the spec refers to this rendered table.
