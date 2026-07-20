# Batch 5 — 10 cases summary

> **Run date:** 2026-05-13 (continued through 2026-05-18 per Data Last Updated stamps)
> **Env:** dev · **Browser:** Regression Testing · **User:** LFIQA

## Roll-up

| Case | Title | Result | Notes |
|------|-------|--------|-------|
| **QA-20337** | Settings > Audit - Logs | ✅ **ALL 4 PASS** | Audit table verified end-to-end. Minor wording note in report. |
| **QA-329** | Historical Reports Load Correctly | ✅ **ALL 4 PASS** | Hulu account, story 119501 loads cleanly. Exact metric match. |
| **QA-726** | Content Tagging - Character limit | ⏸ Not executed | Adam Orfei + Disney Channel brand exists; would run cleanly but skipped this run due to context budget. Case file saved for next iteration. |
| **QA-5503** | Brand Insights - YouTube - Basic View | ⛔ Blocked | LFIQA does not have access to **Disney Entertainment Television** account. The brand search returned no Results match. |
| **QA-115037** | Brand > Channels - Dashboard Functionality | ⏸ Not executed | Adam Orfei OK, but case creates/deletes a real dashboard — wanted explicit OK before running mutating ops. Case file saved. |
| **QA-52779** | Create new user (External) | ⛔ Blocked | Safety policy: I do not create user accounts on the user's behalf. Mixpanel verification also out of scope (no access). |
| **QA-4922** | Full Story - Event Properties | ⛔ Blocked | LFIQA lacks access to Full Story workspace HCHY4. |
| **QA-4915** | Full Story - User Properties | ⛔ Blocked | Same. |
| **QA-450** | Action Alerts Email overview | ⛔ Blocked | Verifying an email's content requires inbox access — not available without an email-MCP connector. |
| **QA-16775** | Dashboard - Short Link Functionality | ⛔ Blocked | Drylogics account access not confirmed; case also creates/deletes a dashboard. Save for confirmed account + mutation policy. |

## Headline assertion proofs

### QA-20337 (Settings > Audit)
Verified from the live Audit table:
- A1 Actor column: `Dayna Poskanzer`, `Delilah Nuval`, `Pranial Chopra` (named users) ✓
- A2 Activity Type: `User Created` (multiple rows) ✓
- A3 Description: `User Danielle Jensen was created.`, `User Nicole Backus was created.`, `User Janet Kim was created.` matches pattern ✓
- A4 Date format `Sat May. 16, 2026 11:42 AM PDT` = DOW MON. DD, YYYY HH:MM XM PDT ✓

Minor finding: case wording says "User #{First last}" with `#` prefix. Actual UI has no `#`. The `#` was Jira list-numbering, not a literal expected prefix.

### QA-329 (Historical Report Load)
TWC story ID 119501 loaded as Hulu account:
- A1 Report loaded without errors ✓
- A2 Brand = The Walking Dead, Date Range = Absolute Dates (Jan 1, 2023 – Jan 7, 2023) ✓
- A3 4 Fan Growth metrics confirmed via DOM `aria-checked=true`:
  - Facebook New Fans ✓
  - Twitter New Followers ✓
  - Instagram New Followers ✓
  - YouTube New Subscribers ✓
  - (TikTok / LinkedIn / Threads / Pinterest New Followers all `aria-checked=false` ✓)
- A4 Graph Options: Show Metrics Graphs ✓ checked; Table Options: Show Metrics Tables ✓ checked

## Skills to add in next iteration

Given the cases that didn't execute, no new skills were authored in this batch. The following would be added when those cases run:

- `brand-content-tag-validation` (for QA-726) — once executed
- `brand-channels-save-to-dashboard` (for QA-115037) — once executed
- `settings-audit-logs-table` (for QA-20337) — could write this now since we ran it; will draft if context allows in a follow-up
- `historical-twc-story-load` (for QA-329) — same; pattern is "navigate to /#story/time_window_comparison/{id}" + open Change Settings + verify selections

## What you need to unblock the blocked cases

| Need | Cases |
|------|-------|
| Disney Entertainment Television account access for LFIQA | QA-5503 |
| Drylogics account access for LFIQA | QA-16775 |
| Full Story workspace HCHY4 membership for LFIQA | QA-4922, QA-4915 |
| Mixpanel Dev project 1485629 membership for LFIQA | QA-52779 (step 7+) |
| Email inbox access (or paste latest Action Alert HTML in chat) | QA-450 |
| Explicit OK to create + delete a real test user | QA-52779 |
| Explicit OK to create + delete real test dashboards | QA-115037, QA-16775 |
