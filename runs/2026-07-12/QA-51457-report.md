# QA-51457 — Brand > Insights - Engagements - Tile level export - PNG

- **Run:** 2026-07-12 (unattended, headless, Playwright MCP, `feature/playwright-mcp`)
- **Account:** Hulu (account_id=336) — switched from UCLA via LFQA menu → Search Account → Results row
- **Brand:** Hulu (brand_id=5670)
- **Surface:** Brand > Insights, perspective=Authorized (`perspective=extended`), channels FB/Twitter/IG/TikTok
- **Date range:** Last 7 Days — 2026-07-05 → 2026-07-11 (compare 2026-06-28 → 2026-07-04)
- **Skill reused:** `audience-metrics-export` (v2 Brand>Insights tile PNG parity)

## Verdict: **PASS** (5/5 in-scope assertions)

The modern Hulu Brand>Insights build exposes standalone big-number tiles (including a dedicated
**Engagements** tile) each with a working **tile-level Export → PNG** affordance. The Engagements PNG
downloaded to disk with the exact spec filename pattern and embeds all required chart elements.

**This supersedes the prior BLOCKED finding.** On 2026-06-04 (Chrome-MCP, QA-4325 batch-4) this case
was BLOCKED as "spec drift — Trends-consolidated tile, no per-tile Export" plus a renderer hang
(same as QA-10387). Under Playwright on Hulu today: (a) the Insights renderer did **not** hang
(consistent with the QA-96670 spike that re-characterized the Chrome-MCP hang as a CDP/date-validation
artifact), and (b) the Engagements tile is a distinct tile with its own Export menu — no consolidation
drift. So A5's "document absence as spec drift" branch was **not** needed.

## Steps executed

1. Pre-flight: navigated to `app.lfmdev.in`, redirected to Cognito, logged in via the "With existing
   account" form (config/.env `lfiqa@…`) → `#home` rendered ("Home - ListenFirst").
2. Active account was **UCLA**; case requires **Hulu**. Hovered the LFQA menu header
   (`.navigation-menu-header`), typed "Hulu" into `input.account-typeahead-input`, clicked the
   `.lfm-ta-option` Results row → session switched to account_id=336.
3. Navigated to Brand > Insights with a short 7-day range + valid compare dates:
   `#explore/brand/insights?brand_id=5670&account_id=336&from=2026-07-05&to=2026-07-11&compare_from=2026-06-28&compare_to=2026-07-04`.
   App auto-appended `channels=twitter,instagram,facebook,tiktok&perspective=extended`.
4. Page loaded and tiles rendered within ~5s — **no renderer freeze** (A1).
5. Enumerated tiles: Total Followers, Follower Growth, Fan Growth Rate, New Posts, **Engagements: 1.94M
   (-18%)**, Content Engagement Rate, Impressions, Video Views, Best Performing Content Per Channel,
   Trends, Brand Reputation Index. Confirmed a **standalone Engagements tile** (not folded into Trends).
6. Isolated the Engagements tile (`al tile__container … tile--metric-analysis`, exactly 1
   `.tile-level-export-button-container`; current chart type = **Bar**). Screenshot:
   `.playwright-out/QA-51457/01-engagements-tile-export-btn.png`.
7. Opened the Engagements tile Export dropdown → options **PNG / CSV / Google Sheets / Metrics** (A2).
   Screenshot: `.playwright-out/QA-51457/02-export-menu-open.png`.
8. Clicked **PNG** → Playwright `download` event fired:
   `Hulu-Insights-Engagements-Bar-2026-07-05-2026-07-11.png` → saved to `.playwright-out/`
   (copied to `.playwright-out/QA-51457/`).
9. Verified file on disk: 40,970 bytes, `PNG image data, 424 x 622, 8-bit/color RGBA`. Rendered and
   read the image (A4).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Load Insights on short range | Page loads, no Chrome-MCP renderer freeze on Last 7 Days | Rendered in ~5s under Playwright; all tiles painted; no hang | **PASS** |
