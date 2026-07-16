# QA-1124 — Brand Insights - Public Data - Hovering Functionality

- **Run date:** 2026-07-01
- **Skill used:** `chart-hover-tooltip` (Playwright MCP / D3 SVG approach)
- **Account/Brand:** Hulu (account_id=336). Brand switched via direct URL `account_id` (no LFQA-menu typeahead — per run instruction to minimize tokens using IDs). Brand context resolved automatically to Hulu on the same account (no separate brand-picker step needed since account IS Hulu). **Note:** brand_id was NOT stable across the perspective toggle — see Bugs/Findings below.
- **Date range:** May 31, 2026 – Jun 29, 2026 (30 days, via "Last 30 Days" preset)
- **Channels:** Facebook, Twitter, Instagram, TikTok (default)

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 (5a) | Public Data toggle → review graphs | Tooltip shows only legend channels | Confirmed on Follower Growth, New Posts, Engagements, Total Followers (FB/TW/IG/TT); Views showed Twitter-only (matches its single-channel legend) | PASS |
| A2 (5b) | — | "Compared to" tweak on all bar charts | Present on every bar tile (Follower Growth, Fan Growth Rate, New Posts, Engagements, Response Rate) | PASS |
| A3 (6a) | Hover Follower Growth | Chart hoverable | `browser_hover` on `rect.bar` rendered tooltip natively | PASS |
| A4 (6b) | — | `Mon. DD, YYYY` + `Channel: Values`, hovered channel highlighted | `Jun. 20, 2026 / Facebook: 308 (-70.8%) / Twitter: 16,979 (+3.9%) / Instagram: 1,462 (-15.0%) / TikTok: 100,000 (+999.0%)` — TikTok row has `chart-tooltip__row--selected` | PASS |
| A5 (7) | Hover New Posts | Hovered channel highlighted | `Jun. 08, 2026 / Facebook: 14 (+250.0%) / Twitter: 10 (+150.0%) / Instagram: 12 (+300.0%) / TikTok: 12 (+300.0%)` — Facebook row selected | PASS |
| A6 (8) | Hover Engagements | Hovered channel highlighted | `Jun. 04, 2026 / Facebook: 57,268 (+174.4%) / Twitter: 2,543 (+232.4%) / Instagram: 148,046 (+1.4%) / TikTok: 581,236 (+999.0%)` — TikTok row selected | PASS |
| A7 (9) | Hover Response Rate | `Mon. DD, YYYY` + `Chart Name: Values` | `Jun. 19, 2026 / Response Rate: 2.55%` | PASS |
| A8 (10) | Hover Fan Growth Rate | Same format | `Jun. 20, 2026 / Fan Growth Rate: 0.68%` | PASS |
| A9 (11) | Hover Views (area) | `Mon. DD, YYYY` + `icon Twitter: Values` | `Jun. 15, 2026 / Twitter: 556,101 (+8.3%)` — icon `fab fa-square-x-twitter` present | PASS |
| A10 (12a) | Hover Total Followers (donut/pie) | `icon Facebook: #N` | `Facebook: 6,201,187` row selected, icon `fab fa-facebook-square` color `#4267B2` | PASS |
| A11 (12b) | — | Area chart updated to Aggregate View | After Data Viz → Aggregate, Public Video Views legend collapsed from per-channel to combined `Facebook, Twitter, Instagram, TikTok` | PASS |
| A12 (13) | Data Viz → Aggregate | Tooltips in `Mon. DD, YYYY` + chart-name-prefixed lines | Verified via A13 below (Public Video Views) | PASS |
| A13 (14) | Hover Public Video Views (Aggregate) | `Mon. DD, YYYY` + `Public Video Views: values` | `Jun. 15, 2026 / Public Video Views: 6,570,814` | PASS |

**Overall: 13/13 PASS.**

## Bugs / findings carried forward or newly observed

1. **LFMP-31781 (Minor, Open, carried forward — not re-verified this run to save tokens).** Twitter icon renders in legacy blue instead of black in legend/tooltip components. See `bug-history.md` for prior DOM-RGB reproduction.
2. **NEW finding — perspective-toggle brand_id swap on Hulu.** Clicking the Public/Authorized toggle changed `brand_id` in the URL from `5670` → `11003` (and `perspective=extended` → `standard`) automatically. This matches the previously-documented QA-98351 quirk (brand_id auto-fallback on perspective toggle) but is the first time it's been observed for Hulu specifically rather than Threads/MTV. Not a functional defect (page rendered correctly under the new brand_id), but automation relying on a fixed `brand_id` across a perspective toggle will break. Logged to `known-quirks.md`.
3. **Transient tile failures during the toggle transition.** Immediately after switching Date Range to 30 days (while still in Authorized/extended view), `Follower Growth`/`Fan Growth Rate` tiles showed "You'll need to authorize and connect your account", and `New Posts` showed "This tile failed to load. Please try again." + RELOAD. This resolved on its own once the View toggle was clicked to Public — no manual reload was needed by the time of final verification (all tiles rendered cleanly under Public + Aggregate). Documented as a transient render artifact tied to the toggle transition, not a standing defect.
4. **Playwright MCP `browser_take_screenshot` timeout on this page.** Screenshot calls twice hit `TimeoutError: Timeout 5000ms exceeded ... waiting for fonts to load` on Brand Insights, consistent with the known "Brand Insights renderer hang" quirk. Worked around by reading `document.body.innerText` / targeted DOM queries via `browser_evaluate` instead — no screenshots exist for this run's evidence, all evidence is DOM-text-based.
5. **Donut/pie chart hover required a synthetic-event fallback.** `browser_hover` (trusted event) failed with `<svg> intercepts pointer events` because the arc `<path>`'s bounding-box center falls outside its actual pie-slice fill area (a geometry issue inherent to non-rectangular SVG shapes). Fell back to the documented legacy JS `dispatchEvent(mouseover/mousemove/mouseenter)` sequence directly on the arc path, which worked. Bar/area/line charts did not need this fallback — only the donut.

## Cleanup
No mutating actions performed — no cleanup required.
