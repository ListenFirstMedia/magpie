# QA-103246 — Brand > Content - Daily Post Analysis Modal - Export - PNG & Google Sheets

- **Run date:** 2026-06-27
- **Environment:** Playwright MCP track (`feature/playwright-mcp`), real Chrome, headless/unattended
- **Account:** Adam Orfei (account_id=54) — data fresh through 2026-06-26 04:25 PM PT
- **Brand:** MTV (brand_id=4018) — exact typeahead/header match (Rule 1 satisfied)
- **Skill reused:** `brand-content-dpa-modal` (v1, untrusted) + PNG-on-disk verification pattern
- **Source spec:** `testcases/english/QA-103246.md`
- **Result:** PASS on all in-scope assertions (A1–A4, A7, A8). A5/A6 (Google Sheets) OUT OF SCOPE on this track.

## Scope note (Google Sheets)

`config/env.md` (Playwright MCP track) explicitly puts **Google Sheets export out of scope** (Google 2FA on a separate auth surface). CSV/file exports stay in scope. Accordingly:
- **Step 8** (Export → Google Sheets) was **not executed**.
- **A5** (GS filename) and **A6** (GS row data) are marked **OUT OF SCOPE**, not failed.
- PNG export (Step 7, A1–A4) is a real blob download and was executed + verified end-to-end on disk.

## Steps executed

| # | Step | Action taken | Outcome |
|---|------|--------------|---------|
| Pre | Login + home | Cognito "With existing account" form filled from `config/.env`; landed on `#home` (title "Home - ListenFirst: Home") | PASS — not on auth.lfmdev.in |
| 1 | Brand → Content | Navigated `#explore/brand/content?brand_id=4018&account_id=54&...&from=2026-05-14&to=2026-05-20` | Posts (86) rendered |
| 2 | Type & select brand (MTV) | Verified brand header/selector text = exactly `MTV` (brand_id=4018) via DOM | PASS (Rule 1) |
| 3 | Date range incl. 2026-05-16 + control day | Window 2026-05-14 → 2026-05-20 (covers May 16 + May 15/17/18/19/20 controls) | PASS |
| 4 | Click "Daily Analysis" on a post row | JS-fallback `.click()` on rank-1 TikTok post (Fri May 15, 2026 10:50 AM PDT, "@Off Campus cast") | Modal `.al-daily-post-analysis-modal` opened |
| 5 | Pick TikTok post — observe 2026-05-16 endash | Read table; modal auto-extended Date Range to May 15 – May 20 covering May 16 | endash observed (A7) |
| 6 | Switch data viz dropdown to Bar | Opened `.viz-dropdown-container` (Area/Bar/Line/Pie) → clicked Bar | Chart re-rendered: 36 bars (6 metrics × 6 days); dropdown label = "Bar" |
| 7 | Export → PNG, verify file | Export dropdown (PNG/CSV/Google Sheets) → clicked PNG → download event captured | File saved + read on disk (A1–A4) |
| 8 | Export → Google Sheets | **SKIPPED — out of scope on Playwright MCP track** | N/A |
| 9 | Close modal | Clicked `.crud-modal-close` (×) | Modal dismissed; Posts (86) grid restored (A8) |

## Evidence

### Modal header (Step 4–5)
```
Daily Post Analysis
Date Range: May. 15, 2026 - May. 20, 2026
Mode: In Window
Data Set: Public
Post #1 | MTV | Fri May. 15, 2026 10:50 AM PDT (TikTok, Video)
"Feeling like I scored alllllll the goals after getting to chat with the @Off Campus cast 🏒🎶 #OffCampus"
```

### Table (Sum | Average | per-day) — verbatim from modal
| Metric | Sum | Average | May 15 | **May 16** | May 17 | May 18 | May 19 | May 20 |
|--------|-----|---------|--------|------------|--------|--------|--------|--------|
| Engagements | 157,628 | 26,271 | 32,510 | **–** | 71,584 | 26,207 | 18,585 | 8,742 |
| Reactions | 155,200 | 25,867 | 32,000 | **–** | 70,500 | 25,800 | 18,300 | 8,600 |
| Comments | 176 | 29 | 41 | **–** | 75 | 28 | 21 | 11 |
| Shares | 2,252 | 375 | 469 | **–** | 1,009 | 379 | 264 | 131 |
| Video Views | 1,200,000 | 200,000 | 221,000 | **–** | 558,600 | 206,800 | 113,600 | 100,000 |
| Video Response Rate | N/A | 10.88% | 14.71% | **–** | 12.81% | 12.67% | 16.36% | 8.74% |

