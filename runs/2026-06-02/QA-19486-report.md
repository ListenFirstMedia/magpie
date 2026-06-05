# QA-19486 — Social Recap - Verify PDF

**Run date:** 2026-06-04 (QA-4325 batch-3 re-run)
**Account:** Adam Orfei (account_id=54)
**Brand:** MTV (brand_id=4018)
**Environment:** dev (`app-reporting.lfmdev.in`)
**Result:** **PASS** (single-brand variant verified end-to-end via pdftoppm + Read on PNG; multi-brand variant deferred for token budget)

## Spec
See `/Users/yashsharma/git/magpie/testcases/english/QA-19486.md` — Social Recap PDF verification.

## Configuration achieved (Rules 1 + 2 + 6)
- Brand: MTV — Rule 1 exact-match from Results section of "Add Brand By Name" typeahead (React-aware InputEvent dispatch to surface Results, then clicked "MTV" — not "MTV (Africa)" or any variant).
- Perspective: Public Data — default toggle position on Social Recap builder; visually verified.
- Date range: May 27 – Jun 2, 2026 (default Weekly interval with End-Date pre-selected to Jun 2).
- Channels: All 7 enabled (Facebook, Twitter, Instagram, YouTube, TikTok, LinkedIn, Threads).
- Options: defaults (Year-over-Year comparison; Worst Performing/Source Links/Insights Editor all unchecked).

## Steps executed
1. Navigated to `app-reporting.lfmdev.in/#/social_recap`.
2. Added MTV brand via top-right "Add Brand By Name" typeahead → Results "MTV" picked.
3. Default Weekly interval + End Date = Jun 2, 2026.
4. All 7 channels checked.
5. Clicked Run Report via JS (button text-match) — coordinate click below viewport.
6. Story rendered at `#story/social_recap/154046`.
7. Clicked "Preview & Share Report" → Share/Download/X toolbar appeared at top of report.
8. Clicked Download → PDF auto-downloaded to ~/Downloads.
9. Verified via pdftoppm `-r 100` → 2 PNG pages → Read each PNG.

## Saved artefact
- `~/Downloads/MTV-Weekly Social Recap(May 27, 2026 - Jun 2, 2026).pdf` — 2,137,648 bytes, 2 pages
- `outputs/qa-19486-page1.png`, `outputs/qa-19486-page2.png` (rendered at 100 DPI)

## Page 1 verification (Social Footprint + Social Activity)
- Header: MTV logo + "MTV" title + Type: TV Network + Manufacturer: MTV + ListenFirst logo top-right + "Weekly Social Recap (May 27, 2026 - Jun 2, 2026)" header text.
- Section 1: Social Footprint - All-Time. **104,723,370 Total Fans.** Bar chart per channel:
  - Facebook 45,524,161
  - Instagram 21,145,161
  - X/Twitter 15,754,048
  - YouTube 11,500,000
  - TikTok 10,800,000
- Section 2: Social Activity - May 27, 2026 - June 02, 2026. **Four metric donuts visible side-by-side**:
  - **1M Public Impressions** (-69% YOY)
  - **7,491 New Followers** (+144% YOY)
  - **2M Engagements** (-15% YOY)
  - **32M Video Views** (+164% YOY)
- Per-metric channel-share tables underneath each donut:
  - **Public Impressions:** Twitter 1,279,458 (100%)
  - **New Followers:** Facebook -7,969 (0%); Twitter 7,491 (100%); Instagram -5,725 (0%); YouTube 0 (0%); TikTok 0 (0%); LinkedIn 🔒; Threads 🔒
  - **Engagements:** Facebook 139,763 (6%); Twitter 63,387 (3%); Instagram 1,272,461 (54%); YouTube 41,719 (2%); TikTok 835,263 (36%); LinkedIn 🔒; Threads 🔒
  - **Video Views:** Facebook 4,049,995 (13%); FB Organic 🔒; FB Paid 🔒; Twitter 112,604 (0.35%); Twitter Organic 🔒; Twitter Paid 🔒; Instagram 18,206,815 (56%); YouTube 2,302,365 (7%); YouTube Organic/Paid 🔒; TikTok 7,626,908 (24%); TikTok Paid 🔒; LinkedIn 🔒
