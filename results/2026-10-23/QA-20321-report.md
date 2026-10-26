# QA-20321 — Brand Content > Impressions Data Set > Past date range data test

**Run:** 2026-10-23 (Friday), unattended headless, Playwright MCP, dev (`app.lfmdev.in`). Login `lfiqa@listenfirstmedia.com`.
**Weekday row executed:** Friday — Accounts Hulu / Ralph Lauren → Brands Hulu / Ralph Lauren (both legs run). The "Amazon Prime Video on alternative days" note was not applied.
**Open-bug screen (Rule 7):** case file says "None open" → ran normally.

## Verdict: **FAIL** — Hulu Facebook: 2 of the top-200 posts carry a total Impressions (and Reach) value with Organic/Paid both "–", and the Sum row Organic + Paid ≠ Impressions. Everything else passes (Ralph Lauren all evaluable channels; Hulu Instagram/Twitter). LinkedIn has 0 posts for both brands, so the LinkedIn steps (16–19) could not be evaluated.

| Leg | Account (id) | Brand (id) | Facebook | Instagram | Twitter | LinkedIn |
|---|---|---|---|---|---|---|
| 1 | Ralph Lauren (732) | Ralph Lauren (7000) | PASS (247 posts) | PASS (768) | PASS (396) | not evaluable — Posts (0) |
| 2 | Hulu (336) | Hulu (5670) | **FAIL** (1,075) | PASS (1,087) | PASS (160) | not evaluable — Posts (0) |

## Steps executed (per leg)
1. Account: the login landed on Ralph Lauren (account_id=732) → ran that leg first. For leg 2 I hovered the LFQA menu → Search Account → typed "Hulu" → real mouse click on the `Results` row `.lfm-ta-option` → breadcrumb `ACCOUNT: HULU`, account_id=336.
2. Hovered **Brand** → **Content** (`#explore/brand/content`). The account's default brand matched the spec name exactly (Ralph Lauren brand_id=7000; Hulu brand_id=5670 — Rule 1, no substitute).
3. Data set dropdown → **Impressions** (`table_data_set=impressions`).
4. Date range via the START DATE / END DATE picker: **Oct 01, 2023 – Sep 30, 2024** → Ok → URL `from=2023-10-01&to=2024-09-30` (picker field text verified before Ok).
5. Channels: explicit trusted clicks (Rule 2), enabling the wanted channel first then disabling the rest, **Apply**; verified only `.channel-ghost.<channel>.enabled` remained → URL `channels=<channel>`. Sequence per leg: Facebook → Instagram → Twitter → LinkedIn.
6. **Table View**; scraped header, all rendered rows (200 per page max) and the Sum/Average aggregate row via DOM; evaluated every identity in page JS. "–" components next to a numeric component count as 0 (structurally absent, e.g. Paid on Twitter/Instagram); a total with both components "–" is flagged as unsplit; a total of "–" is no-data and skipped.
   Columns: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate, Actions.

## Assertions

Identities: Organic Impressions + Paid Impressions = Impressions; Organic Reach + Paid Reach = Reach; Engagements / Impressions ×100 = Engagement Rate; Engagements / Reach ×100 = Engaged User Rate (rates compared at ±0.01 pp of the 2-decimal display). "n/N" = posts passing out of posts evaluable among the rendered top 200.

### Leg 1 — Ralph Lauren (account 732, brand 7000)
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5 (FB) | 5 | Organic + Paid Impressions = Impressions | 199/199 ✓ (1 post Impressions "–", skipped). #1 (Sun Aug. 11, 2024): 955,250 + 0 = 955,250. Sum row 51,369,462 + 0 = 51,369,462 ✓ | PASS |
| A6 (FB) | 6 | Engagements / Impressions = Engagement Rate | 199/199 ✓. #1: 34,714 / 955,250 = 3.63% = shown 3.63%. Sum-row rate cell "N/A" | PASS |
| A8 (IG) | 8 | Organic + Paid Impressions = Impressions | 198/198 ✓ (2 posts "–"). #1: 4,642,791 + – = 4,642,791. Sum row 353,018,159 + – = 353,018,159 ✓ | PASS |
| A9 (IG) | 9 | Organic + Paid Reach = Reach | 200/200 ✓. #1: 2,355,292 + – = 2,355,292 | PASS |
| A10 (IG) | 10 | Engagements / Impressions = Engagement Rate | 198/198 ✓. #1: 532,562 / 4,642,791 = 11.47% = 11.47% | PASS |
| A11 (IG) | 11 | Engagements / Reach = Engaged User Rate | 200/200 ✓. #1: 532,562 / 2,355,292 = 22.61% = 22.61% | PASS |
| A13 (TW) | 13 | Organic + Paid Impressions = Impressions | 200/200 ✓. #1: 585,505 + – = 585,505. Sum row 9,218,298 + – ✓ | PASS |
| A14 (TW) | 14 | Organic + Paid Reach = Reach | Reach / Organic Reach / Paid Reach "–" on 200/200 — Twitter has no reach metric (nothing to sum) | PASS (n/a) |
| A15a (TW) | 15 | Engagements / Impressions = Engagement Rate | 200/200 ✓. #1: 24,672 / 585,505 = 4.21% = 4.21% | PASS |
| A15b (TW) | 15 | Engaged User Rate displays en-dash | "–" on 200/200 posts (Sum row "N/A") | PASS |
| A17–A19 (LI) | 17–19 | Impressions / Reach sums, Engagement Rate, EUR en-dash | **Posts (0)** for Ralph Lauren, Oct 2023 – Sep 2024 on LinkedIn — nothing to evaluate | NOT EVALUABLE (test-data gap) |

