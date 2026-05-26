---
name: brand-content-filter
version: 1
last_verified: 2026-05-18
last_passed_run: 2026-05-18
trust: untrusted
pass_streak: 1
preconditions: [brand-content-loaded]
postconditions: [filter-applied]
inputs: [filter_type, filter_value, operator]
outputs: [filtered_post_count]
related_pages: ["/#explore/brand/content"]
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

## Changelog
- **v1** (2026-05-18): Initial draft from QA-91412 (Publish Type = Reel on FX Networks). URL-encoding pattern documented from observed URL params.
