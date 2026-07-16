# QA-569 — Facebook In Window Private Data QA

- **Run:** 2026-07-11 (unattended, headless Playwright MCP, `feature/playwright-mcp`)
- **Target env:** dev only (`app.lfmdev.in`) — stage (`app.lfmstage.*`) is not reachable from magpie
- **Account / Brand:** Hulu (account_id=336) / Hulu (brand_id=5670, no auto-redirect this run)
- **Skills used:** brand-content-data-set-selector, view-perspective-toggle
- **Verdict:** **BLOCKED — cross-environment (dev↔stage) comparison not performable; both assertions require stage**

---

## Verdict rationale

QA-569 is structurally a **dev-vs-stage parity** test. Its preconditions require "dev open in 1 browser and stage open in another," and **both** in-scope assertions compare dev output against stage output:

- **A10** — dev posts must match stage posts for the same window (spec even notes stage shows *more* posts "because of the day ahead").
- **A13** — the number of posts for each view must match **between dev and stage**.

magpie operates only against dev; there is no stage access on this track (same limitation recorded for QA-567 / QA-575 / QA-581 and in this ticket's prior 2026-06-04 run, which was logged PARTIAL). Neither assertion can be evaluated without the stage side, so per Rule 1/3/5 the honest verdict is **BLOCKED** (do not fabricate a stage comparison, do not substitute). The full **dev-side** flow was still executed end-to-end to exercise the skills and capture the dev half of the comparison as evidence for a future cross-env pass.

---

## Steps executed (dev side)

| # | Spec step | Done on dev | Notes |
|---|-----------|-------------|-------|
| 1 | Brand top-nav → Content | ✅ | Navigated to Brand > Content |
| 2 | Brand search → Hulu | ✅ | Hulu brand_id=5670, account_id=336; header "Account: Hulu", brand "Hulu" |
| 3 | Select Facebook channel | ✅ | Disabled twitter/instagram/tiktok/linkedin/threads via trusted clicks → **Apply** → `channels=facebook` |
| 4 | Click Content on stage | ⏭ | STAGE — not reachable (out of env scope) |
| 5 | Click Content on dev | ✅ | Content table rendered |
| 6 | End date back by 2 days | ✅ | Date Range modal (paired from/to calendar): end Jul 09 → **Jul 07**; `to=2026-07-07` (from stayed Jul 03) |
| 7 | Calendar → Select Mode = In Window | ✅ | Select Mode radio Lifetime → **In Window** (input `checked=true`) → Ok → `stats_attribution_window=in_window` |
| 8 | Data Set dropdown → Impressions | ✅ | `table_data_set=impressions` |
| 9 | On Stage click Impressions | ⏭ | STAGE — not reachable |
| 10 | Compare impressions data | ⛔ | Dev captured; **stage half unavailable** → A10 not evaluable |
| 11 | Content → Video Views data set | ✅ | `table_data_set=video_views` |
| 12 | Content → Video Views data set (2nd env = stage) | ⏭ | STAGE — not reachable |
| 13 | Compare video view data | ⛔ | Dev captured; **stage half unavailable** → A13 not evaluable |

Perspective was **Authorized** (`perspective=extended`) throughout — consistent with "Private Data" in the case title (in-window private/authorized metrics). Confirmed via URL param **and** the aggregate showing populated Impressions/Video Views (public-only view would lock these).

---

## Dev-side evidence

**Config:** Hulu / Facebook only / **In Window** / Authorized / range **Jul 03 – Jul 07, 2026** (end −2 days).

### Impressions data set — `table_data_set=impressions` — **Posts (11)**
Screenshot: `.playwright-out/QA-569/impressions-fb-inwindow.png`

| Metric | Sum | Average |
|--------|-----|---------|
| Engagements | 68,148 | 6,195 |
| Engagement Rate | N/A | 1.44% |
| Impressions | 4,740,293 | 430,936 |
| Organic Impressions | 4,740,293 | 430,936 |
| Paid Impressions | 0 | 0 |
| Reach | N/A | – |
| Organic Reach | N/A | – |
| Paid Reach | N/A | – |
| Engaged User Rate | N/A | – |

### Video Views data set — `table_data_set=video_views` — **Posts (11)**
Screenshot: `.playwright-out/QA-569/videoviews-fb-inwindow.png`

| Metric | Sum | Average |
|--------|-----|---------|
| Engagements | 68,148 | 6,195 |
| Video Response Rate | N/A | 2.56% |
| Video Views | 2,662,141 | 242,013 |
| Organic Views | 2,662,141 | 242,013 |
| Paid Views | 0 | 0 |
| Unclassified Views | 0 | 0 |
| Viewers | 2,656,960 | 241,542 |
| Video Duration | 28m54s | 2m37s |
| Watch Time (Minutes) | – | – |

**Dev-side internal consistency (partial support for A13):** post count is **11 for both** Impressions and Video Views, and Engagements (68,148 Sum / 6,195 Avg) is identical across both data sets — the per-view post counts match on dev. This is the dev half of A13; the assertion still needs the stage count to actually pass.

---

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A10 | 10 | Dev posts' impressions data matches stage for those posts (stage shows more posts due to day-ahead) | Dev captured cleanly (Posts 11; Sum Impressions 4,740,293). **Stage side unreachable — no comparison possible** | **BLOCKED** (cross-env) |
| A13 | 13 | Number of posts for each view matches (dev vs stage) | Dev: Impressions Posts(11) == Video Views Posts(11). **Stage side unreachable — cross-env match not verifiable** | **BLOCKED** (cross-env) |

---

## Known bugs checked

- **Case "Open linked bugs":** the ingested `testcases/english/QA-569.md` has no "Open linked bugs" section listing any open defect; `knowledge-base/bug-history.md` QA-569 entry records **Open bugs (0) — None**. Rule 7 open-bug screen: **passed** (no open blocker).
- **bug-history grep (QA-569):** prior 2026-06-04 run was PARTIAL for the same dev-only reason; documented a transient **"This table failed to load. Please try again." + Reload** tile-render lifecycle hiccup on the IG variant. This run the Impressions and Video Views tables **rendered on first attempt** (no "failed to load"), so that render-lifecycle quirk did **not** reproduce.
- No new bug behavior observed on the dev side; aggregates and post counts are self-consistent.

## Bugs filed

None.

---

## Recommendation

Retarget QA-569 to be runnable on a single environment, or provide magpie with stage access, so the dev↔stage parity assertions (A10/A13) can be evaluated. As written, this case is permanently BLOCKED on this track (dev-only). The dev-side numbers above are captured for whoever runs the manual cross-env comparison.
