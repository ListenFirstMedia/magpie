# QA-134185 — Settings > Custom Metric Creation - Info View

- **Run date:** 2026-07-04
- **Verdict:** **PASS** (with the spec's `Metric Definition Link` element N/A — documented spec/UI drift, not a bug)
- **Environment:** Playwright MCP (headless), `app.lfmdev.in`, logged in as `lfiqa@listenfirstmedia.com`
- **Account:** Adam Orfei (switched from default Hulu — Custom Metrics is account-gated; Hulu is non-entitled → blank page)
- **Skill used:** `settings-custom-metrics` (v3), Step 4 (Info View on Create page)
- **Open linked bugs:** None open (screened) — ran normally.

## Preconditions

- Pre-flight login via Cognito "With existing account" form succeeded → `#home` ("Home - ListenFirst") rendered.
- Navigated `#custom-metrics` under default account **Hulu (336)** → **content area blank** (feature account-gated; confirms skill v3 note).
- Switched account to **Adam Orfei** via LFQA menu (hover) → Search Account (React setter) → clicked the `.lfm-ta-option` "Adam Orfei" Result.
- Re-navigated `#custom-metrics` → full Custom Metrics list rendered (columns: Metric, Description, Created Date, Creator, Formula, Actions; `Create a Custom Metric` button present).

## Steps executed

| # | Step | Result |
|---|------|--------|
| 1 | Top Nav → Settings | On Settings > Custom Metrics |
| 2 | Custom Metrics | List page rendered (Adam Orfei) |
| 3 | Click Create Custom Metric | `#custom-metrics/create` — "Create Custom Metric" heading, Name/Description/Formula fields, Save disabled |
| 4 | Hover Name field WITHOUT Info mode | No persistent tooltip; Info button not `active` |
| 5 | Click Info button | Info button → `info-view-toggle active` |
| 6 | Observe tooltip without hovering | Generic panel `info-view-modal-inner`: "Create Custom Metrics / This screen allows you to create your custom metrics" |
| 7 | Inspect Create page elements | Name, Description, Formula inputs present; no `Metric Definition Link` element in DOM |
| 8 | Hover Name field | Tooltip → "Name / Enter a name for your custom metric" |
| 9 | Inspect Name element | `textbox "Name:"` (placeholder "Enter a metric name") |
| 10 | Hover Description field | Tooltip → "Description / Enter a description for your custom metric" |
| 11 | Inspect Description element | `textbox "Description:"` (placeholder "Enter a description") |
| 12 | Hover Formula field | Tooltip → "Formula / Enter a formula for your custom metric" |
| 13 | Inspect Formula element | `textbox "Configure your metric formula"` |
| 14 | Click Info button (dismiss) | Info button → `info-view-toggle` (no `active`); panel removed |
| 15 | Hover Name/Description/Formula (+ Metric Definition Link) | No persistent tooltip on any field; Metric Definition Link element absent (N/A) |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5–6 | Info mode initially shows generic tooltip | "Create Custom Metrics / This screen allows you to create your custom metrics" | PASS |
| A2a | 8 | Hovering Name in Info mode updates tooltip header+description | "Name / Enter a name for your custom metric" | PASS |
| A2b | 10 | Hovering Description updates tooltip | "Description / Enter a description for your custom metric" | PASS |
| A2c | 12 | Hovering Formula updates tooltip | "Formula / Enter a formula for your custom metric" | PASS |
| A2d | 12/15 | Hovering Metric Definition Link updates tooltip | Element does not exist in current build | N/A (spec/UI drift) |
| A3 | 4, 15 | Without Info mode, no persistent tooltip | No `info-view-modal-inner` panel on Name/Description/Formula hover with Info off | PASS |
| A4 | 5, 14 | Info button toggles Info mode on/off | Button toggled `info-view-toggle` ↔ `...active`; panel appears/disappears accordingly | PASS |

## Evidence

- Tooltip container selector: `.info-view-modal-inner` (present only while Info mode `active`).
- Info button class: OFF = `lfm-button sub-header-button info-view-toggle`; ON = `... info-view-toggle active`.
- `Metric Definition Link` search: `document.body.innerText` match = false; zero `definition` links in DOM.
- Screenshots (under `.playwright-out/QA-134185/`):
  - `04-name-hover-info-off.png` — Name hover, Info OFF (no tooltip)
  - `06-info-on-generic-tooltip.png` — generic tooltip, Info ON
  - `08-name-hover-info-on.png` — Name tooltip
  - `10-description-hover-info-on.png` — Description tooltip
  - `12-formula-hover-info-on.png` — Formula tooltip
  - `15-info-off-no-tooltip.png` — Info toggled OFF, no tooltip

## Bugs filed

None. All in-scope assertions passed. The spec's `Metric Definition Link` element is absent from the current build — this is pre-documented spec/UI copy drift (see `settings-custom-metrics` skill Step 4 and known-quirks), **not** a product defect, so no bug is filed.
