# QA-27292 — Brand < Content - Download CSV Template in Update Tag Modal

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Status:** ⏭️ SKIPPED — could not reach the modal in this session

## What was tried
1. Confirmed the "Upload Tags" feature is **not on MTV's Content toolbar** (`Tag | Export` only) — required Hulu (brand_id=11003), which shows the fuller `Tag ▾ (Bulk Tag / Upload Tags / Manage Tags) | Export` toolbar. This itself matches the previously-documented spec drift ("Upload Tags lives on Brand>Content, not Settings>Tags") — reconfirmed here as brand-dependent too.
2. Clicked the **Tag** toolbar dropdown to reveal "Upload Tags" — confirmed the dropdown opened and "Upload Tags" was findable in the DOM three separate times (via JS `.click()`, then via a real Playwright `browser_click`).
3. Each of the 3 attempts to click "Upload Tags" itself (both JS-dispatched and a real trusted click) resulted in **no modal appearing** in the DOM afterward.

## Why skipped rather than retried further

Per instruction, skipping after repeated failed attempts rather than continuing to spend session time on a single case. This may be:
- A timing issue (dropdown auto-closes before the second click registers), or
- A genuine click-target issue similar to other overlay/dropdown quirks already documented in this codebase (e.g. the Apply Filter wrapper-div intercept from QA-1677).

## Assertions

Not evaluated — the modal containing the "Download CSV Template" link was never reached.

## Bugs filed

None — insufficient evidence to distinguish an automation quirk from a product defect.

## Cleanup

Not applicable — no mutation occurred (no modal opened, no tag/template action taken).

## Recommendation for a future run

Retry with a screenshot immediately after the Tag-dropdown click (before clicking Upload Tags) to visually confirm the dropdown's actual open state and the real coordinates of "Upload Tags", since 3 programmatic-selector-based clicks all failed to produce a visible effect.
