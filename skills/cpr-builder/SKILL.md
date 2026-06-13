---
name: cpr-builder
version: 1
last_verified: 2026-06-08
last_passed_run: 2026-06-08
trust: untrusted
pass_streak: 2
preconditions: [user-logged-in, account-context]
postconditions: [cpr-story-built]
inputs: [brand_name, perspective, channels, options, visual_top_count, additional_top_count, least_engaging]
outputs: [story_id, pdf_filename]
related_pages: ["/#explore/reporting/content_performance", "https://app-reporting.lfmdev.in/#/content_performance", "/#story/content_performance/*"]
related_skills: [view-perspective-toggle, social-recap-report-run, pdf-end-to-end-verification]
---

# Reporting > Content Performance Report (CPR) Builder

End-to-end skill for the CPR Builder flow on `app-reporting.lfmdev.in/#/content_performance`. Covers the React-controlled brand picker (Rule 1 typeahead Results), the `controlled-check-box` focus+Space-dispatch workaround for Options panel checkboxes, the triple_click + type pattern for numeric inputs (Visual Top/Bottom Posts, Additional Top/Bottom Post Table Rows), Run Report → story render → Preview & Share Report → Download, and the LFMP-32010 probe.

Used by:
- **QA-3630** (CPR > BPC filmstrip Authorized) — previously BLOCKED on `controlled-check-box`; UNBLOCKED via focus+Space-dispatch. PASS 5/6; LFMP-32010 REPRODUCED on 2026-05-29 batch 11 (Michael Kors Authorized).
- **QA-23991** (CPR Download) — MTV; full flow PASS 4/4 + on-disk PDF (294K).

## Key UI structure

CPR Builder lives on a different subdomain (same pattern as Social Recap):
- Main top-nav: `app.lfmdev.in/#explore/reporting/content_performance`.
- Actual builder: `app-reporting.lfmdev.in/#/content_performance`.
- Story URL: `app-reporting.lfmdev.in/#story/content_performance/<id>`.

OAuth session carries across subdomains.

### Builder sections
1. **Add Brands** — brand picker typeahead + per-brand `View: Public Data | Authorized Data` toggle.
2. **Date Range** — Absolute Dates / Relative Dates tabs. Auto-snaps to **current week** when first loaded.
3. **Channels** — 7 channels default-checked (FB / Twitter / IG / YouTube / TikTok / LinkedIn / Threads).
4. **Options** — `Most Engaging Content` (always), `Least Engaging Content` (opt-in checkbox), numeric inputs for `Visual Top Posts`, `Additional Top Post Table Rows`, `Visual Bottom Posts`, `Additional Bottom Post Table Rows`.
5. **Run Report** — yellow CTA button. Builder shows `Brands ✓ Dates ✓ Data ✓` indicators.

### Story page
- Header: `<Brand> / Content Performance / (<MM DD, YYYY> - <MM DD, YYYY>)`.
- Per-channel `Most Engaging Content` + (optional) `Least Engaging Content` sections.
- Channel-tile distribution chart (Content Posted % + Engagements %).
- Footer: `Preview & Share Report` button (yellow pill, top-right).

## Steps

### Step 1 — Navigate to CPR Builder
- **Action:** Top nav → Reporting (hover) → Content Performance (click). Or direct URL to `app-reporting.lfmdev.in/#/content_performance`.
- **Assertion:** builder loads with Add Brands typeahead empty.

### Step 2 — Add primary brand (Rule 1)
- **React-controlled `controlled-text-input` quirk:** JS-typed value via `Object.getOwnPropertyDescriptor(...).set` did NOT surface the typeahead Results on the CPR builder. **Use real keyboard via `computer.triple_click + type`:**
  ```
  computer.triple_click on input.al-typeahead__text-input
  computer.type "<brand_name>"
  ```
- **Assertion:** typeahead Results section opens after ~3-5s with N matching brands.
- **Select:** click `div.al-typeahead__option` matching the literal brand name from the **Results** section (per Rule 1 — never substitute, never click from Recent Searches).

