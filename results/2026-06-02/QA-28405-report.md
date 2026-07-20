# QA-28405 — Brand Content - CSV - All Data set - Video Views (re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-28405
- **Run date:** 2026-06-04 (QA-4325 batch-4)
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** Hulu (brand_id=11003)
- **Channels:** FB + Twitter + IG + TikTok + YouTube (default multi-channel set)
- **Date range:** May 27 — Jun 2, 2026 (default 7-day)
- **Perspective:** Public Data (default)
- **Result:** **PASS** — All Data Sets CSV export verified end-to-end on disk; Video Views column present and sum/avg match UI.

## Spec
See `/Users/yashsharma/git/magpie/testcases/english/QA-28405.md`. "All Data set" interpretation confirmed in-platform: the Export modal allows checking multiple Data Sets simultaneously (Public + FB Only: Reactions + Twitter Only: Engagements & Follows + YouTube Only: Basic), and the notification message reads "Your Content Export with **All Data Sets** for Hulu …" — matching the spec wording.

## Reused skills
- `brand-content-data-set-selector` (untrusted, pass_streak 23 → bump to 24)
- `export-csv` v2 (untrusted, pass_streak 18 → bump to 19) — CDN bell-link + fetch(credentials:include) pattern reused successfully
- `switch-account` (untrusted, pass_streak 14 → bump to 15) — Adam Orfei active throughout

## Steps executed
| Step | Action | State |
|---|---|---|
| 0 | Search top nav `Hulu` → pick from Results (Rule 1) | PASS — loaded brand_id=11003 (Hulu) on Adam Orfei |
| 1 | Navigate to Brand > Content for Hulu (URL nav) | PASS — Posts (89) loaded, View=Public Data default |
| 2 | Open Data Set dropdown to inspect options | PASS — dropdown lists `Public` (Cross-Channel), `Facebook Only: Reactions`, `Twitter Only: Engagements & Follows`, `YouTube Only: Basic` (Channel-Specific), plus 7 Custom Data Sets |
| 3 | Open Export modal (top-right Export button) → View toggle = CSV | PASS — modal title "Export Select Data Sets" |
| 4 | Check all 4 ListenFirst Data Sets (Public + 3 channel-specific) | PASS — checkboxes flipped |
| 5 | Click OK | PASS — "Your export has successfully been queued" green toast |
| 6 | Wait for export to land, click bell icon | PASS — Recent Activity shows new entry "All Data Sets Export — Your Content Export with All Data Sets for Hulu from May. 27, 2026 to Jun. 02, 2026 is now ready." |
| 7 | Extract CDN URL: `https://analytics-cdn.lfmdev.in/293899-419fa1d5604f4f3565da97b401a18856.csv` | PASS |
| 8 | `fetch(url, {credentials:'include'})` + save to disk | PASS — 200 OK, 36,404 bytes, saved as `Hulu-Brand Content-2026-05-27-2026-06-02-all-data-sets.csv` |
| 9 | Verify CSV structure | PASS — Row 1 = Data Set labels (Public/FB Only/Twitter Only/YouTube Only); Row 2 = column headers including `Video Views` (col 20), `Video Response Rate` (col 21), `YouTube Video Views` (col 36) |
| 10 | Verify Sum Video Views = 26,449,739 (on-screen) vs CSV total | PASS — Python csv parse: Sum = 26,449,739 (exact match), Avg = 367,357 (exact match), 72 rows with VV |
| 11 | Spot-check Row 3 (Rank 1, Hulu IG Reel, Wed May 27 03:01 PM) | PASS — Video Views = 5,965,747 (exact match with on-screen post #1) |

## Assertions table

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | Data Set dropdown | Contains Video Views capable data set | `Public` is the cross-channel data set that includes Video Views/Video Response Rate columns; channel-specific sets (FB/Twitter/YouTube) add their own video metrics | PASS |
| A2 | Posts table loads | Posts (N>0), no skeleton-hang | Posts (89), Sum/Avg row rendered with Video Views = 26,449,739 / 367,357 | PASS |
| A3 | Export → CSV enabled | Queued export works | Export modal opened, OK clicked, queue toast appeared | PASS |
| A4 | Filename pattern | Sensible filename | Bell-link CDN file = `293899-419fa1d5604f4f3565da97b401a18856.csv` (hashed CDN pattern); platform-level message labels the export "All Data Sets Export for Hulu from May 27 to Jun 2"; save-as default not surfaced via the bell link (per BC-2 history this is expected CDN behavior) | PASS |
| A5 | CSV contains Video Views | Video Views + Video Response Rate columns | Col 20: `Video Views`, Col 21: `Video Response Rate`, Col 36: `YouTube Video Views` | PASS |
| A6 | Row 1 Data Set label row | Row 1 labels each metric column by its data set | Row 1 = `Data Set,,,...,,Public,Public,...,Facebook Only: Reactions,...,Twitter Only: Engagements & Follows,...,YouTube Only: Basic,YouTube Only: Basic,YouTube Only: Basic` | PASS |

## Bugs filed
None new. Spec assertion "All Data set" PASS — interpreted via platform terminology as the multi-data-set CSV export (all 4 ListenFirst-created data sets checked simultaneously).

## New findings (non-blocking)
- Confirmed platform-level naming: the Recent Activity notification reads `All Data Sets Export — Your Content Export with All Data Sets for <Brand> from <from> to <to> is now ready.` This is the canonical product wording for what QA-28405 calls "All Data set".
- CSV row structure: Row 1 = Data Set groupings (empty for the 14 base columns Rank…Text, then prefixed per metric); Row 2 = column headers. This is consistent with the QA-109062 Custom-Data-Set CSV pattern documented in `export-csv` v2 skill.

## Files
- `testcases/english/QA-28405.md` (spec)
- `runs/2026-06-02/QA-28405-report.md` (this report)
- `/Users/yashsharma/Downloads/Hulu-Brand Content-2026-05-27-2026-06-02-all-data-sets.csv` (36,404 bytes, verified end-to-end)
- Scratch copy: `outputs/qa-28405/hulu-all-data-sets.csv`
