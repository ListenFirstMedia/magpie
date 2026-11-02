# QA-144818 — Settings > Data Collection - Last Collection Date Reconciles with Collected Posts

**Run date:** 2026-10-27 (Tuesday) — case is fixed to Apple Services / Apple Music / Instagram (regression for APPS-61562)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com` in the same browser context, both logged in with the lfiqa user
**Account:** Apple Services (account_id=409) · **Brand:** Apple Music (brand_id=31783) · Channel: Instagram · Date range: default week Oct. 19, 2026 – Oct. 25, 2026
**Verdict: PASS — Last Collection Date Oct 26, 2026 on the Instagram Posts feeds (Authorized and Public) on BOTH environments; most recent Instagram post on Brand > Content is Sat Oct 24, 2026 11:10 AM PDT on BOTH environments; collection date ≥ newest post, Dev and Prod identical**

## Steps executed
| # | Step | Result (dev) | Result (prod) |
|---|------|--------------|---------------|
| 1 | Settings → Data Collection | ✅ `#data-collection?account_id=409` | ✅ same |
| 2 | Search "Apple Music" → select (typeahead option needs a dispatched click) | ✅ page row `applemusic` | ✅ same |
| 3 | Channel → Instagram | ✅ 5 feeds | ✅ 5 feeds |
| 4 | Data Collection Summary → Last Collection Date | ✅ Earned Comments (Auth) Oct 26 · Page & Audience (Auth) Oct 25 · **Posts (Auth) Oct 26** · Page (Public) Oct 26 · **Posts (Public) Oct 26**; all "Collecting" | ✅ identical values and statuses |
| 5–6 | Brand > Content → Apple Music → Instagram only → newest publish date | ✅ Posts (23); newest Sat Oct 24, 2026 11:10 AM PDT (then Oct 24 11:30 AM, Oct 23 07:00 AM) | ✅ Posts (23); same three dates |
| 7 | Compare Dev vs Prod | ✅ identical | — |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Last Collection Date populated, not a placeholder | Oct 26, 2026 on both Posts feeds (dev and prod) | ✅ PASS |
| A6a | Last Collection Date ≥ publish date of the most recent Brand > Content post | Oct 26, 2026 ≥ Oct 24, 2026 (dev and prod) | ✅ PASS |
| A6b | Same reconciliation on Brand > Insights | Not separately exercised (same brand/channel/range; Insights reads the same collected posts) | ℹ️ not evaluated |
| A7 | Dev and Prod consistent | Feed dates, statuses and newest post identical | ✅ PASS |

## Evidence
- Session results `ctx._dc.dev` / `ctx._dc.prod` (feed rows, summary text, Content dates).

## Known bugs checked
- None open on QA-144818 (APPS-61562 is the fixed defect this case guards).

## Bugs filed
None.

## Cleanup
None (read-only).
