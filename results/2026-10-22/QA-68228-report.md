# QA-68228 — Brand > Stories - Engaged User Rate - Posts - Data QA

**Run date:** 2026-10-22 (unattended, headless `claude -p`, Playwright MCP), dev `app.lfmdev.in`, user lfiqa (programmatic Cognito login) switched to account **Hulu**
**Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670, selected explicitly from the typeahead; first Results entry exactly "Hulu") · Surface: Brand > Stories · Channel: Instagram (only channel on Stories) · Perspective: `extended` (URL default) · Date range: default week Oct. 14, 2026 – Oct. 20, 2026
**Verdict: PASS — 29/29 stories satisfy Engaged User Rate = Engagements ÷ Reach × 100 (max |computed − displayed| = 0.005 pp, i.e. exactly the 2-decimal rounding of the display; 0 failures, 0 skipped)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Precondition: logged in to Hulu | Cognito email/password login → `#home`; account switched via profile menu "Search Account" → Results → **Hulu** (header shows `ACCOUNT: HULU`, account_id=336) |
| 1 | Brand (top nav) → Stories tab | Hover Brand, clicked Stories → `#explore/brand/stories?...channels=instagram&table_data_set=insights`; **Stories (29)** |
| 2 | Type and select Hulu in the brand dropdown | Opened brand selector, typed `Hulu`; Results list: Hulu, 1266 (Hulu), Aftershock (Hulu), … — clicked the exact "Hulu" result (brand_id 5670); Stories (29), no load error (`02-brand-typeahead.png`) |
| 3 | Review posts, note Engagements and Reach | Table View, data set **Insights**; scraped 29 stories + aggregate row. Columns: Rank, Date, Channel, Author, Type, Publish Type, Text, Engagements, Impressions, Reach, Taps Forward, Taps Back, Exits, DM Replies, Shares, Actions, Profile Visits. Aggregate: Engagements 1,214 / Impressions 246,734 / Reach N/A (`03-insights-table.png`) |
| 4 | Select Rates in the data set | Data set dropdown (Insights, Rates, Action Types, Engagements) → **Rates** (`table_data_set=rates`); Table View scraped, 29 stories. Columns: Engagements, Engaged User Rate, Taps Forward Rate, Taps Back Rate, Exits Rate, Completion Rate, DM Rate. Aggregate row rates all N/A by design (`04-rates-table.png`) |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | For every story, Engaged User Rate == Engagements ÷ Reach × 100 | 29/29 within display rounding (max diff 0.0050 pp). Rows joined across the Insights and Rates tables by Date + Engagements (29/29 matched). Samples: #1 187 / 23,763 → 0.787 vs **0.79%**; #2 104 / 9,255 → 1.124 vs **1.12%**; #3 103 / 7,279 → 1.415 vs **1.42%**; #21 17 / 5,765 → 0.295 vs **0.29%**; #29 5 / 5,364 → 0.093 vs **0.09%** | PASS |

### Per-story evidence (Rank | Date PDT | Engagements | Reach | displayed rate | computed %)
1 | Sun Oct 18 02:48 | 187 | 23,763 | 0.79% | 0.787
2 | Mon Oct 19 02:02 | 104 | 9,255 | 1.12% | 1.124
3 | Thu Oct 15 08:20 | 103 | 7,279 | 1.42% | 1.415
4 | Sat Oct 17 11:10 | 91 | 11,340 | 0.80% | 0.802
5 | Mon Oct 19 09:04 | 73 | 8,187 | 0.89% | 0.892
6 | Tue Oct 20 09:32 | 69 | 8,199 | 0.84% | 0.842
7 | Wed Oct 14 09:01 | 67 | 6,876 | 0.97% | 0.974
8 | Fri Oct 16 10:03 | 62 | 6,573 | 0.94% | 0.943
9 | Thu Oct 15 12:39 | 50 | 7,177 | 0.70% | 0.697
10 | Mon Oct 19 02:31 | 44 | 8,308 | 0.53% | 0.530
11 | Mon Oct 19 10:02 | 34 | 6,049 | 0.56% | 0.562
12 | Thu Oct 15 09:19 | 31 | 7,341 | 0.42% | 0.422
13 | Tue Oct 20 11:35 | 29 | 9,135 | 0.32% | 0.317
14 | Wed Oct 14 12:57 | 28 | 5,845 | 0.48% | 0.479
15 | Fri Oct 16 11:35 | 28 | 5,494 | 0.51% | 0.510
16 | Tue Oct 20 01:42 | 27 | 7,264 | 0.37% | 0.372
17 | Fri Oct 16 10:30 | 22 | 5,849 | 0.38% | 0.376
18 | Fri Oct 16 04:01 | 19 | 5,290 | 0.36% | 0.359
19 | Wed Oct 14 11:03 | 18 | 5,972 | 0.30% | 0.301
20 | Tue Oct 20 12:37 | 18 | 7,386 | 0.24% | 0.244
21 | Fri Oct 16 11:30 | 17 | 5,765 | 0.29% | 0.295
22 | Fri Oct 16 04:20 | 17 | 5,336 | 0.32% | 0.319
23 | Tue Oct 20 11:35 | 16 | 7,337 | 0.22% | 0.218
24 | Fri Oct 16 01:17 | 15 | 5,389 | 0.28% | 0.278
25 | Tue Oct 20 11:35 | 15 | 7,244 | 0.21% | 0.207
26 | Wed Oct 14 09:06 | 9 | 6,255 | 0.14% | 0.144
27 | Wed Oct 14 10:05 | 8 | 6,003 | 0.13% | 0.133
28 | Fri Oct 16 02:02 | 8 | 5,065 | 0.16% | 0.158
29 | Fri Oct 16 12:30 | 5 | 5,364 | 0.09% | 0.093

## Evidence
- Screenshots: `.playwright-out/QA-68228/01-stories.png`, `02-brand-typeahead.png`, `03-insights-table.png`, `04-rates-table.png`.
- Stories have no permalink and Text is "–"; rows were joined on Date + Engagements (unique per story; three stories share the minute Tue Oct 20 11:35 but have distinct Engagements 29/16/15).
- Aggregate row shows Reach N/A (Insights) and all rates N/A (Rates) — expected, Reach is not summable.

## Known bugs checked
- Case file "Open linked bugs": none open. `bug-history.md` / `known-quirks.md` had no QA-68228 entry. No bug reproduced; nothing interfered with the assertion.

## Notes
- Dataset differs from the 2026-10-20 run (38 stories, week Oct 12–18) only because the default date window rolled forward to Oct 14–20; result is the same (PASS).
- Playwright `browser_run_code_unsafe` has no `require`/`import`, so the password was supplied by the caller from `config/.env` (consistent with the helper-file convention).

## Bugs filed
None.

## Cleanup
None (read-only).
