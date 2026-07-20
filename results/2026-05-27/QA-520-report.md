# QA-520 — Facebook Content - Table Data Set - Authorized & UnAuthorized

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-520
- **Run date:** 2026-05-27
- **Account:** Adam Orfei (account_id=54)
- **Brand:** Star Wars (brand_id=75007) — owned by Disney, viewed without auth from Adam Orfei
- **Result:** ✅ **3/3 PASS**

## Steps executed

| Step | Action | State |
|---|---|---|
| 1-2 | Brand > Content → search and select **Star Wars** | ✓ |
| 3 | Data Set → **Impressions** | ✓ |
| 4 | Layout → Table View; Channels → Facebook only | ✓ — Posts (34) Facebook |
| 5 | Reviewed Aggregate Sum row | ✓ |
| 6 | Toggled Sum → Average | ✓ |
| 7 | Reviewed Aggregate Avg row | ✓ |

## Assertion results

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 4 | Only Engagements should display value; other metrics should display Lock symbol | Per-post rows: Engagements column shows real values (15,701; 13,711); **Engagement Rate / Impressions / Organic Impressions / Paid Impressions columns all show 🔒 lock icons** on every post row (unauthorized access for Adam Orfei viewing Disney's Star Wars Facebook data). | ✅ PASS |
| A2 | 5 | Aggregate Sum: Engagement Rate / Reach / Organic Reach / Paid Reach / Engaged User Rate = `N/A`; Impressions / Organic Impressions / Paid Impressions = `0` or `–` | Sum row observed: Engagements `127,043`, Engagement Rate `N/A`, Impressions `–`, Organic Impressions `–`, Paid Impressions `–`, Reach `N/A`, Organic Reach `N/A`, Paid Reach `N/A`, Engaged User Rate `N/A`. Exact match. | ✅ PASS |
| A3 | 7 | Aggregate Avg: all metrics show `–` except Engagements | Avg row observed: Engagements `3,737` (= 127,043 ÷ 34 ≈ correct), all other columns `–`. | ✅ PASS |

## Evidence
- Star Wars on Authorized perspective for Adam Orfei = unauthorized access to Disney's Facebook page data → 🔒 lock symbols on Impression/Engagement Rate columns.
- Aggregate Sum row: Engagements `127,043`; all impression metrics `–`; all rate metrics `N/A`.
- Aggregate Avg row: Engagements `3,737`; all other metrics `–`.

## Bugs filed
None. Behavior matches spec exactly — locked access patterns and aggregate placeholder logic working as designed.

## Skill registry impact
- `switch-account` v2 → pass_streak 9 → 10.
- `brand-content-table-view` v1 → pass_streak 3 → 4.
