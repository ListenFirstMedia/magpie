---
name: chart-hover-tooltip
version: 1
last_verified: 2026-05-18
last_passed_run: null
trust: untrusted
pass_streak: 0
preconditions: [chart-rendered-with-data]
postconditions: [tooltip-text-captured]
inputs: [chart_type, datapoint_index]
outputs: [tooltip_text]
related_pages: ["/#explore/brand/insights", "/#explore/brand/audience"]
---

# Chart Hover Tooltip — JS Workaround

Native Chrome MCP `hover` is hit-or-miss on chart elements because:
1. Recharts/D3 charts use SVG paths, not block-level elements — hover events bubble inconsistently.
2. MCP's `hover` action dispatches a single `mouseover` but Recharts often needs both `mousemove` AND `mouseover` to render its tooltip.
3. Zero-data charts have no datapoints to hover.

This skill documents the JS-based workaround that reliably triggers and captures tooltip content.

Used by:
- **QA-96670** — Brand Insights Threads chart hovers (deferred this session).
- Any test that asserts on chart-tooltip content (bar tooltip, area tooltip, pie tooltip).

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

## Changelog
- **v1** (2026-05-18): Initial scaffold from QA-96670 hover-test deferral. Not yet executed end-to-end (HBO Max Threads had no data).

## 2026-06-11 batch-3 update (QA-96670 Threads, HBO Max Sep 2025)

- Insights big-number tooltips verified Threads-only: bar `Sep. 12, 2025` + `Threads: 1 (0.0%)`; Views area `Threads: 194,857 (+999.0%)`; Pie (after graph-type switch) `Threads: 70` — all include the channel icon. Real `computer.hover` works; synthetic mouse events do NOT trigger these tooltips, and the tooltip div may not match `[class*=tooltip]` queries — verify via screenshot.
- Graph-type dropdown options on big numbers: Area, Bar, Line, Pie, Table. FGR/New Posts default Bar; Views default Area.
- Account/brand drift: test says "Max" — dev account+brand are "HBO Max" (brand 155614). Current-week Threads data was zero; used Sep 2025.
