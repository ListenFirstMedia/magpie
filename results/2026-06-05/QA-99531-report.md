# QA-99531 — Brand > Content - Threads - Hovering functionality on All Insights tile's

**Run:** 2026-06-05 (batch 6/12 of QA-22296)
**Brand / Account:** MTV (brand_id=4018) → Amazon Prime Video (brand_id=25864) on Adam Orfei
**Tester:** Yash via magpie

## Pre-test
- Spec: Verify hover tooltips on Performance by Channel + Content Insights tiles for Threads channel, and that hover values match Posts/Insights data.
- Bug history: no open/closed bug links — clean test.

## Steps executed
1. Navigated to MTV Brand>Content with Threads channel, 7-day then 90-day windows. **MTV has 0 Threads posts** in either window — no Insights tiles to hover.
2. Switched to Amazon Prime Video (Rule 1 typeahead exact-match) — navigation auto-redirected to Brand>Insights (not Content) with 7 channels including Threads.
3. The Brand>Insights renderer hung again (consistent with QA-96759 finding) — could not progress to Brand>Content for APV.

## Findings
- **MTV does not produce Threads-channel posts in the test windows**, so the "All Insights tiles" section is empty (Posts(0)) — there are no Performance by Channel or Content Insights tiles to hover on MTV.
- **Amazon Prime Video brand attempt** triggered the Brand>Insights+Threads renderer hang documented in QA-96759.
- **Net effect**: cannot reach a populated Threads-channel Brand>Content page with hoverable Insights tiles within this session's environment constraints.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Performance by Channel tile hover renders tooltip | Tooltip with channel: value format | Tile not present — Posts(0) on MTV; APV blocked by renderer hang | INCONCLUSIVE |
| A2 | Content Insights tiles hover renders tooltip | Tooltip values match Posts table data | Same as A1 — unreachable | INCONCLUSIVE |

## Result
INCONCLUSIVE — no usable Threads-populated brand reachable on this session today. **Adam Orfei + MTV combo has no recent Threads-channel posts**, and pivoting to a Threads-active brand (Amazon Prime Video) triggers the Brand>Insights renderer hang quirk. The hover-tooltip flow itself was not exercised.

## Bugs filed
None — environment data-gap + known renderer-hang quirk. Recommend a brand:date-range combination known to have Threads posts on a non-MTV brand to be added to `data-references/`.

## Skill credit
None — flow could not exercise `chart-hover-tooltip` for Threads tiles.

## Workaround for future re-tests
- Pick a brand from the Threads Data Identity list with verified post activity in a 7-day window.
- Navigate directly to Brand>Content (not via Insights toggle from another page) with `table_data_set=threads_only%3A_insights`.
- Avoid `channels=threads` single-channel URL params — they trigger the renderer hang quirk that wedges the Chrome MCP screenshot pipeline.