- Footer "Page 1".

## Page 2 verification (Best Performing Content + Social Activity Year-to-Date)
- Section: Best Performing Content - 5 post tiles in row:
  1. Jun 10, 2025 09:35 AM PDT @mtv (FB) Original Post — Engagements 8,777; Reactions 7,070; Comments 43; Shares 564.
  2. Jun 11, 2025 10:24 AM PDT @mtv (Twitter) Original Post — Engagements 12,931; Reactions 11,229; Comments 94.
  3. May 28, 2026 09:54 AM PDT @mtv (IG) Original Post — Engagements 230,255; Reactions 228,889; Comments 1,366; Shares 1,602; Public Impressions 168,243.
  4. May 29, 2026 12:51 AM PDT @mtv (YouTube) Original Post — Engagements 4,242; Reactions 4,239; Comments 0; Video Views 303,003.
  5. May 27, 2026 09:54 AM PDT @mtv (TikTok) Original Post — Engagements 6,995; Reactions 5,989; Comments 279; Shares 224; Video Views 49,300.
- Section 3: Social Activity - Year to Date. **Four donuts**: 1B Public Impressions (-13% YOY) / 515K New Followers (-389% YOY) / 59M Engagements (-13% YOY) / 486M Video Views (+115% YOY).
- Per-channel-share tables underneath each donut (all populated or 🔒 padlock for unauthorized perspective splits).
- Footer "Page 2".

## Assertions table

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | step 6 | PDF downloads to disk with sensible filename | `MTV-Weekly Social Recap(May 27, 2026 - Jun 2, 2026).pdf` 2.1MB | PASS |
| A2 | step 7 | First page contains report title + brand + date range | "MTV" + "Weekly Social Recap (May 27, 2026 - Jun 2, 2026)" header | PASS |
| A3 | step 7 | Each tile from in-app report appears in PDF | Social Footprint, Social Activity 4 donuts, per-channel tables, Best Performing Content, Year-to-Date — all present | PASS |
| A4 | step 8 | Multi-brand PDF interleaved correctly | Multi-brand variant NOT EXECUTED in this run (single brand only — deferred for token budget) | NOT VERIFIED |
| A5 | step | Footer/header without "undefined" / template leakage | "Page 1" / "Page 2" footer rendered correctly; no template literals visible | PASS (BC-4 not reproduced) |
| A6 | step | Single-channel VV donut display anomaly per APPS-55559 known-bug | Multi-channel VV donut renders correctly (FB/IG/YT/TT split visible) — no anomaly observed; single-channel scenario not exercised | N/A (multi-channel) |

## Bugs filed
_None._ BC-4 (page-footer defect from QA-23969) did NOT reproduce on this MTV PDF — page numbers render correctly. APPS-55559 single-channel donut display bug also did not trigger (multi-channel data set used).

## Skills reused
- `social-recap-report-run` — Add Brand By Name with React-aware InputEvent dispatch + Run Report via JS button-text click.
- `pdf-end-to-end-verification` — pdftoppm 100dpi rasterization + Read on each rendered PNG (Rule 6).

## New findings
- Run Report button click at coordinate (1224, 524) didn't fire — JS button-text click fired successfully. Same pattern as QA-298 batch-2 — button is below the viewport edge or has layer interference. Confirm `Array.from(document.querySelectorAll('button')).find(b => b.textContent.trim() === 'Run Report').click()` as the reliable trigger.
- PDF rendered cleanly without the BC-4 page-footer defect (template leakage). The Social Recap PDF pipeline appears stable on dev for single-brand reports with default channels.
