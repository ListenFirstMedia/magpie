---
name: dashboard-mutation-flows
version: 2
last_verified: 2026-06-08
last_passed_run: 2026-06-08
trust: untrusted
pass_streak: 4
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

## v2 — Save filtered tile to Dashboard + filter chip preservation (2026-06-08)

⚠ **MUTATING — cleanup non-optional.** Test dashboards must be created with `QA-XXXXX-rerun-<date>` naming so they're easy to bulk-find for emergency cleanup. Every test ends with a Delete-dashboard step.

### Save filtered tile to Dashboard end-to-end (QA-88219, QA-89390)

#### Flow

1. Brand > Content for the target brand. Apply a Filter (e.g., `Publish Type = Reel` via `brand-content-filter`).
2. Switch the Insights dropdown to `Content Insights` — Content Performance tile renders with the **filter-respecting** Sum/Avg numerics (e.g., 228,847 Engagements for MTV Reel only).
3. Per-tile `Save to Dashboard` dropdown — surfaces existing-dashboard checkboxes + `Create Dashboard` button.
4. Click `Create Dashboard` → "Create New Dashboard" modal opens with Name input + Ok/Cancel.
5. Fill Name (use timestamped pattern `QA-<ticket>-rerun-<date>-<batch>`) via React-aware InputEvent setter:
   ```javascript
   const inp = document.querySelector('input[placeholder*="dashboard" i]');
   const setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
   setter.call(inp, '<dashboard_name>');
   inp.dispatchEvent(new Event('input', {bubbles: true}));
   ```
6. Click Ok → modal closes; counter increments to `Save to Dashboard (1)` confirming save.
7. Navigate to Dashboards. Dashboards menu shows `Dashboards (N+1)` with the new dashboard listed.
8. Open the new dashboard (URL `#dashboards/<id>`). **Verify tile renders with:**
   - Brand link header (e.g., `MTV (Brand: Content)`).
   - Perspective label preserved (e.g., `Public Data`).
   - Filter chip preserved verbatim (e.g., `Publish Type: Reel`) with `Filter(N)` count.
   - Tile numeric matches source (Sum Engagements 228,847 → ~228K bar in `Performance by Type` tile).

#### Cleanup (CRITICAL)

9. Dashboards menu → Delete on the saved dashboard row.
10. Confirmation modal → click Ok.
11. **Verify** Dashboards menu count drops from `(N+1)` back to `(N)`. No orphan in the list.

### Brand Content Insights filtered tiles (QA-89390)

Sister-test of QA-88219 — the **Save filtered tile** mechanic is identical regardless of which Insights variant (Content Insights, Sentiment Insights, etc.) drives the tile. Verified on 2026-06-08 RECONFIRM as no environment regression since QA-88219 PASS 4 days earlier.

### Why the React-aware InputEvent setter

The Dashboard Name input is React-controlled — `computer.type` directly into the input does NOT commit the value to React state. JS `.value = '...'` alone also doesn't work because React's setState ignores value assignments without an input event.

The dance:
```javascript
const setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
setter.call(inp, value);                          // bypasses React's setter intercept
inp.dispatchEvent(new Event('input', {bubbles:true}));  // triggers React onChange handler
```

This is the same pattern documented for TWC brand picker, Brand>Content Tag input, and Custom Metrics Name input.

### JS click required for several controls

Coordinate-based `computer.left_click` is inconsistent for:
- `Save to Dashboard` dropdown chevron.
- `Create Dashboard` button.
- Ok button in the "Create New Dashboard" modal.

Use JS-fallback `find` + ref-based click for each:
```javascript
[...document.querySelectorAll('button')].find(b => /Create Dashboard/.test(b.textContent))?.click();
```

## Additional Failure signatures (v2)

| Signature | Interpretation | Action |
|---|---|---|
| `Save to Dashboard` counter doesn't increment after Ok | Save API failed; possible 5xx | Check console; retry |
| Saved tile renders without filter chip on Dashboard | Filter not propagated to dashboard tile config | File bug — verify by saving an unfiltered tile to compare |
| Saved tile numeric ≠ source Brand>Content Sum | Filter context lost OR perspective mismatched | Cross-check perspective + filter chip; file bug if mismatch |
| Dashboards count doesn't drop after Delete + Ok | Delete API failed; orphan in list | Manual cleanup via UI |

