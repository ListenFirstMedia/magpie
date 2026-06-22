# Run Environment

> **Branch note:** This file describes the **Playwright MCP** track (branch `feature/playwright-mcp`).
> The Chrome-MCP attach-to-existing-Chrome setup on `staging/lf-regression` is the prior model — see git history if you need it.

## Browser

- **Mode:** Playwright MCP (`@playwright/mcp`), driven by Claude via MCP tools
- **Engine:** real Chrome (`--browser chrome`)
- **Auth:** `config/storageState.json` (gitignored) — see "Auth" below
- **Headed/headless:** start **headed** for first login + spike validation; add `--headless` to `.mcp.json` once auth holds
- **Viewport:** Playwright default (set `--viewport-size` in `.mcp.json` if a case needs a fixed size)
- **Network:** real, no throttling

## Auth (storageState)

The app is **Google SSO** — there are no stored passwords. Headless runs reuse a captured session:

1. One-time interactive capture:
   ```
   npx playwright open --save-storage=config/storageState.json https://app.lfmdev.in
   ```
   Complete the Google SSO login by hand in the window that opens; the session is written to `config/storageState.json`.
2. `.mcp.json` points Playwright MCP at that file via `--storage-state ./config/storageState.json`.
3. The file is **gitignored**. For CI, store its contents as the `LFM_STORAGE_STATE` secret.
4. **Refresh:** the SSO session expires periodically. When pre-flight fails on a login redirect, re-run the capture command.

## Jira ingestion caveat

Test cases come from Jira via the Atlassian MCP, which is **interactively authenticated (claude.ai)** and may be **absent in headless `claude -p` runs**. Either:
- Pre-fetch the batch's tickets into `testcases/english/QA-<id>.md` during an interactive session, then run headless against those files, **or**
- Configure a remote Atlassian MCP server in `.mcp.json`.

## Capture defaults

- **Traces:** auto-saved to `.playwright-out/` (`--save-trace`) — the Playwright-native replacement for ad-hoc screenshots
- **Console / network:** captured per case (errors/warnings, 4xx/5xx flagged)
- **Screenshots:** on assertion failure or bug, plus for any chart/canvas assertion the a11y tree can't read
- **Downloads:** via Playwright `download` events → saved under `.playwright-out/` and verified on disk
- **DOM snippets:** captured for failing elements at point of failure

## Pre-flight (run at start of every regression run)

1. Confirm app is reachable (HEAD on base URL → 2xx/3xx)
2. Confirm the storageState session is valid — navigate to `app.lfmdev.in`, assert the dashboard renders **without** a login redirect. If redirected → auth expired → re-capture storageState and abort.
3. Confirm dashboard renders (one canonical assertion)
4. If any step fails: abort the run, emit a smoke-failure report, do not run remaining cases

## Run cadence

- **Phase (current):** local, on-demand + scheduled via `claude -p` (cron). Smoke-gate aborts early if pre-flight fails; cap cases per batch to bound token cost.
- **Later:** GitHub Actions on a self-hosted runner inside the LFM network (GitHub-hosted runners cannot reach `*.lfmdev.in`).
