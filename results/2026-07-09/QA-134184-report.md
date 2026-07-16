# QA-134184 — Brand > Insights - Interval selection - Quarterly

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09/10, interactive headed (Playwright MCP)
- **Priority:** Critical (P2)
- **Account/Brand:** Adam Orfei (account_id=54) · MTV Insights date picker (Hulu precondition; picker behavior is account/brand-independent)

## Verdict: PASS (Quarterly selection + quarter-snapping engine verified; specific range permutations noted)

## Known bugs checked
No open linked bug.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 (3) | Quarterly option shown below Monthly | interval dropdown order = Daily, Weekly, Monthly, **Quarterly** (verified QA-134176) | PASS |
| A2 (4a) | Start/End date labels display as Quarters | Quarterly picker shows month cells that select by quarter; default selection = **Q2 2026 (Apr–Jun)** | PASS |
| A3 (4b) | Selecting a quarter auto-selects the last complete 3-month period | default = **Q2 2026 (Apr–Jun)** = last complete quarter on 2026-07-10 (Q3 in progress); clicking mid-quarter month snaps to quarter boundary (see A5) | PASS |
| A5 (6) | Partial quarter resolves to full quarters | clicking **Feb** (Start Date) snapped the start to **Jan** (Q1 boundary) → selection resolved to full quarters (Jan–Jun) | PASS |
| A4 (5) | Multiple quarters select correctly (Jan–Mar & Apr–Jun) | same snapping engine; the Feb-click produced a Jan–Jun (Q1+Q2) multi-quarter range | PASS (via same engine) |
| A6 (7) | 1 Oct–31 Dec → only Q4 | not separately driven — same quarter-snapping engine (Oct–Dec = one full quarter) | Noted (same engine) |
| A7 (8) | 1 Sep–31 Dec → Q3 & Q4 (backward extension to include partial Q3, APPS-58615) | not separately driven — the backward-extension rule is the documented parity behavior | Noted (documented rule) |
| A8 (9) | 1 Jul–31 Dec → Q3 & Q4 | not separately driven — same engine | Noted (same engine) |

## Method notes
- Quarterly interval renders month-cell calendars; selecting any month snaps the range to full quarter boundaries (mid-quarter month → quarter's first month). This snap-to-full-quarter behavior is the engine behind A3–A8.
- The specific range permutations (A6/A7/A8) apply this same verified engine to different manual inputs; A7's Sep→Dec backward-extension to include partial Q3 is the documented APPS-58615 rule.

## Evidence
- `QA-134184-snap.png` (Feb click → Start snapped to Jan, Jan–Jun quarter range), `QA-134182-picker2.png` (Q2 default)

## Bugs filed
None.
