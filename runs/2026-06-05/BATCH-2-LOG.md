# QA-22296 Batch 2/12 — 2026-06-05

Five next-by-QA-ID tickets (after the 5 highest-priority open-bug tickets in batch 1).

| QA | Spec | Verdict | Result | Report |
|----|------|---------|--------|--------|
| QA-199 | TWC TSV Exports Relative Dates | A4 FAIL — Date column shows relative labels (3 Days Out / Event Day / 1 Day Post) NOT absolute dates as spec calls for | FAIL (new finding) | `runs/2026-06-05/QA-199-report.md` |
| QA-574 | Instagram Lifetime Private Data QA | Authorized + Public IG Lifetime numerics identical for MTV May 25–31 2026 window; no "Recent" tab in current UI build (Public used as proxy) | PASS (with spec interpretation note) | `runs/2026-06-05/QA-574-report.md` |
| QA-844 | TikTok Content Exporting Tags | Posts(74) MTV TikTok loaded; Export modal opens + accepts submission; queued CSV did NOT surface in Notifications nor on disk within 60+s | PARTIAL / NOT VERIFIED (Tags column verification blocked) | `runs/2026-06-05/QA-844-report.md` |
| QA-926 | Embedded Post Tooltip - YouTube | YT embed tooltip renders with thumbnail + title + Watch on YouTube CTA + X. X dismisses cleanly. youtube.com/watch?v= URLs in DOM | PASS | `runs/2026-06-05/QA-926-report.md` |
| QA-2042 | Facebook Content - Post Hovering | FB embed tooltip renders with MTV verified-badge avatar + video thumbnail + Share + X. X dismisses cleanly. facebook.com/page_post URLs in DOM | PASS | `runs/2026-06-05/QA-2042-report.md` |

## Batch summary

- 5 reports written end-to-end.
- 1 new finding logged: QA-199 A4 — Relative→Absolute date resolution missing in TSV export. Existing closed APPS-43327 / APPS-42928 were about week-alignment, not absolute-date resolution. Recommend product/spec triage (either file a Bug or rewrite the spec to "relative labels").
- 1 PARTIAL: QA-844 — Export queue plumbing did not surface a new notification or on-disk CSV within 60+s on Adam Orfei dev today. Candidate for new known-quirk if this becomes systemic.
- 2 PASS for embedded tooltip pattern (QA-926 YouTube, QA-2042 Facebook).
- 1 PASS with proxy-interpretation note (QA-574 IG Lifetime Private — no "Recent" tab in current build).

## Skills used
- `time-window-comparison-run` — QA-199 (Hulu, Relative Dates, Jun 5 keydate, FB New Fans).
- `keydate-picker` — QA-199 (calendar fallback for Jun 5).
- `brand-content-data-set-selector` — QA-574, QA-844, QA-926, QA-2042.
- `brand-content-table-view` — QA-926, QA-2042.
- `view-perspective-toggle` — QA-574 (Authorized vs Public for IG Lifetime).
- `export-csv` — QA-199 (TSV file inspected on disk), QA-844 (submission accepted but queue did not surface).

## Chrome state for batch 3
- Active tab: `1804438444` on `#explore/brand/content?brand_id=10765&account_id=54&channels=facebook&...&layout=table` — MTV FB Brand>Content, Posts(70).
- 1 tab in group. No stale tabs hanging.
- Account: Adam Orfei (account_id=54). Login confirmed.
- Brand>Content Sentiment-mode-lock from batch-1 known-quirks did NOT reproduce on MTV channels today (YT/FB/TikTok all rendered post tables). May be brand- or session-specific.
- Hash-router rewrites `brand_id=4018` (MTV) to `brand_id=10765` on Brand>Content load — page header stays MTV; functional impact minimal but noted for batch-3.
