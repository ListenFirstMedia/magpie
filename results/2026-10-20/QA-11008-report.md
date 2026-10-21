# QA-11008 — TikTok Content - Same Brand Benchmark - Data QA

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in`, lfiqa user switched to **Disney Ad Sales**
**Account:** Disney Ad Sales (account_id=634) · **Brand:** Disney Channel (brand_id=3877) · Channel: TikTok only · Page date range: Oct. 13, 2026 – Oct. 18, 2026 (last 7 days; Oct 19 is disabled in the picker because data runs through Oct 18) · Benchmark: Set To Current Brand (Disney Channel), Benchmark Period Rolling 7 Days (Oct 13–19 2026), Mode 7 Day
**Verdict: PASS — Owned Average vs Benchmark Average: Engagements 11,525 vs 11,525 · Reactions 10,749 vs 10,749 · Comments 52 vs 52 · Shares 724 vs 723 (off by 1, allowed by the spec)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Content → Disney Channel → TikTok only | ✅ Posts (17) in the default week |
| 4 | Date range → last 7 days | ✅ Oct 13 → Oct 18 (the END picker greys out Oct 19), Posts (13) |
| 5 | Benchmark button (`span.lfm-button-label` "Benchmark") | ✅ `.benchmark-modal`: Select Brand Set, Select a Brand / Set To Current Brand, Branded Content, Tag, Benchmark Period (Q3 2026 default), Post Type, Publish Type, Mode (7 Day), CSV Export / Load / Clear All / Cancel / Go |
| 6 | Set To Current Brand (`div.set-current-brand`) | ✅ "Disney Channel" |
| 7 | Benchmark Period → Rolling 7 Days (options: Rolling 7 Days, Rolling 28 Days, YTD, MTD, QTD, 2025, 2024, Q3 2026 … Q2 2024) | ✅ |
| 8 | Go | ✅ URL gains `benchmark_filters={filter_benchmark_period:{start_date:2026-10-13,end_date:2026-10-19,type:rolling_7_days},filter_stat_mode:7-day,filter_brand:{id:3877},filter_content_channels:[tiktok]}`; a "Benchmark Selections" bar and a **BENCHMARK AVERAGE** row appear above the table (11,525 · 10,749 · 52 · 723 · 0.12% · 47,396 · 12.79%); Table View aggregate toggled Sum → **Average**: 11,525 (+<0.01%) · 10,749 (+<0.01%) · 52 · 724 (+0.12%) · 0.12% · 47,396 · 12.95% |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A8 | Owned Average ≈ Benchmark Average for Engagements, Reactions, Comments, Shares (±1–2 allowed) | 11,525/11,525 · 10,749/10,749 · 52/52 · 724/723 | ✅ PASS |

## Evidence
- Session results `ctx._bench`, `ctx._bench2`.

## Known bugs checked
- LFMP-32557 (Open) "Same Brand Benchmark Owned Average and Benchmark average not matching": did not reproduce today (max difference 1 on Shares, within the spec tolerance).

## Notes (mechanics)
- The Benchmark modal and its dropdown options need real mouse clicks at bounding boxes (locator text clicks timed out on the label spans). The Sum/Average toggle is `.aggregate-row-toggle-container label.toggle-switch-label`; the Average row carries a "(+x%)" delta vs the benchmark.

## Bugs filed
None.

## Cleanup
None (read-only; benchmark selection left on the dev tab).
