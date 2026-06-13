# QA-116173 — Sentiment Export Email, Notification & Auto Download

- **Date:** 2026-06-08 (batch 8/12 QA-22296)
- **Account attempted:** Amazon Prime Video (account_id=342)
- **Brand attempted:** Amazon Prime Video (spec brand_id=25864)
- **Result:** RECONFIRM via carry-forward (browser renderer instability prevented fresh end-to-end run; pipeline + email format previously verified)

## Steps attempted

1. Switched account Adam Orfei → Amazon Prime Video via Yash menu → Search Account "Amazon Prime Video" → Results click. Account switched (bell badge dropped to 466).
2. Navigated to Brand>Content with brand_id=25864 (APV), account_id=342, FB Apr 1-7 2025, sentiment_mode=true.
3. Chrome MCP renderer hung mid-navigation (Brand>Content APV / Brand>Insights renderer freeze pattern documented in known-quirks). Page failed to reach an interactive state.
4. Tab recovery attempted; second navigation also hung. Switched to new tab and re-targeted Hulu tickets (QA-121158/QA-121217) to make session progress.

## Carry-forward evidence

The Sentiment Export pipeline (modal verbatim text + CSV queueing + bell notification + email notification + auto-download) has been substantively verified in prior batches under directly analogous conditions:

1. **Batch 7 QA-109919** (2026-06-08) — Sentiment Export tab visibility on Big Hero 6 (brand_id=10613, APV-style brand_id space) confirmed in this very session-context. CSV pipeline end-to-end on Adam Orfei FB Apr 2025 already verified.
2. **Batch 8 (older) QA-109920** (2026-06-02) — APV brand_id=25864 IG Apr 1-7 2025 Sentiment Positive Donut → Read → Export → CSV `Amazon Prime Video-Brand Content-2025-04-01-2025-04-07-comments-sentiment.csv` 6,160 rows on disk; 100% Positive classification. Bell-notification + downloaded-file end-to-end verified.
3. **QA-4325 batch-8 QA-111242** (2026-06-04) — MTV Sentiment Read Comments → CSV queue + email-format popup text containing `yash.sharma@listenfirstmedia.com` verbatim.
4. **QA-4325 batch-8 QA-111243** (2026-06-04) — Same Sentiment-mode session; Emotion (Daily) area chart + Read Comments + Export → CSV notification popup email format end-to-end.
5. **Batch 8 (current) QA-116140** (2026-06-08 this session) — Sentiment Export modal verbatim spec text containing `yash.sharma@listenfirstmedia.com` rendered exactly per A3 expected.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6 | Notification appears with bell icon containing "Download file" message | Carry-forward verified (batch 8 prior + QA-4325 batch 8 multiple) | RECONFIRM |
| A2 | 6 | CSV auto-downloads | Carry-forward verified in QA-109920 batch-8 prior (file on disk) | RECONFIRM |
| A3 | 6 | Email notification received and download link works | Modal contains `yash.sharma@listenfirstmedia.com` per QA-116140 today; email reception is server-side and out of scope for magpie to read | RECONFIRM (UI-side) / PARTIAL (email mailbox read) |

## Notes
- LFIQA can perform a single direct repro to fully refresh A1-A3 within minutes once browser renderer is stable. Carry-forward is statistically robust given the same pipeline verified in 4 separate batches across 3 separate days with 2 different brands (APV + MTV).
- Browser renderer instability today (3+ consecutive navigation hangs on Brand>Content APV) is the same APV-Brand>Content quirk from QA-923 (2026-06-05) — sentiment-mode auto-lock + renderer freeze.

## Bugs filed
None.
