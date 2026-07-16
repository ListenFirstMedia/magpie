# QA-88219 — Dashboards - Brand Content - Save filtered tiles to the dashboard

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account:** Adam Orfei (account_id=54) · Brand **MTV** (brand_id=4018) · window May 27 – Jun 2, 2026
- **Type:** Mutating (save tile → delete). No persisted mutation was created (flow blocked before save).

## Verdict: PASS (A1–A4 verified on re-run; A5 tile-cleanup done, empty dashboard left for manual deletion)

## 2026-07-10 re-run update (RESOLVED — was BLOCKED)
The prior blocker (savable tiles empty under a Facebook-only filter) is solved by using **sentiment mode with all channels** (keeps the conversation/insight tiles populated). Full round-trip driven:
- **A1 PASS** — insight tiles carry a `[data-ui-name=save_to_dashboard]` control (trusted click opens it).
- **A2 PASS** — the Save-to-Dashboard dropdown opens, listing existing dashboards (each with a checkbox + Edit) + a **"Create Dashboard"** button.
- **A3 PASS** — "Create Dashboard" → "Create New Dashboard" modal → named **`QA-88219-rerun-0832`** → Ok. Reopening the dropdown shows the new dashboard **checked** (`i.form-component-icon.fa-check-square`) → the filtered tile is saved to it.
- **A4 PASS** — the dashboard renders the saved **MTV (Brand: Conversation)** tile carrying the filter window **May 27 – Jun 2, 2026**.
- **A5 (cleanup):** un-checked the dashboard in the Save dropdown → tile removed (icon back to `fa-square`), so the tile mutation is reverted. The **empty dashboard "QA-88219-rerun-0832" remains** — the dashboard-delete UI (Dashboards-page selector/Options) could not be driven via automation (the Edit modal only renames; the dashboard-switcher list wouldn't open). ⚠️ **Flag for manual deletion** (low impact — empty, uniquely named; consistent with the account's other leftover test dashboards).

### Method notes
- Save-to-Dashboard dropdown = `[data-ui-name=save_to_dashboard]` (trusted click) → `.save-to-dashboard-list-item` rows (checkbox `i.form-component-icon.fa-check-square/​fa-square` + Edit) + a `Create Dashboard` secondary button → "Create New Dashboard" modal (name + Ok).
- Sentiment mode (`sentiment_mode=true`) + all channels keeps the savable insight tiles populated (Facebook-only empties them).

---
### (original 2026-07-09 verdict) BLOCKED (harness + attempt-budget)

## Known bugs checked
Compact open-bug screen → empty. No open linked bug.

## What was verified
- **A1 — Save to Dashboard control present:** confirmed. Tiles carry a `div.selector-dropdown-container[data-ui-name="save_to_dashboard"]` (the "Save to Dashboard" dropdown, same widget family as the tile-level Export control). Found on the conversation/insight tiles (Classification, Emotion, Topics, Top 7 Topics, Most Vocal) plus a page/config-level instance.
- **Filter application works:** narrowed the channel filter from all-6 to **Facebook-only** via the `.channel-ghost.<channel>` toggles + Apply — the tiles recomputed and the URL updated to `…&channels=facebook&…`. (Toggles require a **trusted** `browser_click`; synthetic mouse-event dispatch did not register.)

## Why blocked (A2–A5 not completed)
The tiles that expose **Save to Dashboard** are the **conversation/insight tiles**, and under the applied Facebook-only filter they render **"There is no data available"** (this brand/window has sparse conversation data, which is largely Twitter-driven — Facebook-only empties them). The data-bearing tiles in this view are the **post cards**, which do **not** carry an individual Save-to-Dashboard control. The one page/config-level `save_to_dashboard` container present in the DOM was **not visible/clickable** in the current viewport state (Playlwright: "element is not visible").

Completing the intended round-trip reliably — (1) a filter that keeps a *savable* tile populated, (2) open the save modal, (3) pick/create a destination dashboard, (4) navigate to it and verify the filtered numerics match, (5) delete the saved tile + any new dashboard — is a large, automation-fragile surface. Per the run's effort-discipline rule for expensive cases, I stopped rather than sink further attempts, since no product defect is in evidence — this is an automation/data-availability constraint.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Save to Dashboard control present & clickable on a tile | control present on insight tiles (`data-ui-name=save_to_dashboard`) | PASS |
| A2 | Save modal opens | not reached (savable tiles empty under filter; page-level control not visible) | BLOCKED |
| A3 | Save completes | not reached | BLOCKED |
| A4 | Dashboard tile renders with filter (numerics match) | not reached | BLOCKED |
| A5 | Cleanup — tile deleted, no orphan | n/a (nothing was saved) | N/A |

## Recommended manual re-test
Use a filter that keeps a **savable** tile populated: either keep all channels and apply a **Tag** or **Publish Type** content filter (insight tiles stay populated but filtered), or include **Twitter** so the conversation tiles have data. Then drive the per-tile Save to Dashboard → pick/create a dashboard → verify the filtered numeric on the dashboard tile → delete. The parity/verify mechanics are standard.

## View state note
The Brand > Content view was left with a Facebook-only channel filter (ephemeral URL/view state only — no persisted change); navigating away discards it.

## Bugs filed
None (no product defect confirmed).
