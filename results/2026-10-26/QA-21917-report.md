# QA-21917 — Brand Content > LFM vs Native > LinkedIn Channel

**Run date:** 2026-10-26 (Monday) — case is fixed to UCLA / University of California, Los Angeles
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no LinkedIn login), dev `app.lfmdev.in`
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · Channel: LinkedIn only · Date range: default week Oct. 18, 2026 – Oct. 24, 2026 · Data set: Public
**Verdict: FAIL — first post (Sat Oct 24 2026, "One more reason to linger on campus a little longer"): LFM Reactions 853 vs native 1,120 (+31%), Comments 11 vs native 18 (+64%). The post is ~1 day old and LFM "Data Last Updated" is 10-25; the native page is still accruing, but the gap exceeds any reasonable "no big variation" reading at the time of the check**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Switch account → UCLA (LFIQA menu), Brand > Content | ✅ `account_id=799`, brand University of California, Los Angeles |
| 2–3 | Public data set, LinkedIn only → Apply | ✅ Posts (32) |
| 4 | First post metrics (grid card, sorted by Engagements) | ✅ Engagements 882 · Reactions 853 · Comments 11 · Shares 18 · Response Rate 0.09% |
| 5 | Click image → native tab | ✅ https://www.linkedin.com/feed/update/urn:li:share:7519833185157910528/ (public view, no authwall) |
| 6 | Note native Likes / Comments | ✅ reaction count **1,120**, "**18** Comments" (page title "… \| UCLA \| 18 comments") |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A6 | LFM Reactions/Comments ≈ native (no big variation) | 853 vs 1,120 (+31%); 11 vs 18 (+64%) | ❌ FAIL (freshness: 1-day-old post, LFM last collected 10-25; native keeps growing) |

## Evidence
- Session result `ctx._nat.q21917` (card text, LFM metrics, native body text "1,120 | 18 Comments").
- Same brand/channel on 2026-10-20 (older first post): 668 vs 694 (+3.9%) — the gap is age-dependent, consistent with a collection lag rather than a parsing error.

## Known bugs checked
- None linked to QA-21917. LFMP-32113 (native LOWER than LFM) is the opposite direction; here native is higher.

## Bugs filed
None — recommend re-checking the same post after the next collection; if LFM catches up to ≈1,120 it is lag, not loss.

## Cleanup
Native tab closed.
