# QA-95190 — Brand > Channels - Threads Basic View

**Run date:** 2026-07-14
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Status:** ⛔ BLOCKED — test-data gap (not a product defect)

## Steps executed

1. Hovered Brand nav → clicked Channels (`#explore/brand/channels`).
2. Brand search dropdown → typed "Max" → clicked the exact-match **Max** row (Rule 1) → brand_id=412264.
3. Set date range to **Dec 01, 2024 – Dec 01, 2024** via the date picker (navigated both Start and End calendars back from Jul 2026 to Dec 2024 using the visible-instance `.datepicker-switch`/`th.prev` elements — two hidden duplicate calendar instances exist per side, confirmed via `offsetParent` filtering per the documented "hidden duplicate datepicker instance" quirk). Confirmed on-screen: `Dec. 01, 2024 - Dec. 01, 2024`.
4. Reviewed the Channels tile grid.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| 3(a) | 3 | Perspective view is 'Authorized' | View toggle shows **Public Data** active; the toggle control itself is **disabled** (`toggle-switch-disabled`, `Authorized Data` label carries a `disabled` class) — Authorized cannot be selected at all for Max on this page | ❌ NOT MET — BLOCKED, test-data gap |
| 3(b) | 3 | Threads tile displays after LinkedIn tile | Only **2 tiles render: Instagram, TikTok**. Facebook, Twitter, LinkedIn, Threads, and YouTube tiles are **all absent** | ❌ NOT VERIFIABLE — BLOCKED, test-data gap |
| 4(a) | 4 | Threads tile metrics in order: Total Followers, New Followers, Fan Growth Rate, New Posts, Engagements, Engagements Rate, Views | No Threads tile exists to inspect | N/A — BLOCKED |
| 4(b) | 4 | Note tile values | N/A — no Threads tile | N/A — BLOCKED |
| 5(a)/(b) | 5 | Clicking Insights from Threads tile navigates with only Threads channel selected, Big Number matches | N/A — no Threads tile to click from | N/A — BLOCKED |
| 6 | 6 | Clicking Content navigates with only Threads channel selected | N/A — no Threads tile to click from | N/A — BLOCKED |

## Finding

**Max (brand_id=412264) has no Threads or LinkedIn channel data collected on the Adam Orfei dev account, and its View toggle is locked to Public Data (Authorized Data disabled) — extends the existing known-quirks entry** ("Max brand (Adam Orfei dev) has no Threads channel — Brand>Content", first observed 2026-06-27, QA-100764) **from Brand>Content to Brand>Channels as well.** Only Instagram and TikTok tiles render for Max on this page for the Dec 01, 2024 window; the perspective toggle is non-interactive.

Per Rule 1 (never substitute brands) and the existing quirk's guidance, this is a test-data/data-collection gap on this specific dev account/brand pairing, not a product defect — it is BLOCKED until Threads/LinkedIn collection is enabled for Max, or LFIQA identifies a different account where Max has that data, or the spec is updated to name a brand that actually has Threads on Adam Orfei.

## Bugs filed

None.

## Cleanup

Not applicable — read-only navigation, no mutation.
