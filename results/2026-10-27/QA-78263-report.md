# QA-78263 — Brand Content > LFM vs Native > Instagram Reels

**Run date:** 2026-10-27 (Tuesday) — case is fixed to Hulu / Hulu
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no Instagram login), dev `app.lfmdev.in`
**Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670) · Channel: Instagram only · Filter: Publish Type = Reel · Date range: default week Oct. 19, 2026 – Oct. 25, 2026 · Data set: Public
**Verdict: PASS — unpaid reel (Mon Oct 19, "The OG yearner. Now streaming: #OnceUponATime"): LFM Reactions 104,081 vs native 105K likes (+0.9%), Comments 627 vs 629; paid reel (Tue Oct 20, "This is why you do not talk to strangers. #OMITB"): LFM Reactions 66,128 vs native 66K likes, Comments 348 vs 354 (+1.7%). Shares are not exposed on the logged-out native page**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Content → Hulu → Instagram only | ✅ Posts (53) |
| 4–5 | Filter → Publish Type → **Reel** → Apply | ✅ Posts (39) |
| 5 | Identify paid vs unpaid (Table View, Paid column `<i title="Paid post">`) | ✅ unpaid = rank 1, paid = rank 3 (paid reels at ranks 3, 7, 12, 15, 20) |
| 5 | LFM values | ✅ unpaid: Engagements 104,708 · Reactions 104,081 · Comments 627 · Video Views 1,987,731 · paid: Engagements 66,476 · Reactions 66,128 · Comments 348 · Video Views 1,547,963 |
| 6–7 | Click image → native tab, read `<meta name=description>` | ✅ unpaid https://www.instagram.com/reel/Der-ETsgV2Z/ "105K likes, 629 comments" · paid https://www.instagram.com/reel/Deu7w6lFQYA/ "66K likes, 354 comments" |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7 | LFM Reactions/Comments/Shares ≈ native for the paid and the unpaid reel | unpaid 104,081 vs ≈105,000 · 627 vs 629; paid 66,128 vs ≈66,000 · 348 vs 354 | ✅ PASS |

## Evidence
- Session result `ctx._nat.q78263`. Same two reels as 2026-10-26 (then 102,336 / 103K and 65,213 / 66K) — both surfaces grew in step.

## Known bugs checked
- None open on QA-78263.

## Bugs filed
None.

## Cleanup
Native tabs closed.
