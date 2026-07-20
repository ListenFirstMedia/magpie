# QA-51442 — Brand > Stories - Impressions - Tile level export - PNG

- **Verdict:** **PASS**
- **Run:** 2026-07-11, unattended/headless, Playwright MCP (`feature/playwright-mcp`)
- **Account:** Hulu (`account_id=336`) — switched from Adam Orfei via LFQA menu → Search Account → Results row
- **Brand:** Hulu (`brand_id=5670`, Authorized/extended perspective)
- **Surface:** `#explore/brand/stories`, Channel = Instagram, Data Set = Insights
- **Date range:** Jul. 04, 2026 – Jul. 10, 2026 (`from=2026-07-04&to=2026-07-10`)
- **Skills reused:** `switch-account` (v2), `brand-stories-export` (v1), `audience-metrics-export` (tile-PNG filename schema)

## Steps executed

1. Pre-flight: logged in via Cognito "With existing account" form (`config/.env`), landed on `#home`.
2. Switched account Adam Orfei → **Hulu** (hover LFQA menu → type "Hulu" → click the single `.lfm-ta-option` under `Results`). Verified breadcrumb `Account: Hulu` + `account_id=336`.
3. Navigated **Brand** top-nav hover → **Stories** link (`#explore/brand/stories?brand_id=5670`). Page loaded as "Brand Stories - ListenFirst", IG channel, Authorized View, Insights data set.
4. Waited for the four big-number tiles to render (initial "Loading Placeholder" resolved within budget). DOM probe: 4 metric heads (Engagements/Impressions/Taps Back/Exits), 0 placeholders, 28 `rect.bar`, 4 `svg`. Screenshot `01-stories-tiles-rendered.png`.
5. Located the **Impressions** tile (`Impressions: 1.85M (+682%)`); per-tile control row = `Bar | Export | Save to Dashboard`.
6. Opened the Impressions-tile **Export** dropdown → options `PNG / CSV / Google Sheets / Metrics`. Screenshot `02-impressions-export-menu.png`.
7. Clicked **PNG**. Export is synchronous — file written to `.playwright-out/`.
8. Verified on disk (Rule 6): `Hulu-Stories-Impressions-Bar-2026-07-04-2026-07-10.png`, 30,260 bytes, PNG 319×622 RGBA. Copied to evidence folder `03-exported-...png` and rendered it via the Read tool to inspect content.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Page + tile render | Brand > Stories loads with ≥1 Impressions tile rendered | Page loaded; Impressions tile rendered a 7-bar chart (Sum 1.85M, +682%); 4 tiles total, 0 placeholders, 28 bars | PASS |
| A2 | Per-tile export affordance | Impressions tile has per-tile Export with a PNG option | Tile footer `Bar \| Export \| Save to Dashboard`; Export menu = `PNG / CSV / Google Sheets / Metrics` | PASS |
| A3 | PNG triggers download | Clicking PNG triggers a download | Synchronous download fired; file written to `.playwright-out/` | PASS |
| A4 | Filename schema (on disk) | `{Brand}-Stories-Impressions-{ChartType}-{from}-{to}.png` | `Hulu-Stories-Impressions-Bar-2026-07-04-2026-07-10.png` — exact match (Brand=Hulu, Stories, Impressions, ChartType=Bar, from=2026-07-04, to=2026-07-10) | PASS |
| A5 | PNG embeds header/title/data/legend/date | Brand header + chart title + data + legend + date range | ListenFirst logo; brand header **Hulu**; chart title **Impressions**; legend `Instagram - Compared To`; populated bar chart (peak ~1.45M Jul 07); footer `Brand Stories / Date: Jul. 04, 2026-Jul. 10, 2026` | PASS |
| A6 | No render errors / blank canvas | No errors or blank canvases | Chart fully painted with bars + axes + legend; no error tile, no blank canvas | PASS |

## Evidence

- `.playwright-out/QA-51442/01-stories-tiles-rendered.png` — all 4 Stories tiles rendered (incl. Impressions).
- `.playwright-out/QA-51442/02-impressions-export-menu.png` — Impressions-tile Export menu open (PNG/CSV/Google Sheets/Metrics).
- `.playwright-out/QA-51442/03-exported-Hulu-Stories-Impressions-Bar-2026-07-04-2026-07-10.png` — the exported PNG (copy of the on-disk download).
- On-disk download: `.playwright-out/Hulu-Stories-Impressions-Bar-2026-07-04-2026-07-10.png` (30,260 bytes, PNG 319×622).
- Impressions tile Sum = 1.85M (+682%); exported chart daily bars reconcile to the tile sum (dominant Jul 07 bar ~1.45M).

## Known bugs checked

- **bug-history.md (grep QA-51442):** "Open bugs (0) — None." Prior 2026-06-04 PARTIAL was a Chrome-MCP tile-render artifact, **RETRACTED 2026-06-05** (LFIQA screenshot confirmed tiles render). Not applicable on Playwright.
- **known-quirks.md:** "Brand > Stories chart-tile visualization fails to load" was a **Chrome-MCP/CDP-only artifact** — the 2026-07-xx Playwright note confirms all four Stories tiles paint bar charts under Playwright. This run reproduces the healthy behavior: tiles rendered, PNG export produced a valid populated chart. **Not reproduced** — no product defect.
- **Playwright-MCP crash trigger** (2026-07-10 quirk) is specific to Brand>**Insights**; Brand>**Stories** is unaffected and rendered/exported cleanly.
- **Scope:** Google Sheets export option present but out of scope (not exercised). PNG (in-scope) verified end-to-end on disk.

## Bugs filed

None. All six assertions passed; behavior matches spec.
