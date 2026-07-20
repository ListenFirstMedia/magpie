# Batch 7 Run Log — 2026-06-02

Tickets: QA-100764, QA-103248, QA-104870, QA-1053, QA-106218.

## QA-100764 — Brand > Content - Daily Post Analysis Modal - Threads
- **Result:** PASS 6/6
- **Account/Brand:** HBO Max / HBO Max (brand_id=155614). Spec "Max" remapped to HBO Max per prior batch.
- **Channel:** Threads only.
- **Modal window:** Jan 04 – Feb 01 2026 (auto post-publish + 28d).
- **Data Set:** Threads Only: Insights.
- **Notes:** Same outcome as 2026-05-27. Rebrand metadata note on A2 still applies. Area chart re-renders with Y-axis re-scaled 0→65K (vs 0→55K Line). Modal Close button (bottom) dismisses cleanly.
- **Bugs:** none.
- **Skills:** brand-content-data-set-selector +1.

## QA-103248 — Brand Sets > Content - Daily Post Analysis Modal - Export - PNG & Google Sheets
- **Result:** PASS 8/8 (upgraded from BLOCKED)
- **Account/Brand Set:** Adam Orfei / LF // TV // Episodic (brand_set_id=756) — spec brand set, picked from typeahead Results.
- **Date window:** May 25–31 2026 (7-day default — no hang).
- **Post analysed:** Off Campus (APV) TikTok video, Thu May 28 2026 08:01 AM PDT.
- **PNG verified end-to-end:** `Off Campus (APV)-Daily Content Analysis-Bar-2026-05-28-2026-05-31.png` (1507×860, 80KB). Logo + title + bar chart + Daily Content Analysis footer all confirmed.
- **Google Sheets verified end-to-end:** tab title matches spec pattern; rows 3-8 in sheet match the modal's per-date table (SUM=3.77M, AVG=942.5K, May 28=2.67M, May 29=1.10M).
- **Diagnostic:** Adam's Brand Set on 7-day window pre-tested fine, so we proceeded to the spec brand set (LF // TV // Episodic). Prior batch's hang appears to have been driven by long-window data fetch, not the brand set itself.
- **Bugs:** none.
- **Skills:** new candidate `daily-post-analysis-modal-run`.

## QA-104870 — Settings > Custom Data Sets - Basic View
- **Result:** PASS 12/13 + 1 N/A (A5 blank-state — Adam Orfei has 9 CDSes)
- **Account:** Adam Orfei (account_id=54), 9 custom data sets listed.
- **Settings dropdown order:** API, Audit, Authorization, Brand Sets, Brands, Custom Data Sets (highlighted, after Brands), Custom Metrics, Data Collection, Data Identities, Integrations, Notifications, Tags, Topics, Users.
- **Ellipsis menu:** Edit / Delete / Duplicate in spec order.
- **Date format:** `Mon. DD, YYYY` on all 9 rows.
- **Bugs:** none.
- **Skills:** settings-custom-data-sets +1.

## QA-1053 — TWC Aggregate Relative Dates Lock + Endash
- **Result:** PASS 3/3
- **Account:** Hulu (account_id=336). Brands: Hulu (Authorized), FFwSB (Public), Snowfall (Public). Key Date = Jan 01, 2024 for all 3. Interval=Aggregate (Relative Dates, Start=5 Days Before, End=0 Days After).
- **Metrics:** Instagram Comments + TikTok Total Followers.
- **A1 (TikTok endash Snowfall):** PASS — table cell shows `–`, graph has no Snowfall bar.
- **A2 (Lock for IG Comments on FFwSB+Snowfall):** PASS — both graph X-axis positions render colored lock icons; table cells show lock icons.
- **A3 (TikTok numbers for Hulu+FFwSB):** PASS — Hulu=5,500,000, FFwSB=149,700.
- **Bugs:** none.
- **Skills:** time-window-comparison-run +1, keydate-picker +1.

## QA-106218 — Settings > Custom Data Sets - Create flow
- **Result:** PASS 13/14 + minor `MM-DD-YYYY | HH:MM AM/PM PT` format variance (space separator vs pipe)
- **Account:** Adam Orfei. Mutating CDS name `QA-106218-rerun-2236`.
- **Selected Metrics (7):** Engagements, Reactions, Response Rate, Comments🔒, Shares🔒, Engagement Rate🔒, Impressions🔒.
- **Cleanup:** Delete via ellipsis menu → Ok confirmation → row removed. 0 residue.
- **Bugs:** none.
- **Skills:** settings-custom-data-sets +1.
