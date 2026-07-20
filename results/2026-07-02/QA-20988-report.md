# QA-20988 — Brand > Paid - Tile Level Export Functionality - PNG

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-20988 · Priority: Minor
- **Result:** **FAILED** — blocked by an unresolved linked bug. Not executed.
- **Precondition:** Michael Kors · **Channel:** TikTok (Brand > Paid)

## Why FAILED (not executed)
Per [[open-bug-auto-fail]] (any not-Closed linked bug → FAILED until resolved), marked **FAILED without execution** — an unresolved defect sits on the exact data this case depends on:

- **DATA-12089** — "Brand > Paid - TikTok Paid Data not Displaying" · **status: Code Review (In Progress, not Done)** · Major · Bug.

The case sets **TikTok channel only** on Brand > Paid (step 4) and then exports each Paid tile (Active Ads, Paid Impressions, Spends, Clicks, Reach, 100% Completed Video Views). With TikTok paid data not displaying (DATA-12089 unresolved), the tiles/PNGs can't be validated.

## Linked bug scan
- UNRESOLVED: **DATA-12089** (Bug, Major, Code Review/In Progress) — TikTok Paid Data not displaying. ← blocker
- Closed (not blocking): DATA-12023 (earlier TikTok-paid-data bug, Closed), APPS-29174 (triangle-arrow-as-square in PNG, Minor, Closed), LFMP-28044/APPS-36220 (PNG export not working, Closed).

## Next step
Re-run QA-20988 once **DATA-12089** is resolved/Closed and TikTok paid data displays.

## Bugs filed
None (DATA-12089 already exists and is in progress).
