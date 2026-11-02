# QA-29126 — Brand Content - Video Views Dataset - Data Test - TikTok

**Run date:** 2026-10-30 (Friday) · Track: Playwright MCP, unattended headless (`claude -p`)
**Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670) · **Date range:** default week Oct. 22, 2026 – Oct. 28, 2026 · **Data set:** Video Views · **Channel:** TikTok only · **View:** Authorized data (default `perspective=extended`)
**Verdict: PASS** — 48/48 TikTok posts satisfy both identities; the Sum aggregate row is consistent with the column sums.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Open-bug screen (case file "Open linked bugs") | "None open (as of 2026-10-20)" — screen passed |
| 0 | Login: app.lfmdev.in → Cognito "With existing account" (lfiqa user) → `#home` | OK |
| 0 | Precondition (weekday login): Friday row of the Description table → Account **Hulu**; switched via profile menu → Search Account "Hulu" → `Results` row exactly "Hulu" | OK — `account_id=336`, breadcrumb "ACCOUNT: HULU" |
| 1 | Hover **Brand** in the top nav → click **Content** | OK — `#explore/brand/content` |
| 2 | Brand = Hulu; Data Set = **Video Views** | Brand selector already read exactly "Hulu" (brand_id=5670, the Hulu account's own brand; Friday brand in the Description is "Hulu"). Data set dropdown → "Video Views" → URL `table_data_set=video_views`, Posts (170) across all channels |
| 3 | Enable only TikTok | Clicked off the other enabled channels (they were all enabled by default; youtube/pinterest greyed by the data set); `.channel-ghost.enabled` = `[tiktok]`; clicked **Apply** → URL `channels=tiktok`, Posts (48) |
| 4 | Per post: Organic + Unclassified + Paid Views | Switched to **Table View**; scraped all 48 posts + aggregate row; evaluated in page JS |
| 5 | Note Engagements and Video Views | Recorded per post (below) |

### Notes
- Friday mapping: the case Description lists Friday as Account "Hulu, Robinhood, PlayOn! Sports" / Brand "Hulu" (the second brand cell is blank). The case's Notes line says "Fri Hulu/Ralph Lauren", which does not match the Description table (Ralph Lauren is a Thursday brand). I used Hulu / Hulu, the first Friday entry in the Description. No brand was substituted (Rule 1).
- The default week already contained TikTok video posts (all 48 rows have Type "Video"), so no fallback date range was needed.

## Per-post data (Table View, TikTok, Video Views data set — 48 posts)
Organic Views renders "–" on every row (treated as 0, per skill `brand-content-grid-math`); Paid Views "–" is treated as 0 on the rows without paid promotion.

| Rank | Date (PDT) | Engagements | Organic | Paid | Unclassified | Org+Paid+Unc | Video Views | Shown rate | Eng/VV (calc) |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Fri Oct. 23 10:00 AM | 110,076 | – | 703,786 | 2,296,214 | 3,000,000 | 3,000,000 | 3.67% | 3.6692% |
| 2 | Thu Oct. 22 11:30 AM | 35,327 | – | 674,295 | 1,025,705 | 1,700,000 | 1,700,000 | 2.08% | 2.0781% |
| 3 | Thu Oct. 22 03:01 PM | 31,895 | – | 4,905,627 | 2,894,373 | 7,800,000 | 7,800,000 | 0.41% | 0.4089% |
| 4 | Fri Oct. 23 11:01 AM | 30,024 | – | – | 357,200 | 357,200 | 357,200 | 8.41% | 8.4054% |
| 5 | Mon Oct. 26 06:00 PM | 23,863 | – | – | 413,100 | 413,100 | 413,100 | 5.78% | 5.7766% |
| 6 | Thu Oct. 22 11:03 AM | 12,977 | – | – | 138,300 | 138,300 | 138,300 | 9.38% | 9.3832% |
| 7 | Sat Oct. 24 10:01 AM | 10,360 | – | – | 160,400 | 160,400 | 160,400 | 6.46% | 6.4589% |
| 8 | Tue Oct. 27 02:30 PM | 7,443 | – | – | 95,600 | 95,600 | 95,600 | 7.79% | 7.7856% |
| 9 | Thu Oct. 22 12:03 PM | 4,865 | – | – | 32,700 | 32,700 | 32,700 | 14.88% | 14.8777% |
| 10 | Sun Oct. 25 09:04 AM | 2,430 | – | – | 65,500 | 65,500 | 65,500 | 3.71% | 3.7099% |
| 11 | Sun Oct. 25 04:00 PM | 1,749 | – | 331,412 | 148,188 | 479,600 | 479,600 | 0.36% | 0.3647% |
| 12 | Sat Oct. 24 10:30 AM | 1,048 | – | – | 16,500 | 16,500 | 16,500 | 6.35% | 6.3515% |
| 13 | Sat Oct. 24 09:01 AM | 1,002 | – | – | 27,400 | 27,400 | 27,400 | 3.66% | 3.6569% |
| 14 | Thu Oct. 22 09:02 AM | 664 | – | 24,126 | 5,974 | 30,100 | 30,100 | 2.21% | 2.2060% |
| 15 | Mon Oct. 26 08:00 AM | 555 | – | – | 8,549 | 8,549 | 8,549 | 6.49% | 6.4920% |
| 16 | Sat Oct. 24 03:00 PM | 461 | – | – | 31,600 | 31,600 | 31,600 | 1.46% | 1.4589% |
| 17 | Tue Oct. 27 12:00 PM | 330 | – | – | 27,300 | 27,300 | 27,300 | 1.21% | 1.2088% |
| 18 | Wed Oct. 28 09:43 AM | 282 | – | 10,319 | 9,981 | 20,300 | 20,300 | 1.39% | 1.3892% |
| 19 | Fri Oct. 23 04:28 PM | 259 | – | – | 8,536 | 8,536 | 8,536 | 3.03% | 3.0342% |
| 20 | Tue Oct. 27 01:30 PM | 244 | – | – | 5,895 | 5,895 | 5,895 | 4.14% | 4.1391% |
| 21 | Tue Oct. 27 11:07 AM | 240 | – | – | 3,476 | 3,476 | 3,476 | 6.90% | 6.9045% |
| 22 | Thu Oct. 22 02:30 PM | 231 | – | – | 3,742 | 3,742 | 3,742 | 6.17% | 6.1732% |
| 23 | Thu Oct. 22 05:05 PM | 211 | – | – | 7,706 | 7,706 | 7,706 | 2.74% | 2.7381% |
| 24 | Tue Oct. 27 09:01 AM | 205 | – | – | 9,009 | 9,009 | 9,009 | 2.28% | 2.2755% |
| 25 | Tue Oct. 27 05:03 PM | 204 | – | – | 3,519 | 3,519 | 3,519 | 5.80% | 5.7971% |
| 26 | Fri Oct. 23 06:00 PM | 173 | – | – | 2,246 | 2,246 | 2,246 | 7.70% | 7.7026% |
| 27 | Thu Oct. 22 04:00 PM | 171 | – | – | 3,831 | 3,831 | 3,831 | 4.46% | 4.4636% |
| 28 | Mon Oct. 26 09:00 AM | 157 | – | – | 5,581 | 5,581 | 5,581 | 2.81% | 2.8131% |
| 29 | Sun Oct. 25 09:01 AM | 132 | – | – | 5,369 | 5,369 | 5,369 | 2.46% | 2.4586% |
| 30 | Mon Oct. 26 09:02 PM | 131 | – | – | 3,908 | 3,908 | 3,908 | 3.35% | 3.3521% |
| 31 | Fri Oct. 23 12:33 PM | 130 | – | – | 3,401 | 3,401 | 3,401 | 3.82% | 3.8224% |
| 32 | Sat Oct. 24 02:00 PM | 130 | – | – | 5,216 | 5,216 | 5,216 | 2.49% | 2.4923% |
| 33 | Wed Oct. 28 12:02 PM | 121 | – | – | 1,734 | 1,734 | 1,734 | 6.98% | 6.9781% |
| 34 | Fri Oct. 23 03:02 PM | 120 | – | – | 3,319 | 3,319 | 3,319 | 3.62% | 3.6155% |
| 35 | Mon Oct. 26 01:31 PM | 117 | – | – | 4,115 | 4,115 | 4,115 | 2.84% | 2.8433% |
| 36 | Sun Oct. 25 05:00 PM | 116 | – | – | 4,620 | 4,620 | 4,620 | 2.51% | 2.5108% |
| 37 | Fri Oct. 23 06:30 PM | 107 | – | – | 4,090 | 4,090 | 4,090 | 2.62% | 2.6161% |
| 38 | Fri Oct. 23 02:30 PM | 99 | – | – | 4,310 | 4,310 | 4,310 | 2.30% | 2.2970% |
| 39 | Wed Oct. 28 01:00 PM | 95 | – | – | 2,465 | 2,465 | 2,465 | 3.85% | 3.8540% |
| 40 | Wed Oct. 28 03:02 PM | 88 | – | – | 2,628 | 2,628 | 2,628 | 3.35% | 3.3486% |
| 41 | Wed Oct. 28 11:01 AM | 84 | – | – | 1,135 | 1,135 | 1,135 | 7.40% | 7.4009% |
| 42 | Sat Oct. 24 09:31 AM | 74 | – | – | 2,741 | 2,741 | 2,741 | 2.70% | 2.6997% |
| 43 | Wed Oct. 28 09:35 AM | 71 | – | – | 1,705 | 1,705 | 1,705 | 4.16% | 4.1642% |
| 44 | Fri Oct. 23 12:01 PM | 68 | – | – | 3,062 | 3,062 | 3,062 | 2.22% | 2.2208% |
| 45 | Wed Oct. 28 07:03 AM | 68 | – | – | 1,742 | 1,742 | 1,742 | 3.90% | 3.9036% |
| 46 | Wed Oct. 28 03:32 PM | 51 | – | – | 1,494 | 1,494 | 1,494 | 3.41% | 3.4137% |
| 47 | Tue Oct. 27 08:30 AM | 46 | – | – | 1,256 | 1,256 | 1,256 | 3.66% | 3.6624% |
| 48 | Thu Oct. 22 02:47 PM | 29 | – | – | 2,051 | 2,051 | 2,051 | 1.41% | 1.4139% |

**Sum aggregate row** (Table View, default toggle): Engagements 279,323 · Video Views 14,518,051 · Organic – · Paid Views 6,649,565 · Unclassified Views 7,868,486 · Video Response Rate "N/A". Column sums of the 48 rows: Engagements 279,323 · Video Views 14,518,051 · Paid 6,649,565 · Unclassified 7,868,486 (all match). 6,649,565 + 7,868,486 = 14,518,051 = Video Views.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | For every grid post: Organic Views + Unclassified Views + Paid Views = Video Views | 48/48 posts equal (0 failures, 0 skipped). 6 posts carry Paid Views (ranks 1, 2, 3, 11, 14, 18) and still reconcile exactly. Sum row: 0 + 6,649,565 + 7,868,486 = 14,518,051 = Video Views | PASS |
| A5 | 5 | Engagements ÷ Video Views = Video Response Rate | 48/48 posts match at the 2-decimal display (tolerance ±0.01 pp); max deviation 0.0047 pp. The Sum row's rate shows "N/A" by design (the Average row, not toggled here, is the rate carrier); the aggregate ratio 279,323 / 14,518,051 = 1.924% is consistent with the per-post values | PASS |

## Evidence
- Screenshots under `.playwright-out/QA-29126/`: `f00-login.png`, `f01-account.png`, `f02-brand.png`, `f03-tiktok-videoviews.png`, `f04-table.png`. (Other files in that folder are from earlier weekday runs.)
- Final URL: `#explore/brand/content?brand_id=5670&account_id=336&from=2026-10-22&to=2026-10-28&compare_from=2026-10-15&compare_to=2026-10-21&channels=tiktok&perspective=extended&stats_attribution_window=lifetime&table_data_set=video_views&…`
- Console showed the usual dev-environment React/network errors throughout; none affected the Table View data.

## Known bugs checked
- Case file "Open linked bugs": none open. Pre-fetched `bug-history.md` and `known-quirks.md` greps for QA-29126: no entries. Nothing related reproduced or interfered with the steps/assertions.

## Bugs filed
None.

## Cleanup
None (read-only).
