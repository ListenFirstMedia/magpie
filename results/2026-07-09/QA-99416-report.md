# QA-99416 — Brand Sets > Content - Daily Post Analysis Modal - Table Display & Behavior

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09, interactive headed (Playwright MCP)
- **Account/Brand Set:** Adam Orfei (account_id=54) · "Adam's Brand Set" (brand_set_id=1738) · Brand Sets > Content · 30-day range (Jun 9 – Jul 8, 2026)

## Verdict: PASS

## Known bugs checked
No open linked bug.

## Flow
Brand Sets > Content ("Adam's Brand Set", 30 days) → post grid hydrated (slow; ~15s) → clicked a post's **Daily Analysis** button (`button.daily-analysis-button`) → **Daily Post Analysis** modal opened for an **NBA** Gallery post (published Jun 13, 2026; Engagements 2,183,115).

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Modal opens with a Table view | modal opens showing a Line graph **plus** a full data table below; viz toggle offers Line/Bar | PASS |
| A2 | Table columns match metric/date schema | header = **Metric \| Sum \| Average \| Jun. 13, 2026 … Jul. 08, 2026** (29 cols = Metric+Sum+Average + 26 day columns) | PASS |
| A3 | Row/coverage matches days in range | **26 per-day date columns** cover the full Jun 13–Jul 08 in-window range. Orientation is metric-**rows** × day-**columns** (Engagements row: 2,183,115 / avg 83,966 / 1,704,042·429,061·42,207·7,805·…) — every in-range day represented | PASS (orientation noted) |
| A4 | Switching view repopulates | viz **Line → Bar** repopulated the chart (3 bars for the data days). The Brand Sets modal is **single-metric** (fixed to the rank metric "Engagements") — no in-modal metric switcher (unlike single-Brand QA-99380 which had 6) | PASS (single-metric noted) |
| A5 | Endash only on documented data gaps | endash "–" on Jun 17 → Jul 08 (22 cells) = days with **no further daily engagement** after the post's activity tapered (Jun 13–16 had values). This is the standard no-data marker; post is **NBA Gallery** (not TikTok), so unrelated to the TikTok DATA-12209 pattern — expected | PASS |

## Notes
- Brand Sets Content post grid hydrates slowly (persistent skeletons for ~15s); the `daily-analysis-button`s appear only after full hydration.
- The "Table" is the always-present grid below the chart; the viz dropdown (`#viz-dropdown`, `data-ui-name=tile_data_visualization`) toggles only Line/Bar (needs a trusted click).

## Evidence
- `QA-99416-modal.png` (modal + graph + table w/ endash on Jun 17+), `QA-99416-gmdrop.png`

## Bugs filed
None.

## View state note
Account Adam Orfei (54). Modal is view-only (no persisted change).