**Sum/Avg math check (endash counts as 0 value but day counts in denominator):**
- Engagements: 32,510 + 0 + 71,584 + 26,207 + 18,585 + 8,742 = **157,628** ✓ (matches Sum). Average = 157,628 / 6 = 26,271.3 → displayed **26,271** ✓.

### PNG export (Step 7)
- **Download filename:** `MTV-Daily Content Analysis-Bar-2026-05-15-2026-05-20.png`
- **Saved to disk:** `.playwright-out/MTV-Daily-Content-Analysis-Bar-2026-05-15-2026-05-20.png` (Playwright sanitizes spaces→hyphens in the on-disk path; the browser download name retains the spaces and matches the spec pattern)
- **File type:** PNG image, 847 × 573, 8-bit RGBA (valid raster — Rule 6 satisfied via real file read, not DOM/header proxy)
- **Rendered contents (read from file):**
  - LISTENFIRST logo (top-left) + brand title `MTV`
  - Legend: Engagements / Reactions / Comments / Shares / Video Views / Video Response Rate
  - Stacked bar chart, Y-axis 0 → 800K, X-axis May 15 / May 16 / May 17 / May 18 / May 19 / May 20
  - **May 16 column has no bars** (consistent with endash for all metrics — DATA-12209)
  - Bar magnitudes match modal (May 17 tallest ~705K driven by Video Views 558,600; May 15 ~285K; May 18 ~260K; May 19 ~155K; May 20 ~120K)
  - Footer below chart: `Daily Content Analysis` + `Date: May. 15, 2026-May. 20, 2026`

### Screenshot refs (under `.playwright-out/`)
- `QA-103246-01-modal-line.png` — modal default Line state
- `QA-103246-02-modal-bar.png` — modal after switching to Bar
- `MTV-Daily-Content-Analysis-Bar-2026-05-15-2026-05-20.png` — exported PNG (verified on disk)

## Assertions table

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 7 | PNG filename `[Brand]-Daily Content Analysis-[Graph Type]-YYYY-MM-DD-YYYY-MM-DD.png` | `MTV-Daily Content Analysis-Bar-2026-05-15-2026-05-20.png` | **PASS** |
| A2 | 7 | ListenFirst logo + brand name in PNG header | LISTENFIRST logo + `MTV` present (read from saved file) | **PASS** |
| A3 | 7 | Date range below the chart | Footer `Date: May. 15, 2026-May. 20, 2026` | **PASS** |
| A4 | 7 | PNG matches modal display | Bars on May 15/17/18/19/20, empty May 16; magnitudes + Y-axis match table | **PASS** |
| A5 | 8 | GS filename `[Brand]-[Publish Time]-[Channel]-Daily Content Analysis-...` | Google Sheets export not executed | **OUT OF SCOPE** (Playwright MCP track) |
| A6 | 8 | GS row data matches modal | Google Sheets export not executed | **OUT OF SCOPE** (Playwright MCP track) |
| A7 | 5 | For 2026-05-16 TikTok day, metric cell shows endash (DATA-12209) | All 6 metrics show `–` on May 16; May 15 & May 17 show real numerics | **PASS — DATA-12209 REPRODUCED** |
| A8 | 9 | Close button dismisses modal | `.crud-modal-close` clicked → modal gone, Posts (86) grid restored | **PASS** |

## Probes (open bugs)

- **DATA-12209 (Major) — Daily Post Analysis TikTok endash on 2026-05-16:** **REPRODUCED.** On the MTV TikTok post (publish May 15, 2026), the May 16 2026 column renders endash `–` for every metric (Engagements, Reactions, Comments, Shares, Video Views, Video Response Rate) while May 15 and May 17 carry real values. The exported PNG likewise shows an empty May 16 bar slot. Bug remains open/valid — no fix observed.

## Bugs filed

_No new bugs._ The only defect exercised, **DATA-12209**, is an already-open Major bug and was reproduced as expected (probe A7) — documented above, not re-filed. No regression or new product defect observed in the PNG export path, the chart-type switch, the Sum/Average math, or the modal close behavior.

## Notes / quirks encountered (no bug)

- **Channel-merge quirk:** navigating with `channels=tiktok` was rewritten by the hash router to all 6 channels (`twitter/instagram/facebook/linkedin/tiktok/threads`). Did not affect the test — TikTok posts were still identified by per-row `.fa-tiktok` channel icon, and the rank-1 post was TikTok. (Matches known-quirks "Brand > Content channel URL param merging".)
- **brand_id rewrite:** brand_id stayed 4018 in URL this run; page header confirmed `MTV` regardless (DOM-verified per quirk guidance).
- PNG is a real blob download captured via the Playwright download event and verified by reading the file from disk (Rule 6 — actual save outcome observed, not inferred from DOM/headers).
