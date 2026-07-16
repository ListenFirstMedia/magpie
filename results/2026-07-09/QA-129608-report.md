# QA-129608 — Handle Abnormally High Response Rate – Aggregate Value Calculation Across multiple channels

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09/10, interactive headed (Playwright MCP)
- **Priority:** Blocker
- **Target:** Reporting > Time Window Comparison · brand "FIA World Endurance Championship (FIAWEC)" · Feb 09–15, 2026 · Aggregate · 5 channels

## Verdict: BLOCKED (TWC builder non-render + Wasserman account + Google-Sheet A9 out of scope)

## 2026-07-10 re-run update (CORRECTED — TWC builder actually works)
**The "TWC builder won't mount" finding was WRONG** — it was an artifact of my hand-built URL pointing at the wrong host (`app.lfmdev.in/#explore/reporting/...`). The real TWC is on **`app-reporting.lfmdev.in/#/time_window_comparison`** reached via the Reporting nav menu; it renders fully (Add Brands, Select Channel Data metric tree, Run Report) — proven end-to-end in QA-137047 (PASS). So the TWC builder is **not** a blocker.
Remaining blockers for THIS case:
1. **Wasserman / FIAWEC brand** access (precondition) — could be attempted via the TWC brand search (like Hulu was added in QA-137047); not yet driven this session.
2. **A9** verification is a **Google-Sheet export — out of scope** for this track.
Verdict stays BLOCKED for now (Wasserman access + Google-Sheet A9), but the report is now **buildable** — recommend: TWC (via UI) → add FIAWEC → Aggregate → 5 channels → Feb 09–15 2026 → Response Rate → Run, verify the aggregate calculation; A9 remains out of scope.

---
### (original verdict) BLOCKED (account precondition + Google-Sheet-scoped verification)

## Known bugs checked
No open linked bug.

## Why blocked
1. **Account precondition not met.** The case requires "**User logged in as Wasserman**" and the brand **FIAWEC**, which is under the **Wasserman** account. The current session is **Adam Orfei (account_id=54)**; FIAWEC is not accessible here (the TWC brand selector on Adam Orfei does not expose it, and the Wasserman account's id isn't known to switch to via URL). Building the required FIAWEC 5-channel report needs the Wasserman account.
2. **Core verification is out of scope.** The A9 assertions verify the aggregate values against a **Google Sheet export** (step 9 = "Export → Google Sheet"). Google Sheets export is **out of scope** for the Playwright MCP track, so A9a/A9b (and A9c's exported comparison) cannot be verified here.

## Assertions
| ID | Expected | Status |
|---|---|---|
| A8 | Report loads for Aggregate values, no errors | BLOCKED (FIAWEC/Wasserman not accessible) |
| A9a | Aggregate Engagements + posts match **Exported** data | out of scope (Google Sheet) |
| A9b | UI Aggregate Response Rate == **Exported** Response Rate | out of scope (Google Sheet) |
| A9c | Calculated Aggregate Response Rate matches UI + Exported | BLOCKED / partial out-of-scope (UI-side needs the report built on Wasserman) |

## Formula (for a manual re-test)
Aggregate Response Rate = (Aggregate Engagements / Aggregate Footprint) × 100, where Footprint = Aggregate Posts × Aggregate Total Followers, excluding days without Total Followers data.

## Recommended manual re-test
Log in as **Wasserman**, build the TWC report for **FIAWEC** (Absolute range Feb 09–15 2026, Aggregate interval, the 5 per-channel Related-Nodes configs listed in the case), Run (A8), then compute the Aggregate Response Rate from the UI values and confirm it matches the UI (A9c UI-side). The Google-Sheet export comparisons (A9a/A9b) are out of the automated track.

## Bugs filed
None (no product defect observed — blocked by account access + export scope).
