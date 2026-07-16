# QA-10387 — Brand Insights - Impression and Video Views Chart - PNG

- **Run:** 2026-07-11 (unattended, headless Playwright MCP)
- **Verdict:** **PASS** (4/4 assertions)
- **Account:** Hulu (account_id=336) — switched from default Adam Orfei (account_id=54)
- **Brand:** Hulu — Authorized entity brand_id=5670, perspective=extended (Authorized Data)
- **Date range:** Jul. 03, 2026 – Jul. 09, 2026 (compare_from 2026-06-26 / compare_to 2026-07-02)
- **Channels:** Facebook, Twitter, Instagram, TikTok
- **Skill reused:** [audience-metrics-export](../../skills/audience-metrics-export/SKILL.md) v2 (Brand>Insights tile PNG parity) + [switch-account](../../skills/switch-account/SKILL.md) + [view-perspective-toggle](../../skills/view-perspective-toggle/SKILL.md)

## Headline finding — prior spec-drift BLOCKER no longer reproduces

The 2026-06-04 QA-4325 batch-3 run marked this case **BLOCKED** ("tile-level PNG export not present on the modern Trends-consolidated Brand Insights build"), catalogued in `knowledge-base/known-quirks.md` ("Brand Insights tile-level PNG export absent…") and `bug-history.md`.

On this run the current Brand Insights build exposes **separate per-metric tiles** (Impressions, Video Views, Fan Growth Rate, Response Rate, Brand Reputation Index, Views, …), and **every tile carries its own `Area | Export | Save to Dashboard` control row**. The `Export` dropdown offers `PNG / CSV / Google Sheets / Metrics`. The Impressions and Video Views tiles are present and each exported to PNG cleanly. **The spec-drift block is resolved** — recommend un-blocking QA-10387 and refreshing the two KB entries.

### Why the earlier run blocked and this one passed (test-data / account gating)
- Viewing the **Hulu brand under the Adam Orfei account** (brand_id=11003, the Public entity) shows only Public tiles — **no Impressions tile** (Impressions is Authorized/private) — and the **View → Authorized Data toggle is DISABLED** (`div.toggle-switch.toggle-switch-disabled`, right label `.disabled`). Navigating to the Authorized entity brand_id=5670 under Adam Orfei **redirects to `#home`** (no ACL — matches the documented Adam-Orfei brand-gating edge case).
- Switching to the **Hulu account (account_id=336)** and opening Brand>Insights auto-loads **brand_id=5670 with perspective=extended (Authorized)**, the toggle is **enabled and ON Authorized**, and both the Impressions and Video Views tiles render with per-tile Export. The spec precondition ("account: Hulu", "brand with Authorized data — Hulu FB/IG private data") is only satisfiable on the Hulu account, not on Adam Orfei.

## Steps executed

| # | Step | Action taken | Result |
|---|------|--------------|--------|
| 0 | Pre-flight login | Cognito "With existing account" form (lfiqa) → `#home` | OK |
| 0b | Account precondition | Default account was Adam Orfei (54); Hulu Public brand (11003) has Impressions absent + Authorized toggle disabled; brand 5670 under Adam Orfei redirects to #home → switched to **Hulu account (336)** via LFQA menu → Search Account "Hulu" → Results row | Switched, `account_id=336`, breadcrumb `Account: Hulu` |
| 1 | Navigate to Brand > Insights (Authorized) | `#explore/brand/insights?account_id=336…` auto-loaded brand_id=5670, perspective=extended | Rendered, no hang |
| — | Confirm perspective (Rule 2) | DOM probe: `input#perspective` checked=**true**, switch not disabled, right label "Authorized Data" not disabled | Authorized confirmed |
| 2 | Locate Impressions tile | Found `Impressions: 93.7M (-55%)`, Area chart, legend FB/Twitter/IG, Y-axis 0–30M | OK |
| 3 | Tile Export → PNG (Impressions) | Clicked tile `Export` → dropdown `PNG/CSV/Google Sheets/Metrics` → `PNG` | Download fired |
| 4 | Wait for PNG | `page.on('download')` captured file | Saved |
| 5 | Locate Video Views tile | Found `Video Views: 63.2M (-43%)`, Area chart, legend FB/Twitter/IG/TikTok, Y-axis 0–13M | OK |
| 6 | Tile Export → PNG (Video Views) | Clicked tile `Export` → `PNG` | Download fired |
| 7 | Wait for PNG | Download captured | Saved |
| 8 | Open both PNGs, verify content + headers | Read on both rendered PNGs on disk | Both fully rendered (see evidence) |

## Downloaded files (on disk, verified)

