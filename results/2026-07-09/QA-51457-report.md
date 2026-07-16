# QA-51457 — Brand > Insights - Engagements - Tile level export - PNG

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account/Brand:** Hulu (account_id=336, brand_id=5670) · Insights · Jul 2–8 2026 (Last-7 short range, no renderer freeze)

## Verdict: PASS

## Known bugs checked
Compact open-bug screen → empty. No open linked bug.

## Flow
Brand > Insights (Hulu, 7-day range → A1: page loaded, no freeze). Engagements tile present (2.14M, -23%). Tile footer **Bar ▾ | Export ▾ | Save to Dashboard ▾**; opened the Engagements tile's Export dropdown (`.selector-dropdown-container` toggle) → flat menu **PNG / CSV / Google Sheets / Metrics** → **PNG** → downloaded synchronously.

## PNG verified (rendered + read)
`Hulu-Insights-Engagements-Bar-2026-07-02-2026-07-08.png`: ListenFirst logo, **Hulu** header, **Engagements** title, Legend Facebook/Twitter/Instagram/TikTok "- Compared To", stacked bar chart per-day (Jul 02–08, Y-axis 0–800K, Compared-To markers), footer "Brand Insights / Date: Jul. 02, 2026-Jul. 08, 2026". No render errors.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Insights loads, no freeze (short range) | loaded on 7-day range, Engagements tile rendered | PASS |
| A2 | Engagements tile exposes tile-level Export menu (or document absence) | tile Export ▾ → PNG/CSV/Google Sheets/Metrics | PASS |
| A3 | PNG export reachable → downloads | `Hulu-Insights-Engagements-Bar-2026-07-02-2026-07-08.png` | PASS |
| A4 | PNG embeds title, data, axes, legend, date range | all present | PASS |
| A5 | (if absent) mark BLOCKED spec-drift | not applicable — export present & working | N/A |

## IMPORTANT — corrects QA-10387 (this session)
QA-10387 (Brand > Insights Impressions/Video Views tile-PNG) was marked **BLOCKED** earlier this session on the belief that the Insights per-tile PNG submenu doesn't render under Playwright MCP. **That was a mis-click, not a real block.** The Insights per-tile PNG export **works**: open the tile-footer **`.selector-dropdown-container`** whose text is "Export" (NOT the separate `tile-level-export-button-container`, which opens a different Export/Save-to-Dashboard menu) → a flat PNG/CSV/Google Sheets/Metrics list appears → PNG downloads synchronously (same pattern as Brand > Stories / QA-51442). **Recommend re-running QA-10387 — it will PASS.**

## Evidence
- `.playwright-out/Hulu-Insights-Engagements-Bar-2026-07-02-2026-07-08.png`
- `.playwright-out/QA-51457-innerexport.png` (flat PNG/CSV/GS/Metrics menu visible)

## Bugs filed
None.
