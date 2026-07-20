# QA-575 — Instagram In Window Private Data QA

- **Run:** 2026-07-11 (unattended, headless Playwright MCP, `feature/playwright-mcp`)
- **Target env:** dev only (`app.lfmdev.in`) — stage (`app.lfmstage.*`) is not reachable from magpie
- **Account / Brand:** Hulu (account_id=336) / Hulu (brand_id=5670, no auto-redirect this run)
- **Skills used:** brand-content-data-set-selector, view-perspective-toggle
- **Verdict:** **BLOCKED — cross-environment (dev↔stage) comparison not performable; both assertions require stage**

---

## Verdict rationale

QA-575 is structurally a **dev-vs-stage parity** test. Its preconditions require "dev open in 1 browser and stage open in another," and **both** in-scope assertions compare dev output against stage output:

- **A10** — dev posts must match stage posts for the same window (spec even notes stage shows *more* posts "because of the day ahead").
- **A13** — the number of posts for each view must match **between dev and stage**.

magpie operates only against dev; there is no stage access on this track (same limitation recorded for QA-567 / QA-569 / QA-581 and in this ticket's prior 2026-06-04 run, which was logged PARTIAL). Neither assertion can be evaluated without the stage side, so per Rule 1/3/5 the honest verdict is **BLOCKED** (do not fabricate a stage comparison, do not substitute). The full **dev-side** flow was still executed end-to-end to exercise the skills and capture the dev half of the comparison as evidence for a future cross-env pass.

---

## Steps executed (dev side)

| # | Spec step | Done on dev | Notes |
|---|-----------|-------------|-------|
| 1 | Brand top-nav → Content | ✅ | Hovered Brand menu → clicked Content |
| 2 | Brand search → Hulu | ✅ | Account switched Adam Orfei → **Hulu** via LFQA menu (hover) → Search Account "Hulu" → **Results** row (Rule 1). Brand Hulu brand_id=5670, account_id=336; header "Account: Hulu" |
| 3 | Select Instagram channel | ✅ | Disabled facebook/twitter/tiktok/linkedin/threads via trusted clicks → **Apply** → `channels=instagram` |
| 4 | Click Content on stage | ⏭ | STAGE — not reachable (out of env scope) |
| 5 | Click Content on dev | ✅ | Content table rendered (Posts loaded first attempt) |
| 6 | End date back by 2 days | ✅ | Date Range modal (paired from/to calendar): end Jul 09 → **Jul 07**; `to=2026-07-07` (from stayed Jul 03) |
| 7 | Calendar → Select Mode = In Window | ✅ | Select Mode radio Lifetime → **In Window** (input `checked=true`) → Ok → `stats_attribution_window=in_window` |
| 8 | Data Set dropdown → Impressions | ✅ | `table_data_set=impressions` |
| 9 | On Stage click Impressions | ⏭ | STAGE — not reachable |
| 10 | Compare impressions data | ⛔ | Dev captured; **stage half unavailable** → A10 not evaluable |
| 11 | Content → Video Views data set | ✅ | `table_data_set=video_views` |
| 12 | Content → Video Views data set (2nd env = stage) | ⏭ | STAGE — not reachable |
| 13 | Compare video view data | ⛔ | Dev captured; **stage half unavailable** → A13 not evaluable |

Perspective was **Authorized** (`perspective=extended`) throughout — consistent with "Private Data" in the case title (in-window private/authorized metrics). Confirmed via DOM toggle probe (`input#perspective checked=true`, not disabled) **and** the screenshot (handle on the right / "Authorized Data" side) **and** the aggregate showing populated Impressions/Video Views (a public-only view would lock these). Rule 2 satisfied — toggle state verified by widget, not by URL alone.

---

## Dev-side evidence

**Config:** Hulu / Instagram only / **In Window** / Authorized / range **Jul 03 – Jul 07, 2026** (end −2 days).

### Impressions data set — `table_data_set=impressions` — **Posts (13)**
Screenshot: `.playwright-out/QA-575/05-impressions-dataset.png`

| Metric | Sum | Average |
|--------|-----|---------|
| Engagements | 131,912 | 10,147 |
| Engagement Rate | N/A | 5.77% |
| Impressions | 2,287,634 | 175,972 |
| Organic Impressions | 2,287,634 | 175,972 |
| Paid Impressions | – | – |
| Reach | N/A | 129,575 |
| Organic Reach | N/A | 129,575 |
| Paid Reach | N/A | – |
| Engaged User Rate | N/A | 7.83% |

### Video Views data set — `table_data_set=video_views` — **Posts (11)**
Screenshot: `.playwright-out/QA-575/06-videoviews-dataset.png`

| Metric | Sum | Average |
|--------|-----|---------|
| Engagements | 110,056 | 10,005 |
| Video Response Rate | N/A | 5.56% |
| Video Views | 1,979,266 | 179,933 |
| Organic Views | 1,979,266 | 179,933 |
| Paid Views | – | – |
| Unclassified Views | 0 | 0 |
| Viewers | – | – |
| Video Duration | – | – |
| Watch Time (Minutes) | 610,429.72 | 55,493.61 |

**Dev-side observation on A13 (NOT a filed bug):** unlike the Facebook variant (QA-569, where both data-set views held **11** posts each), on **Instagram** the two data-set views hold **different** post counts — Impressions **Posts (13)** vs Video Views **Posts (11)** — and the Sum Engagements differ accordingly (131,912 vs 110,056). This is because the **Video Views data set scopes the post list to video-bearing posts**; the 2 non-video IG posts (static image / carousel) in this window have no video-views metric and drop out of the Video Views view. This is expected data-set scoping (IG mixes video and non-video post types, where the QA-569 Facebook window happened to be all video-eligible), **not** a defect — so it is documented, not filed (Rule 5). It does mean the *within-dev* post counts do not trivially match; A13's real intent (dev video-view count == stage video-view count, minus the day-ahead posts) still requires the stage side.

---

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A10 | 10 | Dev posts' impressions data matches stage for those posts (stage shows more posts due to day-ahead) | Dev captured cleanly (Impressions Posts 13; Sum Impressions 2,287,634 / Sum Engagements 131,912). **Stage side unreachable — no comparison possible** | **BLOCKED** (cross-env) |
| A13 | 13 | Number of posts for each view matches (dev vs stage) | Dev captured: Impressions Posts(13), Video Views Posts(11) (difference = IG video-only scoping, expected). **Stage side unreachable — cross-env match not verifiable** | **BLOCKED** (cross-env) |

---

## Known bugs checked

- **Case "Open linked bugs":** `knowledge-base/bug-history.md` QA-575 entry records **Open bugs (0) — None** (closed history exists, none open). The ingested `testcases/english/QA-575.md` has no open-defect section. Rule 7 open-bug screen: **passed** (no open blocker).
- **bug-history grep (QA-575):** prior 2026-06-04 run was PARTIAL for the same dev-only reason; it documented a transient **"This table failed to load. Please try again." + Reload** tile-render lifecycle hiccup on the IG variant. This run the Impressions and Video Views tables **rendered on first attempt** (no "failed to load"), so that render-lifecycle quirk did **not** reproduce.
- The prior 2026-06-04 run captured Impressions & Video Views both at **Posts (10)** on the May 25–27 window; this run's differing counts (13 vs 11) are a function of the different, later date window (Jul 03–07) and the IG video/non-video post mix, not a regression.
- No new bug behavior observed on the dev side; aggregates are self-consistent (Organic == total where Paid is –/0).

## Bugs filed

None.

---

## Recommendation

Retarget QA-575 to be runnable on a single environment, or provide magpie with stage access, so the dev↔stage parity assertions (A10/A13) can be evaluated. As written, this case is permanently BLOCKED on this track (dev-only). The dev-side numbers above are captured for whoever runs the manual cross-env comparison. Note for the manual runner: on IG, expect the Impressions and Video Views views to hold different post counts (video-only scoping) — compare each view dev↔stage, not Impressions↔Video Views.
