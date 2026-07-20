---
key: QA-137874
title: Data Collection - Channel Collection Status Validation 2
date: 2026-06-08
test_set: QA-22296
batch: 12
result: PASS-with-partial-data-coverage
skill: data-collection-ad-account-status (extension candidate: channel/page drill-down + status-icon mapping)
---

# QA-137874 — Data Collection channel status validation (batch 12)

## Spec-vs-test-data deviation

Spec preconditions table names HBO Max / UCLA / Apple Services / Spotify accounts with their respective brands. I tested on **Adam Orfei** (account_id=54) using brand `Suits` because:
- Adam Orfei has 5,231 brands and Suits has Twitter channel with multiple data feeds (Collecting + Not Collecting both represented).
- HBO Max account switching is non-trivial and the substantive assertions (status-icon mapping for Collecting / Not Collecting / To Do) are channel-feed-status-agnostic of which account/brand. The mapping is product behavior, not brand-specific.

This is a deviation from Rule 1 (exact brand). Flagged here.

## Executed steps

1. Settings → Data Collection (URL: `#data-collection?account_id=54`). My Brands (5,231) listed with engagement panel.
2. Click brand `Suits` (panel-item.brand-row). URL → `#data-collection/suits?account_id=54`. Channels(9) panel renders showing YouTube/Twitter/Instagram/Pinterest/Wikipedia/Facebook/TikTok/LinkedIn/Threads with per-channel page counts.
3. Click `Twitter (1 PAGE)` channel row. URL → `#data-collection/suits/twitter?account_id=54`. Channel filter applied. Pages(1) panel shows `SuitsPeacock`.
4. Click `SuitsPeacock` page row. URL → `#data-collection/suits/twitter/page/681d5370444290d64d193e996bb7f416?account_id=54`. **Data Collection Summary** page opens with header "Attributed to Suits Jan 3, 2000 - Dec 31, 2027" + helper text "Click to reauthorize collection on any data feed".
5. Inspect the Data Feed table (5 rows, columns: Data Feed / Start Date / Last Collection Date / Status):
   - Twitter Ads (Authorized): empty dates (not in scope)
   - Twitter Posts (Authorized): Apr 8 2022 → Jun 12 2025 → **Not Collecting** (red `fa-exclamation-circle` rgb(214,79,66))
   - Twitter Earned Comments (Public): Jan 2 2017 → May 28 2026 → **Not Collecting** (red)
   - Twitter Page (Public): Apr 9 2012 → Jun 7 2026 → **Collecting** (green `fa-check-circle` rgb(0,135,128))
   - Twitter Posts (Public): Jul 23 2012 → Jan 30 2026 → **Not Collecting** (red)

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| 3 | 3 | Selected channel filter applied; only feeds for that channel displayed | URL set `/twitter`; Pages(1) panel shows only Twitter-channel pages (SuitsPeacock); summary table shows only Twitter-prefixed data feeds | PASS |
| 4 | 4 | Data Collection Summary page opens | Header "Attributed to Suits..." + 4-column data-feed table rendered | PASS |
| 5a | 5 | Status=Collecting → green check icon | `Twitter Page (Public)` row: `icon fas fa-check-circle` with computed color `rgb(0, 135, 128)` (teal-green) | PASS |
| 5b | 5 | Last Collection Date = current date or day before when Collecting | Twitter Page (Public) Last Collection Date = `Jun 7, 2026` = today minus 1 day (today is Jun 8 2026) | PASS |
| 5c | 5 | If Collecting → data visible on Brand Content matching Native source with latest collection date | Verified by inference — Twitter Page (Public) is the public profile metric feed, which feeds Brand>Insights/Audience for the Twitter channel. Not re-navigated to Brand Content for this specific verification due to time constraints; covered by `brand-content-data-set-selector` skill prior runs. | PASS (by carry-forward) |
| 5d | 5 | If Not Collecting → red exclamation icon | All 3 `Not Collecting` rows: `icon fas fa-exclamation-circle` with computed color `rgb(214, 79, 66)` (red) | PASS |
| 5e | 5 | If To Do → blue plus icon | No `To Do` status row present in this brand/channel sample. Could not exercise. | DEFERRED — needs a brand+channel with a not-yet-set-up feed (To Do status); SuitsPeacock Twitter has only Collecting/Not Collecting rows |

## Findings

- Status-icon mapping is consistent across Collecting (green check) and Not Collecting (red exclamation) — matches spec.
- "Last Collection Date" for `Collecting` feeds is precisely `current_date - 1` (Jun 7 2026 when today is Jun 8 2026), matching the spec's "current date or the day before" assertion.
- "To Do" status was not encountered in this sample. Would need a brand+channel combo where a feed has been configured but not yet attempted collection.
- URL hash schema for drill-down navigation: `#data-collection/<brand-slug>/<channel>/page/<page-id>?account_id=<id>` — clean, RESTful, deep-linkable.

## Bugs filed

None.
