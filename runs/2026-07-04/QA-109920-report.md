# QA-109920 — Brand > Content · Sentiment Comments limit · Positive Classification Donut · CSV

- **Run date:** 2026-07-04 (headless, unattended, Playwright MCP)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-109920
- **Verdict:** **PASS (3/3)**
- **Brand:** Amazon Prime Video (brand_id=25864, exact typeahead Results match — Rule 1)
- **Account:** Adam Orfei (account_id=54); brand reachable here via typeahead
- **Date range:** Apr 01, 2025 – Apr 07, 2025 (`from=2025-04-01&to=2025-04-07`)
- **Open-bug screen:** case file says "None open. Screen only — run normally." → ran.

## Pre-flight
- Logged in via Cognito "With existing account" form (lfiqa@listenfirstmedia.com) → `#home` rendered ("Home - ListenFirst"). OK.

## Steps executed
1. Hover Brand → clicked **Content** → Brand>Content loaded.
2. Opened brand-change chevron → typed "Amazon Prime Video" in "Search for a Brand" → clicked the **exact** `Amazon Prime Video` option under Results (not a regional/roll-up variant). Header confirmed "Amazon Prime Video", `brand_id=25864`.
3. Opened Date Range picker (two-calendar widget) → Start calendar: months view → prev year (2026→2025) → Apr → day **1**; End calendar: months view → prev year → Apr → day **7**. Verified `range-start`=Apr 1, `range-end`=Apr 7 before clicking **Ok**. URL updated to `from=2025-04-01&to=2025-04-07`.
4. Clicked **Sentiment** button → `sentiment_mode=true`; Classification donut rendered (Positive 50% / Neutral 36% / Negative 14%).
5. Hovered the **Positive** (green, rgb(0,187,0)) arc of the Classification donut → tooltip rendered: "Positive Classification: 50% / Total Comments: 6,231 / Read". (D3 `g.donut`; hover via mouseover/mousemove dispatched at a ring coordinate per the donut pointer-interception workaround.)
6. Clicked **Read** → popup modal opened.
7. Clicked modal **Export** (`csv-export-comments-btn`) → dropdown (CSV / Google Sheets) → clicked **CSV**.
8. **Sentiment Export Request** popup shown → clicked **Ok**. Export auto-downloaded to disk.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6 | Pop-up opens | "Positive Classification: 50%" modal opened with a sortable comments table (Date/Author/Type/Comment Text/Classified/Emotion/Topics) | **PASS** |
| A2 | 6 | Message: "2,000 Sample Comments. To view all possible comments, please export your result as on screen display is limited to 2,000" | Verbatim (`.title`): "2,000 Sample Comments. To view all possible comments, please export your result as on screen display is limited to 2,000." | **PASS** |
| A3 | 8 | CSV export has more than 2000 comments | On-disk CSV = **6,161** data records (all `Comment Classified` = Positive), 1,191,477 bytes → **6,161 > 2,000** | **PASS** |

## Evidence
- **A1/A2 popup + message:** `.playwright-out/QA-109920/step6-after-read-click.png` (header + 2,000-limit message + comments table).
- **A1/A2 tooltip → Read:** `.playwright-out/QA-109920/step5-positive-tooltip-read.png` ("Positive Classification: 50%", Total Comments 6,231, Read).
- **Step 8 popup:** `.playwright-out/QA-109920/step8-sentiment-export-request.png` (Sentiment Export Request → Ok; notes auto-download + bell + email to lfiqa@listenfirstmedia.com).
- **Sentiment mode:** `.playwright-out/QA-109920/step4-sentiment-mode.png`.
- **CSV on disk:** `.playwright-out/Amazon-Prime-Video-Brand-Content-2025-04-01-2025-04-07-comments-sentiment.csv`
  - Server/download-event filename: `Amazon Prime Video-Brand Content-2025-04-01-2025-04-07-comments-sentiment.csv` (Playwright slugifies spaces→`-` on disk).
  - Header: `Comment Date,Comment Day of Week,Comment Time,Comment Channel,Comment Author,Comment Type,Comment Text,Comment Classified,Comment Emotion,Topic 1..6,Post Link` (16 cols).
  - CSV-aware record count (Python csv): **6,161 records, 100% classified `Positive`.**

## Notes
- Export delivered **synchronously as an auto-download** (Playwright `download` event fired to `.playwright-out/`) in addition to the queued/bell/email path the popup advertises — no bell-fetch needed this run.
- On-screen popup is capped at 2,000 sample comments (A2), while the export contains the full **6,161** Positive comments (tooltip "Total Comments: 6,231" is the pre-export count; the export corpus of 6,161 confirms the "export to see all" behavior). Consistent with the 2026-06-02 run (~6,160 rows) recorded in known-quirks.
- Google Sheets was offered in the Export dropdown but NOT exercised (spec calls CSV; GS is out of scope on this track).

## Bugs filed
None. All assertions passed on the exact spec configuration.
