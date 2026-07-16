---
name: chart-hover-tooltip
version: 4
last_verified: 2026-07-15
last_passed_run: 2026-07-15
trust: untrusted
pass_streak: 3
preconditions: [chart-rendered-with-data]
postconditions: [tooltip-text-captured]
inputs: [chart_type, datapoint_index]
outputs: [tooltip_text]
related_pages: ["/#explore/brand/insights", "/#explore/brand/audience", "/#explore/brand/stories"]
---

# Chart Hover Tooltip

> **2026-06-22 — Playwright MCP rewrite. READ THE "Playwright MCP" SECTION FIRST.**
> Under Playwright MCP, `browser_hover` is a **trusted** hover and triggers chart tooltips natively —
> the JS synthetic-event workaround below is **no longer needed**. The charts are also **D3 SVG, not
> Recharts**, so the `.recharts-*` selectors in the legacy steps **do not exist** in the current
> build. The legacy "Chrome MCP / Recharts" content is retained below for history only.

## Playwright MCP — current approach (Brand > Insights, verified 2026-06-22)

The Brand>Insights big-number tiles render **D3 / custom SVG** charts, not Recharts. Real markup:
- Bars: `rect.bar.<channel>-<YYYY-MM-DD>` (e.g. `rect.bar.twitter-2026-06-14`).
- Donut: `.arc` / `.donut-center-label`; axes: `.axis .tick .domain`.
- Bar `<title>` elements are **empty** — the tooltip is JS-driven, not a native SVG title.

**Steps:**
1. Ensure tiles are loaded with a **valid date + compare-date window**. If you reach Insights with
   missing/invalid `compare_from`/`compare_to`, tiles never load (looks like a hang — it is NOT).
   Switching account via the LFIQA menu, or navigating via the Brand menu after a Home load with
   dates, sets valid compare dates. (See `knowledge-base/known-quirks.md` 2026-06-22.)
2. Locate a populated datapoint and tag it (custom SVG is not in the a11y tree):
   ```js
   // browser_evaluate
   const bar = document.querySelector('rect.bar.twitter-2026-06-14'); // pick a non-zero one
   bar.setAttribute('data-spk','hoverbar');
   ```
3. `browser_hover` the tagged element — `[data-spk="hoverbar"]`. No synthetic events needed.
4. Read the tooltip from the DOM at **`.al-bar-chart__tooltip`** (no screenshot required):
   ```js
   document.querySelector('.al-bar-chart__tooltip')?.textContent
   ```
   Format: `Mon. DD, YYYY` then one line per channel `Channel: value (±%)`, e.g.
   `Jun. 14, 2026 · Facebook: 4,994 (+108.4%) · Twitter: 13,183 (+2.7%) · …`.
   This satisfies QA-96670 A2 (bar) / A4 (area) format checks.
5. A screenshot (`browser_take_screenshot`) is a fallback only if the tooltip selector changes.

Used by:
- **QA-96670** — Brand Insights chart hovers (account "Max" → HBO Max; current-week Threads data may
  be zero, use a populated channel/window).
- Any test asserting on chart-tooltip content.

---

## Brand > Stories big-number tiles — bar + Pie/donut hover (QA-949, verified 2026-07-02)

Same D3-SVG stack as Insights. Verified on Michael Kors (brand 3801), Instagram, Insights data set.

- **Big-number bars:** `rect.bar` with class `bar <metric-key>-<YYYY-MM-DD>`, e.g. `bar instagram.story_insight.engagements-2026-06-26`. The metric key uses **dots** (`instagram.story_insight.impressions`), so match on the full `getAttribute('class')` string rather than a CSS class selector. Pick a **non-zero-height** bar. `browser_hover` it → tooltip at `[class*=tooltip]` reads `MMM. DD, YYYY` + `Instagram: <value> (±%)` (e.g. `Jun. 26, 2026 Instagram: 528 (+999.0%)`). All four Stories tiles (Engagements / Impressions / Taps Back / Exits) hover identically.
- **Switch a tile to Pie:** open the tile's graph-type selector `.tile-level-data-viz-buttton-container .selector-dropdown-container` (label shows current type e.g. "Bar"), then click the `.list-item` option (Area / Bar / Line / **Pie** / Table).
- **Pie/donut hover — pointer interception gotcha:** the chart is a `svg.donut` with arc `path.arc` (also `path[data-datapoint]`). `browser_hover` on the arc **times out** because the parent `svg.donut` "intercepts pointer events" and the arc's bbox-center is the donut hole. Workaround: dispatch `mouseover`+`mousemove` **on the arc path** with a `clientX/clientY` on the ring (donut center ± ~radius 64), then read `[class*=tooltip]`. Tooltip = `Instagram: <value>` (e.g. `Instagram: 233,698`) — no date line for pie. (This is the one place synthetic mouse events DO work for the tooltip.)

## Legacy (Chrome MCP / Recharts) — historical, superseded 2026-06-22

The notes below assume Chrome MCP + Recharts and are kept for history. Do not use the
synthetic-event dispatch or `.recharts-*` selectors under Playwright MCP.

