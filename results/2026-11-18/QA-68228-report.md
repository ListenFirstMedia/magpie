# QA-68228 — Brand > Stories - Engaged User Rate - Posts - Data QA

**Run date:** 2026-11-18 (unattended, headless `claude -p`, Playwright MCP), dev `app.lfmdev.in`, user lfiqa (programmatic Cognito login)
**Account:** Hulu (account_id=336) — the login landed on **UCLA**, so the precondition "logged in to Hulu" was satisfied by switching account via the profile menu (Search Account → Results → Hulu; header then showed `ACCOUNT: HULU`).
**Brand:** Hulu (brand_id=5670, typed "Hulu", clicked the exact first Results entry "Hulu") · Surface: Brand > Stories · Channel: Instagram · Perspective: `extended` (URL default) · Date range: Nov. 10 – Nov. 16, 2026
**Verdict: PASS — 50/50 stories satisfy Engaged User Rate = Engagements ÷ Reach × 100 (max |computed − displayed| = 0.0050 pp, i.e. the 2-decimal display rounding; 0 failures)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Precondition: logged in to Hulu | Login → `#home` showed ACCOUNT: UCLA; switched to Hulu via profile menu → ACCOUNT: HULU |
| 1 | Brand (top nav) → Stories tab | Hovered Brand, clicked Stories → `#explore/brand/stories?brand_id=5670&account_id=336&from=2026-11-10&to=2026-11-16&...&perspective=extended` (`01-stories.png`) |
| 2 | Type and select Hulu in the brand dropdown | Clicked brand name, typed `Hulu` in "Search for a Brand"; Results: Hulu, 1266 (Hulu), Aftershock (Hulu), … — clicked exact "Hulu"; URL gained `channels=instagram&table_data_set=insights`; **Stories (50)** (`02-brand-typeahead.png`) |
| 3 | Review posts, note Engagements and Reach | Clicked Table View → 50 stories + Sum/Average row (no Reload tile this run). Data set **Insights**. Aggregate: Engagements 1,252 / Impressions 379,721 / Reach N/A (`03-insights-table.png`). Per-story Engagements and Reach captured (table below) |
| 4 | Select Rates in the data set | Data set dropdown (Insights → **Rates**, `table_data_set=rates`); 50 stories; columns Engagements, Engaged User Rate, Taps Forward Rate, Taps Back Rate, Exits Rate, Completion Rate, DM Rate. Aggregate row rates all N/A by design (`04-rates-table.png`) |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | For every story, Engaged User Rate == Engagements ÷ Reach × 100 | 50/50 within display rounding (max diff 0.0050 pp; all diffs <= 0.0050). Rows joined across the Insights and Rates tables by Rank, with Date and Engagements verified equal on all 50 (0 mismatches). Samples: #1 123 / 7,800 → 1.577 vs **1.58%**; #3 84 / 7,798 → 1.077 vs **1.08%**; #22 21 / 6,884 → 0.305 vs **0.31%**; #39 10 / 46,923 → 0.021 vs **0.02%**; #50 1 / 3,777 → 0.026 vs **0.03%** | PASS |

