# QA-113722 — Admin - User Creation and Settings > Audit screen — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash
- **Skills:** settings-audit-logs
- **Result:** ⛔ BLOCKED-safety for the creation step (Audit-reflection half verified)

## Steps
1. **Settings > Users (Admin)** page loaded with an **Add a New User** flow (banner: "An automated email will be sent to a user's inbox whenever you add… a user").
2. **Did not** perform user creation.
3. Cross-checked the **Settings > Audit** screen (this run, QA-110083/107134).

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Create a user via Admin | New user added | **Not performed — prohibited** (never create accounts/users; also sends an automated email to the invitee) | ⛔ BLOCKED-safety |
| Audit screen logs user creation | "User Created" entry appears | Audit shows **"User User012 test was created"** (Activity Type **User Created**, Actor LFQA Testing) + "User012 test was deactivated" | ✅ |

## Notes / automation learning
- **User creation is a prohibited action** (account creation + automated email to a third party). The complementary verification — the **Audit screen correctly logs user creation/deactivation** — is fully observable from existing entries, so the Audit half passes.
- Recommend a credentialed manual tester perform the actual Add-a-New-User → Audit round-trip.

## Bugs filed
_None (creation safety-blocked; Audit reflection verified)._
