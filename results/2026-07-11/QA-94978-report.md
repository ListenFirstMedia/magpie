# QA-94978 — Brand Audience · LinkedIn Channel · PNG Export Functionality

- **Verdict:** **PASS** (6/6 tile PNGs verified end-to-end on disk; all assertions pass)
- **Run:** 2026-07-11, unattended/headless (`claude -p`), Playwright MCP track (`feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-94978
- **Skills used:** audience-metrics-export (PNG tile-export pipeline) + view-perspective-toggle (perspective confirm) + switch-account (account context)
- **Account / Brand:** UCLA (account_id=799) · University of California, Los Angeles (brand_id=127756)
- **Surface:** Brand > Audience · Channel = **LinkedIn** (only LinkedIn ghost `enabled`, all others `disabled`)
- **Window:** Jan 01, 2025 – Dec 31, 2025
- **Perspective:** Authorized Data (`input#perspective` `checked:true, disabled:true` — LinkedIn demographics come only from Authorized data; toggle locked, matches known-quirks)

## Steps executed

1. Pre-flight login via Cognito "With existing account" form (config/.env) → app rendered at `#home` on **UCLA** account. ✓
2. Opened Brand nav; navigated to `#explore/brand/audience?brand_id=127756&account_id=799&from=2025-01-01&to=2025-12-31&channels=linkedin&perspective=extended`. Confirmed brand = **University of California, Los Angeles**, channel = LinkedIn (DOM: `linkedin channel-ghost enabled`, all others `disabled`). ✓
3. Confirmed perspective via DOM probe (Rule 2), not URL: `input#perspective` → `checked:true` (Authorized), `disabled:true` (locked). ✓
4. For each of the 6 target tiles, opened the tile-level Export dropdown (`.tile-level-export-button-container .dropdown-name`), confirmed **PNG** present alongside CSV / Google Sheets / Metrics, clicked **PNG**, and captured the Playwright `download` event. ✓
5. Verified each saved file on disk (existence, MIME `image/png`, size) and opened each PNG to visually confirm it represents the tile. ✓
6. APPS-58574 layout probe via DOM tile-position measurement. ✓

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Open per-tile Export dropdown | Dropdown exposes PNG | Dropdown = **PNG / CSV / Google Sheets / Metrics** (`li.list-item`) on every tile | PASS |
| A2 | Choose PNG | PNG downloads to disk | 6/6 Playwright `download` events fired; 6/6 files present in `.playwright-out/`, all `image/png` | PASS |
| A3 | Filename check | `<Brand>-Audience-<tile>-<start>-<end>.png` | Server names conform: `University of California, Los Angeles-Audience-Followers <Tile>-2025-01-01-2025-12-31.png` (on-disk slugified `,`/`/`/spaces → `-`, per known-quirks — not a product bug) | PASS |
| A4 | Open each PNG | Content matches visible tile | All 6 visually verified — UCLA header + tile title + correct chart/list + footer `Brand Audience Date: Jan. 01, 2025-Dec. 31, 2025` | PASS |
| A5 | APPS-58574 observed | Misalignment may show but must not block PNG export | APPS-58574 **REPRODUCED** (1+3 row split); did **not** block any of the 6 PNG exports | PASS |

### A2/A3 — files on disk (`.playwright-out/`, copies under `.playwright-out/QA-94978/`)

| Tile | On-disk filename | Bytes | MIME |
|------|------------------|-------|------|
| Followers: Job Function | `University-of-California-Los-Angeles-Audience-Followers-Job-Function-2025-01-01-2025-12-31.png` | 87,796 | image/png |
| Followers: Industry | `University-of-California-Los-Angeles-Audience-Followers-Industry-2025-01-01-2025-12-31.png` | 321,879 | image/png |
| Followers: Seniority | `University-of-California-Los-Angeles-Audience-Followers-Seniority-2025-01-01-2025-12-31.png` | 39,616 | image/png |
| Followers: Staff Count Range | `University-of-California-Los-Angeles-Audience-Followers-Staff-Count-Range-2025-01-01-2025-12-31.png` | 45,763 | image/png |
| Followers By Country | `University-of-California-Los-Angeles-Audience-Followers-By-Country-2025-01-01-2025-12-31.png` | 74,308 | image/png |
| Followers By Region | `University-of-California-Los-Angeles-Audience-Followers-By-Region-2025-01-01-2025-12-31.png` | 75,375 | image/png |

Server-emitted download-event names (from Playwright `download` events) carry the spec commas/spaces, e.g. `University of California, Los Angeles-Audience-Followers Job Function-2025-01-01-2025-12-31.png`.

### A4 — visual content verification (evidence: rendered PNGs read via multimodal file read)

- **Job Function** — Job Function / Share table: Business Development 13%, Education 11%, Engineering 8%, … Purchasing 0.29%. UCLA header + footer date present.
- **Industry** — long Industry / Share table (Higher Education top, Computer Software, Hospital & Health Care, …). Matches tile.
- **Seniority** — Senior 34%, Entry 33%, Director 9%, Manager 7%, … Unpaid 0.64%.
- **Staff Count Range** — Size 1 1%, Size 2 to 10 11%, Size 11 to 50 12%, … Size 10,001 or more 25%.
- **Followers By Country** — world choropleth + legend (60-79% / 1-19% / 0.01-0.99% / 0%); United States dark-red dominant.
- **Followers By Region** — world map with metro-area point markers, LA-metro bubble dominant (consistent with UCLA's metro-level region data, per the QA-95067 finding). Legend 20-39% / 1-19% / ….

Every PNG carries the ListenFirst logo, `University of California, Los Angeles` title, the tile title, and footer `Brand Audience / Date: Jan. 01, 2025-Dec. 31, 2025`.

## Known bugs checked

- **bug-history.md grep (QA-94978):** Open bugs (0) — *None*. Probe bug **APPS-58574** (Trivial, In Progress — Brand>Audience LinkedIn cards misaligned).
- **Rule 7 open-bug screen:** case file lists only APPS-58574 (Trivial), which A5 explicitly states does not block PNG export → screen passed, case run normally.
- **APPS-58574 verification (this run):** DOM tile-position measurement — `Followers: Job Function` alone on row 1 (top=328, left=10, `lfm-col-3`); `Industry` / `Seniority` / `Staff Count Range` on row 2 (top=728, lefts 20 / 335 / 650, all `lfm-col-3`). Four `lfm-col-3` tiles (~4×295=1180px) would fit the ~1240px container, but layout breaks 1+3 → **APPS-58574 REPRODUCED** (unchanged from 2026-06-04 batch-7). Trivial; did not interfere with any assertion — all 6 PNG exports succeeded.

## Bugs filed

None. (APPS-58574 already tracked; reproduced as expected, non-blocking per spec A5.)

## Evidence

- Export PNGs: `.playwright-out/QA-94978/*.png` (6 files, copied from `.playwright-out/` download targets).
- Full-page screenshot: `.playwright-out/QA-94978/page-linkedin-audience-tiles.png`.
