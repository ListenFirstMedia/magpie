# QA-134517 — Reporting > Data Studio: Verify layered tag filtering (Include + Exclude)

- **Run date:** 2026-07-13 (unattended, headless Playwright MCP)
- **Account:** Adam Orfei (id=54) — switched from Viacom via account typeahead (Results header, Rule 1)
- **Brand:** MTV (exact typeahead match, Rule 1; brand_view resolved to 10765 = MTV Public)
- **Page:** Reporting > Data Studio → Post Level (`/#explore/reporting/data_studio`)
- **Date range:** 30D (2026-06-12 → 2026-07-11)
- **Skill reused:** `brand-content-filter` (v3, 8th surface = Data Studio)
- **Verdict:** **PASS** — layered Include + Exclude tag filtering fully functional on Data Studio; prior FAIL (2026-06-04) confirmed FIXED.

## Steps executed

1. Logged in (Cognito existing-account form), landed on `#home`.
2. Switched account Viacom → **Adam Orfei** (typed into Search Account, clicked the **Results** entry, not Recent Searches). Confirmed header `Account: Adam Orfei`, `account_id=54`.
3. Navigated Reporting menu → **Data Studio** (via menu link, per known-quirks DS-direct-URL-blank guard).
4. Switched to **Post Level** tab; set date range **30D**.
5. Added brand **MTV** via "Search for a Brand" typeahead — exact "MTV" option (Rule 1), not a regional/family variant. Brand row rendered with Public/Authorized View toggle.
6. Opened **Filters → Select** dropdown → chose **Tag**. Sub-panel opened.
7. Verified panel structure (A1): search box, **Include/Exclude** radios, **Or/And** radios, Select All/None, 2,791-tag checkbox list.
8. With **Include** default-selected (Or default), selected tag **`01nikhil01`** → row shows `--selected` + `fa-check-square`.
9. Clicked **Exclude** radio → verified (A2) the Include-selected `01nikhil01` row became `--disabled` (`pointer-events:none`) — greyed/mutually-exclusive.
10. Selected Exclude tag **`000`**.
11. Closed the Tag dropdown → two pills rendered: **`Tag: 01nikhil01`** (green = Include) + **`Tag: 000`** (red = Exclude).
12. Opened **Select Metrics** → selected **Engagements** rollup; metric row registered.
13. Clicked **Go** → report ran (`report_id=302210`); captured the backend `fetch_job` payload (A3) and the rendered data table (A4).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Step 4 | Data Studio Tag Filter has Include + Exclude radios | Panel `header-configs` shows **Include** (`#radio-include`, role=radio) + **Exclude** (`#radio-exclude`) radios, plus **Or/And** radios, Select All/None, and 2,791-tag list (`.filter__option__row`). Distinct DS DOM (`.tag-filter-dropdown` / `.filter__option__row`). | **PASS** |
| A2 | Step 6 | Include-selected tags greyed when Exclude active | After clicking Exclude (aria-checked Include=false / Exclude=true), tag `01nikhil01` row = `filter__option__row--disabled` with computed `pointer-events:none` — greyed and unselectable. | **PASS** |
| A3 | Step 8 | URL or filter state encodes Include + Exclude tag predicates | Filter STATE encodes both: pill `Tag: 01nikhil01` = `filter__selection` (green bg `rgb(229,252,241)` / border `rgb(76,237,159)` = Include); pill `Tag: 000` = `filter__selection--exclude-filter` (red bg `rgb(252,229,229)` / border `rgb(236,76,76)` = Exclude). **Backend `fetch_job` payload** (definitive): `content_tags:[{operator:"or",values:["01nikhil01"],not:false},{operator:"or",values:["000"],not:true}]`. (DS serializes report config under `report_id=302210`, not an inline URL `filters=` param.) | **PASS** |
| A4 | Step 9 | Built report data reflects layered tag filter | `POST /analytics/fetch_job` carried the layered `content_tags` predicate (Include `not:false` + Exclude `not:true`) → HTTP 200 → report rendered. Data table: **Engagements / MTV[P] / Sum 3,466,682** with per-day values; no error/empty pane. | **PASS** |

## Evidence

- `.playwright-out/QA-134517/A1-tag-panel-include-exclude.png` — Tag sub-panel with Include/Exclude + Or/And radios + tag list.
- `.playwright-out/QA-134517/A2-include-greyed-under-exclude.png` — `01nikhil01` greyed under Exclude mode.
- `.playwright-out/QA-134517/A3-layered-include-exclude-pills.png` — green Include pill + red Exclude pill.
- `.playwright-out/QA-134517/A4-metric-tree-blocker.png` — metric tree modal (see automation note below).
- `.playwright-out/QA-134517/A4-report-rendered-layered-filter.png` — rendered report table with layered filter applied.
- Backend request body (`fetch_job`, index 191):
  ```json
  "content_filters":{"content_tags":[
    {"operator":"or","values":["01nikhil01"],"not":false},
    {"operator":"or","values":["000"],"not":true}
  ]}
  ```
- DS DOM (parity with `brand-content-filter` v3): rows `.filter__option__row(--selected/--disabled)`, radios `#radio-include`/`#radio-exclude` (`<i role=radio aria-checked>`), pills `.filter__selection` / `.filter__selection--exclude-filter`.

## Known bugs checked

- **knowledge-base/bug-history.md (grep QA-134517):** "Open bugs (0) — None." No linked Bug/Test-Failure. The prior entry recorded a **2026-06-04 FAIL-with-finding** ("DS Tag Filter uses LEGACY widget, only Or/And, NO Include/Exclude — same divergence as CPR/QA-134516").
- **known-quirks.md:** two conflicting records — (line 534) the older 2026-06-04 "DS lacks Include/Exclude" and (line 256) the newer **2026-06-13 "FIXED — DS now has full Include/Exclude"** (re-verified by skill v3 on 2026-07-10).
- **Case notes:** flagged CPR (QA-134516) as known to lack Include/Exclude; asked to determine if DS diverges too.
- **Outcome this run:** DS **HAS the full Include/Exclude layered filter** — the 2026-06-04 FAIL is **confirmed FIXED** and does not reproduce. DS does **NOT** share the CPR (QA-134516) divergence. The stale known-quirks entry (line 534, "DS lacks Include/Exclude") is now superseded and should be trimmed to CPR-only.

## Automation note

The DS metric-tree `.controlled-check-box` (FontAwesome `<i role=checkbox>`) is not reachable by a Playwright trusted click (visibility heuristic reports the inline `<i>` as not-visible after scroll). A synthetic `MouseEvent` dispatch on the checkbox **did** register the Engagements metric (async React), which unblocked **Go** and allowed the report to run — so A4 was verified end-to-end rather than blocked. This is a known DS metric-tree automation-friction point, not a product defect.

## Bugs filed

None. Feature works as specified across all 4 assertions.
