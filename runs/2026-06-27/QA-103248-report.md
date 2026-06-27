# QA-103248 — Brand Sets > Content - Daily Post Analysis Modal - Export - PNG & Google Sheets — 2026-06-27

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei (account_id=54) · **User:** lfiqa@listenfirstmedia.com
- **Brand Set:** LF // TV // Episodic (brand_set_id=756) · **Window:** Jun 19–25 2026 (default 7-day); modal window Jun 22–25 2026
- **Post under test (rank 1):** Love Island USA (Peacock) — TikTok, Video, published Mon Jun. 22, 2026 08:58 AM PDT
- **Skill reused:** `brand-content-dpa-modal` (v1, untrusted) — exact coverage of this case
- **Result:** ✅ PASS (PNG path) · GS path OUT OF SCOPE per `config/env.md`
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-103248

## Scope note (Google Sheets)
`config/env.md` (Playwright MCP track) + `MIGRATION.md`: **Google Sheets export is out of scope** (Google 2FA on a separate auth surface). Step 7 was NOT executed and assertions A5/A6/A7 are marked **OUT OF SCOPE — not tested** (not FAIL). The Export menu was confirmed to *offer* the Google Sheets option (PNG / CSV / Google Sheets all present), but the GS flow itself was not driven.

## Steps executed
1. **Brand Sets → Content** via top-nav hover menu (`competitive_category` dropdown → Content link). Landed on `#explore/competitive/content`. ✓
2. **Brand Set picker** → opened dropdown, typed `LF // TV // Episodic`. Typeahead Results returned two entries: `LF // TV // Episodic` and `LF // TV // Episodic Plus`. Per Rule 1, clicked the **exact match** `LF // TV // Episodic` (brand_set_id resolved 1738→756). Posts loaded: **Posts (32,137)**. ✓
3. **Daily Analysis** button below the first post (rank 1, Love Island USA (Peacock)) clicked → DPA modal `.lfm-modal.daily-post-analysis` rendered (Date Range Jun. 22, 2026 – Jun. 25, 2026 / Mode: In Window / Rank: Engagements). ✓
4. **Data-viz dropdown** (label `Line`) → selected **Bar**. Chart re-rendered as a 4-day bar chart; dropdown label confirmed `Bar`. ✓
5. **Export dropdown** (top-right of modal) opened → options **PNG / CSV / Google Sheets** present. ✓
6. **PNG** selected → browser fired a real PNG download (blob anchor); Playwright captured it to disk. ✓
7. **Google Sheets** — SKIPPED (out of scope; see scope note). 
8. **Close** button (modal footer) clicked → modal dismissed, Brand Sets > Content grid restored. ✓

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6 | Filename `[Brand]-Daily Content Analysis-[Graph Type]-YYYY-MM-DD-YYYY-MM-DD.png` | `Love Island USA (Peacock)-Daily Content Analysis-Bar-2026-06-22-2026-06-25.png` (saved on disk, 43,855 bytes) | ✅ PASS |
| A2 | 6 | ListenFirst logo + name top-left, above the Brand name | PNG top-left: LISTENFIRST mark + `LISTENFIRST` wordmark; brand title `Love Island USA (Peacock)` directly below | ✅ PASS |
| A3 | 6 | "Daily Content Analysis" text + date range below the graph | PNG footer: `Daily Content Analysis` + `Date: Jun. 22, 2026-Jun. 25, 2026` below the chart | ✅ PASS |
| A4 | 6 | PNG matches the page | Bars Jun 22 ≈818K, Jun 23 ≈1.07M, Jun 24 ≈666K, Jun 25 ≈22K + `Engagements` legend — identical to modal/table | ✅ PASS |
| A5 | 7 | GS filename `[Brand]-[Publish Time PST]-[Channel]-Daily Content Analysis-YYYY-MM-DD-YYYY-MM-DD` | Google Sheets export out of scope (Google 2FA) | ⛔ OUT OF SCOPE — not tested |
| A6 | 7 | Date format YYYY-MM-DD | Google Sheets export out of scope | ⛔ OUT OF SCOPE — not tested |
| A7 | 7 | GS data matches page data | Google Sheets export out of scope | ⛔ OUT OF SCOPE — not tested |
| A8 | 8 | The window closes | `.daily-post-analysis` removed from DOM; `Posts (…)` grid restored | ✅ PASS |

## Evidence
- **On-disk PNG (Rule 6 — actual saved file, not a DOM proxy):** `.playwright-out/Love-Island-USA-Peacock--Daily-Content-Analysis-Bar-2026-06-22-2026-06-25.png` (43,855 bytes). Browser-save filename = `Love Island USA (Peacock)-Daily Content Analysis-Bar-2026-06-22-2026-06-25.png`.
- **Modal (Line, pre-switch):** `.playwright-out/QA-103248-01-modal-line.png`
- **Modal (Bar, post-switch):** `.playwright-out/QA-103248-02-modal-bar.png`
- **Table math cross-check:** Engagements Sum 2,578,064; Average 644,516; per-day Jun 22 818,662 + Jun 23 1,071,088 + Jun 24 665,856 + Jun 25 22,458 = 2,578,064 (= Sum); 2,578,064 / 4 = 644,516 (= Average). Consistent.
- **Filename schema note:** the spec strikethrough over "Daily Content Analysis" (A1) was ambiguous; the current build's filename **does** include the literal `Daily Content Analysis` segment, matching the documented `brand-content-dpa-modal` schema. Not a defect.

## Pre-flight
Programmatic Cognito login (existing-account form) succeeded; `#home` rendered (title "Home - ListenFirst"); active account = Adam Orfei (account_id=54), matching the precondition.

## Bugs filed
_None._ All in-scope assertions (A1–A4, A8) passed. A5–A7 require the out-of-scope Google Sheets path and were not evaluated.
