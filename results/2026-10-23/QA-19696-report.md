# QA-19696 — Brand Content - Basic Data Set - Data Test

**Run date:** 2026-10-23 (Friday → rotation row: account **Hulu**, brand **Hulu**) · **Track:** Playwright MCP, unattended headless (`claude -p`) · **Account:** Hulu (account_id=336, breadcrumb `ACCOUNT: HULU`) · **Brand:** Hulu (brand_id=5670, account default — exact name) · **Date range:** default week Oct. 15 – Oct. 21, 2026 · **Channel:** Facebook only · **Data set:** Public (Basic) · **Perspective:** Authorized (default)
**Verdict: PASS (1/1) — Reactions + Comments + Shares = Engagements on all 44 posts and on the Sum row**

## Preconditions
- Login: `lfiqa@listenfirstmedia.com` via Cognito "With existing account" → `#home`. The session landed on account 336 (Hulu), which is Friday's rotation account, so no account switch was needed. Breadcrumb confirmed `ACCOUNT: HULU`.
- Open-bug screen (Rule 7): case file says "None open" → run normally.

## Steps
| # | Step | Result |
|---|------|--------|
| 1 | Hover Brand → click Content in the top nav | Landed on `#explore/brand/content?brand_id=5670&account_id=336…` |
| 2 | Brand | Page header shows **Hulu** (brand 5670, exact name, the account's default brand). No substitution (Rule 1) |
| 3 | Enable Facebook channel only | Clicked Twitter, Instagram, TikTok, LinkedIn and Threads off with trusted clicks (Facebook stayed enabled; YouTube and Pinterest were already disabled). Verified `.channel-ghost.facebook.enabled` and every other ghost `disabled`, then clicked Apply. URL `channels=facebook`, **Posts (44)** (was 172 with all channels) |
| 4 | In each grid post, read Reactions, Comments, Shares | Switched to Table View (`[title="Table View"]`, `table.lfm-table` with a Rank header). Scraped all 44 rows via the DOM plus the Sum row |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | Reactions + Comments + Shares = Engagements for each post | 44/44 posts match exactly, 0 failures, 0 skipped, no "–" cells. Rank 1: 6,244+85+382 = 6,711 ✓; rank 2: 6,388+16+82 = 6,486 ✓; rank 3: 4,503+27+81 = 4,611 ✓. Sum row: Reactions 32,164 + Comments 488 + Shares 1,256 = 33,908 = Engagements 33,908 ✓ | ✅ PASS |

## Evidence
- `.playwright-out/QA-19696/01-content-landing.png` — Hulu Brand > Content landing: all-channel view (172 posts), Public data set, Authorized data.
- `.playwright-out/QA-19696/02-fb-public-table.png` — Facebook-only Table View.
- Facebook-only URL: `…channels=facebook&perspective=extended&table_data_set=public…`.
- I read the Table View data by scripted DOM scrape. The Channel column is an icon with no text, so I confirmed Facebook-only from `channels=facebook` in the URL and the Posts count dropping from 172 to 44.

## Known bugs checked
- No open linked bugs in the case file, and there is nothing for QA-19696 in `bug-history.md` or `known-quirks.md`.
- A "Facebook Data Collection Disruption 9/27" platform banner was showing. It did not affect this identity: no Facebook post had "–" on Reactions, Comments or Shares.

## Bugs filed
None. · **Cleanup:** none (read-only case).
