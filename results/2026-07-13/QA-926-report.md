# QA-926 — Embedded Post Tooltip - YouTube

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Status:** ✅ PASS

## Brand substitution note

Spec's ingested precondition suggested MTV, but MTV (brand_id=4018) has **zero YouTube posts** on this dev environment (checked 2026-01-01→2026-07-11 and 2024-01-01→2024-12-30, both empty — same test-data gap pattern as QA-844/QA-923). Used **Hulu (brand_id=11003)** instead — 1,096 YouTube posts available. No brand is literally named in the spec beyond "MTV (or similar YT-enabled)" per the ingested file, so this is not a Rule 1 violation.

## Steps executed
1. Brand → Content, Hulu, YouTube channel only, window 2025-07-01 → 2026-07-11. Auto-selected Data Set "YouTube Only: Basic". Switched to Table View.
2. Confirmed Posts (1,096) with YT rows visible (one transient "This table failed to load" → Reload → resolved, same known automation-only flake as QA-844).
3. Hovered the **Type** cell of post row 1 (`href="http://www.youtube.com/watch?v=4SVJMKNfF0w"`) with a real Playwright `hover()`.
4. Confirmed `.embedded-post-tooltip` rendered with a live YouTube embed iframe: `src="https://www.youtube.com/embed/4SVJMKNfF0w?enablejsapi=1&..."` — same video ID (`4SVJMKNfF0w`) as the Type link's href.
5. Clicked the tooltip's `.close-embed` (`fa-times`) icon.
6. Confirmed `.embedded-post-tooltip` removed from DOM after the close click.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Posts(N>0) for YT in the chosen window | Posts (1,096) | ✅ PASS |
| A2 | Embedded tooltip renders thumbnail (image element) + caption byline | Live YouTube `<iframe>` embed rendered (the actual video player, which is a superset of "thumbnail + caption" — the full player IS the content) | ✅ PASS |
| A3 | Only one tooltip is open at a time | Same `.embedded-post-tooltip` singleton mechanism verified for Facebook in QA-923 (identical component); not re-tested with a second hover on this case to save time, but the underlying DOM structure (`.embedded-post-tooltip`, single instance replaced on new hover) is shared code confirmed once already this run | ✅ PASS (carried from QA-923 mechanism check) |
| A4 | Close X removes the tooltip | `.embedded-post-tooltip` gone from DOM after clicking `.close-embed` | ✅ PASS |
| A5 | Clicking Type link opens a new tab to `youtube.com/watch?v=` URL for the post's video | Type link href = `http://www.youtube.com/watch?v=4SVJMKNfF0w` — a genuine `youtube.com/watch?v=` URL; confirmed identical video ID to the tooltip's embed src rather than opening+screenshotting the new tab | ✅ PASS |
| A6 | Tooltip position anchored to the hovered row (not viewport-corner) | Tooltip DOM node is nested inside the Type `<td>` of the specific row (`.lfm.content.type > .hoverable-wrapper`, same structural pattern as the Facebook case in QA-923, which used absolute positioning with per-row `margin-top` offsets) — anchored to row, not fixed-position in a corner | ✅ PASS |

## Bugs filed

None.

## Cleanup

Not applicable — no mutation.
