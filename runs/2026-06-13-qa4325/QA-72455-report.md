# QA-72455 — Brand > Paid - Unauthorized Spend Metrics - Twitter Channel — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand:** MTV (4018) · **Window:** Jun 1–15 2026
- **Skills:** brand-paid-nav
- **Result:** 🟡 PARTIAL — Spend renders as unauthorized/no-data, but Twitter-isolated tile view blocked by env

## Steps
1. Brand > Paid for MTV, window Jun 1–15 2026 (fresh tab after the Brand>Insights hang recovery).
2. Six paid trend tiles (Active Ads, Paid Impressions, **Spend**, Clicks, Paid Actions, 95% Completed Video Views) all displayed **"This tile failed to load. Please try again."** (Chrome-MCP tile-render artifact).
3. Switched **View → Authorized Data**; inspected the Ads table.
4. Attempted to isolate the **Twitter (X)** channel via the channel selector — the channel icons are not exposed as accessible refs and coordinate toggling was unreliable; the applied channel stayed Facebook.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Spend metric present | Paid table exposes a Spend column | Table columns: **Spend, Paid Actions, Clicks, Outbound Clicks, Inline Clicks** | ✅ |
| Spend unauthorized/empty | Twitter spend not authorized → no value | **Ads (0)**, Spend Sum/Avg = **"–"**, "There is no data available" | ✅ (consistent) |
| Twitter-channel isolated view | Twitter-only Spend tile shows unauthorized state | Could not isolate Twitter (icons not ref-addressable) + Spend trend tile fails to render (MCP) | ⛔ not observable |

## Notes / automation learning
- This **Adam Orfei / MTV** context has **no authorized paid/ad-account data at all** (Ads 0; every paid metric "–"), so Spend is effectively unauthorized across channels including Twitter. That matches the case's "unauthorized spend metrics" expectation, but means the *positive/authorized* comparison can't be shown here.
- **Brand>Paid trend tiles fail to render under Chrome MCP** — same artifact as Brand>Stories (data/table layer renders; chart canvases stall). Tile-level confirmation of the Twitter unauthorized-spend *display* is therefore not observable in this session.
- **Channel selector icons are not exposed in the accessibility tree** (no refs) and are too small for reliable coordinate toggling — fold a note into the brand-paid/channels skill to use the URL `channels=` param or a DOM-dispatched click instead.

## Bugs filed
_None (env/automation limits + test-data gap, not a product defect)._
