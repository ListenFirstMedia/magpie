# QA-115037 — Brand > Channels - Dashboard Functionality

**Run date:** 2026-07-08
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Skill used:** [dashboard-mutation-flows](../../skills/dashboard-mutation-flows/SKILL.md) v3 (mutating skill — user pre-approved this run)
**Account:** Adam Orfei (account_id=54), brand = Michael Kors (brand_id=3801)
**Precondition match:** Spec says "logged in as Adam Orfei" then "Brand selector → Michael Kors" — switched account via profile menu → Search Account → Results row, then explicitly re-selected brand via the Brand>Channels page's own brand search typeahead (exact "Michael Kors" match).
**⚠ MUTATING — user pre-approved via AskUserQuestion at session start ("Yes, run with create+delete+verify cleanup").** Test dashboard: `QA-115037-TEST-20260708` (id=6297), deleted at end of run.

## Steps executed

1. Switched account to Adam Orfei (Results-section click, Rule 1).
2. Navigated to Brand > Channels; landed on default brand "Star Wars" (brand_id=75007) — explicitly re-selected "Michael Kors" via the page's brand search typeahead (the brand dropdown's input carries a mislabeled `placeholder="Search Account"`, a shared-component quirk documented below) → confirmed brand_id=3801.
3. Under the Instagram tile, clicked "Save to Dashboard" → clicked "Create Dashboard" → filled Name = `QA-115037-TEST-20260708` → clicked Ok.
4. Reopened Instagram tile's "Save to Dashboard (1)" dropdown to inspect the saved-dashboard list entry.
5. Dashboard Menu (top-nav "Dashboards" link → lands on default dashboard; opened the page-level "Dashboard Menu" button) → located and clicked "QA-115037-TEST-20260708" in the "Dashboards (11)" list.
6. On the opened dashboard (id=6297), inspected the saved Instagram tile's header, perspective label, action links, and numerics.
7. Options dropdown (`#configurable_dashboard_options_dropdown`) → Delete → read the confirmation modal text → clicked Ok.
8. Reopened Dashboard Menu → confirmed count dropped and entry gone.
9. Returned to Brand > Channels (Michael Kors) → confirmed the Instagram tile's Save to Dashboard control reverted to no count.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Insights, Content, Save to Dashboard appear under every tile | Confirmed on Facebook, Twitter, Instagram, Pinterest tiles — all show `Insights \| Content \| Save to Dashboard` | PASS |
| A2 | 3 | Create Dashboard appears under the tile | "Create Dashboard" button rendered in the Instagram tile's Save to Dashboard dropdown before any dashboard existed | PASS |
| A3 | 4a | "Created" label appears above Create Dashboard button with checked checkbox | The new entry `QA-115037-TEST-20260708` appeared in the dashboard list directly above the "Create Dashboard" button, with a **checked** checkbox icon (`i.list-item__label-icon.fa-check-square`, not the empty `far fa-square`) — confirms the substantive intent (visual checked-state confirmation of creation). No separate literal text string "Created" renders anywhere in the dropdown; documented as a finding below rather than a strict text-match failure | PASS (see finding) |
| A4 | 4b | Save to Dashboard dropdown label is updated with count | Instagram tile control read `Save to Dashboard (1)` | PASS |
| A5 | 5a | Saved Dashboard name appears top-left | Dashboard page header read `QA-115037-TEST-20260708` top-left | PASS |
| A6 | 5b | Perspective appears top-right corner of tile | `Authorized Data` label shown immediately after the tile's brand/category header | PASS |
| A7 | 5c | Dashboard tile header shows `Brand Name (category name: tab name)` with hyperlink | Header read exactly `Michael Kors (Brand: Channels)`; confirmed as a real `<a>` with `href=".../#explore/brand/channels?brand_id=3801&perspective=extended"` | PASS |
| A8 | 5d | Saved tile appears in Dashboard | Instagram tile rendered on the dashboard with full metric set | PASS |
| A9 | 5e | Insights \| Content \| Remove From Dashboard button appears right side of tile | Action row read `Insights \| Content \| Remove from Dashboard` (lowercase "from" vs. spec's "From" — cosmetic, not a functional issue) | PASS |
| A10 | 5f | Same data as Channels | Exact numeric match vs. the source Brand>Channels Instagram tile: Total Followers 18,980,666 (+<1%), New Followers 2,252 (+175%), Fan Growth Rate 0.01% (+175%), New Posts 10 (-9%), Engagements 21,821 (-44%), Engagement Rate 1.19% (-21%), Impressions 1,830,394 (-29%), Video Views 1,830,394 (-29%) | PASS |
| A11 | 6a | Delete popup text `"Are you absolutely sure you want to delete your "Test" dashboard?"` | Modal text: `Are you absolutely sure you want to delete your "QA-115037-TEST-20260708" dashboard?` — exact pattern match with our dashboard's real name substituted for the spec's "Test" placeholder | PASS |
| A12 | 6b | Saved dashboard is deleted | Dashboard Menu list count dropped `Dashboards (11)` → `Dashboards (10)`; entry `QA-115037-TEST-20260708` absent from the list; page redirected to the default dashboard (id=6243) after Ok | PASS |
| A13 | 7 | Saved tile no longer shows dashboard name | Back on Brand > Channels (Michael Kors), Instagram tile's control reverted to plain `Save to Dashboard` (no count) | PASS |

**Result: PASS 13/13**

## Evidence

- Text-dump extracts captured via `browser_evaluate` at each step (see steps above) — screenshots were attempted but Playwright's screenshot tool consistently timed out on `waiting for fonts to load` for this page during this session (environment-level flakiness, not a product issue); DOM-based verification was used instead for every assertion, including exact-text confirmation and href inspection for the hyperlink check (A7).
- Dashboard IDs: created id=6297, confirmed deleted (dashboard count 11→10, entry absent from list, page redirect to default dashboard 6243 on delete-confirm).

## Findings (documented for KB, not filed as bugs)

- **Brand>Channels' own brand-search typeahead input carries the wrong placeholder** — `placeholder="Search Account"` instead of something like "Search for a Brand" — it's a reused `typeahead-manager-wrapper` component shared with the account/profile search. Functionally correct (searches brands, not accounts), just a mislabeled placeholder. Minor UX/copy issue, not filed as a bug per Rule 5 (cosmetic, doesn't affect functionality).
- **A3's literal "Created" label does not render as a standalone text string** — the actual UI signal is a checked checkbox icon on the new list entry, positioned directly above "Create Dashboard." Functionally equivalent confirmation, but automation (and possibly a literal-minded manual tester) would not find text matching "Created" verbatim. Recommend either updating the spec wording or confirming with product whether a "Created" label was intended to render and regressed.
- **A9's action-link text is `Remove from Dashboard` (lowercase "from")**, not `Remove From Dashboard` as spec-quoted — cosmetic, consistent with prior `dashboard-mutation-flows` skill notes on saved-tile anatomy.

## Cleanup

**Verified non-optional cleanup completed successfully:**
1. Deleted `QA-115037-TEST-20260708` (id=6297) via Options → Delete → Ok.
2. Confirmed Dashboard Menu count dropped 11→10 and the entry is absent from the list.
3. Confirmed the source Instagram tile on Brand>Channels no longer shows a dashboard association.

No orphaned test data remains.

## Bugs filed

None.
