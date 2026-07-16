# QA-63553 — Settings > Tags > Content Tagged - Hovering and Switching tabs

**Run date:** 2026-07-09
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54)
**Skill authored:** [settings-tags-filter-hover](../../skills/settings-tags-filter-hover/SKILL.md) (NEW)

## Steps executed

1. Navigated to `#tags?account_id=54` (Settings → Tags).
2. Dismissed the ListenFirst Status alert iframe (click-blocker workaround, known quirk).
3. Clicked the "Filter:" dropdown trigger → clicked the "Tag" category option (`data-ui-name="tag_manager.tag_filter"`). This reveals a **second, separately-positioned** `.filter__options-container` panel (absolutely positioned, not nested in the first dropdown's accessible-tree branch) with its own search box, Or/And radio, and a virtualized checkbox list of every tag.
4. Hovered a long tag name with ellipsis (`helloo nba instagram`, `.filter__option__row[title=...]`) — confirmed via DOM that `title` attribute carries the full un-truncated text (native browser tooltip pattern, consistent with `text-input-wrap-tooltip` skill).
5. Typed `nba` in the tag-value search box (`pressSequentially`) — list filtered to 13 matches (`nba`, `nba2`, `nba3`, `nbahghg`, `nba syn`, `nba sync 1-4`, `funba`, `hello nba`, `helloo nba instagram`, `the nba side`).
6. Checked the exact-match `nba` row's checkbox (confirmed `fa-check-square` after click).
7. Clicked **Apply Filter** — URL updated to `filters=%7B%22filter_tags%22%3A...%22nba%22...%7D`.
8. Clicked the `nba` tag link → navigated to `#tags/content?tag=nba` (Tag: nba, Posts (519)).
9. Hovered a post's Text cell and a Tag Name cell — confirmed both carry full-text `title` attributes matching the visible (untruncated) content exactly.
10. Scrolled the virtualized `.table__body` list to its current bottom.
11. Clicked the Brand name link (`NBA`, brand_id=7911) on the first content row.
12. On the resulting Brand>Content page, opened the brand-search dropdown (`.brand-selector-name-container`) to inspect its contents.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6 | Selected tag data displays | After Apply Filter, the Tags list showed exactly one row: `nba` (previously many rows) | ✅ PASS |
| A2 | 8 | Tooltip shows full post text | `.text-cell[title="..."]` exact match to visible/rendered text — DOM-level tooltip source confirmed | ✅ PASS |
| A3 | 9 | Tooltip shows tag names | `.tag-cell .sample-tags[title="nba, qa_new 789 12/10/55/16"]` — full tag list in title, overflow `+1` in a second `.rest-tags[title=...]` span | ✅ PASS |
| A4 | 10 | 200 more posts load on scroll | Virtualized list `scrollHeight` grew from `8000px` → `16000px` after scrolling near the bottom (200 rows × 40px = 8000px per batch) — confirms a 200-row lazy-load batch fired | ✅ PASS |
| A5 | 11a | Navigates to Brand Content Page | URL → `#explore/brand/content?brand_id=7911...`, page title "Brand Content - ListenFirst: Brand Content" | ✅ PASS |
| A6 | 11b | Only selected brand in brand dropdown | Opening the page's brand-search widget (`.brand-selector-dropdown-container`) shows the **standard global "Recent Searches" list**: NBA, MTV, Disney Channel, Star Wars, Michael Kors — 5 entries, not restricted to NBA alone | ⚠️ NOT AS SPECIFIED (see note) |

## A6 — note, not filed as a bug

Per Rule 5 (re-read the spec before flagging a bug), the assertion text "Only selected brand in brand dropdown" is ambiguous: it's unclear whether the spec means (a) the page-level brand-search-typeahead should be locked/restricted when reached via a tag's brand link, or (b) some other "brand dropdown" (e.g., top-nav Brand menu) is meant. What was actually observed is the same global brand-search component used everywhere in the app (search box + Recent Searches), pre-populated with this session's 5 most-recently-viewed brands (NBA, MTV, Disney Channel, Star Wars, Michael Kors) — fully able to switch brands. This is standard, expected behavior for the shared component, not obviously a defect. Flagging for human clarification rather than filing a bug, since a wrong-brand-substitution or wrong-widget misread would repeat the BC-3 anti-pattern.

## Evidence

- Screenshot: `qa63553-tag-tooltip-hover.png` (long tag name hover in filter dropdown)
- Screenshot: `qa63553-post-text-hover.png` (post-text hover on Tag: nba content page)
- Screenshot: `qa63553-brand-dropdown.png` (brand-search dropdown with Recent Searches after brand-name click-through)

## Result: ✅ 5/6 PASS, 1 flagged for clarification (A6)

## Bugs filed

None — A6 documented as ambiguous/needs-human-review, not a confirmed defect.

## Cleanup

Not applicable — read-only test, no mutations performed (filter selection reverted automatically on next navigation; no persistent state changed).
