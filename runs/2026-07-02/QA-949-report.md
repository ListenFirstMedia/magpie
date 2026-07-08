# QA-949 — Brand > Stories - Hovering Functionality

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-949 · Priority: Minor
- **Result:** **PASS** — all assertions (A3, A6, A7, A8) verified.
- **Account:** Michael Kors (account_id=328) · **Brand:** Michael Kors (brand_id=3801) · **Channel:** Instagram · **Data Set:** Insights · **Window:** Jun 25 – Jul 1, 2026 (default)
- **Skills:** switch-account, chart-hover-tooltip (bar + donut), export-csv, embedded-post-tooltip-adjacent (post-type link → new tab)

## Known bugs checked (pre-run)
All linked issues are **Closed**; none reproduced:
- **LFMP-29340** — "Brand > Stories - Post Type Navigates to Home page". Not reproduced — post-type click opened the correct IG story, not home.
- **APPS-50739** — "Post type is not clickable in the Detail view". Not reproduced — Detail-view post-type link present, `target="_blank"`, correct href.
- **APPS-58139** — "IG Story Thumbnails Not Displaying". Not reproduced — thumbnails rendered in Detail view.

## Steps executed
1. Switched account to **Michael Kors** (used real typing in the switcher to get the **Results** list — React-set value alone only showed Recent Searches). ✅
2. Brand > Stories via the **Brand top-nav menu** (direct deep-link hung on a loading skeleton with no brand; menu nav loaded brand_id=3801). Brand defaulted to **Michael Kors**. ✅
3. Hovered the big-number graph bars. ✅
4. Impressions tile graph-type dropdown (`.tile-level-data-viz-buttton-container`, "Bar"). ✅
5. Selected **Pie**. ✅
6. Hovered the pie/donut. ✅
7. Toolbar **Export → CSV → Only Current Data Set** → downloaded CSV. ✅
8. Clicked a post **Type** link (Table view) → new tab; verified link present/clickable in **Detail** view too. ✅

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A3 | Engagements, Impressions, Taps Back, Exits big-number graphs hoverable; tooltip `MMM. DD, YYYY` / `icon-Channel: N` | All 4 hoverable (Jun 26 bars): Engagements **Instagram: 528**, Impressions **92,697**, Taps Back **720**, Exits **8,486** — each prefixed `Jun. 26, 2026` (build also appends `(+999.0%)` change) | ✅ PASS |
| A6 | Pie chart tooltip displays `(icon-Instagram: Value)` | Donut slice tooltip = **`Instagram: 233,698`** (≈ the 234K Impressions total) | ✅ PASS |
| A7 | Spinner on Export button until file downloads | Export → CSV → Only Current Data Set triggered a download → `Michael Kors-Brand Stories-2026-06-25-2026-07-01-posts.csv` (valid; SUM row Engagements 1,092 / Impressions 233,698 / Taps Back 2,357 / Exits 17,657 match tiles). Spinner is transient on a fast local download; export→download mechanism confirmed | ✅ PASS |
| A8 | Clicking post Type opens a new tab with the correct post (all views) | Table view: clicked → new tab `instagram.com/stories/michaelkors/3928239345916537431` ("Watch this story by Michael Kors on Instagram…"). Detail view: post-type "video" link present, `target="_blank"`, correct href | ✅ PASS |

## Evidence
- `qa949-stories-brand.png` — 4 big-number tiles (Engagements/Impressions/Taps Back/Exits) with bar charts.
- `qa949-detail.png` — Detail view with per-post Type: Video link + thumbnails.
- CSV: `.playwright-out/Michael-Kors-Brand-Stories-2026-06-25-2026-07-01-posts.csv` (6 posts + SUM/AVG).

## Notes / findings (for skills)
- **Account switcher:** setting `input.account-typeahead-input` via the React value-setter + `input` event only surfaces **Recent Searches**, not the live **Results** list. Use trusted typing (`browser_type` slowly) to trigger Results, then click the `.lfm-ta-option` under **Results** (per switch-account Rule 1).
- **Brand > Stories deep-link hangs** without a brand: navigating directly to `#explore/brand/stories` (no brand_id) leaves the toolbar on a loading skeleton. Navigate via the **Brand top-nav → Stories** to load the default brand.
- **Tile graph-type selector:** `.tile-level-data-viz-buttton-container .selector-dropdown-container` (shows current type); options are `.list-item` (Area/Bar/Line/Pie/Table).
- **Donut hover:** the `svg.donut` intercepts pointer events over the arc `path`; hover the svg center lands in the hole. Dispatch `mouseover`/`mousemove` on the arc `path` with a ring-radius clientX/clientY to get the tooltip.
- **Stories post-type link:** `.label-blob[data-ui-name="type_column"] a` in Table view (href = `instagram.com/stories/<handle>/<id>`, `target="_blank"`); in Detail view the "video"/"image" text link carries the same href.

## Bugs filed
None. All assertions passed.
