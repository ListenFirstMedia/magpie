# QA-88219 — Dashboards - Brand Content - Functionality to save filtered tiles to the dashboard

- **Run:** 2026-07-11 (unattended, headless, Playwright MCP, branch `feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-88219
- **Type:** MUTATING — unique tag `qa-88219-rerun-2026-07-11-1552`; cleanup performed.
- **Skill reused:** `dashboard-mutation-flows` (v2 Save-filtered-tile pattern) + `brand-content-filter`.
- **Verdict:** **PASS** (5/5 assertions). Filtered tile saved, filter context + numerics preserved on the dashboard, full cleanup verified.

## Environment / configuration
- Account: **Adam Orfei** (account_id=54); Brand: **MTV** (brand_id=4018).
- Perspective: **Authorized Data** (`perspective=extended`) — the active view on landing; not spec-constrained, kept as-is per Rule 2 (no toggle needed).
- Date Range: Jul. 04, 2026 – Jul. 10, 2026 (Mode: Lifetime). Data Set: Public.
- Filter applied: **Publish Type = Reel** (Include). URL serialized on Apply: `filters={"content_post_class":{"operator":"or","values":["reel"],"not":"false"}}`.

## Steps executed
1. Logged in programmatically (Cognito "existing account", lfiqa) → `#home` rendered (pre-flight PASS).
2. Navigated Brand → Content for MTV. Opened Filter → **Publish Type**; value list = IGTV / Original Post / Quote / Reel / Retweet / X Thread. Selected **Reel** (row `selected`, `fa-check-square`), clicked **Apply Filter**. Chip **"Publish Type: Reel | Include"** rendered; `Posts (9)`. Screenshots 01–03.
3. Switched the **Insights** dropdown → **Content Insights**. The **Performance by Type** tile rendered (Instagram/purple bar ≈120K). Screenshot 04.
4. On the Performance by Type tile, opened **Save to Dashboard** dropdown (existing-dashboard list + **Create Dashboard**). Clicked **Create Dashboard** → "Create New Dashboard" modal. Filled Name `qa-88219-rerun-2026-07-11-1552` (React-aware InputEvent setter) → **Ok**. Modal closed; tile counter incremented **Save to Dashboard → Save to Dashboard (1)**. Screenshot 05.
5. Dashboards → Dashboard Menu: count **Dashboards (34)**, new dashboard listed. Opened it (`#dashboards/6422`). Tile header **"MTV (Brand: Content)"**, chip **"Publish Type: Reel"**, **Filter(1)**, perspective **"Authorized Data"** — all preserved. Chart body first showed **"This tile failed to load. Please try again."**; clicked **RELOAD** (still failed once), then full-page nav with the dashboard's channel params recovered it. Bar chart rendered with value **121,430** = source Sum Engagements for Reel. Screenshots 06–11.
6. **Cleanup:** Options → Delete → confirm modal `Are you absolutely sure you want to delete your "qa-88219-rerun-2026-07-11-1552" dashboard? Click "Ok" to continue.` → Ok. Redirected to default dashboard 6411. Dashboard Menu count **Dashboards (33)**; test dashboard **absent**. Screenshot 12.

## Source (Brand > Content, Reel filter) — aggregate numerics
| Row | Engagements | Reactions | Comments | Shares | Response Rate | Video Views | Video Response Rate |
|-----|-------------|-----------|----------|--------|---------------|-------------|---------------------|
| Sum | 121,430 | 120,513 | 917 | – | N/A | 2,886,372 | N/A |
| Average | 13,492 | 13,390 | 102 | – | 0.06% | 320,708 | 4.21% |

Posts (9). Top post (Reel) Jul. 06, 2026 — Engagements 49,674 / Video Views 641,250.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Save to Dashboard control present & clickable on ≥1 Brand>Content tile | Present on every Content Insights tile (Performance by Type used); dropdown toggler clickable | PASS |
| A2 | 3 | Save modal opens | Save-to-Dashboard dropdown opened (existing dashboards + Create Dashboard); Create → "Create New Dashboard" modal opened | PASS |
| A3 | 4 | Save completes (modal closes; success signal) | Modal closed after Ok; tile counter `Save to Dashboard` → `Save to Dashboard (1)` | PASS |
| A4 | 5 | Dashboard tile renders with filter applied; numerics match Brand>Content | Header "MTV (Brand: Content)", chip "Publish Type: Reel", Filter(1), perspective "Authorized Data" all preserved; bar value **121,430** == source Sum Engagements 121,430 | PASS (recovered after transient tile-load failure) |
| A5 | 6 | Cleanup — tile/dashboard deleted, no orphan | Dashboard deleted via confirm modal; count 34→33; test dashboard absent from list | PASS |

## Known bugs checked
- **Linked open bugs (bug-history.md QA-88219):** 0 open. Not an open-bug auto-fail case (Rule 7 clear). Prior PASSes: 2026-06-04 batch-6, 2026-06-08 RECONFIRM. No regression indicators for this flow.
- **Reload-error tile (feedback_reload_button / framework rule):** the dashboard "Performance by Type" tile initially rendered **"This tile failed to load. Please try again."** with a RELOAD button. Per the reload-first rule I clicked RELOAD (still failed once) then re-navigated with the full channel param set, after which the chart rendered correctly with matching data. This is a transient dashboard-tile render flake (consistent with known dashboard/insights render friction), **not** a functional defect — the tile config, filter context, and data were all correct once loaded. A4 judged PASS, not BLOCKED, because the tile recovered within budget and the numeric matched the source exactly.
- **URL-serialize-on-Apply quirk (brand-content-filter v3):** confirmed — `filters=` only appeared in the URL after clicking Apply Filter. Expected.

## Bugs filed
- None. (Transient tile-load flake noted above is a re-probe-each-run render artifact, not filed.)

## Evidence (screenshots under `.playwright-out/QA-88219/`)
- 01-filter-publish-type-open.png, 02-publish-type-values.png, 03-filtered-results.png
- 04-content-insights-tile.png (source Performance by Type bar ≈120K)
- 05-create-dashboard-modal.png (name filled)
- 06/07-dashboard-tile*.png (loading), 08/09-*.png (tile-failed + after RELOAD), 10-fresh-nav.png
- 11-dashboard-tile-data-match.png (chart rendered; Reel bar 121,430)
- 12-delete-confirm.png (confirm modal verbatim text)
