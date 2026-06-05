# Batch 4 re-run log — 2026-05-29

| Ticket | Result | Open bug verdicts | Next action |
|--------|--------|-------------------|-------------|
| QA-51490 | PASS with minor format deviations | (no open bugs) | All 12 assertions pass on content; A9/A11 minor layout drift in the PNG (brand+chart on separate lines vs single hyphen-joined; date at PNG footer vs directly below legend). LFMP-31903 .png-suffix issue (Brand Sets Partnerships) does NOT reproduce on Brand Insights CER PNG — file saved with `.png` extension. |
| QA-135321 | PASS | (no open bugs) | All 4 assertions pass. Minor: URL `filters` JSON didn't reflect the `is_paid` entry at A4 inspection but pills + greyed Apply button confirm state-side filter registration. |
| QA-135319 | PASS | (no open bugs) | All 10 assertions pass. Defaults (Include + Or-disabled, And-disabled with <2 tags), smooth toggle, Remove Filter on unapplied Exclude pill — all behave as spec describes. |
| QA-134277 | PARTIAL — 2 new findings | (no open bugs) | Engineering — two new findings: (1) backend rejects OR-operator + None-tag combination ("Table failed to load"); (2) Export button disabled at Posts(0), blocking A6 verification. A1/A2/A5 PASS; A3/A4 BLOCKED by backend failure; A6 NOT VERIFIED (export disabled). |
| QA-134516 | FAIL (spec mismatch) | (no open bugs) | Engineering / product — CPR Tag Filter lacks Include/Exclude semantics (only OR/AND inclusion). Spec assumes parity with Brand>Content that doesn't exist on Content Performance. Either CPR needs Include/Exclude feature or QA-134516 spec needs rewrite. |

## Batch summary

- **Tickets:** 5
- **PASS:** 3 (QA-51490, QA-135321, QA-135319)
- **PARTIAL:** 1 (QA-134277 — 2 new backend findings)
- **FAIL:** 1 (QA-134516 — spec/feature mismatch)
- **BLOCKED:** 0
- **New bugs found:** 3 (CPR Tag Filter missing Include/Exclude feature; CSV `OR` + None-tag table-load failure; Export button disabled when Posts=0)
- **Open-bug reproductions:** 0 (no open bugs were attached to any batch-4 ticket)
- **Quirks reused this batch:** 1 (Brand picker React-controlled input — used programmatic input-setter pattern on the CPR Add Brand By Name field)

## Chrome MCP state for batch 5 handoff

- Tab group ID: 2136372442
- Active tab: 1804437657 — currently on `app-reporting.lfmdev.in/#/content_performance` (HBO Max, Euphoria added, Tag sub-popup open).
- Sessions: app.lfmdev.in authenticated as Yash; HBO Max account context active (account_id=657).
- Notes for batch 5: Recommend fresh tab + re-login. Several account switches (Viacom → Hulu → HBO Max) and multiple filter-state pills accumulated this batch.
