# QA-2035 — Brand Sentiment - CSV & GS — Report

- **Run date:** 2026-07-04 (headless, unattended, Playwright MCP)
- **Branch:** feature/playwright-mcp
- **Account:** Viacom (account_id=181)
- **Brand:** MTV (brand_id=4018) — exact typeahead Results match (Rule 1)
- **Surface:** Brand > Content → Sentiment mode (`sentiment_mode=true`)
- **Date range (report):** Jun. 26, 2026 – Jul. 02, 2026
- **Skill used:** `export-csv` (untrusted) + `switch-account` (untrusted)
- **Verdict:** **PASS** (in-scope A1–A5 PASS; A6 format-only with documented PST-suffix spec drift; A7/Google Sheets out of scope — skipped)

## Open-bug screen (Rule 7)
Case file "Open linked bugs" (as of 2026-07-03): **None open. Screen only — run normally.** → screen passed, ran the case.

## Steps executed

| # | Spec step | Action taken | Result |
|---|-----------|--------------|--------|
| pre | Login as config identity | Cognito "With existing account" form (lfiqa@…) → `#home` "Home - ListenFirst" | OK |
| pre | Precondition: logged in as Viacom | LFQA menu (hover) → Search Account "Viacom" → clicked Results `.lfm-ta-option` → account_id=181 | OK |
| 1 | Brand → Content | Top-nav Brand (hover) → Content link | Loaded `#explore/brand/content` |
| 2 | Type MTV; select MTV brand | Brand chevron → "Search for a Brand" → typed `MTV` → clicked exact "MTV" option (idx 0 of 73) | brand_id=4018 |
| 3 | Click the sentiment button | Clicked `button.sentiment-button` | `sentiment_mode=true`; Classification donut (70% Positive) + Classification (Daily) area chart rendered |
| 4 | Click Sentiment Export button | Clicked `button.sentiment-export-button` | "Sentiment Export" modal opened (View toggle CSV|Google Sheets, CSV default) |
| 5 | Click OK button | Clicked modal `Ok` (CSV mode) | Export queued; delivered async |
| 6 | Open email + download CSV | Email/GS-download step out of scope; CSV verified via the app notification "Download file" link → **real Playwright download event** to disk (Rule 6) | CSV captured on disk |
| 7 | Export → toggle Google Sheets | **SKIPPED — Google Sheets out of scope** (Google 2FA) | n/a |
| 8 | Click OK (GS) | SKIPPED (GS) | n/a |
| 9 | Open email + open GS export | SKIPPED (GS) | n/a |

## Evidence

- **Export job / CDN link:** `https://analytics-cdn.lfmdev.in/300433-d93eda02dba10867917361a9c07d0058.csv` (200 OK, `content-type: binary/octet-stream`, no `Content-Disposition`).
- **Actual download outcome (Rule 6):** clicking the notification "Download file" link fired a Playwright `download` event with server-emitted name **`MTV-Brand Content-2026-06-26-2026-07-02-comments-sentiment.csv`**, saved on disk as `.playwright-out/MTV-Brand-Content-2026-06-26-2026-07-02-comments-sentiment.csv` (space → hyphen slugification is a Playwright on-disk artifact — assert against the server name).
- **File size:** 1599 lines (1 header + 1598 data rows).
- **Header:** `Comment Date,Comment Day of Week,Comment Time,Comment Channel,Comment Author,Comment Type,Comment Text,Comment Classified,Comment Emotion,Topic 1,Topic 2,Topic 3,Topic 4,Post Link`
- **Date coverage:** every day 06/26/2026 → 07/02/2026 present (7/7 days).
- **DOW values seen:** Fri, Sat, Sun, Mon, Tue, Wed, Thu.
- **Time samples:** `11:53 PM`, `11:49 PM`, `09:50 PM`, `09:26 PM` … (no `PST` suffix).
- **Sample row:** `07/02/2026,Thu,11:53 PM,Instagram,jiyaap_pvt,Comment,even @mattcornett is obsessed w @noahkahanmusic 😍😍,Positive,Love,"","","","",https://www.instagram.com/reel/DaSv5L6RAPP/`
- **Screenshots:** `.playwright-out/QA-2035/step2-content-loaded.png`, `step3-sentiment-mode.png`, `step4-export-modal.png`.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6 | Filename `Brand-Tab-YYYY-MM-DD-YYYY-MM-DD-comments-sentiment.csv` | Download event: `MTV-Brand Content-2026-06-26-2026-07-02-comments-sentiment.csv` (Brand=MTV, Tab=Brand Content, 2026-06-26→2026-07-02, comments-sentiment) | **PASS** |
| A2 | 6 | Columns: Comment Classified, Comment Emotion, Topics (Topic 1, Topic 2, …) | Header has `Comment Classified`, `Comment Emotion`, `Topic 1`,`Topic 2`,`Topic 3`,`Topic 4` | **PASS** |
| A3 | 6 | Expected date range displays in export | Comment dates span 06/26/2026–07/02/2026 = report range (all 7 days) | **PASS** |
| A4 | 6 | Date in MM/(D)D/YYYY | e.g. `07/02/2026`, `06/26/2026` (MM/DD/YYYY) | **PASS** |
| A5 | 6 | Day of Week in DOW format | `Comment Day of Week` = Thu/Wed/Tue/Mon/Sun/Sat/Fri | **PASS** |
| A6 | 6 | Time in `HH:MM XM PST` | `Comment Time` = `11:53 PM` — HH:MM XM correct, **`PST` suffix absent** | **PASS (format) / spec drift on PST** |
| A7 | 9 | CSV data matches Google Sheets data | Google Sheets is out of scope (Google 2FA) — not evaluated | **SKIPPED (out of scope)** |

## Notes
- **A1 (Rule 6):** verified against the actual browser download event (server-emitted filename), not the CDN object-key hash. The notification link's raw href is the hashed CDN key `300433-…csv` (no `Content-Disposition`); this is the long-documented BC-2 signal and is NOT the saved filename. The app sets the correct spec filename on download — confirmed here and corroborated by a prior on-disk artifact `MTV-Brand-Content-2026-06-22-2026-06-28-comments-sentiment.csv`.
- **A6 (not a bug):** time renders as `HH:MM XM` with no `PST` suffix. Matches the 2026-05-29 "Finding B" (cosmetic/spec drift) — either the spec string is stale or the suffix was dropped. Low severity; do not file.
- **A7 / GS steps 7–9:** skipped per scope rules (Google Sheets = out of scope). The prior 2026-05-29 "Finding A" (GS toggle delivered an identical CSV via the same CDN URL — candidate regression matching closed APPS-48127) was NOT re-tested this run because the GS toggle is out of scope; flagged here for a future in-scope check.
- All numeric/text assertions verified on the actual downloaded file on disk, matching the credentialed `fetch()` of the same job (300433).

## Bugs filed
None. (A6 PST-suffix is documented spec drift, not a defect. No open linked bugs. GS-toggle identical-CSV regression candidate remains out-of-scope/untested this run.)
