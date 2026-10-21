---
name: brand-content-grid-math
version: 1
last_verified: 2026-10-19
last_passed_run: 2026-10-19
trust: untrusted
pass_streak: 24
preconditions: [user-logged-in, account-set]
postconditions: [per-post-identities-evaluated]
inputs: [account_name, brand_name, data_set, channels, from_date, to_date, identities]
outputs: [per-post pass/fail counts, aggregate Sum/Average rows]
related_pages: ["/#explore/brand/content"]
---

# Brand > Content — per-post / aggregate math identities (Data Test set QA-27628)

Verify "In each grid post, A + B (+ C) = Total" and "X / Y = Rate" identities for ALL rendered posts by scraping **Table View** once via `browser_evaluate`, instead of reading tiles one by one. Verified 2026-10-19 on 24 PASS cases (HBO Max, UCLA, Sephora, Hulu).

## Mechanics
1. **Order of operations matters:** pick the **data set first, then the channel(s)**. Channel-specific sets grey out other channels (Engagements Breakdown → Twitter+Instagram only; Facebook Only: … → Facebook; YouTube Only: … → YouTube) and a click on a greyed ghost is silently ignored. The app also ignores a click that would deselect the **last** enabled channel — enable the new channel before disabling the old one, then verify `.channel-ghost.<name>.enabled` and click **Apply**.
2. **Data set dropdown:** the first `.lfm-dropdown-select-box` in the DOM is hidden; use the **visible** one (`filter({visible:true})`), trusted click, then the visible `.lfm-dropdown-option` with the exact label. Labels seen: Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, Facebook Only: Reactions, Facebook Only: Completed Video Views, Twitter Only: Engagements & Follows, Instagram Only: Insights, YouTube Only: Insights, YouTube Only: Premium, Pinterest Only: Basic (+ custom sets).
3. **Date range:** `brand-content-native-post-check` documents the START DATE / END DATE picker.
4. **Table View:** `[title="Table View"]`; verify a visible `table.lfm-table` whose `thead th` includes `Rank` (other `lfm-table`s exist on the page). Renders **200 posts per page** plus the aggregate row (`Rank` cell "Sum Average"). Sum ↔ Average toggle: `.aggregate-row-toggle-container label.toggle-switch-label` (Table View only).
5. **Scrape:** headers from `thead th`, rows from `tbody tr` → `{header: cellText}`; parse numbers with commas/`%`/`K`/`M`; `–` = no data. Evaluate each identity in page JS and return only counts + a few samples/failures (keeps the agent context small).
6. **Judging:** sums must match exactly; rates within ±0.01 pp of the 2-decimal display; the Average row can be off by ±1 (individually rounded averages). A component that is structurally absent for a channel (LinkedIn Organic/Paid Views, Instagram Shares, Twitter Reach, Pinterest Pin Saves) renders "–" → treat as 0 and say so; a row where the TOTAL is "–" is "no data" → skip and count it.
7. **Slow dev:** after Apply/date change poll `Posts (N)` up to ~90 s; on "This table failed to load" click the Reload link (`.error-data-link a`) once.
8. **Paid/Organic filter:** `[data-ui-name=content_select_filter_cta]` → `.option-row` "Paid" → `.option-row` "Boosted" / "Organic" → `[data-ui-name=apply_filter_cta]`; URL `filters={"content_is_paid":{"values":["Promoted"|"Unpaid"]}}`; clear with the "Clear All" text button. Paid rows carry `i.fa-dollar-sign[title="Paid post"]` in the Paid column.

## Findings that recur (2026-10-19)
- Facebook: ~17 of 30 current-week posts carry "–" on every impression/view metric (collection disruption banner) — identities evaluated on the rest.
- Twitter User Follows "–" on all current posts (LFMP-32088) but present for 2024.
- Oct 2023 – Sep 2024 Facebook: ~15% of top posts have a total Impressions/Reach value with no organic/paid split (QA-20321 FAIL candidate).
- HBO Max LinkedIn has 0 posts in the default week (QA-24276/24278 LinkedIn legs not evaluable).

## Changelog
- **v1** (2026-10-19): initial from the QA-27628 run.
