# QA-114845 — Brand > Insights - Hovering functionality and PNG Export

- **Run:** 2026-07-12 (unattended, headless Playwright MCP, `feature/playwright-mcp`)
- **Verdict:** **PASS (5/5)**
- **Skills used:** `chart-hover-tooltip`, `audience-metrics-export` (+ `brand-insights-interval-picker` for Last-30-Days, `switch-account`/brand-picker Rule 1)
- **Environment:** app.lfmdev.in, logged in as lfiqa@listenfirstmedia.com; Account: Adam Orfei (54)
- **Brand:** Michael Kors (brand_id=3801) — exact typeahead Results match (Rule 1)
- **Date window:** Last 30 Days = **Jun 11, 2026 – Jul 10, 2026** (compare May 12 – Jun 10); set via Date Range → "Make a Selection" per case note to avoid the Insights renderer-freeze
- **View:** Authorized Data; Channels: Facebook, Twitter, Instagram, TikTok (default)

## Steps executed

1. Top nav **Brand → Insights** (menu link, trusted click) → landed on Brand Insights, brand_id=3801.
2. Opened the brand selector chevron → typed **"Michael Kors"** → clicked the exact-match **Michael Kors** row under Results (Rule 1). Then set Date Range → **Last 30 Days** (Jun 11 – Jul 10, 2026). Tiles rendered cleanly under Playwright (no freeze).
3. Hovered the **Total Followers** donut (svg.donut arc, ring-coordinate mouseover dispatch — the svg intercepts pointer events per known-quirk).
4. **Total Followers** tile → Export ▾ → **PNG** (synchronous Playwright download).
5. Hovered the **Fan Growth Rate** bar (trusted hover on `rect.bar` for 2026-06-15, the tallest bar).
6. **Fan Growth Rate** tile → Export ▾ → **PNG** (synchronous Playwright download).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A3 | 3 | Tooltip displays as "Channel name: value" | `.al-donut__tooltip`: **Facebook: 18,690,949 / Twitter: 2,893,932 / Instagram: 18,980,714 / TikTok: 2,100,000** — exact "Channel: value" format per line | **PASS** |
| A4a | 4 | Filename `Brand-Tab-Tile-Pie-YYYY-MM-DD(Start)-YYYY-MM-DD(End).png` | Download event name **`Michael Kors-Insights-Total Followers-Pie-2026-06-11-2026-07-10.png`** (on disk slugified to `Michael-Kors-...`, 32,640 bytes) | **PASS** |
| A4b | 4 | PNG matches the page | PNG shows LISTENFIRST logo, "Michael Kors", "Total Followers", FB/Twitter/IG/TikTok legend, donut **42.7M** center with **18.7M / 2.89M / 19M** slices, footer "Brand Insights · Date: Jun. 11, 2026-Jul. 10, 2026" — matches on-page tile | **PASS** |
| A5 | 5 | Values `Mon. DD, YYYY` + `Fan Growth Rate: value` | `.al-bar-chart__tooltip`: **"Jun. 15, 2026"** + **"Fan Growth Rate: -0.01%"** — exact format | **PASS** |
| A6 | 6 | Filename `Brand-Tab-Tile-Bar-YYYY-MM-DD(Start)-YYYY-MM-DD(End).png` | Download event name **`Michael Kors-Insights-Fan Growth Rate-Bar-2026-06-11-2026-07-10.png`** (on disk `Michael-Kors-...`, 50,429 bytes); PNG renders 30 daily bars + Compared To legend + footer date range | **PASS** |

## Evidence

- `.playwright-out/QA-114845/01-insights-landing.png` — Insights landing (Last 7 Days pre-adjust)
- `.playwright-out/QA-114845/02-datepicker.png` — Date Range picker (Make a Selection / dual calendars)
- `.playwright-out/QA-114845/03-30day-tiles.png` — tiles after Last 30 Days (Jun 11 – Jul 10)
- `.playwright-out/QA-114845/04-A3-donut-tooltip.png` — Total Followers donut hover
- `.playwright-out/QA-114845/05-A5-fgr-tooltip.png` — Fan Growth Rate bar hover
- `.playwright-out/Michael-Kors-Insights-Total Followers-Pie-2026-06-11-2026-07-10.png` — A4 export (verified end-to-end via Read render)
- `.playwright-out/Michael-Kors-Insights-Fan Growth Rate-Bar-2026-06-11-2026-07-10.png` — A6 export (verified end-to-end via Read render)

Notes on filename verification (Rule 6): the on-disk artifacts are slugified by Playwright (spaces → `-`); the authoritative server-emitted names are read from the Playwright `download` events and are quoted above (they carry the spec-format spaces and match A4a/A6 exactly). Both PNGs were opened and visually confirmed to match their tiles.

## Known bugs checked

- **Open linked bugs (Rule 7):** case file has no "## Open linked bugs" section; `bug-history.md` QA-114845 → **Open bugs (0)**. Screen passed → ran the case.
- **Brand>Insights renderer freeze** (known-quirk, Chrome-MCP era): did **NOT** reproduce under Playwright. Tiles rendered fast at both Last 7 Days and Last 30 Days. Consistent with the 2026-06-22 finding that the "hang" was a missing-compare-dates artifact, not a perf freeze. Last-30-Days window used per case note anyway.
- No new defects observed.

## Bugs filed

None.
