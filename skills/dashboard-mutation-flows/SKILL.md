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

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows; 0 historical defects (all closed) are catalogued there.

## Changelog
- **v1** (2026-05-18): Initial scaffold from skipped batch 6 cases (QA-84202, QA-85175, QA-115037, QA-16775, QA-116177). Not yet executed — awaits user mutation-OK.

## 2026-06-11 batch-3 updates (QA-85175, Adam Orfei, dashboard "Order3 0611" id=6295)

- **BUG (Major, open): tile "Remove from Dashboard" never persists.** Click removes the tile from the page instantly but fires ZERO API calls (only Mixpanel/NewRelic beacons in the network log). After reload the tile is back; the Edit (Order) popup keeps listing it the whole time. 2/2 repro. Treat any "popup reflects removal" assertion as expected-FAIL until fixed.
- **Save to Dashboard dropdown:** toggler needs full `mousedown/mouseup/click` MouseEvent dispatch (bare `.click()` and plain coordinate clicks are flaky). Dropdown rows live in `.selector-dropdown` (30 empty instances exist in DOM; only the open one has rows). Click the dashboard-name row element via `.click()` after opening; success toast = `You've successfully added this tile to: <name>`.
- **Dashboard Menu (left button) → pick dashboard:** coordinate clicks unreliable; use `find` → ref click to open, then full-event dispatch on the name row. Top-nav "Dashboards" CLICK navigates to the default dashboard — the dashboard list opens via the page-level Dashboard Menu button, not the nav item.
- **Order modal drag (no HTML5 draggable):** synthetic `mousedown` on the row label + 8 stepped `mousemove`s (±70–120 px) + `mouseup` reorders reliably; rank numbers renumber automatically; OK persists (verified after reload).
- **Delete:** Options → Delete → confirm text `Are you absolutely sure you want to delete your "<name>" dashboard? Click "Ok" to continue.` → redirects to default dashboard; menu entry gone.
- Dashboard ids are NOT strictly sequential (created 6295 while 6260-6264 existed; 6264 = another user's, shows "You can only share dashboards that you've created").

## Changelog (cont.)
- **v2** (2026-06-11): Remove-from-Dashboard persistence bug, full-event-dispatch requirement, selector-dropdown row mechanics, drag recipe, delete confirm text.
