---
name: brand-video-favourites
version: 1
last_verified: 2026-06-08
last_passed_run: 2026-06-08
trust: untrusted
pass_streak: 1
preconditions: [account-context, brand-selected]
postconditions: [brand-favourite-toggled]
inputs: [brand_id, account_id]
outputs: [favourite_state, favourite_persisted]
related_pages: ["/#explore/brand/video"]
---

# Brand > Video — Favourites toggle (heart) — persistence across navigation

End-to-end skill for verifying that the Favourite (heart) button in the Brand > Video page header toggles ON and persists when the user navigates away and back.

⚠ **Side-effect tag:** the heart button is a per-user favourite setter — clicking it mutates user-prefs server-state. Intent-to-cleanup is required; documented automation-only cleanup limitation noted below.

Used by:
- **QA-18940** (Brand > Video - Favourites Functionality) — A1+A2+A3 PASS; APPS-53917 NOT REPRODUCED.

## Key UI structure

Brand > Video page header (top-left, next to brand name):
- Favourite button: `button.favorite-brand-button.toggle-button.lfm-button.rounded-button.small`.
- Icon child: `<i class="fal fa-heart">` when not favourite, `<i class="fas fa-heart">` when favourite (`fal` = light/outline, `fas` = solid/filled — FontAwesome class swap).
- Coordinates at default zoom: approx (349, 129), 39×23 px (varies with brand-name length).

## Steps

### Step 1 — Navigate to Brand > Video for the target brand
- **Action:** Direct URL `https://app.lfmdev.in/#explore/brand/video?brand_id={brand_id}&account_id={account_id}` works.
- **Assertion:** Page renders header with brand name + Favourite button. Content tiles may render empty on some brand+window combos (known-quirk: Brand>Video sparse-content; the Favourites widget is independent of the chart renderer).

### Step 2 — Read pre-state of Favourite button
- **DOM probe:**
  ```javascript
  const btn = document.querySelector('button.favorite-brand-button');
  const icon = btn.querySelector('i');
  const state = icon.className.includes('fas') ? 'favourited' : 'not-favourited';
  ```
- **Assertion:** record initial state (favourited vs not-favourited).

### Step 3 — Click Favourite button
- **Action:** JS click on the button:
  ```javascript
  document.querySelector('button.favorite-brand-button').click();
  ```
- **Assertion:** icon class flips `fal fa-heart` ↔ `fas fa-heart` immediately. Confirm via re-probe of `icon.className`.

### Step 4 — Navigate away
- **Action:** navigate to `#home?account_id={account_id}` (or any other surface). Wait ~5s.

### Step 5 — Navigate back to Brand > Video
- **Action:** direct URL back to `#explore/brand/video?brand_id={brand_id}&account_id={account_id}`. Wait ~8s for the brand header to re-render.
- **Assertion:** Favourite icon class is `fas fa-heart` (persisted favourited state). Pre-bug (APPS-53917 historic) the icon would revert to `fal fa-heart` after navigation. The fix should hold — if it does NOT, APPS-53917 has regressed.

## Cleanup

⚠ **Automation-only friction:** The favourite-DELETE endpoint requires a trusted-event signature that JS `.click()`, synthetic `MouseEvent`, and `computer.left_click` did NOT reliably reproduce in QA-18940. The favourite-ADD endpoint accepts JS-fallback clicks; the favourite-DELETE endpoint does not.

**Workaround:** ask LFIQA to un-favourite the brand manually via the hardware mouse on the heart icon in the page header after the test run completes. Document the post-test favourited state in the report Notes.

## Failure signatures

| Signature | Interpretation | Action |
|---|---|---|
| Favourite icon does NOT flip on click | APPS-38159 / APPS-38133 / APPS-30765 regression (heart toggle broken) | File bug |
| Favourite icon flips on click but reverts after navigation | APPS-53917 REGRESSION (persistence broken) | File against the closed bug |
| Brand > Video page empty content area (no tiles) but Favourite button still visible | Brand>Video sparse-content known-quirk — favourite widget is independent of chart renderer | Not a bug — proceed with favourite verification |
| JS-fallback un-favourite click silently fails | Automation-only cleanup friction; favourite-DELETE endpoint requires trusted event | Ask LFIQA for manual cleanup |

## Network expectations

| Endpoint | Method | Expected status | Notes |
|---|---|---|---|
| `/api/.../favorites` (POST add) | POST | 200/201 | Adds brand to user favourites |
| `/api/.../favorites/<id>` (DELETE) | DELETE | 200/204 | Removes — fires only on a trusted-event click in the current build |

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this flow; historical closed defects (APPS-53917 / APPS-38159 / APPS-38133 / APPS-30765) all NOT REPRODUCED on 2026-06-08.

## Changelog

- **v1** (2026-06-08): Initial draft from QA-18940 PASS run. Documents the `fal`↔`fas` icon class swap, the persistence-across-navigation pattern, the APPS-53917 NOT REPRODUCED evidence, and the automation-only cleanup limitation on the favourite-DELETE endpoint.
