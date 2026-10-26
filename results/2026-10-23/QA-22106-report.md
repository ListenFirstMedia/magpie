# QA-22106 — Brand Content > LFM vs Native > Instagram Channel

**Run date:** 2026-10-23 (Friday → rotation row: account **Hulu**, brand **Hulu**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no Instagram login), dev `app.lfmdev.in`
**Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670) · Channel: Instagram only · Date range: Jan. 01, 2024 – Dec. 31, 2024 · Data set: Public
**Verdict: FAIL — open linked bug LFMP-32113 (Open) ⇒ FAILED per policy; execution also fails: first post (reel C1vZ-ojRu7x, Fri Jan 5 2024, Gypsy Rose Blanchard) LFM Reactions 1,063,050 vs native 949K likes (−11%), Comments 12,151 vs native 6,751 (−44%) — native lower than LFM, the LFMP-32113 pattern**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand > Content → Hulu → date range Jan 01 – Dec 31 2024 | ✅ `from=2024-01-01&to=2024-12-31` |
| 3 | Instagram only → Apply | ✅ grid rendered (200 cards loaded) |
| 4 | First post metrics (grid card) | ✅ Fri Jan 05, 2024 reel — Engagements 1,075,201 · Reactions 1,063,050 · Comments 12,151 · Response Rate 55.80% · Video Views 31,238,034 |
| 5 | Click image → native tab | ✅ https://www.instagram.com/reel/C1vZ-ojRu7x/ (logged-out view; login prompt overlay) |
| 6 | Note native Likes | ✅ `<meta name=description>`: "949K likes, 6,751 comments - hulu on January 5, 2024" |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A6 | LFM Reactions ≈ native Likes (no big variation) | 1,063,050 vs ≈949,000 (−11%); comments 12,151 vs 6,751 (−44%) | ❌ FAIL (LFMP-32113 pattern) |

## Evidence
- Session result `ctx._nat.q22106` (card text, LFM metrics, native meta description).

## Known bugs checked
- **LFMP-32113 (Open)** "native data is lower than LFM" — reproduced in direction (native lower) on a 2024 post; case FAILED per the open-bug policy regardless.

## Bugs filed
None (existing bug).

## Cleanup
Native tab closed.
