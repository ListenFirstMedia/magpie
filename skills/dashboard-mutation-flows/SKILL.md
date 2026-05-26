---
name: dashboard-mutation-flows
version: 1
last_verified: 2026-05-18
last_passed_run: null
trust: untrusted
pass_streak: 0
preconditions: [user-okayed-mutation, dashboard-page-loaded]
postconditions: [dashboard-created-or-modified]
inputs: [dashboard_name, tiles]
outputs: [dashboard_id]
related_pages: ["/#dashboards"]
---

# Dashboard Mutation Flows (Create / Drag-Drop / Delete)

⚠ **MUTATING SKILL** — every step in this skill alters real database state. Requires explicit user confirmation per the project's no-auto-mutation rule.

Used by (when user grants OK):
- **QA-84202** — Dashboards Order Model Basic View (create + drag-drop + delete)
- **QA-85175** — Dashboards Drag and Drop Tile Ordering (same)
- **QA-115037** — Dashboards related mutation flows
- **QA-16775** — Drylogics dashboard tests
- **QA-116177** — Brand Content Sentiment Tagging (related — adds a tag to a real post)

## Mandatory pre-flight
Before invoking any step, confirm:
```
User has explicitly typed "OK to mutate dashboard <name>" 
   or equivalent affirmative consent in chat.
```
If not, **STOP** and request consent. Report the case as ⛔ Skipped — Mutation policy.

## Steps

### Step 1 — Create a new dashboard
- **Action:** Navigate to `/#dashboards` → click `Create Dashboard` button.
- **Action:** Enter the dashboard name (test-prefixed, e.g. `QA-84202-TEST-<timestamp>`).
- **Action:** Click `Save` or `Create`.
- **Assertion:** Dashboard appears in the dashboard list with the typed name.
- **Capture:** dashboard_id from URL `/#dashboards/<id>`.

### Step 2 — Add a tile
- **Action:** Click `Add Tile` (top-right of dashboard view).
- **Action:** In the modal, pick a brand + a metric.
- **Action:** Click `Save Tile`.
- **Assertion:** tile appears in the grid.

### Step 3 — Drag-drop reorder
- **Action:** Mouse-down on the tile drag-handle (typically top-left corner of tile or via "Edit" mode).
- **Action:** Move to target position.
- **Action:** Mouse-up.
- **Assertion:** tile order persists; reload page → order is same.

**Drag-drop JS workaround** (when MCP coordinate-drag is flaky):
```javascript
// HTML5 drag events
const src = document.querySelector('.tile[data-id="<id>"]');
const dst = document.querySelector('.tile-drop-zone[data-position="2"]');
const dataTransfer = new DataTransfer();
src.dispatchEvent(new DragEvent('dragstart', {bubbles: true, dataTransfer}));
dst.dispatchEvent(new DragEvent('dragover', {bubbles: true, dataTransfer}));
dst.dispatchEvent(new DragEvent('drop', {bubbles: true, dataTransfer}));
src.dispatchEvent(new DragEvent('dragend', {bubbles: true, dataTransfer}));
```

### Step 4 — Delete the dashboard (cleanup)
- **Action:** From the dashboard list, hover over the dashboard row → click `⋮` menu → `Delete`.
- **Action:** Confirm in the `Are you sure?` modal.
- **Assertion:** dashboard no longer appears in the list.

## Cleanup discipline
- **Always delete the test dashboard at the end of the test run.** Mutating tests should leave NO trace.
- If the test fails midway, the cleanup step should still run (try/finally pattern).
- Test dashboards must be named with a `QA-XXXXX-TEST-` prefix so they're easy to find and bulk-delete if cleanup ever fails.

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| Create button disabled after entering name | Name conflict (test dashboard from prior run still present) | Run cleanup pass first; then retry |
| Drag-drop appears to work but order reverts on reload | Backend save not persisting drag-drop events | File as bug |
| Delete confirmation modal doesn't appear | Possibly using a different mutation guard pattern | Check console for errors |
| Test dashboard remains after cleanup step | Cleanup failure | Manually delete via UI; log skill failure |

## Brand Content Sentiment Tagging (QA-116177) variant

Different mutation, similar protocol:
1. **Tag a post:** Brand → Content → click post → Sentiment button → Tag dropdown → type new tag name → Save.
2. **Cleanup:** click the tag chip on the post → "Remove tag" → confirm.
3. Email step (Step 7 of QA-116177) requires Gmail integration, currently NOT available.

## Changelog
- **v1** (2026-05-18): Initial scaffold from skipped batch 6 cases (QA-84202, QA-85175, QA-115037, QA-16775, QA-116177). Not yet executed — awaits user mutation-OK.
