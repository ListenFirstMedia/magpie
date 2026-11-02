# QA-21917 — Brand Content > LFM vs Native > LinkedIn Channel

**Run date:** 2026-10-29 (Thursday) — case is fixed to UCLA / University of California, Los Angeles
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no LinkedIn login), dev `app.lfmdev.in`
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · Channel: LinkedIn only · Date range: default week Oct. 21, 2026 – Oct. 27, 2026 · Data set: Public
**Verdict: PASS — first post (Sat Oct 24 2026, "One more reason to linger on campus a little longer"): LFM Reactions 1,572 vs native 1,669 (+6.2%), Comments 20 vs native 21. Fourth day on the same post: +31% (10-26) → +12% → +7% → +6% as collection keeps pace with a post that is still accruing; no big variation**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Account UCLA, Brand > Content | ✅ `account_id=799`, brand University of California, Los Angeles |
| 2–3 | Public data set, LinkedIn only → Apply | ✅ Posts (30) |
| 4 | First post metrics (grid card, sorted by Engagements) | ✅ Engagements 1,624 · Reactions 1,572 · Comments 20 · Shares 32 · Response Rate 0.16% |
| 5 | Click image → native tab | ✅ https://www.linkedin.com/feed/update/urn:li:share:7519833185157910528/ (public view) |
| 6 | Note native Likes / Comments | ✅ reaction count **1,669**, "**21** Comments" |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A6 | LFM Reactions/Comments ≈ native (no big variation) | 1,572 vs 1,669 (+6.2%); 20 vs 21 | ✅ PASS (within the ±10% band used for live posts; comments off by 1) |

## Evidence
- Session result `ctx._nat.q21917`. Trend: 10-26 853/1,120 → 10-27 1,229/1,371 → 10-28 1,421/1,521 → 10-29 1,572/1,669 (LFM / native).

## Known bugs checked
- None linked to QA-21917.

## Bugs filed
None — the earlier two FAILs on this post were collection lag on a fresh post, now resolved.

## Cleanup
Native tab closed.
