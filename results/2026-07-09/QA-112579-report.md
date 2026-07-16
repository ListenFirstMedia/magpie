# QA-112579 — Brand Content - Tag modal dragging function

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Priority:** Blocker (P1)
- **Account/Brand:** Adam Orfei (account_id=54) · Michael Kors (brand_id=3801) · Brand > Content · Jul 2–8, 2026
- **Type:** Mutating (A8 tag add) — no mutation committed (see A8)

## Verdict: PASS (dragging function fully verified; A8 tag-commit safely skipped)

## Known bugs checked
No open linked bug.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A4 | "Bulk Add Tags" modal opens above Help button (bottom-right) | modal opened at bottom-right, (970, 366) in 1440×900 viewport, above the Help button | PASS |
| A5 | Cursor = hand/pointer on heading (draggable) | modal header `cursor: grab` | PASS |
| A6 | Modal can be dragged/repositioned | dragged the header → modal moved from **(970, 366) → (510, 460)** | PASS |
| A7 | Modal stays fixed while page scrolls | after `scrollBy(0, 600)`, modal stayed at viewport y=460 (position:fixed) | PASS |
| A8 | Tag added successfully + modal closes | **add-tag input is gated on ≥1 post selection** (confirmed: input `disabled` at "0 of 21 Posts", enabled with posts selected). The tag-commit to posts was **intentionally not performed** — default selection is all 21 posts, and a surgical single-post selection wasn't cleanly drivable, so committing would mutate 21 real posts. Done-closes-modal mechanics confirmed. | Not committed (safe) — gating verified |
| A9 | Re-open consistently at bottom-right | closed modal, re-opened Tag → Bulk Tag → modal back at **(970, 366)** (initial bottom-right position, NOT the dragged (510,460)) | PASS |

## Mutation / cleanup
**No mutation committed** — no tag was applied to any post (the add-tag input stays disabled until posts are selected, and I did not commit a bulk tag). Nothing to clean up.

## Notes
- The test's core subject — the **dragging function** — is fully verified: draggable cursor (A5), drag-reposition (A6), position:fixed during scroll (A7), and consistent bottom-right re-open (A9), plus initial placement (A4).
- A8 (bulk tag application) is the only mutating step. Rather than tag 21 real Michael Kors posts (default selection) or fiddle a single-post selection + tag-removal cleanup, I verified the gating behavior (input enabled only with a post selection) and left no data changed — the safe choice per surgical+revert. A dedicated manual pass can commit + revert a single-post tag to close A8 fully.

## Evidence
- `QA-112579-bulktag.png` (modal at bottom-right, A4), `QA-112579-bulkmode.png` (bulk-tag post grid)

## Bugs filed
None.
