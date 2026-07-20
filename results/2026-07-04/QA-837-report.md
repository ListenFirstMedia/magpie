# QA-837 — Social Recap: Report - Multiple brands

- **Run date:** 2026-07-04
- **Track:** Playwright MCP (feature/playwright-mcp), headless/unattended
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-837
- **Verdict:** **FAILED (blocked by open bug)**

## Why blocked (not run)

Per spec-adherence **Rule 7 — Open-bug auto-fail**, the case file's "## Open linked bugs"
section (baked in from Jira on 2026-07-03) lists **OPEN** defects:

- **LFMP-31798 (Open)**
- **LFMP-31918 (Open)**

A case with an open linked defect cannot produce a trustworthy PASS. The case was therefore
**not executed** — no login, no browser flow — to avoid wasting the per-case budget and
reporting a misleading result. Re-runs pick this case up automatically once the linked bugs
close and the cache is refreshed.

## Steps executed

None. Screening halted execution before the browser flow (Rule 7).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | URL updates to `…/#/template` | Not evaluated | BLOCKED (open bug) |
| A2 | 2 | Selected template loads on the page | Not evaluated | BLOCKED (open bug) |
| A3 | 3 | Primary brand not shown as an option once brands entered | Not evaluated | BLOCKED (open bug) |
| A4 | 3–4 | Report displays brands in order added | Not evaluated | BLOCKED (open bug) |
| A5 | 5 | Print Preview has a page break after every brand | Not evaluated | BLOCKED (open bug) |
| A6 | 5 | New sidebar + header for each brand | Not evaluated | BLOCKED (open bug) |
| A7 | 6 | Downloaded report matches generated report | Not evaluated | BLOCKED (open bug) |

## Evidence

No screenshots or snapshots captured — the browser flow was not opened (auto-fail before execution).

## Bugs filed

None. This run did not execute the case, so no new observations. Blocking defects already
tracked in Jira: **LFMP-31798 (Open)**, **LFMP-31918 (Open)**.
