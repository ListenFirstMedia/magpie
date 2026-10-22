# QA-21916 — Brand Content > LFM vs Native > YouTube Channel

**Run date:** 2026-10-22 (Thursday) — interactive re-run on the alternative account; the unattended runner blocked it because the Thursday rotation brand does not exist on dev
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in`
**Account:** Amazon Prime Video · **Brand:** Amazon Prime Video · Channel: YouTube only · Date range: default week Oct. 14, 2026 – Oct. 20, 2026
**Verdict: FAIL (data freshness) — first video "The Greatest - Official Trailer | Prime Video" (Wed Oct 14): LFM Video Views 4,285,418 vs native 9.2M (native +115%), Likes 5,821 vs ≈8,000 (+37%), Comments 304 vs 457 (+50%); LFM's lifetime stats for a 7-day-old trailer lag the live counters by a large margin**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Content → Amazon Prime Video → YouTube only | ✅ Posts (51) |
| 4 | First post metrics | ✅ Video Views 4,285,418 · Likes 5,821 · Comments 304 |
| 5–6 | Click image → native tab | ✅ https://www.youtube.com/watch?v=RnRf-r-RdA4 — "9.2m views 7 days ago", like button "like this video along with 8,000 other people", `#comments #count` "457 Comments" |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A6 | LFM values not far from native | Video Views 4,285,418 vs 9,200,000; Likes 5,821 vs 8,000; Comments 304 vs 457 | ❌ FAIL (large variance; native higher) |

## Evidence
- Session result `ctx._rerun2.q21916`.

## Known bugs checked
- None open on the case. The direction is the opposite of LFMP-32113 (native higher): a fast-moving trailer whose LFM stats were last collected well before the native read. Worth a data-collection cadence check for YouTube on high-velocity videos.

## Bugs filed
None (needs triage).

## Cleanup
Native tab closed.
