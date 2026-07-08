# QA-1519 — Brand > Content - All Data set - Engagement Breakdown and Clicks set - CSV & GS

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-1519 · Priority: Critical
- **Result:** **PARTIAL PASS** — all in-app export-popup data-set-enablement assertions verified (A6a, A6b, A13a, A13b). The CSV-download (from email) and Google Sheets assertions (A8 filename+columns, A11 GS-match, A15 Clicks CSV columns) are **out of scope on this track** (see below).
- **Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670) · **View:** Table · **Range:** Jun 2 – Jul 1 2026
- **Skills:** brand-content-data-set-selector (stable), brand-content-table-view

## Known bugs checked (pre-run)
66 linked issues Closed; none open/relevant. No reproduction concerns.

## Scope limitation (why A8/A11/A15 are out of scope)
Brand > Content export is delivered **asynchronously by email** ("We're at work preparing your export… an email to lfqa@listenfirstmedia.com"), not a synchronous file download. Steps 8/11/15 require opening that inbox and downloading the emailed CSV / opening the emailed Google Sheet. The email inbox is not accessible on this automation track, and **Google Sheets is out of scope** (Google 2FA on a separate auth surface). So the emailed-artifact assertions (CSV filename + column list, GS-matches-CSV, Clicks CSV columns) cannot be verified here. The **in-app** portion (which data sets are pre-selected and enabled/disabled in the Export pop-up) is fully verifiable and was verified.

## Steps executed
1–4. Brand > Content → Hulu → Table View. ✅
5. Data Set → **Engagements Breakdown** (`table_data_set=engagements_breakdown`). ✅
6. Export → "Export Select Data Sets" pop-up. ✅
7. (Inspected default selection + enabled set; did NOT submit OK — email export not verifiable.) ✅ inspected
8. Email CSV download — **out of scope**.
9–11. Google Sheets export — **out of scope**.
12. Data Set → **Clicks** (`table_data_set=clicks`). ✅
13. Export → pop-up. ✅
14–15. OK + email CSV download — **out of scope**.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A6a | Only 'Engagements Breakdown' selected in the Export pop-up | Only "Engagements Breakdown" checked; all others unchecked | ✅ PASS |
| A6b | Only [Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, Twitter Only: Engagements & Follows, Instagram Only: Insights, Instagram Only: Action Types, Instagram Engagements Beta, YouTube Only: Basic/Insights/Premium/Subscribers & Playlists/Cards] enabled | Exactly those 15 enabled; **Facebook-Only** variants, Threads Only, Pinterest Only, custom sets **disabled** — matches spec | ✅ PASS |
| A8 | Filename `Brand - Tab - YYYYMMDD-YYYYMMDD-Posts.csv`; ~100 EB columns | Requires emailed CSV | ⏭️ OUT OF SCOPE (email) |
| A11 | Google Sheet matches LFM CSV | GS out of scope | ⏭️ OUT OF SCOPE |
| A13a | Only 'Clicks' selected in the Export pop-up | Only "Clicks" checked | ✅ PASS |
| A13b | Only [Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, Facebook Only: Reactions, Facebook Only: Completed Video Views, Facebook Engagements Beta, Twitter Only: Engagements & Follows, YouTube Only: Basic/Insights/Premium/Subscribers & Playlists/Cards] enabled | Exactly those enabled; **Instagram-Only** variants, Threads, Pinterest, custom sets **disabled** — matches spec | ✅ PASS |
| A15 | Clicks CSV columns (Engagements, Link Clicks, Twitter Organic/Paid Clicks, Other Clicks, Facebook Photo Views) | Requires emailed CSV | ⏭️ OUT OF SCOPE (email) |

## Key finding (for skills)
The Export pop-up's **enabled data-set list is context-dependent on the active data set's channel compatibility**:
- **Engagements Breakdown** context → Instagram-Only sets ENABLED, Facebook-Only sets DISABLED.
- **Clicks** context → Facebook-Only sets ENABLED, Instagram-Only sets DISABLED.
Both exactly matched the spec's expected enabled lists. In both, Threads-Only, Pinterest-Only, and custom (Hulu Impressions/Video Views) sets are disabled.

## Evidence
- `qa1519-export-popup-eb.png` / `qa1519-export-popup2.png` — Export pop-up (Engagements Breakdown checked).
- DOM enablement maps captured for both EB and Clicks contexts (in report table).

## Bugs filed
None. In-app assertions passed; emailed-CSV/GS assertions deferred as out-of-scope.
