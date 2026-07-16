# QA-107134 — Settings > Audit - Deep Linking

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account:** Adam Orfei (account_id=54) · Settings > Audit

## Verdict: PASS (A3 probe consistent with known open bug; core deep-linking works)

## Known bugs checked — tolerated (probe)
- **APPS-54603** (Open) — "Global Deep Linking issue when replacing the URL on the current page; pasted URL not updated with selected parameters except date range." Concerns **non-date filter params** (channels, publish-time, sort) on **in-page** URL replacement. Does not interfere with the Audit page's core deep-link state (account + date range) → run + note. Probed as A3.

## Flow
Settings → Audit (breadcrumb "Adam Orfei | Settings > Audit"; audit-log table: Date / Customer / Business Unit / Account / Actor / Activity Type / Description). Deep-linked a distinct date range in a fresh load, then tested in-page URL replacement.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Deep-link URL (fresh load) loads Audit with same date range/filters | navigated fresh to `#audit?account_id=54&from=2026-06-01&to=2026-06-07…` → page loaded showing **Jun. 01, 2026 - Jun. 07, 2026**, 252 audit rows | PASS |
| A2 | All deep-link params (account, date range) preserved | account_id=54 (Adam Orfei) + date range both applied from URL | PASS |
| A3 (probe) | APPS-54603 — same-tab URL replacement may not apply non-date params | in-page hash replace to `from=2026-05-01&to=2026-05-07` updated the display to **May. 01, 2026 - May. 07, 2026** — the **date range applies** (the documented exception in APPS-54603). The Audit page's URL state is account + date range (both apply); the bug's affected params (non-date filters) are not part of Audit's core deep-link state | PASS (probe consistent w/ open bug) |

## Notes
- Audit page deep-links via `#audit?account_id=<id>&from=<YYYY-MM-DD>&to=<YYYY-MM-DD>&compare_from=…&compare_to=…`. Both fresh-tab load (A1/A2) and in-page hash replacement correctly apply the account + date range.
- APPS-54603's failure mode (filter/sort/channel params dropped on in-page paste) is documented as reproducible on filter-heavy pages (e.g. Brand Content) and is out of the Audit page's core parameter set.

## Evidence
- `QA-107134-audit.png` (Audit log table + filters)

## Bugs filed
None new — A3 covered by existing **APPS-54603**.
