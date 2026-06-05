# QA-130076 — Settings > Notifications - Improve Lost Authorization Messaging (Batch 10 re-confirm 2026-06-04)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-130076
- **Run date:** 2026-06-04 (QA-4325 batch-10 re-confirm)
- **Account tested:** Adam Orfei (account_id=54)
- **Skill:** none (candidate `settings-notifications`)
- **Result:** PASS 4/4 — re-confirmed consistency with V2 sweep (2026-06-02 batch-9).

## Pre-test
Followed V2 conclusion that Adam Orfei has the lost-auth events (Viacom has 0). Tab opened on Adam Orfei context already (from prior batch-9 run; switch-account skill confirms session sticky).

## State

- Notifications page header: **"Notifications (8,414)"** (vs 8,613 in batch-9 — net –199 over ~48 h; consistent with read/delete activity).
- Account banner: `Adam Orfei`.

## Sample lost-auth notifications observed (2026-06-04 run)

| Date | Message | Status |
|---|---|---|
| Jun 03 2026 11:20 PM | We lost data collection on the 'Facebook Earned Comments (Authorized)' feed for the 'Comedy Central (Australia & New Zealand)' brand. Please click to troubleshoot. | NOT COLLECTING |
| Jun 03 2026 11:20 PM | We lost data collection on the 'Instagram Mentions (Authorized)' feed for the 'Venom: Let There be Carnage' brand. Please click to troubleshoot. | NOT COLLECTING |
| Jun 03 2026 11:20 PM | We lost data collection on the 'TikTok Posts (Authorized)' feed for the 'Pluto TV' brand. Please click to troubleshoot. | NOT COLLECTING |
| Jun 03 2026 11:20 PM | We lost data collection on the 'Instagram Mentions (Authorized)' feed for the 'Workaholics' brand. Please click to troubleshoot. | NOT COLLECTING |
| Jun 03 2026 11:20 PM | We lost data collection on the 'Wikipedia Page (Public)' feed for the 'Key & Peele' brand. Please click to troubleshoot. | NOT COLLECTING |

## Assertions

| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Feed name displayed clearly | Single-quoted feed (e.g. `'Facebook Earned Comments (Authorized)'`, `'TikTok Posts (Authorized)'`, `'Wikipedia Page (Public)'`) on every sampled row | PASS |
| A2 | Brand name displayed clearly | Single-quoted brand after "for the" (e.g. `'Comedy Central (Australia & New Zealand)'`, `'Venom: Let There be Carnage'`, `'Pluto TV'`, `'Workaholics'`, `'Key & Peele'`) | PASS |
| A3 | Status = NOT COLLECTING | Right-column pill renders `NOT COLLECTING` on all 5 sampled lost-auth rows | PASS |
| A4 | Format: "We lost data collection on the '<feed>' feed for the '<brand>' brand. Please click to troubleshoot" | Verbatim match on every sampled row, with trailing period | PASS |

## Drift vs V2 sweep (2026-06-02 batch-9)
- Total notification count drifted 8,613 → 8,414 (–199). Expected business turnover; not a regression.
- Messaging format identical: same wording, same single-quote style, same NOT COLLECTING status pill.
- Sampled feeds differ (this run featured Wikipedia Page (Public) for the first time alongside the prior TikTok/Facebook/Instagram set) — all conform to the standard template.

## Bugs filed
None. No drift detected.

## Sources
- Prior PASS: `runs/2026-05-29/QA-130076-report.md`, `runs/2026-06-02/QA-130076-RERUN-report.md` (batch-9)
