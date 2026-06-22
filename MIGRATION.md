# Migration: Chrome MCP → Playwright MCP (branch `feature/playwright-mcp`)

This branch moves magpie's browser backend from **Chrome MCP (attach-to-your-open-Chrome)** to **Playwright MCP**, so Claude can run test cases **headless and unattended**. Claude stays the executor and judge — only "the hands" change. The existing framework on `staging/lf-regression` is untouched; this branch is additive until each skill is deliberately ported.

## What changed on this branch

- `.mcp.json.example` — Playwright MCP server config (rename to `.mcp.json` to activate; see below).
- `config/env.md` — rewritten for the Playwright/headless/`storageState` model + Jira-fetch caveat.
- `PROMPT.md` — fixed stale project path; points at this branch's Playwright docs.
- `skills/_shared/playwright-porting.md` — the Chrome-MCP → Playwright mechanic-translation table; **read before porting any skill**.
- `.gitignore` — ignores `config/storageState.json`, `.playwright-out/`, `.playwright-profile/`.

Everything else (skills, KB, REGISTRY, `_shared` rules, report format) is inherited unchanged.

## One-time setup (you must do these — they need your interactive Google login)

### 1. Activate the MCP server
```
mv .mcp.json.example .mcp.json
```
Renaming triggers Claude Code's MCP-approval prompt — approve the `playwright` server. (Keep `--headless` OFF in the args for now.)

### 2. Capture the SSO session (Google SSO — manual login)
```
npx playwright open --save-storage=config/storageState.json https://app.lfmdev.in
```
Log in by hand in the window that opens. It writes `config/storageState.json` (gitignored). Re-run whenever the session expires.

## Spike (validate before porting more) — 3 cases

Goal: prove the two real risks (Google SSO headless; charts invisible to the a11y tree) plus downloads, on a small set before wider porting.

1. **`data-studio-post-level-run`** — numeric/deterministic; magpie's only *stable* skill. Proves the core loop + math-identity assertions.
2. **TWC export (QA-198: TSV / CSV / XLS)** — proves `page.on('download')` for the file exports. **Google Sheets is out of scope** (see below).
3. **`chart-hover-tooltip`** — proves whether Recharts tooltips read via `.hover()` or need synthetic events / a screenshot fallback.

Run headless via `claude -p` (or interactively first). **Success criteria:**
- SSO session holds across all three (no login redirect).
- CSV/TSV/XLS verified on disk.
- Chart tooltip read — record in `knowledge-base/known-quirks.md` whether `.hover()` sufficed.

### Out of scope — Google Sheets export

GS export opens a separate `docs.google.com` tab that requires Google **2FA** on its own auth surface, which is impractical to bypass on every unattended run. On this track, **skip all Google Sheets steps and assertions** (the `export-google-sheets` skill is deferred). File exports (CSV/TSV/XLS) and on-disk verification stay in scope and cover the export pipeline. Revisit only if a service-account / non-interactive GS auth path becomes available.

Record the spike outcome in a run report under `runs/<date>/` and note new findings in `known-quirks.md`.

## After the spike

- Port skills lazily per `skills/_shared/playwright-porting.md`; add `--headless` to `.mcp.json` once auth is proven.
- Stand up local scheduled runs (`claude -p` on cron); emit `runs/<date>/summary.json` alongside the markdown reports.
- GitHub Actions later, on a **self-hosted runner** inside the LFM network (`*.lfmdev.in` is not reachable from GitHub-hosted runners); inject `storageState.json` as the `LFM_STORAGE_STATE` secret.

## Risks (track these)

- **Google SSO headless** is the primary blocker; `storageState` expires — expect periodic re-capture.
- **Charts/canvas** are invisible to the a11y tree → screenshot fallback for visual/hover assertions.
- **Product hangs** become Playwright timeouts (not fixed by auto-wait) — reload or skip.
- **Jira/Atlassian MCP** is interactively authenticated → may be absent headless; pre-fetch test cases or wire a remote server.
- **poppler-utils** must be installed for PDF-verification skills.
- Claude stays in the loop → token cost + non-determinism; gate batches, cap cases.
