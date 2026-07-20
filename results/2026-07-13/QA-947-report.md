# QA-947 — Brand Video Tab - Hovering Functionality

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54), Brand: Hulu (brand_id=11003)
**Status:** ⛔ BLOCKED — environment/tooling failure (renderer hang crashed the Playwright MCP server)

## What happened

1. Navigated to `https://app.lfmdev.in/#explore/brand/video?brand_id=11003&account_id=54&from=2026-06-01&to=2026-07-11`.
2. Page loaded (title "Brand Video - ListenFirst: Brand Video"), 49 console errors, 2 warnings — consistent with prior runs' noise level.
3. Called `browser_wait_for` (3s) to let the stacked bar charts render — this call **timed out after 30 seconds**.
4. The very next tool call (`browser_evaluate`) returned **"MCP error -32000: Connection closed"**.
5. All subsequent Playwright MCP tools (`browser_navigate`, `browser_click`, `browser_evaluate`, `browser_tabs`, etc.) disappeared from the available tool registry — `ToolSearch` for `playwright browser` returns no matches. The Playwright MCP server process itself has died, not just a single call.

## Why this matches (and escalates) a known quirk

`knowledge-base/known-quirks.md` documents a long-running "Brand>Insights / Brand>Video renderer hang" under **Chrome MCP** (CDP `Runtime.evaluate` 45s timeouts, recoverable via `tabs_close_mcp` + fresh tab). This is the **first time this hang has been observed to fully crash the Playwright MCP server connection** rather than just timing out an individual tool call. Chrome-MCP's documented recovery (`tabs_close_mcp` + fresh tab) is not available under Playwright MCP's tool set, and even if it were, the tools themselves are gone.

## Impact on this run

This is a **session-ending infrastructure failure**, not a per-case issue. Because the Playwright MCP browser tools are no longer reachable, every remaining test case in the QA-22296 batch queue (batches 3–15, 62 cases: QA-18940 through QA-138162) had to be skipped for this run — see the cumulative report for the full list.

## Assertions

Not evaluated — the page never finished rendering before the connection died.

## Bugs filed

None filed against the product — this is an automation/environment stability issue. **Recommend**: escalate to whoever owns the Playwright MCP process/config (`@playwright/mcp` launch args in `.mcp.json`) to add a hard navigation/render timeout + auto-restart, since a single hung page can currently take down the entire tool for the rest of a run. Also recommend updating `known-quirks.md`'s Brand>Insights/Brand>Video hang entry to note this new Playwright-MCP-crash escalation (done — see below).

## Cleanup

Not applicable — no mutation occurred.
