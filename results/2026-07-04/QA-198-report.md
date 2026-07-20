# QA-198 — TWC Exports - Absolute dates

- **Run date:** 2026-07-04 (headless, unattended, Playwright MCP)
- **Branch:** feature/playwright-mcp
- **Account:** Disney Ad Sales (account_id=634)
- **Skill reused:** [time-window-comparison-run](../../skills/time-window-comparison-run/SKILL.md) v6 (untrusted)
- **Report built:** `#story/time_window_comparison/155546`
- **Verdict:** **PASS** (9/9 in-scope assertions; A10 Google Sheets skipped — out of scope)
- **Open linked bugs (cache 2026-07-03):** None open — ran normally.

## Preconditions
- Logged in programmatically as `lfiqa@listenfirstmedia.com` → `#home` rendered.
- Switched account Hulu (336) → **Disney Ad Sales (634)** via LFIQA menu → Search Account → Results (exact "Disney Ad Sales", not "[Internal] Disney Ad Sales").

## Steps executed
1. Reporting → Time Window Comparison → builder at `#/time_window_comparison`.
2. Verified **Absolute Dates** tab selected by default (`al-view-switcher__option--selected`).
3. Added 4 brands from typeahead **Results**, in order: **Disney Channel**, **CBS News**, **CNN**, **FOX News** (spec "Fox News" renders uppercase "FOX News" — known-quirk, matched case-insensitively).
4. Added 3 data points via metric filter (each exact-match rollup, not channel-specific): **Instagram Follower Growth Rate**, **New Followers**, **Facebook New Fans**. Category counter confirmed Audience & Growth (3/36).
5. Run Report → story 155546. Report header: `Time Window Comparison (Jun 26, 2026 - Jul 2, 2026)`. 3 metric tables rendered (New Followers, Facebook New Fans, Instagram Follower Growth Rate); brand columns Disney Channel / CBS News / CNN / FOX News; 7 daily rows Jun 26 – Jul 2, 2026; no en-dash cells.
6. Export dropdown → confirmed options **Google Sheets · CSV · TSV · XLS**.
7. Export → **CSV** → downloaded to disk (synchronous).
8. Export → **TSV** → downloaded to disk.
9. Export → **XLS** → downloaded to disk (`.xlsx`).
10. Google Sheets — **skipped (out of scope, Google 2FA)**.

## Exported files (on disk, `.playwright-out/`)
| Format | File | Size | Rows |
|--------|------|------|------|
| CSV | `Disney-Channel---Time-Window-Comparison---Jun-26-2026---Jul-2-2026.csv` | 2160 B | 1 header + 28 data |
| TSV | `Disney-Channel---Time-Window-Comparison---Jun-26-2026---Jul-2-2026.tsv` | 1812 B | 1 header + 28 data |
| XLS | `Disney-Channel---Time-Window-Comparison---Jun-26-2026---Jul-2-2026.xlsx` | 22677 B | 29 (1 header + 28 data) |

Header (all formats): `Perspective, Brand, Date, New Followers, Facebook New Fans, Instagram Follower Growth Rate`. 28 data rows = 4 brands × 7 days, all Perspective=Public.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6 | Google Sheets, TSV, CSV, XLS options available | Dropdown showed all 4: Google Sheets · CSV · TSV · XLS | PASS |
| A2 | 7 | Brands & datapoints same order as report screen | Export order Disney Channel→CBS News→CNN→FOX News; metric cols New Followers, FB New Fans, IG Follower Growth Rate — matches report | PASS |
| A3 | 7 | Only selected datapoints displayed | Exactly 3 metric columns (the 3 selected), no extras | PASS |
| A4 | 7 | Dates match report | Export dates 06/26/2026–07/02/2026 (7 days) = report Jun 26–Jul 2, 2026 | PASS |
| A5 | 7 | Rate % displays as float value | IG Follower Growth Rate serialized as raw float (e.g. `0.00010850231…`), in-app shows `0.01%` | PASS |
| A6 | 7 | En-dash not displayed in export | No `–`/`-` cells; every cell populated | PASS |
| A7 | 7 | Exports match TWC report | Spot-checks all match report: CBS News Jun 30 New Followers 117,201; CNN Jul 02 109,920; FOX Jun 28 FB New Fans 19,664; Disney Jun 26 IG rate 0.0001085≈0.01%; Disney Jun 29 0.0000437 = `<0.01%` | PASS |
| A8 | 8 | TSV data matches CSV | TSV byte-content identical to CSV (tab-delimited, unquoted); all 28 rows equal | PASS |
| A9 | 9 | XLS data matches CSV | xlsx 29 rows; header + all values equal CSV (verified Disney Jun 26 1624/633/0.0001085; FOX Jul 01 124284/15251; FOX Jul 02 23131/11196) | PASS |
| A10 | 10 | Google Sheets data matches CSV | **SKIPPED — out of scope (Google 2FA)** | N/A |

## Evidence
- Report values (in-app table): New Followers Disney Channel Jun 26 = 1,624; CBS News Jun 30 = 117,201; CNN Jul 02 = 109,920; FOX News Jul 01 = 124,284. Facebook New Fans FOX Jun 28 = 19,664. IG Follower Growth Rate Disney Jun 29 = `<0.01%`, CBS News Jul 02 = 0.13%.
- CSV/TSV/XLS all cross-verified against the above.
- Screenshots (`.playwright-out/QA-198/`): `builder-4-brands.png`, `report-full.png`, `export-dropdown.png`.

## Notes
- Report date range is the daily-shifting default "last 7 days ending yesterday" (Jun 26 – Jul 2, 2026 on this run); captured from the built report, not hardcoded.
- All Chrome-MCP workarounds obsolete under Playwright (real keystrokes drive the brand/metric typeahead; trusted clicks flip `.controlled-check-box`) — consistent with skill v6.

## Bugs filed
None. All in-scope assertions passed; no product defects observed.
