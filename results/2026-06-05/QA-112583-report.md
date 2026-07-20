---
ticket: QA-112583
title: Reporting > Follower Demographics Vs Threads Audience - Export - Data QA
date: 2026-06-08
batch: QA-22296 batch 7
operator: magpie
result: BLOCKED (no Threads Audience data on Adam Orfei brands)
skill: audience-metrics-export (n/a — no data)
---

## Steps
1. Login as Yash on `app.lfmdev.in` — Adam Orfei account.
2. Probe Brand>Audience Threads channel for MTV (brand_id=4018) — default window + extended window 2026-01-01 → 2026-06-06. NO DATA across all 5 Threads-Audience tiles (Country, City, Geo Country, Geo City, Gender Breakdown). See QA-109749 sibling.
3. Attempt to navigate to Michael Kors (brand_id=12597) for cross-brand probe — Brand>Audience Threads page hung the Chrome MCP renderer per the Threads multi-channel known-quirk; recovered via tabs_close + new tab.
4. Reporting > Follower Demographics path (Reporting → Follower Demographics Report) — DEFERRED. Without an Adam-Orfei brand that has Threads Audience data, the cross-source compare cannot be performed.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | Brand>Audience Threads Gender Breakdown renders | Donut/bar with M/F/Other % | "There is no data available." for MTV across 2 date windows | BLOCKED-NO-DATA |
| A2 | Reporting Follower Demographics export Threads gender numbers | CSV/XLSX export with same gender shares as Brand>Audience tile | Not attempted — source-2 (Brand>Audience) cannot supply baseline | BLOCKED |
| A3 | Cross-source delta % within rounding tolerance | Source-1 ≈ Source-2 to ≤1 percentage point | NOT VERIFIED | BLOCKED |

## Evidence
- See QA-109749 sibling for Brand>Audience Threads no-data evidence on MTV.
- Brand>Audience Threads Michael Kors renderer-hang (Chrome MCP CDP timeout 45+ s) — known-quirks "Brand Insights with Last 6/12 Months range freezes Chrome MCP renderer" entry was extended on 2026-06-08 to cover Threads multi-channel mixes. Threads-channel-on-Brand>Audience exhibits same hang behavior in this session.

## Bugs filed
None new. Carry-forward blocker: Threads Audience cross-source parity test requires a brand on Adam Orfei with populated Threads Audience tiles. Recommend retrying when LFIQA confirms a known-Threads-Audience brand or when the data lag resolves.

## Skill maintenance
- `audience-metrics-export`: no streak bump — no successful export performed.
