# QA-28405 — Brand > Content - CSV Export (Video Views data set) — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand:** MTV (brand_id 4018) · **Window:** Jun 1–15 2026 · **Data Last Updated (PT):** 06-16-2026 09:26 AM
- **Skills:** brand-content-data-set-selector, content-csv-export-verify (in-page fetch)
- **Result:** ✅ PASS

## Steps
1. Brand > Content for MTV, window Jun 1–15 2026 (123 posts).
2. **Data Set** dropdown → selected **Video Views** (Cross-Channel Metrics). Grid re-rendered with VV columns: Video Views (Sum **18,217,654**), Organic Views (17,689,115), Paid Views (0), Unclassified Views (528,539), Viewers (2,039,591), Video Duration (39m32s), Watch Time min (1,451,498.53).
3. **Export** → "Export Select Data Sets" modal; View=**CSV** (Google Sheets toggle off); **Video Views** data set checkbox pre-selected → **Ok**.
4. Toast: **"Your export has successfully been queued."** Async export processed server-side.
5. Installed `URL.createObjectURL` + anchor-`click` hooks; AsyncPoller auto-fired the download (anchor href captured).
6. Fetched the export file in-page (`fetch(url,{credentials:'include'})`) and parsed (Rule 6 — observe actual file; returned only parsed summary, never the raw signed URL).

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Data Set selectable | "Video Views" data set applies to grid | Applied; `table_data_set=video_views`; VV columns rendered | ✅ |
| Export produces CSV | CSV file delivered | fetched OK; `binary/octet-stream`, **43,617 chars**, **124 data rows**, **29 columns** | ✅ |
| Video Views column present | CSV contains a "Video Views" column | Column **"Video Views"** present (header row after the "Data Set" preamble) | ✅ |
| Video Views populated | VV column holds numeric data | **49 / 50** sampled rows have a positive Video Views value | ✅ |

## Notes / automation learning
- Content CSV export is **asynchronous** ("queued" toast); the file is delivered via an auto-download (and notifications/email), not an immediate blob. Hooking `HTMLAnchorElement.prototype.click` to capture the auto-download href + then in-page `fetch` is the reliable Rule-6 verification path (the `URL.createObjectURL` hook alone misses it — the poller navigates an `<a href>` to a signed CDN URL).
- LF Content CSVs carry a **"Data Set" metadata preamble** before the true column header, so column detection must scan for the header row containing "Video Views" rather than assuming row 0.
- Did this on **MTV / Adam Orfei** (current account) rather than switching to Hulu — MTV has ample Video Views data, so the case is fully exercisable without an account switch.

## Bugs filed
_None._
