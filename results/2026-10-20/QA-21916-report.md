# QA-21916 — Brand Content > LFM vs Native > YouTube Channel

**Run date:** 2026-10-20 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no social-network login), dev `app.lfmdev.in`
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · Channel: YouTube only · Date range: default week (the app's default rolled to Oct. 13, 2026 – Oct. 19, 2026 during this run)
**Verdict: PASS — native YouTube watch page readable; Video Views 726 vs 751 (+3.4%), Likes 8 vs 8, Comments 1 vs 1**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand > Content, brand University of California, Los Angeles (account default) | ✅ |
| 3 | YouTube channel only → Apply | ✅ |
| 4 | First post (grid card #1) metrics | ✅ Wed Oct. 14, 2026 03:40 PM PDT "Going for Culinary Gold: UCLA Dining Prepares for the Olympics" — Video Views 726 · Likes 8 · Comments 1 |
| 5 | Click the post image (`.image-card .image-link`) → native tab | ✅ https://www.youtube.com/watch?v=SONXq3tU-yA — "751 views 5 days ago"; like button aria-label "like this video along with 8 other people"; `#comments #count` "1 Comment" |
| 6 | Compare | see assertions |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Video Views: no big variation vs native | 726 vs 751 (native +25, +3.4%; post still accruing) | ✅ PASS |
| A2 | Likes: no big variation vs native | 8 vs 8 | ✅ PASS |
| A3 | Comments: no big variation vs native | 1 vs 1 | ✅ PASS |

## Evidence
- Session result `ctx._native.ucla.youtube` (card text, LFM key-values, native URL/title/meta/body excerpt).

## Known bugs checked
- None open on the case.

## Bugs filed
None.

## Cleanup
Native tab closed.
