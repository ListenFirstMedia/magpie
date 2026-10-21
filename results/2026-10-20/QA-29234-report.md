# QA-29234 — Brand Content > Video Views Data Set > Past date range data test (Twitter/Instagram)

**Verdict: PASS**

- Run: 2026-10-20 (Tuesday), headless unattended, Playwright MCP, app.lfmdev.in (dev)
- Skill used: `brand-content-grid-math` (Table View scrape) + `switch-account` + `brand-content-native-post-check` (date picker)

## Setup / precondition
- Weekday rotation (Description table, authoritative): **Tuesday = UCLA / Viacom / Wasserman**; brands *University of California, Los Angeles*, MTV, Gatorade. Used **Account UCLA, Brand "University of California, Los Angeles"** (first Tuesday pair). Note: the case's "Notes" line lists a different rotation (Tue UCLA/Sony Pictures) — it conflicts with the Description table and was not followed. "Amazon Prime Video on alternative days" not applicable today (optional).
- Logged in as lfiqa@listenfirstmedia.com (landed on account HBO Max), switched via LFQA menu -> Search Account -> Results row `UCLA`; breadcrumb `ACCOUNT: UCLA` (account_id=799).
- Brand loaded by default: University of California, Los Angeles (brand_id=127756) — exact spec name (Rule 1; no substitute).

## Steps executed
1. Hover Brand -> Content (top nav). Done (`#explore/brand/content`).
2. Brand = University of California, Los Angeles; Data Set dropdown -> **Video Views** (URL `table_data_set=video_views`).
3. Date picker: START Jan 01, 2023, END Jan 10, 2023, Ok (URL `from=2023-01-01&to=2023-01-10`; screenshot 03).
4. Disabled all channels except Twitter via explicit ghost clicks, Apply (URL `channels=twitter`).
5/6. Table View scrape (Posts (6)): Organic + Paid vs Video Views; Engagements / Video Views vs Video Response Rate.
7. Enabled Instagram, then disabled Twitter, Apply (URL `channels=instagram`).
8/9. Table View scrape (Posts (2)): same identities.

## Evidence — Twitter only (6 posts, Jan 1–10 2023)
| Rank | Date | Engagements | Organic Views | Paid Views | Video Views | Displayed VRR | Eng/VV |
|---|---|---|---|---|---|---|---|
| 1 | Jan 09 12:38 PM | 234 | 4,115 | – | 4,115 | 5.69% | 5.686% |
| 2 | Jan 02 04:00 PM | 23 | 1,569 | – | 1,569 | 1.47% | 1.466% |
| 3 | Jan 03 09:00 AM | 16 | 848 | – | 848 | 1.89% | 1.887% |
| 4 | Jan 06 04:00 PM | 14 | 1,082 | – | 1,082 | 1.29% | 1.294% |
| 5 | Jan 04 09:00 AM | 9 | 583 | – | 583 | 1.54% | 1.544% |
| 6 | Jan 02 09:00 AM | 7 | 977 | – | 977 | 0.72% | 0.716% |
| Sum row | | 303 | 9,174 | – | 9,174 | N/A | 3.30% |

Check: Sum Engagements 234+23+16+14+9+7 = 303; Sum Video Views 4115+1569+848+1082+583+977 = 9,174 — both match the Sum row.

## Evidence — Instagram only (2 posts, Jan 1–10 2023)
| Rank | Date | Engagements | Organic Views | Paid Views | Video Views | Displayed VRR | Eng/VV |
|---|---|---|---|---|---|---|---|
| 1 | Jan 09 12:39 PM | 11,427 | 36,826 | – | 36,826 | 31.03% | 31.028% |
| 2 | Jan 06 04:18 PM | 5,742 | 112,674 | – | 112,674 | 5.10% | 5.096% |
| Sum row | | 17,169 | 149,500 | – | 149,500 | N/A | 11.48% |

Check: 11,427+5,742 = 17,169; 36,826+112,674 = 149,500 — both match the Sum row.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5 | 5 (Twitter) | Organic Views + Paid Views = Video Views, every post | 6/6 posts equal (Paid Views "–" = no paid views, treated as 0; Unclassified Views 0 everywhere) | PASS |
| A6 | 6 (Twitter) | Engagements / Video Views = Video Response Rate | 6/6 within rounding of the 2-decimal display (max delta 0.004 pp) | PASS |
| A8 | 8 (Instagram) | Organic Views + Paid Views = Video Views, every post | 2/2 posts equal (Paid "–" treated as 0) | PASS |
| A9 | 9 (Instagram) | Engagements / Video Views = Video Response Rate | 2/2 match (31.03%, 5.10%) | PASS |

Screenshots: `.playwright-out/QA-29234/01-content.png`, `02-datepicker-open.png`, `03-datepicker-set.png`, `04-twitter-table.png`, `05-instagram-table.png`.

## Observations (not affecting verdict)
- Paid Views renders "–" for every post on both channels (no boosted posts in this window); the identity holds with Paid = 0.
- The aggregate row's Video Response Rate shows **"N/A"** on both channels (the spec asserts only per-post values; Sum-row Eng/VV would be 3.30% Twitter, 11.48% Instagram). Not asserted; noted only.
- The Channel column renders icon-only (empty text) in the Table View scrape; channel was confirmed through the URL `channels=` param and ghost `.enabled` state.
- Console showed many app errors throughout (dev); none affected the Content grid.

## Known bugs checked
- Case file "Open linked bugs": None open (Rule 7 screen passed). `knowledge-base/bug-history.md` and `known-quirks.md`: no matches for QA-29234. No known bug reproduced; no regression observed.

## Bugs filed
- None.
