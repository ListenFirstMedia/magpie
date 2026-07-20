# QA-22296 Re-run — Batch 6/12 — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Members:** QA-96045, QA-96759, QA-98351, QA-99531, QA-104876 (order 26–30)

| QA | Title | Result | Note |
|----|-------|--------|------|
| QA-96045 | Settings > Data Identities - IG Threads | 🚫 BLOCKED | Threads channel absent (6 channels only) — test-data gap, Rule 1 |
| QA-96759 | Brand > Insights - Threads - Tile PNG | 🚫 BLOCKED | Brand>Insights renderer hang (reproduced repeatedly this session) |
| QA-98351 | Brand > Content - Threads - Basic View | ✅ PASS | MTV Threads (Mar 16–22 2025) Posts(2), columns + Sum/Avg |
| QA-99531 | Brand > Content - Threads - Hovering | ✅ PASS | **Upgrades prior BLOCKED** — Threads embed tooltip renders (mtv✓ + date + text), X closes |
| QA-104876 | Custom Data Sets - Delete | ✅ PASS | Create→Delete→F5-persistent; confirmation modal verbatim; self-cleaning |

## Headline
- 3 PASS (incl. QA-99531 upgrade), 2 BLOCKED (Threads test-data gap; Insights renderer hang). No new product bugs.
- Used Mar 2025 window for MTV Threads cases (window WITH Threads posts) — Rule 1 brand kept, date adjusted to data.

## Cleanup
- CDS `QA-104876-del-0613` created + deleted (self-cleaning). No residual test data.
