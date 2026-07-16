# QA-103246 — Brand > Content · Daily Post Analysis Modal · Export — PNG & Google Sheets

- **Run:** 2026-07-11 (unattended, headless Playwright MCP, `feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-103246
- **Brand:** MTV (brand_id=4018) · **Account:** Adam Orfei (account_id=54)
- **Surface:** Brand > Content → Daily Post Analysis (DPA) modal
- **Skill reused:** `brand-content-dpa-modal` (untrusted, streak 7)
- **Verdict:** **PASS** — all in-scope assertions pass (A1–A4, A7 in-app probe, A8). Google Sheets assertions (A5, A6, and the GS-context of A7) are **out of scope** on this track (Google 2FA — `config/env.md`).

---

## Preconditions
- Logged in programmatically as `lfiqa@listenfirstmedia.com` (config/.env). Pre-flight login → `#home` OK.
- Brand with TikTok data = **MTV** (spec named "MTV / Amazon Prime Video"); MTV auto-loaded as the favorite brand on Adam Orfei. Rule 1 satisfied — exact spec brand, no substitution.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1 | Brand → Content | MTV Brand>Content loaded (Posts (73)) |
| 2 | Type & select brand (MTV) | MTV header + logo confirmed (brand_id=4018) |
| 3 | Date range incl. 2026-05-16 + control day | Set **May 15 → May 20, 2026** via two-calendar date picker → Ok; URL `from=2026-05-15&to=2026-05-20` |
| 4 | Click "Daily Analysis" on a post row | Clicked `button.daily-analysis-button` on top TikTok post |
| 5 | Pick a TikTok post — observe 2026-05-16 endash | Post: MTV TikTok, **Fri May 15 2026 10:50 AM PDT**, "Feeling like I scored alllllll the goals…". Modal opened: window May 15–20, Mode In Window, Data Set Public, 6 Metrics. **May 16 endash observed** (see probe) |
| 6 | Switch data viz dropdown to Bar | Line → **Bar**; stacked bars rendered, May 16 = no bar |
| 7 | Export → PNG; verify in Downloads | PNG downloaded + verified on disk (A1–A4) |
| 8 | Export → Google Sheets | **OUT OF SCOPE** (GS deferred — Google 2FA); step skipped, never opened docs.google.com |
| 9 | Close modal | × (`div.crud-modal-close.lf-close`) → modal dismissed, grid restored |

## Modal data table (evidence)
Header: `Metric | Sum | Average | May 15 | May 16 | May 17 | May 18 | May 19 | May 20`

| Metric | Sum | Average | May 15 | **May 16** | May 17 | May 18 | May 19 | May 20 |
|---|---|---|---|---|---|---|---|---|
| Engagements | 157,628 | 26,271 | 32,510 | **–** | 71,584 | 26,207 | 18,585 | 8,742 |
| Reactions | 155,200 | 25,867 | 32,000 | **–** | 70,500 | 25,800 | 18,300 | 8,600 |
| Comments | 176 | 29 | 41 | **–** | 75 | 28 | 21 | 11 |
| Shares | 2,252 | 375 | 469 | **–** | 1,009 | 379 | 264 | 131 |
| Video Views | 1,200,000 | 200,000 | 221,000 | **–** | 558,600 | 206,800 | 113,600 | 100,000 |
| Video Response Rate | N/A | 10.88% | 14.71% | **–** | 12.81% | 12.67% | 16.36% | 8.74% |

**Sum/Average math (endash = 0, denominator = 6 days):**
- Engagements: 32,510 + 0 + 71,584 + 26,207 + 18,585 + 8,742 = **157,628** ✓ · 157,628/6 = 26,271 ✓
- Reactions: 32,000 + 0 + 70,500 + 25,800 + 18,300 + 8,600 = **155,200** ✓ · /6 = 25,867 ✓
- Comments: 41 + 0 + 75 + 28 + 21 + 11 = **176** ✓ · /6 = 29 ✓
- Shares: 469 + 0 + 1,009 + 379 + 264 + 131 = **2,252** ✓ · /6 = 375 ✓
- Video Views: 221,000 + 0 + 558,600 + 206,800 + 113,600 + 100,000 = **1,200,000** ✓ · /6 = 200,000 ✓
- Video Response Rate: Sum N/A (rate metric); Average 10.88% = (14.71+12.81+12.67+16.36+8.74)/6 = 65.29/6 ✓ (endash day in denominator)

## PNG export verification (on disk — Rule 6)
- **Download-event (server) name:** `MTV-Daily Content Analysis-Bar-2026-05-15-2026-05-20.png`
- **On-disk path:** `.playwright-out/MTV-Daily-Content-Analysis-Bar-2026-05-15-2026-05-20.png` (44,977 bytes, PNG 847×573 RGBA). Spaces slugified to `-` on save — Playwright artifact, not a product name (assert against the server name; see known-quirks 2026-06-28).
- **Rendered PNG contents (read via multimodal render):** LISTENFIRST logo + wordmark top-left; brand title **MTV**; legend chips for all 6 metrics (Engagements/Reactions/Comments/Shares/Video Views/Video Response Rate); Bar chart with **no bar on May 16** (matches modal endash); bar heights match modal (May 17 tallest ≈700K, May 15 ≈290K, May 18 ≈260K, May 19 ≈155K, May 20 ≈120K); footer `Daily Content Analysis` + `Date: May. 15, 2026-May. 20, 2026`.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 7 | PNG filename `[Brand]-Daily Content Analysis-[Graph Type]-YYYY-MM-DD-YYYY-MM-DD.png` | `MTV-Daily Content Analysis-Bar-2026-05-15-2026-05-20.png` (server name) | **PASS** |
| A2 | 7 | ListenFirst logo + brand name in PNG header | LISTENFIRST wordmark + "MTV" present | **PASS** |
| A3 | 7 | Date range below the chart | `Date: May. 15, 2026-May. 20, 2026` footer | **PASS** |
| A4 | 7 | PNG matches modal display | Bar chart, 6-metric legend, May 16 empty, bar heights match modal | **PASS** |
| A5 | 8 | GS filename `[Brand]-[Publish Time]-[Channel]-Daily Content Analysis-…` | Not tested — GS out of scope (Google 2FA) | **OUT OF SCOPE** |
| A6 | 8 | GS row data matches modal | Not tested — GS out of scope | **OUT OF SCOPE** |
| A7 | 5/8 | For 2026-05-16 TikTok day, metric cell shows endash (DATA-12209) | **In-app modal table: all 6 metrics show `–` on May 16** (May 15 & 17+ numeric) — DATA-12209 reproduced. GS-cell aspect out of scope | **PASS (in-app)** |
| A8 | 9 | Close button dismisses modal | Modal removed from DOM; Brand>Content grid restored | **PASS** |

## Known bugs checked
- **bug-history.md grep (QA-103246):** 1 open bug — **DATA-12209** (Bug, Major, Open) "Daily Post Analysis TikTok endash on 16-05-26 (APV / MTV)". Prior reproductions 2026-06-02 batch-1 and 2026-06-04 batch-8.
- **Outcome this run:** **DATA-12209 REPRODUCED** — all 6 metrics show endash `–` for May 16, 2026 on the MTV TikTok post, surrounding days numeric. This bug **is the case's own probe (A7)** and is the *expected* behavior under test — it does **not** interfere with the PNG/close assertions, so it does not block the verdict (Rule 7: open bug does not auto-fail because it does not interfere; it is the intended probe). No regression.
- No other linked/related bugs applicable to the PNG export path.

## Bugs filed
- None. (DATA-12209 already open and tracked; reproduction noted above. Reports are markdown-only — no Jira tickets created.)

## Evidence artifacts
- `.playwright-out/QA-103246/01-grid-default.png` … `09-export-menu.png` (nav, date picker, modal Line, modal Bar, export menu)
- `.playwright-out/QA-103246/06-dpa-modal-line.png` — modal Line view + table
- `.playwright-out/QA-103246/08-dpa-modal-bar.png` — modal Bar view
- `.playwright-out/MTV-Daily-Content-Analysis-Bar-2026-05-15-2026-05-20.png` — exported PNG (verified on disk)
