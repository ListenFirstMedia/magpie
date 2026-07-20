# QA-4325 Batch 3 of 12 — Re-run log

**Run date:** 2026-06-04
**Tickets:** members 6-10 of QA-4325 — QA-575, QA-581, QA-2062, QA-10387, QA-19486

| QA-ID | Title | Skill | Result | Brand / Account | New bugs | Report |
|---|---|---|---|---|---|---|
| QA-575 | IG In Window Private Data QA | view-perspective-toggle, brand-content-data-set-selector | PARTIAL (dev-only) | Hulu (5670) / Hulu (336) | 0 | `runs/2026-06-02/QA-575-report.md` |
| QA-581 | Twitter In Window Private Data QA | view-perspective-toggle, brand-content-data-set-selector | PARTIAL (Video Views skeleton-hang; dev-only) | Hulu (5670) / Hulu (336) | 0 (skeleton-hang noted as new-finding) | `runs/2026-06-02/QA-581-report.md` |
| QA-2062 | Pinterest Content - Post Hovering | brand-content-table-view, brand-content-data-set-selector | PASS | Sephora (7159) / Sephora (655) | 0 | `runs/2026-06-02/QA-2062-report.md` |
| QA-10387 | Brand Insights - Impression and Video Views Chart - PNG | (no skill — spec drift) | BLOCKED (spec drift) | MTV (4018) / Adam Orfei (54) | 0 (finding flagged: tile-level PNG export absent on modern Brand Insights) | `runs/2026-06-02/QA-10387-report.md` |
| QA-19486 | Social Recap - Verify PDF | social-recap-report-run, pdf-end-to-end-verification | PASS (single-brand variant; multi-brand deferred) | MTV (4018) / Adam Orfei (54) | 0 (BC-4 page-footer NOT reproduced; APPS-55559 not triggered) | `runs/2026-06-02/QA-19486-report.md` |

## Summary
- **PASS:** 2 (QA-2062, QA-19486 single-brand)
- **PARTIAL:** 2 (QA-575, QA-581 — both dev-only stage-parity tests, plus QA-581 Twitter Video Views tile skeleton-hang)
- **BLOCKED:** 1 (QA-10387 — UI redesign removed tile-level PNG export per spec drift)
- **NEW bugs filed:** 0
- **New findings flagged for product/spec review:** 2
  - QA-10387 — tile-level PNG export absent on modern Brand Insights Trends-consolidated tile.
  - QA-581 — Twitter Video Views tile under In Window mode hung in skeleton-shimmer state for 45+ seconds without error message (distinct from IG render-lifecycle "table failed to load + Reload" pattern).

## Skill streak credits applied
- `view-perspective-toggle` +2 → streak 3 (eligible for stable promotion after one more separate-day pass).
- `brand-content-data-set-selector` +3 → streak 23.
- `brand-content-table-view` +1 → streak 4.
- `social-recap-report-run` +1 → streak 8.
- `pdf-end-to-end-verification` +1 → streak 10.

## Chrome state for batch 4
- Active tab: 1804437993 (post-PDF Social Recap story view at `app-reporting.lfmdev.in/#story/social_recap/154046` on Adam Orfei account_id=54).
- Recommend batch-4 start with `tabs_close_mcp` + fresh navigation.
- Known-quirk hit during batch: Brand Insights Hulu Last-7-Days range hangs Chrome MCP renderer — Adam Orfei MTV used as lighter alternative.
- Long Brand>Content / Brand>Insights navigations require explicit JS button-text click for Run Report (coordinate clicks below viewport edge fail) — same as QA-298 batch-2 finding.
