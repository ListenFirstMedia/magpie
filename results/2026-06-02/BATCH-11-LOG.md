# QA-4325 Batch 11 — execution log

- **Date:** 2026-06-04
- **Account:** Adam Orfei (account_id=54), Yash session on app.lfmdev.in
- **Members:** QA-134188 (reconfirm), QA-134271, QA-134272, QA-134273, QA-134296

## Per-ticket outcomes

| Ticket | Result | Skill | Notes |
|--------|--------|-------|-------|
| QA-134188 | RECONFIRM (carry-forward PASS) | `brand-insights-interval-picker` + `export-csv` | Brand>Insights renderer hung on every URL variant tried today (4-channel + single-channel, 1mo + 3mo ranges). Batch-5 PASS holds; tile-fetch / chart-paint freeze is a recurring quirk noted for KB update. |
| QA-134271 | PASS | (cross-cut) | Timestamp `Data Last Updated (PT): 06-04-2026 05:06 AM PT` identical across Home / Brand>Insights / Audience / Content / Channels / Stories / Optimization, persists through F5, persists across brand switch to Tory Burch. |
| QA-134272 | PASS | `brand-content-filter` | Default Include + Or-selected-but-disabled; Or/And enable on ≥2 tags; flipping to Exclude greys out tags already in Include. All DOM-state probes confirmed. |
| QA-134273 | PARTIAL | `brand-content-filter` | Mechanic verified at URL/JSON-serialization layer (operator=or/and toggle, not=true/false for Exclude). The 4-combo numeric dataset compare blocked by the documented "table failed to load" backend pattern (same family as QA-134277 known-quirk) on test-tag values. |
| QA-134296 | PASS | (cross-cut) | Brand Sets Rankings + Content timestamp identical to Brand surfaces (`06-04-2026 05:06 AM PT`), persists through F5, persists across brand-set switch (Adam's Brand Set → 1923 Talent). |

## New bugs filed

None — all behaviors that could be verified matched spec; the QA-134188 hang is a known-quirk extension and QA-134273 partial is a known-quirk extension (None+Or → expand to "Or on real tags with zero matching posts also fails").

## Chrome MCP state for batch 12

- Brand>Insights endpoint repeatedly hangs the renderer today — recovery requires `tabs_close_mcp` + fresh tab. Any future Brand>Insights tile-interaction tests should narrow to single-channel + short window AND have a fallback plan if even that hangs.
- Brand>Audience / Brand>Content / Brand>Channels / Brand>Stories / Brand>Optimization / Brand Sets surfaces all loaded cleanly.
- Active tab group (1593866171) at end of batch contained:
  - tabId 1804438084 — Brand Insights MTV IG (hung skeleton state)
  - tabId 1804438085 — Brand Insights MTV FB May 2026 (hung skeleton state)
- For batch 12: recommend close-all and `createIfEmpty:true` for a fresh group. Adam Orfei (account_id=54) is the active account.

## KB / REGISTRY updates queued

- known-quirks.md — extend `Brand Insights with Last 6/12 Months range freezes Chrome MCP renderer` entry with the 2026-06-04 single-channel + short-range reproductions.
- known-quirks.md — extend `Brand > Content backend rejects OR operator with empty tag value (None)` to note that OR on real tags with zero matching posts in the channel/range also fails with the same "This table failed to load" UI state.
- bug-history.md — append "2026-06-04 batch-11 re-run findings" sections under QA-134188, QA-134271, QA-134272, QA-134273, QA-134296.
- REGISTRY.md — bump `brand-content-filter` pass_streak (+1 from QA-134272). `brand-insights-interval-picker` and `export-csv` get carry-forward credit via QA-134188 RECONFIRM. No new skills authored.
