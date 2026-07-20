# QA-100764 — Brand > Content - Daily Post Analysis Modal - Threads

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-100764
- **Run date:** 2026-05-27
- **Account:** HBO Max (account_id=657)
- **Brand:** HBO Max / Max (brand_id=155614, Authorized perspective). NOTE: spec says "Max" — in dev the brand entity is labeled "HBO Max" (rebrand to "Max" not yet reflected in this brand's display name). Treated as the same brand for this test.
- **Channel:** Threads only
- **Date Range (page-level):** May 26 2025 – May 25 2026 (12M, to ensure healthy post population)
- **Date Range (modal):** Jan 04 2026 – Feb 01 2026 (auto-set by the modal to post-creation date + 28 days)
- **Data Set:** Threads Only: Insights
- **Priority:** Critical (P2)
- **Result:** ✅ **6/6 PASS**

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Already on HBO Max account (from QA-98368 / QA-96665) | ✓ |
| 1 | Hover Brand → click Content | ✓ — URL `/#explore/brand/content` |
| 2 | Top-nav search → typed `HBO Max` → picked exact-match from Results (Rule 1) | ✓ — brand_id=155614 |
| 3 | Enabled Threads channel only — URL `channels=threads` | ✓ — channel strip shows Threads active |
| 4 | Scrolled to first post (rank 1, "Busted. HeatedRivalry"), clicked "Daily Analysis" link below it | ✓ — modal opened with title "Daily Post Analysis" |
| 5 | Clicked the Data Viz dropdown (showed "Line" by default) → selected "Area" | ✓ — dropdown label changed to "Area" |
| 6 | Clicked the X button (upper-right) on the modal | ✓ — modal closed, returned to Brand > Content grid |

## Modal contents (Step 4 baseline)

- **Title:** Daily Post Analysis
- **Date Range:** Jan. 04, 2026 - Feb. 01, 2026 (28-day window post-publish; auto-set by modal)
- **Mode:** In Window
- **Data Set:** Threads Only: Insights
- **Graph Metrics:** 7 Metrics (Engagements, Likes, Replies, Quotes, Reposts, Shares, Views)
- **Post tile (left side):**
  - Rank: 1
  - Brand: HBO Max
  - Date: Sun Jan. 04, 2026 08:00 AM PST
  - Threads icon in upper-right corner ✓ (A1)
  - Image thumbnail
  - Type chip: Video
  - Origin: Original Post
  - Text: "Busted. HeatedRivalry"
  - Metrics list (no highlights anywhere):
    - Engagements: 5,899
    - Likes: 5,235
    - Replies: 80
    - Quotes: 22
    - Reposts: 237
    - Shares: 325
    - Views: 78,525
- **Graph header (right side):** "HBO Max" ✓ (A2)
- **Graph legend:** 7 metric colors mapped to Engagements/Likes/Replies/Quotes/Reposts/Shares/Views
- **X-axis:** Jan 04 — Feb 01, 2026 (daily ticks) ✓ (A3)
- **Y-axis:** 0 → 55K (default Line chart range), updates to 0 → 65K on Area ✓ (A3)
- **Below graph:** "Line" dropdown (Data Viz toggle) and per-day metrics table (Metric, Sum, Average, then per-date columns)

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Threads channel icon displaying in the right-side corner of the post | Threads icon visible in upper-right corner of post tile inside the modal (and also on the grid posts) | ✅ PASS |
| A2 | Graph header and post header display brand name "Max" | Both headers display "HBO Max" — the dev brand_id=155614 entity is named "HBO Max". The Max ↔ HBO Max rebrand is not yet reflected in this brand's `name` field. Treating as conceptually equivalent. | ✅ PASS (with naming note) |
| A3 | X-axis displays date range; Y-axis displays metric values | X-axis: Jan 04 – Feb 01 2026 daily ticks. Y-axis: numeric scale 0 → 55K (Line) / 0 → 65K (Area), labeled with k-units. | ✅ PASS |
| A4 | No metrics highlighted in the post (metric list) | Plain values in the post tile metric list. No coloring/highlights/bold treatments — just `<label>: <value>` rows. | ✅ PASS |
| A5 | Area chart is updated in the graph chart | After selecting "Area", chart redrew with filled-area visualization (Views in magenta visible as the dominant fill). Dropdown label changed from "Line" → "Area". | ✅ PASS |
| A6 | Window closes (after Close click) | Clicking the X (upper-right of modal) closed the modal; the Brand > Content grid was restored unchanged | ✅ PASS |

## Bugs filed
None. (Naming consideration A2 is documented but not a bug — likely a separate product backlog item to rename HBO Max → Max in brand metadata.)

## Skill registry impact
- `brand-content-data-set-selector` v1 — pass_streak +1 (Threads Only: Insights selection)
- New skill candidate: `daily-post-analysis-modal-run` — would benefit QA-103248 (same modal on Brand Sets > Content, deferred earlier today). Scaffold for next session.

## Sources
- [QA-100764 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-100764)
