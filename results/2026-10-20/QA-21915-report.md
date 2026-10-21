# QA-21915 — Brand Content > LFM vs Native > Instagram Channel

**Run date:** 2026-10-20 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no social-network login), dev `app.lfmdev.in`
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · Channel: Instagram only · Date range: default week (the app's default rolled to Oct. 13, 2026 – Oct. 19, 2026 during this run)
**Verdict: PASS — native Instagram post readable logged-out; LFM Reactions 2,132 vs native 2,147 likes (+0.7%), Comments 13 vs 13**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand > Content, brand University of California, Los Angeles (account default) | ✅ |
| 3 | Instagram channel only → Apply | ✅ |
| 4 | First post (grid card #1) metrics | ✅ Fri Oct. 16, 2026 04:12 PM PDT gallery "Excellence is driven by those who think boldly…" — Engagements 2,145 · Reactions 2,132 · Comments 13 · Response Rate 0.39% |
| 5 | Click the post image (`.image-card .image-link`) → native tab | ✅ https://www.instagram.com/p/Dekr3oAFyF_/ — `<meta name=description>`: "2,147 likes, 13 comments - ucla on October 16, 2026" |
| 6 | Compare | see assertions |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Reactions vs likes: no big variation vs native | 2,132 vs 2,147 (native +15, +0.7%) | ✅ PASS |
| A2 | Comments: no big variation vs native | 13 vs 13 | ✅ PASS |

## Evidence
- Session result `ctx._native.ucla.instagram` (card text, LFM key-values, native URL/title/meta/body excerpt).

## Known bugs checked
- None open on the case.
- Instagram serves the exact count in the meta description for this post (abbreviated "K" counts appear only on very large posts).

## Bugs filed
None.

## Cleanup
Native tab closed.
