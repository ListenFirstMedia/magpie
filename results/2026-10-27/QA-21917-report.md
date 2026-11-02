# QA-21917 — Brand Content > LFM vs Native > LinkedIn Channel

**Run date:** 2026-10-27 (Tuesday) — case is fixed to UCLA / University of California, Los Angeles
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no LinkedIn login), dev `app.lfmdev.in`
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · Channel: LinkedIn only · Date range: default week Oct. 19, 2026 – Oct. 25, 2026 · Data set: Public
**Verdict: FAIL — first post (Sat Oct 24 2026, "One more reason to linger on campus a little longer"): LFM Reactions 1,229 vs native 1,371 (+11.6%), Comments 19 vs native 19. Same post as 2026-10-26, when it read 853 vs 1,120 (+31%): LFM caught up by 376 reactions in one collection while the native count grew by 251, so the gap is a collection-freshness lag that is closing, but it is still above a "no big variation" reading on the primary metric**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Account UCLA, Brand > Content | ✅ `account_id=799`, brand University of California, Los Angeles |
| 2–3 | Public data set, LinkedIn only → Apply | ✅ Posts (32) |
| 4 | First post metrics (grid card, sorted by Engagements) | ✅ Engagements 1,270 · Reactions 1,229 · Comments 19 · Shares 22 · Response Rate 0.12% |
| 5 | Click image → native tab | ✅ https://www.linkedin.com/feed/update/urn:li:share:7519833185157910528/ (public view) |
| 6 | Note native Likes / Comments | ✅ reaction count **1,371**, "**19** Comments" |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A6 | LFM Reactions/Comments ≈ native (no big variation) | 1,229 vs 1,371 (+11.6%); 19 vs 19 | ❌ FAIL (comments exact; reactions lag one collection behind a still-growing post) |

## Evidence
- Session result `ctx._nat.q21917`. Trend for this post: 10-26 LFM 853 / native 1,120 → 10-27 LFM 1,229 / native 1,371.

## Known bugs checked
- None linked to QA-21917.

## Bugs filed
None — recommend the Data team confirm the LinkedIn reaction refresh cadence for posts < 3 days old; the comments count is exact, so parsing is correct.

## Cleanup
Native tab closed.
