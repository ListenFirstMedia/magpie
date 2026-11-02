# QA-78263 — Brand Content > LFM vs Native > Instagram Reels

**Run date:** 2026-10-30 (Friday) — case is fixed to Hulu / Hulu
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no Instagram login), dev `app.lfmdev.in`
**Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670) · Channel: Instagram only · Filter: Publish Type = Reel · Date range: default week Oct. 22, 2026 – Oct. 28, 2026 · Data set: Public
**Verdict: FAIL — the unpaid reel matches native (LFM Reactions 72,617 vs native 73K likes, Comments 187 vs 187), but the top paid reel (Thu Oct 22, "Do you spot the differences? … #PHONY", https://www.instagram.com/reel/Dezy5atESyG/) shows LFM Reactions 11,639 / Comments 137 against native 3,914 likes / 52 comments (LFM 3.0× / 2.6× higher) — same reel and same gap as 2026-10-29 (11,326/135 vs 3,656/48)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Content → Hulu → Instagram only | ✅ Posts (59) |
| 4–5 | Filter → Publish Type → **Reel** → Apply | ✅ Posts (43) |
| 5 | Identify paid vs unpaid (Table View, Paid column `<i title="Paid post">`) | ✅ unpaid = rank 1, paid reels at ranks 13, 14, 40 |
| 5 | LFM values | ✅ unpaid (rank 1): Engagements 72,804 · Reactions 72,617 · Comments 187 · Video Views 1,076,619 · paid (rank 13): Engagements 11,776 · Reactions 11,639 · Comments 137 · Video Views 13,187,840 |
| 6–7 | Click image → native tab, read `<meta name=description>` | ✅ unpaid https://www.instagram.com/reel/DezeSZfCk4e/ "73K likes, 187 comments" · paid https://www.instagram.com/reel/Dezy5atESyG/ "3,914 likes, 52 comments" |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7 (unpaid) | LFM Reactions/Comments ≈ native | 72,617 vs ≈73,000 · 187 vs 187 | ✅ |
| A7 (paid) | LFM Reactions/Comments ≈ native | Dezy5atESyG: 11,639 vs 3,914 (+197%) · 137 vs 52 (+163%) | ❌ FAIL |

Shares are not exposed on the logged-out native page.

## Evidence
- Session result `ctx._nat.q78263`.
- Same reel as yesterday; both surfaces grew overnight (LFM +313 reactions, native +258 likes) and the ratio is unchanged, so the LFM figure is not a one-off collection glitch. Video Views 13.19M against 3.9K organic likes → the reel is being promoted and LFM appears to roll the promoted-instance interactions into the public metrics while the permalink shows the organic post only (see the 2026-10-29 report for the second affected reel DezemAMlW8R and the matching small paid reel).
- Not the LFMP-32113 direction (there native was higher than LFM); here LFM is higher.

## Known bugs checked
- None open on QA-78263. Recommend raising with data engineering: Instagram paid reel public metrics include promoted-instance likes/comments that the native permalink does not show.

## Bugs filed
None (needs triage to confirm whether the paid-instance roll-up is intended).

## Cleanup
Native tabs closed.
