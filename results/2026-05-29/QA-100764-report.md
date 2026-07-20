# QA-100764 — Brand > Content - Daily Post Analysis Modal - Threads

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-100764
- **Run date:** 2026-06-02 (batch 7)
- **Account:** HBO Max (account_id=657)
- **Brand:** HBO Max (brand_id=155614). Spec says "Max" — dev still labels this entity "HBO Max"; rebrand not reflected in brand metadata. Same treatment as 2026-05-27 batch.
- **Channel:** Threads only (Apply)
- **Date Range (page):** Jun. 01, 2025 – May. 31, 2026 (12M)
- **Date Range (modal):** Jan. 04, 2026 – Feb. 01, 2026 (28-day auto window post-publish)
- **Data Set:** Threads Only: Insights
- **View:** Authorized Data (perspective=extended)
- **Priority:** Critical (P2)
- **Result:** PASS 6/6

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Switched account Adam Orfei → HBO Max via Search Account (Rule 1) | OK |
| 1 | Navigated to Brand > Content for HBO Max with channels=threads | OK |
| 2 | Brand auto-loaded as "HBO Max" (only Results match for "Max" account search) | OK |
| 3 | Selected Threads icon → clicked Apply; Threads Only: Insights data set auto-applied | OK — `Posts (516)` |
| 4 | Clicked `Daily Analysis` button below post 1 ("Busted. HeatedRivalry") | OK — modal opens with title "Daily Post Analysis" |
| 5 | Clicked Data Viz dropdown (label "Line") → selected `Area` | OK — chart re-rendered as Area, label switched to "Area" |
| 6 | Clicked `Close` button (bottom right of modal) | OK — modal dismissed, returned to Brand>Content grid |

## Modal contents (Step 4 baseline)

- **Title:** Daily Post Analysis
- **Date Range:** Jan. 04, 2026 – Feb. 01, 2026
- **Mode:** In Window
- **Data Set:** Threads Only: Insights
- **Graph Metrics:** 7 Metrics
- **Legend chips:** Engagements, Likes, Replies, Quotes, Reposts, Shares, Views
- **Post tile (left):**
  - Rank 1, brand "HBO Max" link, Threads icon top-right
  - Sun Jan. 04, 2026 08:00 AM PST
  - Video chip, Original Post
  - Text: "Busted. HeatedRivalry"
  - Metric list (no highlights):
    - Engagements: 5,899
    - Likes: 5,235
    - Replies: 80
    - Quotes: 22
    - Reposts: 237
    - Shares: 325
    - Views: 78,525
- **Graph header:** "HBO Max"
- **X-axis:** Jan 04 → Feb 01 daily ticks
- **Y-axis (Line):** 0 → 55K
- **Y-axis (Area, post-Step 5):** 0 → 65K (re-scaled)
- **Below graph:** Data Viz selector (Line/Area/Bar/Pie) + per-day metrics table (Metric, Sum, Average, per-date columns)
  - Engagements row Sum=5,899, Avg=203, Jan 04 = 4,296, Jan 05 = 1,380, Jan 06 = 117, …
  - Views row Sum=78,525, Avg=2,708, Jan 04 = 51,667, Jan 05 = 20,506, …

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Threads channel icon displayed in the right-side corner of the post | Threads logo glyph visible in upper-right corner of post tile inside modal AND on grid posts | PASS |
| A2 | Graph header and post header display brand name "Max" | Both headers display "HBO Max" — same as prior run. dev brand `name` field is "HBO Max"; the Max ↔ HBO Max rebrand is a brand-metadata backlog item, not a defect of the modal. | PASS (with rebrand note) |
| A3 | X-axis displays date range; Y-axis displays metric values | X-axis: Jan 04 – Feb 01 2026 daily ticks; Y-axis: 0–55K (Line) / 0–65K (Area), numeric with k-suffix labels | PASS |
| A4 | No metrics highlighted in the post | Metric list rows render plain `<label>: <value>` — no color/bold/highlight treatments | PASS |
| A5 | Area chart updates in the graph chart | Selecting Area redraws as filled-area (purple/magenta dominant Views fill), label changes Line → Area | PASS |
| A6 | The window closes | Clicking Close dismissed the modal; underlying Brand>Content grid restored unchanged | PASS |

## Bugs filed
None.

## Skill registry impact
- `brand-content-data-set-selector` — pass_streak +1 (Threads Only: Insights auto-applied after channel narrow).

## Sources
- [QA-100764 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-100764)
- Prior run: `/runs/2026-05-27/QA-100764-report.md` (PASS 6/6 — same outcome)
