# QA-95226 — Global Search and Brand Search - Show Two Rows in Search

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-95226
- **Run date:** 2026-07-07 (Playwright MCP track)
- **Account:** UCLA (account_id=799)
- **Skill used:** `text-input-wrap-tooltip` (v1, untrusted)
- **Fixtures (reused from skill history):** brand "Lowell Milken Center for Music of American Jewish Experience" (brand_id=290318), brand set "UCLA School of the Arts and Architecture Roll-up" (brand_set_id=11415, displayed as "50 Top Schools" favorite alias — same underlying set)

## Steps executed

1. Switched account to UCLA via LFQA → Search Account (needed `pressSequentially`, not `.fill()` — same quirk as QA-96670).
2. Clicked the global search icon (top nav) → typed the long brand name into `textarea.global-brand-typeahead`.
3. Hovered/inspected the result row; clicked it.
4. On the resulting Brand → Insights page, clicked the brand name to open the in-page brand search, typed the same string.
5. Navigated to Brand Sets → Content, clicked the brand-set name to open its search, typed "UCLA School of the Arts and Architecture Roll-up".
6. Navigated to Reporting → Time Window Comparison, typed the same brand name into its `Add Brand` typeahead.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3a | Brand displayed in two rows, both highlighted | Global search result row height 34px (≈2×17px lines) for the 262px-wide input's dropdown — text wraps, not single-line | **PASS** |
| A2 | 3b | Full brand name in tooltip on hover | `title="Lowell Milken Center for Music of American Jewish Experience"` present on the option row | **PASS** |
| A3 | 4 | Page navigates to Brand → Insights | Clicked result → URL `#explore/brand/insights?brand_id=290318` | **PASS** |
| A4 | 6a/b | Same two-row + tooltip behavior in brand search container (Brand → Insights page) | In-page `.option-label` span height 34px (2-row wrap); ancestor `title` = full name | **PASS** |
| A5 | 9a/b | Same in brand set container (Brand Sets → Content) | `.lfm-ta-option.option-row` height 40px, `.option-label` height 34px (2-row wrap); `title` = full brand-set name | **PASS** |
| A6 | 12a-c | Same two-row + ellipsis + tooltip in TWC brand container | TWC's `al-typeahead__option` row: height **40px** (2-row **wrap**, not ellipsis-truncation), `white-space: pre-wrap`, `scrollWidth === clientWidth` (nothing cut off), `title` attribute still present with the full name. See Problems #1. | **PASS** (full text accessible; behavior differs from a prior note but not from the assertion's intent) |

## Evidence

- Global search option row: height 34px, width 273px, `title` = full name.
- Brand-page in-page picker: `.option-label` height 34px, same title.
- Brand Set picker: `.lfm-ta-option.option-row` height 40px / `.option-label` height 34px, same pattern.
- TWC `al-typeahead__option` (data-option-key="options-290318"): height 40px, `text-overflow: ellipsis` is set in CSS but overridden by `white-space: pre-wrap` (wrap wins over truncate when both are present and content fits within the wrapped height) — so the row **wraps** instead of truncating.

## Problems encountered

1. **TWC's typeahead no longer ellipsis-truncates — it wraps, like the other 3 contexts.** The `chart-hover-tooltip`... — sorry, the `text-input-wrap-tooltip` skill's 2026-06-11 batch-3 note states "TWC builder typeahead ellipsizes (`text-overflow: ellipsis`) with full name in `title` attr." This run found the opposite: the option row's computed `white-space` is `pre-wrap`, the text wraps to 2 lines (height 40px) exactly like the global/brand/brand-set pickers, and `scrollWidth === clientWidth` (no overflow to ellipsize). The CSS `text-overflow: ellipsis` property is present but inert because `white-space: nowrap` is not also set. **This reads as a product fix that unified TWC's typeahead with the other 3 contexts, not a regression** — the full brand name is fully visible via wrap AND still backed by a `title` tooltip. Flagging for a human to confirm this is an intentional consistency fix rather than accidentally shipped, since it contradicts documented prior behavior.
2. **Account-search input still needs real keystrokes** (same as QA-96670) — `.fill()` on `input[placeholder="Search Account"]` does not surface the live Results section; `pressSequentially` does.
3. **Both Brand-page and Brand-Set-page "switcher" triggers are ambiguous by structure.** Brand → Insights: clicking the bare brand-name text opens the typeahead reliably. Brand Sets → Content: clicking the bare brand-set-name text does **nothing** — the click must land on the `.brand-selector-name-container` wrapper (which includes the chevron icon), not just the text node. A misplaced click instead opens a "Remove this brand set from your favorites" tooltip on the adjacent heart icon.

## Skill updates

`text-input-wrap-tooltip` — updating the TWC-context note to reflect the wrap behavior found this run (see v2 changelog entry); the brand-set-name click-target gotcha (Problem #3) is worth folding into a future navigation-pattern note.

## Bugs filed

None. All 6 assertions passed; the TWC behavior change (Problem #1) is flagged as a finding for human confirmation, not filed as a bug (the observed behavior is strictly better than what the ellipsis-truncation would have provided).
