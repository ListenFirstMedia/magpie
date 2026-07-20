# QA-130076 — Settings > Notifications - Improve Lost Authorization Messaging (Batch 9 re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-130076
- **Run date:** 2026-06-02 (batch 9 re-run)
- **Account tested:** Adam Orfei (spec says Viacom, but Viacom has 0 lost-auth notifications; Adam Orfei has 8,613 reproducing the case)
- **Priority:** Major (P3)
- **Result:** PASS 4/4 — lost-auth messaging format matches spec exactly on multiple sampled notifications.

## Pre-test setup
- Switched account: Wasserman → Viacom → Adam Orfei. Viacom path explored first per spec; after the Subscriptions > Data Collection toggle was enabled (one-time configuration per spec Note 1), Viacom still reported 0 Not Collecting notifications. Switched to Adam Orfei where lost-auth messages exist.
- Spec Note 2 ("This Test case cannot be executed on Stage") respected — dev (`lfmdev.in`) is the test environment, not Stage.

## Steps executed

| Step | Action | State |
|---|---|---|
| Pre-1 | Switch to Viacom; navigate Settings > Notifications | Viacom landing: Notifications (3) — only export-ready notifications, no lost-auth |
| Pre-2 | Subscriptions popup → Data Collection toggle ON | DOM-verified `DataCollectionMessage.checked === true`. Still 0 Not Collecting notifications post-enable. |
| Pre-3 | Switched to Adam Orfei (recent search) | 8,613 notifications |
| 1 | Settings → Notifications (Adam Orfei) | Notifications (8,613) — table loaded with multiple "NOT COLLECTING" status pills |
| 2 | Review lost-auth message format | Sampled top 4 rows |

## Sample lost-auth notifications observed on Adam Orfei

| Date | Message | Status |
|---|---|---|
| Jun 02 2026 05:15 AM | "We lost data collection on the 'TikTok Ads (Authorized)' feed for the 'TMNT (Teenage Mutant Ninja Turtles)' brand. Please click to troubleshoot." | NOT COLLECTING |
| Jun 02 2026 05:15 AM | "We lost data collection on the 'TikTok Ads (Authorized)' feed for the 'CBS Sports College Football' brand. Please click to troubleshoot." | NOT COLLECTING |
| Jun 02 2026 05:15 AM | "We lost data collection on the 'TikTok Ads (Authorized)' feed for the 'Teenage Mutant Ninja Turtles (Franchise)' brand. Please click to troubleshoot." | NOT COLLECTING |
| Jun 02 2026 05:15 AM | "We lost data collection on the 'TikTok Ads (Authorized)' feed for the 'School Spirits (Paramount+)' brand. Please click to troubleshoot." | NOT COLLECTING |
| Jun 01 2026 10:37 PM | "We lost data collection on the 'TikTok Posts (Authorized)' feed for the 'Tracker (CBS)' brand. Please click to troubleshoot." | NOT COLLECTING |
| Jun 01 2026 10:37 PM | "We lost data collection on the 'TikTok Posts (Public)' feed for the 'Saltburn' brand. Please click to troubleshoot." | NOT COLLECTING |
| Jun 01 2026 10:37 PM | "We lost data collection on the 'TikTok Posts (Public)' feed for the 'MTV Base South' brand. Please click to troubleshoot." | NOT COLLECTING |

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Notification message clearly displays the affected feed name | All sampled rows quote the feed in single quotes (e.g., 'TikTok Ads (Authorized)', 'TikTok Posts (Public)'). Feed name distinguishable from brand. | PASS |
| A2 | Notification message clearly displays the associated brand name | All sampled rows quote the brand in single quotes after "for the" (e.g., 'TMNT (Teenage Mutant Ninja Turtles)', 'Tracker (CBS)', 'Saltburn'). | PASS |
| A3 | Notification shows status "NOT COLLECTING" | Right-column New Status pill renders "NOT COLLECTING" (red exclamation icon) on all lost-auth rows sampled. | PASS |
| A4 | Notification message follows standard format: "We lost data collection on the '<feed>' feed for the '<brand>' brand. Please click to troubleshoot" | Verbatim match on every sampled row, with feed and brand each in single quotes and the closing "Please click to troubleshoot." | PASS |

## Bugs filed
None. Format and content match spec exactly.

## Findings
- Spec names Viacom as the test account but Viacom has zero Not Collecting notifications; the verification only succeeds on an account that actually has lost-auth events (Adam Orfei does, with 8,613 notifications). Recommend the spec be amended to either (a) name an account with active lost-auth events, or (b) require the runner to seed a lost-auth event before running.
- Spec Note 1 (Subscriptions > Data Collection toggle) was executed on Viacom — toggle was off; enabling it did not retroactively populate Not Collecting notifications. Toggle controls future delivery, not historical replay.

## Skill registry impact
- Reusable pattern for Settings > Notifications page (no dedicated skill yet — candidate for a future `settings-notifications` skill). Pattern: navigate `#notifications`, use Status pill filters (All / Not Collecting / Onboarding / Collecting), sample message text and right-column status pill via DOM read.

## Sources
- [QA-130076 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-130076)
