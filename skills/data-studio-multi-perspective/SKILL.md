---
name: data-studio-multi-perspective
version: 1
last_verified: 2026-05-18
last_passed_run: 2026-05-18
trust: untrusted
pass_streak: 1
preconditions: [data-studio-page-loaded]
postconditions: [same-brand-added-twice-different-perspectives]
inputs: [brand_name]
outputs: [legend_labels]
related_pages: ["/#explore/reporting/data_studio"]
---

# Data Studio — Add Same Brand with Different Perspectives

A non-obvious flow: Data Studio allows adding the SAME brand TWICE — once as Public, once as Authorized — so a report can compare the two perspectives side-by-side.

The legend then shows the Public copy with a `[P]` pill and the Authorized copy with no suffix.

Used by:
- **QA-86318** — Verify dual-perspective add (Michael Kors + MTV-P + MTV-Authorized).
- Any Data Studio test that needs to compare Public vs Authorized for the same brand.

## Steps

### Step 1 — Add the brand once (Public default)
- Type the brand into `Add a Brand` typeahead.
- Click the brand in the **Results** section (not Recent Searches — same caveat as `switch-account` skill).
- Use React-aware setter to trigger the typeahead:
  ```javascript
  const input = document.querySelector('input[placeholder*="Brand" i]');
  const setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
  setter.call(input, '<BrandName>');
  input.dispatchEvent(new Event('input', {bubbles: true}));
  input.focus();
  ```
- **Assertion:** a new row appears in the brand list with `Public ⬛ Authorized` toggle (defaults to Public).

### Step 2 — Add the same brand a second time
- Type the SAME brand name in the typeahead again.
- The dropdown still shows the brand as a clickable option (even though it's already in the list).
- Click it from the **Results** section.
- **Assertion:** a second row with the same brand name appears in the list. Now there are two rows for the brand, both with independent toggles.

### Step 3 — Toggle the second instance to Authorized
- Find the second brand row's `al-toggle__checkbox` input (use `:nth-of-type(2)` or the last one in the list).
- Click it.
- **Assertion:** toggle visually moves right, URL persists, dataset shows Authorized perspective for the second instance.

### Step 4 — Add metrics + Go
- Use `data-studio-post-level-run` skill primitives to pick metrics and click Go.

### Step 5 — Verify legend
After report renders:
- **Assertion:** legend contains both:
  - `<BrandName> [P]` — small pill identifying Public
  - `<BrandName>` — no suffix, the Authorized one

Example for MTV:
```
Legend: ■ Michael Kors [P]   ■ MTV [P]   ■ MTV
```

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| System rejects the second add (only one row visible) | Regression — dual-perspective add broken | File bug, capture URL + DOM snapshot |
| Toggle on second row is disabled | Brand has no Authorized data on this account | Not a bug per se; document data gap (same pattern as Hulu in QA-111213) |
| Legend missing the `[P]` pill on Public brand | UI regression | Capture legend DOM + screenshot |
| Both brands show identical labels (no Public/Authorized distinguisher) | Critical legend regression | High-severity bug |

## Caveats
- The Authorized toggle is **brand-specific** — some brands on some accounts have no Authorized data, so the toggle renders disabled (`al-toggle__switch--disabled`). That's not a bug.
- Tested on Adam Orfei + MTV. Recommended to also verify on at least one more account/brand pair before promoting to `stable`.

## Changelog
- **v1** (2026-05-18): Initial draft from QA-86318. Verified dual-MTV-perspective added correctly, legend showed `MTV [P]` and `MTV`.
