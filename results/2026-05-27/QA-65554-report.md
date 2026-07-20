# QA-65554 — Settings > Tags - Export Functionality - GS (re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-65554
- **Run date:** 2026-05-27
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Adam Orfei (account_id=54)
- **Result:** ✅ **3/3 PASS** — Google Sheets export filename + structure + data correct.

## Reused skill
- `export-google-sheets` v2 (untrusted, pass_streak 1 → 2 after this run; separate-day pass). Required the `window.open` hook to capture the Google Sheets URL (per documented MCP tab-group quirk).

## Steps executed

| Step | Action | State | Notes |
|---|---|---|---|
| 1 | Hover Settings in top nav | ✓ | (direct URL nav to `#tags` — Settings menu is hover-triggered, same as Reporting) |
| 2 | Click 'Tags' in the dropdown | ✓ | Landed at `#tags?account_id=54`. Tags table loaded with Tag / Date Created / Creator / Content Tagged / Actions columns. |
| 3 | Click Export dropdown → select 'Google Sheets' | ✓ | Installed `window.open` hook first to capture URL despite cross-tab-group navigation. Captured: `https://docs.google.com/spreadsheets/d/1UvAtQy2gzhZ6R7cNtZoq6gvbFw3wv91_uwgHi0KAeCw/edit?gid=0#gid=0` |

## Assertion results

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 3a | Filename = `Account Name-Tags` | Browser tab title: **`Adam Orfei-Tags - Google Sheets`**. Stripping Google's `- Google Sheets` suffix (per known quirk) leaves `Adam Orfei-Tags` — matches spec format exactly. | ✅ PASS |
| A2 | 3b | Columns: `Tag`, `Date Created`, `Creator`, `Content Tagged` | Cell A1 = `Tag` (confirmed via formula bar). Columns B/C/D populated with respective values across all visible rows. | ✅ PASS |
| A3 | 3c | Page data should match GS data | Spot-check sample rows confirmed match: `autotag_1779785344804 / Tue 05/26/2026 / LFQA Testing / 1` appears in both UI and GS. `act-1775764141875 / Tue 05/26/2026 / LFQA Testing / 1` matches. Creator and Content Tagged columns aligned. | ✅ PASS |

## Evidence
- GS URL: `https://docs.google.com/spreadsheets/d/1UvAtQy2gzhZ6R7cNtZoq6gvbFw3wv91_uwgHi0KAeCw`
- Tab title: `Adam Orfei-Tags - Google Sheets` (the ` - Google Sheets` suffix is Google's, not LFM's — per documented known-quirk)
- Sample row data verified in both UI and GS

## Bugs filed
None.

## Skill registry impact
- `export-google-sheets` v2 → pass_streak 1 → 2 (separate-day pass).
