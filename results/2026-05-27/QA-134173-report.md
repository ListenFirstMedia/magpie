# QA-134173 — Settings > Custom Metric - Info View — Run Report

- **Date:** 2026-05-29
- **Account:** Adam Orfei (account_id=54)
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-134173.md

## Result: PASS

## Execution
1. Top Nav → Settings → Custom Metrics (URL `#custom-metrics`). Table columns: Metric, Description, Created Date, Creator, Formula, Actions.
2. Hovered Metric column header / first-row Metric cell ("Cross-Channel Engagements") **without** Info mode → no persistent tooltip rendered.
3. Clicked **Info** button (top-right next to Help Center) → Info button toggled to highlighted state (blue background, white text); Info mode ON.
4. With no element hovered → no tooltip yet displayed (tooltip is bound to hover).
5. Hovered each column in turn:
   - Metric → tooltip: **`Metric` / `The name of your custom metric`**.
   - Description → tooltip: **`Description` / `The description of your custom metric`**.
   - Created Date → tooltip: **`Date Created` / `The date when your custom metric was created`**.
   - Creator → tooltip: **`Creator` / `The user who created your custom metric`**.
   - Formula → tooltip: **`Formula` / `The formula that makes up your custom metric`**.
6. Clicked Info button again → Info mode OFF; hovering Metric column produced no tooltip.

## Assertions
- **A1 (3) No tooltip when hovering columns without Info mode:** PASS.
- **A2 (4) Info button toggles Info mode ON (visual state change to blue/highlighted):** PASS.
- **A3 (5) When Info mode ON and no hover, no element-specific tooltip yet:** PASS — tooltip is hover-bound; no "default/generic" tooltip is shown while pointer is in empty space.
- **A4 (7-16) Tooltip header + description update dynamically per hovered column:** PASS — verified for Metric, Description, Created Date (header reads `Date Created`), Creator, Formula.
- **A5 (17) Clicking Info button again dismisses Info mode and tooltip:** PASS — Info button reverts to neutral state; subsequent hover shows no tooltip.

## Notes
- Header label nuance: the **Created Date** column shows tooltip header **"Date Created"** (noun-phrase order swapped vs. column header). Cosmetic but worth noting — analysts looking for "Created Date" in the tooltip will find "Date Created" instead.
- The tooltip card is anchored at a fixed lower-left position on the page (does NOT follow the cursor), which is consistent with the persistent-info-card pattern used elsewhere in the platform.
- Info button states: OFF = outlined / neutral text; ON = filled blue + white text.
- This test is the **read-side sibling** of QA-134185 (Info View on the Create Custom Metric screen). The toggle mechanism and tooltip-anchor position are identical.

## Evidence
- URL remained `https://app.lfmdev.in/#custom-metrics` throughout (Info mode is client-side; no URL/state change).
- Tooltip persistence: tooltip card stays visible at lower-left while pointer hovers any column cell; updates without flicker when pointer moves between columns.
