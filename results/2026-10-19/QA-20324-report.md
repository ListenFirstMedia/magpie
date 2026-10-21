# QA-20324 — Brand Content > Engagements Breakdowns Data Set > Past date range data test

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** Jun. 01, 2023 – Dec. 31, 2023 · **Data set:** Engagements Breakdown · Twitter only (Posts 697), then Instagram only (Posts 1,283) · Table View, 200 rendered rows + Sum row
**Verdict: FAIL (minor, needs triage) — Instagram 200/200 on every identity; Twitter: 3 of 200 tweets have Organic + Paid Engagements ≠ Engagements (small unattributed remainder), and the Sum row shows the same gap (669,314 organic vs 670,599 total, Paid "–")**

## Twitter only
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A5 | Organic + Paid Engagements = Engagements | 197/200 ✓ (rank 1: 31,728 + – ✓). **✗ rank 45: 3,489 + – vs 3,520 (Δ31); rank 144: 763 + – vs 776 (Δ13); rank 200: – + – vs 486.** Sum row 669,314 + – = 669,314 vs 670,599 (Δ1,285) | ❌ 3 posts |
| A6 | Organic R + C + S = Organic Engagements | 199/199 ✓ (23,067 + 564 + 8,097 = 31,728 ✓) | ✅ |
| A7 | Paid R + C + S = Paid Engagements | no paid tweets in range (all "–") | ✅ (n/a) |

## Instagram only
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A9 | Organic + Paid Engagements = Engagements | 200/200 ✓; Sum 17,122,861 ✓ | ✅ |
| A10 | Organic R + C + S = Organic Engagements | 200/200 ✓ (1,231,499 + 11,568 + – = 1,243,067 ✓; IG has no Shares split) | ✅ |
| A11 | Paid R + C + S = Paid Engagements | no paid IG posts in range | ✅ (n/a) |

## Evidence
`.playwright-out/QA-20324/01-tw-eb-2023.png`, `02-ig-eb-2023.png`

## Known bugs checked
APPS-54916 (closed Test Failure) and DATA-12253 (closed) sit on this case — the 3-tweet remainder (engagements attributed to neither organic nor paid) looks like the same family; re-open or file with the ranks above if the data team confirms it is not expected. No open bug currently covers it.

## Bugs filed
None auto-filed (candidate documented). · **Cleanup:** none.
