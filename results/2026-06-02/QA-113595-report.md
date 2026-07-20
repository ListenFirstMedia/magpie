# QA-113595 — Settings > Audit and Admin page changes

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-113595
- **Run date:** 2026-06-04 (QA-4325 batch-9; Thursday-only test, executed on Thursday)
- **Account/User:** Adam Orfei / Yash Sharma
- **Result:** BLOCKED on safety policy
- **Skill mapped:** `settings-audit-logs`
- **Mutating:** YES (Admin page brand-title edit)

## Steps executed
1. Settings → Audit page — loaded, Audit table rendered with multi-thousand audit rows visible (Date / Customer / Business Unit / Account / Actor / Activity Type / Description columns).
2. Hovered key icon (top-right). Menu opened with Admin / Content Alerts / DCR Browser / Twitter Audience / Radaac / Internal Features / Demo Mode.
3. Clicked Admin → redirected to `auth.lfmdev.in/login?client_id=6ep4l754u2dglosjdqggbt2mjr&redirect_uri=https%3A%2F%2Fadmin.lfmdev.in%2Foauth%2Fcognito_callback` — Cognito sign-in page asking for corporate email + password OR Google/Facebook social, OR existing-account email+password.

## Why blocked
- Spec steps 2-7 require Admin page access (admin.lfmdev.in) which is gated by a separate Cognito sign-in challenge. Per environmental safety policy, the assistant cannot enter passwords or authenticate into a separate identity-provider flow.
- Steps 1 (key-icon hover), 8 (Settings → Audit nav) are verifiable and pass; the body of the test (Admin → edit brand title → re-login → verify Brand Edited audit row) requires Admin access.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A0 | preflight | Today is Thursday (spec requires Thursday-only execution) | 2026-06-04 is Thursday | PASS |
| A0b | 1 | Settings > Audit page loads | Audit page rendered with Date Range filter (May 25–31 2026), Filter dropdown, and audit-row skeleton+populated rows | PASS |
| A0c | 1 | Key icon menu opens with Admin option | Key-icon menu opened: Admin, Content Alerts, DCR Browser, Twitter Audience, Radaac visible | PASS |
| A0d | 2 | Admin page reachable | Admin page redirected to Cognito sign-in (`auth.lfmdev.in/login`) requiring password — cannot bypass per safety policy | BLOCKED |
| A6 | 6 | Brand is updated | Cannot execute (Admin gated) | NOT VERIFIED |
| A8a | 8 | Audit Actor column displays your name | Cannot execute (would-be audit row not generated) | NOT VERIFIED |
| A8b | 8 | Activity Type = 'Brand Edited' | Cannot execute | NOT VERIFIED |
| A8c | 8 | Description = 'Brand #{brand name} metadata was edited.' | Cannot execute | NOT VERIFIED |

## Notes
- Existing audit-row format (verified via prior batches QA-107134 / QA-110083) supports the same Activity Type enum extension and Date / Customer / Business Unit / Account / Actor / Activity Type / Description columns. Live audit rows for `Brand Set Created`, `Brand Set Deleted`, `User Activated`, `User Deactivated` rendered as expected on 2026-06-04. No Brand Edited row generated for this run because the prerequisite Admin edit could not be performed.
- Recommend: LFIQA executes the Admin half manually and re-confirms audit-row generation. Alternatively, expose a dev-only auth-bypass for admin.lfmdev.in to enable automation.

## Bugs filed
- None.
