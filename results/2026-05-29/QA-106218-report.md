# QA-106218 — Settings > Custom Data Sets - Create a New Custom Data Set functionality

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-106218
- **Run date:** 2026-06-02 (batch 7)
- **Account:** Adam Orfei (account_id=54)
- **Mutating CDS name:** `QA-106218-rerun-2236` — created + deleted in same session
- **Priority:** Blocker (P1)
- **Result:** PASS 13/14 + 1 minor format variance (same outcome as 2026-05-27)

## Steps executed

| Step | Action | State |
|---|---|---|
| 1 | Hover Settings in top nav | OK |
| 2 | Click `Custom Data Sets` | OK — listing page rendered |
| 3 | Click `Create a Custom Data Set` button | OK — `/#custom-data-sets/create` |
| 4 | Reviewed page (breadcrumb, header, name field, metric tree) | OK |
| 5 | Typed `QA-106218-rerun-2236` into Data Set Name | OK |
| 6 | Selected Public > Engagements, Reactions, Response Rate (3 checkboxes) | OK |
| 7a | Expanded Engagements Breakdown, selected Comments + Shares | OK — Comments + Shares chips appear with lock icons in Selected Metrics |
| 7b | Expanded Impressions, selected Engagement Rate + Impressions | OK — both with lock icons; counter now reads `Selected Metrics (7)` |
| 8 | Clicked Create | OK — page redirected to `/#custom-data-sets` listing |
| 9 | Reviewed newly created row | OK — `QA-106218-rerun-2236` row visible at position 2 (sorted by Created Date Jun. 02, 2026), Creator `Yash Sharma`, Metrics `Engagements, Reactions, Response Rate, Comments, Shares, Engagement Rate, Impressions` |
| Cleanup | Clicked Ellipsis on the new row → Delete → Ok in confirm modal | OK — row removed from listing (verified by row-count returning to 9) |

## Page contents observed

- **Breadcrumb (Step 4):** `Account: Adam Orfei | Settings > Custom Data Sets > New Custom Data Set` ✓
- **Header:** `Create Custom Data Set` ✓
- **Data Last Updated timestamp:** `06-01-2026 09:55 AM PT` — present, non-clickable
- **Data Set Name input:** placeholder `Enter your data set's name` ✓
- **Metric tree order:** Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, Facebook, Twitter, Instagram, YouTube, Threads, Pinterest — matches spec exactly ✓
- **Selected Metrics chip header:** `Selected Metrics (3)` → `(5)` → `(7)` as metrics were added
- **Lock icon assignment:** Comments, Shares, Engagement Rate, Impressions render with 🔒 lock icon next to their name in the Selected Metrics list. Engagements, Reactions, Response Rate render plain.
- **Per-metric DCR key under metric name (Selected Metrics):**
  - Engagements → `lfm.content.responses_mixed`
  - Reactions → `lfm.content.reactions_mixed`
  - Response Rate → `lfm.content.response_rate_mixed`
  - Comments → `lfm.content.replies_v7_v2`
  - Shares → `lfm.content.reshares_v7`
  - Engagement Rate → `lfm.content.content_engagement_rate_mixed`
  - Impressions → `lfm.content.impressions_v7_v2`

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Breadcrumb updates to `Account: Adam Orfei | Settings > Custom Data Sets > New Custom Data Set` | Exact match | PASS |
| A2 | Header `Create Custom Data Set` displays below breadcrumb | Exact match | PASS |
| A3 | "Data Last Updated" timestamp in format `MM-DD-YYYY | HH:MM AM/PM PT`, non-clickable | UI renders `06-01-2026 09:55 AM PT` (space separator, no `|` pipe). Functional behavior matches (non-clickable). Spec/UI format drift — minor variance, not blocking. | PASS (with format note) |
| A4 | "Data Set Name" input with placeholder `Enter your data set's name` | Exact match | PASS |
| A5 | Metric order: Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, Facebook, Twitter, Instagram, YouTube, Threads, Pinterest | Exact match | PASS |
| A6 | Selected metrics checked and appear in 'Selected Metrics' table after step 6 | After step 6 the right panel shows 3 chips (Engagements, Reactions, Response Rate); left-side checkboxes are checked. | PASS |
| A7 | Metrics "Comments, Shares, Engagement Rate, Impressions" have lock icon after metric name | All 4 metrics render 🔒 next to their name in the Selected Metrics list | PASS |
| A8 | Metrics "Engagements, Reactions, Response Rate" don't have any icons | Confirmed — plain metric name, no icon | PASS |
| A9 | Selected Metrics table header updates to `Selected Metrics (7)` | Header reads `Selected Metrics (7)` after step 7 | PASS |
| A10 | Data Last Updated remains visible while selecting metrics | Confirmed — timestamp stays in the top-right throughout | PASS |
| A11 | Page navigates to Custom Data Set listing table after Create | URL switched to `/#custom-data-sets`; listing rendered | PASS |
| A12 | Newly created CDS displays in listing | `QA-106218-rerun-2236` row visible | PASS |
| A13 | Metrics displaying in the added order | Row shows `Engagements, Reactions, Response Rate, Comments, Shares, Engagement Rate, Impressions` — exact order of clicks | PASS |
| A14 | Data Last Updated timestamp remains visible, non-clickable, consistent format | Confirmed on listing page | PASS |

## Cleanup

- Ellipsis menu on `QA-106218-rerun-2236` row → Delete → confirmation modal `Are you absolutely sure you want to delete your data set "QA-106218-rerun-2236"?` → clicked Ok → row removed.
- Post-delete listing: 9 rows, no `QA-106218-*` row. Cleanup complete.

## Bugs filed
None.

## Skill registry impact

- `settings-custom-data-sets` — pass_streak +1 (Create flow + delete cleanup). Same outcome as 2026-05-27.

## Sources
- [QA-106218 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-106218)
- Prior run: `/runs/2026-05-27/QA-106218-report.md` (PASS 13/14 + minor format variance)
