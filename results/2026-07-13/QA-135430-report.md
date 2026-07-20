# QA-135430 — Settings > Custom Metrics - Delete Functionality (MUTATING)

- **Verdict:** PASS
- **Account:** Adam Orfei (id=54) — switched from Amazon Prime Video (id=342) at run start
- **Page:** Settings > Custom Metrics (`/#custom-metrics`)
- **Run mode:** unattended / headless (Playwright MCP), 2026-07-13
- **Skill reused:** `settings-custom-metrics` (v4, untrusted) + `switch-account` (v2)
- **Test metric:** `QA-135430-rerun-1200` (unique timestamped id; formula `Comments + Engagements` = `lfm.post_engagement_score.comments_score_v5 + lfm.post_engagement_score.public_nvo_engagement_v5`)

## Known bugs checked

- `knowledge-base/bug-history.md` grep for QA-135430: entry present, **Open bugs (0)** — none. No formally-linked open Bug/Test-Failure. Rule 7 open-bug screen: PASS (ran normally).
- Case file `## Notes`: MUTATING, cleanup non-optional — honored (see A4/A5).
- No bug from the history interferes with the Delete flow; none reproduced during the run.

## Steps executed

1. Logged in (Cognito email/password, `lfiqa@listenfirstmedia.com`) → `#home`.
2. Account context was Amazon Prime Video (id=342); switched to **Adam Orfei** via the LFQA profile menu → Search Account typeahead → Results row (breadcrumb `Account: Adam Orfei` confirmed). Custom Metrics is account-gated to Adam Orfei.
3. Navigated to `/#custom-metrics`. Listing table rendered with columns in spec order: `Metric | Description | Created Date | Creator | Formula | Actions`; `Create a Custom Metric` button present.
4. Clicked `Create a Custom Metric` → `/#custom-metrics/create`. Save initially DISABLED.
5. Entered Name `QA-135430-rerun-1200`, Description `QA-135430 delete test metric`.
6. Built formula via builder: Metrics → ListenFirst → **Comments**; Operators (auto-enabled) → **+**; Metrics → ListenFirst → **Engagements**. Save became ENABLED. (screenshot `01-create-formula.png`)
7. Clicked Save → modal `Success / Custom metric successfully created!` → Ok → redirected to `/#custom-metrics`.
8. Confirmed the new row present (A1). Row count 71→72.
9. Row-actions ellipsis on the new metric → menu showed `Edit` + `Delete` (A2). Clicked Delete.
10. Confirmation dialog appeared (A3): `Delete — Are you absolutely sure you want to delete your custom metric "QA-135430-rerun-1200"? Click "Ok" to continue.` — Cancel/Ok. (screenshot `02-delete-confirm.png`)
11. Clicked Ok (`button.modal-accept-button`). Row removed from listing (A4). Row count 72→71.
12. Hard page reload (`location.reload()`) → listing re-fetched; no `QA-135430-*` row present, 71 rows (A5). (screenshot `03-post-refresh-removed.png`)

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Step 2-3 | Test metric created; appears in listing with correct name | Row present: name `QA-135430-rerun-1200`, desc `QA-135430 delete test metric`, Created Date `Jul. 13 2026`, Creator `LFQA Testing`, formula `lfm.post_engagement_score.comments_score_v5 + lfm.post_engagement_score.public_nvo_engagement_v5`. Rows 71→72 | PASS |
| A2 | Step 4 | Row-actions Delete option present | Ellipsis menu exposed `Edit` + `Delete` | PASS |
| A3 | Step 5 | Confirmation dialog appears with metric name | Dialog `Delete` — body `Are you absolutely sure you want to delete your custom metric "QA-135430-rerun-1200"? Click "Ok" to continue.`; buttons Cancel + Ok | PASS |
| A4 | Step 6 | Metric removed from listing after confirm | Row disappeared immediately; 0 matches, rows 72→71 | PASS |
| A5 | Step 7 | Removal persists after page refresh (cleanup verified) | After hard reload, 0 `QA-135430-*` rows, 71 rows total; account still Adam Orfei | PASS |

## Evidence

- Screenshots under `.playwright-out/QA-135430/`: `01-create-formula.png`, `02-delete-confirm.png`, `03-post-refresh-removed.png`.
- Created formula (verbatim from row): `lfm.post_engagement_score.comments_score_v5 + lfm.post_engagement_score.public_nvo_engagement_v5`.
- Confirmation-modal text (verbatim): `Are you absolutely sure you want to delete your custom metric "QA-135430-rerun-1200"? Click "Ok" to continue.`
- Row counts: pre-create 71 → post-create 72 → post-delete 71 → post-refresh 71.

## Cleanup (MUTATING — non-optional)

Cleanup is intrinsic to the test: the created metric `QA-135430-rerun-1200` was deleted as the assertion body and its removal verified after a hard refresh (A4/A5). No `QA-135430-*` metrics remain in the Adam Orfei listing. No orphans.

## Bugs filed

None. All assertions passed; Delete flow behaved to spec. No new defects observed; no known bug reproduced or interfered.
