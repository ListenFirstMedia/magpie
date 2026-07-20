# QA-844 — TikTok Content - Exporting Tags — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV (4018) · **Channel:** TikTok · **Window:** May 12 – Jun 11 2026 · **Perspective:** Authorized (extended)
- **Skills:** brand-content-data-set-selector, export-csv v2
- **Result:** ✅ PASS (6/6) — **upgrades the 2026-06-05 PARTIAL/NOT-VERIFIED** (export queue + tag column both verified end-to-end this run)

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | TikTok-only filter active | Channels bar shows only TikTok highlighted | ✅ |
| A2 | Posts(N>0) for TikTok | Posts(163) | ✅ |
| A3 | CSV 200 OK + comma-separated (no TSV regression) | fetch 200, `binary/octet-stream`, comma-separated, 163 data rows | ✅ |
| A4 | CSV header includes Tags/Content Tags | Tags export as **named columns** — existing tag `hi` present as its own column (col index 25) | ✅ |
| A5 | Tagged TikTok row shows the tag string | Rank-3 TikTok row: `hi` cell = `"hi"` (non-empty, equals applied tag) | ✅ |
| A6 | Non-tagged rows: tag cell empty (not `null`) | 162/163 rows blank in the `hi` column (truly empty, not literal null) | ✅ |

## Evidence
- Queued Select Data Sets export surfaced in Recent Activity bell ("…for MTV from May. 12 to Jun. 11, 2026 is now ready. Download file") — **the prior run's blocker (export never surfacing) did NOT recur.**
- CSV fetched in-page with `credentials:'include'` (Rule 6). Row 1 = Data Set labels (Public ×7); Row 2 = column headers (Rank, Date, …, Video Response Rate, **hi**); rows 3+ = 163 posts.
- Tag-column mechanic: each applied tag becomes a column whose header is the tag name; cell = tag name for tagged posts, blank otherwise.

## Notes / maintenance
- **New learning (export-csv):** Brand>Content tag export represents tags as one column **per tag name** (header = tag), value = tag name on tagged rows, blank otherwise — not a single delimited "Tags" column. Worth folding into the export-csv skill.
- No mutation performed — an existing `hi` tag (leftover test data on one TikTok post) was reused; Tag modal opened and closed via Done with no change.
- Minor: the Tag modal opened from the visually-first card showed `hi`, but the CSV's `hi`-tagged row is rank 3 — grid Engagements-sort vs export-rank ordering nuance; immaterial to the assertions.

## Bugs filed
_None._
