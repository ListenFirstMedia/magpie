# QA-21912 — Brand Content > LFM vs Native > Facebook Channel

**Run date:** 2026-10-20 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no social-network login), dev `app.lfmdev.in`
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · Channel: Facebook only · Date range: default week (the app's default rolled to Oct. 13, 2026 – Oct. 19, 2026 during this run)
**Verdict: PASS — native Facebook post page served logged-out (login banner, content behind); Reactions 742 vs 766 (+3.2%), Comments 34 vs 38, Shares 76 vs 77**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand > Content, brand University of California, Los Angeles (account default) | ✅ |
| 3 | Facebook channel only → Apply | ✅ |
| 4 | First post (grid card #1) metrics | ✅ Sat Oct. 17, 2026 07:00 AM PDT "UCLA alum Beatriz Porto has helped grow her family's Porto's Bakery…" — Engagements 852 · Reactions 742 · Comments 34 · Shares 76 |
| 5 | Click the post image (`.image-card .image-link`) → native tab | ✅ https://www.facebook.com/UCLA/posts/pfbid02psYGGz… — body text "All reactions: 766 | 38 comments | 77 shares" |
| 6 | Compare | see assertions |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Reactions: no big variation vs native | 742 vs 766 (+3.2%) | ✅ PASS |
| A2 | Comments: no big variation vs native | 34 vs 38 (+4 — includes replies on native) | ✅ PASS |
| A3 | Shares: no big variation vs native | 76 vs 77 | ✅ PASS |

## Evidence
- Session result `ctx._native.ucla.facebook` (card text, LFM key-values, native URL/title/meta/body excerpt).

## Known bugs checked
- None open on the case.
- First time the Facebook public post page rendered headless without a login wall (2026-10-20); treat as fragile.

## Bugs filed
None.

## Cleanup
Native tab closed.
