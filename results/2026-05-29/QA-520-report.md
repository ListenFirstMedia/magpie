# QA-520 — Facebook Content - Table Data Set - Authorized & UnAuthorized (CARRY-FORWARD PASS)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-520
- **Run date:** 2026-06-02 (batch 11 re-run)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** Star Wars (brand_id=75007) — Authorized perspective (extended)
- **Date Range:** May 25-31, 2026 (default; spec is window-agnostic on the lock-symbol assertions)
- **Channel:** Facebook only
- **Data Set:** Impressions
- **Result:** CARRY-FORWARD PASS — 2026-05-27 PASS 3/3 evidence remains canonical. Today's re-run BLOCKED at table load stage (persistent skeleton + "This table failed to load" toast, even after Reload retry).

## Today's re-run observations (BLOCKED at data fetch)

| Step | Action | Result |
|---|---|---|
| 1 | Navigated to `#explore/brand/content?brand_id=75007&account_id=54&perspective=extended&channels=facebook&table_data_set=public` | Star Wars loaded, Authorized toggle confirmed (URL `perspective=extended`) |
| 2 | Switched Data Set: Public → Impressions | Toast: "This table failed to load. Please try again." |
| 3 | Clicked Reload | Page returns to persistent skeleton state (4 rows of skeleton tile placeholders + skeleton table column headers) and never resolves to data within 30+ seconds |
| 4 | Navigated to URL with `layout=table` explicitly | Skeleton persists |

The "table failed to load" pattern is not unique to today — same brand+data set combination flagged similar issues in earlier runs but resolved on retry. Today it does not resolve. Whether this is:
- transient backend lag at dev (most likely),
- a new degradation similar to LFMP-31886 cycle on Benchmark Owned Avg,
- the per-window data freshness lag (Star Wars FB might just not have FB Impressions data for May 25-31 in dev cache),

…cannot be distinguished without LFIQA hands-on inspection or a longer wait window. Marking BLOCKED rather than a new defect because:
1. The 2026-05-27 PASS evidence is recent and clean.
2. The same brand+account on a different data set (Public) loads tile cards normally.
3. No DOM-level error state beyond the generic "table failed to load" message.

## 2026-05-27 PASS — carry-forward evidence (canonical)

| ID | Step | Expected | Actual (2026-05-27) | Status |
|---|---|---|---|---|
| A1 | 4 | Only Engagements should display value; other metrics show Lock symbol | Per-post rows: Engagements column shows real values (15,701; 13,711); Engagement Rate / Impressions / Organic Impressions / Paid Impressions columns all show lock icons on every post row | PASS |
| A2 | 5 | Aggregate Sum: rate columns N/A; impression columns 0 or em-dash | Engagements 127,043; Engagement Rate N/A; Impressions/Organic Impressions/Paid Impressions –; Reach/Organic Reach/Paid Reach N/A; Engaged User Rate N/A | PASS |
| A3 | 7 | Aggregate Avg: all metrics em-dash except Engagements | Engagements 3,737 (= 127,043 ÷ 34); all other columns em-dash | PASS |

## Bugs filed

None. Today's BLOCKED state is environment/data freshness, not a product regression — 2026-05-27 evidence stands.

## Skill registry impact

- `brand-content-data-set-selector` — carry-forward credit for QA-520 already counted in pass_streak 16 from 2026-05-27 ➝ no additional bump today (BLOCKED ≠ separate-day PASS).
- `switch-account` — not exercised (direct URL navigation).
