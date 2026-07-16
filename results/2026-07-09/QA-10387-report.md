# QA-10387 — Brand Insights - Impression and Video Views Chart - PNG

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account/Brand:** Hulu (account_id=336, brand_id=5670) · Brand > Insights · Jul 2–8 2026 (Authorized)

## Verdict: PASS
> Note: initially recorded BLOCKED earlier this session due to a mis-click on the tile export control; **re-run and corrected to PASS** after the QA-51442/QA-51457 investigation identified the correct interaction.

## Known bugs checked
Compact open-bug screen → empty. No open linked bug.

## Flow (correct interaction)
Brand > Insights (Hulu). Each tile footer has **`<ChartType> ▾ | Export ▾ | Save to Dashboard ▾`**. Open the tile-footer **`.selector-dropdown-container`** whose text is "Export" → flat menu **PNG / CSV / Google Sheets / Metrics** → **PNG** → downloads synchronously. (Do NOT use the separate `tile-level-export-button-container`, which opens a different Export/Save-to-Dashboard menu whose format submenu doesn't drive — that was the earlier mis-click.)

## PNGs verified (rendered + read)
- **Impressions:** `Hulu-Insights-Impressions-Area-2026-07-02-2026-07-08.png` — Hulu header, "Impressions" title, Facebook/Twitter/Instagram legend + "-- Compared To" dashed lines, area chart (Jul 02–08, Y-axis 0–30M), footer "Brand Insights / Date: Jul. 02, 2026-Jul. 08, 2026". Clean render.
- **Video Views:** `Hulu-Insights-Video Views-Area-2026-07-02-2026-07-08.png` — Hulu header, "Video Views" title, Facebook/Twitter/Instagram/TikTok legend + Compared-To, area chart (Y-axis 0–14M), same footer. Clean render.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Both PNGs download with sensible filenames (brand + tile + date range) | both downloaded, correct filename pattern | PASS |
| A2 | Each PNG renders chart title, axes, legend, series | Impressions + Video Views both render fully | PASS |
| A3 | PNG data matches on-screen | area charts match the on-screen tiles | PASS |
| A4 | No render errors / blank canvases | clean | PASS |

## Evidence
- `.playwright-out/Hulu-Insights-Impressions-Area-2026-07-02-2026-07-08.png`
- `.playwright-out/Hulu-Insights-Video Views-Area-2026-07-02-2026-07-08.png`

## Harness note
Insights tile-level PNG export IS drivable under Playwright MCP via the footer `.selector-dropdown-container` "Export" toggle (flat PNG/CSV/Google-Sheets/Metrics menu) — same mechanism as Brand > Stories (QA-51442). Supersedes the earlier "tile-PNG not drivable" finding.

## Bugs filed
None.
