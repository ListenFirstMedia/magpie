# QA-126530 — TWC Cohort/Competitive Average as a Line

> **Status:** ✅ **ALL 4 ASSERTIONS PASS**
> **Run date:** 2026-05-13 · **Env:** dev · **Account:** Adam Orfei · **User:** LFQA
> **Story IDs:** 153237 (Cohort), 153238 (Cohort+Competitor)

## Execution

| Step | Description | Result |
|----:|-------------|:------:|
| 1 | Reporting → Time Window Comparison | ✅ |
| 2 | Add MTV, Star Wars, HBO Max | ✅ |
| 3 | Absolute date, Interval=Aggregate | ✅ |
| 4 | Metrics: FB New Fans, TW New Followers, IG Total Followers | ✅ |
| 5 | Show Cohort Average | ✅ |
| 6 | Run Report | ✅ |
| 7 | Change Settings | ✅ |
| 8 | Show Competitor Average | ✅ |
| 9 | Run Report | ✅ |

## Assertion results

| ID | Description | Status | Evidence |
|---:|-------------|:------:|----------|
| A1 | Cohort Average displayed as a LINE across chart (not separate bar) | ✅ | Horizontal solid line at ~45K labeled "Cohort Average"; 3 separate brand bars (MTV ~0, Star Wars ~10K, HBO Max ~125K) |
| A2 | Hovering Cohort Average shows tooltip with value | ✅ | Tooltip: **"Cohort Average: 45275"** |
| A3 | Competitor Average displayed as DOTTED LINE across chart | ✅ | Dashed/dotted horizontal line at ~70K labeled "Competitor Average"; legend shows dotted pattern |
| A4 | Hovering Competitor Average shows tooltip with value | ✅ | Tooltip: **"Competitor Average: 70990"** |

All assertions pass with high confidence — values captured exactly, line rendering verified visually.
