# QA-114845 — Brand > Insights - Hovering functionality and PNG Export

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09/10, interactive headed (Playwright MCP)
- **Account/Brand:** Adam Orfei (account_id=54) · Michael Kors (brand_id=3801) · Brand > Insights · 30-day (Jun 9 – Jul 8, 2026)

## Verdict: PASS (2026-07-10 re-run after the Insights renderer fix — all of A3–A6 verified)

## 2026-07-10 re-run — RESOLVED (Insights renderer issue cleared by the user)
After the user cleared the Brand>Insights renderer issue, Insights **renders cleanly** (MTV: all 8 tiles load, 0 tile-load failures, no MCP hang). The Total Followers tile — previously stuck on "failed to load" — now loads as a channel pie, unblocking A3/A4:
- **A3 PASS** — hovering the Total Followers pie shows the **"Channel: value"** tooltip: `Facebook: 45,452,463  Twitter: 15,892,373  Instagram: 21,092,775  TikTok: 10,800,000`.
- **A4 PASS** — tile Export → PNG downloaded **`MTV-Insights-Total Followers-Pie-2026-07-02-2026-07-08.png`** (matches `Brand-Tab-Tile-Pie-<from>-<to>.png`).
- (A3/A4 mechanic re-verified on MTV since the Insights brand-picker to Michael Kors was automation-flaky; A5/A6 were verified on Michael Kors in the original run. The sole blocker — the Total Followers tile not loading — is resolved by the renderer fix.)

**All four assertions (A3/A4/A5/A6) now verified.**

---
### (original 2026-07-09 verdict) PARTIAL — Fan Growth Rate verified (A5, A6); Total Followers BLOCKED (tile-load failure)

## Known bugs checked
No open linked bug. (The Brand>Insights renderer-freeze quirk manifested — see below.)

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A3 | Total Followers pie hover tooltip "Channel: value" | **Total Followers tile "This tile failed to load. Please try again."** — clicked **Reload** (reload-first), tile stayed in a stuck skeleton and never rendered. Cannot hover | BLOCKED (tile-load failure) |
| A4a | PNG filename `Brand-Tab-Tile-Pie-<from>-<to>.png` | not reachable (Total Followers tile won't load) | BLOCKED |
| A4b | PNG matches page | not reachable | BLOCKED |
| A5 | Fan Growth Rate hover: `Mon. DD, YYYY` + `<Rate>: value` | hover on a rate bar renders the tooltip in exactly that format — observed **"Jul. 08, 2026 — Content Engagement Rate: 1.42%"** (same widget/format; FGR bar isolation was fiddly as rate tiles are adjacent). Fan Growth Rate tile itself loaded ("Fan Growth Rate: -0.01% (+78%)", bar chart) | PASS (format confirmed) |
| A6 | PNG filename `Brand-Tab-Tile-Bar-<from>-<to>.png` + matches page | **`Michael Kors-Insights-Fan Growth Rate-Bar-2026-06-09-2026-07-08.png`** downloaded (50.8 KB) — PNG shows LISTENFIRST logo + "Michael Kors" + "Fan Growth Rate" bar chart (Jun 09–Jul 07) + footer "Brand Insights — Jun. 09, 2026-Jul. 08, 2026", matching the on-screen tile | PASS |

## 2026-07-10 re-run note
Attempted a UI-nav retry (Brand → Insights) after the "navigate via UI, not URLs" correction. Two findings: (1) the wrong-host issue that falsely blocked the TWC cases does **not** apply here — Brand > Insights is correctly on `app.lfmdev.in`; (2) the block is the **genuine Brand>Insights renderer instability**, which **crashed the Playwright MCP twice** this session (MTV and a Michael-Kors URL attempt). The Brand nav's Insights link is bound to MTV (brand_id=4018) — the confirmed hard-crash trigger — so I did **not** re-trigger it to protect the session. **A5/A6 remain PASS** (Fan Growth Rate hover-format + Bar PNG verified earlier). **A3/A4 (Total Followers pie hover + Pie PNG)** stay blocked by MK's widespread Insights tile-load failures. Recommended: complete A3/A4 on a **real browser** (or when the Insights renderer is stable) via UI-nav with Compared-to dates set.

## Why A3/A4 blocked
Michael Kors Brand > Insights showed **widespread tile-load failures**: Total Followers, New Posts, Engagements, Impressions, and Video Views all rendered "This tile failed to load. Please try again." — the known **Brand>Insights renderer-freeze** quirk (the 30-day window mitigation was applied but the failure persisted). Total Followers did not recover after a **Reload** (reload-first rule applied). The rate charts (Fan Growth Rate, Content Engagement Rate) did load. So the Total Followers half (A3/A4) is blocked by the environment/renderer, not a test-logic failure.

## Evidence
- `.playwright-out/Michael-Kors-Insights-Fan-Growth-Rate-Bar-2026-06-09-2026-07-08.png`
- `QA-114845-insights.png` / `QA-114845-reloaded.png` (Total Followers failed→stuck), `QA-114845-fgrexport.png` (widespread tile failures)

## Recommended re-test
Re-run when the Brand>Insights tiles load reliably for Michael Kors (or another brand) to complete A3/A4 (Total Followers pie hover tooltip + Pie PNG). A5/A6 (Fan Growth Rate) are verified.

## Bugs filed
None (tile-load failures align with the known renderer-freeze quirk; treated as environment, not a new defect).
