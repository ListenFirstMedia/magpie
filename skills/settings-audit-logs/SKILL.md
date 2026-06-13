---
name: settings-audit-logs
version: 2
last_verified: 2026-06-08
last_passed_run: 2026-06-08
trust: untrusted
pass_streak: 3
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

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows; 0 historical defects (all closed) are catalogued there.

## v2 — Deep Linking + Brand Set Created enum + extended Activity Type vocabulary (2026-06-08)

### Deep Linking (QA-107134)

Settings > Audit supports deep-linkable URLs with `filters` (JSON-encoded) + `from` / `to` / `compare_from` / `compare_to` params.

**Example URL with `Activity = Brand Edited` filter on May 10–20, 2026 window:**
```
https://app.lfmdev.in/#audit?account_id=54
  &from=2026-05-10&to=2026-05-20
  &compare_from=2026-04-29&compare_to=2026-05-09
  &filters=%257B%2522activity%2522%253A%255B%257B%2522values%2522%253A%255B%2522Brand%2520Edited%2522%255D%252C%2522not%2522%253Afalse%252C%2522operator%2522%253A%2522or%2522%257D%255D%257D
```

Decoded `filters` payload:
```json
{"activity":[{"values":["Brand Edited"],"not":false,"operator":"or"}]}
```

**Deep-link assertions:**
- Fresh-tab nav with the full URL preserves Date Range chip + Activity chip + filtered table rows.
- Filter pill renders as `Activity: Brand Edited Include`.

### APPS-54603 — same-tab URL replace bug (REPRODUCED 2026-06-04, broader scope)

When the URL is replaced **in the same tab** (e.g., changing date range AND filter), neither the `filters` JSON nor the date range takes effect: the UI continues to show the original chip + date range. The URL bar shows new params but UI state stays stuck.

**Verdict if same-tab URL replace fails to update UI state:** APPS-54603 REPRODUCED with broader scope than the original Jira description (which said only filters fail; this run shows both filters AND date range fail).

### Brand Set Created enum addition (QA-110083)

The `Activity Type` column now exposes additional enum values beyond the original User-centric set. Verified end-to-end on 2026-06-04:

**Extended enum:**
- `User Created`
- `User Deactivated`
- `User Edited`
- `Brand Edited`
- **`Brand Set Created`** ← new in QA-110083 verification
- `Brand Set Deleted`
- `Brand Set Edited`

**Brand Set Created row format:**
```
Date         | Customer     | Business Unit | Account     | Actor       | Activity Type      | Description
Thu Jun. 04, 2026 03:24 AM PDT | ListenFirst | ListenFirst | Adam Orfei | Yash Sharma | Brand Set Created | Brand Set <name> was created.
```

The Description column preserves the brand-set name verbatim (including timestamp suffixes for test/sandbox sets).

### New audit trail rows include user-management + brand-management activities

The audit table is no longer just user-management; it now spans:
- User mutations (Created/Deactivated/Edited).
- Brand mutations (`Brand Edited`).
- Brand Set mutations (Created/Deleted/Edited).

Pattern: any mutation in Settings → Brand Sets / Users / Brands generates one audit row of the corresponding type.

## Additional Failure signatures (v2)

| Signature | Interpretation | Action |
|---|---|---|
| Same-tab URL replace doesn't update UI state | APPS-54603 REPRODUCED (broader scope: filters AND date range fail) | File against the known bug |
| Fresh-tab deep-link doesn't load filter + date range | Deep-link parser regression | File bug |
| `Activity Type` column shows unrecognized enum value | New activity type added — extend skill enum list | Skill update |
| Brand-set or user mutation does NOT generate an audit row | Audit trail dropped | File bug; cross-reference Settings mutation flow |

## Changelog
- **v2** (2026-06-08): Deep Linking via fresh tab works correctly (QA-107134); APPS-54603 same-tab URL-replace bug REPRODUCED with broader scope; `Brand Set Created` enum addition catalogued (QA-110083 with verbatim audit row format); Activity Type vocabulary extended beyond user-management to include brand + brand-set mutations.
- **v1** (2026-05-13): Initial draft from QA-20337 run. All 4 assertions verified deterministically.
