# QA-51442 — Brand > Stories - Impressions - Tile level export - PNG

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account/Brand:** Hulu (account_id=336, brand_id=5670) · Stories · Instagram · Authorized · Jul 2–8 2026

## Verdict: PASS

## Known bugs checked
Compact open-bug screen → empty. No open linked bug.

## Flow
Brand > Stories (Hulu, IG) → Impressions tile rendered (1.85M, +485%) → tile footer **Bar ▾ | Export ▾ | Save to Dashboard ▾** → Impressions tile **Export ▾** → menu **PNG / CSV / Google Sheets / Metrics** → **PNG** → downloaded synchronously to disk.

## PNG verified (rendered + read)
`Hulu-Stories-Impressions-Bar-2026-07-02-2026-07-08.png` renders: ListenFirst logo, **Hulu** brand header, **Impressions** chart title, Legend "Instagram - Compared To", the bar chart with per-day data (Jul 02–08, peak 1.44M on Jul 07, Y-axis 0–1.6M), and footer "Brand Stories / Date: Jul. 02, 2026-Jul. 08, 2026". No blank canvas / render errors.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Stories page loads with Impressions tile | Impressions tile 1.85M rendered | PASS |
| A2 | Per-tile Export affordance with PNG option | tile footer Export ▾ → PNG/CSV/Google Sheets/Metrics | PASS |
| A3 | Clicking PNG triggers a download | PNG downloaded to disk | PASS |
| A4 | Filename `{Brand}-Stories-Impressions-{ChartType}-{from}-{to}.png` | `Hulu-Stories-Impressions-Bar-2026-07-02-2026-07-08.png` | PASS |
| A5 | PNG has brand header, title, chart data, legend, date range | all present (see above) | PASS |
| A6 | No render errors / blank canvas | clean render | PASS |

## Evidence
- `.playwright-out/Hulu-Stories-Impressions-Bar-2026-07-02-2026-07-08.png`
- `.playwright-out/QA-51442-tilemenu.png` (per-tile Export menu with PNG)

## Finding (harness — unblocks tile-PNG)
**Tile-level PNG export IS drivable under Playwright MCP on Brand > Stories.** Each tile has a footer `Export ▾` (`[class*=tile-level-export]`) opening a **flat dropdown** with PNG/CSV/Google Sheets/Metrics — clicking PNG downloads synchronously. This contrasts with **QA-10387 (Brand > Insights)** where the per-tile Export opened an intermediate "Export / Save to Dashboard" menu whose format submenu did not render via synthetic events (marked BLOCKED). The Stories pattern (flat menu, direct PNG) works — QA-10387 may be retryable by matching this simpler interaction if Insights exposes an equivalent flat menu.

## Bugs filed
None.
