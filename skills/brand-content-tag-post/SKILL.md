---
name: brand-content-tag-post
version: 1
last_verified: 2026-05-20
last_passed_run: 2026-05-20
trust: untrusted
pass_streak: 1
preconditions: [on-brand-content-page, brand-selected]
postconditions: [test-tag-applied-and-removed]
inputs: [brand_name, unique_tag_value]
outputs: [tag_persisted_verified, filter_behavior_verified, view_layouts_verified]
related_pages: [Brand>Content]
---

# Brand Content — Tag Post (mutating)

End-to-end flow for QA-1677-style tests: click Tag on a postcard, add a unique tag, verify count update + persistence + filter behavior + Table/Detail view, then cleanup.

⚠ **MUTATING SKILL** — adds & removes a tag on a real post. ALWAYS use a unique timestamped tag value and ALWAYS run cleanup at end.

## Used by
- **QA-1677** (Brand Content — Tag Post). 9/9 PASS.

## Key UI structure

### Postcard bottom strip
Each postcard ends with `Tag | Daily Analysis` (where `Tag` becomes `Tag (N)` if the post has N tags).

### Tag popup (opens on click)
- Title: "Add Tags" (visible at top of popup body)
- Search/filter input: "Filter Tags"
- List of existing tags (each shown as `<tag-value> ×` chip)
- Input: "Please enter up to 100 characters" + "Add" button
- "Delete All Tags" link (bottom-left)
- "Done" button (bottom-right, yellow)
- Close × at top-right of popup

### Add behavior
- Type tag value into input → click Add
- Tag immediately appears as chip in popup
- Tag count on the post (visible below in postcard strip) updates `Tag` → `Tag (1)` even before Done

### Platform side effects
- Tag values are **lowercased** when saved (`MyTag` → `mytag`)
- Tag values are **deduplicated** (adding same value twice has no effect)
- 100 character limit

## Steps

### Step 1 — Click Tag on postcard
Use `find` with query like "Tag link on <date> postcard" to locate the right Tag link. Click via `ref`. Confirm popup opened by screenshot.

### Step 2 — Add unique tag
Generate timestamp: `date +%Y%m%d-%H%M%S` via bash.
Tag value: `QA-<TICKET>-TEST-<timestamp>` (e.g. `QA-1677-TEST-20260520-104121`).

The text input has a React-controlled value, so use the Chrome MCP `form_input` tool with the input `ref` — DON'T use `computer:type` because it may miss the input field's coordinates on some viewports.

After setting value, click the "Add" link (next to input). Confirm:
- Chip `<value> ×` appears
- Filter Tags search input appears (it shows once any tag exists)
- Tag count on postcard updates

### Step 3 — Close popup
Click "Done" button (find via `ref`). Use `ref` click, not coordinate — Done button may shift position after Add.

### Step 4 — Refresh + verify persistence
Press F5. Wait ~10s for posts grid to fully reload. Scroll down to see Tag count on the post. Confirm `Tag (1)` persists.

### Step 5 — Apply Tag filter
- Click Filter "Select" dropdown
- Type "Tag" in search → click "Tag" option
- In child dropdown: **None** is always the first/topmost option (alphabetically sorted, but None is special and always first)
- Tick "None" checkbox (Include is default radio)
- Chip `Tag: None [○ Include]` appears at top
- Click "Apply Filter"

URL parameter set: `filters=...content_tags...operator=or, values=[""], not="false"`

### Step 6 — Toggle to Exclude
The chip has a small toggle slider between "None" and "Include" text. **DON'T click on the chip text** (that opens "Remove Filter" tooltip).

Reliable approach: use JS to click the `input.toggle-switch-checkbox` element directly. There are 4 such checkboxes on the Brand>Content page (3 for benchmark/sentiment/something + 1 for the Tag chip toggle). The 4th one (index 3) is the Tag chip toggle.

```js
const tagToggle = document.querySelectorAll('input.toggle-switch-checkbox')[3];
tagToggle.click();
```

After click:
- Chip background turns **pink/red** (Exclude indicator)
- Chip text now reads `Tag: None [Exclude ●]`
- Apply Filter button becomes active again

Click Apply Filter. URL `not` changes to `"true"`.

### Step 7 — Verify filter math
| State | Posts visible | Math |
|---|---|---|
| No filter | 85 (all) | baseline |
| Tag: None Include (= posts without tags) | 78 | 85 - 7 tagged = 78 |
| Tag: None Exclude (= posts with tags) | 7 | the 7 tagged posts |

### Step 8 — Switch layouts
Layout: selector at top-right of Posts header, three icons:
1. Table View (leftmost, `≡` icon) — use `ref` from find "Table View"
2. Grid View (middle, grid icon, default selected) — find "Grid View"
3. Detail View (rightmost, list-detail icon) — find "Detail View"

Click each via `ref` and verify the posts re-render in the new layout.

### Step 9 — Cleanup (CRITICAL)
1. Switch back to Grid View
2. Find Tag link on the post you tagged (search by date timestamp + "Tag (1)")
3. Click Tag → popup opens with your tag chip
4. Either:
   - Click the × next to your specific tag chip (preserves other tags) — accessibility tree may not expose this; coordinate-click on the × after scrolling popup into view
   - OR click "Delete All Tags" → confirmation dialog "Delete N tag(s) from 1 post(s)" → click "Delete All"
5. The Delete All approach is SAFE if you tagged a post that had no pre-existing tags. Verify count in confirmation dialog matches your expected (1 if you added 1 tag).
6. Click Done. Verify postcard Tag link reverts to "Tag" (no count).

## Failure signatures

| Signature | Interpretation | Action |
|---|---|---|
| `computer:type` types into wrong field after popup open | React input field doesn't receive raw keys reliably | Use `form_input` with `ref` instead |
| Click on Tag link doesn't open popup | Click coordinate was on postcard body, not link | Use `find` + `ref` click instead of coordinate |
| Chip toggle click opens "Remove Filter" tooltip | Click hit chip text, not slider | Use JS `.click()` on `input.toggle-switch-checkbox[3]` |
| Posts count doesn't update after Apply Filter | Apply Filter button click missed | Use `find` + ref for the Apply Filter button |
| Tag value capitalized in code but lowercase in chip | Platform auto-lowercases | Expected behavior, not a bug |

## Changelog
- **v1** (2026-05-20): Initial draft from QA-1677 PASS run. Documents the React-aware input pattern, the 4th-checkbox toggle pattern, the lowercase auto-normalization, and Delete-All-Tags cleanup pattern.
