# QA-23991 — Reporting > Content Performance Report - Download — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV · **Window:** Jun 5–11 2026 · **Story:** 154575
- **Skills:** pdf-end-to-end-verification v2
- **Result:** ✅ PASS — consistent with 2026-06-05

## Steps
1. Reporting → Content Performance → add MTV (Rule 1) → Most Engaging Content → Run Report → story 154575 (Content Posted 150 / Engagements 839K; channel split IG 32%/FB 27%/TikTok 27%/X 13%/YT 1%).
2. Preview & Share Report → LISTENFIRST-branded preview.
3. Download → jsPDF blob captured + inspected in-page (Rule 6).

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Report builds + renders | CPR renders Content Posted + Engagements channel bars | story 154575, Content Posted 150 / Engagements 839K | ✅ |
| Download produces valid PDF | jsPDF PDF | Blob: **113,629 bytes**, `application/pdf`, `%PDF-1.3`, **1 page** | ✅ |
| LFMP-32010 (Least Engaging) | — | NOT tested (Least Engaging Content not enabled this run) | ⚠️ NOT VERIFIED (same as prior) |

## Bugs filed
_None._ (PDF smaller than prior 294K because Visual Top Posts=0 this run — no embedded post images; structure valid.)

## Cleanup
- CPR story 154575 created (harmless).
