---
name: brand-sets-content-vs-brand-content
version: 1
last_verified: 2026-10-20
last_passed_run: 2026-10-20
trust: untrusted
pass_streak: 4
preconditions: [user-logged-in, account-set]
postconditions: [brand-sets-vs-brand-content-diff-evaluated]
inputs: [account_name, brand_set_name, content_brand, channels, rank_metrics, data_mode]
outputs: [per-post value diff per rank metric, missing posts]
related_pages: ["/#explore/competitive/content", "/#explore/brand/content"]
---

# Brand Sets > Content vs Brand > Content (Data Test sets QA-26183: QA-573, QA-576, QA-32524, QA-32526, QA-60304)

Rank a brand set's posts by one metric, restrict to one Content Brand, and check every post's value equals the same post on Brand > Content. Mechanics verified 2026-10-20 on Viacom / "LF // TV // Episodic" / The Daily Show.

## Mechanics
1. **Navigation:** hover `.navigation-menus .navigation-menu-header-label` "Brand Sets" → click the **visible** `a.navigation-menu-link` "Content" (`href="#explore/competitive/content?brand_set_id=…"`). A plain `getByText('Content')` resolves to the hidden Brand-menu link and times out. The account's default brand set loads with up to 5 channel ghosts (facebook, twitter, instagram, youtube, tiktok — no linkedin/threads/pinterest on this page) and can take 60–90 s on dev.
2. **Brand set picker** = the same `.brand-selector` as Brand > Content: click `.brand-selector-name-container`, type into the visible `textarea.lfm-textarea`, real mouse click on the `.lfm-ta-option` whose text equals the set name. URL gains `brand_set_id=` (LF // TV // Episodic = 756).
3. **Rank By** = the single visible `.lfm-dropdown-select-box` ("Rank:"); options seen: Engagements, Comment Rate, Comments, Public Impressions, Reaction Rate, Reactions, Response Rate, Share Rate, Shares, Video Views (public) and, under Authorized Data, Impressions, Video Views (duplicates of the public labels — pick by position: the LAST "Video Views"/"Impressions" entries are the authorized ones). URL `rank_by_metric=`. Table View shows ONE metric column (the rank metric) plus `Share`, `Brand`, `Programmer`, 100 rows per page.
4. **Content Brand filter:** `[data-ui-name=brand_select_filter_cta]` (the generic `[data-ui-name*=select_filter]` matches it) → `.option-row` "Content Brand" → the LAST visible `textarea.lfm-textarea[placeholder="Search"]` → type the brand → click the `.option-row` with that exact text → `[data-ui-name=apply_filter_cta]`. URL `filters={"content_brand_ids":{"operator":"or","values":[<id>],"not":"false"}}` (The Daily Show = 9973). **Applying the filter resets the channel ghosts to all channels** — re-apply the single-channel selection AFTER the filter.
5. **Channels:** `.channel-ghost.<c>` enable-wanted-first, then disable the rest, then `Apply`; only touch ghosts that exist on the page.
6. **Rank Mode:** "Overall | Filtered" radio text next to `Rank Mode:` (spec step "select Filtered Rank mode" for the private-data cases).
7. **Scrape** with the grid-math scraper (`table.lfm-table` with `Rank` header). Join to Brand > Content rows by post permalink — ignore the in-app `#explore/brand/content?brand_id=…` link that Brand Sets rows also carry; Facebook rows have NO permalink on either surface, so fall back to `Date|Text[0:60]`. Brand > Content YouTube basic set exposes `Video Views / Likes / Comments` (Likes ≙ Reactions). If a scrape comes back empty right after a channel/rank change, wait and re-scrape (`scrapeStable`).
8. **Rank By resets channels too** (not only the filter): re-apply the single channel after EVERY Rank By change, before scraping.

## Judging
- Every Brand Sets row must exist on Brand > Content for the same brand/channel/window and carry the same value for the rank metric. A Brand Sets page shows at most 100 rows; if the brand has more posts, compare the top 100 only and say so.

## Failure signatures
| Signature | Interpretation | Action |
|---|---|---|
| Channel ghosts back to "all" after Apply Filter | known page behaviour | re-run setChannels |
| Row count differs by a few posts between surfaces | Lifetime vs In-Window mode or perspective mismatch | align `stats_attribution_window` and perspective, re-scrape |

## Changelog
- **v1** (2026-10-20): initial mechanics from QA-573 (YouTube, The Daily Show); verified on QA-576 (Instagram), QA-60304 (public vs authorized rank), QA-32524 (authorized Impressions, FB/IG/TikTok, Filtered rank mode) — all PASS.
