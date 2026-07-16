---
name: brand-content-filter
version: 3
last_verified: 2026-07-10
last_passed_run: 2026-07-10
trust: untrusted
pass_streak: 27
preconditions: [brand-content-loaded]
postconditions: [filter-applied]
inputs: [filter_type, filter_value, operator]
outputs: [filtered_post_count]
related_pages: ["/#explore/brand/content", "/#explore/brand/stories", "/#explore/brand/paid", "/#explore/brand/partnerships", "/#explore/brand/optimization", "/#explore/competitive/content", "/#explore/competitive/partnerships"]
---

# Brand Content Filter Dropdown

Generic skill for applying any of the 13+ filter types on Brand → Content via the Filter dropdown.

Used by:
- **QA-91412** — Publish Type = Reel
- **QA-121304** — Collaborator Name = `amazonmgmstudios`
- **QA-533** — Text Search (long-text tooltip case, related)
- Any test that filters Brand Content posts.

## Filter types (from the dropdown)

`Branded Content`, `Collaborated`, `Content Type`, `Live Stream`, `Paid`, `Publish Day`, `Publish Time`, `Publish Type`, `Sponsor Name`, `Tag`, `Text Search`. (Some accounts add more depending on data setup.)

Each filter has a sub-dropdown with `Or` / `And` operator radios at the bottom.

## Steps

### Step 1 — Open the Filter dropdown
- **Action:** click the `Filter:` dropdown (default state shows `Select`).
- **Selector:** at top of post list, below channels row; has placeholder text `Select`.
- **Coordinate hint:** ~(230, 357) on a typical layout; vary by zoom/window size.
- **Assertion:** dropdown opens showing the 13+ filter type list + a search input at top.

### Step 2 — Select filter type
- **Action:** click the filter-type label (e.g. `Publish Type`).
- **Assertion:** a sub-dropdown opens to the right with: search input, `Or | And` radios, and the list of values for that filter type.

### Step 3 — Choose value
- **Action:** for short value lists, click the checkbox next to the value (e.g. `Reel`).
- **For text search filters** (Sponsor Name, Tag, Text Search, Collaborator Name): type into the sub-dropdown's search field first, then the matching values appear as suggestions.

### Step 4 — Set operator (optional)
- **Default:** `Or` is selected. Click `And` only when filtering on multiple values within the same filter type AND you want them all to match.

### Step 5 — Apply Filter
- **Action:** click `Apply Filter` (located to the right of the Filter dropdown).
- **Selector:** button text `Apply Filter`. Coordinate hint: ~(404, 357).
- **Assertion:** a filter pill renders below the Filter row with: `<FilterType>: <Value(s)>` + a small toggle showing `Include`/`Exclude`. URL updates to include `filters=...` JSON param.

### Step 6 — Verify filtered post-count
- **Action:** read `Posts (N)` count above the post grid.
- **Assertion:** N is ≤ pre-filter count. Posts shown all match the filter criteria.

## Filter URL encoding

The URL `filters` param is a JSON-encoded object. For Publish Type = Reel:

```
filters=%257B%2522content_post_class%2522%253A%257B%2522operator%2522%253A%2522or%2522%252C%2522values%2522%253A%255B%2522reel%2522%255D%252C%2522not%2522%253A%2522false%2522%257D%257D
```

Decoded:
```json
{"content_post_class": {"operator": "or", "values": ["reel"], "not": "false"}}
```

Filter-type → URL key mapping (partial — extend as discovered):

| UI label | URL key |
|---|---|
| Publish Type | `content_post_class` |
| Collaborated | `is_collaborated` |
| Collaborator Name | `collaborator_name` |
| Paid | `is_paid` |
| Live Stream | `is_livestream` |
| Branded Content | `is_branded_content` |
| Sponsor Name | `sponsor_name` |
| Tag | `tag` |
| Text Search | `text_search` |

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| Sub-dropdown values list empty | Filter has no data for current brand/date | Check date range or brand authorization |
| Apply Filter button disabled after selection | Form validation broken | Check console for errors |
| Filter pill renders but Posts count unchanged | Filter not actually applied to backend query | Compare URL — if `filters` not in URL, click was lost |
| Post grid shows "Table failed to load" with filter applied | Backend filter query timeout or bad filter combination | Reload; if persists, file as bug |