Native Chrome MCP `hover` was hit-or-miss on chart elements because:
1. Recharts/D3 charts use SVG paths, not block-level elements — hover events bubble inconsistently.
2. MCP's `hover` action dispatches a single `mouseover` but Recharts often needs both `mousemove` AND `mouseover` to render its tooltip.
3. Zero-data charts have no datapoints to hover.

## Steps

### Step 1 — Identify the chart and the target datapoint
- **Selector path:** `.tile-container` (or similar) → `svg.recharts-surface` (or `.chart-container`) → individual datapoint shape (rect, circle, path).
- Use `read_page` or `find` to get the chart's element ref; or compute coordinates directly from the SVG.

### Step 2 — Dispatch mousemove + mouseover events
```javascript
(function(chartSelector, dataPointIndex){
  const chart = document.querySelector(chartSelector);
  const points = chart.querySelectorAll('.recharts-rectangle, .recharts-dot, .recharts-pie-sector');
  const target = points[dataPointIndex];
  if (!target) return "no datapoint at index " + dataPointIndex;
  
  const rect = target.getBoundingClientRect();
  const cx = rect.left + rect.width / 2;
  const cy = rect.top + rect.height / 2;
  
  // Dispatch the full hover sequence Recharts expects
  ['mouseover', 'mousemove', 'mouseenter'].forEach(type => {
    target.dispatchEvent(new MouseEvent(type, {
      bubbles: true,
      clientX: cx,
      clientY: cy,
      view: window
    }));
  });
  
  return JSON.stringify({cx: Math.round(cx), cy: Math.round(cy)});
})('.tile-fan-growth-rate svg', 3)
```

### Step 3 — Wait for tooltip to render, then read its text
```javascript
(async function(){
  await new Promise(r => setTimeout(r, 300));
  const tooltip = document.querySelector('.recharts-tooltip-wrapper');
  if (!tooltip) return "no tooltip rendered";
  return tooltip.textContent.trim();
})()
```

### Step 4 — Assert tooltip format
For Brand > Insights tiles, the expected formats per QA-96670:

| Chart type | Expected tooltip format |
|---|---|
| Bar (e.g. New Posts) | `Mon. DD, YYYY` / `<icon> <channel name>: value` |
| Area (e.g. Views) | `MMM.DD,YYYY : Value` / `<icon> <channel name>: value` |
| Pie (e.g. New Posts pie variant) | `<icon> Threads: value` (single channel) |

Parse the captured text and compare component-by-component.

### Step 5 — Dispatch mouseleave to clean up
```javascript
const target = /* same as step 2 */;
target.dispatchEvent(new MouseEvent('mouseleave', {bubbles: true}));
```

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| `.recharts-tooltip-wrapper` not found after dispatch | Hover sequence didn't trigger Recharts handler | Try a different event sequence (e.g. `pointermove` for newer Recharts) |
| Tooltip text empty | Datapoint is at value 0 | Skip — pick a non-zero datapoint |
| Tooltip format doesn't match expected | Regression OR test spec needs update | Capture exact actual text |
| `points.length === 0` | Chart has no data | Document data gap (see QA-96670 on HBO Max Threads) |

## Selector cheatsheet

| Chart element class | Notes |
|---|---|
| `.recharts-rectangle` | Bar chart bars |
| `.recharts-dot` | Line/area chart points |
| `.recharts-pie-sector` | Pie slices |
| `.recharts-tooltip-wrapper` | The tooltip container |
| `.recharts-default-tooltip` | Default tooltip styling |

## Known bug history

See `knowledge-base/bug-history.md` for the full per-ticket bug list. Highest-priority open bugs currently tied to this skill's flows:

- LFMP-31781 (Minor) — Brand Insights - Hovering Functionality - twitter icon color is blue     [from QA-1124]

## 2026-07-02 QA-1124 reconfirm (Hulu Brand>Insights Public, 30-day) — full 7-chart + Aggregate sweep

