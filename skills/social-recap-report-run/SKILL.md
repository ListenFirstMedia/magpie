---
name: social-recap-report-run
version: 2
last_verified: 2026-06-08
last_passed_run: 2026-06-08
trust: untrusted
pass_streak: 8
preconditions: [account-context]
postconditions: [social-recap-report-built]
inputs: [primary_brand, perspective, additional_brands, options]
outputs: [report_id, pdf_anchor]
related_pages: ["/#explore/reporting/social_recap", "https://app-reporting.lfmdev.in/#/social_recap", "/#story/social_recap/*"]
---

# Reporting > Social Recap — Build + Preview + Download

End-to-end skill for the Social Recap report flow: brand add (Authorized/Public per Rule 1+2), options selection, Run, Preview & Share, Download.

Used by:
- **QA-23969** (Reporting > Social Recap - Download) — full end-to-end
- Any future Social Recap test

## Important platform note

Social Recap lives on a **different subdomain** than the main LFM Platform:
- Main: `app.lfmdev.in/#explore/reporting/social_recap`
- Actual reports: `app-reporting.lfmdev.in/#/social_recap` and `/#story/social_recap/<report_id>`

Clicking Reporting → Social Recap from the main nav navigates cross-subdomain. The OAuth session carries across.

## Steps

### Step 1 — Navigate to Social Recap
- Click `Reporting` in top nav → hover reveals submenu → click `Social Recap`.
- Page redirects to `app-reporting.lfmdev.in/#/social_recap`.

### Step 2 — Add primary brand
- Locate `Add Brand By Name` search field (top-right of Add Brands section).
- Use React-aware typeahead (per `_shared/selectors.md`):
  ```javascript
  const ta = document.querySelector('input[placeholder*="Brand" i]');
  const setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
  setter.call(ta, '<exact brand name>');
  ta.dispatchEvent(new Event('input', {bubbles: true}));
  ```
- Click the literal-match result from the Results dropdown (per Rule 1 — never substitute brands).

### Step 3 — Set perspective explicitly (per Rule 2)
- The View toggle defaults to Public Data on add.
- If spec says Authorized: click the toggle. Confirm via the pill text changing (`Use Authorized Data` ↔ `Use Public Data` — the pill always shows the *inverse* of the current state, so reading the pill tells you the current state).

### Step 4 — Repeat for additional brands
- Type and select each additional brand from Results.
- Set perspective for each per spec.
- Important: typing a new brand search in the same input replaces the previous query — the prior added brands remain in the brand-list table.

### Step 5 — Select Channel Data
- Scroll down to `Select Channel Data` section.
- Channels are checkbox-selected. Default = all on. Adjust per spec.

### Step 6 — Set Options
- Scroll down to `Options` section.
- Three groups: Comparison (Year-over-Year / Prior Period), Worst Performing, General.
- General options:
  - Show Source Links (☐ default)
  - Show Insights Editor (☐ default)
- Click only the options the spec says to enable.

### Step 7 — Run Report
- Click `Run Report` button (bottom right of options).
- The button shows `Brands ✓ Dates ✓ Data ✓` confirmation; if any are ✗, the form is incomplete.
- URL transitions to `/#story/social_recap/<report_id>`. Each run produces a NEW `report_id`.
- Page loads with brand logo, title `<Primary Brand>` + subtitle `Weekly Social Recap (MMM D, YYYY - MMM D, YYYY)`.

### Step 8 — Preview & Share Report
- Click `Preview & Share Report` button (top-right area).
- Top nav transforms: hides the main nav links, shows `Share | Download | X` controls.
- Page content remains rendered (full-page preview).

### Step 9 — Download (PDF generation)
- Click `Download`.
- Browser triggers PDF download silently.
- **Per Rule 6:** do NOT claim the filename or content is correct based on DOM inspection. Ask LFIQA to verify the saved file.

