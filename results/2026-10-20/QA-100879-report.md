# QA-100879 — Brand Content > LFM vs Native > Threads Channel

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no Threads login), dev `app.lfmdev.in`
**Account:** HBO Max (account_id=657) · **Brand:** HBO Max (brand_id=155614) · Channel: Threads only · Date range: Jun. 01, 2025 – Jun. 07, 2025 (the default week has no Threads posts for this brand)
**Verdict: PASS — native Threads post readable logged-out; LFM Reactions 751 vs native 746 likes (−0.7%), Comments 8 vs 8 replies, Shares 48 vs native reposts 16 + quotes 31 = 47**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Content → HBO Max (account default) → window Jun 01–07 2025 | ✅ |
| 4 | Threads only → Apply | ✅ Posts (21) |
| 5 | First post metrics (grid card #1) | ✅ Sat Jun. 07, 2025 10:00 AM PDT image "She has a type." — Engagements 807 · Reactions 751 · Comments 8 · Shares 48 · Response Rate – |
| 6 | Click the image → native tab | ✅ https://www.threads.com/@hbomax/post/DKm2_-Kq1Ec — title "She has a type.", body "192K views | hbomax | 07/06/2025 | She has a type. | 746 | 8 | 16 | 31" (likes, replies, reposts, quotes) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Reactions ≈ native likes | 751 vs 746 (−0.7%) | ✅ PASS |
| A2 | Comments ≈ native replies | 8 vs 8 | ✅ PASS |
| A3 | Shares ≈ native reposts + quotes | 48 vs 16 + 31 = 47 | ✅ PASS |

## Evidence
- Session result `ctx._native.other.threads`.

## Known bugs checked
- None open on the case.

## Notes
- Threads public post pages render headless with the counters as bare numbers under the post text (likes, replies, reposts, quotes order); the LFM card link uses `threads.com/@brand/post/<id>`.

## Bugs filed
None.

## Cleanup
Native tab closed.
