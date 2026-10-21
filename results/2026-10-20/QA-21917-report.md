# QA-21917 — Brand Content > LFM vs Native > LinkedIn Channel

**Run date:** 2026-10-20 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no social-network login), dev `app.lfmdev.in`
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · Channel: LinkedIn only · Date range: default week (the app's default rolled to Oct. 13, 2026 – Oct. 19, 2026 during this run)
**Verdict: PASS — native LinkedIn post page served (Sign in / Join now header, no authwall); Reactions 668 vs 694 (+3.9%), Comments 12 vs 12**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand > Content, brand University of California, Los Angeles (account default) | ✅ |
| 3 | LinkedIn channel only → Apply | ✅ |
| 4 | First post (grid card #1) metrics | ✅ Wed Oct. 14, 2026 09:14 AM PDT video "Integrity, excellence, and belonging. The values we live by. #TrueBruinValues" — Engagements 722 · Reactions 668 · Comments 12 · Shares 42 |
| 5 | Click the post image (`.image-card .image-link`) → native tab | ✅ https://www.linkedin.com/feed/update/urn:li:ugcPost:7516169500598149120/ — title "#truebruinvalues | UCLA | 12 comments"; body "694 | 12 Comments" |
| 6 | Compare | see assertions |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Reactions: no big variation vs native | 668 vs 694 (+3.9%) | ✅ PASS |
| A2 | Comments: no big variation vs native | 12 vs 12 | ✅ PASS |

## Evidence
- Session result `ctx._native.ucla.linkedin` (card text, LFM key-values, native URL/title/meta/body excerpt).

## Known bugs checked
- None open on the case.
- Same ~4% native-higher drift as QA-22108 yesterday (post keeps accruing after the LFM stats window).

## Bugs filed
None.

## Cleanup
Native tab closed.
