# QA-130076 — Settings > Notifications - Improve Lost Authorization Messaging

- **Run:** 2026-07-12 (unattended, headless, Playwright MCP, `feature/playwright-mcp`)
- **Environment:** `app.lfmdev.in` (dev). Note 2 satisfied — not run on Stage.
- **Account:** Viacom (account_id=181) — precondition met via account switch from Wasserman (863) → Viacom through the LFQA menu Search Account → Results row.
- **Skill:** none mapped (candidate `settings-notifications`) — flow driven directly. **Skill/REGISTRY maintenance deferred to harvest.sh per run instructions.**
- **Verdict:** **PASS (4/4)**

## Preconditions
- Logged in as config/.env identity (lfiqa@listenfirstmedia.com); session on **Viacom** confirmed (breadcrumb "Account: Viacom", URL `account_id=181`).
- Note 1 (Subscriptions → Data Collection toggle, one-time config): not required this run — Viacom already carries **80** live lost-authorization notifications, so the review target exists without enabling the subscription. (Enabling it only governs *future* delivery; it does not backfill.)

## Steps executed
1. **Settings top-nav → Notifications** (hover Settings dropdown → click `#notifications`). Page rendered (title "Settings Notifications - ListenFirst: Notifications"). Header reads **"Notifications (182)"**; a **Status** filter control and a **Search messages** box are present; table columns are **[unread-icon] | Date | Message | New Status**.
2. **Reviewed the lost-authorization notification message(s).** 80 lost-auth rows present in the main table. Representative rows (verbatim from DOM + screenshot):
   - `Jul 11, 2026 10:36 PM` — "We lost data collection on the 'Facebook Posts (Authorized)' feed for the 'The Andy Griffith Show' brand. Please click to troubleshoot." — **NOT COLLECTING**
   - `Jul 11, 2026 10:36 PM` — "We lost data collection on the 'TikTok Ads (Authorized)' feed for the 'FBI' brand. Please click to troubleshoot." — **NOT COLLECTING**
   - `Jul 11, 2026 10:36 PM` — "We lost data collection on the 'Facebook Page & Audience (Authorized)' feed for the 'The Borgias' brand. Please click to troubleshoot." — **NOT COLLECTING**

## Evidence
- Row DOM: `<tr><td><i class="fas fa-circle read-icon"></i></td><td class="date">Jul 11, 2026 10:36 PM</td><td class="message-text">We lost data collection on the 'TikTok Ads (Authorized)' feed for the 'FBI' brand. Please click to troubleshoot.</td><td><span class="status-pill red red"><span class="icon fas fa-exclamation-circle"></span><span class="pill-label">Not Collecting</span></span></td></tr>`
- Status pill: `.status-pill.red` with `.pill-label`; DOM text "Not Collecting", `text-transform: uppercase` → **renders "NOT COLLECTING"** (confirmed via computed style + screenshot).
- Count: **80** rows matching `We lost data collection …` in the Settings>Notifications table (out of 182 total notifications; the rest are Sentiment/Content Export "…is now ready" + Fetch-job entries for MTV).
- Screenshot: `.playwright-out/QA-130076/notifications-lost-auth.png` (shows header, Status filter, column headers, and multiple lost-auth rows with red NOT COLLECTING pills).

## Assertions (step 2)

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Review message | Message clearly displays the affected **feed name** | Feed shown in quotes: 'Facebook Posts (Authorized)', 'TikTok Ads (Authorized)', 'Facebook Page & Audience (Authorized)', … (feed + perspective) | PASS |
| A2 | Review message | Message clearly displays the associated **brand name** | Brand shown in quotes: 'The Andy Griffith Show', 'FBI', 'The Borgias', 'Gunsmoke', … | PASS |
| A3 | Review message | Status shows **"NOT COLLECTING"** | New-Status column renders red `status-pill` with label **NOT COLLECTING** (uppercase) on every lost-auth row | PASS |
| A4 | Review message | Format: "We lost data collection on the '<feed>' feed for the '<brand>' brand. Please click to troubleshoot" | Verbatim match: **"We lost data collection on the '<feed> (Authorized)' feed for the '<brand>' brand. Please click to troubleshoot."** (feed carries the `(Authorized)` perspective qualifier; trailing period) | PASS |

## Known bugs checked
- **Case "## Open linked bugs":** "None open. Screen only — run normally." → Rule 7 screen passed.
- **bug-history.md (grep QA-130076):** no open defects; prior runs recorded as PASS 4/4 (2026-05-27/29, 2026-06-04 QA-4325 batch-10 RECONFIRM).
- **known-quirks (2026-07-01):** QA-130076 was **BLOCKED** on 2026-07-01 because Viacom then had **0** lost-auth notifications (Status=Not Collecting returned 0). That quirk's explicit **"Revisit if: a Viacom feed loses authorization and generates a Not-Collecting notification"** condition is now **MET** — Viacom carries 80 lost-auth notifications dated Jul 11 2026 10:36 PM. Test-data gap resolved; case is runnable and passes. (KB update deferred to harvest.sh.)
- No regression: the message format, quoting, and NOT COLLECTING badge match the format captured on the 2026-06-13 PASS (`'<Feed> (Authorized|Public)'`).

## Bugs filed
None.
