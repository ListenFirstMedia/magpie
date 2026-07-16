# QA-99416 — Brand Sets > Content · Daily Post Analysis Modal — Table Display & Behavior

- **Run:** 2026-07-11 (unattended, headless, Playwright MCP, branch `feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-99416
- **Account / Brand Set:** Adam Orfei (account_id=54) → Adam's Brand Set (brand_set_id=1738)
- **Skill reused:** `brand-content-dpa-modal` (v1, untrusted) — Brand Sets variant
- **Verdict:** **PASS** (5/5 assertions)

## Preconditions
- Logged in as `lfiqa@listenfirstmedia.com` via Cognito existing-account form; `/#home` rendered.
- Brand Set with multi-brand content data: Adam's Brand Set, 7-day window (Jul 04–10 2026) → Posts (1,805) with Engagements rank. 7-day window used deliberately to avoid the known 76K-post render hang on the 30-day window (known-quirks: "Adam Orfei Brand Set returns ~76K posts").

## Steps executed
1. Navigated to Brand Sets > Content for Adam's Brand Set (`#explore/competitive/content?brand_set_id=1738`). Page resolved to account_id=54, window Jul 04–10 2026, all 5 channels, Mode Lifetime, Rank = Engagements. Posts (1,805) rendered. Screenshot `01-brand-sets-content-loaded.png` / `02-posts-loaded.png`.
2. Date range = Jul 04–10 2026 (Last-7-Days equivalent with daily data). (30-day intentionally avoided — hang quirk.)
3. Opened Daily Post Analysis modal via top-ranked post's `button.daily-analysis-button` (JS-fallback click). Top post: **NBA, Instagram, published Tue Jul 07 2026 10:28 AM PDT, Engagements 535,576.** Modal `.al-daily-post-analysis-modal` opened — header `Date Range: Jul. 07, 2026 - Jul. 10, 2026 / Mode: In Window / Rank: Engagements / Graph Metrics: Engagements`. Screenshot `03-dpa-modal-open.png`.
4. Table view: the DPA modal renders a persistent data **Table** beneath the chart (chart-type dropdown `.dropdown-name` offers Area/Bar/Line/Pie — the tabular data view is always shown, not a chart-type). Table read from DOM.
5. Verified columns: `Metric | Sum | Average | <per-day date columns>`. Engagements row read (see evidence).
6. Verified each date column = a day in range and values reconcile to Sum/Average (math below).
7. **Switched metric:** closed modal → changed page Rank-by dropdown (`.rank-by-container`) from Engagements → **Video Views** (`rank_by_metric=lfm.content.public_video_views_v5`). Page re-ranked to Posts (1,420); new top post **NBA, Instagram Reel, published Mon Jul 06 2026 04:28 PM PDT, Video Views 6,411,490**. Re-opened DPA modal → table repopulated with the Video Views metric and a new 5-day range. Screenshot `04-dpa-modal-video-views.png`.
8. Endash probe: no `–` markers on any date column in either metric. DATA-12209 (TikTok endash on 2026-05-16) is **N/A** — both posts are Instagram and the range is July 2026, so no TikTok/May-16 surface was in play.

## Evidence — table values

**Engagements (Rank = Engagements), range Jul 07–10 2026 (4 days):**

| Metric | Sum | Average | Jul 07 | Jul 08 | Jul 09 | Jul 10 |
|---|---|---|---|---|---|---|
| Engagements | 535,576 | 133,894 | 260,889 | 230,410 | 25,278 | 18,999 |

- Sum check: 260,889 + 230,410 + 25,278 + 18,999 = **535,576** ✓
- Average check: 535,576 / 4 = **133,894** ✓

**Video Views (Rank = Video Views), range Jul 06–10 2026 (5 days):**

| Metric | Sum | Average | Jul 06 | Jul 07 | Jul 08 | Jul 09 | Jul 10 |
|---|---|---|---|---|---|---|---|
| Video Views | 6,411,490 | 1,282,298 | 3,760,201 | 1,443,851 | 807,453 | 231,501 | 168,484 |

- Sum check: 3,760,201 + 1,443,851 + 807,453 + 231,501 + 168,484 = **6,411,490** ✓
- Average check: 6,411,490 / 5 = **1,282,298** ✓

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3–4 | Modal opens with Table view option | `.al-daily-post-analysis-modal` opened; persistent data table rendered beneath the chart (Metric/Sum/Average/per-day) | PASS |
| A2 | 5 | Table columns match metric / date schema | Columns = `Metric \| Sum \| Average \| <per-day date columns>` in both metric states | PASS |
| A3 | 6 | Row count matches days in range | Date columns = days in modal range: 4 cols for Jul 07–10; 5 cols for Jul 06–10 after metric switch | PASS |
| A4 | 7 | Switching metric repopulates table | Rank Engagements→Video Views repopulated the table with new metric, new 5-day range, new values (all reconciling) | PASS |
| A5 | 8 | Endash markers only on documented data gaps | No endash on any date column; no undocumented gaps. DATA-12209 N/A (IG posts, July range) | PASS |

## Known bugs checked
- **bug-history.md grep QA-99416:** prior run (2026-06-04 batch-7) PASS 5/5; only linked concern is **DATA-12209** (Major, Open — TikTok metric endash on 2026-05-16, seen on Brand>Content TikTok posts). This case exercised **Instagram** posts in a **July 2026** range, so DATA-12209's surface (TikTok / May 16) is not reachable → **not applicable**, does not interfere with any assertion.
- Case file has no "Open linked bugs" section; Rule 7 screen result = clear (no interfering open bug).

## Bugs filed
- None. No new defects observed; all assertions passed and Sum/Average math reconciled exactly in both metric states.

## Notes
- No data mutation performed. The only state change was the page Rank-by metric (a view/URL param, `lfm.content.public_video_views_v5`), not persisted data — no cleanup required.
- Screenshots under `.playwright-out/QA-99416/`: `01-brand-sets-content-loaded.png`, `02-posts-loaded.png`, `03-dpa-modal-open.png`, `04-dpa-modal-video-views.png`.
