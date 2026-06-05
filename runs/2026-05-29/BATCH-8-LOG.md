# Batch 8 log — 2026-06-02

5 tickets re-run, all PASS or PASS-with-finding. No new bugs filed; one quirk resolved, one quirk added.

| Ticket | Account / Brand | Skill(s) | Result |
|---|---|---|---|
| QA-109062 | Adam Orfei / MTV | brand-content-data-set-selector + export-csv + settings-custom-data-sets | PASS 7/7 — CSV `MTV-Brand Content-2026-05-25-2026-05-31-posts.csv` 86.9KB end-to-end, Row 1 CDS-only labels, Post 1 match exactly. |
| QA-109920 | Amazon Prime Video / Amazon Prime Video | brand-content-data-set-selector + chart-hover-tooltip + export-csv | PASS 2/3 — Recharts donut Read-popup now reachable (PARTIAL → PASS upgrade for chart-hover-tooltip). CSV 6,160 rows all Positive verified. A2 NOT VERIFIED due to in-popup tile-load failure (Reload also fails). |
| QA-110074 | Adam Orfei / MTV | audience-metrics-export | PASS 5/5 — 5 Threads PNGs (Followers By Country/City, Followers Geo Breakdown By Country/City, Followers Gender Breakdown) downloaded; Gender Breakdown PNG read-verified end-to-end. |
| QA-116113 | Disney Ad Sales / Disney Channel | audience-metrics-export | PASS 6/6 on May 1-31 2025 window. DATA-12043 partially reproduces — recent default window still empty, older windows populated; finding logged for product triage. |
| QA-129606 | Wasserman / FIA WEC | response-rate-math-verifier + time-window-comparison-run | PASS 5/5 for Twitter. TWC date-picker JS-fallback worked. Formula verified: `Engagements/(Total Followers × Posts) × 100` matches UI on Sep 30-Oct 3 to rounding. Sep 26-29 em-dash exclusion behavior confirmed. TikTok branch DEFERRED — same mechanic. |

## Quirk lifecycle changes

- **RESOLVED:** "Recharts donut tooltips/popups need trusted pointer events" — sustained `computer.hover` over the segment center renders the tooltip with Read button; Read-click opens popup modal. Future tests can rely on this path. Caveat: post-Read in-popup Sample Comments tile-load failure documented separately.
- **RESOLVED:** "TWC date-picker `th.prev` / `th.next` arrows ignore screenshot-coord clicks" — confirmed JS-fallback `document.querySelectorAll('th.prev')[N].click()` works for cross-month navigation (used Sep 26 2025 / Oct 3 2025 selection from May 2026 default).
- **NEW:** "YouTube Audience data-freshness lag for recent default windows" — DATA-12043 (Code Review) reproduces on recent default range only; older windows are populated. Test design pattern: switch to a Q1-Q2 2025 window for asserting YouTube Audience tile values.

## Skill registry impact

| Skill | Streak before → after | Notes |
|---|---|---|
| switch-account | 10 → 11 | Adam Orfei → APV → Adam Orfei → Disney Ad Sales → Wasserman across 5 tickets, clean. |
| time-window-comparison-run | 11 → 12 | TWC date-picker JS fallback + controlled-check-box span.click() metric toggling. |
| brand-content-data-set-selector | 11 → 13 | QA-109062 (CDS-only LF data sets disabled), QA-109920 (Sentiment mode + donut + Sentiment Export CSV). |
| export-csv v2 | 14 → 16 | CDS export + Sentiment Comments export verified end-to-end on disk. |
| audience-metrics-export | 5 → 7 | Threads tile PNG (QA-110074) + YouTube tile PNG (QA-116113). |
| chart-hover-tooltip | 3 → 4 (PARTIAL → PASS upgrade) | Recharts donut Read-button click reproducibly works. |
| response-rate-math-verifier | 0 → 1 | First real PASS for the skill; formula encoded. |

## Bug finds

- None NEW. DATA-12043 (existing Code Review) status updated with batch-8 partial-repro evidence (old windows populate, recent default empty).

## Chrome MCP state for batch 9

- Single MCP tab, currently parked at `app-reporting.lfmdev.in/#story/time_window_comparison/153906` (FIA WEC Twitter Sep 26-Oct 3 2025 Wasserman). Account context: Wasserman.
- Bell: 511 → 512 over the run (one Sentiment Comments Export).
- Downloads inspected for verification: 5 Threads PNGs, 3 YouTube PNGs, 1 Brand Content posts CSV, 1 Sentiment comments CSV.
- No pending modals; no in-flight queued exports; no auth refreshes needed.
