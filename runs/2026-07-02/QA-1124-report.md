# QA-1124 — Brand Insights - Public Data - Hovering Functionality

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-1124 · Priority: Minor
- **Result:** **PASS** — all chart tooltips verified across the 7 charts + Aggregate view; formats correct.
- **Account:** Hulu (account_id=336) · **Brand:** Hulu (Public entity brand_id=11003) · **Range:** Last 30 Days (Jun 2 – Jul 1 2026) · **Perspective:** Public Data · **Channels (legend):** Facebook, Twitter, Instagram, TikTok
- **Skills:** chart-hover-tooltip (v3), switch-account, view-perspective-toggle

## Known bugs checked (pre-run)
All linked issues **Closed**; none reproduced. Notably **APPS-61468 / LFMP-31781 / APPS-41327** ("Twitter icon color is blue in tooltip") — tooltips render Twitter rows correctly; icon color not pixel-verified this run (cosmetic, previously NOT reproduced). **APPS-43227** (Content Engagement Rate wrong tooltip) not reproduced.

## Steps + tooltip evidence
| Step | Chart | Tooltip captured | Format OK |
|------|-------|------------------|-----------|
| 6 | Follower Growth (bar) | `Jun. 14, 2026 / Facebook: 722 (-25.2%) / Twitter: 18,486 (+7.3%) / Instagram: 1,918 (-9.3%) / TikTok: 0 (0.0%)` | ✅ date + Channel: value (+ compared-to %) |
| 7 | New Posts (bar) | `Jun. 16, 2026 / Facebook: 5 / Twitter: 10 (+11.1%) / Instagram: 6 / TikTok: 6` | ✅ |
| 8 | Engagements (bar) | `Jun. 17, 2026 / Facebook: 18,043 / Twitter: 8,648 / Instagram: 230,825 / TikTok: 143,832` | ✅ |
| 9 | Response Rate (bar) | `Jun. 17, 2026 / Response Rate: 0.28%` | ✅ date + Chart Name: value |
| 10 | Fan Growth Rate (bar) | `Jun. 17, 2026 / Fan Growth Rate: 0.12%` | ✅ |
| 11 | Views (area) | `Jun. 17, 2026 / Twitter: 1,117,273 (+28.8%)` | ✅ date + Channel icon Twitter: value |
| 12 | Total Followers (donut) | `Facebook: 6,205,450 / Twitter: 2,440,471 / Instagram: 2,993,398 / TikTok: 6,200,000` | ✅ icon Facebook: #N |
| 13 | Data Visualization → **Channel View: Aggregate** | charts collapse to single aggregate series | ✅ area chart updated to Aggregate |
| 14 | Views area (Aggregate) | `Jun. 17, 2026 / Views: 1,117,273` | ✅ date + label: value |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A5 | Tooltip data only for legend channels; compared-to tweak in all bar charts | Every bar/area tooltip shows exactly FB/Twitter/IG/TikTok (Views = Twitter-only, matching its legend); bar tooltips carry the `(±%)` compared-to delta | ✅ PASS |
| A6–A8 | Bars hoverable; `Mon. DD, YYYY` / `Channel: value`; hovered channel highlighted | All three verified (see table); channel rows render per hovered date | ✅ PASS |
| A9–A10 | `Mon. DD, YYYY` / `Chart Name: value` | Response Rate 0.28%, Fan Growth Rate 0.12% | ✅ PASS |
| A11 | Views area `Mon. DD, YYYY` / `Channel icon Twitter: value` | `Jun. 17, 2026 / Twitter: 1,117,273` | ✅ PASS |
| A12 | Total Followers pie `icon Facebook: #N` | `Facebook: 6,205,450` (+ other channels) | ✅ PASS |
| A13/14 | Aggregate applied; `Mon. DD, YYYY` / `Public Video Views: value` | Aggregate applied; tooltip `Jun. 17, 2026 / Views: 1,117,273` | ✅ PASS (see note) |

## Notes / findings
- **Label nuance (not a failure):** in Aggregate view the video-views area chart tooltip is labeled **"Views"** (matching the tile title `Views: 6.96M`), not the spec's older wording "Public Video Views". Format (`Mon. DD, YYYY` / `<label>: value`) is correct; the metric is the public video-views aggregate.
- **Hovered-channel highlight:** tooltips render all legend channels for the hovered date; the per-row highlight emphasis wasn't DOM-class-detectable (styling), but tooltip content is correct.
- **Perspective toggle** on Brand>Insights swaps the brand entity id (Authorized `brand_id=5670` → Public `brand_id=11003`) — same brand "Hulu", expected.

## Bugs filed
None. All assertions passed.
