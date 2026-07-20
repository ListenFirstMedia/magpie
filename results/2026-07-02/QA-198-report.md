# QA-198 — TWC Exports - Absolute dates

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-198 · Priority: Critical (P2)
- **Result:** **PASS** (all in-scope assertions A1–A9; A10 Google Sheets out of scope).
- **Account:** Disney Ad Sales (account_id=634) · TWC report story `155506`
- **Skill:** time-window-comparison-run

## Known bugs checked (pre-run)
- `bug-history.md`: 0 open; 22 closed (incl. APPS-54189 "TWC Response Rate reload-error tile", APPS-49531/50403 export-not-working). None open. The reload-error-tile pattern appeared transiently this run (see below) but cleared — not a reproduced defect.

## Steps executed
1. Reporting → Time Window Comparison (Disney Ad Sales). ✅
2. Absolute Dates; default range Jun 25 – Jul 1, 2026. ✅
3. Added 4 brands (exact, Rule 1): Disney Channel, CBS News, CNN, **FOX News** (renders "FOX News"). ✅
4. Datapoints: New Followers, Facebook New Fans, Instagram Follower Growth Rate. ✅
5. Run Report → story `155506`. ✅
6–8. Export → CSV / TSV / XLS, verified on disk. ✅ (GS out of scope, skipped.)

## Reload-error recovery (per the reload rule)
On first render, the **New Followers** and **Instagram Follower Growth Rate** graph+table tiles showed *"This tile failed to load. Please try again."* (4 `.error-data-link` tiles). The initial CSV/TSV/XLS therefore had those two columns empty (invalid). **Recovery = full-page reload only (no per-tile Reload clicks):** it cleared on the **2nd full-page reload**, all tiles loaded, and the exports were re-taken with complete data.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | GS/TSV/CSV/XLS options available | All 4 present | ✅ PASS |
| A2 | Brands/datapoints in report order | Disney Channel→CBS→CNN→FOX; cols in selection order | ✅ PASS |
| A3 | Only selected datapoints | Cols = New Followers, Facebook New Fans, IG Follower Growth Rate | ✅ PASS |
| A4 | Dates match report | 06/25/2026–07/01/2026 (7 days × 4 brands = 28 rows) | ✅ PASS |
| A5 | Rate % displays as float | IG Follower Growth Rate = raw float e.g. `0.00010309844266139233` | ✅ PASS |
| A6 | No en-dash in export | 0 en-dashes | ✅ PASS |
| A7 | Exports match report | Spot-checks (Disney NF 1571, FB New Fans 611, CBS NF 12708, IG rate) present on-screen | ✅ PASS |
| A8 | TSV == CSV | Identical (29 rows) | ✅ PASS |
| A9 | XLS == CSV | Identical (29 rows, header + values) | ✅ PASS |
| A10 | GS == CSV | OUT OF SCOPE (Google 2FA) — skipped | — |

## Evidence (post-reload, valid)
`.playwright-out/Disney-Channel---Time-Window-Comparison---Jun-25-2026---Jul-1-2026.{csv,tsv,xlsx}` — all 3 metrics populated, CSV=TSV=XLS.

## Notes / findings
- **Reload-error tiles are transient** — cleared on the 2nd full-page reload (per-tile Reload clicks did nothing). A report exported while tiles are errored has empty columns → re-export after reload.
- Rate metric serialized as a raw float (not a `%` string) — consistent with known-quirks.
- "Fox News" brand renders as "FOX News".

## Bugs filed
None.
