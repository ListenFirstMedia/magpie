# QA-10387 — Brand Insights - Impression and Video Views Chart - PNG — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei
- **Result:** 🚫 BLOCKED (carry-forward) — tile-level PNG export absent on consolidated Insights tile + Brand>Insights renderer-hang risk

## Rationale
- Prior run (2026-06-04) found the **tile-level PNG export is absent on the modern Trends-consolidated Insights tile** (the Impression/Video Views chart no longer exposes a per-tile PNG export) — a spec/feature drift, recorded as BLOCKED.
- Brand>Insights is also in the documented renderer-hang family (froze the Chrome MCP CDP pipeline repeatedly on 2026-06-13). To protect the session it was not re-driven this run.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Per-tile PNG export of Impression & Video Views chart | PNG downloads | Tile-level PNG export not present on consolidated Insights tile (carry-forward); Insights renderer-hang risk | 🚫 BLOCKED |

## Bugs filed
- Spec/feature drift carry-forward: per-tile PNG export missing on the consolidated Insights Trends tile. Recommend product/spec triage.
