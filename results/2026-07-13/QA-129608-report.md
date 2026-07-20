# QA-129608 — Handle Abnormally High Response Rate – Aggregate Value Calculation Across Multiple Channels — 2026-07-13

- **Env:** Dev (app.lfmdev.in / app-reporting.lfmdev.in) · **Account:** Wasserman (switched via TWC Search-Account) · **User:** lfiqa@listenfirstmedia.com
- **Surface:** Reporting → Time Window Comparison · **Brand:** FIA World Endurance Championship (FIAWEC) · **Window:** Feb 09–15, 2026 · **Interval:** Aggregate · **Perspective:** Public
- **Story:** `#story/time_window_comparison/155904`
- **Skills:** response-rate-math-verifier (reused), time-window-comparison-run (reused), switch-account (reused)
- **Mode:** Unattended / headless Playwright MCP
- **Verdict:** ✅ **PASS**

## Steps executed
1. Reporting top-nav → **Time Window Comparison** (builder is on `app-reporting.lfmdev.in/#/time_window_comparison`; the `app.lfmdev.in/#explore/...` route only renders the sub-header — see known-quirks TWC render fragility).
2. Precondition **logged in as Wasserman**: session started on Hulu (acct 336); switched via LFQA menu → Search Account → typed "Wasserman" → clicked the **Results** row (Rule 1). Header confirmed `Account: Wasserman`.
3. Added brand via typeahead: typed "FIA World Endurance"; two results surfaced — picked the **exact** `FIA World Endurance Championship (FIAWEC)` (Rule 1; the "…Highlights" sibling was not used).
4. **Absolute Dates** button clicked; **Interval → Aggregate** selected.
5. Date range set to **Feb 09 – Feb 15, 2026** via `th.prev`/`th.next` JS calendar nav (both Start + End calendars; End calendar reset to current month after the Start pick and was re-navigated). Verified `range-start`=9 … `range`=10–14 … `range-end`=15, both calendars on February 2026.
6. **By Channel** view engaged. Per-channel metric selection (channels are `<details class="node">`; opened each via trusted click on its `<summary>`; leaves are `li.leaf` with a `.controlled-check-box`). Selected exactly:
   - **Instagram (4/99):** Total Followers · Posts · Engagements (Public Only) · Organic Response Rate
   - **Twitter (4/70):** Total Followers · Posts · Engagements · Response Rate
   - **Facebook (4/47):** Total Fans · Posts · Engagements · Response Rate
   - **TikTok (4/35):** Total Followers · Posts · Engagements · Response Rate
   - **YouTube (4/29):** Total Subscribers · Posts · Engagements · Response Rate
   - *Spec sub-step "select Related Nodes" — no such control exists in the current TWC builder (legacy/spec-drift wording). Substantive per-channel metric selection performed instead; does not affect the assertions.*
8. **Run Report** → story 155904 rendered with title "Time Window Comparison > FIA World Endurance Championship (FIAWEC)"; all 20 metric tables painted, no error state.
9. **Export → CSV** (Google Sheet is OUT OF SCOPE on the Playwright track — GS steps/assertions skipped per scope rules; verified export parity via the in-scope **synchronous CSV** download instead, read on disk). File: `.playwright-out/FIA-World-Endurance-Championship-FIAWEC---Time-Window-Comparison---Feb-9-2026---Feb-15-2026.csv`.

## Aggregate values (UI report ↔ CSV export)

