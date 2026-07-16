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

### Quirk D — Toggle click can silently fall back to a DIFFERENT brand (escalated to bug candidate)

**Status: reproduced 3 independent times** (QA-98351 MTV/Threads 2026-06-08 → brand_id fell back to 10765; QA-91412 FX/Facebook 2026-07-07 — noted but not detailed; **QA-136261 FX/Facebook 2026-07-14 — reproduced deterministically 2/2 retries**, full detail below). No longer treat this as automation flakiness — it is a real, repeatable product behavior.

- **Behavior:** Clicking the toggle (`label[for="perspective"]`) can change `brand_id` in the URL to a *different* brand's ID, while the on-screen brand name/logo continues to show the SAME display text (e.g. "FX" → "FX", brand_id 4251 → 19746) — there is no visible cue that the brand changed. The click also resets the Channels row to a default multi-channel set and clears any active Filter pill.
- **Reproduction (QA-136261, FX Networks account_id=204):** brand FX (4251), Facebook-only channel, Publish Type=Reel filter active, Authorized perspective → click toggle → brand_id becomes 19746, channels reset to default, filter cleared. Re-selected FX (4251) via typeahead (itself resets perspective→Authorized, channels→default) → clicked toggle again with NO filter/channel restriction active → brand_id fell back to 19746 again. Confirms the fallback does **not** depend on channel/filter state — it happens on the bare toggle click.
- **Practical impact:** Because re-selecting the correct brand also resets perspective back to Authorized, there is currently **no UI path** to view certain brands' data under Public perspective without hitting this fallback — it blocks the Public-perspective half of any test case on an affected brand.
- **Action:** Do not silently work around this anymore by "just re-select the brand" and move on — document as a BLOCKED assertion + bug finding in the test report each time it's hit, and note the brand_id pair (correct → fallback) for engineering. Recommend it be formally filed as a Jira bug (see `runs/2026-07-14/QA-136261-report.md`).

## Failure signatures

| Signature | Interpretation | Action |
|---|---|---|
| Click does nothing, indicator doesn't move | Toggle is disabled (see Quirk A) | Inspect for `--disabled` class |
| Click moves indicator but data doesn't refresh | Page caching | Hard reload + retry |
| URL says one perspective but indicator is on opposite side | Quirk B | Click toggle to match the spec, then proceed |
| `brand_id` in URL changes after toggle click, display name unchanged | Quirk D (brand-fallback) | Document as BLOCKED + bug finding; do not evaluate assertions against the fallback brand |

## Known bug history

See `knowledge-base/bug-history.md`. Quirk D is a bug candidate as of 2026-07-14 (3rd reproduction) — not yet filed to Jira.

## Changelog
- **v2** (2026-07-03): +1 from QA-134594 (Brand > Video Public Data, PASS). Added the alternate selector `input.toggle-switch-checkbox#perspective` / `label.toggle-switch-label[for="perspective"]` (container `div.toggle-container[data-ui-name=perspective]`), documented the **brand-entity swap** on toggle (Hulu Authorized 5670/extended ↔ Public 11003/standard; brand_id changes are expected), and the **Video tile-rename** confirmation signal ("Public Page Video Views" ⇄ "Page Video Views").
- **v3** (2026-07-14, QA-136261, FX Networks): Escalated the brand-fallback-on-toggle-click pattern (previously dismissed as an automation quirk) to a documented bug candidate (Quirk D) after a 3rd independent, deterministic (2/2 retry) reproduction. A1 (Authorized perspective, no en-dash) PASSED; A2 (Public perspective) BLOCKED — no UI path currently reaches "FX + Public perspective" without the brand silently switching to a different same-named brand (4251→19746).
- **v2** (2026-07-07, QA-91412 Playwright re-run, FX Networks): Brand>Content uses a **different DOM** than the `.al-toggle__checkbox` documented above: `input#perspective.toggle-switch-checkbox` (hidden, click `label[for="perspective"]` instead), inside `.toggle-container[data-ui-name="perspective"]`. Same checked=Authorized / unchecked=Public convention held. Confirmed `perspective=extended` can render `checked=true` (Authorized) on load — reconfirms Quirk B; always verify+click, never trust the URL. All 1,001 metric cells (143 posts × 7 metrics) verified en-dash after toggling to Public — PASS.
- **v1** (2026-05-20): Initial draft after a multi-session QA-91412 re-execution that revealed how easy it is to mis-read the URL `perspective` param vs the actual visual toggle state. Documents Rule 2 from `_shared/spec-adherence-rules.md`.
