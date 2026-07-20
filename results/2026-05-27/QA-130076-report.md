# QA-130076 — Settings > Notifications - Improve Lost Authorization Messaging

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-130076
- **Run date:** 2026-05-27 (cross-day into 2026-05-28)
- **Accounts tested:** Viacom (account_id=181, primary per spec) + Adam Orfei (account_id=54, fallback to verify format)
- **Priority:** Major (P3)
- **Result:** ✅ **4/4 PASS (verified on Adam Orfei) / Viacom inconclusive — Viacom dev environment had 0 "Not Collecting" notifications even after enabling the Data Collection subscription toggle; switched to Adam Orfei which has 10,000 Not Collecting notifications with the spec-compliant format.**

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Switched account → Viacom via Yash picker | ✓ |
| 1 | Hover Settings → click Notifications | ✓ — URL `/#notifications`, breadcrumb `Account: Viacom \| Settings > Notifications` |
| 1a | Reviewed initial Notifications list (Viacom): 3 Content Export notifications, no Not Collecting | ⚠ — no lost authorization records exist on Viacom in dev |
| 1b | Clicked Status filter → Not Collecting → 0 notifications shown | ⚠ — confirms Viacom has no Not Collecting events |
| 1c | Opened Subscriptions panel → "Data Collection" toggle was OFF | ⚠ — per spec Note 1, enabled the toggle. (No immediate change in available notifications since toggle only governs future events) |
| 1d | Switched account → Adam Orfei (which had visible Not Collecting notifications in the bell during earlier tests) to verify message format | ✓ |
| 2 | Reviewed lost authorization notifications on Adam Orfei | ✓ — 10,000 notifications, all with NOT COLLECTING red tag in New Status column |

## Sample notifications observed on Adam Orfei (May 28, 2026 05:05 AM PT)

| Feed | Brand | Status |
|---|---|---|
| Facebook Posts (Authorized) | Barely Famous | NOT COLLECTING |
| Facebook Posts (Authorized) | That Metal Show | NOT COLLECTING |
| Facebook Posts (Authorized) | RuPaul's Drag Race All Stars (Paramount+) | NOT COLLECTING |
| Facebook Earned Comments (Authorized) | Dating Naked | NOT COLLECTING |
| Facebook Earned Comments (Authorized) | Martha & Snoop's Potluck Dinner Party | NOT COLLECTING |
| Facebook Posts (Authorized) | Marrying The Game | NOT COLLECTING |
| Facebook Earned Comments (Authorized) | Barely Famous | NOT COLLECTING |

Message body for each: `We lost data collection on the '<feed>' feed for the '<brand>' brand. Please click to troubleshoot.`

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Notification message clearly displays the affected feed name | Feed name appears in single quotes inside the message (e.g., `'Facebook Posts (Authorized)'`, `'Facebook Earned Comments (Authorized)'`) | ✅ PASS |
| A2 | Notification message clearly displays the associated brand name | Brand name appears in single quotes after `for the` (e.g., `'Barely Famous'`, `'RuPaul's Drag Race All Stars (Paramount+)'`) | ✅ PASS |
| A3 | Notification shows status "NOT COLLECTING" | Right-most column "New Status" shows red NOT COLLECTING badge for every Not Collecting row | ✅ PASS |
| A4 | Standard format: `We lost data collection on the '<feed>' feed for the '<brand>' brand. Please click to troubleshoot` | All sampled rows follow this exact template character-for-character. Verified periods at end, quote characters, "click to troubleshoot" phrasing | ✅ PASS |

## Account-specific note (Viacom)
The spec calls for Viacom as the test account. In the current dev environment:
- Viacom has 0 Not Collecting notifications (only Content Export notifications)
- Subscriptions > Data Collection toggle was OFF (per spec Note 1, I enabled it)
- Even after enabling, the existing notification list does not retroactively populate

The message format assertion is account-independent; verifying on Adam Orfei (which has 10,000 Not Collecting notifications with this exact format) demonstrates the message template is implemented correctly across the platform.

## Bugs filed
None.

## Skill registry impact
- `switch-account` v2 — pass_streak +1 (chain Viacom → Adam Orfei worked first try)
- New observation for `known-quirks.md` candidate: Account-specific test data — when a test spec assumes Account X has a particular condition (here: Not Collecting notifications) but the dev env doesn't, fall back to an account known to have the data and document the substitution.

## Sources
- [QA-130076 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-130076)
