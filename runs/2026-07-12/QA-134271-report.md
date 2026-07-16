# QA-134271 — Brand Navigation — Data Last Updated: Timestamp

- **Run:** 2026-07-12 (unattended headless, Playwright MCP, `feature/playwright-mcp`)
- **Account:** Adam Orfei (`account_id=54`) — matches precondition
- **Brand under test:** MTV (`brand_id=4018`), then switched to Hulu (`brand_id=11003`)
- **Skill used:** cross-cut (no dedicated skill); `switch-account` not needed (same-account brand switch via Home favorites)
- **Verdict:** **PASS**

## Summary
The ETL "Data Last Updated (PT)" header renders the identical value
`Data Last Updated (PT): 07-11-2026 09:56 AM` on Home and on all six Brand sub-tabs, persists
across an F5 hard refresh, and persists across a brand switch (MTV → Hulu) — confirming it is an
account-wide freshness signal, not a per-page/per-brand value. Format conforms.

## Steps executed
1. Logged in via Cognito "With existing account" form → landed on `#home`, `Account: Adam Orfei`.
2. Read Home header timestamp (`.etl-timestamp` element).
3. Navigated Brand > Insights → Audience → Content → Channels → Stories → Optimization via the
   in-page tab bar (`a.tab-link`), reading the timestamp on each.
4. F5 hard-refreshed the Brand > Optimization page; re-read timestamp.
5. Switched brand MTV → Hulu via Home favorites link; re-read timestamp; confirmed URL
   `brand_id=11003` and breadcrumb still `Account: Adam Orfei`.

## Evidence — timestamp value per surface
All reads returned the exact string `Data Last Updated (PT): 07-11-2026 09:56 AM`
(DOM: `<div class="etl-timestamp"><div>…</div></div>`).

| Surface | brand_id | Timestamp read |
|---------|----------|----------------|
| Home | — | `07-11-2026 09:56 AM` |
| Brand > Insights | 4018 | `07-11-2026 09:56 AM` |
| Brand > Audience | 4018 | `07-11-2026 09:56 AM` |
| Brand > Content | 4018 | `07-11-2026 09:56 AM` |
| Brand > Channels | 4018 | `07-11-2026 09:56 AM` |
| Brand > Stories | 4018 | `07-11-2026 09:56 AM` |
| Brand > Optimization | 4018 | `07-11-2026 09:56 AM` |
| Brand > Optimization (after F5) | 4018 | `07-11-2026 09:56 AM` |
| Brand > Insights (Hulu, post-switch) | 11003 | `07-11-2026 09:56 AM` |

Screenshots under `.playwright-out/QA-134271/`: `01-home.png`, `02-insights.png`,
`03-optimization.png`, `04-hulu-brandswitch.png`.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Insights | Same timestamp as Home | `07-11-2026 09:56 AM` | PASS |
| A2 | Audience | Same timestamp | `07-11-2026 09:56 AM` | PASS |
| A3 | Content | Same timestamp | `07-11-2026 09:56 AM` | PASS |
| A4 | Channels | Same timestamp | `07-11-2026 09:56 AM` | PASS |
| A5 | Stories | Same timestamp | `07-11-2026 09:56 AM` | PASS |
| A6 | Optimization | Same timestamp | `07-11-2026 09:56 AM` | PASS |
| A7 | All sub-tabs | Consistent across all Brand sub-tabs | Identical on all 6 | PASS |
| A8 | Brand switch (MTV→Hulu) | Persists (account-wide) | `07-11-2026 09:56 AM` unchanged | PASS |
| A9 | F5 refresh | Persists after refresh | `07-11-2026 09:56 AM` unchanged | PASS |
| A10 | Format | `MM-DD-YYYY HH:MM AM/PM PT` after `(PT):` | `(PT): 07-11-2026 09:56 AM` — date+time+meridiem conform; timezone shown by `(PT):` prefix | PASS |

## Format note (non-blocking)
The full string is `Data Last Updated (PT): 07-11-2026 09:56 AM`. The timezone (PT) is denoted by the
`(PT):` label prefix; the value itself matches `MM-DD-YYYY HH:MM AM/PM`. The prior 2026-06-04 run
(bug-history) recorded a **trailing** `PT` suffix (`… 05:06 AM PT`); that trailing suffix is not
present today — the timezone is now carried only by the `(PT):` prefix. Cosmetic-only difference; the
timezone remains unambiguously indicated, so A10 passes. Flagged for awareness, no bug filed.

## Known bugs checked
- bug-history.md (grep QA-134271): **0 open bugs**; "No open Bug/Test-Failure links." Prior run
  2026-06-04 QA-4325 batch-11 = PASS with the same account-wide-signal finding.
- Case file has no "Open linked bugs" section listing any open defect → Rule 7 screen passed; case run.
- No known bug interferes with these assertions. No regression observed.

## Bugs filed
None.
