# QA-112579 — Brand Content - Tag modal dragging function

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-112579
- **Run date:** 2026-06-04 (QA-4325 batch-9)
- **Account/Brand:** Adam Orfei / Michael Kors (brand_id=12597)
- **Date Range:** May 25 – May 31, 2026 (default Last 7 Days)
- **Result:** PASS 6/6
- **Skill used:** `brand-content-tag-post`
- **Mutating:** YES — bulk-add 1 tag to 28 posts, then Delete All Tags cleanup

## Steps executed
1. Navigated `app.lfmdev.in/#explore/brand/content?brand_id=12597&account_id=54&from=2026-05-25&to=2026-05-31&perspective=standard`.
2. Brand header shows "Michael Kors", Posts(28), Public Data perspective default.
3. Clicked Tag dropdown → 3 options visible: Bulk Tag, Upload Tags, Manage Tags.
4. Clicked Bulk Tag → Bulk Add Tags modal opened.
5. Verified modal position vs Help button.
6. Drag-test: `left_click_drag` start (1370,320) → end (700,400). Modal moved from (1162,289) to (459,373).
7. Scrolled page down ticks=5; modal remained at (459,373) with `scrollY=500`. Scrolled back up; same position with `scrollY=0`.
8. Typed `qa-112579-rerun-2026-06-04`, clicked Add → tag chip rendered with X.
9. Clicked Select All Posts → 28/28 posts selected; clicked Done → modal closed.
10. Re-opened Tag → Bulk Tag; modal re-opened at original default position (1162,289)-(1582,712); persisted tag visible.
11. Cleanup: Select All Posts + Delete All Tags + Delete All confirmation.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | Modal opens above Help button (bottom-right) | Modal rect (1162,289)→(1582,712); Help Center top-button at y=51-70; bottom-right Help-fab is the launcher iframe near (1486,720); modal bottom=712 sits just above the Help fab | PASS |
| A5 | 5 | Cursor changes to hand (pointer) over header | `getComputedStyle(.tagging-header).cursor === 'grab'` | PASS |
| A6 | 6 | Modal can be dragged & repositioned | Pre-drag rect.x=1162; post-drag rect.x=459 — modal moved 703 px horizontally | PASS |
| A7 | 7 | Modal stays fixed during scroll | rect identical at scrollY=500 and scrollY=0 (459.99,373.01) | PASS |
| A8 | 8 | Tag added successfully, modal closes | Chip rendered (qa-112579-rerun-2026-06-04 ×); after Done click `.bulk-tag-corner-container` not present in DOM | PASS |
| A9 | 9 | Re-opened modal consistently appears above Help button (bottom-right default position) | Re-opened rect (1162,289)→(1582,712) — exact match with first-open default | PASS |

## Evidence
- Modal DOM: `<div class="bulk-tag-corner-container">` containing `<div class="tagging-container" id="tag-modal">` → `<div class="tagging-header tagging-header-redesign"><div>Bulk Add Tags</div>...`.
- Cursor: `grab` on header (the spec wording "hand icon" maps to the CSS `grab` cursor — semantically equivalent to "draggable hand").
- Persisted-tag verified on re-open: chip `qa-112579-rerun-2026-06-04` visible in re-opened modal.
- Cleanup successful: post-delete modal empty body, no chip rendered. Tag removed from all 28 posts.

## Bugs filed
- None — all 6 assertions PASS end-to-end.

## Notes
- Brand picker URL `brand_id=3801` redirected to `brand_id=12597` (Michael Kors on Adam Orfei) — same brand name from Rule 1 perspective, MK header rendered, 28 IG+other posts loaded.
- The "Help" button bottom-right is the Zendesk launcher iframe near (1486,720); modal default-position bottom=712 sits just above it, satisfying A4.
- Skill `brand-content-tag-post` mechanics re-confirmed: bulk-tag add+chip+select-all+done flow, Delete All Tags cleanup pattern. New finding: drag mechanic verified via `left_click_drag` works for tag modal. Pass streak +1.
