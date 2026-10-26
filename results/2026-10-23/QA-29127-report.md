# QA-29127 — Brand Content - Video Views Dataset - Data Test - Linkedin

**Run date:** 2026-10-23 (Friday) · Track: Playwright MCP, unattended headless (`claude -p`)
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · **Date range:** default week Oct. 15, 2026 – Oct. 21, 2026 · **Data set:** Video Views · **Channel:** LinkedIn only · **View:** Authorized data (default)
**Verdict: PASS** — 8/8 LinkedIn video posts satisfy both identities; Sum and Average aggregate rows are consistent.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Open-bug screen (case file "Open linked bugs") | "None open" — screen passed |
| 0 | Login: app.lfmdev.in → Cognito "With existing account" (lfiqa user) → `#home` | OK |
| 0 | Precondition: switch account to UCLA (profile menu → Search Account "UCLA" → `Results` row exactly "UCLA") | OK — URL `account_id=799`, breadcrumb "ACCOUNT: UCLA" |
| 1 | Hover **Brand** in top nav → click **Content** | OK — `#explore/brand/content` |
| 2 | Brand = UCLA; Data Set = **Video Views** | Brand: see "Brand selection note" below. Data set dropdown → "Video Views" (URL `table_data_set=video_views`, selector reads "Video Views") |
| 3 | Enable only LinkedIn | Clicked off facebook/twitter/instagram/tiktok (threads/youtube/pinterest were already greyed out by the data set); `.channel-ghost.linkedin enabled`, all others disabled; clicked **Apply** → URL `channels=linkedin`, Posts (8) |
| 4 | Per post: Organic Views + Paid Views + Unclassified Views | Table View scraped (8 posts + aggregate row); evaluated in page JS |
| 5 | Note Engagements and Video Views | Recorded per post (below) |

Video posts were available in the default week (all 8 rows are Type "Video"), so the fallback range Aug. 05, 2022 – Feb. 05, 2023 was **not** needed.

### Brand selection note (Rule 1)
The brand typeahead for "UCLA" returned 68 results (all "UCLA …" sub-brands, e.g. "UCLA Bruins", "UCLA Health", "UCLA Law"); there is **no brand named exactly "UCLA"**. The UCLA account's own default brand is "University of California, Los Angeles" (127756), which the repo documents as the UCLA-account brand (`skills/brand-content-native-post-check/SKILL.md`; used in all earlier Daily Data Testing UCLA cases). The test ran on that brand; no sub-brand was substituted. Evidence: `.playwright-out/QA-29127/04-brand-typeahead-ucla.png`.

### Data set note
The dropdown also offers a custom "UCLA Video Views" set; the spec says "the video views dataset", so the standard **Video Views** set was used.

## Per-post data (Table View, LinkedIn, Video Views data set)
Organic Views and Paid Views render "–" on every LinkedIn row (structurally absent for LinkedIn → treated as 0, per skill `brand-content-grid-math`).

| Rank | Date (PDT) | Engagements | Organic | Paid | Unclassified | Org+Paid+Unc | Video Views | Video Response Rate (shown) | Eng/VV (calc) |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Mon Oct. 19 05:15 PM | 459 | – | – | 7,942 | 7,942 | 7,942 | 5.78% | 5.7794% |
| 2 | Sat Oct. 17 12:07 PM | 190 | – | – | 2,236 | 2,236 | 2,236 | 8.50% | 8.4973% |
| 3 | Fri Oct. 16 12:01 PM | 172 | – | – | 3,379 | 3,379 | 3,379 | 5.09% | 5.0903% |
| 4 | Wed Oct. 21 06:28 PM | 138 | – | – | 1,740 | 1,740 | 1,740 | 7.93% | 7.9310% |
| 5 | Mon Oct. 19 09:11 AM | 130 | – | – | 5,163 | 5,163 | 5,163 | 2.52% | 2.5179% |
| 6 | Wed Oct. 21 11:48 AM | 64 | – | – | 11,514 | 11,514 | 11,514 | 0.56% | 0.5558% |
| 7 | Thu Oct. 15 12:30 PM | 40 | – | – | 1,124 | 1,124 | 1,124 | 3.56% | 3.5587% |
| 8 | Mon Oct. 19 11:31 AM | 31 | – | – | 1,452 | 1,452 | 1,452 | 2.13% | 2.1350% |

Aggregate rows: **Sum** — Engagements 1,224 · Video Views 34,550 · Organic – · Paid – · Unclassified 34,550 · Video Response Rate "N/A". Column sums of the 8 rows: Engagements 1,224 and Video Views 34,550 (match). **Average** — Engagements 153 · Video Views 4,319 · Unclassified 4,319 · Video Response Rate **3.54%** (= 1,224 / 34,550 = 3.5427%).

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | For every grid post: Organic Views + Paid Views + Unclassified Views = Video Views | 8/8 posts equal (Organic "–"=0, Paid "–"=0, Unclassified = Video Views on each row); Sum row Unclassified 34,550 = Video Views 34,550 | PASS |
| A5 | 5 | Engagements ÷ Video Views = Video Response Rate | 8/8 posts match at the 2-decimal display (tolerance ±0.01 pp); max deviation 0.0050 pp (rank 8: 2.1350% calc vs 2.13% shown). Average row 3.54% = 1,224/34,550 | PASS |

## Evidence
- Screenshots under `.playwright-out/QA-29127/`: `01-brand-content-initial.png`, `02-brand-picker.png`, `03-brand-picker-open.png`, `04-brand-typeahead-ucla.png`, `05-dataset-dropdown.png`, `06-linkedin-only-pre-apply.png`, `07-table-view-sum.png`, `08-table-view-average.png`.
- Final URL: `#explore/brand/content?brand_id=127756&account_id=799&from=2026-10-15&to=2026-10-21&compare_from=2026-10-08&compare_to=2026-10-14&channels=linkedin&perspective=extended&stats_attribution_window=lifetime&table_data_set=video_views&…`
- Console showed React/dev-environment errors throughout the session (React 18 `ReactDOM.render` warning plus network noise); none affected the Table View data or the assertions.

## Known bugs checked
- Case file "Open linked bugs": none open. `knowledge-base/bug-history.md` and `known-quirks.md`: no entries for QA-29127. No related bug reproduced or interfered with the steps/assertions.

## Bugs filed
None.

## Cleanup
None (read-only). Side effect: the session's Aggregate toggle was left on Average.
