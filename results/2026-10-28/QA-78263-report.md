# QA-78263 — Brand Content > LFM vs Native > Instagram Reels

**Run date:** 2026-10-28 (Wednesday) — case is fixed to Hulu / Hulu
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no Instagram login), dev `app.lfmdev.in`
**Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670) · Channel: Instagram only · Filter: Publish Type = Reel · Date range: default week Oct. 20, 2026 – Oct. 26, 2026 · Data set: Public
**Verdict: PASS — unpaid reel (Thu Oct 22, "Survivor. Full stop. Now streaming: #TheRookie"): LFM Reactions 69,808 vs native 71K likes (+1.7%), Comments 184 vs 186; paid reel (Tue Oct 20, "This is why you do not talk to strangers. #OMITB"): LFM Reactions 66,762 vs native 67K likes, Comments 359 vs 357. Shares are not exposed on the logged-out native page**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Content → Hulu → Instagram only | ✅ Posts (51) |
| 4–5 | Filter → Publish Type → **Reel** → Apply | ✅ Posts (38) |
| 5 | Identify paid vs unpaid (Table View, Paid column `<i title="Paid post">`) | ✅ unpaid = rank 1, paid = rank 2 (paid reels at ranks 2, 11, 13, 19, 33) |
| 5 | LFM values | ✅ unpaid: Engagements 69,992 · Reactions 69,808 · Comments 184 · Video Views 1,029,057 · paid: Engagements 67,121 · Reactions 66,762 · Comments 359 · Video Views 1,642,912 |
| 6–7 | Click image → native tab, read `<meta name=description>` | ✅ unpaid https://www.instagram.com/reel/DezeSZfCk4e/ "71K likes, 186 comments" · paid https://www.instagram.com/reel/Deu7w6lFQYA/ "67K likes, 357 comments" |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7 | LFM Reactions/Comments/Shares ≈ native for the paid and the unpaid reel | unpaid 69,808 vs ≈71,000 · 184 vs 186; paid 66,762 vs ≈67,000 · 359 vs 357 | ✅ PASS |

## Evidence
- Session result `ctx._nat.q78263`. The paid reel is the same as on 10-26/10-27 (65,213 → 66,128 → 66,762 LFM vs 66K → 66K → 67K native); the unpaid top reel changed with the new week.

## Known bugs checked
- None open on QA-78263.

## Bugs filed
None.

## Cleanup
Native tabs closed.
