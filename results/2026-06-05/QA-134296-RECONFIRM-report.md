# QA-134296 — Brandsets → Rankings - Data Last Updated: Timestamp (RECONFIRM)

- **Date:** 2026-06-08 (QA-22296 batch 10)
- **Account:** Adam Orfei (account_id=54)
- **Brand Sets:** Adam's Brand Set (brand_set_id=1738), 1923 Talent (brand_set_id=11190)
- **Source spec:** `testcases/english/QA-134296.md` + Atlassian QA-134296
- **Skill:** none dedicated
- **Prior runs:** QA-4325 batch 11 2026-06-04 (PASS, value `06-04-2026 05:06 AM PT`)

## Result: PASS — RECONFIRM

`Data Last Updated` timestamp renders identically across Brand Sets sub-tabs, persists through F5 reload, and persists across brand-set switches. Today's value matches the Brand surface values from QA-134271 — confirms account-wide ETL signal.

## Execution

1. Brand Sets > Rankings (Adam's Brand Set 1738) — read header
2. Brand Sets > Content (Adam's Brand Set 1738) — read header
3. F5 reload of Brand Sets > Content — re-read header
4. Brand Sets > Rankings (1923 Talent 11190) — read header

## Assertions

| ID | Surface | Expected | Actual | Status |
|----|---------|----------|--------|--------|
| A1 | Brand Sets > Rankings (Adam's Brand Set) | `MM-DD-YYYY HH:MM AM/PM PT` | `Data Last Updated (PT): 06-08-2026 04:29 AM PT` | PASS |
| A2 | Brand Sets > Content (Adam's Brand Set) | Same value | `Data Last Updated (PT): 06-08-2026 04:29 AM PT` | PASS |
| A3 | Brand Sets > Content after F5 | Persists | `Data Last Updated (PT): 06-08-2026 04:29 AM PT` | PASS |
| A4 | Brand Sets > Rankings (1923 Talent — different brand set) | Same value | `Data Last Updated (PT): 06-08-2026 04:29 AM PT` | PASS |
| A5 | Format conformance | regex match | Matches | PASS |
| A6 | Cross-app parity with Brand surfaces (QA-134271) | Identical | `06-08-2026 04:29 AM PT` matches all Brand surfaces today | PASS |

## Evidence

- 4 sequential JS-probe captures all returned `Data Last Updated (PT): 06-08-2026 04:29 AM PT`.
- Cross-app parity: identical to QA-134271 RECONFIRM values from same session.

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs on QA-134296) | — | clean test |

## New findings

None — Brand Sets timestamp behavior identical to Brand surface behavior. Account-wide signal confirmed.

## Files

- `runs/2026-06-05/QA-134296-RECONFIRM-report.md` (this report)
- Prior: `runs/2026-06-02/QA-134296-report.md`
