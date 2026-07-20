# QA-129801 — Handle Abnormally High Response Rate – Exclude Days Without Follower for Instagram On Daily Basis

**Run date:** 2026-07-08
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Skills used:** [time-window-comparison-run](../../skills/time-window-comparison-run/SKILL.md) v6, [response-rate-math-verifier](../../skills/response-rate-math-verifier/SKILL.md) v2
**Account:** Wasserman · **Brand:** FIA World Endurance Championship (FIAWEC) · **Report:** story/time_window_comparison/155737 (reused QA-129802's brand/date via Change Settings, swapped channel/metrics)

## Steps executed

1. From the QA-129802 story, clicked "Change Settings" to reuse brand (FIAWEC) + date range (Sep 26 – Oct 3, 2025) without rebuilding from scratch.
2. Switched to "By Channel" view, clicked YouTube's bulk "Off" to clear its 4 metrics (0/29).
3. Expanded Instagram → Audience & Growth, selected "Total Followers".
4. Expanded Instagram → Content, selected "Organic Response Rate", "Posts", "Engagements (Public Only)" — exact spec metric names, by their `checkbox` refs.
5. Clicked Run Report → new story 155737 built.
6. Read all 4 metric tables via DOM.
7. Exported CSV and read the saved file from `.playwright-out/`.

## Raw data (UI, cross-checked against CSV)

| Date | Total Followers | Engagements (Public Only) | Posts | Organic Response Rate (UI) | Organic Response Rate (CSV raw) |
|---|---|---|---|---|---|
| Sep 26 | – | 308,660 | 21 | – | (blank) |
| Sep 27 | – | 515,129 | 36 | – | (blank) |
| Sep 28 | – | 260,613 | 17 | – | (blank) |
| Sep 29 | – | 46,750 | 3 | – | (blank) |
| Sep 30 | 1,234,260 | 54,826 | 3 | 1.48% | 0.014806712794170866 |
| Oct 1 | 1,234,991 | 69,022 | 2 | 2.79% | 0.027944333197569858 |
| Oct 2 | 1,235,413 | 51,032 | 3 | 1.38% | 0.013769214559557546 |
| Oct 3 | 1,235,835 | 78,698 | 4 | 1.59% | 0.01592000550235266 |

## Math verification

`RR_day = Engagements / (Total Followers × Posts) × 100`

- Sep 30: 54,826 / (1,234,260 × 3) × 100 = 1.4807% → rounds to **1.48%** ✓
- Oct 1: 69,022 / (1,234,991 × 2) × 100 = 2.7944% → rounds to **2.79%** ✓
- Oct 2: 51,032 / (1,235,413 × 3) × 100 = 1.3771% → rounds to **1.38%** ✓
- Oct 3: 78,698 / (1,235,835 × 4) × 100 = 1.5920% → rounds to **1.59%** ✓
- Sep 26–29: Total Followers missing → RR correctly excluded despite Engagements and Posts both being present and substantial (e.g. Sep 27: 515,129 engagements across 36 posts) — exactly the defect class under test, handled correctly.
- **Cross-reference:** these exact figures (1.48% / 2.79% / 1.38% / 1.59%, same raw Engagements/Followers/Posts) match the prior 2026-06-11 batch-3 run recorded in the skill file — no regression across ~4 weeks.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 8 | Report loads successfully with no errors | Story 155737 built cleanly | PASS |
| A2 | 10 | Engagements match between UI Report and exported data | UI and CSV identical for all 8 days | PASS |
| A3 | 10 | Total Followers shown only for days where it exists, matching UI/export | Both blank Sep 26-29, populated Sep 30-Oct 3, values identical | PASS |
| A4 | 10 | Response Rate shown only for days where Total Followers exists, matching UI/export | Both exclude Sep 26-29; populated days match | PASS |
| A5 | 10 | Day-wise Response Rate calculation matches UI and export | All 4 computed days match exactly | PASS |

**Result: PASS 5/5**

## Problems / deviations

1. **Step 10 deviation — Google Sheets export substituted with CSV**, same as QA-129802, per `config/env.md` scope-out. Documented deliberate substitution, not a skipped verification — cross-source consistency was fully verified via CSV instead.
2. No other issues. The "Change Settings" reuse pattern (documented in the skill's 2026-06-11 update) worked cleanly and saved a full brand/date rebuild — flagged here only as a note that this pattern remains reliable, not a problem.

## Evidence

- Report URL: `app-reporting.lfmdev.in/#story/time_window_comparison/155737`
- CSV saved: `.playwright-out/FIA-World-Endurance-Championship-FIAWEC---Time-Window-Comparison---Sep-26-2025---Oct-3-2025.csv` (overwritten from QA-129802's identically-named file since filenames only encode brand+date range, not metrics — noted for the skill maintenance pass: **the export filename does not disambiguate between different metric selections on the same brand/date range**, so parallel exports on the same report window will silently overwrite each other on disk. Not a product bug (this is a Playwright-download-to-`--output-dir` artifact of automation, not a UI/export defect — a real user's browser "Save As" dialog would prompt or auto-suffix `(1)`), but worth flagging as an automation-harness gotcha for future batch runs: rename/move the file immediately after each download if a later CSV export on the same brand+date range is expected in the same session.)

## Skill maintenance

- `response-rate-math-verifier` pass_streak +1 (Instagram variant re-confirmed clean on 2026-07-08, exact match to 2026-06-11 baseline).
- `time-window-comparison-run` pass_streak +1 (Change-Settings-reuse + By-Channel bulk-Off-then-switch-channel flow both worked cleanly).

## Bugs filed

None.
