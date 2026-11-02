# QA-29115 — Brand Content > Basic Data Set > Past date range data test - LinkedIn

**Run date:** 2026-10-26 (Monday) · **Track:** Playwright MCP, headless unattended (`claude -p`) · **Env:** app.lfmdev.in
**Verdict: PASS**

## Open-bug screen (Rule 7)
`cases/QA-29115.md` says "None open". `results/open-bugs-2026-10-26.json` has no QA-29115 entry. The screen passed and the case was run in full.

## Steps executed
1. Logged in as the config/.env user (landed on ACCOUNT: ADAM ORFEI) and switched to the **UCLA** account through the account menu (account_id=799). Hovered Brand > Content in the top nav. Screenshot `01-content-landing.png`.
2. Brand: the brand search for "UCLA" returned only "UCLA …" variants (UCLA Alumni, UCLA Bruins, UCLA Health, and so on) and **no literal "UCLA" brand** (`02-brand-typeahead.png`). The UCLA account's own brand is **University of California, Los Angeles** (brand_id=127756). I typed it into the picker and clicked the exact-match result. This follows the 2026-10-20 runs (QA-100887, QA-20271, QA-20275), which treated "UCLA" the same way. See "Deviation" below.
3. Date range set through the START/END date picker: Jan 01, 2025 to Oct 01, 2025. The picker fields read `START DATE Jan 01, 2025 / END DATE Oct 01, 2025`, and the URL has `from=2025-01-01&to=2025-10-01` (`03-dates-set.png`).
4. Channels: clicked the LinkedIn ghost and deselected all others. Enabled set = `["linkedin"]`, then Apply (`04-linkedin-only.png`). Data set is the default **Public** (cross-channel basic set, `table_data_set=public`). All 200 scraped rows carry a linkedin.com permalink.
5. Switched to Table View (`[title="Table View"]`, `05-table-view.png`). Heading reads **Posts (1,013)**, and 200 rows render per page with no pager and no further rows on scroll (`06-table-bottom.png`). Scraped the DOM and tested Reactions + Comments + Shares = Engagements on every rendered row and on the Sum row. Sorted Engagements ascending (`07-sorted-asc.png`) to scrape the 200 lowest-ranked posts as well. The top-200 and bottom-200 sets share 0 posts.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A5a | 5 | Top 200 posts by Engagements (desc): Reactions + Comments + Shares = Engagements for each post | 200/200 match, 0 mismatches, 0 rows with a "–" in any column. Example: Rank 1 (Sat Mar. 15, 2025): 2,792 + 64 + 67 = 2,923 = Engagements 2,923 | PASS |
| A5b | 5 | Bottom 200 posts (Engagements asc, e.g. 3 … 19): same identity | 200/200 match, 0 mismatches, 0 "–" rows | PASS |
| A5c | 5 | Aggregate Sum row (all 1,013 posts): Reactions + Comments + Shares = Engagements | 133,014 + 4,270 + 7,147 = 144,431 = Engagements 144,431 | PASS |

The scraped top-200 rows alone sum to Engagements 109,333 = 101,459 + 3,084 + 4,790, which is also internally consistent.

## Evidence
- Screenshots in `.playwright-out/QA-29115/`: 01-content-landing, 02-brand-typeahead, 03-dates-set, 04-linkedin-only, 05-table-view, 06-table-bottom, 07-sorted-asc.
- Table headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate, Actions.
- Coverage: 400 of 1,013 posts checked individually, because the grid caps at 200 rendered rows per sort order. Posts ranked 201-813 were not individually inspected. The Sum row covers all 1,013 posts and balances exactly.

## Deviation
- Step 2 says "Add a Brand UCLA", but the dev brand search has no brand named exactly "UCLA". Rule 1 forbids substituting a lookalike brand, but this is not a lookalike: it is the UCLA account's own brand, University of California, Los Angeles, which is already the account default and matches the precondition "logged in UCLA account". The result does not change if that mapping is wrong: UCLA Bruins, UCLA Athletics and the other "UCLA …" brands are separate sub-brands that the spec does not name. Flagging in case the spec intended a different brand.

## Known bugs checked
- No linked bugs on the case (`cases/QA-29115.md`, as of 2026-10-20). `results/open-bugs-2026-10-26.json` has no entry, so none are open.
- `knowledge-base/bug-history.md` and `known-quirks.md` have no QA-29115 entry (pre-fetched). The Twitter Reactions + Comments + Shares ≠ Engagements bug (APPS-61116, QA-29111) is Twitter-specific and did not reproduce on LinkedIn.
- Console showed the usual dev noise (errors on the page), none affecting the table.

## Bugs filed
None. Markdown-only report, no Jira tickets created.

## Skill note (for harvest.sh)
Reused `brand-content-grid-math` (Table View scrape, 200-row cap, Sum row) with helpers from `skills/_shared/playwright-helpers/devprod-helpers.js`. New detail: the grid shows 200 rows per sort order, so sorting Engagements ascending exposes a second disjoint 200-post set.
