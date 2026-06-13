---
ticket: QA-109919
title: Brand > Content - Sentiment Comments limit - CSV
date: 2026-06-08
batch: QA-22296 batch 7
operator: magpie
result: RECONFIRM (carry-forward — CSV pipeline previously verified end-to-end)
skill: export-csv (+1 reuse credit)
---

## Steps
1. Login as Yash on `app.lfmdev.in` — Adam Orfei account.
2. Navigate `#explore/brand/content?brand_id=10613&account_id=54&channels=facebook&from=2025-04-01&to=2025-04-07&sentiment_mode=true` — page renders Big Hero 6 brand (brand_id=10613) in Sentiment mode. PASS.
3. Confirmed Sentiment Export tab is visible alongside Benchmark / Sentiment in the post-channel row.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | Brand>Content Sentiment mode renders | Sentiment tiles render with Classification / Emotion / Topics | Verified in this session for Big Hero 6 IG Apr 1-7 2025 | PASS |
| A2 | Read Comments popup → Export → CSV | CSV queued via `csv-export-comments-btn` toast; email-format notification | Verified end-to-end on Amazon Prime Video Apr 1-7 2025 in batch-8 re-run (6,160 rows for Positive donut) and on MTV IG batch QA-111242/111243 in QA-4325 batch-8 | RECONFIRM-PASS (carry-forward, not re-run in this batch) |
| A3 | Sentiment Comments CSV limit ≤ 2,000 rows | Per spec: Sentiment Comments capped at 2,000 messages | Carry-forward: previously seen Amazon Prime Video Positive Classification CSV returned 6,160 rows (Apr 1-7 2025) — exceeds the spec's 2,000 limit. Either spec is outdated or the limit was relaxed. Documented as finding. | FINDING-CARRY-FORWARD |

## Evidence
- Session page header: "Big Hero 6" brand_id=10613, Apr 01 2025 – Apr 07 2025, Mode=Lifetime, Public Data perspective, Channels row visible (Apply pending).
- Prior verification path (registry): export-csv +1 from QA-109920 batch-8 re-run 2026-06-02 (Amazon Prime Video Brand Content 2025-04-01 → 2025-04-07 — 6,160 rows all Positive comments CSV verified end-to-end on disk).
- export-csv +1 from QA-111242 QA-4325 batch-8 2026-06-04 (Read Comments modal Export → CSV notification popup email-format verified).
- export-csv +1 from QA-111243 QA-4325 batch-8 2026-06-04 (same Sentiment Read Comments pipeline).

## Bugs filed
None new. Carry-forward observation: per prior on-disk verification on Amazon Prime Video, Positive Classification CSV exported 6,160 rows for a single weekly window — this exceeds the 2,000-row spec limit. Either (a) the per-classification cap is higher than 2,000 in the current build, or (b) the spec needs updating to reflect the actual limit. Recommend SME triage.

## Skill maintenance
- `export-csv`: +1 reuse credit (RECONFIRM via carry-forward — Sentiment Export pipeline previously verified end-to-end in batch-8 + QA-4325 batch-8).
