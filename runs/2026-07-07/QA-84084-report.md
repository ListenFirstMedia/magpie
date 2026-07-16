# QA-84084 — Reporting > Data Studio - Post Level Metrics - Data QA

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-84084
- **Run date:** 2026-07-07 (Playwright MCP track)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV
- **Skill used:** `data-studio-post-level-run` (v2, untrusted) — this is the skill's origin ticket (v1 was drafted from this exact case)

## Steps executed

1. Reporting → Data Studio → **Post Level** toggle.
2. Add a Brand: typed and selected **MTV** (exact match).
3. Select Metrics → searched and checked: **YouTube Video Engagements**, **YouTube Video Likes**, **YouTube Video Comments** (all three confirmed added to the Post Level Metrics table).
4. Clicked **Go** → report built (report_id=301117), default 7D window, Lifetime mode.
5. Read the data grid via `.al-table__row` → `.al-table__cell` (per the skill's documented selectors — this is NOT a native `<table>`).

## Known platform limitation (re-confirmed, not a new finding)

Per the skill's documented quirk: despite the "Post Level" label, this report **aggregates by metric across all posts** (Metric / Brand / Sum / Average / one column per day) — there is no per-individual-post row breakdown available anywhere in this report's UI. The spec's literal wording ("for every post row, compute Likes + Comments") cannot be executed against a per-post grid because that grid doesn't exist. The math identity is instead verified against the **Sum** column and **every populated daily column**, which is the accepted equivalent verification per the skill's `v1` precedent (originally confirmed 2026-05-13, Sum=433/Likes=413/Comments=20).

## Assertion

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | `YouTube Video Engagements == YouTube Video Likes + YouTube Video Comments` for every row/column | Verified across **Sum + all 7 daily columns** (2 columns had no data in either metric, correctly skipped as `–`/`–`, not counted as a mismatch): every populated column satisfies the identity exactly. | **PASS** |

## Evidence

Raw grid (`.al-table__cell` per row):
```
YouTube Video Engagements | MTV P | Sum 1,058 | Avg 151 | 122 | – | 101 | 44 | 791 | – | –
YouTube Video Likes       | MTV P | Sum   994 | Avg 142 | 118 | – |  99 | 40 | 737 | – | –
YouTube Video Comments    | MTV P | Sum    64 | Avg   9 |   4 | – |   2 |  4 |  54 | – | –
```

Identity check (Engagements = Likes + Comments):
| Column | Likes | Comments | Likes+Comments | Engagements | Match |
|---|---|---|---|---|---|
| Sum | 994 | 64 | 1,058 | 1,058 | ✓ |
| Day 1 | 118 | 4 | 122 | 122 | ✓ |
| Day 2 | – | – | (skip) | – | ✓ (both missing, consistent) |
| Day 3 | 99 | 2 | 101 | 101 | ✓ |
| Day 4 | 40 | 4 | 44 | 44 | ✓ |
| Day 5 | 737 | 54 | 791 | 791 | ✓ |
| Day 6 | – | – | (skip) | – | ✓ |
| Day 7 | – | – | (skip) | – | ✓ |

Zero mismatches across 8 checked columns (Sum + 7 days). Also cross-verified Σ(daily) == Sum independently for all three metrics (1058=122+101+44+791; 994=118+99+40+737; 64=4+2+4+54) — internal consistency holds.

## Problems encountered

None beyond the already-documented per-post-vs-per-metric report-type limitation (not a new finding — re-confirms the skill's existing quirk note). Metric-tree checkbox clicks by label text worked cleanly on the first attempt for all three metrics.

## Skill updates

None needed — this run is a clean reconfirmation of `data-studio-post-level-run` v2's existing guidance; bumping pass_streak only.

## Bugs filed

None. Math identity holds exactly.
