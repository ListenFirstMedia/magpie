# QA-121304 — Brand > Content - Instagram Collaborator Name Filtering

**Run date:** 2026-07-08
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Skill used:** [brand-content-filter](../../skills/brand-content-filter/SKILL.md) v2 (2026-06-11 Collaborator Name addendum — same exact ticket, flow reused almost verbatim)
**Account:** Amazon Prime Video (account_id=342), brand = Amazon Prime Video (brand_id=25864)
**Precondition match:** Spec says "logged in as Amazon Prime Video" — switched via profile menu → Search Account → Results row (Rule 1). Brand also exact match "Amazon Prime Video."

## Steps executed

1. Navigated to Brand > Content for Amazon Prime Video.
2. Confirmed brand dropdown already reads exact "Amazon Prime Video."
3. Set Date Range to Sep. 10, 2025 - Sep. 16, 2025 (confirmed via on-screen Date Range pill after navigation).
4. Clicked Filter dropdown (`[data-ui-name="content_select_filter_cta"]`) → **captured full filter-type list before selecting**: `Branded Content, Collaborated, Collaborated Total, Collaborator Name, Content Type, Live Stream, Paid, Publish Day, Publish Time, Publish Type, Sponsor Name, Tag, Text Search`.
5. Clicked "Collaborator Name" → child sub-panel opened with a values list (already alphabetical, underscore-prefixed entries first: `_harrietslater, amazonmgmstudios, cultureratedpv, itsdeborah, jacobscipio, jamie.roy_, lazofficial, livkatecooke, madelame, markwahlberg, nba, nbaonprime, nfl, nflonprime, outlander_starz, primemovies, primerolatino, sportsonprime, theofficialai3, theofficialcakid` — 20 unique names, no duplicates).
6. Clicked `amazonmgmstudios` (floated to top of the list, confirming selection) → clicked "Apply Filter" (`[data-ui-name="apply_filter_cta"]`). URL updated with `filters={"content_collaborator_names":{"operator":"or","values":["amazonmgmstudios"],"not":"false"}}` — matches the documented v2 encoding exactly.
7. Observed the filter pill (`Collaborator Name: amazonmgmstudios`) and Posts header count + table.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5a | Collaborator Name filter appears after Collaborated Total filter | Filter-type list order: `…, Collaborated, Collaborated Total, Collaborator Name, Content Type, …` — Collaborator Name immediately follows Collaborated Total | PASS |
| A2 | 5b | Collaborator names appear only once, alphabetical order | 20-item list, each name unique, alphabetically sorted (underscore-prefixed `_harrietslater` first per ASCII ordering) | PASS |
| A3 | 8a | Posts header count updates | Pre-filter (Sep 10-16 2025, all channels): `Posts (175)`. Post-filter: `Posts (3)` | PASS |
| A4 | 8b | Only Collaborated posts in table | All 3 rows carry the `label-blob lfm.content.is_collaborated` badge (`(3)`, `(2)`, `(2)` collaborator counts) | PASS |
| A5 | 8c | All posts contain collaborator `amazonmgmstudios` in selected date range | Verified via the underlying `/content` API response (`browser_network_request`): all 3 records' `lfm.content.collaborator_name` arrays include `"amazonmgmstudios"`; `published_at` timestamps (1758034891, 1757537515, 1758036598) all decode to Sep 10-16, 2025 inclusive | PASS |

**Result: PASS 5/5**

## Evidence

- Screenshot: `.playwright-out/qa121304-00-content-loaded.png` (pre-filter state, Amazon Prime Video, Posts still loading)
- Screenshot: `.playwright-out/qa121304-01-date-range-set.png` (Date Range confirmed "Sep. 10, 2025 - Sep. 16, 2025")
- Network response (request #453, 200 OK): 3 records, each with `"lfm.content.collaborator_name":["amazonmgmstudios", ...]` and text: "Consider the engines revved…", "Choose very wisely. The Girlfriend is now streaming.", "May the best shop win…"
- Filter pill text: `Collaborator Name: amazonmgmstudios`
- Final `Posts (3)` header with Sum/Average row: Engagements Sum 240,949 / Video Views Sum 8,245,462

## Findings — backend reliability (documented, not filed as a functional bug)

**Intermittent `BiQuerier::Error::Timeout` (HTTP 500) on the `/content` posts-list endpoint when the Collaborator Name filter is applied.** After clicking Apply Filter, the posts table showed "This table failed to load. Please try again." Inspected via `browser_network_request`:
- 1st attempt: `GET data-api.lfmdev.in/content?...content_collaborator_names...` → **500**, `x-runtime: 39.27s`, body `{"error_type":"BiQuerier::Error::Timeout","error":"Request has timed out", ...}` (Ruby stack trace in `bi_querier/sql_builder/query_builder.rb`).
- 2nd attempt (Reload): same **500** timeout again.
- 3rd attempt (Reload): **200 OK**, data loaded correctly with all 3 posts as expected.

The unfiltered query (no collaborator filter) for the same brand/date/channel scope succeeded on the first try (`Posts (175)`), so the timeout is specific to the collaborator-name-filtered query path (likely a warehouse-side query-plan cost for the `content_collaborator_names` filter clause). This is a backend performance/reliability issue, not an automation artifact — the error body is a genuine server stack trace, not a client-side timeout. Recommend product/eng review of `BiQuerier` query cost for `content_collaborator_names` filters; retry-until-success masked it here but a real user would see two consecutive failures before a manual reload succeeds.

## Cleanup

None required — read-only test (filter application is transient page state).

## Bugs filed

None (documented as a backend reliability finding above per Rule 5 — data ultimately loaded correctly and all assertions evaluate against the correct, complete dataset; recommend a human/product decision on whether to file this timeout as a ticket).
