# Skill Health

Surfaces skills that are flaky, drifting, or otherwise need human attention.

_Last updated: 2026-06-11 (after batch-3, 22 cases / 10 accounts)._

## Skills needing review

| Skill | Issue | Detected | Recommendation |
|-------|-------|----------|----------------|
| export-google-sheets | TWC Google Sheets export hangs systemically on dev (2 accounts, 2 reports); Export control locks until reload | 2026-06-10, re-confirmed 2026-06-11 | File/escalate the product bug; skill now treats CSV blob-hook as the canonical TWC export-verification path until fixed |
| dashboard-mutation-flows | "Remove from Dashboard" fires no API call (open product bug) — any assertion depending on persisted removal will fail | 2026-06-11 (QA-85175) | Keep expected-FAIL annotation in skill until bug fixed; rest of flow stable |
| brand-paid-ads-table (new) | Underlying Paid surface fragile: Invalid-date-compare trap + 2026-06-04 Michael Kors full-page degradation precedent | 2026-06-11 | Always navigate with full date+compare params; single-select channel model documented |

## Stale `last_verified`

Skills not exercised in 14+ days. Either the cases that use them aren't running, or the area is no longer covered.

| Skill | Last verified | Last cases that used it |
|-------|---------------|-------------------------|
| data-collection-ad-account-status | 2026-05-13 | QA-127567 (re-verified 2026-06-10 in batch-1 — bump pending registry sync) |
| historical-twc-story-load | 2026-05-13 | QA-329 (re-verified 2026-06-10 batch-1) |
| data-collection-brand-popup | 2026-05-20 | QA-2498 |
| keydate-picker | 2026-06-02 | QA-1053 batch-7 |

## Frequently-quarantined skills

| Skill | Quarantine events (30d) | Last reason |
|-------|------------------------:|-------------|
| _none_ | 0 | — |

## Batch-3 health notes (2026-06-11)

- 16 skills exercised, 0 skill-drift failures — all assertion failures traced to product bugs, not skill rot.
- New skills added: `brand-paid-ads-table`, `brand-sets-content-posts`.
- Version bumps: time-window-comparison-run v5, export-google-sheets v4, dashboard-mutation-flows v2, response-rate-math-verifier v2, brand-content-filter v2.
- switch-account: Wasserman now confirmed reachable via the normal switcher (9/9 clean switches this batch) — the 2026-06-04 re-auth blocker note is superseded.
- Automation environment: Chrome MCP coordinate-space flip-flop (1.0 ⇄ 1.225) and the hidden duplicate datepicker were the two biggest time sinks this batch; both documented in known-quirks with guards.
