# QA-131491 — Social Recap Vs Brand > Content - IG Public Video View

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-131491
- **Priority:** Major (P3)
- **Run date:** 2026-07-15 (Playwright MCP track, QA-22296 remaining batch)
- **Account:** Adam Orfei (account_id=54)
- **Skills used:** `social-recap-report-run` (v2), `brand-content-data-set-selector` (v1)

## Steps executed

1. Switched account context from Amazon Prime Video to **Adam Orfei** via the profile dropdown Search Account → Results (per `switch-account` skill; confirmed `Account: Adam Orfei` breadcrumb + `account_id=54` in URL).
2. Reporting (top nav, hover) → Social Recap → landed on `app-reporting.lfmdev.in/#/social_recap`.
3. Add Brand By Name → typed `MTV` → clicked the literal exact-match "MTV" result from the typeahead list (Rule 1 — ignored the 70+ "MTV (...)"/"MTV ..." variants).
4. Confirmed View pill read **"Use Authorized Data"** (i.e. current state = Public Data, the spec-required default) — no toggle click needed.
5. Set Date Range: Start Date → clicked month header → selected Jan 2026 → clicked day 1. End Date synced to Jan 2026 automatically and clicked day 7. Screenshot-confirmed Jan 1 and Jan 7 2026 both highlighted in both calendars before proceeding (Rule 3).
6. Clicked **Run Report** — `Brands ✓ Dates ✓ Data ✓` all satisfied — new report generated at `report_id=156035`.
7. Waited for report render; screenshot-captured the "Best Performing Content" section.
8. Navigated Brand → Content (Home → "Brand Content" suggested tile, on the Adam Orfei account already-loaded MTV brand, `brand_id=10765`).
9. Set Date Range via the Content-page date picker (month-header → Jan year-picker → day 1 for Start, day 7 for End) to Jan 1–7, 2026. Confirmed via screenshot both calendars showed Jan 1/Jan 7 selected.
10. Channels: deselected Facebook, Twitter, TikTok (clicked each icon to grey out), leaving only **Instagram** selected → clicked **Apply**. URL confirmed `channels=instagram` only.
11. Posts list defaulted to Sort: Engagements (descending) — reviewed Post #1 (top of list = highest Engagements, same post identified in the BPC card).

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Social Recap report loads without error | Report rendered fully (report_id 156035) — Social Footprint, Social Activity (weekly + YTD), Best Performing Content all populated, no error banners | PASS |
| A2 | IG Video View metric unlocked and visible at Brand level when data available | "Video Views" donut (13M, ▲62% YoY) rendered in Social Activity section with per-channel breakdown table incl. Instagram 6,287,585 (50% share) | PASS |
| A3 | Video View metric displayed within Instagram card in 'Best Performing Content' | Instagram BPC card (@mtv, Mon Jan 05 2026 03:23 PM PST, Reel) shows: Engagements 44,227 / Reactions 43,971 / Comments 256 / **Video Views 691,822** | PASS |
| A4 | IG Video View value in Social Recap BPC card matches Brand → Content | Brand > Content, MTV, Jan 1–7 2026, Instagram-only, Post #1 (Mon Jan 05 2026 03:23 PM PST, Reel): Engagements 44,227 / Reactions 43,971 / Comments 256 / Response Rate 0.20% / **Video Views 691,822** / Video Response Rate 6.39% — **exact verbatim match** with the Social Recap BPC card across every field, not just Video Views | PASS |

## Evidence

- `.playwright-out/qa131491-01-daterange.png` — Social Recap date-range calendars (Jan 1–7 2026 selected, both sides)
- `.playwright-out/qa131491-03-bpc.png` — full Social Recap report incl. Best Performing Content row (Instagram card 3rd from left)
- `.playwright-out/qa131491-09-dates-set.png` — Brand > Content date picker confirmation (Jan 1–7 2026)
- `.playwright-out/qa131491-12-ig-only.png` — Brand > Content channel selector showing Instagram-only active
- `.playwright-out/qa131491-15-ig-post1-metrics.png` — Brand > Content Post #1 card with full metric block (691,822 Video Views)

## Cross-source parity (re-confirmed, no drift)

Same MTV / Jan 1–7 2026 / IG / Public parity value as the 2026-06-02 and 2026-06-08 runs documented in `social-recap-report-run` SKILL.md: **691,822**. Third separate-day reconfirmation, zero drift across all 3 runs.

## Status: **PASS** (4/4 assertions)

## Cleanup
Non-mutating test — no cleanup required.
