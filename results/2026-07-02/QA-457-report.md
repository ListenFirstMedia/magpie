# QA-457 — TWC Rate Data QA

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-457 · Priority: Critical
- **Result:** **SKIPPED** — needs STAGE environment (deferred), per user direction.

## Known bugs checked (pre-run)
- No open bugs; ~30 Jira links are all Closed (automation/history tickets).

## Why skipped
The case's core assertion is **"Ensure dev and stage data match"** — steps 9–10 require re-running the report on the **STAGE** environment and comparing dev vs stage. Only **dev** (`app.lfmdev.in`) is configured/accessible on this track (creds in `config/.env`); no stage environment. Same limitation as sister test QA-458. Not attempted per user direction (skip, move on). Revisit if stage access (URL + creds) is provided.
