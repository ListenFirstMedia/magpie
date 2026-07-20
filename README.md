# magpie — LF regression testing framework

Magpie runs the ListenFirst platform's manual QA regression suite using Claude as both the
executor and the judge. Claude drives a real browser via **Playwright MCP**, follows each Xray
test case step-by-step, verifies the assertions, and writes a markdown report with a
PASS / FAIL / BLOCKED / SKIPPED verdict. It runs two ways:

- **Interactive / headed** — one case at a time, browser visible, Claude stops and asks on any block.
- **Unattended / headless** — `claude -p` per case, hard per-case watchdog, batches with resume.
  This is the path CI (Jenkins on-prem) will drive.

The authoritative spec for *how* a case is executed is **[`docs/PROMPT.md`](docs/PROMPT.md)** — the
single source of truth that both modes follow.

## Folder map

```
magpie/
├── README.md            # this file
├── docs/                # PROMPT.md (execution spec), MIGRATION.md, env.md (run env + login)
├── bin/                 # runners: run-case.sh, run-batches.sh, harvest.sh, adf_to_cases.py
├── cases/               # ingested Xray test cases, one QA-<id>.md per case
├── batches/             # named case-ID lists (the "sets") fed to run-batches.sh
├── results/             # run outputs: results/<date>/QA-<id>-report.md + summary.json
├── skills/              # reusable per-flow playbooks (REGISTRY.md, _shared/, _TEMPLATE.md)
├── knowledge-base/      # app-map.md, known-quirks.md, glossary.md, bug-history.md
├── config/              # .env (LFM_EMAIL/LFM_PASSWORD) + storageState.json — gitignored secrets
└── .playwright-out/     # Playwright MCP output dir (screenshots/snapshots) — gitignored
```

## Quickstart

Prereqs: `.mcp.json` has the Playwright MCP server (with `--headless` for unattended runs), and
`config/.env` holds `LFM_EMAIL` / `LFM_PASSWORD`. See [`docs/env.md`](docs/env.md).

```sh
# one case, unattended headless
bin/run-case.sh QA-84193

# prove headless login only (smoke gate), run no case
bin/run-case.sh QA-84193 --login-only

# run a whole set in batches (login smoke gate → batches of 5 → summary.json, resumable)
bin/run-batches.sh batches/qa4325.txt

# after a batch run: skill/registry/KB maintenance pass (no browser)
bin/harvest.sh                 # today's run
bin/harvest.sh 2026-06-27      # a specific run date
```

Useful knobs: `CASE_TIMEOUT` (per-case hard cap, seconds; default 900 — long cases need 1800),
`BATCH_SIZE`, `ON_LIMIT=wait|stop` (behavior on a Claude usage/rate limit).

## Status

- **Cases ingested:** ~234 in `cases/`.
- **Sets executed:** 4 (QA-22298, QA-4325, QA-22296, QA-4204) — ~173 cases, ~87% PASS; remaining
  are mostly open-bug BLOCKs (bugs go into reports only, never auto-filed to Jira).
- **Skills:** 47 total (`skills/REGISTRY.md`), 3 promoted to `stable`, the rest `untrusted`.
- **Next phase:** wire the unattended path into **Jenkins (on-prem)** — the only runner with network
  reachability to `*.lfmdev.in`.
