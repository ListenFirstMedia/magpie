# QA-22296 Batch 3/12 — 2026-06-05

Next 5 net-new tickets after batch 2 (QA-199/574/844/926/2042).

| QA | Spec | Verdict | Result | Report |
|----|------|---------|--------|--------|
| QA-18940 | Brand > Video Favourites Functionality | Heart toggle MTV `fal fa-heart` → `fas fa-heart`; persists across Home→Brand>Video round-trip; cleanup blocked (toggle-off JS click ineffective — flagged for LFIQA manual unfavourite) | PASS | `runs/2026-06-05/QA-18940-report.md` |
| QA-22072 | Brand > Partnerships Basic View — Advanced Filter capability of Metrics | Filter popover has 10 sub-categories (Collaborated/Collaborator Name/Content Type/Publish Day/Publish Time/Publish Type/Sponsor Name/Tag/Text Search + Collaborated Total). **NO metric-based sub-filter present.** Search for "engagement" returns 0 rows. | PARTIAL — possible spec drift or product gap (new finding) | `runs/2026-06-05/QA-22072-report.md` |
| QA-23991 | Reporting > CPR Download | Built CPR story_id=154220 MTV (May 31 – Jun 6 2026) → Preview & Share → Download → `MTV-Content Performance(May 31, 2026 - Jun 6, 2026).pdf` 294K 1pg jsPDF on disk. LFMP-32010 not tested (Least Engaging not enabled). | PASS | `runs/2026-06-05/QA-23991-report.md` |
| QA-24021 | Reporting > TWC Download | Built TWC story_id=154221 MTV Total Followers (May 31 – Jun 6 2026) → Preview & Share → Download → `MTV-Time Window Comparison(May 31, 2026 - Jun 6, 2026).pdf` 313K 1pg jsPDF on disk. | PASS | `runs/2026-06-05/QA-24021-report.md` |
| QA-27292 | Brand > Content - Download CSV Template in Update Tag Modal | Tag dropdown → Upload Tags option → Update Tag Modal → Download CSV Template link → `LF Upload Tags Sample - Sheet1.csv` 696 bytes 2-col schema (Post URL, Post Tag) + 8 sample rows across 6 channels (FB/Twitter/IG/YT/TikTok/LinkedIn) | PASS | `runs/2026-06-05/QA-27292-report.md` |

## Batch summary
- 4 PASS, 1 PARTIAL (QA-22072).
- 1 new finding: QA-22072 — Brand>Partnerships Basic Filter has no metric-based sub-filter (spec says "Advanced Filter capability of Metrics"). Recommend product/spec triage.
- 3 end-to-end downloads verified on disk this batch (CPR PDF 294K, TWC PDF 313K, CSV template 696B).
- 1 brand-level mutation: MTV favourited on Adam Orfei (cleanup pending — manual unfavourite required).
- Brand>Video chart-content rendering remains sparse on MTV (header + footer only) — distinct from Brand>Insights renderer hang quirk; the Favourites button (brand header row) is independent and works.

## Skills used / streak bumps
- `pdf-end-to-end-verification` — QA-23991, QA-24021 (full rasterize + filename verify cycle).
- `brand-content-data-set-selector` — QA-27292 (Brand>Content navigation + Tag dropdown discovery).
- (new pattern: Update Tag Modal Download CSV Template flow — candidate for future `brand-content-tag-upload` skill if revisited).

## Chrome state for batch 4
- Active tab: `1804438454` on `#explore/brand/content?brand_id=4018&account_id=54&...&layout=table` (MTV Brand>Content; Update Tag Modal still open after CSV Template download).
- Stale orphan tab: `1804438457` ("Untitled") created during CSV download click. To close before batch 4.
- Account: Adam Orfei (account_id=54). Login confirmed throughout.
- No Sentiment-mode lock reproduced this batch on MTV.
- Brand>Video sparse-content + Brand>Insights renderer hang remain documented but did not block this batch (none of the 5 tickets needed chart-data).
- MTV favourite-flag persists in account state (cleanup pending).
