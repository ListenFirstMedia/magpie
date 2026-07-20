# QA-51442 — Brand > Stories - Impressions tile - Export PNG — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand:** MTV (brand_id 4018) · **Channel:** Instagram · **Window:** Jun 9–15 2026 · **Data Last Updated (PT):** 06-16-2026 09:26 AM
- **Skills:** brand-stories-nav, tile-png-export-verify (blob)
- **Result:** ⛔ BLOCKED — Chrome-MCP tile-render artifact (not a confirmed app defect)

## Steps
1. Brand > Stories for MTV / Instagram, window Jun 9–15 2026 (reached via fresh tab after MTV Brand>Insights renderer hang — see Notes).
2. Trend tiles (Engagements, **Impressions**, Taps Back, Exits) all displayed **"This tile failed to load. Please try again."** with RELOAD.
3. Clicked RELOAD on the Impressions tile → chart container entered skeleton (grey bar placeholders) and never completed rendering.
4. Full-page reload (sorted by Impressions) → all 4 tiles again "failed to load".
5. Installed `URL.createObjectURL` blob hook; opened the Impressions tile **Export ▾** → menu shows **PNG / CSV / Google Sheets / Metrics**; clicked **PNG**.
6. No blob captured (`{captured:false}`); no download fired; console showed only `renderGrid complete` + AsyncPoller polling, no export error.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Impressions tile renders | Bar/line chart of IG story Impressions | Tile stuck on "failed to load" / skeleton across 3 attempts | ⛔ (MCP artifact) |
| PNG export option present | Tile Export menu offers PNG | **PNG present** (PNG/CSV/Google Sheets/Metrics) | ✅ |
| PNG file produced & valid | A valid PNG (`89504e47`) downloads | No blob produced — chart never rendered, nothing to rasterize | ⛔ not observable |
| Underlying data present | Impressions data exists for window | Table **Sum Impressions 1,248,958** (Avg 48,037) over **26 IG stories** | ✅ |

## Notes / automation learning
- The four Brand>Stories **trend tiles consistently fail to render their charts under Chrome MCP** (CDP) in this session — identical to the prior-run Brand>Stories tile-fail that was **retracted as a Chrome-MCP rendering artifact** (the data table renders perfectly; only the chart canvases stall). The tile-level **PNG export depends on the rendered chart**, so it can't be captured while the tile is in the failed/skeleton state. This is an automation-environment limit, **not a confirmed product bug**.
- Distinct from the **Brand>Insights / Brand>Video renderer hang** (which froze the whole CDP pipeline on the first MTV Insights load this run and required a fresh tab) — here the page stays responsive; only the Stories trend-tile charts don't paint.
- Recommendation: verify QA-51442 manually (real browser) or via a non-CDP capture; the PNG menu entry and the data layer are both confirmed healthy.

## Bugs filed
_None (env/automation-artifact, not a product defect)._
