# QA-131491 — Social Recap Vs Brand Content - IG Public Video View — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV (4018) · **Channel:** Instagram · **Window:** Jan 1–7 2026
- **Skills:** brand-content-data-set-selector, social-recap-report-run
- **Result:** ✅ PASS (RECONFIRM) — exact verbatim match with prior run; no drift

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Brand>Content IG VV matches Social Recap | Post-level + aggregate VV consistent | Posts(15); Sum Engagements **297,194** / Reactions 295,241 / Comments 1,953 / **Video Views 6,021,556**; Avg 19,813 / 19,683 / 130 / VV 752,694 / VRR 3.08% | ✅ |
| Post #1 Video Views | 691,822 (prior verbatim) | 691,822 present in page | ✅ |

All figures match the 2026-06-02/08 runs exactly → Social Recap ↔ Brand Content IG Video View parity holds, no drift.

## Bugs filed
_None._
