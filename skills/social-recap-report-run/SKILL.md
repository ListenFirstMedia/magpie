---
name: social-recap-report-run
version: 1
last_verified: 2026-05-20
last_passed_run: 2026-05-20
trust: untrusted
pass_streak: 1
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

## Changelog
- **v1** (2026-05-20): Initial draft from QA-23969 end-to-end run. Per `_shared/spec-adherence-rules.md`: brand name exact-match (Rule 1), explicit Authorized toggle click (Rule 2), every step performed in order (Rule 3), download verification deferred to user per Rule 6.
