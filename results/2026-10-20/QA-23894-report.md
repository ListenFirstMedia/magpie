# QA-23894 — BPC > Brand Content vs Brand Insights - LinkedIn Channel

**Verdict: PASS**
**Run:** 2026-10-20, unattended headless (Playwright MCP) · Env: app.lfmdev.in · Login: lfiqa (programmatic Cognito login)
**Account:** UCLA (account_id=799, switched via profile menu > Search Account > `Results` item) · **Brand:** University of California, Los Angeles (brand_id=127756)
**Range:** Last 30 Days = Sep 19, 2026 – Oct 18, 2026 · **Channel:** LinkedIn only · **View:** Authorized data (page default; spec names none) · Mode: Lifetime

## Steps executed
1. Home > Brand Insights (opened `#explore/brand/insights`, account UCLA).
2. Brand chevron > typeahead. Typing `UCLA` returns only sub-brands (UCLA Alumni, UCLA Bruins, …) and **no brand named exactly "UCLA"**. The account's own brand is `University of California, Los Angeles`, the exact-name typeahead result (a sibling result "…Los Angeles Police" was not chosen). Selected it, consistent with the precedent for the UCLA account in this data set (QA-20318 etc.) — Rule 1 note: no sub-brand substituted. Date picker "Make a Selection" > **Last 30 Days** → Sep 19 – Oct 18, 2026 (URL from=2026-09-19, to=2026-10-18).
3. Channel selector: clicked `.channel-ghost.linkedin` (all others went `disabled`; LinkedIn is per-channel-only), clicked Apply → URL `channels=linkedin`.
4. Noted Best Performing Content (Lifetime) tile (sort: Engagements) top-5 posts + tile "New Posts: 133".
5. Top nav Brand > Content (brand and range carried over).
6. Re-selected brand via the typeahead: exact result `University of California, Los Angeles` (brand_id=127756).
7. Channel selector: LinkedIn on, Facebook/Twitter/Instagram/TikTok/Threads off, Apply → URL `channels=linkedin`. Posts (133).
8. Compared BPC posts with Brand Content posts (Table View, Public data set; Video Views via the Video Views data set; Grid and Detail views also inspected).

## BPC values (Brand Insights, LinkedIn, Sep 19 – Oct 18 2026)
| # | Published (PDT) | Type | Engagements | Reactions | Shares | Comments | Video Views |
|---|---|---|---|---|---|---|---|
| 1 | Mon Sep 21 06:00 PM | Image | 11,200 | 9,873 | 1,110 | 217 | – |
| 2 | Mon Sep 21 06:20 PM | Video | 2,089 | 1,891 | 144 | 54 | 20,106 |
| 3 | Thu Oct 01 12:07 PM | Image | 1,331 | 1,262 | 26 | 43 | – |
| 4 | Wed Oct 14 09:14 AM | Video | 698 | 646 | 40 | 12 | 8,920 |
| 5 | Sun Oct 04 08:52 AM | Gallery | 676 | 655 | 13 | 8 | – |

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A8.1 | 8 | BPC post count/identity matches Content | Insights New Posts = 133; Content `Posts (133)`, 133 table rows; ranks 1–5 are the same 5 posts (same dates/types/text) as the BPC tile in the same order | PASS |
| A8.2 | 8 | Post 1 metrics match | Content table: 11,200 / 9,873 / 1,110 / 217 (Eng/React/Shares/Comments) = BPC | PASS |
| A8.3 | 8 | Post 2 metrics match | 2,089 / 1,891 / 144 / 54 = BPC; Video Views 20,106 (Video Views data set) = BPC | PASS |
| A8.4 | 8 | Post 3 metrics match | 1,331 / 1,262 / 26 / 43 = BPC | PASS |
| A8.5 | 8 | Post 4 metrics match | 698 / 646 / 40 / 12 = BPC; Video Views 8,920 (Video Views data set) = BPC | PASS |
| A8.6 | 8 | Post 5 metrics match | 676 / 655 / 13 / 8 = BPC | PASS |
| A8.7 | 8 | Sum row consistent | Content Sum: Engagements 27,993 = Reactions 25,537 + Comments 612 + Shares 1,844 | PASS |

## Evidence / notes
- Screenshots in `.playwright-out/QA-23894/`: `06-bpc-linkedin.png` (BPC tile), `07-content-table.png` (Table View), `08/09` (Grid, same values, Engagements highlighted), `10-content-detail.png`, `11-content-videoviews-ds.png`.
- **Video Views on the Public data set:** Content Table/Grid show "–" for the two video posts' Video Views, while BPC shows 20,106 / 8,920. This is by design: the Detail view text reads "Video Views on LinkedIn is Authorized only and can be seen in the Video Views data set." Switching the data set to **Video Views** (Posts (32)) shows 20,106 and 8,920 for those two posts, exactly matching BPC. Not a defect.
- Content is sorted by Engagements (default), matching the BPC "Sort: Engagements".
- Authorized perspective was the page default on both pages (`perspective=extended`); same perspective used on both sides.
- Console shows many pre-existing errors (platform noise); a Facebook Posts Insights Disruption status banner is present but irrelevant to the LinkedIn-only data.
- Left the Content page on the Video Views data set after the run (no mutation, nothing to clean up).

## Known bugs checked
Case file "Open linked bugs": none open. Pre-fetched bug-history / known-quirks greps for QA-23894: none. One extra known-quirks/bug-history grep on LinkedIn: no entry covering BPC-vs-Content mismatch or LinkedIn Video Views. No known bug reproduced or interfered.

## Bugs filed
None.
