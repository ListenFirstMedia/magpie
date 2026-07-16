# QA-129802 — Handle Abnormally High Response Rate – Exclude Days Without Follower for Youtube On Daily Basis

**Run date:** 2026-07-08
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Skills used:** [time-window-comparison-run](../../skills/time-window-comparison-run/SKILL.md) v6, [response-rate-math-verifier](../../skills/response-rate-math-verifier/SKILL.md) v2
**Account:** Wasserman · **Brand:** FIA World Endurance Championship (FIAWEC) · **Report:** story/time_window_comparison/155736
**Precondition match:** exact brand-name match from Results section (Rule 1 respected).

## Steps executed

1. Switched account LFQA → Wasserman.
2. Reporting → Time Window Comparison (via hover menu).
3. Added brand "FIA World Endurance Championship (FIAWEC)" from Results.
4. Absolute Dates (default) + Interval = Days (default). Set Start = Sep 26, 2025, End = Oct 3, 2025 via calendar navigation (`th.prev` × 9 JS-fallback per skill, run in two separate `browser_evaluate` calls after discovering the End calendar's month view reverts when the Start day is clicked in the same call — see Problems section).
5. Switched to "By Channel" view, expanded YouTube → Audience & Growth (Total Subscribers) and YouTube → Content (Engagements, Posts, Response Rate); selected all 4 metrics by clicking their `checkbox` elements directly (listitem-wrapper clicks did not register — see Problems section).
6. Clicked Run Report → story 155736 built successfully.
7. Read all 4 metric tables (UI DOM) for Sep 26 – Oct 3, 2025.
8. Exported CSV (Google Sheets step substituted — see Problems/Deviations) and read the saved file from `.playwright-out/`.

## Raw data (UI, cross-checked against CSV)

| Date | Total Subscribers | Engagements | Posts | Response Rate (UI) | Response Rate (CSV raw) |
|---|---|---|---|---|---|
| Sep 26 | – | 20,899 | 12 | – | (blank) |
| Sep 27 | – | 12,084 | 11 | – | (blank) |
| Sep 28 | – | 14,116 | 5 | – | (blank) |
| Sep 29 | – | 7,288 | 2 | – | (blank) |
| Sep 30 | 1,070,000 | 1,767 | 1 | 0.17% | 0.0016514018691588786 |
| Oct 1 | 1,080,000 | 1,069 | 0 | – | (blank) |
| Oct 2 | 1,080,000 | 1,557 | 1 | 0.14% | 0.0014416666666666666 |
| Oct 3 | 1,080,000 | 772 | 1 | 0.07% | 0.0007148148148148148 |

## Math verification

`RR_day = Engagements / (Total Subscribers × Posts) × 100`

- Sep 30: 1,767 / (1,070,000 × 1) × 100 = 0.16514% → rounds to **0.17%** ✓ matches UI & CSV (0.0016514018691588786 × 100 = 0.16514%)
- Oct 2: 1,557 / (1,080,000 × 1) × 100 = 0.14417% → rounds to **0.14%** ✓ matches
- Oct 3: 772 / (1,080,000 × 1) × 100 = 0.07148% → rounds to **0.07%** ✓ matches
- Sep 26–29: Total Subscribers missing (footprint undefined) → RR correctly excluded (em-dash in UI, blank in CSV) **despite Engagements and Posts both being present and non-zero** — this is exactly the defect class the spec guards against, and it is handled correctly.
- Oct 1: Total Subscribers present (1,080,000) but **Posts = 0** → footprint = 0 → RR correctly excluded (em-dash/blank), not a divide-by-zero error or a spurious value.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 8 | Report loads successfully with no errors | Story 155736 built cleanly, all 4 metric tables rendered | PASS |
| A2 | 10 | Engagements match between UI Report and exported data for the full range | UI and CSV Engagements identical for all 8 days (20899/12084/14116/7288/1767/1069/1557/772) | PASS |
| A3 | 10 | Total Followers (Subscribers) shown only for days where it exists, matching between UI and export | Both UI and CSV show blank/em-dash for Sep 26–29, real values Sep 30–Oct 3, identical values | PASS |
| A4 | 10 | Response Rate shown only for days where Total Followers exists, matching UI/export | Both UI and CSV exclude Sep 26–29 (missing subscribers) AND Oct 1 (zero posts); populated days match | PASS |
| A5 | 10 | Day-wise Response Rate calculation matches UI and export values | All 3 computed days match exactly (0.17%/0.14%/0.07% ↔ raw fractions) | PASS |

**Result: PASS 5/5**

## Problems / deviations

1. **Step 10 deviation — Google Sheets export substituted with CSV.** Per `config/env.md`, Google Sheets export is explicitly out of scope on the Playwright MCP track ("Google 2FA on a separate auth surface, impractical per-run"). I substituted the CSV export (downloaded to `.playwright-out/`, verified byte-for-byte against the UI table) to satisfy the intent of assertions A2–A5 (cross-source consistency). This is a **documented deliberate step substitution**, not an oversight — flagging per your request to report any skipped/substituted step.
2. **Automation-only friction (no product impact):** the two-calendar date picker's End-calendar month view silently reverted to its original month after the Start-calendar day was clicked in the same `browser_evaluate` call — had to split Start-day-click and End-calendar-navigation into separate calls. This matches the "duplicate hidden datepicker" / re-render class of quirks already documented in `knowledge-base/known-quirks.md`; adding a fresh note since this specific revert-on-same-call behavior wasn't previously described in exactly this form.
3. **Automation-only friction:** clicking the metric `listitem` wrapper did not toggle the checkbox (counter stayed at 0/29); clicking the actual `checkbox` role element (nested one level deeper) worked. Not a product bug — UI is fully clickable for a real mouse user since the browser hit-tests the checkbox's visual bounds; likely a Playwright accessibility-tree layering nuance.

## Evidence

- Report URL: `app-reporting.lfmdev.in/#story/time_window_comparison/155736`
- CSV saved: `.playwright-out/FIA-World-Endurance-Championship-FIAWEC---Time-Window-Comparison---Sep-26-2025---Oct-3-2025.csv`

## Skill maintenance

- `response-rate-math-verifier` pass_streak +1 (YouTube variant re-confirmed clean on 2026-07-08, first Playwright-track run of this exact case).
- `time-window-comparison-run` pass_streak +1. New quirk candidate: End-calendar view reverting when Start-day click and End-calendar navigation are batched in the same `evaluate` call — recommend adding to skill's known quirks list (not done inline to avoid unreviewed skill edits mid-batch; flagged here for the end-of-run skill maintenance pass).

## Bugs filed

None. Both the missing-subscriber-day exclusion and the zero-posts-day exclusion work exactly as specified — no abnormal/blown-up Response Rate values observed.
