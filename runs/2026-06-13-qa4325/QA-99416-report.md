# QA-99416 — Brand Sets > Content - Daily Post Analysis Modal - Table Display & Behavior — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand Set:** Adam's Brand Set (set 1738) · **Window:** Jun 1–15 2026
- **Post:** NBA IG, Jun 13 2026 ("…THE KNICKS ARE NBA CHAMPIONS", Engagements 2,175,310)
- **Skills:** daily-post-analysis-modal
- **Result:** ✅ PASS

## Steps
1. Brand Sets > Content for **Adam's Brand Set** → post #1 (NBA IG) **Daily Analysis** → DPA modal.
2. Header: Date Range Jun 13–15, **Mode: In Window**, **Rank: Engagements** (Brand-Sets variant uses *Rank* where Brand>Content uses *Data Set*). Graph Metrics: **Engagements**.
3. Line chart + **data table**: columns **Metric / Sum / Average / Jun 13 / Jun 14 / Jun 15** with sortable (↕) headers.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Table displays | Metric × Sum/Average/per-day columns | Engagements row: Sum 2,175,310 / Avg 725,103 / Jun13 1,704,042 / Jun14 429,061 / Jun15 42,207 | ✅ |
| Table internal consistency | Sum = Σ daily; Avg = Sum/days | 1,704,042+429,061+42,207 = **2,175,310** = Sum ✓; /3 = **725,103** = Avg ✓ | ✅ |
| Sortable columns (behavior) | Column headers offer sort | ↕ sort affordances on Metric/Sum/Average/date columns | ✅ |
| Brand-Sets variant | Rank-based (not Data Set) | Header shows **"Rank: Engagements"** | ✅ |

## Notes / automation learning
- The **Brand Sets** DPA modal is the competitive variant of the Brand>Content DPA (QA-99380/103246): header field is **"Rank"** (not "Data Set"), and it defaults to the single rank metric (Engagements) rather than 5 metrics. Table structure + Export menu are otherwise the same.
- Post cards reached via `find` "Daily Analysis" (47 refs); first NBA post opened cleanly.

## Bugs filed
_None._
