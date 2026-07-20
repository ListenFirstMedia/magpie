# QA-112579 — Brand Content - Tag modal dragging function — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand:** MTV (4018) · **Channel:** Instagram · **Window:** Jun 1–15 2026
- **Skills:** brand-content-tag-post
- **Result:** ✅ PASS

## Steps
1. Brand > Content for MTV → **Tag ▾** → **Bulk Tag** → **Bulk Add Tags** modal opened (right side; header "Bulk Add Tags", Filter Tags, "75 of 75 Posts", tag input + Add, Select/Deselect All Posts, Delete All Tags, Done).
2. **Dragged the modal by its header** (`left_click_drag` from the header ~x1143 → ~x550,y420).
3. Verified the modal repositioned; closed via **X** (no tag added).

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Modal is draggable by header | Header drag moves the modal | Modal moved from right edge (header ~x1143) to center-left (header ~x550) | ✅ |
| Content intact after drag | All controls preserved | Header / Filter Tags / "75 of 75 Posts" / tag input / Select-Deselect-Delete / Done all intact | ✅ |
| Non-destructive | No tag created | Drag-only; closed via X — no tag added, no mutation | ✅ |

## Notes / automation learning
- The Bulk Add Tags modal header is the drag handle (`.tagging-header`, cursor=grab). `computer left_click_drag` from the header text successfully repositions it (the harness reports the scaled coords, e.g. 1270→611).
- Mutating surface handled safely: only dragged + closed; **no tag added** (no Save/Add clicked).

## Bugs filed
_None._
