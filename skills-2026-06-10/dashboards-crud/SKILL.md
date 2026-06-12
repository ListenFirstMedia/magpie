---
name: dashboards-crud
version: 1
last_verified: 2026-06-10
trust: untrusted
pass_streak: 3
preconditions: [user-logged-in, account-set]
postconditions: [dashboard-created-or-deleted]
related_pages: ["/#dashboards", "/#dashboards/{id}"]
---

# Dashboards: create, save tiles, short link, order, share modal, delete

## Create
- Dashboards → `Create Dashboard` → name → Ok. New URL `/#dashboards/<id>?...&create=success`.
- From a tile: `Save to Dashboard` dropdown → existing list (checkbox + Edit per row) → `Create Dashboard` button at bottom. Toast: `You've successfully added this tile to: <name>`; label becomes `Save to Dashboard (n)`; entry shows checked in dropdown.

## Dashboard Menu
- `Dashboard Menu` button (top-left) → modal `Dashboards (N)` with search + rows (Delete | Edit per row). Click name to open.

## Saved tile anatomy (on dashboard)
- Header link `<Brand> (<Category>: <Tab>)`, perspective label top-right, identical data to source page, links **below** tile: `Insights | Content | Remove from Dashboard` (test cases saying "right side" are stale).

## Short link (QA-16775)
- Pin/link icon (bottom-right circular button, real coordinate click) → input `https://app.lfmdev.in/#s/<slug>` + copy icon. Short link resolves to the full dashboard URL WITHOUT `create=success`.

## Order modal (QA-84202)
- Options → Edit → `Edit Dashboard` modal: name field + table headers **Order | Tile**, number spinner per row.
- Rows are drag-reorderable: `left_click_drag` row → may show a transitional ghost; click empty modal space to settle, then verify. Ok persists; Cancel discards.

## Share modal (read-only part)
- Options menu = exactly Edit / Share / Delete. Share modal: `People:` email input + Add, owner row, `Copy Link | Bulk Share this Dashboard`, Cancel, Share (disabled until a recipient added). (Agent policy: do not add recipients/share — hand off.)

## Delete (QA-115037)
- Options → Delete → modal: `Are you absolutely sure you want to delete your "<name>" dashboard? Click "Ok" to continue.` → Ok deletes and redirects to default dashboard; source-page tile count clears.

## Tile naming caveat
- Insights tile names vary by account config: Adam Orfei has "Fan Growth Rate"; Michael Kors account has BOTH "Follower Growth" and "Fan Growth Rate". Resolve tiles by regex, not exact name.