### Per-story evidence (Rank | Date PST | Engagements | Reach | displayed rate | computed % | |diff|)
1 | Fri Nov 13 10:10 AM | 123 | 7,800 | 1.58% | 1.577 | 0.0031
2 | Mon Nov 16 10:04 AM | 89 | 5,539 | 1.61% | 1.607 | 0.0032
3 | Sat Nov 14 10:35 AM | 84 | 7,798 | 1.08% | 1.077 | 0.0028
4 | Wed Nov 11 09:14 AM | 70 | 7,420 | 0.94% | 0.943 | 0.0034
5 | Sun Nov 15 06:01 AM | 70 | 6,683 | 1.05% | 1.047 | 0.0026
6 | Thu Nov 12 09:04 AM | 54 | 6,454 | 0.84% | 0.837 | 0.0033
7 | Tue Nov 10 09:03 AM | 47 | 7,679 | 0.61% | 0.612 | 0.0021
8 | Wed Nov 11 09:00 PM | 37 | 5,833 | 0.63% | 0.634 | 0.0043
9 | Tue Nov 10 06:31 PM | 36 | 6,550 | 0.55% | 0.550 | 0.0004
10 | Wed Nov 11 07:38 PM | 36 | 6,160 | 0.58% | 0.584 | 0.0044
11 | Sun Nov 15 12:18 PM | 33 | 6,011 | 0.55% | 0.549 | 0.0010
12 | Fri Nov 13 05:02 PM | 32 | 6,406 | 0.50% | 0.500 | 0.0005
13 | Tue Nov 10 05:27 PM | 31 | 6,718 | 0.46% | 0.461 | 0.0014
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
27 | Mon Nov 16 02:59 PM | 16 | 3,126 | 0.51% | 0.512 | 0.0018
28 | Wed Nov 11 10:56 AM | 15 | 6,524 | 0.23% | 0.230 | 0.0001
29 | Sun Nov 15 10:28 AM | 14 | 5,427 | 0.26% | 0.258 | 0.0020
30 | Mon Nov 16 10:04 AM | 14 | 4,827 | 0.29% | 0.290 | 0.0000
31 | Tue Nov 10 10:48 AM | 13 | 6,175 | 0.21% | 0.211 | 0.0005
32 | Sun Nov 15 09:03 AM | 13 | 5,950 | 0.22% | 0.218 | 0.0015
33 | Mon Nov 16 01:08 PM | 11 | 3,681 | 0.30% | 0.299 | 0.0012
34 | Tue Nov 10 10:11 AM | 10 | 6,426 | 0.16% | 0.156 | 0.0044
35 | Wed Nov 11 11:41 AM | 10 | 6,610 | 0.15% | 0.151 | 0.0013
36 | Wed Nov 11 11:42 AM | 10 | 6,533 | 0.15% | 0.153 | 0.0031
37 | Wed Nov 11 11:46 AM | 10 | 5,886 | 0.17% | 0.170 | 0.0001
38 | Mon Nov 16 10:08 AM | 10 | 4,655 | 0.21% | 0.215 | 0.0048
39 | Mon Nov 16 10:40 AM | 10 | 46,923 | 0.02% | 0.021 | 0.0013
40 | Wed Nov 11 09:18 AM | 9 | 6,665 | 0.14% | 0.135 | 0.0050
41 | Tue Nov 10 10:14 AM | 8 | 6,298 | 0.13% | 0.127 | 0.0030
42 | Mon Nov 16 12:59 PM | 8 | 3,855 | 0.21% | 0.208 | 0.0025
43 | Mon Nov 16 10:38 AM | 7 | 4,496 | 0.16% | 0.156 | 0.0043
44 | Mon Nov 16 12:23 PM | 7 | 4,005 | 0.17% | 0.175 | 0.0048
45 | Wed Nov 11 11:41 AM | 5 | 6,716 | 0.07% | 0.074 | 0.0044
46 | Mon Nov 16 12:23 PM | 5 | 4,051 | 0.12% | 0.123 | 0.0034
47 | Mon Nov 16 01:02 PM | 5 | 3,731 | 0.13% | 0.134 | 0.0040
48 | Wed Nov 11 11:43 AM | 4 | 6,427 | 0.06% | 0.062 | 0.0022
49 | Wed Nov 11 11:46 AM | 4 | 6,344 | 0.06% | 0.063 | 0.0031
50 | Mon Nov 16 01:02 PM | 1 | 3,777 | 0.03% | 0.026 | 0.0035

## Evidence
- Screenshots: `.playwright-out/QA-68228/01-stories.png`, `02-brand-typeahead.png`, `03-insights-table.png`, `04-rates-table.png`.
- Stories have no permalink; rows were joined on Rank and cross-checked with Date + Engagements (50/50 equal).
- Aggregate rows: Reach N/A (Insights) and all rates N/A (Rates) — expected, Reach is not summable.
- Insights aggregate Engagements 1,252 (Sum row) equals the Rates table's aggregate Engagements 1,252.
- Data differs from the 2026-11-17 run for the same range (Nov 10–16): Reach/Engagements of Nov 16 stories grew as insights matured (e.g. aggregate Engagements 1,178 → 1,252); the identity held on both days.

## Known bugs checked
- Case file "Open linked bugs": none open (screen passed, Rule 7). `bug-history.md` / `known-quirks.md` had no QA-68228 entry (pre-fetched). No bug reproduced; nothing interfered with the assertion. The "table failed to load" Reload tile seen on 2026-11-17 did not recur.

## Bugs filed
None.

## Cleanup
None (read-only).
