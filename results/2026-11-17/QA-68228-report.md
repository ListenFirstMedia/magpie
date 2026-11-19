# QA-68228 — Brand > Stories - Engaged User Rate - Posts - Data QA

**Run date:** 2026-11-17 (unattended, headless `claude -p`, Playwright MCP), dev `app.lfmdev.in`, user lfiqa (programmatic Cognito login), account **Hulu**
**Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670, typed "Hulu" in the brand selector and clicked the exact first Results entry "Hulu") · Surface: Brand > Stories · Channel: Instagram · Perspective: `extended` (URL default) · Date range: Nov. 10 – Nov. 16, 2026
**Verdict: PASS — 50/50 stories satisfy Engaged User Rate = Engagements ÷ Reach × 100 (max |computed − displayed| = 0.0050 pp, i.e. the 2-decimal display rounding; 0 failures)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Precondition: logged in to Hulu | Cognito email/password login → `#home`; header already showed `ACCOUNT: HULU` (account_id=336) |
| 1 | Brand (top nav) → Stories tab | Hovered Brand, clicked Stories → `#explore/brand/stories?brand_id=5670&account_id=336&from=2026-11-10&to=2026-11-16&channels=instagram&perspective=extended&table_data_set=insights` (`01-stories.png`) |
| 2 | Type and select Hulu in the brand dropdown | Clicked brand name, typed `Hulu` in "Search for a Brand"; Results: Hulu, 1266 (Hulu), Aftershock (Hulu), … — clicked exact "Hulu" (brand_id 5670); **Stories (50)** (`02-brand-typeahead.png`) |
| 3 | Review posts, note Engagements and Reach | The Stories table first rendered "This table failed to load" (Reload tile); clicked Reload, then Table View → 50 stories + Sum/Average row. Data set **Insights**. Aggregate: Engagements 1,178 / Impressions 354,403 / Reach N/A (`03-insights-table.png`) |
| 4 | Select Rates in the data set | Data set dropdown (Insights, Rates, Action Types, Engagements) → **Rates** (`table_data_set=rates`); 50 stories; columns Engagements, Engaged User Rate, Taps Forward Rate, Taps Back Rate, Exits Rate, Completion Rate, DM Rate. Aggregate row rates all N/A by design (`04-rates-table.png`) |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | For every story, Engaged User Rate == Engagements ÷ Reach × 100 | 50/50 within display rounding (max diff 0.0050 pp). Rows joined across the Insights and Rates tables by Rank, with Date and Engagements verified equal on all 50 (0 mismatches). Samples: #1 123 / 7,800 → 1.577 vs **1.58%**; #2 84 / 7,798 → 1.077 vs **1.08%**; #22 21 / 6,884 → 0.305 vs **0.31%**; #40 9 / 35,950 → 0.025 vs **0.03%**; #50 0 / 2,707 → 0 vs **0.00%** | PASS |