### Step 10 — Close preview
- Find the close-X icon (it's an `<i class="fa fa-times close-icon">` element, NOT a `<button>`, so `find` by accessibility tree may miss it).
- Use this JS pattern:
  ```javascript
  document.querySelector('i.fa-times.close-icon').click();
  ```
- Page returns to edit mode with `Change Settings` + `Preview & Share Report` buttons.

### Step 11 — Change Settings (re-edit)
- Click `Change Settings` to re-open the brand/options modal.
- Existing brands remain in the table; add or remove as needed.
- **Important quirk:** clicking a brand result from the typeahead while the modal is open may auto-close the modal once the brand is added — you may need to re-open the modal to apply additional Options changes.

## Failure signatures

| Signature | Interpretation | Action |
|---|---|---|
| `Brands ✗` next to Run Report | No brand added or duplicate | Re-add via typeahead |
| `Dates ✗` next to Run Report | Date range not selected | Set Start/End dates in calendar |
| `Data ✗` next to Run Report | No channels selected | Toggle Everything On |
| Run Report click does nothing | Form validation silent fail | Check console |
| URL stays at `/social_recap` instead of `/story/social_recap/<id>` after Run | Backend error | Reload + retry |
| Preview top bar shows only some controls | Page not fully loaded | Wait longer (8-10s) before clicking Download |
| Close X not clickable via coordinate | It's an `<i>` not a `<button>` | Use JS `.click()` on the icon element |

## Notes
- The `Insights Editor` is the rich-text WYSIWYG that appears when "Show Insights Editor" is checked. It has Sans Serif / Normal / B/I/U/S / Color / Quote / Code / Lists / Align / Image / Link toolbar.
- "Source Links" adds hyperlinks below each datapoint in the rendered report linking to the source platform post.
- Each Run Report creates a new persisted report (`report_id` increments). Previous report IDs remain accessible via direct URL.

## Known bug history

See `knowledge-base/bug-history.md` for the full per-ticket bug list. Highest-priority open bugs currently tied to this skill's flows:

- LFMP-31925 (Major) — Reporting > Social Recap ->  %YOY is not Present in Video Views Donut in Report.     [from QA-23969]
- LFMP-31918 (Major) — Thumbnail Issue : Report > Social Recap - Thumbnail not showing properly for some posts after downloading report and also for normal reports.     [from QA-837]
- LFMP-31798 (Major) — Reporting > Social Recap - Up and down arrows do not appear correctly in the doughnut charts in the export.      [from QA-837]

## v2 — controlled-check-box workaround + cross-source parity + open bug probes

### `controlled-check-box` focus + Space-dispatch for Options checkboxes (overdue from 2026-05-27)

The Social Recap Options panel (Show Source Links, Show Insights Editor, YoY Comparison, Prior Period Comparison, Worst Performing) uses the same React `controlled-check-box` widget as CPR (`cpr-builder` skill) and TWC v5 (`time-window-comparison-run` skill). Coordinate-based `computer.left_click` lands on the wrapper, not the toggle.

**Workaround:**
```javascript
const cb = [...document.querySelectorAll('i[role="checkbox"]')]
  .find(el => /<Option text>/i.test(el.closest('label, .controlled-check-box')?.textContent || ''));
cb.focus();
cb.dispatchEvent(new KeyboardEvent('keydown', {bubbles:true, key:' ', code:'Space'}));
cb.dispatchEvent(new KeyboardEvent('keyup',   {bubbles:true, key:' ', code:'Space'}));
```

### Cross-source parity — IG Video Views (QA-131491) + YouTube Video Views (QA-131492)

**QA-131491 — IG Public:** Social Recap BPC IG Reel value MUST match Brand>Content IG Post #1 Video Views for the same window.
- MTV / Jan 1-7 2026 / IG / Public: Brand>Content Post #1 Video Views = **691,822**.
- Social Recap BPC IG card same window = **691,822**.
- Verbatim match — no drift across 2 separate-day runs (2026-06-02 + 2026-06-08).

**QA-131492 — YouTube:** Same parity pattern for YouTube VV. Brand>Content YouTube Post #1 = **67,332**. Social Recap BPC YouTube card = **67,332**.

### Multi-brand PDF (QA-837)

Social Recap supports multi-brand builds (typeahead adds brands sequentially; brand-list table accumulates). The Step 4 quirk: typing a new brand search REPLACES the prior query in the input but the prior added brands REMAIN in the brand-list table.

Render time scales linearly with brand count + selected channels. A 3-brand 7-channel build produces a 13+ page PDF.

### LFMP-31798 — Doughnut arrows in export (REPRODUCED)

In the downloaded PDF the up/down arrows in the donut center labels (e.g., `▲ 12%` next to YoY comparison) render incorrectly (wrong direction or missing). DOM read on the in-app preview shows correct arrows; the issue is jsPDF render-side.

**Probe:** rasterize PDF page 1 → look at the donut center text → if arrows missing/inverted, LFMP-31798 REPRODUCED.

### LFMP-31918 — Thumbnail rendering in BPC tiles (REPRODUCED)

Some BPC tile thumbnails don't render correctly in the downloaded PDF (image src placeholder, blank tile, or wrong post's image). Render in the in-app preview is correct; issue is jsPDF asset-fetch.

**Probe:** rasterize PDF page with BPC section → compare thumbnail count vs spec (should be N per channel) → if any missing or wrong, LFMP-31918 REPRODUCED.

## Additional Failure signatures (v2)

| Signature | Interpretation | Action |
|---|---|---|
| Options checkbox doesn't flip on coordinate click | `controlled-check-box` quirk | Use focus + Space-dispatch |
| BPC IG/YouTube card VV ≠ Brand>Content Post #1 VV | Cross-source consistency regression | File bug; capture both values |
| Donut center arrow missing or inverted in downloaded PDF | LFMP-31798 REPRODUCED | File against the known bug |
| BPC tile thumbnail blank in downloaded PDF | LFMP-31918 REPRODUCED | File against the known bug |

## Changelog
- **v2** (2026-06-08): `controlled-check-box` focus+Space-dispatch quirk for Options checkboxes (overdue from 2026-05-27); IG VV parity (QA-131491 691,822) + YouTube VV parity (QA-131492 67,332) + Multi-brand PDF (QA-837); LFMP-31798 doughnut arrows REPRODUCED + LFMP-31918 thumbnail REPRODUCED. +7 streak across QA-23969, QA-131491, QA-131492, QA-837 (×2), QA-19486, QA-131491 RECONFIRM.
- **v1** (2026-05-20): Initial draft from QA-23969 end-to-end run. Per `_shared/spec-adherence-rules.md`: brand name exact-match (Rule 1), explicit Authorized toggle click (Rule 2), every step performed in order (Rule 3), download verification deferred to user per Rule 6.
