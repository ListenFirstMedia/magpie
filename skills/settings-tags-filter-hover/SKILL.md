---
name: settings-tags-filter-hover
version: 1
last_verified: 2026-07-09
last_passed_run: 2026-07-09
trust: untrusted
pass_streak: 1
preconditions: [user-logged-in]
postconditions: [tag-content-list-rendered]
inputs: [tag_name]
outputs: [filtered_content_rows]
related_pages: ["/#tags", "/#tags/content"]
---

# Settings > Tags — Filter dropdown, hover tooltips, and tag-content drill-through

Covers Settings → Tags: the two-level Filter dropdown (category picker → tag-value
checklist), row-level hover tooltips (post text, tag names), lazy-load pagination on the
Tag-content sub-page, and brand-link navigation out to Brand > Content.

## Key structural quirk — the Filter widget is TWO separate floating panels

Clicking "Filter:" → "Select" opens a small category dropdown (`.tag-filter-dropdown`) with
4 options: `ListenFirst Created`, `Tag`, `Tag Created Date`, `Tag Creator`
(`data-ui-name="tag_manager.<x>_filter"`). Clicking **Tag** does NOT nest a submenu inside
that same dropdown — it opens a **second, independently-positioned** panel,
`.filter__options-container` (absolute-positioned via inline `left`/`margin-top`, NOT a DOM
child of the first dropdown), containing:
- its own search `textarea` (`.filter__options-container .search-box textarea`)
- Or/And radio buttons (`#radio-or` / `#radio-and`)
- a virtualized checkbox list of every tag (`.filter__option__row[title="<tag>"]`, each with
  a `.check-box-container i` that toggles `far fa-square` ↔ `far fa-check-square`)

**Do not `browser_snapshot` the whole page or the `.filter__options-container` root while
this list is open** — the virtualized list can be many thousands of rows and blows the
snapshot token limit. Query specific rows via `browser_evaluate` /
`querySelector('.filter__option__row[title="<exact-tag>"]')` instead.

**React-controlled search box gotcha:** do not set `.value` + dispatch a manual `input`
event on the search `<textarea>` — it desyncs from React state and the options list goes
permanently empty. Always drive it via `browser_type` (`pressSequentially`), never raw DOM
mutation.

## Steps

### Step 1 — Open Filter dropdown, select Tag category
- Navigate: `https://app.lfmdev.in/#tags?account_id={account_id}`
- Dismiss the ListenFirst Status alert iframe if present (click its close `<button>`,
  otherwise it intercepts clicks — recurring cross-skill quirk).
- Click `.tag-filter-dropdown` trigger (label "Select") → click
  `[data-ui-name="tag_manager.tag_filter"]` (the "Tag" option).
- **Assertion:** `.filter__options-container` appears in the DOM with a populated
  `.filter__option__row` list.

### Step 2 — Search and select a tag value
- Type into `.filter__options-container .search-box textarea` via `pressSequentially`.
- **Assertion:** `.filter__option__row` count narrows to matches containing the typed
  substring (case-insensitive).
- Click `.filter__option__row[title="<exact tag>"] .check-box-container` to check it.
- **Assertion:** the row's `i` class flips to `far fa-check-square`.

### Step 3 — Apply Filter
- Click `.apply-filter-button`.
- **Assertion:** URL gains a `filters=` param (JSON-encoded, double URL-encoded) with
  `filter_tags: [{values:["<tag>"], operator:"or"}]`; the Tags list narrows to only rows
  matching that tag.

### Step 4 — Drill into tag content
- Click the tag name link (`a[href*="#tags/content?tag=<tag>"]`).
- **Assertion:** URL → `#tags/content?tag=<tag>`; header shows `Tag: <tag>` and
  `Posts (<N>)` count.

### Step 5 — Hover tooltips (post text / tag names)
- Row structure: `.content-row` → `.text-cell[title="<full post text>"]`,
  `.tag-cell .sample-tags[title="<comma-joined tags>"]` +
  overflow `.rest-tags[title="..."]` (shows `,+N` when more tags exist than fit).
- **Assertion:** the `title` attribute is the full untruncated string — this IS the
  tooltip (native browser title tooltip), matching the `text-input-wrap-tooltip` family of
  patterns elsewhere in the app. DOM-level `title` inspection is sufficient evidence per
  Rule 6's screenshot-not-strictly-required carveout (precise DOM read available).

### Step 6 — Scroll-triggered lazy load
- Scroll `.table__body` (the virtualized rows container) near its `scrollHeight`.
- **Assertion:** `scrollHeight` grows by ~8000px per batch (200 rows × 40px row height) —
  confirms a 200-row lazy-load fired. Compare before/after `scrollHeight`, not row count
  (only ~17-20 rows are ever mounted at once due to windowing).

### Step 7 — Brand link navigation
- Click `.content-row .brand-name` (an `<a href="#explore/brand/content?brand_id=...">`).
- **Assertion:** navigates to Brand > Content for that brand; header
  `.brand-selector-name-container` shows the brand name.
- Opening the brand-search widget there (`.brand-selector-name-container` click →
  `.brand-selector-dropdown-container`) shows the **standard global "Recent Searches"
  list** (this session's 5 most-recently-viewed brands), NOT restricted to only the
  clicked-through brand. See known-quirks / QA-63553 report for the open question on
  whether spec intent was a locked/scoped widget — flagged for human review, not filed as
  a bug.

## Failure signatures

| Signature | Interpretation | Action |
|-----------|-----------------|--------|
| `.filter__options-container` never appears after clicking a category | Category-select click didn't register (hover-vs-click state) | retry with a real `browser_click` on the option ref, not a coordinate/title-locator hover |
| Search textarea typed text but options-container goes empty and stays empty | React-controlled input desync (see gotcha above) | reload the page, redo via `browser_type` only |
| `scrollHeight` unchanged after scrolling near bottom | Lazy-load didn't fire — possible regression | re-scroll after a short wait; if still unchanged, treat as a bug candidate |
| Brand-search dropdown after tag-drill-through shows only the clicked brand | Actually matches spec A6 as literally stated | do NOT treat as unexpected — this would be the spec-compliant case |

## Changelog
- **v1** (2026-07-09): initial draft from QA-63553. Two-panel Filter widget structure,
  React-controlled search-box gotcha, hover-tooltip title-attribute pattern, scroll lazy-load
  byte-math, and the brand-dropdown-scope ambiguity all documented.
