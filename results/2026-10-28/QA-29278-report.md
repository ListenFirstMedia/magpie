# QA-29278 — Brand Content - Impressions Dataset - Data Test - TikTok

**Date:** 2026-10-28 (Wednesday)
**Mode:** unattended / headless (`claude -p`), Playwright MCP
**Verdict: FAIL** (A1 fails: 3 of 22 TikTok posts show "–" for Total Impressions; A2 passes)

## Setup / account choice

- Login: Cognito "With existing account" using `config/.env` (lfiqa@listenfirstmedia.com). The session landed on `#home` with ACCOUNT: WASSERMAN (account_id=863).
- Weekday rotation (Wednesday row of the Description table): Account 1 = **Apple Services**, Brand 1 = **Apple Music**. The first pair of the row was used; NBCU Enterprises / CNBC / NBC News were not run. Same call as the earlier runs: the Description table is authoritative over the Notes line.
- Account switch (Precondition "different login for each day"): account menu, typed "Apple Services", clicked the exact result. Breadcrumb then read `ACCOUNT: APPLE SERVICES` (account_id=409).
- Date range: Oct. 20, 2026 - Oct. 26, 2026 (app default, last full week). View: Authorized data (`perspective=extended`, app default; the spec sets no perspective).

## Steps executed

1. Hovered the **Brand** top-nav menu and clicked **Content** (`#explore/brand/content`). Done.
2. Opened the brand selector and typed "Apple Music". Results: Apple Music, Apple Music (Japan), Apple Music (LATAM), Apple Music -  NFL Players, Apple Music Classical, Apple Music Hall, Apple Music Radio Sept 2025. Clicked the exact "Apple Music" (brand_id=31783). Opened the visible Data Set dropdown and selected **Impressions** (URL `table_data_set=impressions`). Done.
3. Clicked off Facebook, X, Instagram, LinkedIn and Threads one at a time. DOM check: `.channel-ghost.tiktok` enabled; facebook/twitter/instagram/linkedin/threads disabled (YouTube/Pinterest were already disabled). Clicked **Apply**. URL `channels=tiktok`, grid shows **Posts (22)**. Done.
4. Reviewed Total / Organic / Paid Impressions on every post. Values were scraped from Table View (one row per grid post, plus the Sum/Average row), then the last rows were checked visually in Grid View. Done.

## Assertions

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| A1 | 4 | Total Impressions displays a value on every post | 19 of 22 posts show a number (918,431 / 580,725 / 158,756 / 73,461 / 28,883 / 15,029 / 12,229 / 9,653 / 7,251 / 13,366 / 5,551 / 5,728 / 7,921 / 4,441 / 10,540 / 33,131 / 31,936 / 3 / 2). Posts ranked **18, 19 and 20 show "–"** for Total Impressions. The 19 numeric values sum to 1,917,037, which equals the Sum row. | **FAIL** |
| A2 | 4 | Organic Impressions and Paid Impressions are en-dash on every post | All 22 posts show "–" for both Organic Impressions and Paid Impressions. The Sum row also shows "–" for both. | PASS |

Every row carries the `fa-tiktok` channel icon, so no other channel leaked into the set.

### Failing posts (A1)

All three are Apple Music TikTok videos, "Try 1 month free of Apple Music.* Terms apply.", published Sun Oct. 25, 2026 10:37 PM PDT. They show Total / Organic / Paid Impressions "–", Reach "–" and Engagements 0. A fourth post with the same text and timestamp (rank 21) does show Total Impressions 3, so the "–" is a missing metric rather than a zero. Rank 22 (Mon Oct. 26, 02:52 PM PDT) shows 2.

## Evidence

- `.playwright-out/QA-29278/01-content-landing.png` — Brand > Content landing, Apple Services account.
- `.playwright-out/QA-29278/02-brand-dropdown.png` — brand typeahead open, exact "Apple Music" in Results.
- `.playwright-out/QA-29278/03-impressions-selected.png` — Impressions data set selected, all channels still enabled.
- `.playwright-out/QA-29278/04a-tiktok-only-before-apply.png` — channel toggles with only TikTok on.
- `.playwright-out/QA-29278/04-tiktok-impressions-grid.png` — TikTok only, Posts (22), grid layout.
- `.playwright-out/QA-29278/05-tiktok-impressions-table.png` — Table View.
- `.playwright-out/QA-29278/06-grid-bottom.png` — Grid View bottom: tiles for ranks 18–20 (top row) show Impressions "–", Organic "–", Paid "–"; rank 21 shows 3, rank 22 shows 2.
- DOM scrape of `table.lfm-table` (Rank header): 23 rows (Sum/Average + 22 posts). Sum row: Impressions 1,917,037, Organic –, Paid –.

## Known bugs checked

- Case file "Open linked bugs": none open (Rule 7 screen passed).
- `knowledge-base/bug-history.md`: no QA-29278 match (pre-fetched).
- `knowledge-base/known-quirks.md`: notes that this case's TikTok "–" Total Impressions depends on the brand's TikTok feed (failed on HBO Max on 10-26, passed on UCLA on 10-20 and 10-27). It is recorded as a brand-specific data finding, not an accepted product behavior, so it does not turn the A1 miss into a pass. The same symptom is reproduced here on Apple Music.
- No linked bug applies, so the failure is not attributed to a known bug.

## Bugs filed

None filed in Jira (markdown-only policy). Candidate defect for triage: Apple Music (Apple Services account, brand_id=31783) TikTok posts ranked 18–20 for Oct. 20–26, 2026 have no Total Impressions value ("–") while a same-text, same-timestamp sibling post shows 3. Total Impressions does not display for every post, as A1 requires.

## Notes

- Not run: the other Wednesday account/brand pairs (NBCU Enterprises with CNBC / NBC News); the case defines "Add a Brand" per day without requiring all of them in one execution. A re-run on one of those brands would show whether the gap is specific to Apple Music's TikTok feed.
- Reach was read only for ranks 18–22, where it shows "–"; it was not checked on the other posts and is outside this case's assertions.
- The Sum/Average toggle was not used; only the Sum row was read.
- Skill maintenance is deferred to harvest.sh.
