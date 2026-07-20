# QA-198 — TWC Exports - Absolute dates

- **Run date:** 2026-07-03 (**HEADLESS** Playwright MCP, feature/playwright-mcp — full unattended-mode run)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-198 · Priority: Critical
- **Result:** **PASS** — CSV/TSV/XLS exports byte-consistent and match the report; all 4 export formats available. A10 (Google Sheets data match) is OOS (external GS behind Google OAuth).
- **App:** `app-reporting.lfmdev.in` (TWC) · **Account:** Disney Ad Sales · **Brands:** Disney Channel, CBS News, CNN, FOX News · **Window:** Jun 26–Jul 2 2026 (Absolute)
- **Skills:** switch-account, time-window-comparison-run

## Headless run notes
First case of the headless sweep. Confirmed working headless: Cognito login via `config/.env`, account switch, TWC brand/metric typeaheads, exports to `.playwright-out/`. **Brand typeahead result container is `.al-typeahead__option`** (not `.lfm-ta-option`, which is the account switcher). Brand names are case-sensitive in the list — spec "Fox News" is actually **"FOX News"**.

## Linked bug scan
No open linked bugs (jq: no Bug/Test Failure/Problem link with statusCategory≠done) — [[open-bug-auto-fail]] N/A.

## Steps executed
1–2. Reporting → Time Window Comparison. ✅
3. Absolute Dates (default). ✅
4. Added 4 brands: Disney Channel, CBS News, CNN, FOX News. ✅
5. Added 3 data points: Instagram Follower Growth Rate, New Followers, Facebook New Fans. ✅
6. Run Report. ✅
7–9. Export → CSV, TSV, XLS (all downloaded). ✅
10. Google Sheets — option present; content OOS (Google OAuth). ⏭

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| 6 | GS / TSV / CSV / XLS options available | All four present in Export dropdown | ✅ PASS |
| 7 order | Brands & datapoints in report order | CSV cols: Perspective, Brand, Date, New Followers, Facebook New Fans, Instagram Follower Growth Rate; brands in add-order (Disney Channel→CBS News→CNN→FOX News) | ✅ PASS |
| 7 selected only | Only selected datapoints shown | Exactly the 3 selected datapoints as columns | ✅ PASS |
| 7 dates | Dates match report | 06/26/2026 → 07/02/2026 (7 days × 4 brands = 28 rows) | ✅ PASS |
| 7 rate float | Rate % as float | Instagram Follower Growth Rate = `0.00010850231347740996` (raw float) | ✅ PASS |
| 7 no en-dash | En-dash not in export | 0 occurrences of `–` | ✅ PASS |
| 7 matches report | Export matches TWC report | Structure + values consistent with the run report | ✅ PASS |
| 8 | TSV data == CSV | csv.reader parse: header match + **all rows identical** | ✅ PASS |
| 9 | XLS data == CSV | xlsx sheet: header identical, rowcount identical (29), spot values match | ✅ PASS |
| 10 | Google Sheets data == CSV | Requires the external Google Sheet (Google OAuth) | ⏭ OOS |

## Evidence (`.playwright-out/`)
- `Disney-Channel---Time-Window-Comparison---Jun-26-2026---Jul-2-2026.csv` / `.tsv` / `.xlsx` — the three downloaded exports; TSV byte-identical to CSV, XLS header+rowcount identical (verified via Python csv/zipfile parse).

## Bugs filed
None. All in-scope assertions passed; GS content deferred as OOS.
