---
name: brand-content-tile-hover
version: 1
last_verified: 2026-07-15
last_passed_run: 2026-07-15
trust: untrusted
pass_streak: 1
preconditions: [insights-toggle-checked, channel-has-nonzero-data-in-window]
postconditions: [tooltip-text-captured]
inputs: [channel, tile_section]
outputs: [tooltip_text]
related_pages: ["/#explore/brand/content"]
---

# Brand > Content — Insights tile hover (Performance by Channel / Content Insights)

Covers hovering the donut/bar tiles that appear on **Brand > Content** when the page-local
**Insights** dropdown (next to Tag/Export, top-right of the filter bar) has **All Insights** (or
the individual **Performance by Channel** / **Content Insights** checkboxes) checked. This is a
different widget family from the Brand > Insights big-number tiles covered by
`chart-hover-tooltip` — different tooltip class, different selector scoping.

## Steps

### Step 1 — Reveal the tiles
- **Action:** click the **Insights** dropdown button (next to Tag/Export) → check **All Insights**
  (`#check-box_all-insights`), or the individual Performance by Channel / Content Insights
  checkboxes.
- **Assertion:** a `Performance by Channel` heading + 3 tiles (New Posts, Engagements, Engagement
  Rate) render above the Posts table; scrolling further reveals `Content Insights` → `Performance
  by Type` (stacked bar by post type) and `Performance by Tag` (bar by applied tag, empty if no
  tags applied).

### Step 2 — Dismiss the status.io outage banner if present
- The `status.listenfirstmedia.com` embed (`iframe[src*=statuspage.io]`) renders an orange outage
  banner that can visually and pointer-overlap the first tile in the row (esp. "New Posts") and
  silently swallow hover events aimed at it (`NO TOOLTIP` with no error). It is a **cross-origin
  iframe** — cannot reach into it via `page.evaluate`'s `document`; use Playwright's frame API:
  ```js
  const frames = page.frames();
  for (const f of frames) {
    const hasOutage = (await f.locator('body').innerText().catch(()=>'')).includes('Outage');
    if (hasOutage) {
      for (const c of await f.locator('button').all()) await c.click({force:true}).catch(()=>{});
    }
  }
  ```

### Step 3 — Locate the per-channel donut arc (Performance by Channel tiles)
- Each tile's outer boundary is `.tile--channel-display` (NOT a blind `parentElement` climb — an
  8-level climb overshoots into `.grid-tiles`, the container for ALL 3 tiles in the row, and
  `.querySelectorAll('.arc')` then silently returns the WRONG tile's arc). Scope with:
  ```js
  const tile = Array.from(document.querySelectorAll('.tile--channel-display'))
    .find(t => t.querySelector('h4')?.textContent.trim() === 'New Posts'); // or Engagements / Engagement Rate
  ```
- Channel fill-color map (consistent across all donut/bar tiles on this page):
  Facebook `#4267B2`, Twitter/X `#1DA1F2`, Instagram `#833AB4`, TikTok `#69C9D0`, LinkedIn (no
  fixed color observed — renders `–`/0 on brands with no LinkedIn data), **Threads `#1C1E21`**
  (black).
- Tag the target arc's `<path>` via `data-spk` attribute, read `getBoundingClientRect()`, hover its
  centroid (`x + w/2, y + h/2`). Unlike the Insights-page donuts, centering worked fine here (no
  donut-hole miss) — these arcs are wide enough. Two small `mouse.move` calls (a few px apart) are
  more reliable than one, to force a `mousemove` after the initial `mouseover`.

### Step 4 — Read the tooltip
- Selector: **`.chart-tooltip__container`** (full class chain:
  `.al-donut__tooltip > .app-lib.chart-tooltip.chart-tooltip > .chart-tooltip__container`). This
  is **different** from the `.al-bar-chart__tooltip` / `.al-area-chart__tooltip` selectors
  documented for Brand > Insights in `chart-hover-tooltip` — do not assume they're interchangeable
  across page families.
- The tooltip is **shared/global per tile**, not per-arc: hovering ANY channel's arc in a donut (or
  any point on a stacked bar) renders ALL channels' values in one tooltip, e.g.
  `Facebook: 234,907 Twitter: 121,631 Instagram: 966,556 TikTok: 115,134 LinkedIn: 0 Threads: 681`.
  You don't need per-channel precision hovering as a result — hovering anywhere on the shape reads
  the full breakdown, including the target channel's row.

### Step 5 — Content Insights (Performance by Type) stacked bars
- Structurally a stacked bar chart, not a donut: `rect[fill="#1C1E21"]` inside the tile container
  (`.closest('.tile')` off the `Performance by Type` heading text node).
- **A channel with a very small share renders its stacked segment at `height: 0`** (confirmed:
  Threads at 681 of a 814,138-total Gallery bar) — there is nothing pixel-addressable to hover for
  that channel specifically. This is a real, expected charting constraint (proportional stacking),
  **not a bug** — don't file "channel segment not hoverable" for a low-magnitude channel. Instead
  hover anywhere on the visible bar (e.g. the dominant channel's segment); the shared tooltip (Step
  4) still surfaces the small channel's exact value in its row.

## Cross-verification (Rule — match tooltip to table)

Every tile has a companion data table directly below it (`.al-table--performance-by-channel` for
Performance by Channel; a similar rank/tag table for Content Insights). The tooltip text must match
the table's Sum row for the hovered metric — this is the actual assertion in specs like QA-99531,
not just "does a tooltip appear." Compare component-by-component (channel name → value).

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| `NO TOOLTIP` and the point falls under the statuspage.io outage banner | banner is intercepting the hover, not a product bug | dismiss banner (Step 2), retry |
| `NO TOOLTIP` on a tile whose target channel's arc/segment `getBoundingClientRect().height/width === 0` | value too small to render a hoverable shape at this scale | hover the tile generally — shared tooltip (Step 4) still has the row |
| Tooltip text present but doesn't match the table Sum row | genuine data-parity bug | re-verify with a screenshot, then file |
| Wrong tile's data comes back (e.g. "New Posts" hover shows Engagement-Rate percentages) | scoping bug in your own script (blind ancestor climb), not a product defect | rescope with `.tile--channel-display` per Step 3 |

## Changelog
- **v1** (2026-07-15, QA-99531, MTV brand_id=4018, Threads channel, Mar 16–22 2025 window):
  initial scaffold. All 3 Performance-by-Channel tiles (New Posts=2, Engagements=681, Engagement
  Rate=1.81%) and the Content Insights Performance-by-Type tile (Gallery Threads=681) hover-verified
  and cross-checked against their data tables — exact match, no discrepancy.
