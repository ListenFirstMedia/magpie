# QA-5503 — Brand Insights - YouTube - Basic View

**Run date:** 2026-07-09
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Disney Entertainment Television (account_id=113)
**Brand:** Disney Channel (brand_id=3877)
**Skill authored:** [brand-insights-channel-selector-bpc-sort](../../skills/brand-insights-channel-selector-bpc-sort/SKILL.md) (NEW)

## Steps executed

1. Switched account from Adam Orfei → **Disney Entertainment Television** via the profile-menu "Search Account" → Results-section click pattern (`switch-account` skill). URL confirmed `account_id=113`, breadcrumb "Account: Disney Entertainment Television".
2. Navigated to `#explore/brand/insights?account_id=113` — auto-defaulted to **Disney Channel** (brand_id=3877). Per Rule 2/3, explicitly re-performed the brand selection anyway: opened the brand-search dropdown, typed "Disney Channel", clicked the exact-match "Disney Channel" result from the typeahead list (not a "Disney Channel - Canada"/"- Japan"/etc. variant).
3. Opened the channel selector (`[data-ui-name="channel_selector"]`), inspected icon ordering, clicked the YouTube icon (`.channel-ghost.youtube`), clicked Apply.
4. Waited for tiles to render (~8s) and read tile titles, controls, and DOM structure via `browser_evaluate`.
5. Opened the Best Performing Content (BPC) Sort By dropdown, read its options, selected "Comments".
6. Re-inspected BPC post cards for the highlighted metric.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3a | YouTube icon between Cross-channels and LinkedIn, separator present | DOM order: `facebook, twitter, instagram, tiktok` (cross-channel, enabled) → `.chan-separator` → `youtube, linkedin, threads, pinterest, wikipedia, rottentomatoes, imdb, metacritic` (single-channel, disabled until account has that channel). YouTube is the first icon after the separator, immediately before LinkedIn | ✅ PASS |
| A2 | 3b | Graph-type + Save-to-Dashboard on all big-number tiles except Total Subscribers (Save-to-Dashboard only) | Verified via DOM scan of all `.tile.al-tile` nodes: Total Subscribers → `hasGraphDropdown:false, hasSaveDash:true`; New Subscribers/New Posts/Likes/Comments/Video Views → `hasGraphDropdown:true, hasSaveDash:true` for all 5 | ✅ PASS |
| A3 | 3c | Row 1: Total Subscribers, New Subscribers, New Posts | Tile titles in DOM order: `Total Subscribers: 11.3M (–)`, `New Subscribers: 0 (–)`, `New Posts: 15 (+25%)` | ✅ PASS |
| A4 | 3d | Row 2: Likes, Comments | `Likes: 7,751 (-40%)`, `Comments: 0 (–)` | ✅ PASS |
| A5 | 3e | Row 3: Video Views; last row: BPC | `Video Views: 370K (-31%)` then `Best Performing Content (Lifetime)` | ✅ PASS |
| A6 | 3f | Export NOT on any big-number tile | All 6 big-number tiles → `hasExport:false`. (BPC itself — not a big-number tile — does have Export, which is expected/out of scope for this assertion) | ✅ PASS |
| A7 | 4a | Sort By options: Video Views, Likes, Comments | Dropdown options (de-duplicating the current-selection echo): `Video Views, Likes, Comments` | ✅ PASS |
| A8 | 4b | Default Sort By = Video Views | `.lfm-dropdown-current` showed `title="Video Views"` before any interaction | ✅ PASS |
| A9 | 5 | `Comments` highlighted yellow on every BPC post | Every BPC card's `.metric-value.sort-metric.youtube.video.comments` renders `background-color: rgb(255, 232, 115)` (yellow) after selecting Comments sort | ✅ PASS |

## Evidence

- Tile DOM dump (title / graph-dropdown / export / save-to-dashboard) captured via `browser_evaluate`, verbatim in the assistant transcript for this run.
- Channel-selector HTML snippet confirming icon order and the `.chan-separator` divider.
- BPC sort-dropdown options list: `["Video Views", "Video Views", "Likes", "Comments"]` (first entry is the pre-selected echo in the closed-state `.lfm-dropdown-current`).
- Screenshot capture failed twice with the known `waiting for fonts to load` Playwright-MCP timeout (documented cross-cutting finding, 2026-07-08 session) — DOM-level assertions substituted per that precedent; no visual regression risk since every assertion here is textual/structural, not purely visual.

## Result: ✅ PASS (9/9 assertions)

## Bugs filed

None.

## Cleanup

Not applicable — read-only test (channel selection + sort preference are session-local UI state, not persisted mutations). No account/brand state needs reverting since Disney Channel + YouTube view are neutral defaults for this account.
