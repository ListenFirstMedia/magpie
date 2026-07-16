# QA-85175 — Dashboards - Drag and Drop Tile Ordering

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-85175
- **Run date:** 2026-07-07 (Playwright MCP track)
- **Account:** Adam Orfei (account_id=54)
- **⚠ MUTATING TEST — user pre-approved via AskUserQuestion at session start.**
- **Skill used:** `dashboard-mutation-flows` (v2, untrusted)
- **Cleanup:** dashboard `QA-85175-TEST-20260707` (id 6267) created, exercised, and **deleted** at end of run — confirmed via Dashboard list count dropping from (4) to (3) with the entry gone.

## Steps executed

1. Brand → Insights → MTV (brand_id=4018, Adam Orfei).
2. Saved **New Posts** tile to a new dashboard named `QA-85175-TEST-20260707` (React-aware `value`-setter for the name input, JS `find`-by-text for the Create Dashboard / Ok buttons — per skill's documented pattern).
3. Saved **Engagements** and **Impressions** tiles from the same Insights page to the *existing* `QA-85175-TEST-20260707` dashboard (checkbox row in the Save-to-Dashboard dropdown).
4. Opened the dashboard (id 6267) — confirmed all 3 tiles present in order New Posts → Engagements → Impressions.
5. Options → **Edit** → Order/Tile modal opened.
6. Dragged the **New Posts** row down past **Engagements** (synthetic `mousedown` + 8 stepped `mousemove`s + `mouseup`, per the skill's documented drag recipe) → order became Engagements(1) → New Posts(2) → Impressions(3).
7. Clicked **Ok**.
8. Reloaded the dashboard page to verify persistence.
9. Cleanup: Options → Delete → confirmed → verified removed from the dashboard list.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 7a | Column headers `Order` and `Tile` | Modal shows exactly these two column headers | **PASS** |
| A2 | 7b | Tiles displayed in Order column | Order 1/2/3 with numeric spinners, Tile column shows full tile descriptor (`MTV (Brand: Insights) Authorized Data - <Name> [Cross-Channel]`) | **PASS** |
| A3 | 8a | Tile row is movable | Drag recipe successfully moved the New Posts row down one position | **PASS** |
| A4 | 8b | 1st → 2nd row swap | Order changed from New Posts/Engagements/Impressions to Engagements/New Posts/Impressions — a clean adjacent swap | **PASS** |
| A5 | 9 | Tile order in dashboard reflects changes | **FAIL — see Bugs filed.** The Edit modal (re-opened after reload) correctly shows the persisted new order (Engagements=1, New Posts=2, Impressions=3), but the **dashboard page itself renders zero tiles** after the reorder+Ok+reload cycle — a blank content area, no tile-fetch network request fires at all. | **FAIL** |
| A6 | 12 | Tile order remains unchanged after Cancel | Not independently exercised this run — the empty-render bug (A5) made further order-manipulation testing unreliable; recommend re-testing once A5 is fixed. | **NOT TESTED** |

## Evidence

- Edit modal after drag, before Ok: Order column read `1 / 2 / 3` next to Engagements / New Posts / Impressions (screenshot captured).
- After Ok + full page reload: `document.querySelectorAll('h4')` → `[]` (zero tiles rendered) on three consecutive checks (initial reload, 3s wait, fresh navigation). `browser_network_requests` showed **no dashboard-tile-fetch call at all** — only `recent_brand_view_sets` and Mixpanel tracking calls — meaning the frontend never attempted to load tile data for the page.
- Re-opening Options → Edit on the same (visually empty) dashboard still correctly listed all 3 tiles with the persisted order (1=Engagements, 2=New Posts, 3=Impressions) — confirming the **backend/tile-list data survived intact**; this is a **frontend rendering regression**, not data loss.
- Console showed repeated React warnings: `Warning: render(...): Replacing React-rendered children with a new root component` — consistent with an error boundary silently unmounting/remounting the tile-grid component after the reorder.

## Problems encountered

1. **Confirmed Major bug (new): dashboard tile grid fails to render after Edit → drag-reorder → Ok, even after a hard reload.** The tile configuration persists correctly (verified via the Edit modal), but the page's actual tile-rendering pipeline breaks — no tiles shown, no fetch request issued. This is distinct from the already-known "Remove from Dashboard doesn't persist" bug documented in the skill's 2026-06-11 note (that one is a *false-positive-removal* bug; this one is a *renders-nothing-after-persisted-reorder* bug).
2. **Delete confirmation Ok click failed silently on the first attempt** when clicked via the single-dashboard Options menu (the dashboard, being tile-less, may have had a broken DOM tree that ate the click) — the dashboard was NOT deleted despite no error. Switching to the **Dashboard Menu → "view all" list modal's inline `Delete` link** (which opens the same confirm dialog) succeeded and was verified via the dashboard count dropping from (4) to (3). Future cleanup steps should verify via the count/list, not just assume a click succeeded.
3. The "Dashboard Menu" list modal (`#view-all-modal`) stayed open across page navigations in a way that intercepted later clicks — had to be explicitly queried/closed via DOM rather than assumed closed after navigating away.

## Skill updates

`dashboard-mutation-flows` — adding a v3 note for the new empty-render bug and the delete-verification requirement (check the list count, don't trust a silent click).

## Bugs filed

- **BUG (Major, new) — Dashboard renders no tiles after Edit→drag-reorder→Ok, despite the reorder persisting correctly server-side.** Repro: create a dashboard with 2+ tiles → Options→Edit → drag a row to a new position → Ok → reload. Expected: dashboard shows all tiles in the new order. Actual: dashboard content area is completely empty; Edit modal still lists all tiles with the correct (persisted) new order. No network request for tile data fires on load. Recommend filing against the dashboard tile-grid rendering component — likely an unhandled exception when initializing tiles from a mutated order array (matches the observed React "replacing rendered children" warning, suggestive of an error-boundary remount).
