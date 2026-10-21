# QA-21913 — Brand Content > LFM vs Native > Twitter Channel

**Run date:** 2026-10-20 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no social-network login), dev `app.lfmdev.in`
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · Channel: Twitter only · Date range: default week (the app's default rolled to Oct. 13, 2026 – Oct. 19, 2026 during this run)
**Verdict: BLOCKED — X/Twitter returns HTTP 403 "Access to x.com was denied" to the headless browser (bot wall), native values unreadable — same as QA-22105**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand > Content, brand University of California, Los Angeles (account default) | ✅ |
| 3 | Twitter channel only → Apply | ✅ |
| 4 | First post (grid card #1) metrics | ✅ Thu Oct. 15, 2026 04:00 PM PDT "UCLA women's basketball coach Cori Close was awarded…" — Engagements 77 · Reactions 71 · Comments 1 · Shares 5 · Response Rate 0.03% |
| 5 | Click the post image (`.image-card .image-link`) → native tab | ✅ popup URL chrome-error://chromewebdata/, title "x.com", body "Access to x.com was denied | HTTP ERROR 403" |
| 6 | Compare | see assertions |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Reactions / Comments / Shares vs native: no big variation vs native | native page not served (403) | ⛔ BLOCKED (native access) |

## Evidence
- Session result `ctx._native.ucla.twitter` (card text, LFM key-values, native URL/title/meta/body excerpt).

## Known bugs checked
- LFMP-32113 (Open) — not evaluable, see note.
- LFMP-32113 (Open, native lower than LFM on past dates) could not be checked. Needs a logged-in X session or a data-API path.

## Bugs filed
None.

## Cleanup
Native tab closed.
