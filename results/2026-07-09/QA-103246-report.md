# QA-103246 — Brand > Content - Daily Post Analysis Modal - Export - PNG & Google Sheets

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account/Brand:** Adam Orfei (account_id=54) · MTV (brand_id=4018) · Brand > Content · range May 10–20, 2026 (includes the 2026-05-16 TikTok endash day)

## Verdict: PASS (Google Sheets half out of scope for this track)

## Known bugs checked
No **open** linked bug (DATA-12209, the TikTok-endash probe, is not currently linked/open — likely resolved as a ticket; the endash behavior is still observed and is expected, see A7).

## Flow
Brand > Content (MTV) → opened a **TikTok** post's Daily Analysis (post published Fri May 15, 2026) → switched viz to **Bar** → Export ▾ → **PNG** → verified file → closed modal.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | PNG filename `[Brand]-Daily Content Analysis-[Graph Type]-YYYY-MM-DD-YYYY-MM-DD.png` | `MTV-Daily Content Analysis-Bar-2026-05-15-2026-05-20.png` (96 KB) | PASS |
| A2 | ListenFirst logo + brand name in PNG header | LISTENFIRST logo top-left + "MTV" header | PASS |
| A3 | Date range below the chart | "Daily Content Analysis / **Date: May. 15, 2026-May. 20, 2026**" | PASS |
| A4 | PNG matches modal display | Bar chart, 6-metric legend (Engagements/Reactions/Comments/Shares/Video Views/Video Response Rate), bars for May 15/17/18/19/20 and **no bar for May 16** — matches the on-screen Bar view | PASS |
| A5 | GS filename pattern | **out of scope** (Google Sheets export excluded from this track) | N/A |
| A6 | GS row data matches modal | **out of scope** | N/A |
| A7 (probe) | 2026-05-16 TikTok day shows endash (DATA-12209) | modal table shows **"–"** for Engagements & Reactions on May 16; PNG shows **no bar** for May 16 — endash/no-data behavior reproduced (expected; DATA-12209 not open) | PASS (probe) |
| A8 | Close button dismisses modal | `crud-modal-close` (× ) closed the modal | PASS |

## Method notes
- The modal has **two** export controls: a `csv_export` button (opens the "Export Select Data Sets" CSV/Google-Sheets dialog) and a separate **`export-dropdown-button`** (Export ▾) offering **PNG / CSV / Google Sheets** — PNG is under the latter. The `csv_export` button sits clipped at the viewport top (behind the modal header) and needs event dispatch, not a trusted click.

## Evidence
- `.playwright-out/MTV-Daily-Content-Analysis-Bar-2026-05-15-2026-05-20.png`
- `QA-103246-modal.png` (table w/ May 16 endash), `QA-103246-export.png` (data-sets dialog)

## Bugs filed
None.
