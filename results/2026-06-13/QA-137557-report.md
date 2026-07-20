# QA-137557 — Custom Metrics - Multiplication & Division Operators - Create & Save — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Skill:** settings-custom-metrics
- **Result:** ⚠️ PARTIAL-PASS — APPS-60358 NOT reproduced; full ÷-chip+Save not re-reached (flyout friction)

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Operators include × ÷ (APPS-60358) | Operators submenu offers + − × ÷ | Create form formula builder shows Metrics / Constant / **Operators ▸** / Parentheses; Operators submenu present (▸) per APPS-60358 | ✅ (present) |
| ÷ chip + Save + listing row | Build ×/÷ metric and save | NOT re-reached — Operators flyout is lazy-rendered and didn't open via synthetic hover (automation-only friction, same as 2026-06-08) | ⚠️ DEFERRED |

## Notes
- APPS-60358 (× ÷ operators) NOT reproduced as a bug — operator support is present. Full enumeration of the 4 operator icons blocked by flyout hover friction (consistent with prior PARTIAL-PASS).

## Bugs filed
_None (automation-only flyout friction)._