| Tile | Server filename | On-disk path | Size |
|------|-----------------|--------------|------|
| Impressions | `Hulu-Insights-Impressions-Area-2026-07-03-2026-07-09.png` | `.playwright-out/QA-10387/Hulu-Insights-Impressions-Area-2026-07-03-2026-07-09.png` | 51,170 B |
| Video Views | `Hulu-Insights-Video Views-Area-2026-07-03-2026-07-09.png` | `.playwright-out/QA-10387/Hulu-Insights-Video-Views-Area-2026-07-03-2026-07-09.png` | 50,266 B |

*Note:* the Video Views **server** filename contains a space (`Video Views`); Playwright slugifies the space to a dash in the local saved path (known on-disk artifact, not a product defect — the download event carries the true spaced name). Both filenames carry the `.png` extension (LFMP-31903 missing-extension bug NOT reproduced here).

## Filename schema conformance

Both match the documented Brand>Insights schema `<Brand>-Insights-<TileName>-<ChartType>-YYYY-MM-DD-YYYY-MM-DD.png`:
- `Hulu` (brand) · `Insights` (surface) · `Impressions`/`Video Views` (tile) · `Area` (chart type) · `2026-07-03-2026-07-09` (date range).

## PNG content (verified by rendering)

**Impressions PNG:** LISTENFIRST logo+wordmark (top-left) → `Hulu` brand title → tile title `Impressions` → legend chips `Facebook / Twitter / Instagram / -- Compared To` → area chart with Y-axis `0–30M` and X-axis `Jul. 03 … Jul. 09`, three stacked series (FB/Twitter/IG) plus dashed compare-to lines → footer `Brand Insights` + `Date: Jul. 03, 2026-Jul. 09, 2026`.

**Video Views PNG:** same header/brand chrome → tile title `Video Views` → legend `Facebook / Twitter / Instagram / TikTok / -- Compared To` → area chart with Y-axis `0–13M`, X-axis `Jul. 03 … Jul. 09`, four stacked series + dashed compare-to lines → footer `Brand Insights` + `Date: Jul. 03, 2026-Jul. 09, 2026`.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4,7 | Both PNGs download with sensible filenames incl. brand + tile + date range | `Hulu-Insights-Impressions-Area-2026-07-03-2026-07-09.png` & `Hulu-Insights-Video Views-Area-2026-07-03-2026-07-09.png` — brand, tile, surface, chart type, date range all present; `.png` ext present | **PASS** |
| A2 | 8 | Each PNG renders chart with title, axes, legend, and visible bars/lines | Both render tile title, X/Y axes, per-channel legend, and populated area series (Impressions 0–30M; Video Views 0–13M) | **PASS** |
| A3 | 8 | PNG shows same data as on-screen (tile sum/axes align) | On-screen Impressions Sum 93.7M / axis 0–30M / legend FB·Tw·IG == PNG; Video Views Sum 63.2M / axis 0–13M / legend FB·Tw·IG·TikTok == PNG | **PASS** |
| A4 | 8 | No render errors or blank canvases | Both PNGs fully painted with data; no blank canvas, no error frame | **PASS** |

## Known bugs checked

- **bug-history.md `QA-10387`** — prior verdict BLOCKED (spec-drift, no tile export). **NOT reproduced** — per-tile Export→PNG is present and functional. Recommend clearing the block.
- **known-quirks.md "Brand Insights tile-level PNG export absent on modern Trends-consolidated tile"** — **NOT reproduced.** Tiles are per-metric (not a single Trends tile) and each has an Export control. Recommend updating/retiring this quirk.
- **known-quirks.md "Brand>Insights renderer hang" (Chrome-MCP)** — **NOT reproduced** under Playwright MCP; page and both tiles rendered within a few seconds. Consistent with the 2026-06-11/2026-06-22 "hang is intermittent/env-load-dependent, not permanent" notes.
- **LFMP-31903 (Minor) — tile PNG export missing `.png` extension** — **NOT reproduced** on either Impressions or Video Views PNG (both carry `.png`).
- **Open linked bugs:** the cached case file has no `## Open linked bugs` section → Rule 7 screen not triggered (no auto-fail).

## Bugs filed

None. (Reporting-only per framework; no Jira tickets auto-created.)

## Evidence artifacts

- `.playwright-out/QA-10387/01-view-toggle-area.png` — View toggle disabled state on Hulu Public entity (pre-account-switch)
- `.playwright-out/QA-10387/Hulu-Insights-Impressions-Area-2026-07-03-2026-07-09.png`
- `.playwright-out/QA-10387/Hulu-Insights-Video-Views-Area-2026-07-03-2026-07-09.png`
