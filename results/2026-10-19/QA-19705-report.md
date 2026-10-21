# QA-19705 — Brand Content - Twitter Only: Engagements & Follows DataSet - Current Date Range Data Test

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** current default week Oct. 11 – Oct. 17, 2026 · **Channel:** Twitter only · **Data set:** Twitter Only: Engagements & Follows
**Verdict: FAIL — known open bug LFMP-32088: User Follows / Organic User Follows / Paid User Follows render "–" on all 23 posts and on the Sum row, so the identity has no data to evaluate**

## Steps
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand>Content, HBO Max, Twitter only, Data Set = Twitter Only: Engagements & Follows | ✅ Posts (23); columns Engagements, Likes, Replies, Retweets, Quotes, Bookmarks, Views, User Follows, Organic User Follows, Paid User Follows |
| 4 | Table View; all 23 rows scraped | ✅ (other Twitter metrics populate: Likes 78,581 / Retweets 7,328 / Views 15,884,742 on the Sum row) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Organic User Follows + Paid User Follows = User Follows | All three columns are "–" for 23/23 posts and for the Sum row — no User Follows data at all | ❌ FAIL — attributed to **LFMP-32088** (Open) "Twitter Only: Engagements & Follows, User follows data is not available" (reported on Apple Services, reproduces on HBO Max) |

## Evidence
`.playwright-out/QA-19705/01-tw-follows-table.png`

## Known bugs checked
- LFMP-32088 (Open) — **reproduces**; it is the cause of the failure (bug confirmed still present, not a new defect).
- APPS-60871 (Open, en-dash across datasets on Amazon Prime Video) — same symptom family.

## Bugs filed
None (existing LFMP-32088 covers it). · **Cleanup:** none.
