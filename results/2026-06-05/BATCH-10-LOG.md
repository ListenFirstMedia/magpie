# QA-22296 Batch 10/12 — Execution log

- **Date:** 2026-06-08
- **Tickets:** QA-134271 RECONFIRM, QA-134274, QA-134275, QA-134276, QA-134296 RECONFIRM
- **Browser:** Work Browser (deviceId 718fbc01-4421-4c06-bce3-daedb57fd1b5)
- **Account:** Adam Orfei (account_id=54)

## Pre-test
- PROMPT.md + spec-adherence-rules.md + REGISTRY.md re-read.
- Closed stale tab 1804438537 (Brand Sets Content); created fresh tab 1804438539 → 1804438540.
- Login confirmed via `#home` header `Data Last Updated (PT): 06-08-2026 04:29 AM PT`.
- Bug-history grepped for each QA-ID — all 5 show "No open or closed Bug/Test-Failure links — clean test."
- Specs for QA-134274/275/276 freshly authored at `testcases/english/` (Atlassian QA-API-fetched summaries).

## Per-ticket results

| QA-ID | Surface | Result | Skill used | Notes |
|-------|---------|--------|-----------|-------|
| QA-134271 RECONFIRM | Brand Navigation `Data Last Updated` timestamp across 7 Brand sub-tabs + cross-brand + F5 | PASS | none dedicated | Today's account-wide ETL: `06-08-2026 04:29 AM PT`. Identical across `#home`/`#brand/insights`/`#brand/audience`/`#brand/content`/`#brand/channels`/`#brand/stories`/`#brand/optimization`/Tory Burch brand_id=21648/F5-Home. 10/10 checks PASS. |
| QA-134274 | Brand>Content Tag filter pill add/remove + Clear All + URL persistence | PASS | `brand-content-filter` | Pill add → URL filters JSON encodes; Clear All clears URL+pillCount=0; URL nav with filters re-hydrates pill (10-25s latency observed). Save/Load Filter UI present. |
| QA-134275 | Brand>Content Include-only OR/AND | PASS (mechanic) | `brand-content-filter` | URL `operator:"or"` vs `"and"` encoded correctly per pill operator-button flip; pill is green-outline (no `exclude` class). Posts(0) on test tags = QA-134277 zero-match extension; no backend table-fail this time. |
| QA-134276 | Brand>Content Exclude-only OR/AND | PASS | `brand-content-filter` | URL `not:"true"` encoding; pill `or-label exclude` CSS class; computed bg `rgb(235, 64, 64)` red; Posts(1,221) = baseline (sanity: excluding empty set leaves baseline). |
| QA-134296 RECONFIRM | Brand Sets > Rankings / Content `Data Last Updated` timestamp + F5 + diff brand set | PASS | none dedicated | Identical value across Adam's Brand Set 1738 → Content → F5 → 1923 Talent 11190. Cross-app parity with Brand surfaces same session. |

## Bugs filed
None — 0 new bugs across batch 10.

## Skill credits
- `brand-content-filter` +3 from QA-134274/275/276 (separate-day run; same Filter→Tag mechanic + Save/Load + Clear All + URL encoding + Include/Exclude color extension)

## Chrome state for batch 11
- Browser: Work Browser still selected
- Tab: 1804438540 (Brand Content) — leave open; batch 11 may close + create fresh
- Adam Orfei session active; no stale modals; pill on Brand>Content has filters JSON in URL — close or Clear All before next ticket if needed
