---
ticket: QA-113594
title: Settings > Audit - External User View
date: 2026-06-08
batch: QA-22296 batch 7
operator: magpie
result: BLOCKED (external-user role gated; Admin-auth boundary blocks new-account setup)
skill: settings-audit-logs (n/a — cannot reach as external user)
---

## Steps
1. Login as Yash (internal user) on `app.lfmdev.in`. PASS.
2. Spec asks to view Settings > Audit as an EXTERNAL user (non-internal LF account). This requires either (a) provisioning a fresh external account, OR (b) logging in as a known external user. Both paths involve Admin (admin.lfmdev.in) operations that are gated by a separate Cognito SSO challenge (see known-quirks "Admin page gated by Cognito sign-in challenge" 2026-06-04 entry).
3. magpie cannot enter Admin passwords per safety policy. The previous QA-4325 batch-9 confirmed QA-113595 and QA-113722 are blocked by the same Admin/Cognito boundary.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | External-user role can reach Settings > Audit | External user lands on `#audit` page with audit row table | Cannot provision external user — Admin-gated | BLOCKED |
| A2 | Audit page columns + filters render for external user | Same column schema as internal-user view | NOT VERIFIED | BLOCKED |
| A3 | External user can or cannot filter by Activity Type | Per spec | NOT VERIFIED | BLOCKED |

## Evidence
- Known-quirks documents the Admin gating: `app.lfmdev.in` → key-icon → Admin redirects to `auth.lfmdev.in/login?client_id=6ep4l754u2dglosjdqggbt2mjr&redirect_uri=https%3A%2F%2Fadmin.lfmdev.in%2Foauth%2Fcognito_callback`. Yash session does not auto-pass through.
- Prior runs QA-113595 + QA-113722 (QA-4325 batch-9 2026-06-04) hit the same Admin-auth blocker and were marked BLOCKED.

## Bugs filed
None. Carry-forward blocker: External-user role provisioning requires Admin-page mutation that magpie cannot perform under current safety policy. LFIQA must execute manually and confirm audit-row visibility for an external user.

## Skill maintenance
- `settings-audit-logs`: no streak bump — not reached in this batch.
