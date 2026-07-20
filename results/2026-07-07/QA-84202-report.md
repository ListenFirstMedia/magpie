# QA-84202 — Dashboards - Order model basic view

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-84202
- **Run date:** 2026-07-07 (Playwright MCP track)
- **Account:** Adam Orfei (account_id=54)
- **⚠ MUTATING TEST — user pre-approved via AskUserQuestion at session start.**
- **Skill used:** `dashboard-mutation-flows` (v3, untrusted)
- **Cleanup:** dashboard `QA-84202-TEST-20260707` (id 6268) created, exercised, and **deleted** — confirmed via Dashboard list count dropping from (4) to (3).

## Steps executed

1. Brand → Insights → MTV (brand_id=4018).
2. Saved **Follower Growth** tile → Create Dashboard `QA-84202-TEST-20260707`.
3. Saved **Video Views** tile to the same (now-existing) dashboard.
4. Opened dashboard (id 6268) — confirmed both tiles present, order: Follower Growth, Video Views.
5. Options → **Edit** → Order/Tile modal.
6. Dragged **Follower Growth** row down past Video Views → order became Video Views(1), Follower Growth(2).
7. Clicked **Ok**.
8. Reloaded the page to check persistence (A5).
9. Options → **Edit** again → dragged **Video Views** row down (back to Follower Growth(1), Video Views(2) in the modal) → clicked **Cancel** this time (A6).
10. Re-opened Options → Edit to inspect the post-Cancel state.
11. Cleanup: Dashboard Menu → "view all" list → inline **Delete** on the test dashboard → confirmed → verified count dropped.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 7a | Column headers `Order` and `Tile` | Present | **PASS** |
| A2 | 7b | Tiles displayed in Order column | Order 1/2 with tile descriptors | **PASS** |
| A3 | 8a | Tile row is movable | Drag successfully swapped rows | **PASS** |
| A4 | 8b | 1st → 2nd row swap | Follower Growth/Video Views → Video Views/Follower Growth | **PASS** |
| A5 | 9 | Tile order in dashboard reflects changes | Immediately after Ok (no reload), the dashboard page still showed the OLD order (Follower Growth, Video Views) — no live re-render. After a hard reload, the dashboard rendered **zero tiles** (same empty-render bug found in QA-85175), while the Edit modal (which auto-reopened on reload) correctly showed the persisted new order (Video Views=1, Follower Growth=2). | **FAIL** |
| A6 | 12 | Tile order remains unchanged after Cancel | **FAIL.** Dragged Video Views back down (transient in-modal order → Follower Growth=1, Video Views=2), clicked **Cancel**, then re-opened Edit: the modal showed **Follower Growth=1, Video Views=2 — the just-dragged (uncommitted) order, not the last-saved order (Video Views=1, Follower Growth=2)**. Cancel did not discard the in-progress drag. | **FAIL** |

## Evidence

- Post-first-drag, pre-Ok: modal order `Video Views(1) / Follower Growth(2)`.
- Immediately after Ok (no reload): dashboard `h4`s still read `Follower Growth: -4,620... / Video Views: 12.2M...` — stale order, no live update.
- After hard reload: `document.querySelectorAll('h4')` → `[]`. Edit modal (auto-reopened) showed the *correct* persisted order (Video Views=1, Follower Growth=2) — confirms the same class of rendering bug as QA-85175.
- Second drag (Video Views → below Follower Growth) then **Cancel**: re-opening Edit showed `Follower Growth(1) / Video Views(2)` — the dragged, not-yet-saved arrangement — proving Cancel did not revert the modal's in-memory drag state.

## Problems encountered

1. **Reproduces the QA-85175 empty-dashboard-after-reorder bug** on an independent dashboard (id 6268, different tiles: Follower Growth + Video Views vs. QA-85175's New Posts/Engagements/Impressions). This corroborates it as a systemic issue with the dashboard tile-grid renderer after any Edit→drag→Ok cycle, not a one-off.
2. **New finding this run: Cancel doesn't revert the drag.** The Order/Tile modal's row order is evidently held in a single piece of component state that both the drag handler and the Ok/Cancel buttons operate on — dragging mutates it immediately, and Cancel merely closes the modal without resetting that state back to the last-saved order. Re-opening Edit shows the modal's stale in-memory order (from the aborted drag), not the true last-saved server order. Note the *dashboard page itself* wasn't re-verified post-Cancel since it was already broken/empty from the first Ok+reload — worth a clean re-test once the render bug (Problem #1) is fixed.
3. Both the "auto-reopening" of the Edit modal on page reload (also seen in QA-85175) and the Dashboard Menu's "view all" list modal persisting across navigations continue to make coordinate-free, state-driven interaction the only reliable approach — plain `browser_click` by visible text repeatedly hit "element intercepts pointer events" errors from these lingering modals.

## Skill updates

`dashboard-mutation-flows` — the v3 note already covers the empty-render bug (added during QA-85175). Adding the Cancel-doesn't-revert finding as a second bullet in the same v3 entry.

## Bugs filed

- **BUG (Major) — Dashboard renders no tiles after Edit→drag-reorder→Ok** (same defect confirmed in QA-85175; see that report for the primary repro). Second independent confirmation here rules out a one-off/flaky render.
- **BUG (Minor/Major-adjacent) — "Cancel" in the dashboard Order/Tile Edit modal does not discard an in-progress drag.** Repro: open Edit → drag a row to a new position → click Cancel → re-open Edit. Expected: order matches the last-saved state. Actual: order reflects the discarded drag. Low real-world severity (user must re-open Edit and manually re-notice the wrong order) but it means "Cancel" is not a safe undo — recommend the modal reset its local row-order state to the server-provided order whenever it's opened, not just cache it across close/reopen cycles.
