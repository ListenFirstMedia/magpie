# QA-22072 — Brand > Partnerships - Basic View data set (Advanced Filter of Metrics) — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV (4018) · **Window:** May 1–31 2026 · **Data Set:** Basic
- **Result:** ⚠️ PARTIAL — re-confirms 2026-06-05 finding (no metric-based sub-filter)

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Filter sub-categories present | Filter dropdown lists filterable attributes | Collaborated, Collaborated Total, Collaborator Name, Content Type, Publish Day, Publish Time, Publish Type, Sponsor Name, Tag, Text Search (10) | ✅ |
| "Advanced Filter capability of **Metrics**" | A metric-based sub-filter (Engagements/Reactions/etc.) | **None present.** Search "engagement" in the filter returns 0 results | ❌ (spec drift / product gap) |

## Finding (re-confirmed)
- Brand>Partnerships Basic Filter has **no metric-based sub-filter**, contradicting the QA-22072 title "Advanced Filter capability of Metrics". Same as 2026-06-05. Recommend product/spec triage: either add metric filtering or rewrite the spec to the 10 attribute-based filters.
- (MTV Partnerships has 0 sponsored posts in the window — tiles show "no data available"; not relevant to the filter assertion.)

## Bugs filed
- Spec/feature gap re-confirmed (no metric filter) — product triage.
