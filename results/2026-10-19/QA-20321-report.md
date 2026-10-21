# QA-20321 — Brand Content > Impressions Data Set > Past date range data test

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** Oct. 01, 2023 – Sep. 30, 2024 · **Data set:** Impressions · one channel at a time, Table View, 200 rendered rows per channel + Sum row
**Verdict: FAIL (needs triage) — Instagram and Twitter hold fully; Facebook: 30 of the top-200 posts show a total Impressions (and Reach) value while Organic/Paid Impressions (and Organic/Paid Reach) are "–", so Organic + Paid ≠ Impressions for those posts; LinkedIn not evaluable (0 posts)**

## Facebook only (Posts 2,563)
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A5 | Organic + Paid Impressions = Impressions | 170/200 ✓ (rank 1: 269,308 + 0 ✓). **30/200 ✗**: e.g. rank 2 Impressions **57,591,779** with Organic "–" / Paid "–"; rank 8 7,350,991; rank 12 3,716,263; rank 21 6,651,643; rank 27 4,230,701; rank 28 4,346,061. Sum row Organic 592,081,591 + Paid 95,991,411 = 688,073,002 **≠** Impressions 911,225,506 (the gap = the unsplit posts) | ❌ 30 posts without organic/paid split |
| A6 | Engagements / Impressions = Engagement Rate | 200/200 ✓ (rank 1: 1,391,033 / 269,308 = 516.52% ✓; rank 2: 659,110 / 57,591,779 = 1.14% ✓) | ✅ |
| (Reach, outside the listed FB assertions) | — | Per-post Reach and Engaged User Rate are still populated for these 2023–24 posts (rank 1 Reach 269,308, EUR 516.52%), although the precondition says FB Reach/EUR were removed in Nov 2025; the same 30 posts have Reach but no Organic/Paid Reach split | ℹ note |

## Instagram only (Posts 2,232)
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A8 | Organic + Paid Impressions = Impressions | 166/166 evaluable ✓ (34 posts "–" across all impression columns — no data, skipped) | ✅ |
| A9 | Organic + Paid Reach = Reach | 200/200 ✓ (rank 1: 9,586,714 + – ✓) | ✅ |
| A10 | Engagements / Impressions = Engagement Rate | 166/166 ✓ (599,650 / 3,741,771 = 16.03% ✓) | ✅ |
| A11 | Engagements / Reach = Engaged User Rate | 200/200 ✓ (1,243,067 / 9,586,714 = 12.97% ✓) | ✅ |

## Twitter only (Posts 695)
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A13 | Organic + Paid Impressions = Impressions | 199/199 ✓ (3,269,583 + – ✓); Sum 139,143,856 + – ✓ | ✅ |
| A14 | Organic + Paid Reach = Reach | Reach "–" on 200/200 — Twitter has no reach metric (consistent) | ✅ (n/a) |
| A15 | Engagements / Impressions = Engagement Rate; Engaged User Rate shows en-dash | 199/199 ✓ (51,840 / 3,269,583 = 1.59% ✓); EUR "–" on 200/200 ✓ | ✅ |

## LinkedIn only
| A17–A19 | — | **Posts (0)** for HBO Max in Oct 2023 – Sep 2024 | 🚫 not evaluable (test-data gap) |

## Evidence
`.playwright-out/QA-20321/01-fb-imp.png`, `02-ig-imp.png`, `03-tw-imp.png`, `04-li-imp.png`

## Known bugs checked
- LFMP-28018, DATA-12253 (closed, Impressions data set) — the Facebook "total without split" pattern should be compared against those before filing anew; APPS-62062 (Open QA Task "update test cases for APPS-61939") may already cover the Meta deprecation changes. **Triage needed:** are the 30 unsplit Facebook posts (likely Reels/cross-posted video, where Meta supplies no organic/paid breakdown) accepted behavior? If yes, add that to the spec; if no, file a bug with the ranks above.

## Bugs filed
None auto-filed (candidate documented above). · **Cleanup:** none.
