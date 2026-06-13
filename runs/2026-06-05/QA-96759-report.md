# QA-96759 — Brand > Insights - Threads - Tile Level Export - PNG

**Run:** 2026-06-05 (batch 6/12 of QA-22296)
**Brand / Account:** MTV (brand_id=4018) on Adam Orfei account
**Tester:** Yash via magpie

## Pre-test
- Spec: Verify tile-level PNG export on Brand>Insights for the Threads channel across all tiles.
- Bug history: no open/closed bug links.
- Known quirk applied: Brand>Insights with `channels=threads` (single-channel) hangs the renderer.

## Steps executed
1. Navigated to `https://app.lfmdev.in/#explore/brand/insights?brand_id=4018&account_id=54&from=2026-05-07&to=2026-06-06&channels=threads&perspective=extended` (Threads-only, 30 days).
2. **Renderer hung** — UI returned skeleton frames; subsequent `screenshot` and `get_page_text` requests timed out for >60 s.
3. Closed and reopened tab; retried with multi-channel `channels=threads&channels=instagram&channels=facebook` (7 days, May 31 – Jun 06).
4. Hung again — same long-running browser-extension timeouts.
5. Retried 2-channel `channels=threads&channels=twitter` (7 days). Page rendered Date Range + brand header skeleton but never progressed to tile render.
6. After 60+ seconds total wait per attempt, the Chrome MCP `screenshot` / `get_page_text` calls stopped returning. Could not advance to tile-level Export → PNG step.

## Findings
- **Brand>Insights renderer hangs whenever the `channels` query string includes `threads`**, in all of these configurations:
  - `channels=threads` alone (Threads-only)
  - `channels=threads&channels=instagram&channels=facebook` (3 channels)
  - `channels=threads&channels=twitter` (2 channels)
- The hang is more aggressive than the previously documented behavior — it not only blocks tile render but also wedges the Chrome MCP extension itself (subsequent screenshots time out).
- This is consistent with the known-quirks entry: "Brand > Insights long ranges OR single-channel `channels=threads`: renderer hangs". Today's reproduction extends the rule to **any Threads-inclusive multi-channel combination** on MTV brand.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Brand>Insights tiles render with Threads channel | Tiles render, Export dropdown reachable | Page never progresses past skeleton — renderer hangs | INCONCLUSIVE — renderer hang |
| A2 | Each Threads tile exports as PNG with correct filename schema | `<Brand>-Insights-<Tile>-<ChartType>-<from>-<to>.png` on disk | Cannot reach Export menu — page unresponsive | INCONCLUSIVE |

## Result
INCONCLUSIVE — **renderer hang quirk reproduced and worse than documented**. Brand>Insights with any Threads-inclusive channel combination wedges the page render AND the Chrome MCP screenshot pipeline. PNG tile exports cannot be validated on this surface without first resolving the render hang.

## Bugs filed
None as new bug — this is a known quirk (already cataloged in `known-quirks.md`). Recommend escalating severity in the quirk doc: the hang now wedges the MCP browser session for >60 s, not just the page render.

## Skill credit
None — flow could not exercise the `audience-metrics-export` Brand>Insights variant due to render hang.

## Recommendation
- Reproduce on the BoxOffice / Sentiment-stable channel set first (e.g. `channels=youtube&channels=tiktok`) to confirm the hang is Threads-specific on this browser session, then file an environment-level bug if needed.
- For PNG tile-export validation of the Threads channel specifically, a non-MTV brand (e.g. one of the smaller Threads-authorized brands) may bypass the hang.
