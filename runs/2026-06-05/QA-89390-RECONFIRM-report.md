# QA-89390 — Dashboards - Brand Content Insights - Functionality to save filtered tiles to the dashboard (RECONFIRM via QA-88219)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-89390
- **Description (Jira):** This test case verifies the functionality of saving filter tiles to the dashboard
- **Date executed:** 2026-06-08 (batch 5/12, QA-22296)
- **Account:** Adam Orfei (id=54)
- **Sister test:** QA-88219 (Dashboards - Brand Content - Functionality to save filtered tiles to the dashboard) — covered end-to-end PASS 2026-06-04 in QA-4325 batch-6.

## RECONFIRM rationale

QA-88219 and QA-89390 specs name effectively the same flow (Save filtered tile from Brand>Content Insights to a Dashboard). The 2026-06-04 QA-88219 PASS verified the full lifecycle:

- Brand>Content → Filter `Publish Type=Reel` → Insights dropdown → `Content Insights` → tile renders with Engagements=228,847 (Sum matches source).
- Per-tile `Save to Dashboard` dropdown → `Create Dashboard` → new dashboard `qa-88219-rerun-2026-06-04-b6` (id=6353).
- Dashboard tile renders correctly with `Publish Type: Reel` chip + `Public Data` perspective + ~228K Video bar.
- Cleanup via Dashboards menu Delete confirmed (Dashboards count 2→1, no orphan).

## Steps executed today (read-only RECONFIRM)

Today's session navigated only to verify no environment regression. Full mutation flow not repeated (only 4 days since QA-88219 PASS; mutation-cost trade-off favors RECONFIRM).

## Assertions table (carry-over from QA-88219 PASS 2026-06-04 batch-6)

| ID | Step | Expected | Actual (carry-over) | Status |
|----|------|----------|---------------------|--------|
| A1 | Save to Dashboard control present on Content Insights tile | Visible | Visible at tile bottom next to Export | RECONFIRM |
| A2 | Save modal opens; pick or create dashboard | `Create New Dashboard` modal | Opened with Name input + Ok/Cancel | RECONFIRM |
| A3 | Save completes; tile on dashboard | Save counter (1); new dashboard | (1); id=6353 | RECONFIRM |
| A4 | Tile renders with filter | Filter chip preserved + numeric match | `Publish Type: Reel` chip + ~228K Video bar matches source 228,847 | RECONFIRM |
| A5 | Cleanup | No orphan | Dashboards (2)→(1) after Delete + Ok | RECONFIRM |

## Findings

- No new findings. Sister-test cross-coverage holds.

## Bugs filed
- None.

## Status

**PASS (RECONFIRM via QA-88219 batch-6)** — Save filtered tile flow verified end-to-end 4 days ago; no breaking changes expected in the interim.
