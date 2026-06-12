---
name: text-input-wrap-tooltip
version: 1
last_verified: 2026-05-18
last_passed_run: 2026-05-18
trust: untrusted
pass_streak: 1
preconditions: [search-input-visible]
postconditions: [wrap-or-tooltip-confirmed]
inputs: [long_text]
outputs: [render_mode]
related_pages: ["*"]
---

# Text Input Wrap + Truncation Tooltip

LFM's textareas (`.lfm-textarea`, `.global-brand-typeahead`) and result rows display long text in one of two modes depending on width:

1. **Wrap mode** — when container width allows, the text wraps to 2 lines. No tooltip needed.
2. **Truncate mode** — when container width is narrow OR text is very long, the text is ellipsis-truncated and a `title` attribute is set to show the full text on hover.

Used by:
- **QA-95226** — Global Search + Brand Search + Brand Set Search + TWC Brand search two-row display.
- **QA-533** — Brand Content text-cell truncation tooltip (similar pattern).

## Steps

### Step 1 — Identify the rendering mode
For any container holding potentially-long text:

```javascript
(function(selector){
  const el = document.querySelector(selector);
  const r = el.getBoundingClientRect();
  const fullText = el.textContent.trim();
  const isWrapped = r.height > 25;  // typical single-line is ~20px
  const hasTitle = !!el.getAttribute('title');
  const isTruncated = el.scrollWidth > el.clientWidth;
  return JSON.stringify({
    fullText,
    rect: [Math.round(r.width), Math.round(r.height)],
    isWrapped,
    hasTitle,
    isTruncated,
    titleAttr: el.getAttribute('title') || ''
  });
})('.global-brand-typeahead')
```

### Step 2 — Assert based on mode

**If wrapped (height > single-line height):**
- Assert text is split across 2 (or more) visual rows.
- Tooltip NOT required (full text visible).
- If a `title` attribute exists anyway, that's belt-and-suspenders — not a bug.

**If truncated (`scrollWidth > clientWidth`):**
- Assert `title` attribute exists AND `title` value === full text.
- The visible text should end with `…` (ellipsis).
- Hovering should show the OS tooltip with the full text.

### Step 3 — Cross-context verification (for QA-95226)
The same wrap/truncate behavior must apply consistently across 4 contexts:

| Context | Selector |
|---|---|
| Global search (top nav) | `textarea.global-brand-typeahead` |
| Brand search container (Brand → Insights) | `.brand-typeahead input` or `.lfm-textarea` |
| Brand-Set search container (Brand Sets → Content) | `.brand-set-typeahead input` |
| TWC brand container (Reporting → TWC) | `.twc-brand-typeahead input` |

For each, repeat Step 1+2 with the same long text input.

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| Text truncates but no `title` attribute set | Tooltip missing — user can't see full text | File bug |
| Wrapped to 3+ lines (height > 60px) | CSS `max-height: 2em` or similar should be enforced | File bug (visual regression) |
| Text wraps inconsistently across the 4 contexts | Cross-context regression | File bug, document which context differs |

## Notes
- The DOM inspection approach (`scrollWidth > clientWidth`) is more reliable than visual screenshots for truncation detection.
- Container width on dev `app.lfmdev.in` ≈ 263px for the global typeahead input, 299px for the dropdown result wrapper. Production may differ.

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows; 0 historical defects (all closed) are catalogued there.

## Changelog
- **v1** (2026-05-18): Initial draft from QA-95226 (UCLA — Lowell Milken Center for Music of American Jewish Experience). Wrap mode confirmed for 60-char brand name in 263px container.

## 2026-06-11 batch-3 update (QA-95226 re-pass, UCLA)

- All four contexts re-verified: global search + Brand page brand-picker + Brand Sets set-picker render long names on 2 rows (item height 40px ≈ 2×20px lines); TWC builder typeahead ellipsizes (`text-overflow: ellipsis`) with full name in `title` attr (hover tooltip). Brand "Lowell Milken Center for Music of American Jewish Experience" (brand 290318) and set "UCLA School of the Arts and Architecture Roll-up" are the fixtures.
