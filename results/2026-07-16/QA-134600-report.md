# QA-134600 — BrandSet > Ranking > Public Video View & Average Public Video View Export Functionality

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134600
- **Run date:** 2026-07-16
- **Track:** Playwright MCP (`feature/playwright-mcp`)
- **Skill used:** `skills/brand-sets-rankings/SKILL.md`, `skills/export-csv/SKILL.md`
- **Account:** Viacom (account_id=181), Brand Set: LF // TV // Episodic (brand_set_id=756), date range Jul 8-14, 2026 (default range at run time — ticket's example dates were Apr 8-14, but the assertions only check that the CSV reflects whatever UI range is active, which it does)
- **Result: PASS** (10/11 assertions PASS, 1 new finding — channel-scoping inconsistency between the two metric exports)

## Steps executed
1. Brand Sets > Rankings, LF // TV // Episodic brand set, Viacom account.
2. Rank dropdown → selected "Public Video Views" (`rank_by_metric=lfm.owned_videos_score.public_owned_video_views_delta_v5`).
3. Channel selector: deselected Facebook/Twitter/YouTube/TikTok, leaving Instagram only enabled → Apply. URL confirmed `channels=instagram`.
4. Export → CSV. File `LF_TV_Episodic_Public Video Views (07.08.2026-07.14.2026).csv` downloaded.
5. Verified on disk: Row 1 = `From: 2026-07-08, To: 2026-07-14, Compare From: 2026-07-01, Compare To: 2026-07-07`; Row 2 = `Metric: Public Video Views`; header row = Overall Rank/Filtered Rank/Brand/Type/Programmer/Public Video Views/Instagram Public Video Views/Movement (×2)/Share (×2) — Instagram-only breakout column present, matching the channel selection.
6. Data cross-checked: Rank #1 "Love Island UK" 225,015,233 / +2.96% / 9.78% — exact match between UI and CSV, correct order.
7. Switched Rank dropdown to "Average Public Video Views" — **this reset the channel selector back to all 5 channels enabled** (new finding, see below). Re-applied Instagram-only.
8. Export → CSV. File `LF_TV_Episodic_Average Public Video Views (07.08.2026-07.14.2026).csv` downloaded.
9. Verified on disk: Row 1/Row 2 metadata correct (`Metric: Average Public Video Views`). Rank #1 "Rick and Morty" 10,252,058 — exact match with UI.

## Assertions

| ID (spec) | Expected | Actual | Status |
|----|----------|--------|--------|
| 6(a) | Filename `BrandSet_Public Video View (from-to)` | `LF_TV_Episodic_Public Video Views (07.08.2026-07.14.2026).csv` — exact pattern match | PASS |
| 6(b) | Required columns present | All present (Overall Rank, Filtered Rank, Brand, Type, Programmer\*, Public Video Views, Instagram Public Video Views, Movement×2, Share×2) | PASS |
| 6(c) | File data matches UI value/order | Rank #1 Love Island UK 225,015,233 exact match | PASS |
| 7 | Row 1 date range + Row 2 "Metric: Public Video Views" | Exact match | PASS |
| 9(a) | Filename `BrandSet_Average Public Video View (from-to)` | Exact pattern match | PASS |
| 9(b) | Required columns present | All present, plus per-channel breakdown columns (see finding below) | PASS |
| 9(c) | File data matches UI value/order | Rank #1 Rick and Morty 10,252,058 exact match | PASS |
| 10(a) | Row 1 correct date range | Exact match | PASS |
| 10(b) | Row 2 "Metric: Average Public Video Views" | Exact match | PASS |
| (negative, informal) | Public Data CSV excludes authorized-only columns (e.g. Page Video Views, Impressions) | Neither CSV contains any authorized-only column | PASS |

\* Ticket's assertion text says "Company" — the account's actual column label is "Programmer" (this brand set's taxonomy uses Programmer, not Company). Same stale-spec-wording pattern documented elsewhere in this project (e.g. QA-134296's PT-suffix note) — not a functional defect.

## Finding — channel-selection not consistently scoping export columns (new, not filed as a formal bug this run)
- **Public Video Views** export: with Instagram-only channel selected, the CSV correctly includes only one per-channel breakout column (`Instagram Public Video Views`).
- **Average Public Video Views** export: with Instagram-only channel selected (re-verified via `.channel-ghost` DOM state immediately before export), the CSV includes per-channel breakout columns for **all 5 channels** (Facebook/Twitter/Instagram/YouTube/TikTok Average Public Video Views + Movement + Share), with blank values for the 4 non-selected channels.
- This is an **inconsistency between the two metrics' export column sets** under an identical channel-selection precondition. It doesn't corrupt data (unselected channels are blank, not wrong), so it's a column-bloat/consistency issue rather than a correctness bug. Recommend product/dev review; not filed as a formal Jira bug per this session's scope, but flagged here for follow-up.
- Also noted in passing: **switching the Rank-by metric resets the channel selector to all-channels-enabled**, requiring re-selection of Instagram-only before the second export — not asserted by the ticket, but a UX quirk worth knowing for future runs of this flow.

## Bugs filed
None formally filed — one channel-scoping consistency finding documented above for follow-up.

## Skill maintenance
`brand-sets-rankings` +1 (Viacom LF // TV // Episodic; Rank-by metric switch resets channel selector — new quirk documented; `getByTitle` metric-option click-target reconfirmed). `export-csv` +1 (new filename pattern `<BrandSet>_<Metric> (MM.DD.YYYY-MM.DD.YYYY).csv` for Brand Set Rankings exports; per-channel breakdown column-set inconsistency documented as a quirk to watch).
