# QA-20527 — Brand Content > Data Test > UnPaid Posts

**Run date:** 2026-10-23 (Friday) · **Mode:** unattended, headless (`claude -p`, Playwright MCP) · **Env:** app.lfmdev.in
**Account:** HBO Max (657), reached via the profile menu account switcher (Results section, real click) · **Brand:** HBO Max (155614), exact "HBO Max" Result from the brand typeahead (Rule 1)
**Date range:** default week Oct. 15 – Oct. 21, 2026 · Mode Lifetime · Table View · Filter **Paid: Organic** (chip "Paid: Organic / Include", URL `content_is_paid` = `Unpaid`)
**Verdict: PASS (6/6). Every paid metric column shows the expected value on every organic post, across all six data sets.**

## Steps executed
1. Logged in with the Cognito email/password form from `config/.env` (lfiqa) and landed on `#home`. The user menu showed "LFQA", so I switched account to **HBO Max** through the profile menu account search (Results section). The breadcrumb then read "ACCOUNT: HBO MAX".
2. Hovered **Brand** in the top nav and clicked **Content**. The page opened on HBO Max (brand_id=155614). I then opened the brand picker and typed "HBO Max". The first Result was the exact "HBO Max", which I clicked. Typeahead searches take ~5 s to return Results.
3. Clicked `[title="Table View"]`. A visible `table.lfm-table` with a `Rank` header rendered, with Posts (183) across all default channels.
4. Opened the Filter dropdown, chose Paid, then Organic, then clicked Apply Filter. The chip "Paid: Organic Include" appeared. The post count stayed at 183 and the scrape found 0 `i.fa-dollar-sign[title="Paid post"]` icons, so the week has no paid posts at all.
5. Selected the **Engagements Breakdown** dataset. Channels auto-narrowed to Twitter and Instagram.
6. Selected **Impressions** (Twitter and Instagram).
7. Selected **Video Views** (Twitter and Instagram).
8. Selected **Facebook Only: Completed Video Views**. The spec calls this "Facebook only: Completed & Live Videos", but the dev dropdown has no option with that label. This is the only Facebook-only completed-views dataset, and it matches the 2026-10-19 run. Channels narrowed to Facebook.
9. Selected **Twitter Only: Engagements & Follows** (Twitter).
10. Selected **Instagram Only: Insights** (Instagram).

After each dataset change I waited for `Posts (N)`, confirmed the filter was still in the URL, and scraped every rendered row of Table View through the DOM.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 | Paid Engagements, Paid Reactions, Paid Comments, Paid Shares show "–" | 65 posts (TW+IG). All four columns are "–" on 65/65 rows, and the aggregate Sum row is also "–" in all four. | PASS |
| A6 | 6 | Paid Impressions and Paid Reach show "–" or 0 | 65 posts (TW+IG). Paid Impressions is "–" on 65/65 and Paid Reach is "–" on 65/65. | PASS |
| A7 | 7 | Paid Views shows "–" or 0 | 57 posts (TW+IG). Paid Views is "–" on 57/57. | PASS |
| A8 | 8 | Paid Completed Views shows 0 | 25 posts (FB). Paid Completed Views is "0" on 25/25, and every Completed Views total is populated. No "–" and no non-zero value. | PASS |
| A9 | 9 | Paid Follows ("Paid User Follows") shows "–" | 24 posts (TW). Paid User Follows is "–" on 24/24. | PASS |
| A10 | 10 | Paid Saves shows "–" | 41 posts (IG). Paid Saves is "–" on 41/41. | PASS |

## Evidence
Screenshots are in `.playwright-out/QA-20527/`:
- `02-content-hbomax.png`, `03-brand-picker.png`: HBO Max brand and the brand picker.
- `04-table-view.png`: Table View.
- `05-filter-selected.png`, `06-filter-applied.png`, `06b-filter-applied.png`: the Paid: Organic filter applied.
- `07-engagements-breakdown.png`, `08-impressions.png`, `08-videoviews.png`, `09-fb-completed.png`, `10-tw.png`, `10-ig.png`: one per dataset.

Counts come from the DOM scrape of `table.lfm-table tbody tr`.

## Known bugs checked
- The case file says "None open (as of 2026-10-19)", so the Rule 7 screen passed.
- The pre-fetched `bug-history.md` and `known-quirks.md` greps for QA-20527 found nothing.
- The 2026-10-19 run recorded closed bugs APPS-30184, APPS-32139, DATA-9890 and DATA-12253. None reproduced.
- The "Facebook Data Collection Disruption 9/27" banner was visible but did not affect these assertions. The Facebook dataset showed "0" on all 25 posts.

## Bugs filed
None. This is a markdown-only report, and no Jira tickets were created.

## Cleanup / notes
- I cleared the filter with "Clear All" after the run.
- The brand-picker search is a `textarea[placeholder="Search for a Brand"]`, not an input. A first `browser_type` after a `pressSequentially` doubled the text ("HBO MaxHBO Max") and returned no Results. Selecting all, deleting, and retyping once fixed it.
- The profile menu must be hovered ("LFQA" at top right) before `.account-switcher` becomes visible.
- No skill or REGISTRY maintenance was done, as instructed (deferred to harvest.sh).
