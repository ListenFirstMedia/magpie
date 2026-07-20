# QA-88219 — Dashboards - Brand Content - Functionality to save filtered tiles to the dashboard (re-run 2026-06-04 batch-6)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-88219
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id resolved to 10765 by app)
- **Channels:** Facebook, Twitter, Instagram, TikTok
- **Date range:** Absolute May 27 – Jun 02 2026, In-Window
- **MUTATION tag:** `qa-88219-rerun-2026-06-04-b6` (dashboard name)

## Result: PASS (5/5) — full Save-to-Dashboard end-to-end including filter persistence and cleanup

## Steps executed
1. Switched account UCLA → Adam Orfei via user dropdown (Results section selection).
2. Brand → Content for MTV with all 4 channels + In-Window + Public.
3. Applied Filter: `Publish Type = Reel (Include)`. Posts dropped 73 → 10 (Reel-only). Sum Engagements = 228,847.
4. Switched Insights dropdown to `Content Insights` — Content Performance tile rendered with Engagements 228,847 on Instagram (Video bar) and 0 on FB/Twitter/TikTok (correctly mirroring filter result).
5. Clicked per-tile `Save to Dashboard` dropdown — surfaced existing-dashboard checkbox (Yash) + `Create Dashboard` button.
6. Clicked Create Dashboard — modal opened titled "Create New Dashboard". Filled `Dashboard Name = qa-88219-rerun-2026-06-04-b6` via React-aware InputEvent setter. Clicked Ok.
7. Save to Dashboard counter incremented to `Save to Dashboard (1)` — confirming the tile was saved.
8. Navigated to Dashboards. Dashboard Menu showed `Dashboards (2): Yash, qa-88219-rerun-2026-06-04-b6`.
9. Opened qa-88219 dashboard (URL `#dashboards/6353`). Verified the saved tile renders correctly with:
   - Brand link: `MTV (Brand: Content)` (top-left)
   - Perspective label: `Public Data` (top-right)
   - Filter chip preserved: `Publish Type: Reel` with `Filter(1)` count
   - Tile: `Performance by Type` Rank Engagements, Video bar at ~228K (matches source 228,847)
10. CLEANUP: Dashboard Menu → Delete on `qa-88219-rerun-2026-06-04-b6` row → confirmation modal → Ok.
11. Re-opened Dashboard Menu → `Dashboards (1)` showing only `Yash` — cleanup verified.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | Save to Dashboard control present on Content Insights tile | Visible at bottom of Content Performance tile next to Export | PASS |
| A2 | 6 | Save modal opens; can pick or create dashboard | `Create New Dashboard` modal opened with Name input + Ok/Cancel buttons | PASS |
| A3 | 7-8 | Save completes; tile appears on dashboard | Save counter incremented to (1); new dashboard `qa-88219-rerun-2026-06-04-b6` (id=6353) created in Dashboards (2) list | PASS |
| A4 | 9 | Dashboard tile renders with filter applied (numerics match Brand>Content) | Performance by Type tile shows Video bar = ~228K matching source Sum Engagements 228,847; Filter(1) chip with `Publish Type: Reel` preserved verbatim; perspective `Public Data` label preserved | PASS |
| A5 | 10-11 | Cleanup — tile/dashboard deleted, no orphan | Dashboard deleted via Delete + Ok confirmation; Dashboard list back to `Dashboards (1)` showing only Yash | PASS |

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-88219-report.md`
- `/Users/yashsharma/git/magpie/testcases/english/QA-88219.md` (proxy spec)

## Mutation audit
- **Created:** Dashboard `qa-88219-rerun-2026-06-04-b6` (id=6353)
- **Cleaned:** Deleted dashboard `qa-88219-rerun-2026-06-04-b6` end-to-end. Confirmed `Dashboards (1)` post-cleanup.
- **No orphans.**

## Notes / Skill candidates

- **New flow:** Save-filtered-tile-to-dashboard pattern. Path is Brand>Content → apply Filter (e.g., Publish Type) → switch Insights dropdown to Content Insights to surface tile-based view → per-tile `Save to Dashboard` dropdown → Create Dashboard (or pick existing) → tile rendered on Dashboard with filter chip preserved verbatim.
- **React-controlled input:** `Dashboard Name` input requires React-aware InputEvent setter (Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set + dispatch 'input' event). Same pattern as TWC brand picker.
- **JS click required:** Save to Dashboard dropdown chevron + Create Dashboard button + Ok button all needed JS-fallback clicks (coordinates inconsistent due to dropdown overlay positioning).
- Candidate to fold into a new `dashboard-save-filtered-tile` skill or extend the existing `dashboard-mutation-flows` scaffold from 2026-05-18.
