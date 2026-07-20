# QA-92735 — Brand > Audience - LinkedIn - Basic View — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand:** MTV (4018) · **Channel:** LinkedIn · **Window:** Jun 1–15 2026
- **Skills:** brand-audience-nav
- **Result:** ✅ PASS-with-deviation (view correct; no LinkedIn audience data for MTV — test-data gap)

## Steps
1. Brand > Audience for MTV, channel **LinkedIn** (needed a reload with full `from/to` params — first nav stuck on skeleton; see Notes).
2. Basic View rendered the **LinkedIn-specific audience tiles**: **Followers: Job Function, Followers: Industry, Followers: Seniority, Followers: Staff Count Range** (LinkedIn-only demographics).
3. Toggled **View → Authorized Data** to check for data.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| LinkedIn Basic View loads | LinkedIn-specific demographic tiles render | Job Function / Industry / Seniority / Staff Count Range tiles present | ✅ |
| Channel isolation | LinkedIn selected in channel bar | `channels=linkedin`; LinkedIn icon active | ✅ |
| Data populates | Audience demographics show values | **"There is no data available"** in Public *and* Authorized view | ⚠️ no data (test-data gap) |

## Notes / automation learning
- The **LinkedIn Basic View structure is correct** — the tile set (Job Function/Industry/Seniority/Staff Count Range) is unique to LinkedIn and confirms the right layout loads. The empty state renders cleanly. MTV on Adam Orfei has **no LinkedIn audience data** (Public or Authorized) — a test-data gap, not a product defect.
- **Nav quirk:** navigating to Brand>Audience without `from/to` left the sub-nav stuck on skeleton (~25s); reloading with the full URL (incl. `from`/`to`/`perspective=extended`) painted it. Fold into brand-audience-nav skill: always include the date params.

## Bugs filed
_None (test-data gap)._
