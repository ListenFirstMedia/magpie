---
id: QA-81494
title: Reporting > Data Studio - Report Table - Export Functionality - PNG
run_date: 2026-07-11
mode: unattended-headless (Playwright MCP)
account: Adam Orfei (account_id=54)
report_id: 302163
verdict: PASS
---

# QA-81494 — Data Studio Graph Export (PNG)

**Verdict: PASS (8/8)**

Page-Level Data Studio graph built for Food Network + Disney Channel (Days interval, metrics
Fan Growth Rate + Facebook Engagements + YouTube Engagements), exported to PNG and verified
end-to-end on disk. Matches the prior 2026-06-04 PASS.

## Preconditions
- Logged in as the config/.env identity (lfiqa) on the **Adam Orfei** account (account_id=54) — the
  spec precondition "logged in as Adam Orfei" is satisfied (account context already Adam Orfei; no
  switch needed).

## Steps executed
1. Hover **Reporting** top-nav → click **Data Studio** → `#explore/reporting/data_studio` loaded.
2. Report builder rendered (default **Page Level**).
3. Clicked the **Interval** dropdown → selected **Days** (was already the default; clicked explicitly).
4. Clicked the **Search for a Brand** textbox.
5. Typed **Food Network** → selected the exact-match `Food Network` result (Rule 1); typed
   **Disney Channel** → selected the exact-match `Disney Channel` result. Both rows added,
   View = **Public** (default).
6. **Select Metrics** → searched and selected:
   - **Fan Growth Rate** (leaf under the `Follower Growth Rate` node — spec calls it the "Fan
     Growth Rate Node"; UI renders the parent node label as `Follower Growth Rate` but the top-level
     `Fan Growth Rate` leaf exists and was selected. Documented spec-drift, not a defect.)
   - **Facebook Engagements** (under the Engagements node)
   - **YouTube Engagements** (under the Engagements node)
7. Clicked **Go** → report built (`report_id=302163`), Line chart + data table rendered.
8. Clicked **Export** dropdown → clicked **Graph → PNG**. Playwright `download` event fired; file
   saved to `.playwright-out/`.

## Evidence
- **Report on screen:** graph title `Fan Growth Rate`; Line chart; Legend = `Food Network [P]` +
  `Disney Channel [P]`; X-axis Jul. 04 → Jul. 10, 2026; Y-axis rate values 0.00% / 0.01%.
- **Data table** (Public perspective, both brands):
  - Fan Growth Rate: Food Network Sum `–` (Avg-only rate values `>-0.01%`…`<0.01%`); Disney Channel `–` (`<0.01%`…`0.01%`).
  - Facebook Engagements: Food Network Sum **35,723**; Disney Channel Sum **132,873**.
  - YouTube Engagements: Food Network Sum **23,680**; Disney Channel Sum **6,272**.
- **Downloaded PNG** (on disk, 49,566 bytes, `PNG image data, 1264 x 603, 8-bit/color RGBA`):
  - On-disk (slugified): `.playwright-out/QA-81494/Food-Network-Data-Studio-Fan-Growth-Rate-Line-2026-07-04-2026-07-10.png`
  - Server-emitted name (spaces preserved): `Food Network-Data-Studio-Fan Growth Rate-Line-2026-07-04-2026-07-10.png`
  - Rendered-PNG read confirms: LISTENFIRST logo+wordmark top-left; `Fan Growth Rate` header beneath it;
    Legend `Food Network [P]` + `Disney Channel [P]`; footer LF icon + `Reporting Data Studio` +
    `Date: Jul. 04, 2026 - Jul. 10, 2026`; X-axis Jul. 04–Jul. 10; Y-axis 0.00% / 0.01%;
    two plotted lines (Food Network purple, Disney Channel orange) matching the on-screen graph.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 8 | Filename `Food Network(Primary Brand)-Data-Studio-Graph Title(First metric)-Line-YYYY-MM-DD-YYYY-MM-DD.png` | Server name `Food Network-Data-Studio-Fan Growth Rate-Line-2026-07-04-2026-07-10.png` (Food Network=primary/first brand, Fan Growth Rate=first metric=graph title, Line, 7D window Jul 04–10 2026). On-disk name slugifies spaces→hyphens (Playwright artifact, not product). | PASS |
| A2 | 8 | The report matches the PNG export | PNG line chart (2 series, same brands/metric/dates) matches the in-app graph exactly | PASS |
| A3 | 8 | LISTENFIRST header with logo top-left | LISTENFIRST logo + wordmark rendered top-left | PASS |
| A4 | 8 | Header 'Fan Growth Rate' under the LISTENFIRST header | `Fan Growth Rate` title directly beneath the logo | PASS |
| A5 | 8 | Legend: Food Network and Disney Channel available | Legend shows `Food Network [P]` and `Disney Channel [P]` | PASS |
| A6 | 8 | 'Reporting Data Studio with Listenfirst icon' and 'Date Range' below | Footer: LF icon + `Reporting Data Studio` + `Date: Jul. 04, 2026 - Jul. 10, 2026` (below the chart; a graph PNG carries no table — spec's "under the table" wording refers to the report footer, content present) | PASS |
| A7 | 8 | Dates on the X-axis | X-axis: Jul. 04, 05, 06, 07, 08, 09, 10 | PASS |
| A8 | 8 | Rate values on the Y-axis | Y-axis: 0.00%, 0.01% | PASS |

## Known bugs checked
- `knowledge-base/bug-history.md` QA-81494: **0 open bugs** ("None open"); case file lists no linked
  bugs. Prior 2026-06-04 run was a clean PASS (8/8). No known bug applied to or interfered with any
  step/assertion this run. LFMP-31903 (missing-`.png`-extension) is tile-PNG-specific (Brand Sets>
  Partnerships) and does not apply to the Data Studio graph export — the file saved with a correct
  `.png` extension.

## Bugs filed
None.

## Notes
- On-disk filename slugification (spaces→hyphens) is a Playwright save artifact; the server-emitted
  download-event name preserves spaces and matches the spec pattern. Assert against the server name.
- Spec "Fan Growth Rate Node" vs UI "Follower Growth Rate" node label is documented spec-drift
  (the `Fan Growth Rate` leaf exists and was selected) — not a defect.
