# QA-20988 — Brand > Paid - Tile Level Export Functionality - PNG

- **Run date:** 2026-07-04
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-20988
- **Track:** Playwright MCP (feature/playwright-mcp), headless/unattended
- **Verdict:** **FAILED (blocked by open bug)**

## Summary

Per **Rule 7 — Open-bug auto-fail** (`skills/_shared/spec-adherence-rules.md`), this case was **not executed**. The cached case file (`testcases/english/QA-20988.md`) carries an open linked defect in its "Open linked bugs" section:

> **OPEN: DATA-12089 (Code Review)** — as of 2026-07-03.

A case with an open linked defect cannot produce a trustworthy PASS, so the browser flow was not opened and no pre-flight login was performed. The case re-runs automatically once DATA-12089 closes and the cache is refreshed.

## Steps executed

None. Case screened out at the open-bug gate before any UI interaction.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | Bar Chart, Export, Save to Dashboard options below all tiles | Not evaluated — blocked | BLOCKED |
| A6a | 6 | Chart updates to Area (Active Ads) | Not evaluated — blocked | BLOCKED |
| A6b | 6 | PNG matches page tile for Active Ads | Not evaluated — blocked | BLOCKED |
| A8a | 8 | Chart updates to Table (Paid Impressions) | Not evaluated — blocked | BLOCKED |
| A8b | 8 | PNG matches page tile for Paid Impressions | Not evaluated — blocked | BLOCKED |
| A8c | 8 | No legend / no "compared to" | Not evaluated — blocked | BLOCKED |
| A10a | 10 | Chart updates to Pie (Spends) | Not evaluated — blocked | BLOCKED |
| A10b | 10 | PNG matches page tile for Spend | Not evaluated — blocked | BLOCKED |
| A10c | 10 | No "Compared to" displays | Not evaluated — blocked | BLOCKED |
| A12a | 12 | Chart updates to Line (Clicks) | Not evaluated — blocked | BLOCKED |
| A12b | 12 | PNG matches page tile for Clicks | Not evaluated — blocked | BLOCKED |
| A13 | 13 | PNG matches page tile for Reach | Not evaluated — blocked | BLOCKED |
| A15a | 15 | Chart updates to Area (100% Completed Video Views) | Not evaluated — blocked | BLOCKED |
| A15b | 15 | PNG matches page tile for 100% Completed Video Views | Not evaluated — blocked | BLOCKED |

## Evidence

- Blocking bug key sourced directly from the cached case file `testcases/english/QA-20988.md` line 50 ("Open linked bugs" section, baked in from Jira at cache time).
- No screenshots captured — no browser session was started.

## Bugs filed

None. DATA-12089 is a pre-existing open defect (status: Code Review) linked to this case; it is the reason for the block, not a new finding from this run.
