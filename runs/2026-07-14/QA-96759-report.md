# QA-96759 — Brand > Insights - Threads - Tile Level Export - PNG

**Run date:** 2026-07-14
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Brand attempted:** MTV (brand_id=4018)
**Status:** ⛔ BLOCKED — reproduces documented renderer hang (not a new product defect, pre-existing known issue)

## Steps executed

1. Switched account to Adam Orfei (account_id=54).
2. Navigated to `#explore/brand/insights?brand_id=4018&channels=threads&from=2026-07-07&to=2026-07-13` (MTV, Threads channel, 7-day window) — the brand/channel combination `known-quirks.md` documents as reliably reproducing the Brand>Insights Threads-renderer hang (2026-06-08, "QA-96759/QA-99531 QA-22296 batch-6" entry, and the 2026-06-08 QA-95190 update).
3. Waited 5s, then attempted `browser_snapshot`.

## Assertions

| Step | Expected | Actual | Status |
|------|----------|--------|--------|
| — | Brand>Insights renders with Threads tile(s) so the tile-level Export → PNG flow can be exercised | Page **hung indefinitely** — `browser_snapshot` timed out after 30s trying to read the DOM (Playwright equivalent of the documented CDP `Runtime.evaluate` 45s timeout on Chrome MCP) | ❌ NOT VERIFIABLE — BLOCKED, reproduces known issue |

No further assertions (PNG export availability, filename schema, per-tile Export dropdown) could be exercised — the page never became interactive.

## Finding

**Reproduces the pre-existing, well-documented Brand>Insights + Threads renderer hang**, now confirmed on the Playwright MCP track (previously only confirmed on Chrome MCP). Per `known-quirks.md`: any `channels=threads` (or Threads-inclusive multi-channel) query against Brand>Insights hangs the page renderer, regardless of brand (MTV, Michael Kors, and multi-channel mixes including Threads have all reproduced it). This is the same root cause blocking QA-99531 (same batch, same page).

Recovery worked as documented: `browser_tabs` close + open fresh tab recovered the session cleanly (still authenticated as Adam Orfei) in well under the ~12s the Chrome-MCP equivalent quirk entry cites.

Per the existing quirk guidance, Brand>Content Threads (not Brand>Insights) is confirmed to render cleanly with the channel-specific data set (`table_data_set=threads_only%3A_insights`) — but that is a different page and cannot substitute for this ticket's Brand>Insights-specific PNG-export assertion (Rule 1: don't substitute the page/flow under test).

This is a **known, previously-filed issue**, not a new defect — no new bug filed. Recommend engineering prioritize the Brand>Insights Threads-render hang given it now blocks two tickets (QA-96759, QA-99531) across two separate automation tracks over multiple runs (2026-06-08 Chrome MCP, 2026-07-14 Playwright MCP).

## Bugs filed

None (pre-existing, already documented in `known-quirks.md`; no new Jira bug filed by this run).

## Cleanup

Not applicable — read-only navigation attempt, no mutation occurred before the hang.
