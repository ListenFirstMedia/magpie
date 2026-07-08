# QA-134173 — Settings > Custom Metric - Info View — Report

- **Run date:** 2026-07-04
- **Environment:** Playwright MCP (headless, real Chrome), `app.lfmdev.in`
- **Auth:** programmatic Cognito email/password (`lfiqa@listenfirstmedia.com`) — pre-flight PASS (`#home`, title "Home - ListenFirst")
- **Account:** Adam Orfei (Custom Metrics is account-gated; feature rendered — see known-quirks)
- **Skill used:** `settings-custom-metrics` v3 (Step 2 — Info View on list page)
- **Verdict:** **PASS** — all in-scope assertions pass. No Google Sheets / external-user steps in this case.

## Steps executed

| # | Step | Result |
|---|------|--------|
| 1 | Top Nav → Settings | Reached (via `#custom-metrics` route) |
| 2 | Click Custom Metrics | List page rendered; columns Metric \| Description \| Created Date \| Creator \| Formula \| Actions; Create button + Info button present |
| 3 | Hover Metric column WITHOUT Info mode | No tooltip appeared (only Info button/label in DOM) |
| 4 | Click Info button | Button switched to `info-view-toggle active` (filled state); persistent tooltip appeared lower-left (`.info-view-modal-inner`, x=62,y=576) |
| 5 | Observe tooltip with no element hovered | Default page tooltip: **"Custom Metrics" / "This table displays all custom metrics created on the account"** |
| 6 | Inspect Custom Metrics page | Table + persistent tooltip confirmed |
| 7–8 | Hover + inspect Metric column | Tooltip → "Metric" / "The name of your custom metric" |
| 9–10 | Hover + inspect Description column | Tooltip → "Description" / "The description of your custom metric" |
| 11–12 | Hover + inspect Created Date column | Tooltip → "Date Created" / "The date when your custom metric was created" |
| 13–14 | Hover + inspect Creator column | Tooltip → "Creator" / "The user who created your custom metric" |
| 15–16 | Hover + inspect Formula column | Tooltip → "Formula" / "The formula that makes up your custom metric" |
| 17 | Click Info button (to dismiss) | Button reverted to neutral (`info-view-toggle`, no `active`); tooltip modal removed from DOM |
| 18 | Hover each column (Info off) | No tooltip appears |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | No Info tooltip appears before Info mode is enabled | Hovering Metric with Info OFF produced no tooltip; only `.info-view-toggle` button/label present | PASS |
| A2 | 4 | Info button enables Info mode (active/filled state) | `class` became `lfm-button sub-header-button info-view-toggle active`; tooltip panel rendered | PASS |
| A3 | 5 | Tooltip persists with no element hovered, showing page-level info | "Custom Metrics" / "This table displays all custom metrics created on the account" | PASS |
| A4 | 7–8 | Metric column tooltip header + description | "Metric" / "The name of your custom metric" | PASS |
| A5 | 9–10 | Description column tooltip | "Description" / "The description of your custom metric" | PASS |
| A6 | 11–12 | Created Date column tooltip | "Date Created" / "The date when your custom metric was created" | PASS (header copy = "Date Created", documented drift) |
| A7 | 13–14 | Creator column tooltip | "Creator" / "The user who created your custom metric" | PASS |
| A8 | 15–16 | Formula column tooltip | "Formula" / "The formula that makes up your custom metric" | PASS |
| A9 | (all) | Tooltip dynamically updates as different columns are hovered | Header + description changed correctly on every hover | PASS |
| A10 | 17–18 | Disabling Info mode dismisses the tooltip; no tooltip on hover | Button neutral; `.info-view-modal-inner`/`-outer` removed from DOM; hover produced nothing | PASS |

## Evidence

- Tooltip DOM: `div.info-view-modal-inner` → `h3.header` (title) + `div.element-description` (body), lower-left panel.
- Info toggle element: `button.lfm-button.sub-header-button.info-view-toggle`; active state adds `active` class.
- Exact tooltip strings captured verbatim via `browser_evaluate` after each hover (see step table).
- Screenshots (`.playwright-out/QA-134173/`):
  - `01-list-page-baseline.png` — list page, Info OFF
  - `02-info-on-default-tooltip.png` — Info ON, default "Custom Metrics" tooltip
  - `03-formula-hover-tooltip.png` — Formula column hover tooltip
  - `04-info-off-no-tooltip.png` — Info dismissed, no tooltip

## Notes

- **Copy drift (not a bug):** The column header reads "**Created Date**" but its Info tooltip header reads "**Date Created**". This is the pre-documented spec/UI copy swap (see `settings-custom-metrics` skill Step 2 + known-quirks). Description text matches spec, so A6 PASS.
- **Account gating:** Custom Metrics rendered because the session resolved to Adam Orfei. On a non-entitled account (e.g. Hulu) the page is blank — noted for future runs; not applicable here.
- Steps executed entirely via UI interaction (clicks + hovers); tooltip content read from the live DOM, not URL/proxy signals.

## Bugs filed

None. All assertions passed; the one copy variance ("Created Date" header ↔ "Date Created" tooltip) is a previously-documented known drift, not a new defect.