## Common gotchas
- The Filter dropdown defaults to `Or` operator — if testing AND-combination, set operator radio BEFORE checking values.
- `Apply Filter` button is enabled only when at least one filter value is checked.
- The pill toggle on `Include`/`Exclude` is a separate concept — set it after applying for "NOT" semantics.

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows; 0 historical defects (all closed) are catalogued there.

## v2 — Layered tag filtering across 7 surfaces (2026-06-08)

The Tag sub-filter is the most complex variant of the Filter widget and appears with identical structure across 7 distinct surfaces. The widget supports layered Include + Exclude pills with OR / AND operators within each pill.

### 7 surfaces verified

| Surface | URL | Filter dropdown options |
|---|---|---|
| Brand > Content | `/#explore/brand/content` | Branded Content / Collaborated / Content Type / ... / Tag / Text Search |
| Brand > Stories | `/#explore/brand/stories` | Branded Content / Collaborated / ... / Tag / Text Search |
| Brand > Paid | `/#explore/brand/paid` | Ad Name / Ads Account ID / Campaign / Delivery Type / Publish Day / Publish Time / Tag / Text Search |
| Brand > Partnerships | `/#explore/brand/partnerships` | Collaborated / Collaborated Total / Collaborator Name / Content Type / Publish Day / Publish Time / Publish Type / Sponsor Name / Tag / Text Search |
| Brand > Optimization | `/#explore/brand/optimization` | (same set as Brand>Content; layered Tag widget identical) |
| Brand Sets > Content | `/#explore/competitive/content` | (layered widget identical) |
| Brand Sets > Partnerships | `/#explore/competitive/partnerships` | (layered widget identical) |

### Layered Include + Exclude — URL JSON encoding

Two-pill state (Include `jbkaxlx` OR + Exclude `+tag`) encodes as:
```
filters={"content_tags":[
  {"operator":"or","values":[" jbkaxlx"],"not":"false"},
  {"operator":"or","values":["+tag"],"not":"true"}
]}
```

### Include-only OR / AND operator flip

Single-pill Include state: green-outline `or-label` chip with `not:"false"`. Pill operator-button flip changes URL operator value:
```
{"content_tags":[{"operator":"or","values":["jbkaxlx","+tag"],"not":"false"}]}
{"content_tags":[{"operator":"and","values":["jbkaxlx","+tag"],"not":"false"}]}
```

### Exclude OR pill CSS

```
or-label exclude     → red background rgb(235, 64, 64)
or-label             → green-outline (Include)
option-row disabled  → greyed (cannot select same tag in both Include + Exclude)
```

### "OR + None backend rejection" quirk

Brand > Content with `Tag = None` + `Operator = OR`:
- UI accepts the combination, URL encodes as `{"content_tags":[{"operator":"or","values":[""],"not":"false"}]}`.
- Backend returns **"Table failed to load"** error pane (the empty-string value + OR-operator combination is rejected server-side).
- Workaround: use `Tag = None` with `Include` only (no OR-merging) — that path encodes `values:[""]` and renders cleanly.

### Save/Load Filter buttons + deep-link re-hydration

Both `Save Filter` and `Load Filter` buttons render alongside `Apply Filter` and `Clear All` on the Filter row. Direct URL nav with the filters JSON re-hydrates the pill with ~10-25s latency.

### CPR Tag Filter divergence (QA-134516)

CPR builder's Tag Filter lacks the Include/Exclude toggle exposed on Brand surfaces — structural divergence flagged. PASS-with-finding rather than a bug.

### Data Studio surface (8th surface, QA-134517) — HAS full Include/Exclude (no CPR-style gap)

Reporting > **Data Studio** (`/#explore/reporting/data_studio`, Post Level) exposes the **full** layered Include/Exclude + Or/And tag filter — it does **NOT** share the CPR divergence. Path: Post Level → add brand via "Search for a Brand" typeahead → filter section **"Filter: Select"** (`.tag-filter-dropdown` `.lfm-dropdown-select-box`) → **Tag** → sub-panel with Include/Exclude radios + Or/And + Select All/None + tag checkbox list.
- **Distinct DOM from Brand surfaces:** DS tag rows use `.filter__option__row` / `.filter__option__label` (NOT `.option-row`); the mutual-exclusivity greyed state is `.filter__option__row--disabled` + `pointer-events:none` (Brand surfaces use `option-row disabled`).
- Applied filter shows as pills "Tag: nikhil" (Include) + "Tag: 000" (Exclude); same `content_tags` JSON state.
- A4 (report data reflects filter) is gated on the DS metric-tree (Select Metrics), which is automation-undrivable — verify the filter state via the pills, cross-ref the metric-tree blocker.

