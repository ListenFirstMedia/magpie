# QA-24278 — Brand Content - Impressions Data Set - Aggregate Data Test

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** current default week Oct. 11 – Oct. 17, 2026 · **Data set:** Impressions · Aggregate row in Table View, Sum then Average, one channel at a time
**Verdict: PASS — Facebook (A4–A5), Instagram (A7–A10) and Twitter (A12–A14) all hold; LinkedIn (A16–A18) NOT EVALUABLE — HBO Max has 0 LinkedIn posts in the current week (no aggregate row)**

## Facebook only (Posts 30)
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Organic Impressions + Paid Impressions = Impressions (sum & avg) | Sum 8,690,567 + 105,084 = 8,795,651 ✓ · Avg 289,686 + 3,503 = 293,189 vs 293,188 (Δ1 rounding) ✓ | ✅ |
| A5 | Engagements ÷ Impressions = Average Engagement Rate | 191,315 ÷ 8,795,651 = 2.175% → Average row Engagement Rate **2.18%** ✓ (Sum row shows N/A, Reach columns N/A per the Meta Reach deprecation) | ✅ |

## Instagram only (Posts 38)
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7 | Organic + Paid Impressions = Impressions | Sum 50,916,788 + 818,704 = 51,735,492 ✓ · Avg 1,339,915 + 21,545 = 1,361,460 ✓ | ✅ |
| A8 | Organic Reach + Paid Reach = Reach (average) | Avg 837,698 + 18,029 = 855,727 ✓ (Sum row N/A — reach is not summable) | ✅ |
| A9 | Engagements ÷ Impressions = Average Engagement Rate | 1,887,192 ÷ 51,735,492 = 3.648% → **3.65%** ✓ | ✅ |
| A10 | Engagements ÷ Reach = Engaged User Rate | Avg 49,663 ÷ 855,727 = 5.804% → **5.80%** ✓ | ✅ |

## Twitter only (Posts 23)
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A12 | Organic + Paid Impressions = Impressions | Sum 15,920,747 + – = 15,920,747 ✓ · Avg 692,206 + – = 692,206 ✓ (no paid tweets) | ✅ |
| A13 | Organic Reach + Paid Reach = Reach | all three N/A (sum) / "–" (avg): Twitter has no reach metric — consistent | ✅ (n/a by design) |
| A14 | Engagements ÷ Impressions = Average Engagement Rate; Engaged User Rate shows en-dash | 92,777 ÷ 15,920,747 = 0.583% → **0.58%** ✓ · Engaged User Rate "–" ✓ | ✅ |

## LinkedIn only
| A16–A18 | — | **Posts (0)** this week → no aggregate row | 🚫 not evaluable (test-data gap, same as QA-24276 A8) |

## Evidence
`.playwright-out/QA-24278/01-fb-imp-agg.png`, `02-ig-imp-agg.png`, `03-tw-imp-agg.png`, `04-li-imp-agg.png`

## Known bugs checked
DATA-12253 (closed) not reproduced; APPS-62062 is a test-case-update task. No open bugs interfere.

## Bugs filed
None. · **Cleanup:** none.
