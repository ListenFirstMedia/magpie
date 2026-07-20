# QA-113595 — Settings > Audit and Admin page changes — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash
- **Skills:** settings-audit-logs
- **Result:** ✅ PASS-with-deviation (both pages load + Audit reflects Admin changes; *making* new Admin changes is safety-gated)

## Steps
1. **Settings > Users (Admin)** page loaded: user table (First/Last/Email/Phone/Job Title/Role/Customer/Business Unit/Account/Status/MFA/API/Last Active/Actions), **Add a New User**, Bulk Resend Invite / Bulk Deactivate, Seat Licenses 183/500. Note banner: "An automated email will be sent to a user's inbox whenever you add, edit, resend invites, or reset a user's password."
2. **Settings > Audit** (verified earlier this run, QA-110083/107134) reflects Admin/Settings changes.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Admin (Users) page loads | User-management table + controls | Loaded read-only with full table + Add/Bulk controls | ✅ |
| Audit reflects Admin changes | Admin/Settings mutations logged in Audit | Audit shows **User Created / User Deactivated / Brand Set Created / Brand Set Deleted / Brand Created / Brand Deleted** (Actor LFQA Testing) | ✅ |
| Make a new Admin change | Create/edit user → appears in Audit | **Not performed — safety-gated** (creating/editing users is prohibited; also dispatches an automated email) | ⛔-safety |

## Notes / automation learning
- The "Admin" surface is **Settings > Users**; it loads read-only fine. The Audit↔Admin integration is demonstrable from the **existing** audit trail (user/brand/brand-set lifecycle entries), so the feature is confirmed without performing a new mutation.
- New Admin mutations (Add a New User / edit / reset password) are **not performed** — they create accounts and send automated emails, both prohibited.

## Bugs filed
_None._
