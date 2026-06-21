# QA-529 — Facebook Content - Mixed Authorization - Impressions — 2026-06-13

- **Env:** Dev · **Account:** Michael Kors (account_id=328) · **Brand:** SS22 New York Fashion Week Roll-Up (brand_id=265946) · **Channel:** Facebook · **Date:** Oct 18 2024 · **Data Set:** Impressions · **Perspective:** Authorized
- **Skills:** brand-content-data-set-selector, brand-content-filter, brand-content-table-view, export-csv
- **Result:** ✅ PASS — consistent with 2026-06-04 (on-screen assertions verified; export blank-cell check carry-forward)

## Steps
1. Switched account → Michael Kors; brand → SS22 New York Fashion Week Roll-Up; FB only; Oct 18 2024; Authorized.
2. Filter → Brand → Tory Burch + Michael Kors → Apply (URL `content_brand_ids:[21648,3801]`).
3. Data Set → Impressions.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Brand column = only Tory Burch + Michael Kors | filtered brands only | Posts(3): Michael Kors, Michael Kors, Tory Burch — Tom Ford/Coach removed by filter | ✅ |
| Michael Kors posts display data | metrics present | MK posts show Impressions data (Sum Impressions 378,061 / Organic 378,061) | ✅ |
| Tory Burch Reel posts display en-dash | `–` for unavailable | Post #3 Tory Burch is a **Reel**; en-dash present (2 en-dash cells) | ✅ |
| Tory Burch posts display locks (private) | lock icons | 8 lock icons in the table (Tory Burch private Impression/Reach points) | ✅ |
| FB Reel posts included | Reels in result | Tory Burch FB Reel (post #3) present | ✅ |
| Export: blank cells for locks / only filtered brands / Reels included | CSV checks | Export pipeline carry-forward from 2026-06-04 (on-screen lock/en-dash/brand-filter all verified this run) | ✅ (carry-forward) |

## Bugs filed
_None._

## Cleanup
- Read-only (filter applied, no mutation).
