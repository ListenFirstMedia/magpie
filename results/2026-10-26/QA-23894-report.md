# QA-23894 — BPC > Brand Content vs Brand Insights - LinkedIn Channel

**Date:** 2026-10-26 (Monday) · **Mode:** unattended headless (`claude -p`, Playwright MCP) · **Env:** app.lfmdev.in
**Verdict: PASS** (with one noted Public-data-set observation — see "Observations")

## Screening
- Case file "Open linked bugs": **None open** → Rule 7 screen passed, case executed.
- `results/open-bugs-2026-10-26.json` has no QA-23894 entry.

## Setup actually used
- Login: Cognito "With existing account" (lfiqa), account switched to **UCLA** (`ACCOUNT: UCLA`, account_id 799).
- **Brand (Rule 1):** typing `UCLA` in the brand typeahead lists many `UCLA …` sub-brands but **no brand named exactly "UCLA"** (screenshot `01-brand-typeahead.png`). The UCLA account's primary brand is **University of California, Los Angeles** (brand_id 127756) — the same brand every prior UCLA data-test case used. It was selected from the typeahead on both Insights and Content (exact-name click, `brand_id=127756`). No substitution; this is the interpretation of "UCLA Brand".
- Perspective/View left at the app default (`perspective=extended`, Content `table_data_set=public`); the spec names no perspective.
- Date range: **Last 30 Days** = Sep. 25, 2026 – Oct. 24, 2026 (picked via "Make a Selection" → Last 30 Days; `02-date-overlay.png`, `03-after-last30.png`). Brand Content inherited the same range on navigation.

## Steps executed
1. Brand > Insights opened via top nav (`#explore/brand/insights?brand_id=127756…`).
2. Brand University of California, Los Angeles selected from typeahead; "Last 30 Days" chosen (Sep 25 – Oct 24, 2026).
3. Channel selector: Facebook/Twitter/Instagram/TikTok disabled, **LinkedIn enabled**, Apply → URL `channels=linkedin`, legend shows only `LinkedIn` (`04-insights-linkedin.png`).
4. Noted the **Best Performing Content (Lifetime)** (BPC) tile, Sort: Engagements, 5 posts (`05-insights-bpc.png`). Insights tile also shows `New Posts: 132 (+6%)`.
5. Navigated Brand > Content via top nav.
6. Brand University of California, Los Angeles re-selected from typeahead (`ok:true`).
7. **LinkedIn only** enabled (`channels=linkedin`, Posts (132)) (`06-content-linkedin.png`).
8. Switched to Table View (200-row scrape, 132 rows rendered; `07-content-table.png`), matched each BPC post to its Content row by LinkedIn permalink (URN) and compared every shown field. Also checked Grid View (`08-content-grid.png`) and the Video Views data set (`09-content-videoviews-ds.png`) for the one differing field.

## BPC (Brand Insights) vs Brand Content — per post
| BPC # | Post (LinkedIn URN) | Date (PDT) | Type | Engagements | Reactions | Shares | Comments | Video Views |
|---|---|---|---|---|---|---|---|---|
| 1 | …7511501952472510464 | Thu Oct 01 12:07 PM | Image | 1,331 = 1,331 | 1,262 = 1,262 | 26 = 26 | 43 = 43 | n/a |
| 2 | …7519833185157910528 | Sat Oct 24 11:52 AM | Image | 882 = 882 | 853 = 853 | 18 = 18 | 11 = 11 | n/a |
| 3 | …7518336754203066368 | Tue Oct 20 08:46 AM | Image | 857 = 857 | 835 = 835 | 14 = 14 | 8 = 8 | n/a |
| 4 | …7516169500598149120 | Wed Oct 14 09:14 AM | Video | 849 = 849 | 783 = 783 | 52 = 52 | 14 = 14 | BPC 11,072; Content Public DS "–"; Content **Video Views DS 11,072** |
| 5 | …7512540048236576769 | Sun Oct 04 08:52 AM | Gallery | 673 = 673 | 653 = 653 | 13 = 13 | 7 = 7 | n/a |

Content Table rank order (1–5 by Engagements) equals the BPC order; every post found by permalink; post text, date/time and type identical. Content totals (Sum row): Engagements 15,234 · Reactions 14,336 · Comments 321 · Shares 577 over **132 posts** = Insights `New Posts: 132`.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 8 | BPC posts data (Brand Insights, LinkedIn, Last 30 Days) matches Brand Content posts data | 5/5 BPC posts found in Content with identical rank, date, type, Engagements, Reactions, Shares, Comments. The only field not visible in Content's default (Public) data set is the video post's Video Views (BPC 11,072 vs "–"); Content's Video Views data set shows the identical 11,072. Insights New Posts 132 = Content Posts (132). | **PASS** (note) |

## Observations (not a verdict-changer, not filed)
- On the default Brand Content **Public** data set the LinkedIn video post (#4) shows Video Views "–" in both Table and Grid views, while BPC shows 11,072. The same post carries 11,072 in the **Video Views** data set (Video Views = 11,072; Unclassified Views 11,072; Organic/Paid "–"). Treated as a data-set display difference (Public set carries no LinkedIn view counts), consistent with the skill note that LinkedIn organic/paid views are structurally split; the underlying figure matches. If product expects the Public table to show LinkedIn Video Views, this should be raised with product — flagged here rather than filed.
- Console reported many app errors (38+ on Content); none affected the rendered data or the comparison.

## Known bugs checked
- Case "Open linked bugs": none. `knowledge-base/bug-history.md` / `known-quirks.md`: no QA-23894 entries (pre-fetched). One known-quirks grep for LinkedIn video/views/public: nothing applicable.
- Related surface bugs seen in sibling case QA-23892 (LFMP-31958 Twitter BPC vs Content, LFMP-32113 LFM vs Native) concern other channels/comparisons and were not exercised here; nothing reproduced for LinkedIn.

## Bugs filed
None (markdown-only policy; nothing new filed).

## Evidence
`.playwright-out/QA-23894/`: 01-brand-typeahead, 02-date-overlay, 03-after-last30, 04-insights-linkedin, 05-insights-bpc, 06-content-linkedin, 07-content-table, 08-content-grid, 09-content-videoviews-ds (.png).