## Changelog
- **v2** (2026-06-08): Promoted from scaffold to PASS. Save filtered tile to Dashboard end-to-end + cleanup (QA-88219, QA-89390). MUTATING — cleanup non-optional. Documents the React-aware InputEvent setter for Dashboard Name + the JS-fallback `find`-by-text-match pattern for inconsistent coordinate clicks. +4 streak across QA-88219, QA-110083 (brand-set wizard extension), QA-89390 RECONFIRM, QA-104876 (Settings entity cleanup pattern carry).
- **v1** (2026-05-18): Initial scaffold from skipped batch 6 cases (QA-84202, QA-85175, QA-115037, QA-16775, QA-116177). Not yet executed — awaits user mutation-OK.

## 2026-06-11 batch-3 updates (QA-85175, Adam Orfei, dashboard "Order3 0611" id=6295)

- **BUG (Major, open): tile "Remove from Dashboard" never persists.** Click removes the tile from the page instantly but fires ZERO API calls (only Mixpanel/NewRelic beacons in the network log). After reload the tile is back; the Edit (Order) popup keeps listing it the whole time. 2/2 repro. Treat any "popup reflects removal" assertion as expected-FAIL until fixed.
- **Save to Dashboard dropdown:** toggler needs full `mousedown/mouseup/click` MouseEvent dispatch (bare `.click()` and plain coordinate clicks are flaky). Dropdown rows live in `.selector-dropdown` (30 empty instances exist in DOM; only the open one has rows). Click the dashboard-name row element via `.click()` after opening; success toast = `You've successfully added this tile to: <name>`.
- **Dashboard Menu (left button) → pick dashboard:** coordinate clicks unreliable; use `find` → ref click to open, then full-event dispatch on the name row. Top-nav "Dashboards" CLICK navigates to the default dashboard — the dashboard list opens via the page-level Dashboard Menu button, not the nav item.
- **Order modal drag (no HTML5 draggable):** synthetic `mousedown` on the row label + 8 stepped `mousemove`s (±70–120 px) + `mouseup` reorders reliably; rank numbers renumber automatically; OK persists (verified after reload).
- **Delete:** Options → Delete → confirm text `Are you absolutely sure you want to delete your "<name>" dashboard? Click "Ok" to continue.` → redirects to default dashboard; menu entry gone.
- Dashboard ids are NOT strictly sequential (created 6295 while 6260-6264 existed; 6264 = another user's, shows "You can only share dashboards that you've created").

## Read-only / navigation details (merged from `dashboards-crud` 2026-06-10 snapshot)

Non-mutating dashboard surfaces consolidated here so all dashboard knowledge lives in one skill:

- **Short link (QA-16775):** the pin/link icon (bottom-right circular button, real coordinate click) opens an input `https://app.lfmdev.in/#s/<slug>` + a copy icon. The short link resolves to the full dashboard URL **without** the `create=success` param.
- **Saved-tile anatomy:** header link `<Brand> (<Category>: <Tab>)`, perspective label top-right, data identical to the source page. Action links sit **below** the tile: `Insights | Content | Remove from Dashboard` (test cases that say "right side" are stale).
- **Share modal (inspect only — do NOT add recipients):** Options menu = exactly Edit / Share / Delete. Share modal: `People:` email input + Add, owner row, `Copy Link | Bulk Share this Dashboard`, Cancel, and Share (disabled until a recipient is added). Agent policy: inspect only, hand off any actual share.
- **Tile-naming caveat:** Insights tile names vary by account config — Adam Orfei has "Fan Growth Rate"; the Michael Kors account has BOTH "Follower Growth" and "Fan Growth Rate". Resolve tiles by regex, not exact name.

## Changelog (cont.)
- **v2** (2026-06-11): Remove-from-Dashboard persistence bug, full-event-dispatch requirement, selector-dropdown row mechanics, drag recipe, delete confirm text.
- **v2.1** (2026-06-27): Merged unique read-only/nav coverage from the retired `dashboards-crud` snapshot (short link, saved-tile anatomy, share modal read-only, tile-naming regex caveat).
