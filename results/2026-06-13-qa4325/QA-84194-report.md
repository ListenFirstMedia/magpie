# QA-84194 — Data Studio - Brand > Content - Data QA - Impressions — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Report:** DS Post Level, report_id 297155
- **Brand:** MTV (Authorized view) · **Window:** 7D (Jun 9–15 2026), In-Window, Days
- **Skills:** data-studio-post-level-run
- **Result:** ✅ PASS

## Steps
1. DS Post Level for MTV; **Select Metrics** → **Impressions (with LinkedIn)** (aggregate impressions).
2. **Key enabling step:** Impressions metrics are greyed/disabled under **Lifetime** mode and **Public** view — they require **In-Window** + the brand's **Authorized Data** view. After switching both, the Impressions tree (Impressions / Public Impressions / Reach and channel sub-metrics) became selectable.
3. **Go** → report 297155: Engagements + **Impressions** rows in the table.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Impressions value present | Non-zero post-level Impressions | **Sum 39,726,174**, Avg **5,675,168** | ✅ |
| Per-day values render | Daily breakdown Jun 9–15 | 1,245,970 / 2,806,020 / 5,834,354 / 9,095,788 / 6,207,890 / 9,302,649 / 5,233,503 | ✅ |
| Internal consistency (Data QA) | Sum = Σ daily; Avg = Sum/7 | Σ daily = **39,726,174** = Sum ✓; 39,726,174/7 = 5,675,168 = Avg ✓ | ✅ |

## Notes / automation learning
- **Post-level Impressions are private/window metrics** — disabled in Lifetime/Public; require **In-Window + Authorized Data** to select (the recurring "DS metric-tree friction", now precisely characterized). MTV on Adam Orfei *does* return Authorized Impressions once the view is switched.
- Data-QA validated by internal arithmetic (daily values reconcile to Sum; Average = Sum/interval count).

## Bugs filed
_None._