### Per-story evidence (Rank | Date PST | Engagements | Reach | displayed rate | computed % | |diff|)
1 | Fri Nov 13 10:10 AM | 123 | 7,800 | 1.58% | 1.577 | 0.0031
2 | Sat Nov 14 10:35 AM | 84 | 7,798 | 1.08% | 1.077 | 0.0028
3 | Wed Nov 11 09:14 AM | 70 | 7,420 | 0.94% | 0.943 | 0.0034
4 | Sun Nov 15 06:01 AM | 70 | 6,683 | 1.05% | 1.047 | 0.0026
5 | Thu Nov 12 09:04 AM | 54 | 6,454 | 0.84% | 0.837 | 0.0033
6 | Tue Nov 10 09:03 AM | 47 | 7,679 | 0.61% | 0.612 | 0.0021
7 | Wed Nov 11 09:00 PM | 37 | 5,833 | 0.63% | 0.634 | 0.0043
8 | Tue Nov 10 06:31 PM | 36 | 6,550 | 0.55% | 0.550 | 0.0004
9 | Wed Nov 11 07:38 PM | 36 | 6,160 | 0.58% | 0.584 | 0.0044
10 | Sun Nov 15 12:18 PM | 33 | 6,011 | 0.55% | 0.549 | 0.0010
11 | Fri Nov 13 05:02 PM | 32 | 6,406 | 0.50% | 0.500 | 0.0005
12 | Tue Nov 10 05:27 PM | 31 | 6,718 | 0.46% | 0.461 | 0.0014
13 | Mon Nov 16 10:04 AM | 31 | 4,211 | 0.74% | 0.736 | 0.0038
14 | Tue Nov 10 12:46 PM | 30 | 6,495 | 0.46% | 0.462 | 0.0019
15 | Sun Nov 15 03:00 PM | 29 | 5,327 | 0.54% | 0.544 | 0.0044
16 | Thu Nov 12 11:31 AM | 25 | 6,054 | 0.41% | 0.413 | 0.0030
17 | Thu Nov 12 01:01 PM | 25 | 5,691 | 0.44% | 0.439 | 0.0007
18 | Sat Nov 14 03:24 PM | 25 | 6,035 | 0.41% | 0.414 | 0.0043
19 | Wed Nov 11 01:31 PM | 23 | 5,773 | 0.40% | 0.398 | 0.0016
20 | Sat Nov 14 10:51 AM | 23 | 6,637 | 0.35% | 0.347 | 0.0035
21 | Tue Nov 10 10:07 AM | 21 | 6,632 | 0.32% | 0.317 | 0.0034
22 | Fri Nov 13 12:40 PM | 21 | 6,884 | 0.31% | 0.305 | 0.0049
23 | Sat Nov 14 03:24 PM | 20 | 6,446 | 0.31% | 0.310 | 0.0003
24 | Tue Nov 10 03:44 PM | 17 | 6,520 | 0.26% | 0.261 | 0.0007
25 | Tue Nov 10 01:58 PM | 16 | 6,605 | 0.24% | 0.242 | 0.0022
26 | Thu Nov 12 12:25 PM | 16 | 5,888 | 0.27% | 0.272 | 0.0017
27 | Wed Nov 11 10:56 AM | 15 | 6,524 | 0.23% | 0.230 | 0.0001
28 | Sun Nov 15 10:28 AM | 14 | 5,427 | 0.26% | 0.258 | 0.0020
29 | Tue Nov 10 10:48 AM | 13 | 6,175 | 0.21% | 0.211 | 0.0005
30 | Sun Nov 15 09:03 AM | 13 | 5,950 | 0.22% | 0.218 | 0.0015
31 | Mon Nov 16 01:08 PM | 11 | 2,599 | 0.42% | 0.423 | 0.0032
32 | Mon Nov 16 02:59 PM | 11 | 1,818 | 0.61% | 0.605 | 0.0049
33 | Tue Nov 10 10:11 AM | 10 | 6,426 | 0.16% | 0.156 | 0.0044
34 | Wed Nov 11 11:41 AM | 10 | 6,610 | 0.15% | 0.151 | 0.0013
35 | Wed Nov 11 11:42 AM | 10 | 6,533 | 0.15% | 0.153 | 0.0031
36 | Wed Nov 11 11:46 AM | 10 | 5,886 | 0.17% | 0.170 | 0.0001
37 | Mon Nov 16 10:04 AM | 10 | 3,873 | 0.26% | 0.258 | 0.0018
38 | Wed Nov 11 09:18 AM | 9 | 6,665 | 0.14% | 0.135 | 0.0050
39 | Mon Nov 16 10:08 AM | 9 | 3,720 | 0.24% | 0.242 | 0.0019
40 | Mon Nov 16 10:40 AM | 9 | 35,950 | 0.03% | 0.025 | 0.0050
41 | Tue Nov 10 10:14 AM | 8 | 6,298 | 0.13% | 0.127 | 0.0030
42 | Mon Nov 16 12:59 PM | 8 | 2,762 | 0.29% | 0.290 | 0.0004
43 | Mon Nov 16 10:38 AM | 7 | 3,540 | 0.20% | 0.198 | 0.0023
44 | Wed Nov 11 11:41 AM | 5 | 6,716 | 0.07% | 0.074 | 0.0044
45 | Mon Nov 16 12:23 PM | 5 | 3,002 | 0.17% | 0.167 | 0.0034
46 | Mon Nov 16 12:23 PM | 5 | 2,976 | 0.17% | 0.168 | 0.0020
47 | Wed Nov 11 11:43 AM | 4 | 6,427 | 0.06% | 0.062 | 0.0022
48 | Wed Nov 11 11:46 AM | 4 | 6,344 | 0.06% | 0.063 | 0.0031
49 | Mon Nov 16 01:02 PM | 3 | 2,664 | 0.11% | 0.113 | 0.0026
50 | Mon Nov 16 01:02 PM | 0 | 2,707 | 0.00% | 0.000 | 0.0000

## Evidence
- Screenshots: `.playwright-out/QA-68228/01-stories.png`, `02-brand-typeahead.png`, `03-insights-state.png` (pre-Table-View tile layout), `03-insights-table.png`, `04-rates-table.png`.
- Stories have no permalink; rows were joined on Rank and cross-checked with Date + Engagements (50/50 equal).
- Aggregate rows: Reach N/A (Insights) and all rates N/A (Rates) — expected, Reach is not summable.
- Insights aggregate Engagements 1,178 matches the tile header "Engagements: 1,178".

## Known bugs checked
- Case file "Open linked bugs": none open (screen passed). `bug-history.md` / `known-quirks.md` had no QA-68228 entry. No bug reproduced; nothing interfered with the assertion.
- Observation (not a bug): the Stories table first showed the "This table failed to load" Reload tile right after the brand selection; one click on Reload (per the Reload-first rule) recovered it. The same session's table render needed a Table View click before the 50 rows appeared.

## Bugs filed
None.

## Cleanup
None (read-only).