### Step 3 — Set perspective explicitly
- **Default:** Public Data.
- If spec says Authorized: click the toggle. Confirm via `view-perspective-toggle` skill (toggle handle-right + `perspective=extended` URL match + DOM probe of `.al-toggle__checkbox.checked === true`).

### Step 4 — Date range
- **Default:** auto-snaps to current week (e.g., May 31, 2026 – Jun 6, 2026 for a 2026-06-08 run).
- For Absolute Dates: click Start + End on the calendars.
- For long historical windows the spec says "Last 30 Days" — the structural assertions (filmstrip rendering, LFMP-32010 probe) do not depend on the window, so the current-week default is acceptable.

### Step 5 — Channels (default 7 checked)
- Most specs use all 7; some specify a 4-channel subset (FB / Twitter / IG / YouTube). Click off the unwanted ones.

### Step 6 — Options panel — `controlled-check-box` workaround

The Options checkboxes (Most Engaging Content, Least Engaging Content) are NOT native `<input type=checkbox>` — they're React `controlled-check-box` widgets that:
- Have `role="checkbox"` on an `<i>` element.
- Do NOT respond to JS `.click()` reliably.
- Do NOT respond to `computer.left_click` at the rendered checkbox coordinate (the click lands on the wrapper, not the toggle).

**Workaround — focus + Space dispatch:**
```javascript
const cb = [...document.querySelectorAll('i[role="checkbox"]')]
  .find(el => /Least Engaging Content/i.test(el.closest('label, .controlled-check-box')?.textContent || ''));
cb.focus();
cb.dispatchEvent(new KeyboardEvent('keydown', {bubbles:true, key:' ', code:'Space'}));
cb.dispatchEvent(new KeyboardEvent('keyup',   {bubbles:true, key:' ', code:'Space'}));
```
- **Assertion:** `aria-checked` flips to `true`. Visual Bottom Posts + Additional Bottom Post Table Rows fields appear.

The same pattern applies to any other `controlled-check-box` on CPR/TWC/social-recap builders.

### Step 7 — Numeric inputs (Visual Top/Bottom Posts, Additional Top/Bottom)

These are React-controlled `<input type="number">`. JS `.value = "5"` + `dispatchEvent('input')` does NOT persist — the React state machine reverts the value on next render.

**Workaround — triple_click + type + Tab:**
```
computer.triple_click on the numeric input  → highlights existing value
computer.type "5"                            → typed value committed
computer.key "Tab"                           → forces React onBlur
```
- For inputs below the viewport, `scroll_to` + `left_click` + `Backspace×3` + `type` + `Tab` is the safe variant.
- **Assertion:** input retains the typed value after Tab.

### Step 8 — Run Report
- **Action:** JS-fallback `find` then `left_click` on the `al-button--primary-button` matching `Run Report` text. (Coordinate click below viewport edge often fails.)
- **Assertion:** URL transitions to `#story/content_performance/<id>`. Story page renders.

### Step 9 — Verify regular-view rendering
- **Assertion:**
  - Header `<Brand> / Content Performance / (<dates>)`.
  - Per-channel `Most Engaging Content` sections render with N posts (matches Visual Top Posts).
  - If Least Engaging Content was checked: per-channel `Least Engaging Content` sections also render with N posts.
  - Channel-tile distribution chart present.

### Step 10 — Preview & Share Report
- **Action:** click `div.preview-and-share-btn` (top-right yellow pill).
- **Assertion:** preview mode opens with `.report-preview-controls` containing `Share | Download` controls.

### Step 11 — LFMP-32010 probe — Least Engaging Posts heading missing in Preview & Share

**Trigger:** Step 6 enabled `Least Engaging Content` AND Step 10 entered Preview & Share Report mode.

**DOM probe:** enumerate every `Least Engaging Content` heading and compare bounding rect against the matching `Most Engaging Content` heading.
```javascript
const all = [...document.querySelectorAll('h1,h2,h3,h4,h5,h6')];
const leastHeadings = all.filter(h => /Least Engaging Content/.test(h.textContent));
const mostHeadings  = all.filter(h => /Most Engaging Content/.test(h.textContent));
leastHeadings.forEach(h => { const r = h.getBoundingClientRect(); console.log(h.textContent, r.width, r.height); });
mostHeadings.forEach(h => { const r = h.getBoundingClientRect(); console.log(h.textContent, r.width, r.height); });
```

