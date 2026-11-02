# QA-11008 — TikTok Content - Same Brand Benchmark - Data QA

**Run date:** 2026-10-28 (Wednesday) — case is fixed to Disney Ad Sales / Disney Channel
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in`
**Account:** Disney Ad Sales (account_id=634) · **Brand:** Disney Channel (brand_id=3877) · Channel: TikTok only · Date range: Oct. 20, 2026 – Oct. 26, 2026 (the most recent complete 7 days; the picker's preset dropdown did not apply a separate "Last 7 Days" range) · Benchmark: Set To Current Brand, Benchmark Period **Rolling 7 Days**, Mode 7 Day
**Verdict: FAIL — open linked bug LFMP-32557 (Open) ⇒ FAILED per policy. Execution outcome: Owned Average vs Benchmark Average — Engagements 19,862 vs 19,862 · Reactions 19,191 vs 19,190 · Comments 107 vs 106 · Shares 565 vs 564 (each off by at most 1, allowed by the spec) — i.e. the assertion itself holds today**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Content → Disney Channel → TikTok only | ✅ Posts (14) |
| 4 | Date range last 7 days | ⚠️ default week Oct 20–26 kept (see header) |
| 5 | **Benchmark** button (`button.benchmark-button`) | ✅ modal "Compare post performance on any metric" |
| 6 | Select a Brand → **Set To Current Brand** (`.set-current-brand.action-label`, real mouse click) | ✅ "Disney Channel" |
| 7 | Benchmark Period → **Rolling 7 Days** (options: Q3 2026, Rolling 7 Days, Rolling 28 Days, YTD, MTD, QTD, 2025, 2024, quarters) | ✅ |
| 8 | Go → Table View → aggregate toggle Sum → Average | ✅ URL gains `benchmark_filters={"filter_benchmark_period":{"type":"rolling_7_days"},"filter_stat_mode":"7-day","filter_brand":{"id":3877},"filter_content_channels":["tiktok"]}` |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A8 | Aggregate-row Owned Average ≈ Benchmark Average for Engagements, Reactions, Comments, Shares (±1–2 allowed) | Owned Average 19,862 / 19,191 / 107 / 565 vs Benchmark Average 19,862 / 19,190 / 106 / 564 (Response Rate 0.20% = 0.20%; Video Views 128,391 = 128,391; Video Response Rate 16.64% vs 14.51%, not in scope) | ✅ holds (Δ1 on Reactions, Comments and Shares) — but case FAILED by the open-bug rule |

## Evidence
- Session result `ctx._bench` (modal text, period options, Sum/Average rows, "BENCHMARK AVERAGE 19,862 19,190 106 564 0.20% 128,391 14.51%").

## Known bugs checked
- **LFMP-32557 (Open)** "Brand > Content - Same Brand Benchmark Owned Average and Benchmark average is not matching" — open ⇒ FAILED (2026-10-22 directive). Today's values match within the spec tolerance (10-20 Shares 724 vs 723; 10-26 Comments 106 vs 105; 10-27 Engagements 21,550 vs 21,549), so the bug may be ready for re-verification by its owner.

## Bugs filed
None (existing bug).

## Cleanup
Benchmark selections left unsaved (session only).