### Tag-filter label differs by surface

The filter-type label is **"Tag"** on Brand > Content / Optimization / Stories, but **"Content Tag"** on **Brand Sets > Content** (`/#explore/competitive/content`). Same sub-panel + `content_tags` encoding; only the dropdown label differs. On Data Studio it is **"Tag"**.

### URL serializes only on Apply Filter

The tag filter writes to the URL `filters` param **only after "Apply Filter" is committed** — in-panel edits (selecting tags, flipping Or/And via the inline `.edit-operator-button.or/.and`, switching Include/Exclude) do NOT update the URL until Apply. "Clear All" removes the `filters` param entirely.

## Additional Failure signatures (v2)

| Signature | Interpretation | Action |
|---|---|---|
| `Tag = None` + OR operator returns "Table failed to load" | Backend rejects empty-string OR-merge | Switch to Include-only (no OR) |
| Pill operator button doesn't flip OR ↔ AND on click | Toggle event-binding regression | File bug |
| Exclude pill background not `rgb(235, 64, 64)` | Color regression | Capture RGB; if persistent, file UI ticket |
| Direct URL nav with `filters` JSON doesn't re-hydrate pill | Deep-link parser regression | File bug; cross-reference settings-audit-logs APPS-54603 |
| CPR Tag Filter shows Include/Exclude toggle | Structural divergence resolved | Update skill + remove this note |

## Changelog
- **v3** (2026-07-10): +8th surface **Data Studio** (QA-134517) — full Include/Exclude confirmed (no CPR-style gap), distinct DOM (`.filter__option__row(--disabled)` / `.filter__option__label` + `.tag-filter-dropdown`). Added the **"Tag" vs "Content Tag" label difference** (Brand Sets uses "Content Tag") and the **URL-serializes-only-on-Apply** rule (Clear All empties `filters`). Re-verified across QA-134272/134273/134436/134443/134517 (all PASS on the layered mechanic; per-case count parity is data-limited when the chosen test-tags have 0 in-window posts).
- **v2** (2026-06-08): Layered tag filtering across 7 surfaces (Brand>Content + Brand>Stories + Brand>Paid + Brand>Partnerships + Brand>Optimization + Brand Sets>Content + Brand Sets>Partnerships). Documents the URL JSON encoding for layered Include+Exclude + OR/AND combinations, the "OR + None backend rejection" quirk on Brand>Content, the Save/Load Filter buttons, the CPR Tag Filter structural divergence, and the pill green-outline/red-fill CSS.
- **v1** (2026-05-18): Initial draft from QA-91412 (Publish Type = Reel on FX Networks). URL-encoding pattern documented from observed URL params.

## 2026-06-11 batch-3 updates

- **Collaborator Name (QA-121304, APV IG Sep 10-16 2025):** filter list order is now Collaborated → Collaborated Total → **Collaborator Combined Followers (NEW option)** → Collaborator Name. Child panel has its own Search + Or/And radios + custom (non-input) checkboxes: click the NAME TEXT (real coordinate click); checked rows float to top. Apply Filter → URL `filters={"content_collaborator_names":{"operator":"or","values":["amazonmgmstudios"],"not":"false"}}`; Posts 211→3, all rows carry the 👥(n) collaborator badge. List is alphabetical (underscore first: `_harrietslater`), unique, 20 names for that window.
- **Publish Type = Reel (QA-91412, FX public FB):** child checkbox is selectable only after the parent dropdown scrolled into viewport; green filter chip appears immediately; Apply Filter → `filters={"content_post_class":{"operator":"or","values":["reel"],"not":"false"}}`. FB Reels public = ALL metrics en-dash (Sum row and every post card) — expected, not a bug.
- Clicking outside the child panel closes BOTH dropdowns and loses selection — keep clicks inside the panel; verify chip + Apply-enabled state before applying.

## Changelog (cont.)
- **v2** (2026-06-11): Collaborator Name flow + Collaborator Combined Followers option; Publish Type Reel flow; selection-loss pitfall.
