# QA-106218 — Settings > Custom Data Sets - Create a New Custom Data Set functionality

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-106218
- **Run date:** 2026-05-27 (cross-day into 2026-05-28 during run)
- **Account:** Adam Orfei (account_id=54)
- **Priority:** Blocker (P1)
- **Result:** ✅ **13/14 PASS / 1 minor variance — A3 spec specifies pipe separator (`MM-DD-YYYY | HH:MM AM/PM PT`) but actual UI uses space separator (`MM-DD-YYYY HH:MM AM/PM PT`). Functionally equivalent; flagging as documentation variance, not a bug.**

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Switched account → Adam Orfei via Yash picker | ✓ |
| 1 | Hover Settings → Custom Data Sets in dropdown | ✓ — URL `/#custom-data-sets`, breadcrumb shows listing |
| 2 | (covered by step 1) | ✓ |
| 3 | Clicked yellow "Create a Custom Data Set" button | ✓ — URL `/#custom-data-sets/create`, page loaded |
| 4 | Reviewed Create page (breadcrumb, header, timestamp, name input, metric tree order) | ✓ |
| 5 | Clicked Data Set Name → typed `QA-106218 Test 20260527` | ✓ |
| 6 | Public node: ✓ Engagements, ✓ Reactions, ✓ Response Rate | ✓ — Selected Metrics (3) |
| 7 | Engagements Breakdown: ✓ Comments, ✓ Shares; Impressions: ✓ Engagement Rate, ✓ Impressions | ✓ — Selected Metrics (7) |
| 8 | Clicked Create button | ✓ — page navigated back to listing |
| 9 | Reviewed new row at top of Data Set listing table | ✓ |

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Breadcrumb "Account: Adam Orfei \| Settings > Custom Data Sets > New Custom Data Set" | Exact match: `Account: Adam Orfei | Settings > Custom Data Sets > New Custom Data Set` | ✅ PASS |
| A2 | Header "Create Custom Data Set" below breadcrumb | Text matches exactly | ✅ PASS |
| A3 | "Data Last Updated" timestamp `MM-DD-YYYY \| HH:MM AM/PM PT`, non-clickable | Actual: `05-27-2026 10:00 AM PT` — uses **space separator, not pipe**. Other components match (MM-DD-YYYY date, HH:MM AM/PM PT time). Non-clickable confirmed. | ⚠ MINOR VARIANCE (no pipe separator) |
| A4 | Data Set Name box with placeholder "Enter your data set's name" displays under header | Placeholder text matches exactly | ✅ PASS |
| A5 | Metrics order: Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, Facebook, Twitter, Instagram, YouTube, Threads, Pinterest | All 12 categories present in exact spec order | ✅ PASS |
| A6 | Selected metrics checked and appear in Selected Metrics table | All 7 selections appeared in the right-side table with correct metric expressions (e.g., `lfm.content.responses_mixed`, `lfm.content.reactions_mixed`, etc.) | ✅ PASS |
| A7 | Metrics "Comments, Shares, Engagement Rate, Impressions" have lock icon after metric name | All 4 metrics show 🔒 lock icon next to their names in the Selected Metrics table | ✅ PASS |
| A8 | Metrics "Engagements, Reactions, Response Rate" don't have any icons after metric name | None of these 3 have lock icons | ✅ PASS |
| A9 | Selected Metrics table header updates to "Selected Metrics (7)" | After adding all 7 metrics, header shows exactly `Selected Metrics (7)` | ✅ PASS |
| A10 | "Data Last Updated" timestamp remains visible while selecting metrics | Timestamp `05-27-2026 10:00 AM PT` remained visible through all metric selections | ✅ PASS |
| A11 | Page navigates to Custom Data Set listing table | After Create click, URL changed back to `/#custom-data-sets`, listing page loaded | ✅ PASS |
| A12 | Newly created custom data set displays in Data Set listing table | New row "QA-106218 Test 20260527" appears at TOP of the listing | ✅ PASS |
| A13 | Metrics displaying in the added order | Metrics column shows: `Engagements, Reactions, Response Rate, Comments, Shares, Engagement Rate, Impressions` — exact order as configured | ✅ PASS |
| A14 | "Data Last Updated" timestamp remains visible, non-clickable, consistent format after Create | Timestamp `05-27-2026 10:00 AM PT` still visible on listing page, same format as create page | ✅ PASS |

## Evidence captured
- New data set in table:
  - **Data Set:** QA-106218 Test 20260527
  - **Created Date:** May. 28, 2026 (crossed UTC midnight during run; PT was still 2026-05-27)
  - **Creator:** Yash Sharma
  - **Metrics:** Engagements, Reactions, Response Rate, Comments, Shares, Engagement Rate, Impressions
- Total data sets after create: 7 (was 6 before)

## Bugs filed (minor)
**Doc variance (A3):** Spec lists timestamp format as `MM-DD-YYYY | HH:MM AM/PM PT` (with pipe separator). Actual UI renders as `MM-DD-YYYY HH:MM AM/PM PT` (with space). Functionally equivalent; recommend either updating spec text OR adding pipe separator to UI for consistency with other timestamps elsewhere in the platform.

## Skill registry impact
- `switch-account` v2 — pass_streak +1 (separate-day HBO Max → Adam Orfei)
- New skill candidate: `custom-data-set-create` — pattern for clicking Public/Breakdown/Impressions nodes + selecting metrics + creating. Would benefit QA-109062 (which uses the result).

## Note for QA-109062 dependency
The created data set name is `QA-106218 Test 20260527` (slug for downstream test consumption). QA-109062 needs to:
1. Navigate to Brand > Content
2. Open Data Set dropdown → select `QA-106218 Test 20260527`
3. Verify metrics appear in Aggregate table and on posts

## Sources
- [QA-106218 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-106218)
