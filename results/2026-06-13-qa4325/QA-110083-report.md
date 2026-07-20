# QA-110083 — Settings > Audit – Brand Set Created - Audit Actions Functionality — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Window:** Jun 1–15 2026
- **Skills:** settings-audit-logs
- **Result:** ✅ PASS

## Steps
1. Settings → Audit, window Jun 1–15 2026.
2. Located **Brand Set Created** and **Brand Set Deleted** audit rows (Jun 15 04:22 PM PDT, Customer/BU/Account = Hulu, Actor = LFQA Testing).

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| "Brand Set Created" activity type present | Audit vocabulary includes Brand Set Created | Row: **Activity Type = "Brand Set Created"** | ✅ |
| Row fields populated | Date/Customer/BU/Account/Actor/Description | Mon Jun 15 04:22 PM PDT · Hulu · Hulu · Hulu · **LFQA Testing** · "Brand Set **qa_new 68998 06/15/21/58** was created." | ✅ |
| Companion lifecycle actions | Created + Deleted both logged | "Brand Set Created" (04:22) + "Brand Set Deleted" (04:22) both present; also Brand Created/Deleted, User Created/Deactivated | ✅ |

## Notes / automation learning
- The Audit **Activity Type vocabulary extends beyond user-management** to brand + brand-set mutations: observed **Brand Set Created / Brand Set Deleted / Brand Created / Brand Deleted / User Created / User Deactivated** in this window. Confirms the QA-110083 enum addition.
- The created Brand Set name is a deep link (ties to QA-107134).

## Bugs filed
_None._
