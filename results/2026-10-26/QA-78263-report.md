# QA-78263 — Brand Content > LFM vs Native > Instagram Reels

**Run date:** 2026-10-26 (Monday) — case is fixed to Hulu / Hulu
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no Instagram login), dev `app.lfmdev.in`
**Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670) · Channel: Instagram only · Filter: Publish Type = Reel · Date range: default week Oct. 18, 2026 – Oct. 24, 2026 · Data set: Public
**Verdict: PASS — unpaid reel (Mon Oct 19, "The OG yearner. Now streaming: #OnceUponATime"): LFM Reactions 102,336 vs native 103K likes (+0.6%), Comments 622 vs 627; paid reel (Tue Oct 20, "This is why you do not talk to strangers. #OMITB"): LFM Reactions 65,213 vs native 66K likes (+1.2%), Comments 341 vs 343. Shares are not exposed on the logged-out native page ("–" in LFM too)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Content → Hulu → Instagram only | ✅ Posts (50) |
| 4–5 | Filter → Publish Type → **Reel** → Apply | ✅ Posts (39), URL `filters={"content_post_class":{"values":["reel"]}}` |
| 5 | Identify paid vs unpaid (Table View, Paid column `<i title="Paid post" class="fa-dollar-sign">`) | ✅ rank 1 unpaid, rank 2 paid (8 of 39 reels flagged paid) |
| 5 | LFM values | ✅ unpaid: Engagements 102,958 · Reactions 102,336 · Comments 622 · Shares – · Video Views 1,954,123 · paid: Engagements 65,554 · Reactions 65,213 · Comments 341 · Shares – · Video Views 1,466,281 |
| 6–7 | Click image → native tab, read `<meta name=description>` | ✅ unpaid https://www.instagram.com/reel/Der-ETsgV2Z/ "103K likes, 627 comments" · paid https://www.instagram.com/reel/Deu7w6lFQYA/ "66K likes, 343 comments" |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7 | LFM Reactions/Comments/Shares ≈ native Likes/Comments/Shares for the paid and the unpaid reel | unpaid 102,336 vs ≈103,000 · 622 vs 627; paid 65,213 vs ≈66,000 · 341 vs 343 (shares not shown natively) | ✅ PASS |

## Evidence
- Session result `ctx._nat.q78263` (card text, LFM metrics, native meta descriptions).

## Known bugs checked
- None open on QA-78263.

## Bugs filed
None.

## Cleanup
Native tabs closed; Reel filter left on the dev tab (session only).
