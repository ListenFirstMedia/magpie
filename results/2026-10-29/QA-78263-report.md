# QA-78263 — Brand Content > LFM vs Native > Instagram Reels

**Run date:** 2026-10-29 (Thursday) — case is fixed to Hulu / Hulu
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no Instagram login), dev `app.lfmdev.in`
**Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670) · Channel: Instagram only · Filter: Publish Type = Reel · Date range: default week Oct. 21, 2026 – Oct. 27, 2026 · Data set: Public
**Verdict: FAIL — the unpaid reel matches native (LFM Reactions 71,271 vs native 72K likes, Comments 187 vs 187), but the top paid reel (Thu Oct 22, "Do you spot the differences? … #PHONY", https://www.instagram.com/reel/Dezy5atESyG/) shows LFM Reactions 11,326 / Comments 135 against native 3,656 likes / 48 comments (LFM 3.1× / 2.8× higher). A second paid reel (DezemAMlW8R, "#TheDropout") shows the same shape: LFM 10,652 / 200 vs native 6,166 / 144. Only the small paid reel DezJvzCARPw matches (372 / 14 vs 363 / 14)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Content → Hulu → Instagram only | ✅ Posts (49) |
| 4–5 | Filter → Publish Type → **Reel** → Apply | ✅ Posts (36) |
| 5 | Identify paid vs unpaid (Table View, Paid column `<i title="Paid post">`) | ✅ unpaid = rank 1, paid reels at ranks 10, 12, 33 |
| 5 | LFM values | ✅ unpaid (rank 1): Engagements 71,458 · Reactions 71,271 · Comments 187 · Video Views 1,056,070 · paid (rank 10): Engagements 11,461 · Reactions 11,326 · Comments 135 · Video Views 12,970,845 · paid (rank 12): Reactions 10,652 · Comments 200 · Video Views 2,237,856 · paid (rank 33): Reactions 372 · Comments 14 · Video Views 125,456 |
| 6–7 | Click image → native tab, read `<meta name=description>` | ✅ unpaid https://www.instagram.com/reel/DezeSZfCk4e/ "72K likes, 187 comments" · paid https://www.instagram.com/reel/Dezy5atESyG/ "3,656 likes, 48 comments" · paid https://www.instagram.com/reel/DezemAMlW8R/ "6,166 likes, 144 comments" · paid https://www.instagram.com/reel/DezJvzCARPw/ "363 likes, 14 comments" |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7 (unpaid) | LFM Reactions/Comments ≈ native | 71,271 vs ≈72,000 · 187 vs 187 | ✅ |
| A7 (paid) | LFM Reactions/Comments ≈ native | Dezy5atESyG: 11,326 vs 3,656 (+210%) · 135 vs 48 (+181%); DezemAMlW8R: 10,652 vs 6,166 (+73%) · 200 vs 144 (+39%); DezJvzCARPw: 372 vs 363 · 14 vs 14 | ❌ FAIL |

Shares are not exposed on the logged-out native page.

## Evidence
- Session result `ctx._nat.q78263` (+ `extraPaid` for the two additional paid reels).
- The two mismatching reels both have very high Video Views relative to their organic likes (12.97M and 2.24M views), i.e. they are being promoted; the LFM figures look like organic + ad-variant interactions while the public reel page shows the organic post only. Yesterday's paid reel (Deu7w6lFQYA) matched native, so this is not every paid reel — it depends on whether the promotion runs as a separate ad instance.
- Not the LFMP-32113 direction (there native was higher than LFM); here LFM is higher.

## Known bugs checked
- None open on QA-78263. Recommend raising with data engineering: Instagram paid reel public metrics include promoted-instance likes/comments that the native permalink does not show.

## Bugs filed
None (needs triage to confirm whether the paid-instance roll-up is intended).

## Cleanup
Native tabs closed.
