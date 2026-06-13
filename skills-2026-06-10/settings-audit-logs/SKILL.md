---
name: settings-audit-logs
version: 2
last_verified: 2026-06-10
trust: untrusted
pass_streak: 2
preconditions: [user-logged-in]
postconditions: [audit-table-rendered]
related_pages: ["/#audit"]
---

# Settings > Audit log table

Columns: Date | Customer | Business Unit | Account | Actor | Activity Type | Description.

## Steps
1. Direct URL `https://app.lfmdev.in/#audit?account_id={account_id}` (or Settings → Audit). Skeletons → rows in 5-10 s.
2. Read rows: `[...document.querySelectorAll('[role="row"], tr')]` works (real table).

## Assertion patterns (v2, broadened)
- **Date:** `/^(Mon|Tue|Wed|Thu|Fri|Sat|Sun) [A-Z][a-z]+\. \d{1,2}, \d{4} \d{1,2}:\d{2} (AM|PM) [A-Z]{3,4}$/` (e.g. `Tue Jun. 09, 2026 04:42 PM PDT`).
- **Activity Type enum (v2):** `User Created|User Edited|User Activated|User Deactivated|Brand Created|Brand Edited|Brand Deleted|Brand Set Created|Brand Set Edited|Brand Set Deleted` (filter checkbox list is the source of truth).
- **Description templates (v2):** `User X was created/deactivated.`, `User X's metadata was edited.`, `Brand Set Y was created/deleted.` Old regex `/^User .+ was (created|deactivated|edited)\.$/` is too narrow.
- **Actor** may be two-word names or org-style names ("LFQA Testing", "Zain LFI").

## Filter flow (v2, verified)
1. Filter `Select` dropdown → field list: Account, Activity, Activity Log, Actor, Business Unit, Customer.
2. Pick `Activity` → child checkbox panel (Or/And radio + activity types) → check value(s).
3. `Apply Filter` → green chip `Activity: User Edited [Include]`; rows filter; URL gains encoded `filters` param. `Clear All` resets.

## Changelog
- **v2** (2026-06-10): broadened enums/templates; documented filter flow + URL param; PASS QA-20337.
- **v1** (2026-05-13): initial.
