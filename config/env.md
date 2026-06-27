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

## Auth (programmatic email/password login)

The app supports a Cognito **email/password** path ("With existing account" on the hosted UI). We log
in fresh at the start of every run rather than replaying a saved session.

**Why not storageState:** `--save-storage` serializes only cookies + localStorage, never
sessionStorage. This app's live session needs `apc_user` (sessionStorage) + `apc_session`
(localStorage) + a server-side HttpOnly cookie, so storageState replay lands on the login page even
right after capture. See known-quirks.md (2026-06-22).

**Login flow (driven via Playwright MCP):**
1. Credentials live in **`config/.env`** (gitignored): `LFM_EMAIL`, `LFM_PASSWORD`.
2. `browser_navigate('https://app.lfmdev.in')` → redirects to the Cognito hosted UI.
3. Fill the **"With existing account"** form (Email address + Password) and click **its** Sign in
   button. There are two "Sign in" buttons on the page — target the existing-account form
   specifically (not the Corporate-email/SSO one).
4. Wait for `app.lfmdev.in/#home` (title "Home - ListenFirst") to render.

**CI:** provide `LFM_EMAIL` / `LFM_PASSWORD` as secrets. `storageState.json` is no longer used for
auth on this track.

## Jira ingestion caveat

Test cases come from Jira via the Atlassian MCP, which is **interactively authenticated (claude.ai)** and may be **absent in headless `claude -p` runs**. Either:
- Pre-fetch the batch's tickets into `testcases/english/QA-<id>.md` during an interactive session, then run headless against those files, **or**
- Configure a remote Atlassian MCP server in `.mcp.json`.

## Capture defaults

- **Session artifacts:** saved to `.playwright-out/` (`--save-session`) — the Playwright-native record of actions/snapshots, replacing ad-hoc screenshots
- **Console / network:** captured per case (errors/warnings, 4xx/5xx flagged)
- **Screenshots:** on assertion failure or bug, plus for any chart/canvas assertion the a11y tree can't read
- **Downloads:** via Playwright `download` events → saved under `.playwright-out/` and verified on disk. **Google Sheets export is out of scope** (Google 2FA on a separate auth surface) — skip GS steps/assertions; CSV/TSV/XLS file exports stay in scope. See MIGRATION.md.
- **DOM snippets:** captured for failing elements at point of failure

## Pre-flight (run at start of every regression run)

1. Confirm app is reachable (HEAD on base URL → 2xx/3xx)
2. Log in — navigate to `app.lfmdev.in`; when redirected to the Cognito hosted UI, fill the
   "With existing account" form from `config/.env` and submit (see "Auth" above).
3. Confirm dashboard renders (one canonical assertion) at `app.lfmdev.in/#home` **without** remaining
   on a login redirect. If login fails (still on `auth.lfmdev.in`), verify `config/.env` creds.
4. If any step fails: abort the run, emit a smoke-failure report, do not run remaining cases

## Run cadence

- **Phase (current):** local, on-demand + scheduled via `claude -p` (cron). Smoke-gate aborts early if pre-flight fails; cap cases per batch to bound token cost.
- **Later:** GitHub Actions on a self-hosted runner inside the LFM network (GitHub-hosted runners cannot reach `*.lfmdev.in`).
