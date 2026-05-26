---
name: settings-audit-logs
version: 1
last_verified: 2026-05-13
last_passed_run: 2026-05-13
trust: untrusted
pass_streak: 1
preconditions: [user-logged-in]
postconditions: [audit-table-rendered]
inputs: []
outputs: [audit_rows]
related_pages: ["/#audit"]
---

# Settings > Audit log table

The Settings > Audit page shows a paginated log of user-management activity (creates, deactivations, edits, etc.). Each row has:

| Column | Format / Example |
|--------|------------------|
| Date | `DOW MON. DD, YYYY HH:MM XM PDT` (e.g., `Sat May. 16, 2026 11:42 AM PDT`) |
| Customer | Free-text — the customer organization name |
| Business Unit | Free-text — sub-organization |
| Account | Free-text — account name |
| Actor | First-last name of the user who performed the action |
| Activity Type | `User Created` / `User Deactivated` / `User Edited` (enum) |
| Description | Templated: `User {First Last} was {action}.` |

## Steps

### Step 1 — Navigate
- Direct URL: `https://app.lfmdev.in/#audit?account_id={account_id}` (or Settings → Audit)

### Step 2 — Wait for table to load
- The page shows skeleton bars while loading. Audit table populates within 5-10s.

### Step 3 — Read rows
```javascript
const rows = [...document.querySelectorAll('[role="row"], tr')]
  .filter(r => r.offsetWidth > 0 && /User\s+\w+\s+\w+\s+was/.test(r.textContent||''))
  .map(r => (r.textContent || '').trim().replace(/\s+/g, ' '));
```

## Assertion patterns

For tests like QA-20337 (verify table content):

- **Actor format:** matches `/^[A-Z][a-z]+ [A-Z][a-z]+$/` (two-word capitalized name)
- **Activity Type:** matches one of `["User Created", "User Deactivated", "User Edited"]`
- **Description:** matches `/^User .+ was (created|deactivated|edited)\.$/`
- **Date format:** matches `/^(Mon|Tue|Wed|Thu|Fri|Sat|Sun) [A-Z][a-z]+\. \d{1,2}, \d{4} \d{1,2}:\d{2} (AM|PM) [A-Z]{3}$/`

If a test asserts "the user's name has been added to Actor" with no specific name, take any non-empty Actor cell that matches the name pattern as a pass.

## Known quirks

- The Description column omits the `#` prefix sometimes present in Jira case text — `#{First last}` in Jira is list-numbering syntax, not an expected prefix in the actual UI.
- "User Created" rows often pair with "User Deactivated" rows soon after — testing teams typically create then deactivate the test user.

## Changelog
- **v1** (2026-05-13): Initial draft from QA-20337 run. All 4 assertions verified deterministically.
