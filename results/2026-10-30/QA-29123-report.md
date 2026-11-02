# QA-29123 — Brand Content - Basic Data Set - Data Test - TikTok

**Run date:** 2026-10-30 (Friday) · **Track:** Playwright MCP, unattended `claude -p` · **Env:** app.lfmdev.in · **Login:** `lfiqa@listenfirstmedia.com` (Cognito "With existing account") · **Account:** HULU (account_id=336) · **Brand:** Hulu (brand_id=5670) · **Date range:** app default week 2026-10-22 .. 2026-10-28 (spec gives none, left unchanged) · **Channel:** TikTok only · **Data set:** Public (`table_data_set=public`) · **Perspective:** Authorized (default `extended`)

**Verdict: PASS (1/1 runnable Friday leg)** — Reactions + Comments + Shares = Engagements holds on all 48 TikTok posts and on the aggregate Sum row for Hulu. The Friday Description row names only one brand, so there are no other legs to run (see interpretation notes).

## Pre-screen (Rule 7)
The case file's "Open linked bugs" section says "None open". The pre-fetched bug-history match for QA-29123 was empty. The screen passed and the case was run.

## Interpretation notes
- **Weekday rotation:** 2026-10-30 is a Friday. The Description table's Friday row lists accounts Hulu / Robinhood / PlayOn! Sports, but only one brand: "Hulu" (the second brand cell is blank). I ran the only named brand, Hulu, on the Hulu account. I did not invent brands for Robinhood or PlayOn! Sports. The case Notes line ("Fri Hulu/Ralph Lauren") disagrees with the Description table, so I followed the table. The case owner may want to fill in the blank brand cell.
- **Date range:** the ticket gives none. The app's default week was left unchanged, as in earlier runs of this case.
- **Skill:** `brand-content-grid-math` (Table View DOM scrape, identity evaluated in page JS) with the shared helpers (`devprod-helpers.js`, `set-helpers.js`). No skill was pre-resolved; the skill came from the case Notes.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito "With existing account", `config/.env`) | OK, landed on `#home` |
| P | Precondition: switch account through the account menu to Hulu | OK — `ACCOUNT: HULU` (account_id=336) |
| 1 | Hover Brand in the top nav, click Content | OK — `#explore/brand/content`, 210 posts across all channels in the default week |
| 2 | Add the Brand | OK — brand selector already showed the exact spec brand "Hulu" (brand_id=5670), so no change was needed |
| 3 | Enable TikTok channel only | OK — explicit ghost clicks, Apply. Enabled ghosts `["tiktok"]`, URL `channels=tiktok`, Posts (48) |
| 4 | Table View; per post Reactions + Comments + Shares vs Engagements | DOM scrape of `table.lfm-table` (`Rank` header verified), see assertions |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4-posts | 4 | Reactions + Comments + Shares = Engagements for each post | 48 TikTok posts (all 48 link to tiktok.com), 48/48 match, 0 mismatches. Rank 1: 110,076 = 103,300 + 401 + 6,375. Rank 2: 35,327 = 33,700 + 239 + 1,388. Rank 3: 31,895 = 30,200 + 374 + 1,321. Rank 48: 29 = 27 + 1 + 1. Rank 47: 46 = 45 + 1 + – (Shares "–", treated as 0). 4 posts have a "–" in one component; the identity holds with "–" as 0. No post had a "–" Engagements total. | PASS |
| A4-agg | 4 | Aggregate Sum row obeys the same identity | Sum row (48 posts): 265,386 + 1,586 + 12,351 = 279,323 = Engagements 279,323 | PASS |

## Evidence
- `.playwright-out/QA-29123/1030-01-hulu-tiktok.png` (Hulu Content, TikTok only, Table View)
- Exact numbers were read from the DOM of `table.lfm-table` (headers Rank … Engagements, Reactions, Comments, Shares, Response Rate, Video Views …) and the identity was evaluated in page JS.
- Final URL: `#explore/brand/content?brand_id=5670&account_id=336&from=2026-10-22&to=2026-10-28&channels=tiktok&perspective=extended&table_data_set=public`.

## Known bugs checked
- Case file "Open linked bugs": none open.
- `knowledge-base/bug-history.md`: no match for QA-29123.
- During the run: no known bug reproduced. The page rendered on the first attempt with no "failed to load" or render hang.

## Bugs filed
None.
