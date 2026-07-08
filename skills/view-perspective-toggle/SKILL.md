---
name: view-perspective-toggle
version: 2
last_verified: 2026-07-03
last_passed_run: 2026-07-03
trust: untrusted
pass_streak: 11
preconditions: [brand-page-loaded-with-view-toggle]
postconditions: [perspective-confirmed-by-screenshot]
inputs: [target_perspective]  # "Public" or "Authorized"
outputs: [confirmed]
related_pages: ["/#explore/brand/*"]
---

# View Perspective Toggle — Public vs Authorized

CRITICAL skill: never trust URL `perspective` param to reflect the actual displayed view. Always click the toggle explicitly and confirm via screenshot.

## When to use

Every Brand → * test that mentions a perspective requirement (Public Data or Authorized Data). Examples:
- QA-91412 step 4: "Change the perspective to Public"
- QA-1515 A6/A7/A8: Public Data vs Authorized Data data-set lists
- QA-122942 step 3: "Perspective = Public Data"
- QA-531: implicitly Public Data (most tests default)

## Steps

### Step 1 — Identify the toggle widget

The toggle is in the page header below the brand name + date range. Visual layout:

```
View: Public Data  [● ───────]  Authorized Data
                    ↑
                    Indicator (handle/dot)
```

The indicator's POSITION indicates which side is selected:
- Indicator on LEFT (under "Public Data" text) = **Public Data is selected**
- Indicator on RIGHT (under "Authorized Data" text) = **Authorized Data is selected**

**Selector varies by page.** Two forms seen: `input.al-toggle__checkbox` (older) and **`input.toggle-switch-checkbox#perspective`** with a clickable `label.toggle-switch-label[for="perspective"]` (Brand > Video, 2026-07). The container is `div.toggle-container[data-ui-name="perspective"]`. Same `checked` convention applies to both: **`checked:false` = Public Data, `checked:true` = Authorized Data.** Click the `<label for="perspective">` (not the hidden checkbox).

**Toggling swaps the brand entity + brand perspective (not just a view flag).** On Hulu, Authorized = `brand_id=5670&perspective=extended`; Public Data = `brand_id=11003&perspective=standard`. The URL brand_id CHANGES when you flip the toggle — expected, not a bug. (Same 5670↔11003 entity swap seen in Insights.) Channel set can also shrink under Public (e.g. LinkedIn drops).

**Tile-rename is a reliable confirmation signal on Video:** the middle Video tile is **"Public Page Video Views"** under Public Data and **"Page Video Views"** under Authorized. Asserting which name is present is a clean, non-visual way to confirm the active perspective (QA-134594 steps 7 & 8).

### Step 2 — Inspect current state via JS (don't trust URL)

```javascript
(function(){
  const toggle = document.querySelector('input.al-toggle__checkbox');
  if (!toggle) return "no toggle";
  return JSON.stringify({
    checked: toggle.checked,
    disabled: toggle.disabled,
    parentCls: toggle.parentElement.className
  });
})()
```

**Convention observed on this codebase:** `checked: false` = Public Data selected, `checked: true` = Authorized Data selected. The visual indicator's position confirms.

### Step 3 — Click to change if needed

If current state ≠ target:

```javascript
(function(){
  const toggle = document.querySelector('input.al-toggle__checkbox');
  toggle.click();
  return JSON.stringify({nowChecked: toggle.checked});
})()
```

OR use `find` + `left_click` with `ref`:

```javascript
mcp_find("View Public Data Authorized Data toggle switch")
// Then left_click on the returned ref
```

### Step 4 — Confirm via screenshot

Take a screenshot immediately after the click. Verify:
1. The indicator is now on the correct side.
2. The page is reloading (skeleton loaders appear briefly).
3. After ~5 seconds, data has refreshed (new Posts count, new metric values).

### Step 5 — Wait for data refresh, then proceed

```
wait 5 seconds
screenshot
verify Posts count + Sum/Average row values changed from previous state
```

Only after these 5 steps is the perspective confirmed and you can evaluate assertions.

## Known quirks

### Quirk A — Toggle disabled when no Authorized data exists
Some brand+channel combinations have no Authorized data (e.g. Hulu's Instagram on Sony Pictures account in QA-111213). The toggle renders disabled:

```html
<div class="al-toggle__switch al-toggle__switch--disabled">
  <input disabled class="al-toggle__checkbox" ...>
</div>
```

If `toggle.disabled === true`, the brand has no Authorized data on this account. **Don't try to force-toggle.** Document the disabled state and treat as a data gap.

### Quirk B — URL `perspective` parameter is unreliable
- `perspective=extended` USUALLY maps to "Public Data" with extended channel list (FB, X, IG, TT, LN, Th, YT, Pin).
- `perspective=standard` USUALLY maps to "Authorized Data" with narrowed channel list.
- BUT some brand+account combinations invert this convention.
- **Never trust the URL — always verify via screenshot.**

### Quirk C — Toggle indicator visual is small
On 1386px-wide screenshots the indicator can look ambiguous. Zoom in (`computer.zoom` action) if uncertain.

## Failure signatures

| Signature | Interpretation | Action |
|---|---|---|
| Click does nothing, indicator doesn't move | Toggle is disabled (see Quirk A) | Inspect for `--disabled` class |
| Click moves indicator but data doesn't refresh | Page caching | Hard reload + retry |
| URL says one perspective but indicator is on opposite side | Quirk B | Click toggle to match the spec, then proceed |

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows; 0 historical defects (all closed) are catalogued there.

## Changelog
- **v2** (2026-07-03): +1 from QA-134594 (Brand > Video Public Data, PASS). Added the alternate selector `input.toggle-switch-checkbox#perspective` / `label.toggle-switch-label[for="perspective"]` (container `div.toggle-container[data-ui-name=perspective]`), documented the **brand-entity swap** on toggle (Hulu Authorized 5670/extended ↔ Public 11003/standard; brand_id changes are expected), and the **Video tile-rename** confirmation signal ("Public Page Video Views" ⇄ "Page Video Views").
- **v1** (2026-05-20): Initial draft after a multi-session QA-91412 re-execution that revealed how easy it is to mis-read the URL `perspective` param vs the actual visual toggle state. Documents Rule 2 from `_shared/spec-adherence-rules.md`.
