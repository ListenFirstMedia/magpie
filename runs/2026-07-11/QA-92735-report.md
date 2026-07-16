# QA-92735 — Brand > Audience - LinkedIn - Basic View — 2026-07-11

- **Env:** Dev (app.lfmdev.in) · Playwright MCP, headless · **User:** lfiqa@listenfirstmedia.com
- **Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756)
- **Channel:** LinkedIn only · **Window:** Jan 01 – Dec 31 2025 · **Perspective:** Authorized (toggle locked/disabled for this brand)
- **Skills:** view-perspective-toggle + audience-metrics-export (Brand>Audience nav pattern)
- **Verdict:** **PASS** (functional assertions A1/A3/A4 pass; A2 probe — APPS-58574 RE-REPRODUCED, Trivial cosmetic, does not affect verdict)

## Steps executed
1. Pre-flight: programmatic Cognito email/password login → `#home` rendered (title "Home").
2. Navigated directly to Brand > Audience for UCLA with full params (`brand_id=127756&account_id=799&from=2025-01-01&to=2025-12-31&channels=linkedin&perspective=extended`) — page painted on first load (no skeleton hang; date params present per the Audience-needs-from/to quirk).
3. Confirmed brand/account via breadcrumb ("Account: UCLA") and channel-ghost DOM: **only `linkedin channel-ghost enabled`**; Facebook/X/Instagram/YouTube/Threads all `disabled`.
4. Confirmed default Basic view loaded; perspective input `#perspective` = `checked:true, disabled:true` → Authorized locked (UCLA LinkedIn Audience has no Public perspective toggle available — matches prior runs).
5. Inspected first row of audience cards via DOM `getBoundingClientRect` geometry + full-page screenshot.
6. Scrolled/captured Followers By Country / Region / Geo-Breakdown tiles (full-page screenshot).

## Tile layout measurement (A2 probe)

Container width: **1280px** (content 1240px). Four `lfm-col-3` cards (4×295 = 1180px) would fit on one row.

| Tile | top | left | width | col class |
|------|-----|------|-------|-----------|
| Followers: Job Function | 328 | 10 | 295 | lfm-col-3 |
| Followers: Industry | 728 | 20 | 295 | lfm-col-3 |
| Followers: Seniority | 728 | 335 | 295 | lfm-col-3 |
| Followers: Staff Count Range | 728 | 650 | 295 | lfm-col-3 |
| Followers By Country | 1128 | 20 | 610 | lfm-col-6 |
| Followers By Region | 1128 | 650 | 610 | lfm-col-6 |
| Followers: Geo Breakdown By Country | 1597 | 20 | 610 | lfm-col-6 |
| Followers: Geo Breakdown By Region | 1597 | 650 | 610 | lfm-col-6 |

**Job Function sits ALONE on row 1** (top=328, left=10) while the other three col-3 cards share row 2 (top=728, lefts 20/335/650). Same 1+3 topology as the 2026-06-02 and 2026-06-04 batch-6 runs → **APPS-58574 RE-REPRODUCED, unchanged.** Note left=10 for the row-1 card vs left=20 for the row-2 cards (extra half-gutter offset). Visually confirmed in screenshot: a large blank gap to the right of the Job Function tile.

## Tile data (A3 — counts populated, non-zero)
- **Job Function:** Business Development 13%, Education 11%, Engineering 8%, Healthcare Services 7%, Operations 7%, Research 6%, Sales 5%, Information Technology 4%, Finance 4%… (matches 2026-06-02 values exactly — no data regression).
- **Industry:** Higher Education 14%, Computer Software 5%, Hospital & Health Care 4%, Information Technology & Services 3%, Medical Practice 3%, Law Practice 3%…
- **Seniority:** Senior 34%, Entry 33%, Director 9%, Manager 7%, Owner 4%, VP 4%, CXO 4%, Training 4%, Partner 1%, Unpaid 0.64%.
- **Staff Count Range:** Size 10,001 or more 25%, Size 1,001 to 5,000 15%, Size 11 to 50 12%, Size 2 to 10 11%, Size 51 to 200 11%, Size 5,001 to 10,000 11%, Size 201 to 500 8%, Size 501 to 1,000 6%, Size 1 1%.
- Followers By Country / Region maps + Geo Breakdown By Country/Region tables all rendered with populated values (US, LA metro, etc.).

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | LinkedIn Audience page loads with cards rendered | All 8 tiles rendered (Job Function, Industry, Seniority, Staff Count Range, Followers By Country, Followers By Region, Geo Breakdown By Country, Geo Breakdown By Region) + channel bar + toolbar | PASS |
| A2 (probe) | 5 | First-row cards align on a single line | First row has only Job Function (top=328, left=10); other 3 col-3 cards pushed to row 2 (top=728) | **APPS-58574 REPRODUCED** (Trivial cosmetic — does not change verdict) |
| A3 | 5–6 | Tile titles + counts correct, non-zero where data exists | All LinkedIn tiles populated with correct shares (see above); values match prior run — no regression | PASS |
| A4 | 5–6 | Layout visually correct (no overlap, no truncation) | No overlap/truncation beyond the row-1 misalignment covered by A2 | PASS |

## Known bugs checked
- **bug-history.md (QA-92735):** APPS-58574 (Bug, Trivial, In Progress) — "Brand Audience LinkedIn first row cards misaligned, separated into two lines (UCLA)". Prior runs 2026-06-02 / 2026-06-04 batch-6 both PASS with the bug reproduced. Sweep note: *"Document layout drift but don't fail on this."*
- **Case file "## Probes (open bugs)":** APPS-58574 only, tied to A2.
- **Outcome:** APPS-58574 **RE-REPRODUCED** this run (identical 1+3 tile topology). It is a Trivial cosmetic misalignment that does not interfere with A1/A3/A4 (page loads, data correct, no overlap/truncation) → per the open-bug/interferes rule and the KB sweep note, it does **not** block the case. No regression in the underlying data or feature.
- No other linked/related open bug touches this surface's assertions.

## Bugs filed
_None._ APPS-58574 is an existing open Trivial bug, re-reproduced as expected (not a new defect, not a regression). Reported here as a probe outcome only — no Jira ticket created (markdown-only per framework).

## Evidence
- `.playwright-out/QA-92735/01-linkedin-audience-full.png` — full-page render (UCLA / LinkedIn / Jan 1–Dec 31 2025 / Authorized; shows the row-1 Job Function misalignment + all 8 tiles).
- DOM geometry + tile-data probes inline above.
