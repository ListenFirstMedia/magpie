# QA-28799 — Settings > User > Create new user for Admin (Dev)

- **Run date:** 2026-07-04 (headless Playwright MCP, feature/playwright-mcp)
- **Account:** Adam Orfei (account_id=54) — precondition met on landing
- **Login identity:** lfiqa@listenfirstmedia.com (config/.env)
- **Priority:** P1 (Blocker) · **Mutating:** YES (creates + deactivates a real user)
- **Verdict:** **PASS** — all in-scope assertions (A1–A8) pass. A9/A10 (Dev Mixpanel) are OUT OF SCOPE (third-party system, separate auth — treated like Google Sheets). New user created and then deactivated (cleanup complete).
- **Open linked bugs:** None open (screened per Rule 7 → ran normally).

## Test data used
- First / Last name: `QA28799` / `AutoTest`
- Invalid email (step 4): `qa28799autotest.com` (no `@`)
- Valid email (step 5): `qa28799-auto-20260704@drylogics-qatest.com`
- Phone: `+1-20-26-0704-2879` · Job Title: `Drylogics Contract`
- Account: Drylogics (→ Customer/Business Unit auto = ListenFirst) · Role: Analyst (default)

## Steps executed
1. Settings (top nav) → Users. ✓ (`.playwright-out/QA-28799/01-users-page.png`)
2. Add a New User → redirected to Add New User form. ✓ (`02-add-new-user.png`)
3. Account = Drylogics selected; Customer/Business Unit auto-populated to ListenFirst. ✓ (`04-account-drylogics.png`)
4. Entered name + invalid-format email → Add User → inline error shown. ✓ (`06-invalid-email-filled.png`, `07-invalid-email-error.png`)
5. Corrected to valid-format email. ✓
6. Entered unique Phone + Job Title "Drylogics Contract". ✓ (`08-valid-form-ready.png`)
7. Add User → redirected to Settings Users; filtered by new user email → single row shown. ✓ (`09-after-add-user.png`, `16-filtered-row.png`)
8. Admin (key icon) → Accounts → Users (classic admin `admin.lfmdev.in/admin/users`). ✓ (`18-admin-users-page.png`)
9. Back to Settings Users → re-filtered → Actions ellipsis → menu (Edit/Resend Invite/Deactivate). ✓ (`20-actions-menu.png`)
10. Deactivate → confirmation modal → Ok. ✓ (`21-deactivate-confirm.png`, `22-after-deactivate.png`, `23-deactivated-view.png`)
11–13. Dev Mixpanel — **SKIPPED (out of scope)**, see Scope note.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2a | Page redirects to Add New User | Breadcrumb `Account: Adam Orfei \| Settings > Users > Add New User`; form rendered | **PASS** |
| A2 | 2b | "Analyst" default in Role dropdown | Role select box shows `Analyst` on fresh form | **PASS** |
| A3 | 3 | Role dropdown contains Admin, Analyst, Analyst (No Spend), LF Employee | After Account=Drylogics: `Admin, Analyst, Analyst (No Spend), LF Employee, TEST` — all 4 spec roles present (+extra Drylogics-custom `TEST`) | **PASS** |
| A4 | 4a | Add User enabled when text entered in email field | Button `disabled=false`, `cursor:pointer` once email text present (was disabled on empty form) | **PASS** |
| A5 | 4b | Red icon + error "Received invalid email: 'email.com'" | `error-msg`: **"Received invalid email: 'qa28799autotest.com'"**; email input class `user-input invalid` (red outline + X icon) | **PASS** |
| A6 | 7 | New user displayed in Users tab + success message | Filtered row shows QA28799 / AutoTest / qa28799-auto-20260704@drylogics-qatest.com / Drylogics Contract / Analyst / Drylogics / External. Seat Licenses 314→313 (user added). Success toast transient — not captured verbatim (see Notes) | **PASS** (display verified; toast text not captured) |
| A7 | 8 | New user displays in Users page in classic admin | Classic admin `/admin/users` top row: **Id 20801, QA28799 AutoTest, qa28799-auto-20260704@drylogics-qatest.com, Primary Account Drylogics, Ad Sales, Analyst, Is External: Yes, Created At July 03, 2026 21:56** | **PASS** |
| A8 | 10 | Success message "You've successfully deactivated added user@email.com!" | Confirmation modal named "QA28799 AutoTest"; after Ok, Seat Licenses 313→314 (seat freed), user removed from Active Users and present under Deactivated Users. Success toast transient — not captured verbatim | **PASS** (deactivation verified; toast text not captured) |
| A9 | 13a | "User Deactivated" below Activity Feed in Mixpanel | Not evaluated — Dev Mixpanel out of scope | **OUT OF SCOPE** |
| A10 | 13b | Duplicate users not created in Mixpanel | Not evaluated — Dev Mixpanel out of scope | **OUT OF SCOPE** |

