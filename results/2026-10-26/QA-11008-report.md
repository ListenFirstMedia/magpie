# QA-11008 — TikTok Content - Same Brand Benchmark - Data QA

**Run date:** 2026-10-26 (Monday) — case is fixed to Disney Ad Sales / Disney Channel
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in`
**Account:** Disney Ad Sales (account_id=634) · **Brand:** Disney Channel (brand_id=3877) · Channel: TikTok only · Date range: Oct. 18, 2026 – Oct. 24, 2026 (the most recent complete 7 days; the picker's preset dropdown did not apply a separate "Last 7 Days" range) · Benchmark: Set To Current Brand, Benchmark Period **Rolling 7 Days**, Mode 7 Day
**Verdict: FAIL — open linked bug LFMP-32557 (Open) ⇒ FAILED per policy. Execution outcome: Owned Average vs Benchmark Average — Engagements 20,289 vs 20,289 · Reactions 19,609 vs 19,609 · Comments 106 vs 105 (off by 1, allowed by the spec) · Shares 574 vs 574 — i.e. the assertion itself holds today**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Content → Disney Channel → TikTok only | ✅ Posts (11) |
| 4 | Date range last 7 days | ⚠️ default week Oct 18–24 kept (see header) |
| 5 | **Benchmark** button (`button.benchmark-button`) | ✅ modal "Compare post performance on any metric" |
| 6 | Select a Brand → **Set To Current Brand** (`.set-current-brand.action-label`, real mouse click) | ✅ "Disney Channel" |
| 7 | Benchmark Period → **Rolling 7 Days** (options: Q3 2026, Rolling 7 Days, Rolling 28 Days, YTD, MTD, QTD, 2025, 2024, quarters) | ✅ |
| 8 | Go → Table View → aggregate toggle Sum → Average | ✅ URL gains `benchmark_filters={"filter_benchmark_period":{"type":"rolling_7_days"},"filter_stat_mode":"7-day","filter_brand":{"id":3877},"filter_content_channels":["tiktok"]}` |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A8 | Aggregate-row Owned Average ≈ Benchmark Average for Engagements, Reactions, Comments, Shares (±1–2 allowed) | Owned Average 20,289 / 19,609 / 106 / 574 vs Benchmark Average 20,289 / 19,609 / 105 / 574 (Response Rate 0.20% = 0.20%; Video Views 130,692 = 130,692; Video Response Rate 17.04% vs 13.35%, not in scope) | ✅ holds (Δ1 on Comments) — but case FAILED by the open-bug rule |

## Evidence
- Session result `ctx._bench` (modal text, period options, Sum/Average rows, "Benchmark Selections … BENCHMARK AVERAGE 20,289 19,609 105 574 0.20% 130,692 13.35%").

## Known bugs checked
- **LFMP-32557 (Open)** "Brand > Content - Same Brand Benchmark Owned Average and Benchmark average is not matching" — open ⇒ FAILED (2026-10-22 directive). Today's values match within the spec tolerance (same as 2026-10-20: Shares 724 vs 723), so the bug may be ready for re-verification by its owner.

## Bugs filed
None (existing bug).

## Cleanup
Benchmark selections left unsaved (session only).