| A2 | Engagements tile export affordance | Engagements tile (or line in Trends) exposes tile-level Export menu, OR absence documented as spec drift | Standalone Engagements tile has its own `tile-level-export-button-container`; dropdown lists PNG/CSV/Google Sheets/Metrics | **PASS** |
| A3 | PNG filename pattern | `{Brand}-Insights-Engagements-{ChartType}-{from}-{to}.png` | `Hulu-Insights-Engagements-Bar-2026-07-05-2026-07-11.png` (Brand=Hulu, ChartType=Bar, from/to = 2026-07-05/2026-07-11) — exact match | **PASS** |
| A4 | PNG content | Embeds chart title, chart data, axes, legend, date range | ListenFirst logo+wordmark; brand "Hulu"; title "Engagements"; legend Facebook/Twitter/Instagram/TikTok + "Compared To"; stacked-bar data; Y-axis 0–450K; X-axis Jul 05–Jul 11; footer "Brand Insights" + "Date: Jul. 05, 2026-Jul. 11, 2026" | **PASS** |
| A5 | If PNG absent → BLOCKED/spec-drift | Only applies if export absent | N/A — PNG export present and working; A5 branch not taken | **N/A** |

## Evidence

- Engagements big-number: **1,938,504** (`title="1,938,504"`, displayed "1.94M (-18%)").
- Export dropdown DOM: `#export-button-46911b9e992b46db9615344fb16bea66`, items `.list-item` = PNG, CSV,
  Google Sheets, Metrics.
- Download (Playwright event log): `Downloaded file Hulu-Insights-Engagements-Bar-2026-07-05-2026-07-11.png`.
- On-disk: `.playwright-out/QA-51457/Hulu-Insights-Engagements-Bar-2026-07-05-2026-07-11.png` (40,970 bytes, 424×622 RGBA).
- Screenshots: `.playwright-out/QA-51457/01-engagements-tile-export-btn.png`, `02-export-menu-open.png`.

## Known bugs checked

- **bug-history.md (QA-51457):** only closed Bug/Test-Failure history noted (not enumerated); no OPEN
  linked bug listed. Prior magpie run 2026-06-04 (QA-4325 batch-4) = BLOCKED on spec drift +
  Chrome-MCP renderer hang. Neither reproduced under Playwright today (see verdict note).
- **QA-10387** (sibling "Impression and Video Views Chart - PNG", cross-referenced by the case):
  historically BLOCKED for the same "no per-tile export" spec drift. **Not reproduced** here — the
  Engagements tile has a per-tile Export menu on the current Hulu build.
- **Brand>Insights renderer hang (APPS-55565 / known-quirk):** Chrome-MCP-only CDP artifact; did not
  recur under Playwright (matches the 2026-06-22 QA-96670 spike re-characterization).
- **audience-metrics-export v2 findings** (QA-114845 Insights tile PNG parity): consistent — filename
  schema `<Brand>-Insights-<TileName>-<ChartType>-YYYY-MM-DD-YYYY-MM-DD.png` matched exactly, and the
  PNG content invariant (logo, brand, tile title, legend, chart, footer date) held.
- No renderer-hang; Rule 7 open-bug screen passed (no open linked bug baked into the case file).

## Bugs filed

None. (Markdown-only per framework; no Jira tickets created.)

## Notes / mutations

- Read-only flow; no data mutation, no cleanup required.
- Framework note: the case file's step 4/7 assumed possible Trends-consolidation with no per-tile
  export (from the stale Chrome-MCP QA-10387 batch-3 finding). On the Playwright track this no longer
  holds for Hulu — the Engagements tile and its PNG export are present. Prior BLOCKED entries for
  QA-51457/QA-10387 in bug-history are candidates for a "resolved under Playwright" update (defer to
  harvest.sh).
