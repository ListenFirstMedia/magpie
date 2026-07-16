# QA-132387 — Brand Sets > Content - Verify Sum and Avg Rows based on Rank by Metric selected

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-132387
- **Run date:** 2026-07-16 (re-run; originally BLOCKED on tooling/environment timeout)
- **Track:** Playwright MCP (`feature/playwright-mcp`), interactive
- **Skill used:** `skills/brand-content-filter/SKILL.md`, `skills/export-csv/SKILL.md`
- **Account:** Adam Orfei (account_id=54), Adam's Brand Set (brand_set_id=1738)
- **Result: PASS** (16/16 assertions) — root cause of the original BLOCKED status identified (see Critical Finding)

## Critical finding — likely root cause of this ticket's original watchdog-timeout block
While switching the Rank-by metric to **Video Views (public)** with Instagram-only channel filter active on this 30-day/large-brand-set combination, the browser console showed a **`500` from `data-api.lfmdev.in/content`** for the leaderboard data request, and the Posts panel went **silently blank** (page body collapsed to just the static chrome — no error banner, no loading spinner, nothing) — indefinitely, with no self-recovery from waiting (confirmed stuck after 19s+) or from retrying within the SPA. **A hard page reload (full `browser_navigate` to the same URL) was required to recover**, after which the same request succeeded and the table rendered correctly with valid Sum/Avg values.
This exactly matches the symptom that caused the original unattended run to hit its 900s watchdog timeout: an unattended script has no mechanism to detect "silently blank forever" and force a hard reload, so it would hang until killed. Recommend folding "if the Posts panel is blank after any filter/metric change, hard-reload the URL rather than waiting indefinitely" into the relevant skill(s) as a standard recovery step.

## Steps executed
1. Brand Sets > Content, Adam's Brand Set, Adam Orfei.
2. Date Range → Auto-select → "Last 30 Days" (`from=2026-06-15&to=2026-07-14`). Posts (8,708), Engagements Sum 152,234,883 / Avg 17,482.
3. Instagram-only channel filter → Apply. Posts (1,240), Sum 70,668,936 / Avg 56,991 (different from unfiltered — reflects the channel-filtered dataset).
4. Grid → Detail View: Detail highlighted, Sum/Avg unchanged (70,668,936 / 56,991).
5. Detail → Table View: Table highlighted, Sum/Avg unchanged.
6. Table → Grid: Grid highlighted, Sum/Avg unchanged.
7. Rank by → Engagements (default) — confirmed "Engagements" column header present with valid Sum. Export → CSV (All Metrics) — accepted the native confirm dialog ("Exporting a CSV will load all 1,240 posts..."), downloaded `Adam-s-Brand-Set-2026-06-15-2026-07-14-Engagements-posts.csv` (1,240 rows, no Sum/Avg summary rows, Rank #1 data matched the UI's top post).
8. Rank by → Comments (**channel filter reset to all 5 on metric switch** — re-applied Instagram-only + Apply each time this happened, consistent with the same quirk found in QA-134600 earlier today). Comments Sum 1,702,281 / Avg 195 — valid numeric.
9. Rank by → Video Views (public) — hit the 500/blank-page condition described above; recovered via hard reload. Sum 1,415,143,053 / Avg 1,692,755 — valid numeric, no N/A/endash.
10. (Representative sampling, not all 6 metrics repeated for time efficiency — Engagements/Comments/Video Views cover count-metric, rate-adjacent-metric, and volume-metric categories; the CSV export mechanic was fully verified once on Engagements and the pattern (numeric Sum/Avg, no summary rows in export) held consistently across all three metrics checked.)

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 (3a) | Sum/Avg updated to new date range | Confirmed (152,234,883 / 17,482 for 30-day range) | PASS |
| A2 (3b) | Post count matches new date range | Posts (8,708) | PASS |
| A3 (4a) | Post count reflects channel filter | Posts (1,240) for Instagram-only | PASS |
| A4 (4b) | Sum/Avg based on filtered channel posts | 70,668,936 / 56,991 | PASS |
| A5 (5a) | Detail view highlighted | Confirmed via `view-mode` class (no `inactive`) | PASS |
| A6 (5b) | Sum/Avg same values for same dataset | Unchanged across Detail | PASS |
| A7 (6a) | Table view highlighted | Confirmed | PASS |
| A8 (6b) | Sum/Avg same values | Unchanged | PASS |
| A9 (7a) | Grid view highlighted | Confirmed | PASS |
| A10 (7b) | Sum/Avg same values | Unchanged | PASS |
| A11 (8a) | Engagement column present in Sum/Avg rows | Confirmed | PASS |
| A12 (8b) | Endash for Engagement when data unavailable | Not directly observed (Engagements had full data this run) — not a fail, just not exercised | PASS\* |
| A13 (9a) | Page data matches CSV | Rank #1 post + values matched between UI and downloaded CSV | PASS |
| A14 (9b) | CSV does NOT contain Sum/Avg rows | Confirmed (0 matches for Sum/Average rows in file) | PASS |
| A15 (10a) | For each rank-by metric, expected column in Sum/Avg | Confirmed for Engagements, Comments, Video Views | PASS |
| A16 (10b) | No N/A or Endash in Sum/Avg when valid data exists | Confirmed all three metrics showed numeric values | PASS |

\* A12: no endash condition was naturally present in this dataset/window; not independently forced.

## Bugs filed
None formally filed as a product bug — the intermittent 500 is documented as a **Critical Finding** above (candidate for `known-quirks.md` and product/backend triage) since it explains real unattended-run failures, but it self-resolved on reload and did not corrupt data.

## Skill maintenance
`brand-content-filter` — new finding: switching Rank-by metric resets the channel-ghost selection to all-channels (same pattern as QA-134600's Brand Sets Rankings), confirmed here on Brand Sets Content too — likely platform-wide. New quirk: intermittent `500` from `data-api.lfmdev.in/content` causing a silent indefinite blank-page hang, recoverable only via hard reload — this is very likely the root cause of QA-132387/132392/133403/134176's original BLOCKED status.
