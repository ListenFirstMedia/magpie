# QA-24281 — Brand Content - Channel Specific Data Sets - Aggregate Data Test

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** current default week Oct. 11 – Oct. 17, 2026 · Aggregate row (Sum, then Average) in Table View, one channel-specific data set at a time
**Verdict: FAIL — 7 of 8 assertions PASS; A7 (Twitter User Follows) fails on the known open bug LFMP-32088 (all User Follows columns render "–")**

| ID | Data set (channel) | Expected | Sum row | Average row | Status |
|----|--------------------|----------|---------|-------------|--------|
| A3 | Facebook Only: Reactions (FB, 30 posts) | Likes+Loves+Hahas+Wows+Sads+Angries+Others = Reactions | 157,714+18,734+3,375+1,670+52+22+0 = 181,567 ✓ | 5,257+624+113+56+2+1+0 = 6,053 vs 6,052 (Δ1 rounding) ✓ | ✅ |
| A5 | Facebook Only: Completed Video Views (FB, 29) | Organic + Paid Completed Views = Completed Views | 1,695,101 + 6,059 = 1,701,160 ✓ | 58,452 + 209 = 58,661 ✓ | ✅ |
| A7 | Twitter Only: Engagements & Follows (TW, 23) | Organic + Paid User Follows = User Follows | User Follows / Organic / Paid all **"–"** | all "–" | ❌ **LFMP-32088** (Open) reproduces |
| A9 | Instagram Only: Insights (IG, 38) | Organic + Paid Saves = Saves | 126,800 + – = 126,800 ✓ | 3,337 + – = 3,337 ✓ | ✅ |
| A11 | YouTube Only: Insights (YT, 13) | Organic + Paid + Unclassified Views = Video Views | 813,277 + 19,329,329 + 16,438,945 = 36,581,551 ✓ | 62,560 + 1,486,871 + 1,264,534 = 2,813,965 ✓ | ✅ |
| A12 | YouTube Only: Insights | Organic + Paid Watch Time = YouTube Watch Time (Minutes) | 538,534.46 + 7,187,136.83 = 7,725,671.29 vs 7,725,671.28 (±0.01) ✓ | 41,425.73 + 552,856.68 = 594,282.41 ✓ | ✅ |
| A14 | YouTube Only: Premium | Organic + Paid Premium Views = Premium Views | 96,712 + 0 = 96,712 ✓ | 7,439 + 0 = 7,439 ✓ | ✅ |
| A15 | YouTube Only: Premium | Organic + Paid Premium Watch Time = Premium Watch Time | 98,477.71 + 0.00 ✓ | 7,575.21 + 0.00 ✓ | ✅ |

## Evidence
`.playwright-out/QA-24281/01-fb-reactions-agg.png` … `06-yt-premium-agg.png`

## Known bugs checked
- LFMP-32088 (Open) — reproduces on HBO Max (A7). APPS-60871 (Open, APV en-dash on YouTube sets) — does not reproduce on HBO Max.

## Bugs filed
None (LFMP-32088 already covers A7). · **Cleanup:** none.
