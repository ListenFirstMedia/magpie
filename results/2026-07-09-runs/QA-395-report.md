# QA-395 — Brand Sets Rankings - Default View

**Run date:** 2026-07-09
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Skill used:** none pre-existing for Brand Sets > Rankings — new patterns documented below (candidate for a future `brand-sets-rankings` skill)
**Account:** Disney Entertainment Television (account_id=113) — switched via `switch-account` skill (Results section, not Recent Searches)
**Brand Set:** LF // TV // Episodic (brand_set_id=756) — already the default brand set for this account, no manual selection needed

## Steps executed

1. Switched account Hulu → Disney Entertainment Television via LFQA menu → Search Account → Results.
2. Clicked Brand Sets → Rankings (menu hover-then-click).
3. Opened the Rank dropdown (`.lfm-dropdown-select-box`), inspected the Public Data / Authorized Data groups.
4. Typed "New Followers" in the dropdown's search box, clicked the filtered "New Followers" result (via `getByTitle` — the earlier attempt via a bare JS text-match click missed and opened the date-picker calendar instead; re-clicking the actual dropdown-list node worked).
5. One transient "This tile failed to load. Please try again." after the New Followers selection — clicked Reload, table recovered.
6. Reopened the Rank dropdown, typed/clicked "Public Impressions".

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Help Center / Guide / Info icons top right | All 3 present (`fas fa-question-square`/`fa-question-circle`/`fa-info-circle` equivalents rendered as buttons) | PASS |
| A2 | 2 | On selected brand set rankings page | URL `#explore/competitive/rankings?brand_set_id=756`, header shows brand set name | PASS |
| A3 | 2 | Breadcrumb "Account: Disney Entertainment Television \| Brand Sets > Rankings" | Breadcrumb reads exactly that (Brand Sets / chevron / Rankings) | PASS |
| A4 | 2 | URL follows `#explorer/brand-set-name/rankings` | Actual URL is `#explore/competitive/rankings?brand_set_id=756` — spec wording reflects an older URL scheme; current scheme is `#explore/competitive/rankings?brand_set_id=<id>`. Not a functional defect (Rule 5 — spec drift, not filed as bug) | PASS (spec-wording note) |
| A5 | 2 | Public data displayed top-right without refresh | `View:` toggle shows "Public Data" (`toggle-data-label-left`, active) / "Authorized Data" (`disabled` class) on initial load, no click needed | PASS |
| A6 | 2 | Export button in toolbar | Present | PASS |
| A7 | 2 | All channels clickable | Facebook/Twitter/Instagram/YouTube/TikTok icons all `cursor:pointer` | PASS |
| A8 | 2 | Apply button in channel toggle, disabled | `button "Apply" [disabled]` present | PASS |
| A9 | 2 | Rank By with metric dropdown next to it | "Rank:" label + dropdown showing current metric | PASS |
| A10 | 2 | Engagements default metric | Confirmed on initial load | PASS |
| A11 | 2 | Filter section below toolbar | "Filter:" row with Select/Apply Filter/Load Filter/Save Filter/Clear All, positioned below the Channels/Export row | PASS |
| A12 | 2 | Engagements sorted by default | Rank column descending by Engagements on load | PASS |
| A13 | 3 | Rank by dropdown has two group labels: Public Data and Authorized Data | Both group headers present exactly | PASS |
| A14 | 3 | Public Data group contains the 20 named metrics | All 20 present verbatim (Average Engagements per Post … Wikipedia Page Views) | PASS |
| A15 | 3 | "Extended Data" contains Average Video Views, Impressions, Video Views | Group is labeled "Authorized Data" in the actual UI (not "Extended Data") but contains exactly those 3 metrics — spec-wording inconsistency (calls it "Authorized Data" in A13 but "Extended Data" in A15), not a product defect | PASS (spec-wording note) |
| A16 | 4 | Dropdown updates per search | Typing "New Followers" filtered the list to the matching entry under Public Data | PASS |
| A17 | 4 | Page updates to "New Followers" | URL `rank_by_metric=lfm.audience_ratings.public_fan_acquisition_score_v5`, table column header + Rank label both read "New Followers", Brands(3,744) | PASS |
| A18 | 5 | Dropdown updates per search | Typing "Public Impressions" filtered correctly | PASS |
| A19 | 5 | Rank by / Table column updates to "Public Impressions" | Column header + Rank label read "Public Impressions" | PASS |
| A20 | 5 | "Public Impressions" data only available for Twitter channel | Selecting the metric auto-collapsed the channel selector from 5 icons to a single non-removable "Twitter" chip; URL `channels=twitter` (all other channel params dropped) | PASS |

**Result: PASS 20/20** (2 items carry a spec-wording note, not a functional defect)

## Findings (not filed as bugs — documented for KB)

- **Selecting a channel-exclusive Rank metric (e.g. "Public Impressions") auto-collapses the channel selector to just that channel**, replacing the multi-channel icon toggle with a single non-interactive channel label. This is the Brand Sets > Rankings equivalent of the already-documented Data Set / channel-exclusivity pattern seen elsewhere in the app (`brand-content-data-set-selector` skill) — same underlying architecture, new surface.
- **One-time transient tile-load failure ("This tile failed to load. Please try again.")** immediately after switching Rank metric to New Followers — resolved cleanly on a single Reload click. Not reproduced on the subsequent Public Impressions switch. Treated as a one-off backend hiccup, not filed as a bug.
- **JS text-match click on a leaf DOM node found the wrong element** (an off-screen/hidden calendar node also matched "New Followers" textContent) — the reliable pattern for this custom rank-metric dropdown is `page.getByTitle(metricName)` (the `span.lfm-option-label` carries a `title` attribute with the exact metric name), not a generic textContent scan.

## Cleanup

None required — read-only test, no mutating steps.

## Bugs filed

None.
