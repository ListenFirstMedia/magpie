---
name: brand-insights-channel-selector-bpc-sort
version: 1
last_verified: 2026-07-09
last_passed_run: 2026-07-09
trust: untrusted
pass_streak: 1
preconditions: [user-logged-in, brand-selected]
postconditions: [channel-filter-applied]
inputs: [channel_name]
outputs: [tile_layout, bpc_sort_state]
related_pages: ["/#explore/brand/insights"]
---

# Brand > Insights — Channel selector layout + Best Performing Content Sort By

Covers the Brand > Insights "Basic View": the channel-icon selector's structural layout
(cross-channel vs per-channel icons), which big-number tiles carry which controls, and the
Best Performing Content (BPC) tile's Sort By dropdown + yellow metric-highlight behavior.

## Steps

### Step 1 — Select a single channel
- Open `[data-ui-name="channel_selector"]`.
- **Layout invariant:** icons render in two groups separated by `.chan-separator`:
  - **Cross-channel group** (order: Facebook, Twitter, Instagram, TikTok) — these support
    multi-select (additive `.channel-ghost.enabled` state).
  - **Per-channel-only group** (order: YouTube, LinkedIn, Threads, Pinterest, Wikipedia,
    Rotten Tomatoes, IMDb, Metacritic) — clicking one of these auto-clears the cross-channel
    multi-select (single-channel-only views).
- Click `.channel-ghost.<channel>` for the target channel, then
  `[data-ui-name="channel_selector_apply_cta"]`.
- **Assertion:** URL `channels=` param collapses to exactly the one selected channel.

### Step 2 — Big-number tile control audit
- Tile container: `.tile.al-tile` (title lives at `.tile__title-bar .title` / `h4.title`,
  format `"<Metric>: <value> (<change>)"`, en-dash `–` for no-change/no-data).
- Per-tile controls to check:
  - Graph-type dropdown: `[data-ui-name="tile_data_visualization"]`
  - Save-to-Dashboard: `[data-ui-name*="save_to_dashboard"]` (or similar `save`-prefixed
    `data-ui-name` / class)
  - Export: `[class*="export-button"]` / `[data-ui-name*="export"]`
- **Known layout (Basic View, 6 big-number tiles + BPC):**

  | Tile | Graph dropdown | Save-to-Dashboard | Export |
  |------|----------------|--------------------|--------|
  | Total Subscribers | ❌ | ✅ | ❌ |
  | New Subscribers | ✅ | ✅ | ❌ |
  | New Posts | ✅ | ✅ | ❌ |
  | Likes | ✅ | ✅ | ❌ |
  | Comments | ✅ | ✅ | ❌ |
  | Video Views | ✅ | ✅ | ❌ |
  | Best Performing Content | ❌ | ✅ | ✅ |

  Total Subscribers is the sole big-number tile without a graph-type switcher (nothing to
  chart — it's a point-in-time count, not a delta series). BPC is not a big-number tile and
  is expected to have Export.

### Step 3 — BPC Sort By
- Dropdown: `.sort-dropdown .lfm-dropdown-select-box` (current value at
  `.lfm-dropdown-current [title]`).
- Default on load: **Video Views**.
- Options (channel-dependent — YouTube shown): `Video Views`, `Likes`, `Comments`.
- Click an option → `.lfm-dropdown-option` matching its exact text via
  `.locator('text="<option>"')` (avoid ambiguous partial-text matches — the closed dropdown
  echoes the current selection as a duplicate first option in the open list).
- **Assertion:** every BPC post card's corresponding metric cell —
  `.metric-value.sort-metric.<channel>.video.<metric>` (e.g.
  `.metric-value.sort-metric.youtube.video.comments`) — gets `background-color:
  rgb(255, 232, 115)` (yellow highlight) once that metric becomes the active sort.

## Failure signatures

| Signature | Interpretation | Action |
|-----------|-----------------|--------|
| Total Subscribers tile gains a graph dropdown | Spec drift / UI change | re-verify against current spec before filing — could be an intentional feature add |
| Any big-number tile shows Export | Regression against this documented layout | file bug |
| BPC highlight color isn't `rgb(255, 232, 115)` | Theme/design change, not necessarily a bug | screenshot + note the actual color, ask before filing |
| `browser_take_screenshot` times out with "waiting for fonts to load" | Known Playwright-MCP artifact (2026-07-08+) | substitute DOM-level `browser_evaluate` assertions; do not block the run on it |

## Changelog
- **v1** (2026-07-09): initial draft from QA-5503 (Disney Channel, YouTube). Channel-selector
  two-group layout, full big-number-tile control matrix, BPC Sort By default + yellow
  highlight color documented.
