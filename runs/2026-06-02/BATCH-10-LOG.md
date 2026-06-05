# QA-4325 Batch 10 — Execution Log

- **Date:** 2026-06-04
- **Account:** Adam Orfei (account_id=54) — stable across batch
- **Tickets:** QA-130076, QA-133403, QA-134176, QA-134182, QA-134184

## Per-ticket result

| Ticket | Title | Skill | Type | Result |
|--------|-------|-------|------|--------|
| QA-130076 | Settings > Notifications - Improve Lost Authorization Messaging | (none / candidate `settings-notifications`) | RECONFIRM | PASS 4/4 — re-confirmed consistency with V2 sweep. Notifications count 8,613 → 8,414 (–199; expected turnover). Format/quoting/NOT-COLLECTING status all match spec verbatim. |
| QA-133403 | Brand Set > Content - Authorised Video Views Sum/Avg | (none / candidate `brand-sets-content-rank-by`) | FIRST RUN | PASS 3/15 on substitute setup (Adam's Brand Set IG May 30 – Jun 1 2026); A1, A2, A3, A4, A5, A6 verified; A7-A15 NOT VERIFIED (spec calls Viacom + 2019 BET Awards Sponsors brand set + Mar 23-24 2026, not reachable on Adam Orfei session). Math: Sum 806,052 + 159,572 = 965,624 ✓; Avg 965,624 / 2 = 482,812 ✓. Channel coverage FB/Twitter/IG/YouTube/TikTok confirmed via `.channel-ghost.<name>` DOM check. |
| QA-134176 | Brand > Insights - Auto Select Dates for all Intervals | `brand-insights-interval-picker` | FIRST RUN | PASS 7/7 — Daily/Weekly/Monthly/Quarterly auto-select dropdown contents all match spec structure. Monthly drops Last 7 Days/Prior Year/MTD/YTD (regression-guard PASS). Quarterly drops months + relative entries (regression-guard PASS). Spec brand Sephora not reachable from Adam Orfei (redirect to /#home) — MTV substituted; mechanic-level test unaffected by substitution. |
| QA-134182 | Brand > Insights - Interval Date selector historical limits | `brand-insights-interval-picker` (v2) | RECONFIRM | PASS — Daily End-side `.next disabled` + `visibility: hidden` at June 2026 cap re-confirmed; historical floor "Dec 02, 2013" (sliding-window shift from V2 Nov 30, 2013); no mechanic regression. |
| QA-134184 | Brand > Insights - Interval selection - Quarterly | `brand-insights-interval-picker` (v2) | RECONFIRM | PASS — Quarterly Interval present below Monthly; Q1 2026 = range-start/range/range-end; Apr-Dec 2026 = month disabled; `.prev` click moves Jan 2026 → Jan 2025 (year-granularity confirmed). Quarterly Auto-Select list = 49 quarters only (no months, no relative entries). |

## Chrome MCP state at end of batch

- Tab group `872061071` open. One tab: `1804438067` — Brand Sets Content (Adam's Brand Set IG May 30 - Jun 1 2026, Authorized Video Views).
- Renderer recovered from initial Adam's-Brand-Set / Mar 23-24 2026 hang via tab close + fresh tab + URL-narrow workaround per known-quirks.
- Account context stable: Adam Orfei across all 5 tickets.

## Drift vs prior runs

- QA-130076: -199 notifications (8,613 → 8,414) — turnover; no drift.
- QA-134182: data-cap month advanced May 2026 → June 2026 (data freshness one-month forward) — consistent with V2. No mechanic drift.
- QA-134184: Q1 2026 remains last selectable quarter (Q2 2026 still in progress on 2026-06-04). Year-granularity arrow nav re-confirmed. No drift.
- QA-134176: dropdown structure stable; current quarter Q2 2026 correctly excluded from auto-select; current month June 2026 correctly excluded.

## New bugs filed
None.

## KB updates
- REGISTRY.md: bumped `switch-account` 18 → 19; `brand-insights-interval-picker` 7 → 10.

## Known-quirks usage
- "Adam Orfei Brand Set returns ~76K posts; Chrome MCP renderer hang per Rank-by switches" — re-confirmed; pre-narrow via shorter window AND single-channel was sufficient.
- "Brand > Content backend ... Filter URL: prior MTV filter persisted across URL nav and only Clear-All button cleared it" — new observation: even URL re-nav with empty `filters={}` was insufficient; explicit Clear-All required. Worth documenting as future quirk.
- "Brand Sets > Content View toggle disabled at brand-set level; perspective derived from Rank-by metric group" — re-confirmed; Authorized Video Views set perspective=extended via metric subsection.
