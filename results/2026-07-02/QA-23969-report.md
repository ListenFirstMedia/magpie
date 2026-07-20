# QA-23969 — Reporting > Social Recap - Download

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-23969 · Priority: Critical
- **Result:** **FAILED** — blocked by an OPEN linked bug. Not executed.
- **Primary brand:** ListenFirst (Authorized)

## Why FAILED (not executed)
Per [[open-bug-auto-fail]], marked **FAILED without execution** — an open defect sits on the Social Recap report content this case builds/downloads/verifies:

- **LFMP-31925** — "Reporting > Social Recap → %YOY is not Present in Video Views Donut in Report" · **status: Open** · Major · Bug.

Steps 7–8 / 15–16 require the downloaded PDF to match the preview-mode report; with LFMP-31925 open (the report's Video Views donut is missing its %YOY), the report/PDF content is known-defective.

## Linked bug scan
- OPEN: **LFMP-31925** (Bug, Major) — Video Views donut missing %YOY in report. ← blocker
- Other linked defects Closed.

## Next step
Re-run QA-23969 once **LFMP-31925** is resolved/Closed. (The Social Recap build/Preview/Download mechanics themselves are validated by QA-837's PASS run this session; this case is blocked only by the open report-content bug.)

## Bugs filed
None (LFMP-31925 already exists and is open).