**Expected LFMP-32010 REPRODUCED signature** (2026-05-29 batch 11 — Michael Kors Authorized):
```
Facebook Least Engaging Content   → rect 0,0 0x0   (display: inline-block, visibility: visible) — INVISIBLE
... (7 channels all 0x0) ...

Facebook Most Engaging Content    → rect 604,115 250x20  — VISIBLE
... (7 channels all 250x20) ...
```

The heading elements exist in DOM but render with 0×0 bounding rect — a CSS sizing/positioning regression specific to Preview & Share view. The regular-view (Step 9) renders Least Engaging Content headings with normal 250×20 rect.

**Verdict if 7/7 Least Engaging headings render at 0×0 in Preview mode while Most Engaging headings render at 250×20:** LFMP-32010 REPRODUCED.

### Step 12 — Download (PDF generation)
- **Action:** click `div.download-btn` inside `.report-preview-controls`.
- **Engine:** jsPDF 3.0.1 (client-side render — no server-fetch, no Recent Activity notifications bell entry).
- **Wait:** ~28-35s for PDF generation + download.
- **Filename schema:** `<Brand>-Content Performance(<MM DD, YYYY> - <MM DD, YYYY>).pdf`.
  - Example: `MTV-Content Performance(May 31, 2026 - Jun 6, 2026).pdf`.
- **Size:** typically 290-310K for 1-page (Most Engaging only) build.
- **Verification:** use `pdf-end-to-end-verification` skill (pdftoppm rasterize → PNG read). Text extraction returns 0 lines because jsPDF embeds canvas as image.

## Failure signatures

| Signature | Interpretation | Action |
|---|---|---|
| Typeahead Results section doesn't surface after JS value-set | React `controlled-text-input` quirk on CPR builder | Use `computer.triple_click + type` instead |
| `controlled-check-box` doesn't toggle on JS click | Known quirk | Use focus + Space-dispatch workaround |
| Numeric input reverts to default after JS `.value=` set | React state-machine quirk | Use `triple_click + type + Tab` |
| Run Report disabled with `Brands ✓ Dates ✓ Data ✓` | Validation logic regression | File bug |
| Story page URL stays at `/content_performance` after Run | Backend build failure | Check console for 5xx; reload + retry |
| Least Engaging Content headings render at 0×0 in Preview & Share | **LFMP-32010 REPRODUCED** | File against the open bug |
| jsPDF download <100K | Likely empty/blank PDF (APPS-55569 historic) | Verify on disk via `pdf-end-to-end-verification`; file if reproduced |
| Filename schema deviates from `<Brand>-Content Performance(<dates>).pdf` | Schema regression (APPS-49527 historic) | File bug |

## Network expectations

| Endpoint | Method | Expected status | Notes |
|---|---|---|---|
| `/api/.../content_performance/build` | POST | 200 | Triggered by Run Report; returns story_id |
| `/api/.../content_performance/<id>` | GET | 200 | Story page renders |

## Known bug history

See `knowledge-base/bug-history.md`. Highest-priority open bugs currently tied to this skill's flows:

- LFMP-32010 (Major) — Reporting > CPR > Least Engaging Posts & Heading does not show in Preview & Share Report.     [from QA-3630]

## Changelog

- **v1** (2026-06-08): Initial draft from QA-3630 (PASS after `controlled-check-box` unblock; LFMP-32010 REPRODUCED) + QA-23991 (full builder + download PASS, on-disk 294K PDF). Documents the React-controlled brand picker triple_click+type pattern, the `controlled-check-box` focus+Space-dispatch workaround, the numeric input triple_click+type+Tab pattern, the jsPDF client-side render, the `<Brand>-Content Performance(<dates>).pdf` filename schema, and the LFMP-32010 bounding-rect-0×0 probe.
