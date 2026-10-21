# QA-90072 — Brand Content > Reels Data Set - LFM vs Native

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no Instagram login), dev `app.lfmdev.in`
**Account:** Amazon Prime Video (account_id=342) · **Brand:** Amazon Prime Video · Data set: Reels · Channel: Instagram · Date range: default week Oct. 12, 2026 – Oct. 18, 2026
**Verdict: PASS — first reel: LFM Reactions 293,853 vs native 297K likes (+1.1%, abbreviated), Comments 809 vs 814 (+0.6%); Shares 32,105 have no public native counterpart**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Content → Amazon Prime Video → data set **Reels** | ✅ `table_data_set` Reels, Posts (44) Instagram |
| 4 | First post Reel Reactions / Comments / Shares | ✅ Sat Oct. 17, 2026 08:00 AM PDT reel "A speech worth remembering" — Engagements 294,662 · Reactions 293,853 · Comments 809 · Shares 32,105 · Reach 7,646,674 · Plays – |
| 5 | Click the video → native tab | ✅ https://www.instagram.com/reel/DemRTgmlHch/ |
| 6 | Native Reel Likes / Comments / Shares | ✅ `<meta name=description>`: "297K likes, 814 comments - primevideo on October 17, 2026"; shares are not exposed on the logged-out page |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Reel Reactions ≈ native likes | 293,853 vs ≈297,000 (abbreviated "297K", +1.1%) | ✅ PASS |
| A2 | Reel Comments ≈ native comments | 809 vs 814 | ✅ PASS |
| A3 | Reel Shares ≈ native shares | native share count not public logged-out | ⚠️ not evaluable (platform) |

## Evidence
- Session result `ctx._native.reels.reels`.

## Known bugs checked
- None open on the case.

## Bugs filed
None.

## Cleanup
Native tab closed.
