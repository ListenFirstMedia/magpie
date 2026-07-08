# QA-2706 — Brand > Content - Benchmark - Authorized

- **Run date:** 2026-07-04
- **Track:** Playwright MCP (feature/playwright-mcp), headless/unattended
- **Verdict:** **FAILED (blocked by open bug)**
- **Blocking bug:** **LFMP-31886 (Open)**

## Why blocked (not run)

The cached test case's **"## Open linked bugs"** section (as of 2026-07-03) lists an
**OPEN** defect: `LFMP-31886(Open)`.

Per **spec-adherence Rule 7 (open-bug auto-fail)**, a case with any open linked defect
cannot produce a trustworthy PASS. The case is marked **FAILED (blocked)** WITHOUT running
any steps — no browser flow was opened, no pre-flight login performed, per the rule
("Do not open the browser flow for that case"). This conserves the per-case budget and
avoids a misleading result.

Re-runs will pick this case up automatically once **LFMP-31886** is closed and the
test-case cache is refreshed from Jira.

## Steps executed

None. Case screened out before execution by the open-bug auto-fail rule.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6 | Benchmark % indicators updated only on Average aggregate row | Not evaluated | BLOCKED (open bug) |
| A2 | 6 | Benchmark Row shows benchmark value per metric below Sum/Average; N/A if no data | Not evaluated | BLOCKED (open bug) |
| A3 | 6 | Each post metric contains Benchmark values; N/A if no data | Not evaluated | BLOCKED (open bug) |
| A4 | 6 | Collection breadcrumb displays the benchmark used | Not evaluated | BLOCKED (open bug) |
| A5 | 6 | Post metrics show % indicators vs. benchmark | Not evaluated | BLOCKED (open bug) |
| A6 | 6 | Post metric % values rounded to nearest percent | Not evaluated | BLOCKED (open bug) |

## Evidence

- Test case source: testcases/english/QA-2706.md — "## Open linked bugs (as of 2026-07-03)":
  `**OPEN: LFMP-31886(Open)**`.
- No screenshots/snapshots (browser flow not opened by design).

## Bugs filed

None. This run files no bugs — it defers to the already-open **LFMP-31886**. No Jira
tickets created (markdown-only reporting).
