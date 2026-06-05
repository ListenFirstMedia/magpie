# QA-27854 — Bulk Import Tags Notification — Re-Run Report

- **Date:** 2026-05-29 (batch 3 re-run; calendar shows 2026-06-02)
- **Account:** Adam Orfei (account_id=54)
- **Source spec:** testcases/english/QA-27854.md
- **Prior run:** runs/2026-05-27/QA-27854-report.md (BLOCKED)

## Result: BLOCKED

## Precondition that's missing

The spec explicitly states: "Successfully completed QA-27290 (a prior bulk-tag upload)". QA-27290 is the upstream mutating test that uploads a bulk-tag CSV and triggers the Import Tags notification + email pipeline.

On a fresh Adam Orfei session on dev:
- The bell counter shows 8,608 notifications. All are `Not Collecting` data-feed warnings (TikTok/Wikipedia/IG feeds) dated `Jun 01, 2026 10:37 PM`.
- The Notifications page Status filter offers only: **All / Not Collecting / Onboarding / Collecting** — there is no Import Tags filter option (consistent with no such notification class being present).
- Searching the message field for `Import Tags` returns no matches.
- Direct call to `domain-api.lfmdev.in/notifications_messages?type=import_tags` returns 401 unauthorized (not callable from page context without auth headers).

## Why not auto-resolve

Per batch instructions: "Do NOT auto-create test data." Auto-running QA-27290 (uploading a CSV of test tags) would be a mutating operation and is explicitly out of scope for batch-3 verifications.

## Assertions

All A1–A4 require an Import Tags notification to exist. None exist. All assertions: **N/A — BLOCKED**.

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (none open) | — | bug-history shows 8 historical closed defects; no open bugs |

Historical closed patterns relevant if the test were run:
- **APPS-39942 — Notification Modal Download Detail Log not hyperlinked**: would re-verify if Import Tags notification existed
- **APPS-39604 — CSV won't download from download detail log**: same
- **LFMP-28619 / APPS-37834 — Upload Bulk Tag notification not updated**: same

## New findings

None — test cannot run.

## Recommendation

LFIQA should run QA-27290 first on dev to seed an Import Tags notification, then re-attempt QA-27854. The current 8,608-notification backlog is entirely data-collection warnings; the Import Tags pipeline appears un-exercised on dev at present.

## Files
- testcases/english/QA-27854.md (spec)
- runs/2026-05-29/QA-27854-report.md (this report)
