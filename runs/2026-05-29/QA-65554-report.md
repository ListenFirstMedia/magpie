# QA-65554 — Settings > Tags - Export Functionality - GS (re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-65554
- **Run date:** 2026-06-02 (batch 12/12)
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Adam Orfei (account_id=54)
- **Priority:** P4 (Minor)
- **Result:** PASS 3/3 (re-confirmed; consistent with batch 2026-05-27 run).

## Reused skill

`export-google-sheets` v2 — pass_streak +1 (now 3 → eligible for promotion to stable).

## Steps executed

| Step | Action | State | Notes |
|---|---|---|---|
| 0 | Confirmed Adam Orfei login (account_id=54) | OK | Avatar `Y` (Yash) + Account label `Adam Orfei`; nav shows Recent Searches Adam Orfei, ListenFirst Media, etc. |
| 1 | Hover Settings → Tags (direct URL `#tags?account_id=54`) | OK | Settings menu hover-triggered; direct URL is canonical equivalent. |
| 2 | Click Export dropdown → Google Sheets | OK | `.option__row.option--gs` clicked. Google Sheets opened in cross-tab-group tab `tabId=1804437776`. |

## GS file evidence (live verification)

- GS URL: `https://docs.google.com/spreadsheets/d/16jiaPh4ImjYUfgRI9XFYy2zoOI2UKx91MlbmSbQGm2c/edit?gid=0#gid=0`
- Browser tab title: **`Adam Orfei-Tags - Google Sheets`** (Google's `- Google Sheets` suffix is platform-added per known-quirks).
- A1 = `Tag` (confirmed via Google's formula bar showing `Tag`).
- A1:D1 visible row contents: `Tag | Date Created | Creator | Content Tagged`.
- Sheet name: `Sheet1`.

## Page-vs-GS row alignment (spot-check)

| UI Row | Tag | Date Created | Creator | Content Tagged | GS match |
|---|---|---|---|---:|---|
| 1 | `qa_11605_testing_2026-05-31` | Tue 06/02/2026 09:24 AM | LFQA Testing | 1 | Row 2 (`qa_11605_testin... / Tue 06/02/2026 / LFQA Testing / 1`) |
| 2 | `tag_1780369901413` | Tue 06/02/2026 03:11 AM | LFQA Testing | 1 | Row 3 (`tag_1780369901... / Tue 06/02/2026 / LFQA Testing / 1`) |
| 3 | `autotag_1780369809912` | Tue 06/02/2026 03:10 AM | LFQA Testing | 1 | Row 4 (`autotag_178036... / Tue 06/02/2026 / LFQA Testing / 1`) |
| 6 | `cat` | Mon 06/01/2026 11:33 PM | * | 1 | Row 7 (`cat / Mon 06/01/2026 / * / 1`) |
| 9 | `iconic` | Mon 06/01/2026 12:23 PM | Suhail Khan | 2 | Row 10 (`iconic / Mon 06/01/2026 / Suhail Khan / 2`) |

All five spot-checks match (tag string, date, creator including the `*` creator anomaly, and Content Tagged count including the `2` outlier).

## Assertion results

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 3a | Filename = `Account Name-Tags` | Browser tab title `Adam Orfei-Tags - Google Sheets`; stripping Google's ` - Google Sheets` suffix = `Adam Orfei-Tags`. Account name is `Adam Orfei`, so filename matches `Adam Orfei-Tags` exactly. | PASS |
| A2 | 3b | Columns include `Tag`, `Date Created`, `Creator`, `Content Tagged` | Row 1 of GS shows A1=`Tag`, B1=`Date Created`, C1=`Creator`, D1=`Content Tagged`. Note: UI also has `Actions` column; GS correctly omits it. | PASS |
| A3 | 3c | Page data matches GS data | 5 spot-check rows including the special-character creator `*` (row 6 `cat`) and a multi-count row (`iconic` → 2) all match. | PASS |

## Bugs filed

None.

## Skill registry impact

- `export-google-sheets` v2 → pass_streak 2 → 3. Promotion to `stable` recommended (3 successful runs across separate days: 2026-05-13, 2026-05-27, 2026-06-02).

## Sources

- [QA-65554 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-65554)
