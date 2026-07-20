# QA-581 — Twitter In Window Private Data QA

- **Run date:** 2026-07-11 (unattended, headless Playwright MCP track)
- **Account:** Hulu (account_id=336) — switched from default Adam Orfei (account_id=54)
- **Brand:** Hulu (brand_id=5670, Authorized/Private entity)
- **Surface:** Brand > Content
- **Config:** Twitter channel · In Window · Jul 03–07, 2026 · perspective=extended (Authorized / "Private Data")
- **Verdict:** **PASS** (dev-only; stage↔dev parity out of scope — deferred per QA-569 pattern)
- **Skills used:** switch-account, brand-content-data-set-selector, view-perspective-toggle, brand-content-table-view

## Scope note (why dev-only)
The case is a **dev-vs-stage parity** test (precondition: "dev open in 1 browser and stage open in another"; both scoring assertions compare dev against stage). magpie runs against **dev only** — the stage environment is not accessible on this track, and the case file itself records "stage parity is deferred per QA-569 pattern." Therefore every step was executed **in full on dev**, and the stage-comparison halves of A10/A13 are marked **NOT VERIFIED — out of scope**. The in-scope verification is that the dev Impressions and Video Views data sets render correct, internally-consistent data for the Hulu Twitter In-Window Private (Authorized) configuration.

## Precondition handling — account switch (key finding)
"Private Data" = the **Authorized** perspective. On the default **Adam Orfei** account, Hulu resolves to the Public-only entity (brand_id=11003) whose **Authorized-Data toggle is `disabled`** (`toggle-switch-disabled`, checkbox `disabled`) — Adam Orfei has no authorized access to Hulu. Per the account-precondition workflow, switched account **Adam Orfei → Hulu** via the LFQA menu (typed "Hulu", clicked the exact "Hulu" **Results** entry). On the Hulu account, Brand>Content defaults to **brand_id=5670** with `perspective=extended` and the perspective toggle **enabled + checked (Authorized)** — the correct "Private Data" precondition.

## Steps executed (dev)
| # | Step | Action taken | Result |
|---|------|--------------|--------|
| 1 | Brand > Content | Home → Brand Content view | Brand Explorer / Brand>Content loaded |
| 2 | Brand search → Hulu | Chevron → typed "Hulu" slowly → clicked exact "Hulu" (Rule 1, Results header) | Hulu selected |
| — | Precondition: Private (Authorized) | Perspective toggle disabled on Adam Orfei/Hulu-11003 → switched account to **Hulu** → brand 5670 `perspective=extended`, toggle enabled+checked | Authorized/Private active |
| 3 | Select 'Twitter' channel | Disabled FB/IG/TikTok/LinkedIn/Threads (trusted clicks), kept Twitter, clicked Apply | `channels=twitter` |
| 6 | End date back 2 days | Date picker → clicked day **7** in End Date calendar (was Jul 9) | Range Jul 03 – **Jul 07** |
| 7 | Mode = In Window | Clicked "In Window" radio → Ok | `stats_attribution_window=in_window` |
| 8 | Data set → Impressions | Opened Data Set dropdown, clicked cross-channel "Impressions" | `table_data_set=impressions` |
| 10 | Compare impressions data | Captured dev aggregate (stage N/A — out of scope) | see A10 |
| 11–12 | Data set → Video Views | Opened Data Set dropdown, clicked cross-channel "Video Views" | `table_data_set=video_views` |
| 13 | Compare video view data | Captured dev post count (stage N/A — out of scope) | see A13 |

(Stage-side steps 4/9 and the stage halves of 1–3/5–7 are out of scope; not performed.)

## Dev evidence

**Impressions data set** (Twitter · In Window · Authorized · Jul 03–07) — `04-impressions-data.png`
- **Posts (9)**
- Sum: Engagements **505** · Engagement Rate N/A · **Impressions 126,579** · Organic Impressions 126,579 · Paid Impressions – · Reach N/A · Organic/Paid Reach N/A · Engaged User Rate N/A
- Average: Engagements 56 · Engagement Rate 0.40% · **Impressions 14,064** · Organic 14,064 · Paid – · others –

**Video Views data set** (same config) — `05-videoviews-data.png`
- **Posts (5)**
- Sum: Engagements **93** · Video Response Rate N/A · **Video Views 13,024** · Organic Views 13,024 · Paid Views – · Unclassified Views 0 · Viewers/Duration/Watch Time –
- Average: Engagements 19 · VRR 0.71% · **Video Views 2,605** · Organic 2,605 · Paid – · Unclassified 0

Post-count differs across data sets (Impressions 9 vs Video Views 5) as expected — Video Views only counts video posts within the same window; this is not the A13 comparison (A13 compares the *same* view dev↔stage).

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A10 | 10 | Dev impressions data matches stage for the same posts (stage shows more posts due to day-ahead) | Dev renders valid Impressions: Posts(9), Sum Impressions 126,579, Avg 14,064. **Stage not accessible → parity NOT VERIFIED (out of scope).** | NOT VERIFIED (out of scope) — dev side OK |
| A13 | 13 | Number of posts for each view matches (dev↔stage) | Dev renders valid Video Views: Posts(5), Sum Video Views 13,024. **Stage not accessible → parity NOT VERIFIED (out of scope).** | NOT VERIFIED (out of scope) — dev side OK |

## Known bugs checked
- **Rule 7 / open linked bugs:** case file lists no "Open linked bugs" section → screen passed, case run normally.
- **bug-history.md (grep QA-581):** prior 2026-06-04 run PARTIAL — "Twitter Video Views tile skeleton-hang; stage not accessible."
- **Twitter Brand>Content In Window Video Views tile skeleton-hang** (known-quirks, 45+s no-error): **DID NOT REPRODUCE** this run — Video Views rendered in <5s with Posts(5) + full aggregate (Sum 13,024). No skeleton, no hang.

## Bugs filed
None.

## Verdict
**PASS** — all executable steps ran in full on dev; both Impressions and Video Views data sets rendered correct, internally-consistent Private (Authorized) data for Hulu Twitter In-Window (Jul 03–07). The Video Views skeleton-hang from the prior run did not reproduce. The A10/A13 stage↔dev comparisons are **out of scope** (dev-only track; stage parity deferred per QA-569 pattern) and are recorded as NOT VERIFIED rather than failing the case.
