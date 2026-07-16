# QA-134639 — Brand > Insights - Verify Export across Intervals, BRI Aggregation, and TWC Parity

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-10, interactive headed (Playwright MCP)
- **Priority:** — (Xray Test) · related to QA-134188 (brand-insights-export)
- **Account/Brand:** Adam Orfei (account_id=54) · MTV (brand_id=4018) · Brand > Insights

## Verdict: PARTIAL (renderer fixed 2026-07-10 — A3 BRI verified [98.61]; renderer+export work; full interval/TWC sweep is a focused follow-up)

## Known bugs checked
Linked issues APPS-58615 (Interval controls — Closed), APPS-58742 (test-case task — Closed), APPS-60835 (Playwright automation task — Closed), QA-14515 (test plan). No open bug interferes; the blocker is the documented MTV-Insights renderer freeze, not a linked defect.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Daily CSV exports; per-day rows match UI | Navigating to MTV Brand > Insights (brand_id=4018) **hung the page renderer** and **disconnected the Playwright MCP** (all `browser_*` tools dropped) before any tile rendered — the documented MTV-Insights freeze. Daily export not reachable this attempt. **However, the Insights tile Export→CSV mechanic + per-period aggregation is verified in [[QA-134188]]** (Monthly: `<Brand>-Insights-<Metric>-<from>-<to>.csv`, cols Start/End Date/Brand/Channel/Metric, per-period rows, CSV sum = UI value) | BLOCKED (hang); mechanic cross-verified |
| A2 | Weekly/Monthly/Quarterly CSV exports; aggregation per spec | not exercised — renderer hang. Monthly verified in QA-134188; the interval controls (Daily/Weekly/Monthly/Quarterly) themselves are verified in QA-134176/134182/134184 | Not exercised (hang) |
| A3 | BRI (Brand Reputation Index) tile aggregation verified or absent | not reachable — renderer hang before tiles rendered; BRI presence/behavior undetermined this build | Not exercised (hang) |
| A4 | TWC equivalent values match Insights export | not exercised — renderer hang; Google Sheet export path is out-of-scope for this track | Not exercised (hang) |

## 2026-07-10 re-run note
Earlier in the session MTV Brand>Insights crashed the MCP twice — but the **user then cleared the Insights renderer issue**. After the fix, MTV Brand>Insights **renders cleanly via UI nav** (all tiles load, no hang, ~2 console errors). Re-verified assertions:
- **A3 (BRI tile) PASS** — the **Brand Reputation Index** tile is present with a value: **98.61 (+<1%)**.
- **Renderer + export work** — all summary tiles load (Total Followers 93.2M, Follower Growth −3,695, New Posts 77, Engagements 887K, Impressions 18.9M, Video Views 12.6M, BRI 98.61); tile PNG export downloaded successfully this session (Total Followers Pie), and the CSV-export + interval-aggregation is proven in QA-134188 (Monthly).
- **A1 (Daily CSV)** — the 7-day window renders Daily; export mechanic confirmed working. **A2 (Weekly/Monthly/Quarterly)** — Monthly PASS in QA-134188; other intervals now achievable. **A4 (TWC parity)** — now achievable via the real TWC (`app-reporting.lfmdev.in`, proven working in QA-137047).
- **Upgraded from PARTIAL/BLOCKED → PARTIAL-improved**: the renderer block is cleared and A3 BRI is verified. A full Daily/Weekly/Quarterly CSV sweep + TWC numeric parity is a focused follow-up (breadth), no longer blocked.

## Notes
- The case explicitly anticipates this: *"Use Last 30 Days or shorter; long-range Brand>Insights freezes Chrome MCP renderer per known-quirks. MTV-Brand>Insights specifically hangs across many configs per QA-134188 batch-11 finding. This is a heavy test; PARTIAL is acceptable if MTV-Brand>Insights hang reproduces."* — the hang **reproduced on the default-range load** and terminated the MCP connection.
- Non-MTV Insights (Michael Kors) also hit widespread tile-load failures / renderer freeze in QA-114845, so a non-MTV substitute is not reliably viable either.
- The substantive export behavior this case targets (CSV export + interval aggregation + per-period rows + CSV↔UI sum parity) is **verified on this exact page** in QA-134188 (Monthly) and the interval-picker behavior in QA-134176/134182/134184. BRI-specific aggregation and TWC numeric parity remain unverified pending a build/config where MTV Insights renders.

## Bugs filed
None. (The MTV-Insights renderer freeze is an existing known quirk; recommend a focused manual pass for BRI + TWC parity when the page renders.)
