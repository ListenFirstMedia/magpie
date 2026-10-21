# QA-81509 — Listening Analysis > LFM vs Native

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`)
**Account:** Robinhood (precondition) · Surface: Listening → Search term "#Robinhood", Last 7 Days, Search Twitter → Load Tweets → View Now → first post image → native X post
**Verdict: BLOCKED — the assertion compares LFM tweet metrics with the native X post, and x.com returns HTTP 403 ("Access to x.com was denied") to the headless browser on every attempt today (QA-21913, QA-22105); the Listening steps were not executed because the only assertion is the native comparison**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–7 | Listening search, Load Tweets, View Now, open first post | ⏭️ not executed (see verdict) |
| 8 | Compare Engagements, Likes, Comments, Retweets, Bookmarks with native | ⛔ native X page not readable headless (403 bot wall) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A8 | LFM values close to native values | native unavailable | ⛔ BLOCKED (native access) |

## Known bugs checked
- None open on the case.

## Notes
- Needs a logged-in X session (cookie jar) or an X data-API read to automate; the Listening surface itself (search/Load Tweets) is scriptable and can be covered separately once a native path exists.

## Bugs filed
None.

## Cleanup
None.
