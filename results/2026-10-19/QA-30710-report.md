# QA-30710 — Brand Insights - Cross-Channel Response Rate Tile (Public Data) - Data QA

**Run date:** 2026-10-19 (retry; the first attempt on Hulu hung in Public view) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (spec: 'HBO Max' | Hulu) · Window Oct. 12 – Oct. 18, 2026
**Verdict: FAIL (minor, needs exact values) — Insights Public-data Response Rate tile 0.46% vs TWC Cross-Channel Response Rate (Public) 0.45%: a 0.01 pp difference at the 2-decimal display, which may be a rounding boundary or a definitional difference; both surfaces only expose 2 decimals so it cannot be adjudicated from the UI**

## Steps
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand > Insights, brand **HBO Max** (typeahead: chevron → `textarea.lfm-textarea` React setter → `.real-list-body .lfm-ta-option` clicked at its bounding box; the account opened on "South Park" by default), **Public Data** view (`input#perspective` click; brand entity became 155611, channels reset) | ✅ `perspective=standard` |
| 3 | Channels Facebook, Twitter, Instagram, TikTok → Apply | ✅ |
| 4 | Response Rate tile | **0.46%** (tooltip: Value 0.46% · Comparison 0.32% · Change +0.15%) |
| 5–8 | Reporting → TWC → brand HBO Max (**Public Data**, toggle unchecked) → Absolute Oct 12–18 2026 → Interval **Aggregate** | ✅ |
| 9–11 | By Channel → Cross-Channel › Content › **Response Rate**; Show Metrics Graphs unchecked | ✅ |
| 12 | Run Report → story 161367 | **Response Rate 0.45%** |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A12 | Insights cross-channel Response Rate (Public) = TWC Cross-Channel Response Rate (Public) | 0.46% vs 0.45% (Δ 0.01 pp, ~2% relative) | ❌ minor — exact (unrounded) values needed; if both round from ~0.455% this is a PASS |

## Evidence
`.playwright-out/QA-30710/04-hbomax-insights.png`, `05-hbomax-public-rr.png`, `06-twc-builder.png`, `07-twc-report.png`

## Known bugs checked
APPS-62413 / LFMP-32592 (closed) on this case — a prior Response Rate parity defect; re-check whether the 0.01 pp drift is the same root cause. APPS-58172 (Open QA Task) unrelated. Environment note: on Hulu the Public view hung indefinitely earlier today; on HBO Max it rendered.

## Bugs filed
None auto-filed. · **Cleanup:** none (TWC story 161367 persists).
