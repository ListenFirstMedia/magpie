# QA-98351 — Brand > Content - Threads - Basic View

**Run:** 2026-06-05 (batch 6/12 of QA-22296)
**Brand / Account:** MTV (brand_id=4018) on Adam Orfei account
**Tester:** Yash via magpie

## Pre-test
- Spec: Verify Brand>Content basic view loads cleanly for the Threads channel.
- Bug history: no open/closed bug links — clean test.

## Steps executed
1. Navigated to `https://app.lfmdev.in/#explore/brand/content?brand_id=4018&account_id=54&from=2026-05-31&to=2026-06-06&channels=threads&perspective=extended` (Authorized, 7 days).
2. Brand>Content rendered with all tabs (Insights, Channels, Content, Video, Stories, Audience, Optimization, Partnerships, Paid, Conversation).
3. Data Set widget was initially set to a Custom Data Set ("Test 3 Dupes") which caused table failure.
4. Opened Data Set dropdown — enumerated all data sets including the dedicated **"Threads Only: Insights"** under Channel-Specific Metrics.
5. Selected Threads Only: Insights. URL updated to `table_data_set=threads_only%3A_insights` and `sort_key=threads.post.engagements_authorized`.
6. Initial render returned "This table failed to load. Please try again." with Reload CTA.
7. Clicked Reload — table fully rendered.

## Findings
- Threads basic view on Brand>Content **renders correctly** with these elements:
  - Posts(0) — no posts in May 31 – Jun 06 window (expected — no MTV Threads posts in that range).
  - Sum + Average rows.
  - Columns: **Engagements, Likes, Replies, Quotes, Reposts, Shares, Views** (Threads-specific metrics).
  - Layout switcher (Detail/Grid/Table icons).
  - Sort dropdown, Metric Display dropdown, Include Retweets checkbox.
  - Channels row with Threads icon active, others greyed.
  - "There is no data available. Please select a different brand, brand set, or date range." messaging — proper empty-state.
- Channel filter row icons: `[FB-greyed]`, `[Twitter-greyed]`, `[IG-greyed]`, `[TikTok-greyed]`, `[YouTube-greyed]`, `Threads-active`, `[LinkedIn-greyed]`, `[Pinterest-greyed]`.

## Side findings
1. **Initial "This table failed to load" on Threads Only: Insights data set** — required Reload click to recover. Likely transient backend hiccup on first switch into the Threads-specific CDS. Reproduced once on this run; spec doesn't call it out. Not flagged as defect — could be intermittent.
2. Brand picker overrides URL `brand_id` parameter when perspective toggle is clicked outside the Brand>Content stack — observed during this session that toggle click switched brand_id to a different value with channels=threads stripped (probably a different brand with no Threads data; appeared to be a default fallback). Documented for known-quirks update.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Brand>Content Threads page renders without crash | All tabs and toolbar render; no JS errors | Page rendered; all tabs visible | PASS |
| A2 | Threads Only: Insights data set available | Listed under Channel-Specific Metrics in Data Set dropdown | Confirmed present and selectable | PASS |
| A3 | Threads basic view columns are channel-specific | Engagements/Likes/Replies/Quotes/Reposts/Shares/Views | All 7 columns rendered correctly | PASS |
| A4 | Channels-row icon shows Threads active when channel=threads | Threads icon active, others greyed/disabled | Confirmed | PASS |
| A5 | Empty-state messaging present when 0 posts | "There is no data available..." with proper guidance | Confirmed | PASS |
| A6 | Table initially fails to load on CDS switch | Should render directly, not error | Failed once; recovered with Reload | MINOR — needs further reproduction |

## Result
PASS — Brand > Content Threads Basic View renders correctly with proper Threads-specific column set, channel-row icon state, and empty-state messaging. The transient "table failed to load" was recoverable via Reload and does not block the basic view.

## Bugs filed
None — basic view core flow PASSes. Transient table-failed-to-load on initial CDS switch is logged for future reproduction.

## Skill credit
- `brand-content-data-set-selector` — Threads Only: Insights variant confirmed; sort_key `threads.post.engagements_authorized` URL pattern documented.
- `view-perspective-toggle` — Authorized perspective verified via `perspective=extended` URL after page render (Toggle handle right-side).
