# QA-1124 — Brand Insights - Public Data - Hovering Functionality

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-1124
- **Run date:** 2026-05-20
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Hulu (brand_id=5670, account_id=336)
- **Priority:** P4 (Minor)
- **Result:** ⚠ **DEFERRED — Chrome renderer freeze on Hulu Brand Insights page**

## Status: Deferred (browser environment issue)

Tried twice with a fresh Chrome restart in between. The Hulu Brand Insights page at `/#explore/brand/insights?brand_id=5670&account_id=336&from=2026-04-19&to=2026-05-18` reliably freezes the Chrome MCP renderer.

### Specific failure
After page initially renders (we got one screenshot showing Hulu header, Apr 19 - May 18 2026 date range, View: Authorized Data, channel selector, and skeleton placeholders for charts), all subsequent MCP operations time out:
- `screenshot` → tool did not respond in time
- `left_click` → tool did not respond in time
- `javascript_exec document.title` → `CDP sendCommand "Runtime.evaluate" timed out after 45000ms — renderer may be frozen`

The freeze appears to happen during chart rendering. Brand Insights loads 7+ heavy charts (stacked bars, area, pie) plus aggregated channel data, which may overwhelm the renderer on dev infra.

## What was verified before freeze
- Account: Hulu ✓
- Brand: Hulu (auto-resolved from brand_id=5670) ✓
- Date Range: Apr. 19, 2026 - May. 18, 2026 (30 days per Step 4) ✓
- View toggle in default state: Authorized Data (slider on right) — needed to click toggle for Step 5
- Channel selector visible
- Data Visualization dropdown visible top-right
- Charts area was loading (skeleton placeholders) when freeze occurred

## Steps NOT completed
- Step 5: Click View Toggle to Public Data
- Steps 6-12: Hover 7 charts (Follower Growth, New posts, Engagements, Response Rate, Fan Growth Rate, Views, Total Followers)
- Step 13: Data Visualization → Channel View: Aggregate
- Step 14: Hover Public Video Views area chart

## Assertions
All 13 assertions (A1-A13) require hovering charts → **all DEFERRED**.

## Recommendation
- **LFIQA manual run:** Page renders fine in normal Chrome browsing. LFIQA should hover each chart and confirm tooltip format matches spec (`Mon. DD, YYYY` + `Channel names: Values` / `Chart Name: Values`).
- **Dev-perf bug?** Worth checking why Chrome renderer freezes during Hulu Brand Insights chart load. May be a perf regression on dev or specific to brand_id=5670. Other brands may not freeze.

## Bugs filed
None (cannot reliably attribute the freeze to a product defect vs. MCP/dev env quirk).
