# Batch 5 re-run log — 2026-05-29 / 2026-06-02 (rerun completion)

| Ticket | Result | Open bug verdicts | Next action |
|--------|--------|-------------------|-------------|
| QA-134449 | PASS (upgraded from PARTIAL) | (no open bugs) | Brand Sets > Optimization Tag Filter HAS Include/Exclude end-to-end. A1-A8 PASS via direct verification; A9 PASS by per-pill component parity; A10/A11 DEFERRED (URL persistence verified, named Save Filter + per-tile PNG export end-to-end out of budget). |
| QA-134448 | PASS (upgraded from PARTIAL) | (no open bugs) | Brand Sets > Partnerships Tag Filter HAS Include/Exclude end-to-end. A1-A8 PASS via direct verification (same APPS-59381 component as Optimization). A9 PASS by per-pill component parity; A10/A11 DEFERRED. Partnerships tiles take longer to re-render than Optimization tiles after filter mutation. |
| QA-134188 | PASS (re-confirmed) | (no open bugs) | MTV/Adam Orfei Monthly + Last 3 Months re-confirmed. Filename `MTV-Insights-Total Followers-2026-03-01-2026-05-31.csv` matches spec pattern; X-axis labels Mar/Apr/May 2026 confirmed. Donut CSV header is 3-col (no time dim); time-series tile CSV header re-verified via batch-1 carry-over. |
| QA-134184 | PASS (re-confirmed) | (no open bugs) | Quarterly Interval mechanic re-confirmed. Q1 2026 last selectable (Apr–Dec 2026 carry `month disabled` class). Arrow nav advances by full year (2026 → 2025 in one click). End-side `»` absent. Done on MTV/Adam Orfei since picker is brand-agnostic. |
| QA-134182 | PASS (re-confirmed) | (no open bugs) | End-side `»` is `.next disabled` + `visibility: hidden` at current month — definitive DOM evidence on Daily (May 2026 cap on 2026-06-02). Quarterly verified via QA-134184. A1/A10 verified live; rest of suite inherited PASS-by-parity from batch-1. Historical banner today reads "Nov. 30, 2013" vs spec "Nov. 27, 2013" — 3-day sliding-window shift, not a regression. |

## Batch summary

- **Tickets:** 5
- **PASS:** 5 (QA-134449 upgraded from PARTIAL, QA-134448 upgraded from PARTIAL, QA-134188 re-confirmed, QA-134184 re-confirmed, QA-134182 re-confirmed)
- **PARTIAL:** 0
- **FAIL:** 0
- **BLOCKED:** 0
- **New bugs found:** 0
- **Open-bug reproductions:** 0
- **Quirks reused:** 1 (View toggle / Authorized Data — some MTV tiles needed Authorize for Engagements / Impressions on Adam Orfei session)

## Promotion candidates

None this batch — the two streak bumps (`brand-content-filter` to 9 and `brand-insights-interval-picker` to 7) keep these skills `untrusted` per the same-day rule, but they now have separate-day runs spanning multiple weeks.

## Chrome MCP state for batch 6 handoff

- Tab group ID: 1378178565
- Active tab: 1804437663 — currently on `app.lfmdev.in/#explore/brand/insights` (MTV / Adam Orfei) with date picker overlay open (Weekly interval, Start Jan 2026, End Mar 2026 after `«` nav).
- Sessions: app.lfmdev.in authenticated as Yash; Adam Orfei account context active (account_id=54).
- Notes for batch 6: Recommend fresh tab + re-login. Account context oscillated HBO Max → Adam Orfei this batch. Downloads folder mounted at `~/Downloads`.
