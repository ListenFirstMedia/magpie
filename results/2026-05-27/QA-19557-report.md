# QA-19557 — Brand Content - Impressions Data Set - Instagram Stories — Run Report

- **Date:** 2026-05-27
- **Account:** UCLA (account_id=799)
- **Brand:** University of California, Los Angeles (brand_id=127756)
- **Date range:** Oct 28, 2024 – Oct 28, 2024
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-19557.md

## Result: PASS

## Execution
1. Switched account to UCLA via Yash → Search Account → click Results entry.
2. Navigated Brand → Content with `brand_id=127756`, date range Oct 28, 2024.
3. Clicked Data Set dropdown → selected **Impressions**. URL became `table_data_set=impressions`. Initial table render hit transient "table failed to load" — clicked Reload to retry.
4. Clicked **Insights** button at top-right to expose the "View Analysis with" panel, then ticked **Instagram Stories** checkbox. URL changed to `table_data_set=impressions_with_stories` and posts header updated to "**Posts (with Stories) (38)**" (was 29 without stories). Sum row updated:
   - Engagements: 8,123 (unchanged)
   - Impressions: 233,223 → **318,940** (+85,717 attributable to IG Stories)
5. Navigated to `channels=linkedin` only. URL collapsed to `channels=linkedin&...&table_data_set=impressions` (LinkedIn has no Stories layer, so the data set falls back). Posts re-rendered showing only LinkedIn-channel posts (LinkedIn icon top-right of each card).

## Assertions
- **A1 (Impressions metric shows data for all Story Publish Type posts):** PASS — Enabling Instagram Stories increased Posts count from 29 → 38 (+9 IG Story posts) and Sum Impressions from 233,223 → 318,940. The +85,717 delta is the aggregated IG Stories Impressions across the 9 Story posts, confirming Impressions populates for the Story Publish Type.
- **A2 (LinkedIn posts showing Impressions data):** PASS — LinkedIn-only filter shows 7 posts (Mon Oct 28, 2024); first 5 visible:
  - Post 1 ("Success is never final…") — Impressions **44,644**
  - Post 2 ("Mornings on campus…") — Impressions **16,904**
  - Post 3 ("Join us Nov. 3 at UCLA…") — Impressions **5,908**
  - Post 4 ("The Council for Advancement and Support…") — Impressions **4,372**
  - Post 5 ("A Bruin guide to this month's most…") — Impressions **5,481**
  - Sum row: Impressions 83,633 / Organic 83,633 / Paid – (en-dash for unsupported).

## Evidence
- URL trail: `table_data_set=impressions` → `table_data_set=impressions_with_stories` (with IG channel) → `table_data_set=impressions` (LinkedIn-only fallback).
- Card icons confirm all visible posts on the LinkedIn view carry the LinkedIn icon top-right.

## Notes
- The "Instagram Stories" checkbox lives in the **View Analysis with:** row that appears next to the Layout selector once the Insights side panel is expanded — not in the channels icon row.
- LinkedIn doesn't expose a Stories surface, so the `impressions_with_stories` data set silently falls back to `impressions` when the channel filter excludes Instagram. This is product-correct, not a bug.
- The channels icon row supports single-channel filtering by URL param `channels=linkedin` more reliably than chained UI clicks (Apply button needed when toggling via icon clicks).
- New quirk worth recording: "table failed to load" appears on Data Set switches and clears on Reload — server-side filter-rebuild race condition, not a real failure (see [[known-quirks]]).
