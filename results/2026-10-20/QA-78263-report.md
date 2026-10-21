# QA-78263 — Brand Content > LFM vs Native > Instagram Reels

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no Instagram login), dev `app.lfmdev.in`
**Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670) · Channel: Instagram · Filter: Publish Type = Reel · Date range: default week Oct. 12, 2026 – Oct. 18, 2026
**Verdict: PASS — unpaid reel: LFM Reactions 151,606 vs native 153K likes (+0.9%), Comments 395 vs 399; paid reel: LFM Reactions 24,123 vs native 24K likes, Comments 69 vs 72 (+4%)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Content → Hulu → Instagram only | ✅ |
| 4–5 | Filter → Publish Type → **Reel** → Apply | ✅ URL `filters={"content_post_class":{"values":["reel"]}}`, Posts (40), 40 grid cards (6 paid, marked with the `$` Paid post icon) |
| 6a | First **unpaid** reel (#1, Wed Oct. 14, 2026 05:14 PM PDT) — Engagements 152,001 · Reactions 151,606 · Comments 395 → click image | ✅ https://www.instagram.com/reel/DefpKoIRftR/ — "153K likes, 399 comments - hulu on October 14, 2026: Her husband found a mistress… #TheRemarriedEmpress" |
| 6b | First **paid** reel (#7, Sat Oct. 17, 2026 10:03 AM PDT) — Engagements 24,192 · Reactions 24,123 · Comments 69 → click image | ✅ https://www.instagram.com/reel/DemYXDIIKnE/ — "24K likes, 72 comments - hulu on October 17, 2026: Welcome to Theranos… #TheDropout" |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Unpaid reel LFM vs native: no big variation | Reactions 151,606 vs ≈153,000 (+0.9%); Comments 395 vs 399 | ✅ PASS |
| A2 | Paid reel LFM vs native: no big variation | Reactions 24,123 vs ≈24,000; Comments 69 vs 72 (+4.3%) | ✅ PASS |

## Evidence
- Session result `ctx._native.reels78263` (40 cards with paid flags and LFM values, both native meta descriptions).

## Known bugs checked
- None open on the case.

## Notes
- Publish Type filter values on Brand > Content: IGTV, Original Post, Reel. Paid cards carry `i.fa-dollar-sign[title="Paid post"]`.

## Bugs filed
None.

## Cleanup
Native tabs closed.
