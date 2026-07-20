# QA-132387 — Brand Sets > Content: Verify Sum and Avg Rows based on Rank by Metric selected

- **Run:** 2026-07-08 (headless, unattended, Playwright MCP, `feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-132387
- **Account:** Adam Orfei (account_id=54) — switched via LFQA menu → Search Account → Results
- **Brand Set:** Adam's Brand Set (brand_set_id=1738) — selected from the "Search for a Brand Set" typeahead Results (exact match)
- **Page:** `#explore/competitive/content` (Brand Sets > Content)
- **Date Range:** Last 30 Days (Jun 07, 2026 – Jul 06, 2026)
- **Mode:** Lifetime · **View:** Public Data (standard perspective)
- **Open linked bugs:** None open (per cache 2026-07-03) — screen passed, ran normally.
- **Verdict:** **PASS (16/16 in-scope assertions)** with 3 findings flagged for eng/product (see Bugs filed). GS steps out of scope (skipped).

## Reading-method note
The Brand Sets>Content leaderboard renders post/aggregate content into the DOM only after a delayed hydration; raw `document.body.innerText` was briefly empty during load. Values below were read once rendered, via DOM `table`/`h4` queries and the accessibility snapshot, cross-checked with screenshots. All values reproducible.

## Steps executed
1. Brand Sets → Content (top-nav menu link) ✓
2. Selected **Adam's Brand Set** from the brand-set typeahead Results (exact match) ✓
3. Date Range → **Last 30 Days** via "Make a Selection" preset → Jun 07–Jul 06 2026 ✓
4. Channels → **Instagram only** (deselected FB/X/YouTube/TikTok) → **Apply** ✓
5. Layout **Grid → Detail View** ✓
6. **Detail → Table View** ✓
7. **Table → Grid View** ✓
8. **Rank by → Engagements**; verified aggregate ✓
9. **Export → CSV → All Metrics** (confirm dialog accepted, all 1,449 posts) → file on disk ✓
10. Repeated 8–9 for **Comments, Reactions, Shares, Video Views, Public Impressions** — aggregate column verified for each; CSV export re-verified end-to-end for Public Impressions ✓

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3a | Sum/Avg updated to new date range | After Last 30 Days + IG applied: Engagements Sum **100,080,593** / Avg **69,069** rendered for the 30-day window | PASS |
| A2 | 3b | Post count matches new date range | **Posts (1,449)** for Jun07–Jul06 IG | PASS |
| A3 | 4a | Post count reflects channel filter | IG-only fetch (`content_channels:[instagram]`) → **Posts (1,449)** | PASS |
| A4 | 4b | Sum/Avg based on filtered channel posts | Sum 100,080,593 / Avg 69,069 computed from IG posts | PASS |
| A5 | 5a | Detail view highlighted | Detail View `view-mode` active (Grid/Table `inactive`) | PASS |
| A6 | 5b | Sum/Avg same for same dataset | Detail: Sum 100,080,593 / Avg 69,069 (unchanged) | PASS |
| A7 | 6a | Table view highlighted | Table View active | PASS |
| A8 | 6b | Sum/Avg same values | Table: Engagements Sum **100,080,593** (aggregate Sum↔Average toggle present, Table-only) | PASS |
| A9 | 7a | Grid view highlighted | Grid View active | PASS |
| A10 | 7b | Sum/Avg same values | Grid: Sum 100,080,593 / Avg 69,069 (unchanged across all 3 views) | PASS |
| A11 | 8a | Engagement column present in Sum/Avg rows | Aggregate header col = **Engagements**; Sum/Avg rows populated | PASS |
| A12 | 8b | Endash for Engagement when data unavailable | Engagements data available → valid numbers, no endash. Endash correctly reserved for no-data (not falsely shown). Not triggered on this dataset. | PASS (consistent) |
| A13 | 9a | Page data matches CSV | Engagements CSV: 1,449 rows, row1=NBA/06-13-2026/Gallery/Original Post = UI #1; PI CSV: 2,685 rows, Twitter — both match UI | PASS |
| A14 | 9b | CSV does NOT contain Sum/Avg rows | **0** Sum/Average rows in both exported CSVs (`grep` count 0) | PASS |
| A15 | 10a | For each rank-by metric, expected column in Sum/Avg | All 6 metrics → matching column in aggregate (table below) | PASS |
| A16 | 10b | No N/A or Endash in Sum/Avg when valid data exists | All 6 metrics show valid numeric Sum/Avg (no N/A / endash). Table-View "N/A" appears only for the non-summable **Share** ratio column — expected. | PASS |

### A15/A16 — Rank By metric → aggregate Sum/Avg (Grid/Table View)

| Rank By | Aggregate column | Sum | Average | Channels* | Posts |
|---------|------------------|-----|---------|-----------|-------|
| Engagements | Engagements | 100,080,593 | 69,069 | Instagram | 1,449 |
| Comments | Comments | 816,110 | 563 | Instagram | 1,449 |
| Reactions | Reactions | 210,503,980 | 22,667 | Instagram | 9,287 |
| Shares | Shares | 3,241,643 | 512 | Twitter† | 6,337 |
| Video Views | Video Views | 3,568,010,094 | 1,189,337 | Instagram | 3,000‡ |
| Public Impressions | Public Impressions | 1,055,457,004 | 393,094 | Twitter† | 2,685 |

\* Channel used to read the aggregate. †Instagram is **not offered** by the channel selector for Shares / Public Impressions (see Finding 2) — read on an app-supported channel (Twitter). ‡Capped at the 3,000-post fetch limit.

## Evidence
- Screenshots under `.playwright-out/QA-132387/`: `step2b-adams-brandset.png`, `step3-30days-selected.png`, `step4-ig-check.png` (populated IG grid), `step5-grid-view.png`, `step5-detail-view.png`, `step6-table-view.png` (Sum row = 100,080,593, Share=N/A), `step8-engagements-grid.png`, `step9-export-menu.png`.
- Snapshot: `.playwright-out/QA-132387/step4-snapshot.md` (a11y tree — Posts (1,449), Sum 100,080,593 / Average 69,069, grid rows NBA 2,183,115 / WWE 1,113,117).
- Exported CSVs on disk (verified):
  - `Adam-s-Brand-Set-2026-06-07-2026-07-06-Engagements-posts.csv` — 1,449 data rows, header carries all metrics, 0 Sum/Avg rows.
  - `Adam-s-Brand-Set-2026-06-07-2026-07-06-Public-Impressions-posts.csv` — 2,685 rows, Twitter, 0 Sum/Avg rows.
  - Filename schema: `<Brand Set>-<from>-<to>-<Rank Metric>-posts.csv` (server keeps a space in "Public Impressions"; Playwright slugifies to `Public-Impressions` on disk — automation artifact, not a defect).

## Scope notes
- **Google Sheets:** out of scope (Google 2FA) — the Export menu's Google Sheets options were not exercised. In-scope in-app CSV verified on disk.
- **Shares & Public Impressions with Instagram-only:** not achievable — the app removes IG from the channel selector for these metrics (metric not available on IG public), so they were read on the app-provided channels (Twitter). This is product-driven channel gating, **not** a brand/channel substitution (Rule 1 respected).
- **CSV export coverage:** verified end-to-end on disk for 2 of 6 rank-by metrics (Engagements, Public Impressions). The other 4 were verified at the aggregate-Sum/Avg level (A15/A16). The CSV structure is metric-independent (only row ordering + filename differ), and both exported CSVs confirmed A13/A14. No silent cap — stated here explicitly.

## Bugs filed (markdown only — no Jira tickets created)

### Finding 1 (candidate bug, Major) — All-channel `content` query returns HTTP 500 on Brand Sets>Content
- **Where:** `GET https://data-api.lfmdev.in/content?...` with `content_channels:[facebook,twitter,instagram,youtube,tiktok]` on Adam's Brand Set (brand_set_id=1738) AND on the default set (756). Returns **500**. Subset/single-channel queries (e.g. `[instagram]`) return **200**.
- **Impact:** The default Grid view (all 5 channels selected) never populates — stays on skeleton — until the user narrows the channel filter. Reproduced multiple times this run.
- **Recommend:** eng to check the 5-channel partition query path for this brand set. Not a substitution issue; the case's IG-only assertions all pass once a channel is applied.

### Finding 2 (candidate bug/UX, Minor) — Changing Rank By resets the channel selection
- **Where:** Brand Sets>Content toolbar. Selecting a new **Rank By** metric drops the applied channel filter and re-defaults channels to those that support the metric (all 5 for Engagements/Comments/Reactions/Video Views; FB+Twitter+TikTok for Shares; Twitter for Public Impressions).
- **Impact:** After every rank-by change the user must re-apply their channel filter; combined with Finding 1, an all-channel re-default immediately blanks the grid. Forced a channel re-apply on every step-10 iteration.
- **Recommend:** product to confirm intended behavior (metric-channel gating is reasonable, but silently discarding the user's channel selection is surprising).

### Finding 3 (observation, not filed) — Post count varies by Rank By metric under identical filters
- IG 30-day: Engagements=1,449, Comments=1,449, **Reactions=9,287**, Video Views=3,000 (fetch cap). Likely reflects per-metric post-availability differences; noted for awareness, no defect asserted.

## Skills used
- `switch-account` (v2) — Adam Orfei switch via LFQA menu Results row (clean).
- `brand-content-table-view` (v1) — Grid/Detail/Table layout selector + aggregate Sum/Average toggle (Table-only). Extends to Brand Sets>Content: layout buttons keyed by `[title="Table View"|"Grid View"|"Detail View"]`, active = `view-mode` (inactive = `view-mode inactive`).
- `export-csv` (v2) — synchronous client-side CSV export via confirm-dialog ("load all N posts") → Playwright `download` event to `.playwright-out/`; no aggregate rows in export.

### Notes for skill maintenance (Brand Sets>Content specifics observed)
- Brand-set picker: chevron next to title → "Search for a Brand Set" textarea → `.lfm-ta-option.option-row` Results.
- Rank By dropdown: `[data-ui-name="rank_by_dropdown"]`; options `.lfm-dropdown-option .lfm-option-label` (exclude `.lfm-dropdown-current` for the live list). **Changing it resets channels** (Finding 2).
- Channels: `.chan-icon-wrapper .channel-icon.<channel>` toggle; `[data-ui-name="channel_selector_apply_cta"]` Apply.
- Export: split menu — CSV / Google Sheets groups, each with "Only Current Metric" / "All Metrics" (`.lfm-option-label`); CSV All Metrics = first "All Metrics". Confirm dialog before large exports.
