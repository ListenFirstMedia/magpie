# QA-130076 — Settings > Notifications - Improve Lost Authorization Messaging

- **Run date:** 2026-07-08 (headless, unattended, Playwright MCP track, branch `feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-130076
- **Account:** Viacom (`account_id=181`) — precondition met via account switch
- **Verdict:** **BLOCKED — test-data gap (no lost-authorization / NOT COLLECTING notification exists on Viacom).** Not a product bug. Assertions A1–A4 are Not Evaluable (no message instance to review).
- **Open-bug screen:** "None open. Screen only — run normally." → ran normally.

## Summary

The Settings → Notifications feature, its **Status** filter, and the **Subscriptions → Data Collection** control all work. However, Viacom currently has **no feed in a lost-authorization state**, so **no "We lost data collection…" / NOT COLLECTING notification** exists to review. All 58 present notifications are Export ("…is now ready") / Fetch-job ("…completed successfully") for brand MTV. With **Status = Not Collecting**, the list returns **Notifications (0)**. Therefore A1–A4 have no lost-auth message instance to assert against.

This reproduces the documented known-quirk (2026-07-01) exactly; its revisit-trigger (a Viacom feed loses authorization and generates a Not-Collecting notification) is **still not met**. Per spec-adherence Rules 1/3/5, no substitute account/notification was used.

## Steps executed

| # | Step | Result |
|---|------|--------|
| Pre | Programmatic Cognito email/password login → `app.lfmdev.in/#home` (title "Home - ListenFirst") | PASS |
| Pre | Switch account Adam Orfei → **Viacom** via LFQA menu → Search Account → Results row | PASS — URL `account_id=181`, breadcrumb `Account: Viacom` |
| 1 | Settings (top nav) → **Notifications** from dropdown → `#notifications` | PASS — page rendered, `Notifications (58)`, table cols **Date / Message / New Status**, filters **Status** + **Unread**, tabs **Notifications / Subscriptions** |
| 2 | Review lost-authorization notification message | **No lost-auth message present.** Applied **Status = Not Collecting** → `Notifications (0)`. Checked **Subscriptions** tab → **Data Collection** subscription toggle is **OFF**. |

## Assertions (step 2)

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Notification message clearly displays the affected **feed name** | No lost-authorization notification exists on Viacom (Status=Not Collecting → 0; all 58 are Export/Fetch for MTV) | **Not Evaluable (BLOCKED)** |
| A2 | 2 | Notification message clearly displays the associated **brand name** | Same — no lost-auth message instance to review | **Not Evaluable (BLOCKED)** |
| A3 | 2 | Notification shows status **"NOT COLLECTING"** | "Not Collecting" status filter returns **Notifications (0)**; no NOT COLLECTING badge present | **Not Evaluable (BLOCKED)** |
| A4 | 2 | Message follows format: *"We lost data collection on the '&lt;feed&gt;' feed for the '&lt;brand&gt;' brand. Please click to troubleshoot"* | No message matching "lost data collection" / "troubleshoot" found in any of the 58 notifications | **Not Evaluable (BLOCKED)** |

## Evidence

- **Account context:** URL `#home?account_id=181…`, breadcrumb `Account: Viacom`.
- **Notifications page:** `Notifications (58)`; columns Date / Message / New Status. Top rows (representative):
  - `Jul 08, 2026 11:57 AM — Fetch job 301330 has completed successfully.`
  - `Jul 08, 2026 08:33 AM — Your Content Export with Select Data Sets for MTV from Apr. 01, 2026 to Apr. 07, 2026 is now ready. Download file.`
  - `Jul 08, 2026 07:16 AM — Your Sentiment Export for MTV from Jun. 30, 2026 to Jul. 06, 2026 is now ready. Download file.`
  - All remaining visible rows are Content/Sentiment/Paid Export "…is now ready" or Fetch-job "…completed successfully" (brand MTV). No "lost data collection" / "troubleshoot" / "NOT COLLECTING" text anywhere in the body.
- **Status filter options:** All / **Not Collecting** / Onboarding / Collecting (Data Collection group).
- **Status = Not Collecting →** `Notifications (0)`.
- **Subscriptions tab:** "You will receive notifications for all active subscriptions below." → **Data Collection** subscription toggle **OFF** (`checked=false`). Precondition Note 1 (enable the Data Collection subscription) governs **future** delivery only and does not backfill historical lost-auth events, so it cannot populate the table for this run.
- **Screenshots** (under `.playwright-out/QA-130076/`):
  - `step1-notifications-page.png` — Notifications page, 58 notifications, all Export/Fetch.
  - `step2-notifications-initial.png` — full notifications list (Status=All).
  - `step2-not-collecting-zero.png` — Status=Not Collecting → Notifications (0).
  - `step2-subscriptions-data-collection.png` — Subscriptions tab, Data Collection toggle OFF.

## Why BLOCKED and not FAIL (Rules 1/3/5)

The assertions test message **content/format** of a lost-authorization notification. With no such notification generated on Viacom, the assertions have no subject — this is a **test-data / data-collection gap**, not a product defect. Filing a bug here would repeat the QA-91412 false-positive pattern. No substitute account, brand, or notification type was used. The Notifications feature itself (list render, Status filter incl. "Not Collecting", Subscriptions/Data Collection control) is functioning correctly.

**To unblock:** LFIQA/product must provision a Viacom feed in a lost-authorization state (so a NOT COLLECTING notification is generated), or retarget the spec to an account/feed that currently carries a live lost-auth notification. A1–A4 are otherwise data-independent format checks and will be evaluable once such a notification exists.

## Bugs filed

None. This is a test-data gap, not a defect — consistent with the known-quirks entry dated 2026-07-01 (QA-130076), whose revisit-trigger remains unmet. No Jira ticket created.