Verified `.chart-tooltip` for bars (Follower Growth / New Posts / Engagements = `Mon. DD, YYYY` + per-channel `Channel: value (±%)`), rate bars (Response Rate / Fan Growth Rate = `date` + `<Metric>: X%`), Views **area** (`date` + `Twitter: value` — Views is Twitter-only for Public), and the Total Followers **donut** (`.al-donut__tooltip` reachable by dispatching `mouseover/mousemove` on the `path[data-datapoint*=facebook]` at its bbox center → `Facebook: 6,205,450 / …`). **Data Visualization dropdown** → options `.option__row`: `Data View: Count/Share`, `Channel View: Channel/Aggregate`; selecting **Channel View: Aggregate** collapses charts to a single series (Views tooltip → `date` + `Views: <value>`, no channel split). Note: the aggregate video-views tooltip is labeled **"Views"**, not "Public Video Views" (spec's older wording). The Public/Authorized **perspective toggle swaps the brand entity id** (Authorized 5670 → Public 11003 for Hulu) — same brand.

## Changelog
- **v3** (2026-07-02): Added Brand > Stories big-number bar hover (`rect.bar` metric-key-with-dots) + Pie/donut hover with the `svg.donut` pointer-interception workaround (dispatch mouse events on the arc path at a ring coordinate). Tile graph-type selector `.tile-level-data-viz-buttton-container`. Verified QA-949 (Michael Kors IG). +1 streak.
- **v4** (2026-07-15, QA-109749, NFL on CBS brand_id=55123, Threads channel, Apr 1-5 2025): Brand>Audience
  geo/donut tiles.
  - **Country choropleth hover:** `.datamaps-subunit.<ISO3>` (e.g. `.USA`) — this is the **datamaps**
    library, not the same D3 setup as Brand>Insights. A country's DOM bbox center can be wrong for
    non-compact shapes (USA's combined bbox with Alaska centers over Canada) — scan
    `document.elementFromPoint` over a grid within the tile and pick a hit away from small outlying
    parts, rather than trusting `getBoundingClientRect()` center. Tooltip: `.al-geo-map-tooltip__container`
    → `<Country>Followers <N>%` (matches spec's `Legend: Country / Followers (N%)` format).
  - **City bubble hover:** `circle.datamaps-bubble` (radius scales with follower share). Same tooltip
    class as country. **Format finding:** tooltip renders `<City>, <State/Region>` (e.g. `Philadelphia,
    Pennsylvania`; `Lagos, Lagos State`) — **not** `<City>, <Country>` as QA-109749's spec literally
    describes. Reproduced on 2 unrelated cities (US + Nigeria), so it's a systematic product format
    choice, not a data gap — noted as a spec-vs-actual format finding in the report, not filed as a
    functional bug (the geographic info shown is arguably more precise, just doesn't match the spec's
    exact wording).
  - **Multiple tooltip container instances coexist in the DOM** — one per tile — with only the
    currently-hovered one having `offsetParent !== null`. Always filter for `visible`/`offsetParent`
    before reading `textContent`, or you'll read a stale value from a previously-hovered tile.
  - **Gender-breakdown donut** (`Followers: Gender Breakdown`) uses fixed fill colors `#AA00FF` (Men),
    `#007F77` (Women), `rgb(165,165,165)` (Unknown) — same donut-hole-miss issue as v3's pie/donut
    finding; hovering `rect.y + 8` (top-of-arc offset) rather than the vertical center works reliably.
    Tooltip: `Men: N% Women: N% Unknown: N%` (exact spec format match).
- **v3** (2026-07-07, QA-96670 re-run, HBO Max brand_id=155614): Two new Playwright-only gotchas for
  donut/pie big-number tiles:
  - **Pie/donut hover needs scroll-stable, ring-offset coordinates.** `browser_hover`'s built-in
    actionability check hit-tests the shape's bounding-box *center*, which for a ring (donut hole)
    lands on empty space and reports "parent svg intercepts pointer events" — a false timeout, not a
    real occlusion. Coordinate-based `page.mouse.move` also silently misses if the page's horizontal
    scroll shifts between a `getBoundingClientRect()` read and the move (each separate tool call can
    re-scroll). Fix: do the rect-read + `mouse.move` in **one** `browser_run_code_unsafe` script, and
    target a point offset from the arc's own bbox toward the outer edge (`top + 5px`), not the
    geometric center.
  - **The chart-type dropdown has no static "Graph Type" label** — it displays the *current*
    selection (`Bar`, `Area`, `Pie`, ...), so text-searching for "Graph Type" finds nothing. Locate it
    via `data-ui-name="tile_data_visualization"` or by proximity to the tile's `<h4>` heading.
  - Bar/area hover confirmed still trivial (`browser_hover` + read `.chart-tooltip__container` /
    `.al-area-chart__tooltip` directly — no coordinate math needed for non-ring shapes).
- **v2** (2026-06-22): Playwright MCP rewrite. Confirmed Insights charts are **D3 SVG, not Recharts**
  (`rect.bar.<channel>-<date>`, `.arc` donut). `browser_hover` triggers the tooltip natively (no
  synthetic events); tooltip is DOM-readable at `.al-bar-chart__tooltip` (no screenshot needed).
  Verified end-to-end on HBO Max (brand 155614). "Insights renderer hang" re-diagnosed as
  invalid/missing compare dates. Legacy Recharts content demoted to a historical section.
- **v1** (2026-05-18): Initial scaffold from QA-96670 hover-test deferral. Not yet executed end-to-end (HBO Max Threads had no data).

## 2026-06-11 batch-3 update (QA-96670 Threads, HBO Max Sep 2025)

- Insights big-number tooltips verified Threads-only: bar `Sep. 12, 2025` + `Threads: 1 (0.0%)`; Views area `Threads: 194,857 (+999.0%)`; Pie (after graph-type switch) `Threads: 70` — all include the channel icon. Real `computer.hover` works; synthetic mouse events do NOT trigger these tooltips, and the tooltip div may not match `[class*=tooltip]` queries — verify via screenshot.
- Graph-type dropdown options on big numbers: Area, Bar, Line, Pie, Table. FGR/New Posts default Bar; Views default Area.
- Account/brand drift: test says "Max" — dev account+brand are "HBO Max" (brand 155614). Current-week Threads data was zero; used Sep 2025.
