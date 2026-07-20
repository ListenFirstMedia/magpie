# QA-109062 — Settings > Custom Data Sets support on Brand > Content - Export

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-109062
- **Run date:** 2026-05-27 (cross-day into 2026-05-28 during run)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018, Authorized perspective)
- **Custom Data Set:** QA-106218 Test 20260527 (created in QA-106218 run earlier today)
- **Priority:** Blocker (P1)
- **Result:** ✅ **7/7 PASS** end-to-end. CSV downloaded, filename pattern matches spec, columns include all configured + breakdown metrics, no LF data sets in export, page data matches CSV row 1 exactly.

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Already on Adam Orfei from QA-106218 | ✓ |
| 1 | Hover Brand → Content | ✓ — URL `/#explore/brand/content` |
| 2 | Brand picker → typed `MTV` → clicked exact-match `MTV` from Results (Rule 1) | ✓ — brand_id=4018 |
| 3 | Clicked Data Set dropdown → scrolled to Custom Data Sets section at bottom | ✓ — full hierarchy: Cross-Channel Metrics → Channel-Specific Metrics → Custom Data Set |
| 4 | Clicked `QA-106218 Test 20260527` | ✓ — URL `table_data_set=QA-106218%20Test%2020260527`, Data Set selector label updated |
| 5 | Clicked Export dropdown | ✓ — "Export Select Data Sets" modal opened |
| 6 | Unchecked `QA-106218 Test 20260527` | ✓ — LF data sets enabled (no longer dimmed); Pinterest Only: Basic remained dimmed |
| 7 | Re-checked `QA-106218 Test 20260527` → clicked Ok | ✓ — "Your export has successfully been queued" toast appeared |
| 8 | Waited for export, clicked Recent Activity bell → "Download file" link in notification "Select Data Sets Export ... May 28, 2026 01:22 am" | ✓ — CSV downloaded to ~/Downloads |

## Page data observed (after step 4, data set applied)

Aggregate row (Posts (288), Lifetime, Public Data):

| Metric | Sum | Average |
|---|---:|---:|
| Engagements | 7,224,886 | 25,086 |
| Reactions | 6,944,249 | 24,112 |
| Response Rate | N/A | 0.11% |
| Comments | 62,904 | 218 |
| Organic Comments | 31,222 | 108 |
| Paid Comments | – | – |
| Shares | 217,733 | 756 |
| Organic Shares | 128,513 | 446 |
| Paid Shares | – | – |
| Engagement Rate | N/A | 6.62% |
| Impressions | 109,144,479 | 378,974 |
| Organic Impressions | 92,537,497 | 321,311 |
| Paid Impressions | 0 | 0 |

## CSV verification

**Filename:** `MTV-Brand Content-2026-05-20-2026-05-26-posts.csv` (101,246 bytes)

**Header row 1 (Data Set label):** 13 cells labeled `QA-106218 Test 20260527` (one for each metric column under the custom data set). No LF data set labels present.

**Column headers (row 2):** Rank, Date, Day of Week, Time (PT), Channel, Brand, Author Link, Type, Post Link, Live, Publish Type, Paid, Sponsor Name, Sponsor Link, Instagram Collaborator Count, Instagram Collaborator Name, Instagram Collaborator Link, Text, **Engagements, Reactions, Response Rate, Comments, Organic Comments, Paid Comments, Shares, Organic Shares, Paid Shares, Engagement Rate, Impressions, Organic Impressions, Paid Impressions**, bulk-tag-63600-4, bulk-tag-63600-631, qa_11605_testing_2026-05-23, qa_11605_testing_2026-05-24, qa_11605_testing_2026-05-25, sample_tag_1418

**Post 1 (first data row):**
- Rank 1, Date 05/25/2026, Mon, 07:55 PM PT, Instagram, MTV, Reel, BTS post
- Engagements: 1,182,962
- Reactions: 1,173,314
- Response Rate: 0.0559558... (≈ 5.60%)
- Comments: 9,648
- Organic Comments: 9,648
- Paid Comments: (empty)
- Shares: (empty)
- Organic Shares: -
- Paid Shares: -
- Engagement Rate: 0.146692... (≈ 14.67%)
- Impressions: 8,064,246
- Organic Impressions: 8,064,246
- Paid Impressions: (empty)

These match exactly the post-tile values visible in the on-page Engagements (1,182,962), Reactions (1,173,314), Response Rate (5.60%), Comments (9,648), Engagement Rate (14.67%), and Impressions (8,064,246).

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Selected data set updates in the data set dropdown | Data Set selector label changed from `Public` to `QA-106218 Test 20260527`; URL `table_data_set` param updated | ✅ PASS |
| A2 | Metrics displayed in Aggregate table and posts: Engagements, Reactions, Response Rate, Organic Comments, Paid Comments, Organic Shares, Paid Shares, Engagement Rate, Impressions, Organic Impressions, Paid Impressions | All 11 spec metrics present (note: actual UI also shows totals `Comments` and `Shares` in addition to the organic/paid splits — superset of spec list; no metric is missing) | ✅ PASS (with bonus columns) |
| A3 | "Custom Data Sets Test" data set already selected and LF data sets in disabled state in export modal | Modal opened with our `QA-106218 Test 20260527` ✓ checked. LF data sets (Clicks, Engagements Breakdown, Impressions, Public, Reels, Video Views, all channel-specific) all greyed-out/dimmed. | ✅ PASS |
| A4 | After unchecking, all data sets enabled except those related to Pinterest | After unchecking the custom data set, all LF data sets became enabled. `Pinterest Only: Basic` remained dimmed/disabled, matching spec exactly. | ✅ PASS |
| A5 | Filename `Brand-Tab-Start Date-End Date-posts.csv` | Saved as `MTV-Brand Content-2026-05-20-2026-05-26-posts.csv` — matches pattern. (Brand "MTV", Tab "Brand Content", dates 2026-05-20 / 2026-05-26, suffix `-posts.csv`) | ✅ PASS |
| A6 | No LF data sets should display in CSV | First header row's "Data Set" label cells all read `QA-106218 Test 20260527`. No LF dataset names (Public/Engagements Breakdown/etc.) appear as data-set labels. | ✅ PASS |
| A7 | CSV data matches Page data | Post 1 numeric values in CSV (Engagements 1,182,962 / Reactions 1,173,314 / Response Rate 5.60% / Comments 9,648 / Engagement Rate 14.67% / Impressions 8,064,246) match the on-page post tile exactly | ✅ PASS |

## Bugs filed
None.

## Skill registry impact
- `export-csv` v2 — pass_streak +1 (custom data set CSV export confirmed: server-side queued, Recent Activity bell delivers Download file link)
- New skill candidate: `custom-data-set-export` — encodes the 3-step pattern (select data set → Export → Ok)

## Sources
- [QA-109062 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-109062)
- [QA-106218 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-106218) (precondition)
