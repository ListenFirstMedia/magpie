# QA-22296 Prep Log — Daily Regression Test Set - 3

**Date:** 2026-06-05
**Phase:** Setup only. No tests executed. No Jira tickets created.

## Test set confirmation
- Key: QA-22296
- Issue type: **Xray Test Set** (confirmed via `getJiraIssue`)
- Summary: "Daily Regression Test Set - 3"
- Description: "This is a regression test set for Rajesh"
- Status: Defined

## Member discovery
- **Method that worked:** JQL `issue in testSetTests("QA-22296") ORDER BY key ASC` (Xray operator) — same as QA-4325.
- Returned via 2 pages (50 + 9).
- **Total members: 59**
- Members file: `runs/2026-06-02/QA-22296-members.md`

## Bug-link enrichment
- Per-member `getJiraIssue` calls with `fields=["issuelinks"]` for all 59 members.
- Extracted Bug + Test-Failure links via jq / python (filtered on `issuetype.name == "Bug" || "Test Failure"`).
- Appended to `knowledge-base/bug-history.md` under new section `# QA-22296 Daily Regression Test Set - 3 (2026-06-05)`.
- Members with >=1 open Bug/Test-Failure: **6**
  - QA-923, QA-947, QA-6315, QA-19950, QA-23991, QA-83977
- Distinct open bug keys: **7** (all LFMP-*)
- Members with no Bug/Test-Failure links (clean tests): ~33 (mostly the QA-13xxxx Tag Filter and timestamp tests, plus the recent QA-137xxx custom-metric operators tests).

## Top open bugs by priority
**Major (6):**
- LFMP-31800 — Brand > Conversation - "Click here to load Tweets" navigates to the Listening page (QA-6315)
- LFMP-31814 — Reporting > Data Studio - Data fetching pop-up is not displayed (QA-83977)
- LFMP-31857 — Brand Content - twitter post text having link (QA-923)
- LFMP-31915 — Brand > Content > Instagram Image Posts Tooltip Is Empty (QA-923)
- LFMP-31979 — Thumbnail Issue for Facebook and Pinterest Posts (QA-19950)
- LFMP-32010 — Reporting > Content performance > Least Engaging Posts & Heading Does not show in "Preview & Share Report" (QA-23991)

**Minor (1):**
- LFMP-31781 — Brand Insights - Hovering Functionality - twitter icon color is blue (QA-947)

(No Critical / High / Trivial open bugs linked from this set.)

## API calls used
- 1 × `getJiraIssue` for QA-22296 itself (test set metadata).
- 2 × `searchJiraIssuesUsingJql` (page 1 of 50, page 2 of 9 via nextPageToken).
- 59 × `getJiraIssue` for member issuelinks (one per member; ~10 spilled to tool-result files, parsed via jq).
- **Total: ~62 Jira calls**, in line with the budget (1 + member-count).

## Tests not fully fetched
None — every member returned a 200 with `issuelinks` field. A few large responses (QA-199, QA-2042, QA-6315, QA-19950, QA-22072, QA-23991, QA-24021) spilled to disk and were parsed via jq from the spill files. The shorter inline responses were parsed by hand into the per-member link files.

## Overlap analysis vs prior sweeps

### vs QA-4325 (the prior 56-member set)
- Overlap: **4 members**
  - QA-133403
  - QA-134176
  - QA-134271
  - QA-134296
- These 4 were re-tested in the QA-4325 sweep (batches 10–11). All four are flagged in bug-history.md as completed re-runs.

### vs original 59-ticket sweep at runs/2026-05-27/
- Overlap: **4 members**
  - QA-85176
  - QA-131491
  - QA-132387
  - QA-132392
- All four have prior `<key>-report.md` files in `runs/2026-05-27/`.

### Net new in QA-22296 (not in either prior sweep)
- **51 of 59 members** are net new and have **never been run** through magpie before.
- Notable new areas: Brand > Channels Threads, Settings > Data Identities Threads, Brand > Insights Threads tile-level export, Settings > Audit external-user view, Sentiment Export Email/Notification, Brand Content Instagram Collaborator filter, Brand Set Sum/Avg rows, Brand/Stories/Paid layered tag filtering, Listening timestamp, Custom Metrics edit + multiplication/division operators, Channel Collection Status.

## Files written
- `runs/2026-06-02/QA-22296-members.md` — numbered member list with summaries (59 entries)
- `knowledge-base/bug-history.md` — appended QA-22296 section (~650 new lines)
- `runs/2026-06-02/QA-22296-PREP-LOG.md` — this file

## Go / No-go
Ready for go/no-go decision. No tests executed; no batch task list created. Awaiting user decision on whether to schedule batches.
