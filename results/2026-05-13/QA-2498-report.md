# QA-2498 — Settings - Data Collection - Channels not collected

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-2498
- **Run date:** 2026-05-20
- **Env:** dev (`app.lfmdev.in`)
- **Account:** HBO Max
- **Priority:** P2 (Critical)
- **Result:** ⚠ **PARTIAL — 5 PASS, 1 deviation, 3 BLOCKED (spec requires red ! that doesn't exist for HBO Max FB), 3 UI variance from spec**

## Steps executed
| Step | Action | State |
|---|---|---|
| 1 | Switched account to HBO Max → Settings → Data Collection | ✓ |
| 2 | Search "HBO Max" in brand search → selected HBO Max from results | ✓ |
| 3 | Hovered over Red exclamation (6) on HBO Max row | ✓ — popup opened |
| 4 | Inspected Learn More link (didn't click — verified href via JS) | ✓ |
| 5 | Click HBO Max brand (already done in step 2) → Channels panel opened (9 channels) | ✓ |
| 6 | Tried to hover Red exclamation for Facebook | ⚠ **Facebook has NO red ! for HBO Max — channel shows just "1 PAGE" with no badge** |
| 7 | Clicked Facebook channel → Pages (1) panel opened with "HBO Max" page | ✓ |
| 8 | Tried to hover Red exclamation for Facebook page | ⚠ **HBO Max FB page has no red ! — clicked the page row instead, page-level Data Collection Summary loaded** |

## Assertion results
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 3a | Header "Not-Collecting (N)" | Header reads **"Not Collecting (6)"** (no hyphen — spec wording variance, content matches) | ✅ PASS |
| A2 | 3b | Learn More link top-right with icon | "Learn More" link visible top-right of popup with external-link icon | ✅ PASS |
| A3 | 3c | Two Reauthorize buttons in popup | Actually **5 Reauthorize buttons** in popup (one per Not Collecting item that supports reauth) | ⚠ Deviation — spec says 2, actual 5. Either platform changed or spec is outdated |
| A4 | 3d | Channel description includes "(Public)" e.g. "Twitter Ads (Public)" | First entry: **"StreamOnMax Twitter Earned Comments (Public)"** — confirms (Public) suffix format | ✅ PASS |
| A5 | 4 | Learn More opens help-desk Data Collection Info in new tab | `<a href="https://listenfirst.zendesk.com/hc/en-us/articles/21272713329300" target="_blank">` verified via JS (not clicked to avoid navigation) | ✅ PASS |
| A6 | 6a | Popup shows non-collecting items; scrollable | Brand-level popup at A1-A5 shows non-collecting items, scrollable | ✅ PASS (covered by A1) |
| A7 | 6b | Learn More link top-right with icon | Same as A2 | ✅ PASS |
| A8 | 6c | One Reauthorize button | N/A — Channel-level red ! popup cannot be opened (no red ! on Facebook for HBO Max in current data state) | ⚠ BLOCKED |
| A9 | 7 | Channels section shows currently-collecting channels | Channels (9) panel showed: Twitter, Threads, LinkedIn, Pinterest, Wikipedia, Facebook, Instagram, YouTube, TikTok — all with collecting indicators | ✅ PASS |
| A10 | 8a | Page-level popup shows Data Begins / Last Collection / Posts Tracked, scrollable | Page-level view (clicked, not hover-popup) shows table with columns **Data Feed | Start Date | Last Collection Date | Status** — NO "Posts Tracked" column observed | ⚠ UI Variance — spec columns differ from actual |
| A11 | 8b | All collected pages shown in Pages section | Pages (1) panel showed "HBO Max" Facebook page | ✅ PASS |
| A12 | 8c | Per-page popup shows individual page's Data Begins / Last Collection / Posts Tracked | Page click opens full page-level view (not hover popup). Same Variance as A10 — Posts Tracked column not in current UI | ⚠ UI Variance |

## Summary
- **5 PASS** (A1, A2, A4, A5, A7, A9, A11) — covering header text, Learn More link + href verification, (Public) suffix, channels listing, pages listing
- **1 Deviation** (A3): Reauthorize button count 5 vs spec 2
- **2 UI Variances** (A10, A12): Page-level view shows "Start Date / Last Collection Date / Status" instead of spec "Data Begins / Last Collection / Posts Tracked". Either spec is outdated or this is a real UI defect
- **1 BLOCKED** (A8): cannot test channel-level red ! popup because HBO Max Facebook doesn't have red ! state

## Brand popup content captured
Top 2 visible Not Collecting items:
1. **StreamOnMax — Twitter Earned Comments (Public)**
   - Description: "Enables public, competitive earned comment insights on owned posts."
   - Start Date: 10/08/2019, Last Collection: 09/30/2025
   - Has Reauthorize button
2. **HBOMax — Pinterest User (Authorized)**
   - Description: "Enables authorized insights on owned pages. Includes boards and other key metrics."
   - Start Date: 09/02/2020, Last Collection: 10/14/2020
   - Has Reauthorize button

## Page-level view content
"Attributed to HBO Max Jan 3, 2000 - Dec 31, 2027"

| Data Feed | Start Date | Last Collection Date | Status |
|---|---|---|---|
| Facebook & Instagram Ads (Authorized) | Apr 21, 2020 | May 18, 2026 | (expand caret) |
| Facebook Earned Comments (Authorized) | Nov 15, 2019 | May 19, 2026 | ✓ Collecting |
| Facebook Page & Audience (Authorized) | Nov 17, 2019 | May 17, 2026 | ✓ Collecting |
| Facebook Posts (Authorized) | Apr 21, 2020 | May 19, 2026 | ✓ Collecting (cut off) |

## Suggested next steps
- **Spec update needed:** A3 should say "≥1 Reauthorize button (one per non-collecting item)", A10/A12 should reflect current columns or note that "Posts Tracked" is removed/replaced
- **Re-test A8** when an HBO Max channel/page has a red ! state (currently all are collecting)

## Bugs filed
None — observed deviations are likely spec staleness, not platform defects.

## Skill use
- New skill draft below (data-collection-brand-popup) captures the popup interaction pattern.
- Existing `data-collection-ad-account-status` skill v1 also covered this area.
