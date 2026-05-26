# Known Quirks

Accepted product behavior or automation-only friction that previously looked like bugs. Anything in this list is **not** reported as a bug on future runs.

Each entry should explain *why* it's accepted so we can revisit when product decisions change.

## Format

```
### <quirk title>
- **First observed:** YYYY-MM-DD (TC-XXX)
- **Behavior:** what the app does
- **Why accepted:** product/design decision, link to ticket if available
- **Affected assertions:** which checks should ignore this
- **Revisit if:** condition that would make us care again
```

## Entries

### Brand picker requires programmatic InputEvent dispatch

- **First observed:** 2026-05-13 (QA-5757)
- **Behavior:** The "Search for a Brand" textbox in the TWC builder is React-controlled and ignores plain `value` mutation. Chrome MCP's `type` action sets the value but doesn't trigger React's `onChange`, so the autocomplete dropdown doesn't open. A manual user typing on a real keyboard triggers it normally.
- **Why accepted:** This is automation-only friction, not a product bug. End users are not affected.
- **Affected assertions:** None — assertions still verify the dropdown appears, but the *means* of triggering it is documented in the skill so the assertion doesn't false-fail.
- **Revisit if:** The Chrome MCP `type` action is upgraded to dispatch synthetic input events (then we can simplify the skill).

### Google Sheets tab title includes "- Google Sheets" suffix

- **First observed:** 2026-05-13 (QA-5757)
- **Behavior:** When a Google Sheet opens in a tab, the browser tab title is `<filename> - Google Sheets`. The `- Google Sheets` suffix is added by Google Drive, not by the LFM export.
- **Why accepted:** Standard Google Drive behavior across all hosted spreadsheets.
- **Affected assertions:** Filename pattern checks (e.g., QA-5757 A1) — strip the trailing ` - Google Sheets` before comparing to the expected pattern.
- **Revisit if:** Google changes the convention (highly unlikely).

### Reporting top-nav menu opens on hover, not click

- **First observed:** 2026-05-13 (QA-5757 second run)
- **Behavior:** The "Reporting" item in the top global navigation is a hover-triggered dropdown. Clicking the label is unreliable — sometimes nothing happens, sometimes the click is interpreted as a toggle-close.
- **Why accepted:** This is the product's intended interaction model.
- **Affected assertions:** Any skill that opens a top-nav dropdown. The skills now use `hover` then `click` on the child item.
- **Revisit if:** Product changes to click-to-open.

### Brand picker "Recent Searches" section is display-only

- **First observed:** 2026-05-13 (QA-5757 second run)
- **Behavior:** The "Add Brand By Name" typeahead shows a "Recent Searches" section above the live "Results". Clicking an entry in Recent Searches does **not** add a brand row — it appears to dismiss the dropdown without selecting. Only entries under the `Results` heading add a brand row.
- **Why accepted:** Likely intentional — Recent Searches is shown as a hint, not as a selectable history.
- **Affected assertions:** Skill `time-window-comparison-run` step 5 — always pick from Results.
- **Revisit if:** Product changes Recent Searches to be interactive.

### Default 7-day date range shifts forward daily

- **First observed:** 2026-05-13 (QA-5757 first run on 5-13, then re-run later same day)
- **Behavior:** The TWC builder's default Absolute Dates range is "last 7 days ending yesterday". Two runs on different days will see different default ranges. Within a single day, the range may shift at midnight Pacific or after a session refresh.
- **Why accepted:** Standard relative-default behavior.
- **Affected assertions:** Filename assertions that include dates — capture the actual rendered range from the built report rather than hardcoding.
- **Revisit if:** The default range stops shifting (could indicate a frozen-time bug).

### Em-dash cells for dates past data freshness

- **First observed:** 2026-05-13 (QA-5757 second run)
- **Behavior:** The data table for a metric may render `–` (em dash) for any date that is past the `Data Last Updated` timestamp shown on Home. Today's run on 2026-05-13 had data through 2026-05-12 06:32 PM PT, so the May 12 row in a May 6–12 window correctly showed `–`.
- **Why accepted:** Normal data freshness — that day's ETL hadn't run yet.
- **Affected assertions:** Any cross-export parity check — treat `–` as a recognized missing-value marker, not a value mismatch.
- **Revisit if:** Em dashes appear for dates that should be available (e.g., a date 3+ days in the past).

### Google Sheets export opens a tab outside the Chrome MCP group

- **First observed:** 2026-05-13 (QA-5757 second run)
- **Behavior:** Clicking `Export → Google Sheets` triggers `window.open` to a `docs.google.com/spreadsheets/...` URL. The resulting tab often opens in the user's regular Chrome window, **not** in the Chrome MCP-managed tab group. Consequences:
  - `tabs_context_mcp` won't list the sheet tab.
  - The Export button can stay in a loading state because the LFM tab waits for a message from the new tab that never arrives across the MCP boundary.
- **Why accepted:** Browser / MCP integration behavior, not a product bug.
- **Affected assertions:** Anything that needs to read the Google Sheet content from automation. Workarounds documented in `skills/export-google-sheets/SKILL.md`: install a `window.open` hook to capture the URL, then open that URL in a fresh MCP tab.
- **Revisit if:** Chrome MCP gains the ability to absorb externally-opened tabs.

### Google Sheets export sheet is not in the user's Drive

- **First observed:** 2026-05-13 (QA-5757 second run)
- **Behavior:** The LFM Google Sheets export creates the spreadsheet under a service identity (not the test user's Google account). `drive.google.com/drive/recent` for the test user does not show the sheet at the top; Drive search may not find it either. The sheet IS accessible via the direct URL.
- **Why accepted:** Service-account ownership is a common export pattern.
- **Affected assertions:** Filename assertions that try to verify via Drive — use the direct URL captured by the `window.open` hook instead.
- **Revisit if:** Drive listing starts showing the exports.

### View toggle default position is `Public Data`

- **First observed:** 2026-05-13 (QA-5757)
- **Behavior:** When a brand is added to a Reporting context via the "Add Brand By Name" picker, the per-brand `View:` toggle defaults to `Public Data` (left position, `checkbox.checked === false`).
- **Why accepted:** This is the intended default per product behavior; the test case wording "Hulu (Public Data)" was a descriptive note referring to this default toggle state, not a separate brand entity.
- **Affected assertions:** Skill `time-window-comparison-run` step 6 expects this default and only flips the toggle if a test case requires `Authorized Data`.
- **Revisit if:** Default changes to `Authorized Data` for any user/brand combination, OR if a separate "Hulu (Public Data)" brand entity is later created.
