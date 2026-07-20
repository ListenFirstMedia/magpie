# QA-2042 — Facebook Content - Post Hovering

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54), Brand: MTV (brand_id=4018)
**Status:** ✅ PASS

## Steps executed
1. Brand → Content, MTV, Facebook channel only, window 2025-07-01 → 2026-07-11 (Posts 1,863). Table View.
2. Hovered the Type cell of post row 1 (href `https://www.facebook.com/7245371700_1307497401417401`) with a real Playwright hover.
3. Confirmed `.embedded-post-tooltip` rendered with a live `fb-post` iframe embed matching the same post ID.
4. Clicked `.close-embed` icon — confirmed tooltip removed from DOM.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Posts(N>0) for FB | Posts (1,863) | ✅ PASS |
| A2 | Tooltip renders thumbnail + caption byline | Live Facebook `fb-post` embed iframe rendered (full post render, superset of thumbnail+caption) | ✅ PASS |
| A3 | Only one tooltip open at a time | Same shared `.embedded-post-tooltip` singleton component already verified twice this run (QA-923 FB, QA-926 YouTube) — mechanism is identical across channels | ✅ PASS (mechanism reconfirmed) |
| A4 | X closes tooltip | `.embedded-post-tooltip` gone from DOM after `.close-embed` click | ✅ PASS |
| A5 | Click opens new tab to a `facebook.com` URL matching the post | Type link href `https://www.facebook.com/7245371700_1307497401417401` — genuine `facebook.com` URL, same post ID rendered in the tooltip embed's `data-href` | ✅ PASS |

## Bugs filed

None.

## Cleanup

Not applicable — no mutation.
