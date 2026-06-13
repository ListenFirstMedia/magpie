---
name: brand-content-tag-modal-drag
version: 1
last_verified: 2026-06-08
last_passed_run: 2026-06-08
trust: untrusted
pass_streak: 1
preconditions: [account-context, brand-content-page-loaded, user-okayed-mutation]
postconditions: [tag-modal-dragged-then-cleaned]
inputs: [brand_id, unique_timestamped_tag_value]
outputs: [drag_pre_post_rect, scroll_fixed_verified, tag_cleanup_completed]
related_pages: ["/#explore/brand/content"]
related_skills: [brand-content-tag-post]
---

# Brand > Content — Bulk Tag Modal — Dragging Behavior (MUTATING)

End-to-end skill for verifying the Bulk Add Tags modal drag/scroll/cursor behavior. The modal is a draggable, position-fixed overlay that defaults to top-right above the Zendesk Help fab.

⚠ **MUTATING SKILL** — full flow adds a unique timestamped tag to N posts and runs the Delete-All-Tags cleanup. Requires explicit user mutation-OK per project policy.

Used by:
- **QA-112579** (Brand Content - Tag modal dragging) — PASS 6/6 on Michael Kors (brand_id=12597), 28 posts mutation+cleanup.

## Key UI structure

### Bulk Add Tags modal
- Container: `div.bulk-tag-corner-container > div.tagging-container#tag-modal`.
- Header: `div.tagging-header.tagging-header-redesign` containing the title `Bulk Add Tags` + drag affordance.
- Header CSS: `cursor: grab` (the spec wording "hand icon" maps to CSS `grab` — semantically equivalent).
- Default position: top-right of the Brand>Content body, just above the Zendesk Help fab (bottom-right launcher iframe near y=720).
  - Typical rect at default zoom: top-left (1162, 289), size 420×423 px → bottom y=712.
- Modal is `position: fixed` — rect stays constant when the underlying page is scrolled.

### Help fab reference point
- The Zendesk Help launcher iframe sits near coordinates (1486, 720). The modal default-position bottom edge (~712) sits just above it.

## Steps

### Step 1 — Navigate + open the modal
- **Action:** Navigate to Brand > Content for the target brand. Click `Tag` dropdown → `Bulk Tag` option.
- **Selectors:**
  - Tag dropdown trigger: `button.tag-dropdown.with-dropdown[data-ui-name="tags"]`.
  - Dropdown options: `Bulk Tag`, `Upload Tags`, `Manage Tags`.
- **Assertion:** `div.bulk-tag-corner-container` rendered. Modal title "Bulk Add Tags" visible at top.

### Step 2 — Verify default position above Help fab
- **Probe:**
  ```javascript
  const modal = document.querySelector('.tagging-container#tag-modal');
  const r = modal.getBoundingClientRect();
  // r.bottom should be < Help fab top (typically y ≈ 720 minus a few px)
  ```
- **Assertion:** modal bottom edge sits just above the Help fab launcher (e.g., rect bottom 712, fab top ~720).

### Step 3 — Verify cursor=grab on header
- **Probe:**
  ```javascript
  getComputedStyle(document.querySelector('.tagging-header')).cursor === 'grab'
  ```
- **Assertion:** Equals `'grab'`.

### Step 4 — Drag the modal
- **Action:** `computer.left_click_drag` from a coordinate inside the header (e.g., (1370, 320)) to a target coordinate (e.g., (700, 400)).
- **Probe before/after:**
  ```javascript
  const before = modal.getBoundingClientRect();
  // ... drag ...
  const after = modal.getBoundingClientRect();
  // before.x ≈ 1162, after.x ≈ 459 (moved ~700 px horizontally)
  ```
- **Assertion:** modal's bounding rect shifts by approximately the drag delta (verify left/top differ by > ~50 px).

### Step 5 — Verify scroll-fixed position
- **Action:** scroll the underlying page (e.g., `scroll` ticks=5).
- **Probe:** modal's `getBoundingClientRect()` AND `document.documentElement.scrollTop`.
- **Assertion:** modal rect stays at the post-drag location (459.99, 373.01 in QA-112579) even with `scrollY=500`. Scroll back; modal rect still identical.

### Step 6 — Add a unique timestamped tag
- Generate: `tag = "qa-112579-<timestamp>"` (always include the ticket key + timestamp; never reuse a tag name).
- Type into the modal's "Please enter up to 100 characters" input → click Add.
- **Assertion:** chip with `<tag-value> ×` rendered in the modal body.

### Step 7 — Select all posts + Done
- Click `Select All Posts` (selects all N visible posts).
- **Assertion:** counter increments to `N/N` (e.g., 28/28).
- Click `Done` → modal closes; `.bulk-tag-corner-container` not present in DOM.

### Step 8 — Re-open + verify persisted-tag visible at default position
- Re-open Tag → Bulk Tag.
- **Assertion:** modal opens at the ORIGINAL default position (1162, 289) — drag state does NOT persist across modal close-reopen. Persisted tag chip visible.

### Step 9 — CLEANUP (CRITICAL)
- **Action:** with the modal open and Select All Posts active:
  - Click `Delete All Tags` link → confirmation dialog "Delete N tag(s) from N post(s)" → click `Delete All`.
- **Assertion:** modal body emptied of chips; tag removed from all N posts. F5-refresh → posts table re-renders without tag count.

## Unique-timestamp-tag cleanup discipline

- Always generate `tag = "QA-<ticket>-<timestamp>"` (e.g., `qa-112579-rerun-2026-06-04`). Never reuse a tag name from a prior run.
- Always run Step 9 cleanup at the end. Mutating tests should leave NO trace.
- If the test fails midway, the cleanup step should still run (try/finally pattern).
- The platform auto-lowercases tag values (`MyTag` → `mytag`) and deduplicates within a post.

## Failure signatures

| Signature | Interpretation | Action |
|---|---|---|
| `getComputedStyle(.tagging-header).cursor` ≠ `'grab'` | UI regression on drag affordance | File bug |
| Drag does not move modal | `left_click_drag` start coordinate missed the header | Re-check coordinates; header is the only draggable region |
| Modal rect changes when page scrolled | `position: fixed` regression | File bug |
| Modal re-opens at the dragged position (not default) | Drag-state persistence regression (spec says it should reset) | File bug |
| Cleanup-delete leaves chips in DOM | Delete-All endpoint failed | Manual cleanup via per-chip × click; log skill failure |

## Network expectations

| Endpoint | Method | Expected status | Notes |
|---|---|---|---|
| `/api/.../content_tags` (bulk add) | POST | 200/201 | Bulk-tag-add for N posts |
| `/api/.../content_tags` (bulk delete) | DELETE | 200/204 | Delete-All-Tags cleanup |

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows.

## Changelog

- **v1** (2026-06-08): Initial draft from QA-112579 PASS 6/6 on Michael Kors 28 posts. Documents the `cursor: grab` header, the `position: fixed` scroll-invariance, the default position above the Zendesk Help fab, the drag-state does-NOT-persist-across-reopen behavior, and the unique-timestamp-tag cleanup discipline.