### Leg 2 — Hulu (account 336, brand 5670)
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5 (FB) | 5 | Organic + Paid Impressions = Impressions | 198/200 ✓. **2 posts FAIL (unsplit):** rank 110 Impressions **1,082,472** with Organic "–" / Paid "–"; rank 185 Impressions **1,266,337** with Organic "–" / Paid "–". **Sum row: 837,911,733 + 135,146,120 = 973,057,853 ≠ Impressions 977,021,784 (gap 3,963,931)**. #1 (Sun Sep. 08, 2024): 1,964,465 + 0 ✓ | **FAIL** |
| A6 (FB) | 6 | Engagements / Impressions = Engagement Rate | 200/200 ✓. #1: 1,593,713 / 1,964,465 = 81.13% = 81.13%; #2: 824,757 / 18,014,438 = 4.58% = 4.58% | PASS |
| A8 (IG) | 8 | Organic + Paid Impressions = Impressions | 181/181 ✓ (19 posts "–" on all impression columns — skipped). #1 (Fri Jan. 05, 2024): Organic "–" + Paid 4,588,744 = 4,588,744. Sum row 243,905,368 + 153,152,565 = 397,057,933 ✓ | PASS |
| A9 (IG) | 9 | Organic + Paid Reach = Reach | 200/200 ✓. #1: 15,237,422 + 4,542,593 = 19,780,015 | PASS |
| A10 (IG) | 10 | Engagements / Impressions = Engagement Rate | 181/181 ✓. #1: 1,075,201 / 4,588,744 = 23.43% = 23.43% | PASS |
| A11 (IG) | 11 | Engagements / Reach = Engaged User Rate | 200/200 ✓. #1: 1,075,201 / 19,780,015 = 5.44% = 5.44% | PASS |
| A13 (TW) | 13 | Organic + Paid Impressions = Impressions | 155/155 ✓ (5 posts "–"). #2: 282,300 + – = 282,300. Sum row 7,715,096 + 2,890,818 = 10,605,914 ✓ | PASS |
| A14 (TW) | 14 | Organic + Paid Reach = Reach | Reach columns "–" on 160/160 — Twitter has no reach metric | PASS (n/a) |
| A15a (TW) | 15 | Engagements / Impressions = Engagement Rate | 155/155 ✓. #1 (Thu Oct. 05, 2023): 10,168 / 283,818 = 3.58% = 3.58% | PASS |
| A15b (TW) | 15 | Engaged User Rate displays en-dash | "–" on 160/160 posts | PASS |
| A17–A19 (LI) | 17–19 | Impressions / Reach sums, Engagement Rate, EUR en-dash | **Posts (0)** for Hulu, Oct 2023 – Sep 2024 on LinkedIn — nothing to evaluate | NOT EVALUABLE (test-data gap) |

Only the top 200 posts by rank are rendered per page (Hulu FB has 1,075 posts, IG 1,087; RL IG 768, TW 396, FB 247), so the per-post checks cover the rendered 200. The Sum row aggregates every post in range, which is how the Hulu FB gap exposes unsplit posts beyond the 200.

## Observations (not assertions)
- Facebook **Reach and Engaged User Rate are still populated** for these 2023–24 posts (Hulu FB #1 Reach 1,964,465, EUR 81.13%; RL FB #1 947,877 / 3.66%), although the precondition says both were removed from the platform in Nov 2025. The spec has no Facebook Reach assertion (steps 5–6 only), so nothing is judged on it.
- Same Facebook "total without organic/paid split" pattern as the 2026-10-19 HBO Max run (30 of 200 posts there, 2 of 200 here; none for Ralph Lauren). It looks like a data-side gap rather than a UI rendering defect.

## Evidence
`.playwright-out/QA-20321/RL-01-fb-table.png`, `RL-instagram.png`, `RL-twitter.png`, `RL-linkedin.png`, `Hulu-facebook.png`, `Hulu-instagram.png`, `Hulu-twitter.png`, `Hulu-linkedin.png`. Exact figures above come from the DOM scrape of each Table View.

## Known bugs checked
- Case file "Open linked bugs": none. knowledge-base/bug-history.md and known-quirks.md: no QA-20321 entry and no accepted-behavior note for the Facebook unsplit pattern.
- The 2026-10-19 report cited LFMP-28018 and DATA-12253 (closed, Impressions data set) and APPS-62062 (Meta deprecation test-case update) as possibly related. The unsplit Facebook posts here may be a regression of those closed bugs, or accepted behavior (for example Reels or cross-posted video with no Meta organic/paid breakdown). **Triage needed** — if accepted, the spec should say so; if not, file against the ranks above.

## Bugs filed
None filed (markdown-only, per run policy). Candidate: Hulu Facebook, Oct 01, 2023 – Sep 30, 2024, Impressions data set — ranks 110 and 185 show Impressions/Reach totals with Organic/Paid "–", and the Sum row Organic + Paid is 3,963,931 short of Impressions.

## Cleanup
None (read-only test).
