# QA-129803 — Handle Abnormally High Response Rate – Exclude Days Without Follower for Facebook

- **Run date:** 2026-07-04 (headless Playwright MCP, unattended)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-129803
- **Priority:** Critical (P2)
- **Account:** Wasserman (account_id=863) — confirmed via breadcrumb `Account: Wasserman`
- **Brand:** FIA World Endurance Championship (FIAWEC) — exact-match from Results (Rule 1)
- **Channel / Perspective:** Facebook / Public Data (per-brand View toggle **disabled** on FIAWEC — Public only; spec does not require Authorized)
- **Date range:** Sep 26, 2025 – Oct 3, 2025 (Absolute Dates, interval Days)
- **Report:** `https://app-reporting.lfmdev.in/#story/time_window_comparison/155592`
- **Data Last Updated (PT):** 07-03-2026 04:29 PM
- **Verdict:** **PASS** (5/5 in-scope). GS steps skipped (out of scope).
- **Skill reused:** `time-window-comparison-run` (v6), `switch-account` (v2), `response-rate-math-verifier` (v2)
- **Open linked bugs:** None open (screened) — ran normally.

## Steps executed

1. Pre-flight: navigated app.lfmdev.in → Cognito hosted UI → filled "With existing account" (lfiqa@…) → `#home`, title "Home - ListenFirst". ✓
2. Switched account to Wasserman via LFQA menu (hover) → Search Account "Wasserman" → clicked `.lfm-ta-option` under Results. Breadcrumb `Account: Wasserman`. ✓
3. Reporting → Time Window Comparison (hover-open nav). ✓
4. Add Brand By Name → typed "FIA World Endurance" → clicked exact "FIA World Endurance Championship (FIAWEC)" from Results. Brand row added (View: Public Data, toggle disabled). ✓
5. Absolute Dates / interval Days (default). Navigated Start calendar back 9 months → Sep 2025, clicked day 26; navigated End calendar → Oct 2025, clicked day 3. Verified `range-start=26 (Sep) / range-end=3 (Oct)`. ✓
6. By Channel → Facebook metrics via Filter Metrics: **Facebook Total Fans** (Audience & Growth 1/36), **Facebook Engagements**, **Facebook Posts**, **Facebook Response Rate** (Content 3/263). Selected the plain metrics, not the "(with Clicks)" / "(Authorized)" variants. ✓
7. Run Report → story 155592 built. ✓
8. Reviewed report — 4 metric tables render, header `Time Window Comparison (Sep 26, 2025 - Oct 3, 2025)`, no error banners. ✓
9. Export → Google Sheets — **SKIPPED (out of scope**, Google 2FA). A2 verified on UI side only.

## Report data (per-day, FIAWEC, Facebook)

| Date | Total Fans | Engagements | Posts | Response Rate (UI) | RR computed = Eng/(Fans×Posts)×100 |
|------|-----------|-------------|-------|--------------------|-------------------------------------|
| Sep 26, 2025 | – | 10,398 | 15 | – | (Total Fans absent → excluded) |
| Sep 27, 2025 | – | 12,687 | 22 | – | (excluded) |
| Sep 28, 2025 | – | 17,117 | 12 | – | (excluded) |
| Sep 29, 2025 | – | 2,237 | 3 | – | (excluded) |
| Sep 30, 2025 | 571,924 | 1,698 | 3 | 0.10% | 1698/(571924×3)×100 = 0.0990% → 0.10% ✓ |
| Oct 01, 2025 | 572,213 | 2,486 | 1 | 0.43% | 2486/(572213×1)×100 = 0.4344% → 0.43% ✓ |
| Oct 02, 2025 | 572,402 | 3,204 | 3 | 0.19% | 3204/(572402×3)×100 = 0.1866% → 0.19% ✓ |
| Oct 03, 2025 | 572,608 | 4,234 | 4 | 0.18% | 4234/(572608×4)×100 = 0.1848% → 0.18% ✓ |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 8 | Report loads successfully with no errors | Story 155592 rendered; 4 metric tables + header; no error banner | **PASS** |
| A2 | 10 | Engagements same on UI and Google Sheet | Engagements present all 8 days on UI (10,398 / 12,687 / 17,117 / 2,237 / 1,698 / 2,486 / 3,204 / 4,234). **GS side not verified — out of scope (Google 2FA).** | **PASS (UI only; GS skipped)** |
| A3 | 10 | Total Fans displayed only for days where it exists | Total Fans em-dash Sep 26–29 (no follower data); populated Sep 30–Oct 3 (571,924 / 572,213 / 572,402 / 572,608) | **PASS** |
| A4 | 10 | Response Rate same and only for days where Total Fans exists | RR em-dash exactly Sep 26–29 (mirrors Total Fans absence); populated Sep 30–Oct 3 (0.10 / 0.43 / 0.19 / 0.18%) | **PASS** |
| A5 | 10 | Day-wise RR = Engagements/(Total Fans × Posts) × 100, matches UI | All 4 populated days match UI to rounding (see table above) | **PASS (UI; GS not compared — out of scope)** |

## Evidence

- Builder config (brand/dates/metrics): `.playwright-out/QA-129803/01-builder-config.png`
- Built report tables: `.playwright-out/QA-129803/02-report-tables.png`
- Report URL: `#story/time_window_comparison/155592`
- Exact per-day values captured via DOM read of the 4 metric tables (see table above).

## Notes / scope

- **Google Sheets export (spec step 9 + the "and Google Sheet" halves of A2/A5) skipped** — out of scope on the headless track (Google 2FA on a separate auth surface). All in-scope UI assertions pass, so the verdict is PASS per scope rules. Prior interactive runs also confirmed the GS export button hangs on Wasserman (see known-quirks 2026-06-11), independent of correctness.
- FIAWEC View toggle is disabled (Public Data only). Facebook Engagements/Posts/Response Rate are accessible in Public mode for this brand — consistent with the 2026-05-29 run.
- Result reproduces the 2026-05-27 / 2026-05-29 PASS 5/5 exactly (same values, same em-dash exclusion Sep 26–29).

## Bugs filed

None. Behavior is correct: Response Rate correctly excludes days lacking Facebook follower (Total Fans) data, and the day-wise formula holds on all populated days.