| Channel | Metric | UI value | CSV value | Match |
|---|---|---|---|---|
| Instagram | Total Followers | 1,291,489 | 1291489 | ✓ |
| Instagram | Posts | 7 | 7 | ✓ |
| Instagram | Engagements (Public Only) | 96,129 | 96129 | ✓ |
| Instagram | Organic Response Rate | 1.06% | 0.01064245539156185 (→1.06%) | ✓ |
| Twitter | Total Followers | 457,601 | 457601 | ✓ |
| Twitter | Posts | 7 | 7 | ✓ |
| Twitter | Engagements | 2,573 | 2573 | ✓ |
| Twitter | Response Rate | 0.08% | 0.0008033833899781591 (→0.08%) | ✓ |
| Facebook | Total Fans | 596,609 | 596609 | ✓ |
| Facebook | Posts | 7 | 7 | ✓ |
| Facebook | Engagements | 7,973 | 7973 | ✓ |
| Facebook | Response Rate | 0.19% | 0.0019095432615851532 (→0.19%) | ✓ |
| TikTok | Total Followers | 534,800 | 534800 | ✓ |
| TikTok | Posts | 7 | 7 | ✓ |
| TikTok | Engagements | 10,113 | 10113 | ✓ |
| TikTok | Response Rate | 0.27% | 0.0027052403498916623 (→0.27%) | ✓ |
| YouTube | Total Subscribers | 1,140,000 | 1140000 | ✓ |
| YouTube | Posts | 11 | 11 | ✓ |
| YouTube | Engagements | 16,750 | 16750 | ✓ |
| YouTube | Response Rate | 0.13% | 0.001335725677830941 (→0.13%) | ✓ |

## Response-Rate math verification (formula: `RR = Engagements / (Total Followers × Posts) × 100`)

| Channel | Engagements / (Followers × Posts) | Calculated | UI | Export | Match |
|---|---|---|---|---|---|
| Instagram | 96,129 / (1,291,489 × 7) | 1.063% | 1.06% | 1.064% | ✓ |
| Twitter | 2,573 / (457,601 × 7) | 0.080% | 0.08% | 0.080% | ✓ |
| Facebook | 7,973 / (596,609 × 7) | 0.191% | 0.19% | 0.191% | ✓ |
| TikTok | 10,113 / (534,800 × 7) | 0.270% | 0.27% | 0.271% | ✓ |
| YouTube | 16,750 / (1,140,000 × 11) | 0.134% | 0.13% | 0.134% | ✓ |

All channels reproduce to display precision (2-dp %). The footprint formula (Aggregate Footprint = Aggregate Posts × Aggregate Total Followers, excluding no-follower days) holds: every aggregate Response Rate is sane and bounded (< 1.1%) — the "abnormally high response rate" is correctly handled by using the footprint denominator rather than naively summing per-day rates. Facebook uses **Total Fans** (not Total Followers), YouTube uses **Total Subscribers** — per-channel denominator terminology matches the verifier skill.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A8 | 8 | Report loads for Aggregate values with no errors | Story 155904 rendered; all 20 metric tables painted (5 channels × 4 metrics); no error state | ✅ PASS |
| A9a | 9 | Aggregate Engagements value and number of posts match Exported data | All 5 channels: Engagements + Posts identical UI ↔ CSV (e.g. IG 96,129/7; YT 16,750/11) | ✅ PASS |
| A9b | 9 | UI-displayed Aggregate Response Rate equals Exported Response Rate | All 5 channels match at display precision (0.19/0.08/1.06/0.13/0.27%); CSV raw fractions round to the same | ✅ PASS |
| A9c | 9 | Calculated Aggregate Response Rate matches both UI + Exported | Footprint formula reproduces all 5 channel RRs to 2-dp % (see math table) | ✅ PASS |

*Google Sheets export (spec step 9 wording) skipped — out of scope on the Playwright MCP track; CSV substituted for the in-app export-parity verification. GS skip does not block the case.*

## Known bugs checked
- **Jira issue-links:** none open (case has 0 Bug/Test-Failure links per prior JQL checks). Rule 7 open-bug screen → passed, ran the case.
- **`knowledge-base/bug-history.md` (grep QA-129608):** 0 open, 0 closed defects tied to this case. Prior magpie runs BLOCKED on Wasserman-account reachability (2026-06-02/06-04); resolved this run via the TWC Search-Account switcher.
- **TWC builder render fragility** (known-quirk 2026-07-10, cited QA-129608 as previously TWC-blocked): did NOT recur once the builder was reached via the top-nav Reporting menu on `app-reporting.lfmdev.in`. Builder mounted (title "Time Window Comparison").
- **Em-dash / no-follower-day exclusion** (response-rate-math-verifier): with Aggregate interval the exclusion is folded into the aggregate; no abnormal/blown-up rate observed on any channel.

## Bugs filed
_None._
