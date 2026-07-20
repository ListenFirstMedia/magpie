# QA-134185 — Settings > Custom Metric Creation - Info View — Run Report

- **Date:** 2026-05-29
- **Account:** Adam Orfei (account_id=54)
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-134185.md
- **URL:** `https://app.lfmdev.in/#custom-metrics/create`

## Result: PASS (with one observation: spec's "Metric Definition Link" element does not exist in current build — see Notes)

## Execution
1. Top Nav → Settings → Custom Metrics → clicked **Create a Custom Metric** → landed on `#custom-metrics/create`.
2. Hovered Name input WITHOUT Info mode → no persistent tooltip rendered.
3. Clicked **Info** button (top-right) → button switched to blue/highlighted; Info mode ON.
4. With cursor in empty page area → **generic page-level tooltip** rendered at lower-left: `Create Custom Metrics` / `This screen allows you to create your custom metrics`.
5. Hovered each Create-form element:
   - **Name** input → tooltip: `Name` / `Enter a name for your custom metric`.
   - **Description** input → tooltip: `Description` / `Enter a description for your custom metric`.
   - **Formula** input (Configure your metric formula) → tooltip: `Formula` / `Enter a formula for your custom metric`.
   - **Metric Definition Link** → NOT FOUND on Create screen — see Notes.
6. Clicked Info button again → Info mode OFF; hover on Name field returned no tooltip.

## Assertions
- **A1 (4) No tooltip when hovering Name without Info mode:** PASS.
- **A2 (5) Info button toggles Info mode (button state changes to filled blue/highlighted):** PASS.
- **A3 (6) Info mode shows generic page-level tooltip when no element hovered:** PASS — `Create Custom Metrics` / `This screen allows you to create your custom metrics`.
- **A4 (8-9) Hover Name → tooltip updates to Name header + Name description:** PASS.
- **A5 (10-11) Hover Description → tooltip updates:** PASS.
- **A6 (12-13) Hover Formula → tooltip updates:** PASS.
- **A7 (15a) Hover Metric Definition Link → tooltip updates:** **N/A — element not present** (see Notes).
- **A8 (14) Clicking Info dismisses Info mode (tooltip no longer appears on hover):** PASS.

## Notes
- The Create Custom Metric screen in the current build (`#custom-metrics/create`) contains exactly three form elements: **Name**, **Description**, **Formula (Configure your metric formula)**, plus Cancel / Save buttons. There is no visible "Metric Definition Link" element — neither as a link, an info-icon, nor an external-docs anchor. This may be a planned/removed element, or it may refer to the *Help Center* link that lives in the top-right page chrome (not specific to Create Custom Metric). Recommend confirming with the spec author whether (a) the element was removed from production, (b) it was renamed to "Help Center", or (c) it is gated behind a feature flag.
- The Info-mode tooltip card is anchored at a fixed bottom-left position on the page and does NOT follow the cursor — same anchor pattern as QA-134173 (Custom Metric listing Info View). Tooltip updates without flicker as the pointer moves between fields.
- Information-button state machine: OFF = outlined / dark icon; ON = filled blue background with white icon + text label.
- This Create-side Info View is the **write-side sibling** of QA-134173 (read-side Info View on the Custom Metric list). Toggle, anchor, and content-mapping model are identical.

## Evidence
- URL remained `#custom-metrics/create` throughout (Info mode is client-side only).
- Tooltip headers/descriptions captured verbatim during execution (see "Hovered each Create-form element" in Execution).