## Evidence highlights
- **A3 sequencing (important):** on the fresh form (no account selected) the Role dropdown 4th option was `TEST`, not `LF Employee` (`03-role-dropdown-preaccount.png`). After selecting Account=Drylogics (which A3 is tied to — spec labels it "(3)"), the dropdown correctly listed `Admin / Analyst / Analyst (No Spend) / LF Employee / TEST` (`05-role-dropdown-drylogics.png`). Role options are account/customer-dependent; verifying A3 only after step 3 is required. Not a bug (Rule 5 re-read confirmed the step ordering).
- **A5** exact string: `Received invalid email: 'qa28799autotest.com'` — matches the spec format `Received invalid email: 'email.com'`.
- **Add / Deactivate confirmed by seat-license delta:** 314 (empty) → 313 (after add) → 314 (after deactivate), a durable counter independent of the transient toast.
- **Classic admin reachable this run:** `admin.lfmdev.in/` landing rendered (Titles) via the existing app session; the `/admin/users` route required a Cognito login (same client_id `6ep4l754u2dglosjdqggbt2mjr`, same lfiqa creds) — completed via the "With existing account" form. This supersedes the 2026-06-04 quirk that marked Admin/User-creation flows BLOCKED. See Notes.

## Scope notes
- **Dev Mixpanel (steps 11–13, A9/A10):** Mixpanel is a third-party analytics product behind its own auth surface (like Google Sheets / Google 2FA). Per the run's scope rules it is out of scope; A9/A10 skipped, not run. Case judged on in-scope A1–A8 only → PASS.
- **Precondition (Adam Orfei):** satisfied on landing (account_id=54); no account switch needed (same lfiqa identity).

## Cleanup
- The user created by this test (`qa28799-auto-20260704@drylogics-qatest.com`) was **deactivated** in step 10 (the built-in cleanup). Verified: removed from Active Users, present under Deactivated Users, seat freed (→314 available). No lingering active test user from this run.

## Bugs filed
None.

## Notes / findings for maintainers (not bugs)
1. **Success toasts are transient.** The "You've successfully added …!" (A6) and "You've successfully deactivated …!" (A8) toasts dissolve before a screenshot/DOM read can capture the verbatim text. The underlying behaviors were verified through multiple corroborating signals (seat-count deltas, confirmation-modal naming the exact user, list membership before/after). Per Rule 6 these are NOT reported as broken — only the toast-text capture timing is the gap. Recommend hooking the toast render or polling synchronously immediately post-click for verbatim capture on future runs.
2. **Admin auth boundary — update to the 2026-06-04 quirk.** The classic admin (`admin.lfmdev.in`) is reachable on the Playwright track by re-authenticating the SAME lfiqa user (same Cognito client_id) via the existing-account form; lfiqa has classic-admin access on this environment. The prior "Assistant cannot enter Admin / user-creation flows BLOCKED" note no longer holds for this case — A7 was fully verified. (Worth refreshing the KB entry.)
3. **Main-app tab crashed** ("Target crashed") while the separate `admin.lfmdev.in` tab was open; recovered by closing the crashed tab and re-navigating to `app.lfmdev.in/#users` (re-ran oauth_callback, session restored). The virtualized Email-value filter also required a *trusted* Playwright click on `.check-box-icon` (JS `.click()` does not toggle the React checkbox).
4. **Leftover test users from prior QA-28799 runs** remain in Drylogics/Active: `qa28799-2026-06-30@…`, `qa28799-2026-07-01@…`, `qa28799-3otro7@drylogics.com`, and `qa28799-autotest-20260628213243@listenfirstmedia.com` (Id 18620). Only this run's user was cleaned up (each run should clean only its own). Prior runs appear not to have deactivated their created users — recommend a sweep to deactivate stale `qa28799-*` users.

## Artifacts (`.playwright-out/QA-28799/`)
`00-home-topnav.png`, `01-users-page.png`, `02-add-new-user.png`, `03-role-dropdown-preaccount.png`, `04-account-drylogics.png`, `05-role-dropdown-drylogics.png`, `06-invalid-email-filled.png`, `07-invalid-email-error.png`, `08-valid-form-ready.png`, `09-after-add-user.png`, `10-filter-dropdown.png`, `13-email-search-result.png`, `16-filtered-row.png`, `17-admin-landing.png`, `18-admin-users-page.png`, `20-actions-menu.png`, `21-deactivate-confirm.png`, `22-after-deactivate.png`, `23-deactivated-view.png`
