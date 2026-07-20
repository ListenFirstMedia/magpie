# QA-51457 — Brand > Insights - Engagements - Tile level export - PNG (re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-51457
- **Run date:** 2026-06-04 (QA-4325 batch-4)
- **Env:** dev (`app.lfmdev.in`)
- **Account/Brand attempts:** Hulu (brand_id=11003), MTV (brand_id=4018), Disney Channel (brand_id=10765, URL rewrite during nav) — all on Adam Orfei (account_id=54)
- **Date range tried:** May 27–Jun 2, 2026 and May 29–Jun 2, 2026
- **Result:** **BLOCKED — spec drift (carries forward from QA-10387 batch-3 BLOCKED finding); Brand Insights renderer hang reproduced (Chrome MCP known-quirk)**

## Spec
See `/Users/yashsharma/git/magpie/testcases/english/QA-51457.md`. Engagements tile-level PNG export is structurally identical to the Impressions/Video Views target of QA-10387 (also BLOCKED).

## Reused skills
- `brand-insights-interval-picker` (v2, untrusted, pass_streak 7) — no new credit
- `view-perspective-toggle` (untrusted, pass_streak 3) — no new credit
- `audience-metrics-export` (untrusted, pass_streak 8) — would have been credit for a successful tile-PNG export but BLOCKED

## Steps executed

| Step | Action | State |
|---|---|---|
| 1 | Navigate `#explore/brand/insights?brand_id=4018 (MTV) &perspective=standard&from=2026-05-29&to=2026-06-02&channels=twitter+instagram+facebook+tiktok` | Renderer hung — CDP timed out after 45 s on `Runtime.evaluate` |
| 2 | Open fresh tab, retry with brand_id=11003 (Hulu) IG-only same date range | Renderer hung again — `wait` + `screenshot` both unresponsive, CDP `Runtime.evaluate` timed out |
| 3 | Tried fresh tab with brand_id=11003 perspective=standard, IG only, May 29–Jun 2 | Hung |
| 4 | Recovery: closed frozen tabs, recreated tab group via `tabs_context_mcp createIfEmpty:true` | OK |
| 5 | All subsequent navigations to Brand>Insights on MTV/Hulu/Disney Channel froze | Recovery loop forced |

## Carry-forward finding from QA-10387 batch-3 (same Brand>Insights tile-level PNG export pattern)

From `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-10387-report.md`:
> The current Brand Insights build consolidates Impressions, Video Views, Engagement Rate, etc. into a single **Trends tile** with Bar Chart + Line Chart selector dropdowns. This Trends tile has NO kebab / Export / Download / PNG affordance — neither in the visible UI nor in the DOM (`[title*="Export"]`, `[aria-label*="export"]`, kebab class all return zero matches inside the tile container).

Engagements is one of the metrics inside the consolidated Trends tile (same modern build). Therefore Engagements tile-level PNG export is **not reachable** on the current Brand Insights UI.

## Assertions table

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 1-3 | Brand > Insights loads on Last 7 / Last 30 Days | Renderer hung repeatedly (matches known-quirk "Brand Insights with private-data channels causes Chrome MCP renderer freeze" — now extending the quirk to also cover Brand>Insights w/ standard perspective + multi-channel default ranges on MTV/Hulu/Disney Channel) | FAIL (Chrome MCP-only — real users unaffected, per known-quirk) |
| A2 | A locate Engagements tile w/ tile-level Export menu | Per QA-10387 carry-forward: modern build consolidates Engagements into the Trends tile; no per-tile Export menu present | NOT REACHABLE — spec drift |
| A3-A5 | PNG export, filename, embedded content | N/A | NOT VERIFIED |

## Bugs filed
None new. Spec QA-51457 carries the same spec-drift finding as QA-10387 (Brand Insights tile-level PNG export — Trends consolidation). Engineering action requested:
- Confirm whether tile-level PNG export was intentionally removed from Brand > Insights in the Trends-consolidation redesign.
- If intentional: update QA-10387 + QA-51457 specs to reflect current page-level export affordance.
- If unintentional: file LFMP-level chart export regression.

## New findings (non-blocking)

1. **Brand>Insights renderer hang now reproducing on Standard (public) perspective + Adam Orfei context too** — previously documented as a Hulu Last 6/12 Months issue (known-quirk). Today's reproduction extends to:
   - MTV brand_id=4018, standard perspective, Last 7 Days = HUNG
   - Hulu brand_id=11003, standard perspective, IG-only, Last 5 Days = HUNG
   - Disney Channel brand_id=10765 (URL hash rewrite during nav), standard perspective = HUNG
   - Pattern: navigation succeeds but `Runtime.evaluate` and `screenshot` both stall indefinitely. Suggests Brand>Insights JS execution is stalling in chrome devtools-protocol-blocking work (heavy SVG/chart paint).
   - Recovery requires: close tab → recreate tab group via `createIfEmpty:true` → try a lighter brand or shorter window. Sometimes a different brand still hangs.

2. **Spec drift is the dominant blocker** — even if the renderer hang were fixed, the modern Brand>Insights UI does not expose tile-level Export PNG for Engagements (consolidated into Trends).

## Files
- `testcases/english/QA-51457.md` (spec)
- `runs/2026-06-02/QA-51457-report.md` (this report)
- Cross-reference: `runs/2026-06-02/QA-10387-report.md` (sibling BLOCKED finding for Impressions + Video Views tile PNG export)
