# QA-19700 — Brand Content - Video Views Dataset - Data Test

**Date:** 2026-10-23 (Friday)
**Mode:** unattended, headless (`claude -p`), Playwright MCP
**Verdict: PASS**

## Setup
- Weekday rotation (Friday): Account **Hulu**, Brand **Hulu** (Ralph Lauren is the alternate; Hulu used).
- Login: programmatic Cognito email/password (`config/.env`, user LFQA). Account switched to **Hulu** (account_id=336) via the profile menu `Search Account` typeahead (`Results` section, `.lfm-ta-option`). Breadcrumb confirmed `ACCOUNT: HULU / BRAND > CONTENT`.
- Date range: default Oct. 15 – Oct. 21, 2026. Mode: Lifetime. View: Authorized data (default; the case does not specify a perspective).
- Page banner "Facebook Data Collection Disruption 9/27" was present (status page, last updated 21 days ago).

## Steps executed
1. Hovered **Brand** in the top nav and clicked **Content** → `#explore/brand/content` (brand_id=5670, account_id=336).
2. Opened the brand picker, typed `Hulu`, clicked the exact `Hulu` entry (first in the typeahead list, brand_id=5670). Then Data Set dropdown → **Video Views** (URL `table_data_set=video_views`).
3. Channels: disabled Twitter, Instagram, TikTok, LinkedIn by clicking each ghost; Facebook stayed enabled (the last channel was never deselected). Verified `.channel-ghost.facebook.enabled` only, clicked **Apply**. URL became `channels=facebook`; `Posts (41)`.
4. Switched to **Table View** and scraped every row (41 posts + Sum/Average row; the page renders 200 per page, so this is all of them). Per post, evaluated Organic Views + Paid Views vs Video Views.
5. Noted Engagements and Video Views per post and for the aggregate row.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A4 | 4 | Organic Views + Paid Views = Video Views, every post | 40 of 40 evaluable posts match exactly, 0 mismatches. 1 post (rank 41, 16 Oct 03:30 PM, Phony teaser) shows "–" for Video Views, Organic, Paid, Unclassified, Viewers: no data, skipped. Unclassified Views is 0 or "–" on every row, so it does not distort the sum. Aggregate Sum row: Organic 1,256,209 + Paid 0 = Video Views 1,256,209. Column sums over the rows give the same figures. | PASS |
| A5 | 5 | Engagements / Video Views = Video Response Rate (±0.01 pp of the 2-decimal display), every post | 40 of 40 evaluable posts match, 0 mismatches (same skipped post: Video Views "–", rate "–", Engagements 4). Samples: rank 1: 6,711 / 76,840 = 8.73% (shown 8.73%); rank 2: 6,486 / 242,010 = 2.68% (shown 2.68%); rank 40: 24 / 1,361 = 1.76% (shown 1.76%). | PASS |

## Evidence
- Aggregate (Sum) row, Facebook only: Engagements 33,570; Video Views 1,256,209; Organic Views 1,256,209; Paid Views 0; Unclassified 0; Video Response Rate "N/A" (Sum mode does not compute a rate). Engagements over posts that have Video Views total 33,566 (the skipped post contributes 4).
- Paid Views is 0 on all evaluable posts (Hulu Facebook content in this window is all organic), so A4 here is effectively Organic = Video Views. The identity still holds.
- Screenshots in `.playwright-out/QA-19700/`: `01-brand-content.png` (Hulu account/brand landing), `02-brand-picker.png` and `03-picker-state.png` (brand picker), `04-table-view.png` (Table View after Facebook-only + Video Views). The scrape was done on the DOM, not from the screenshots.

## Known bugs checked
- Case file "Open linked bugs": none open (screen passed, Rule 7).
- `knowledge-base/bug-history.md` and `known-quirks.md`: no matches for QA-19700 (pre-fetched).
- Related surface note: the Facebook collection disruption banner was visible, and one of 41 posts has no view metrics, consistent with the pattern in `brand-content-grid-math`. It did not affect the assertions, because "–" totals are skipped by the case notes.

## Bugs filed
None. (Markdown-only; no Jira tickets created.)

## Notes for harvest
- Skill used: `brand-content-grid-math` (Table View scrape, data-set-before-channel ordering, last-channel rule). Worked as documented.
- The Brand picker on the Content page is opened by clicking `.brand-selector-name-container`. The search box is not a plain `<input>`: typing needs a real mouse click on the box and `page.keyboard.type`. Typeahead entries live under `.item-list-wrapper`, and the exact `Hulu` entry is first.
- Table View header names carry line breaks; match after collapsing whitespace.
