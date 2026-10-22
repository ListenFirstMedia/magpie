# QA-21915 — Brand Content > LFM vs Native > Instagram Channel

**Run date:** 2026-10-22 (Thursday) — interactive re-run on the alternative account; the unattended runner blocked it because the Thursday rotation brands do not exist on dev
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no Instagram login), dev `app.lfmdev.in`
**Account:** Amazon Prime Video · **Brand:** Amazon Prime Video · Channel: Instagram only · Date range: default week Oct. 14, 2026 – Oct. 20, 2026
**Verdict: FAIL — first post (reel "Love makes you do ALL sorts of things", Fri Oct 16): LFM Reactions 373,304 vs native 220K likes (−41%), Comments 2,485 vs 2,006 (−19%); matches open bug LFMP-32113 (native lower than LFM). Note: the unattended run of QA-90072 read the same reel's native meta as 430.8K likes earlier today, so Instagram's logged-out counter is itself inconsistent across requests**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Content → Amazon Prime Video → Instagram only | ✅ Posts (76) |
| 4 | First post metrics | ✅ Engagements 375,789 · Reactions 373,304 · Comments 2,485 · Response Rate 5.15% · Video Views 5,127,832 |
| 5–6 | Click image → native tab | ✅ https://www.instagram.com/reel/Dei-B_-Dpfy/ — `<meta name=description>`: "220K likes, 2,006 comments - primevideo on October 16, 2026" |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A6 | LFM values not far from native | Reactions 373,304 vs ≈220,000 (−41%); Comments 2,485 vs 2,006 (−19%) | ❌ FAIL (LFMP-32113 pattern; native counter inconsistent) |

## Evidence
- Session result `ctx._rerun2.q21915`; compare results/2026-10-22/QA-90072-report.md (same reel, native read 430.8K at 13:16 IST).

## Known bugs checked
- LFMP-32113 (Open) "native data is lower than LFM": reproduced in direction and magnitude.

## Bugs filed
None (existing bug).

## Cleanup
Native tab closed.
