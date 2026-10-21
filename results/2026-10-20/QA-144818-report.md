# QA-144818 — Settings > Data Collection - Last Collection Date Reconciles with Collected Content (APPS-61562)

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com`, both logged in as lfiqa and switched to **Apple Services**
**Account:** Apple Services (account_id=409 on both) · **Brand:** Apple Music (brand_id=31783) · Channel: Instagram · Date range: default week Oct. 12, 2026 – Oct. 18, 2026
**Verdict: PASS — Last Collection Date Oct 19, 2026 on the Instagram Posts feeds (Authorized and Public) on BOTH environments; most recent Instagram post on Brand > Content is Fri Oct 16, 2026 on BOTH environments; collection date is not earlier than the newest post; Dev and Prod identical. Brand > Insights leg not executed (see note).**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Settings → Data Collection (both tabs) | ✅ `#data-collection?account_id=409`, "My Brands (162)" |
| 2 | Search "Apple Music" in the brand typeahead and select it | ✅ option list (Apple Music, Apple Music (Japan), (LATAM), NFL Players, Classical…) → dispatched click on "Apple Music" → URL `#data-collection/apple%20music`, brand row active; Channels (9) |
| 3 | Channel column → Instagram → page `applemusic` | ✅ Data Collection Summary "Attributed to Apple Music Jan 3, 2000 - Dec 31, 2027" |
| 4 | Note Last Collection Date | ✅ Dev: Instagram Earned Comments (Authorized) Oct 19, 2026 · Page & Audience (Authorized) Oct 18, 2026 · **Instagram Posts (Authorized) Oct 19, 2026** · Page (Public) Oct 19, 2026 · **Instagram Posts (Public) Oct 19, 2026** — all "Collecting". Prod: identical values |
| 5 | Brand > Content → Apple Music → Instagram only → Table View | ✅ 15 posts (Oct 12–18 week) on Dev and on Prod |
| 6 | Publish date of the most recent post | ✅ Dev **Fri Oct. 16, 2026 12:00 PM PDT** · Prod **Fri Oct. 16, 2026 12:00 PM PDT** (oldest in window Mon Oct. 12, 2026 12:25 AM PDT on both) |
| 7 | Repeat on Prod and compare | ✅ every value above identical on Prod |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Last Collection Date populated, not a placeholder/null | Oct 19, 2026 (Posts Authorized + Public), Oct 18, 2026 (Page & Audience) — real dates, status Collecting, on both environments | ✅ PASS |
| A6a | Last Collection Date ≥ publish date of the most recent post on Brand > Content | Oct 19, 2026 ≥ Oct 16, 2026 on Dev; same on Prod | ✅ PASS |
| A6b | Same reconciliation holds on Brand > Insights | **Not executed** — Brand > Insights is deliberately kept out of this scripted run (it hung the headless browser twice on 2026-10-19 and would have taken both environment tabs down). Content-side reconciliation stands; Insights uses the same date window and the same collected posts | ⚠️ NOT RUN |
| A7 | Behaviour consistent between Dev and Prod | Identical feeds, identical dates, identical newest post | ✅ PASS |

## Evidence
- Data Collection feed table text and the Content scrape summary (15 posts, newest/oldest dates) for both environments are in the session result dump `results/2026-10-20/_devprod-results.json` is the Dev-vs-Prod dump; this case's raw values are reproduced in the Steps table above.

## Known bugs checked
- None open on the case. The original APPS-61562 defect (Dev-only wrong Last Collection Date) did **not** reproduce: Dev and Prod show the same dates.

## Bugs filed
None.

## Cleanup
None (read-only on both environments).
