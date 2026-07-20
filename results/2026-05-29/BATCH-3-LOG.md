# Batch 3 re-run log — 2026-05-29

| Ticket | Result | Open bug verdicts | Next action |
|--------|--------|-------------------|-------------|
| QA-949 | PASS (same as prior) | (no open bugs) | None. Stories tab hover/pie/export/post-link all working on Michael Kors (account_id=328). Note: had to switch from Amazon Prime Video account (initial Adam Orfei context) to Michael Kors account because brand_id=12597 on APV doesn't have Authorized IG access; brand_id=3801 on account_id=328 does. |
| QA-24544 | PARTIAL (same as prior) | (no open bugs) | Steps 1–10 fully verified for owner side (Adam Orfei). Steps 11–15 deferred — require lfiqa@listenfirstmedia.com password sign-in which is out of scope per batch instructions. |
| QA-27854 | BLOCKED (same as prior) | (no open bugs) | LFIQA — precondition QA-27290 (bulk-tag upload) hasn't been run on dev. No Import Tags notification exists in the system; Status filter on the Notifications page doesn't even offer an Import Tags option, so there's nothing to verify. |
| QA-2035 | PASS with NEW finding | (no open bugs) | Engineering — **new finding LFMP-32xxx candidate:** Sentiment Export GS toggle delivers an identical CSV file (md5 match) via the same `analytics-cdn.lfmdev.in/<id>-<hash>.csv` URL. No Google Sheets URL is produced. Pattern matches closed APPS-48127. Also: spec A6 says time format `HH:MM XM PST` but actual is bare `HH:MM AM/PM` (likely cosmetic spec drift). |
| QA-51425 | PASS — CSV→TSV regression FIXED | (no open bugs) | Quirk should be retired from known-quirks.md. The 2026-05-27 finding (CSV downloads with TSV payload) is no longer reproducible; the downloaded `.csv` file is now genuinely comma-separated with the correct 6-column header. |

## Batch summary

- **Tickets:** 5
- **PASS:** 3 (QA-949, QA-2035 w/ finding, QA-51425)
- **PARTIAL:** 1 (QA-24544 — recipient-side deferred)
- **BLOCKED:** 1 (QA-27854 — missing precondition)
- **FAIL:** 0
- **New bugs found:** 1 (Sentiment Export GS→CSV regression, QA-2035; flagged for product/eng triage)
- **Open-bug reproductions:** 0 (no open bugs were attached to any batch-3 ticket)
- **Quirks resolved this batch:** 1 (Radaac CSV→TSV cache regression appears fixed; recommend retiring the known-quirks entry)
- **Quirks reused this batch:** 1 (`controlled-check-box` ignores synthetic clicks — used screenshot-coord workaround on QA-24544 Options checkboxes)

## Chrome MCP state for batch 4 handoff

- Tab group ID: 1432903074
- Active tab: 1804437645 — currently on Radaac "File is Ready" page (`radaac.lfmdev.in/duplicate_brand_social_pages?file_format=csv`).
- Sessions: app.lfmdev.in authenticated as Yash; radaac.lfmdev.in authenticated via Google SSO as yash.sharma@listenfirstmedia.com; Viacom account context active in app.lfmdev.in.
- Notes for batch 4: clean fresh tab is recommended given several Recent-Activity bell hovers + notifications-page navigations occurred this batch.
