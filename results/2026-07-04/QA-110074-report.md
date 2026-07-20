# QA-110074 — Brand > Audience - Threads - Tile Level Export - PNG

- **Run:** 2026-07-04 (headless, unattended, Playwright MCP track)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-110074
- **Skill used:** `audience-metrics-export` (v2) — per-tile Export→PNG pipeline
- **Verdict:** **PASS** (5/5 tiles exported and verified on disk; all assertions met)
- **Open-bug screen:** "None open. Screen only — run normally." → ran normally.

## Preconditions
- Logged in as `lfiqa@listenfirstmedia.com` (config/.env), account **Adam Orfei** (account_id=54) — matches "logged in as Adam Orfei". ✓
- Brand **MTV** selected via typeahead (exact "MTV" result, not a family variant per Rule 1) → brand_id=4018.
- Channel: **Threads only** (Facebook disabled, Threads enabled, Apply clicked → `channels=threads`).
- Date range: **Mar 16, 2025 – Mar 22, 2025** (two-calendar picker; range-start=16, range-end=22 verified before Ok → `from=2025-03-16&to=2025-03-22`).
- View: Authorized Data (`perspective=extended`, default on this surface).

## Steps executed
1. Hover Brand → click Audience. ✓
2. Open brand dropdown, type "MTV", click exact "MTV" Results row. ✓
3. Disable Facebook + enable Threads channel ghost → Apply; open Date Range picker, navigate both calendars to March 2025 (month-grid → prev-year → Mar), set start=16 / end=22, click Ok. Tiles re-rendered with data. ✓
4. Export → PNG below "Followers By Country". ✓
5. Export → PNG below "Followers By City". ✓
6. Export → PNG below "Followers: Geo Breakdown By Country". ✓
7. Export → PNG below "Followers: Geo Breakdown By City". ✓
8. Export → PNG below "Followers: Gender Breakdown". ✓

All 5 tiles rendered with data (no "no data available" banners). Chart types: Country=world choropleth map, City=world dot map, Geo Country=share table, Geo City=share table, Gender=donut (Men 42% / Women 50% / Unknown 8%).

## Downloaded files (on disk, `.playwright-out/`, all fresh 2026-07-04 10:35–10:37)

Server download-event name → on-disk name (Playwright slugifies spaces→`-`):

| # | Chart | Server filename | On-disk | Bytes |
|---|-------|-----------------|---------|-------|
| 1 | Followers By Country | `MTV-Audience-Followers By Country-2025-03-16-2025-03-22.png` | `MTV-Audience-Followers-By-Country-2025-03-16-2025-03-22.png` | 67,107 |
| 2 | Followers By City | `MTV-Audience-Followers By City-2025-03-16-2025-03-22.png` | `MTV-Audience-Followers-By-City-2025-03-16-2025-03-22.png` | 68,903 |
| 3 | Followers: Geo Breakdown By Country | `MTV-Audience-Followers Geo Breakdown By Country-2025-03-16-2025-03-22.png` | `...-Followers-Geo-Breakdown-By-Country-...png` | 130,034 |
| 4 | Followers: Geo Breakdown By City | `MTV-Audience-Followers Geo Breakdown By City-2025-03-16-2025-03-22.png` | `...-Followers-Geo-Breakdown-By-City-...png` | 169,794 |
| 5 | Followers: Gender Breakdown | `MTV-Audience-Followers Gender Breakdown-2025-03-16-2025-03-22.png` | `...-Followers-Gender-Breakdown-...png` | 31,239 |

## Assertions (apply to all 5 PNGs)

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Filename `Brand - Tab - Chart - YYYY-MM-DD(Start)-YYYY-MM-DD(End).png` | Server names = `MTV-Audience-<Chart>-2025-03-16-2025-03-22.png` for all 5 (brand=MTV, tab=Audience, chart name, start 2025-03-16, end 2025-03-22). Segment separator is `-` (no surrounding spaces) — documented format-vs-spec variance, consistent across runs. | **PASS** |
| A2 | Chart Title: "Brand Name - Chart Name" | Every PNG renders brand "MTV" (header line under logo) + chart name below it (e.g. "Followers By Country", "Followers: Gender Breakdown"). Both tokens present; rendered as two lines rather than joined by " - " (layout variance, not a data defect). | **PASS (w/ layout variance)** |
| A3 | PNG matches the explorer chart | Each PNG matches the on-page tile: Country choropleth (US dark red, legend 20-39%/1-19%/0.01-0.99%/0%); City dot map; Geo Country table (USA 24%, Brazil 11%, India 9%, Mexico 8%…); Geo City table (Mexico City 6%, Lagos 6%, São Paulo 5%, New York 5%, Lima 5%, Bogotá 4%…); Gender donut (Men 42% / Women 50% / Unknown 8%, center 100%). | **PASS** |
| A4 | Display date below "Brand Audience" | Every PNG footer: `Brand Audience` then `Date: Mar. 16, 2025-Mar. 22, 2025`. | **PASS** |

## Evidence
- Rendered tiles (full page): `.playwright-out/QA-110074/tiles-rendered.png`
- Date picker range confirmation: `.playwright-out/QA-110074/datepicker-start2.png`
- Verified PNG content read (multimodal) for all 5 exported files listed above.
- URL at export time: `#explore/brand/audience?brand_id=4018&account_id=54&from=2025-03-16&to=2025-03-22&channels=threads&perspective=extended`.

## Scope notes
- Google Sheets export option present in each tile dropdown but **out of scope** — not exercised (spec only requests PNG). No GS steps in this case.
- CSV option also present; not requested by spec.

## Bugs filed
None. All 5 PNG exports succeeded and match the explorer charts. The A1 segment-separator (`-` vs spec " - ") and A2 two-line title layout are pre-documented format-vs-spec cosmetic variances, not defects.
