# QA-103248 — Brand Sets > Content · Daily Post Analysis Modal · Export PNG & Google Sheets

- **Run:** 2026-07-04 (headless, unattended, Playwright MCP, `feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-103248
- **Skill used:** `brand-content-dpa-modal` (untrusted, v1) + `switch-account` (untrusted)
- **Account:** Adam Orfei (account_id=54) — switched from Viacom (181) via LFQA menu → Search Account → Results row
- **Brand Set:** LF // TV // Episodic (brand_set_id=756) — exact spec match, selected via the "Search for a Brand Set" typeahead Results
- **Post under test:** Rank #1 — **Love Island USA (Peacock)**, TikTok, published Fri Jun. 26, 2026 07:30 PM PDT, "The fallout from Casa Amor is real 🫣 #LoveIslandUSA" (Video)
- **Modal window:** Jun. 26, 2026 – Jul. 02, 2026 · Mode: In Window · Rank: Engagements · Graph Metrics: Engagements

## Verdict

**PASS** — all in-scope assertions (A1–A4, A8) pass. A5–A7 (Google Sheets) skipped as out of scope (Google 2FA — see `config/env.md`); noted, not failed.

## Steps executed

| # | Step | Result |
|---|------|--------|
| 1 | Brand Sets → Content (top nav / competitive/content) | Page loaded, Adam Orfei context, Posts (33,025) |
| 2 | Brand Set dropdown → type + select 'LF // TV // Episodic' | Exact match selected (2 results returned; picked non-"Plus"); header confirms LF // TV // Episodic |
| 3 | Click 'Daily Analysis' below the first post | Modal `.al-daily-post-analysis-modal` opened for Love Island USA (Peacock) |
| 4 | Data viz dropdown → 'Bar' | Options Area/Bar/Line/Pie; selected Bar; viz label = "Bar", chart re-rendered as bars |
| 5 | Export dropdown (top right of modal) | Opened; options PNG / CSV / Google Sheets |
| 6 | Select 'PNG' | Download event fired; file saved to disk |
| 7 | Export → 'Google Sheets' | **SKIPPED — out of scope** (Google 2FA; never opened docs.google.com) |
| 8 | Click 'Close' | Modal dismissed; Brand Sets>Content grid restored |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6 | Filename `[Brand]-Daily Content Analysis-[Graph Type]-YYYY-MM-DD-YYYY-MM-DD.png` | Download-event name `Love Island USA (Peacock)-Daily Content Analysis-Bar-2026-06-26-2026-07-02.png` | **PASS** |
| A2 | 6 | ListenFirst logo + wordmark top-left, above brand name | LISTENFIRST logo + wordmark top-left; "Love Island USA (Peacock)" title below | **PASS** |
| A3 | 6 | "Daily Content Analysis" text + date range below the graph | Footer reads `Daily Content Analysis` / `Date: Jun. 26, 2026-Jul. 02, 2026` | **PASS** |
| A4 | 6 | PNG matches the page | Bars/dates/legend/Y-scale in PNG identical to modal (Jun26≈504K, Jun27≈1.71M, Jun28≈459K, Jun29≈99K, Jun30≈65K, Jul01≈34K, Jul02≈16K; legend "Engagements") | **PASS** |
| A5 | 7 | GS filename `[Brand]-[Publish Time PST]-[Channel]-Daily Content Analysis-YYYY-MM-DD-YYYY-MM-DD` | Not tested — Google Sheets out of scope | **SKIPPED (out of scope)** |
| A6 | 7 | GS date format YYYY-MM-DD | Not tested — Google Sheets out of scope | **SKIPPED (out of scope)** |
| A7 | 7 | GS data matches page data | Not tested — Google Sheets out of scope | **SKIPPED (out of scope)** |
| A8 | 8 | Window closes | Modal removed from DOM; underlying grid (`.grid-item`) restored | **PASS** |

## Evidence

- **PNG on disk (verified by reading the file, Rule 6):**
  `.playwright-out/Love-Island-USA-Peacock--Daily-Content-Analysis-Bar-2026-06-26-2026-07-02.png` (43,225 bytes; Playwright slugifies `_`/spaces/parens → `-`, so `( )` collapse to `--`. The **server-emitted download name** keeps the spec format: `Love Island USA (Peacock)-Daily Content Analysis-Bar-2026-06-26-2026-07-02.png`).
- **Table math (modal, reconciles Sum/Average):** Engagements Sum 2,886,218 = 504,416 + 1,708,449 + 459,307 + 98,941 + 64,698 + 34,417 + 15,990; Average 412,317 = 2,886,218 / 7. ✓
- **Screenshots** (under `.playwright-out/QA-103248/`):
  - `01-brandsets-content-loaded.png` — Brand Sets>Content, LF // TV // Episodic, Adam Orfei
  - `02-dpa-modal-default.png` — DPA modal, default Line chart
  - `03-dpa-modal-bar.png` — DPA modal after switching to Bar (matches exported PNG)

## Notes

- **A1 strikethrough (spec):** the spec shows "Daily Content Analysis" struck through, hinting at an updated format. The current UI filename still includes the literal `Daily Content Analysis` substring, so the produced filename conforms to the non-struck format and A1 passes as written.
- **A5 PST/PDT note (informational, not evaluated):** publish date Jun 26 2026 is in DST, so any GS title would render `PDT` rather than the spec's `PST` — a conceptual match (both Pacific), per the skill's documented timezone-label drift. Not evaluated this run (GS out of scope).
- **Open linked bugs:** None open (per case file, as of 2026-07-03) — screen passed, ran normally.

## Bugs filed

None. All in-scope assertions passed; no product defect observed.
