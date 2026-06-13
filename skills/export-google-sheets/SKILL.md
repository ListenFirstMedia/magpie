---
name: export-google-sheets
version: 2
last_verified: 2026-05-13
last_passed_run: 2026-05-13
trust: untrusted
pass_streak: 1
preconditions: [report-built, user-google-authed-in-browser]
postconditions: [google-sheet-opened-in-new-tab]
inputs: []
outputs: [google_sheet_tab_id_or_url, google_sheet_filename, google_sheet_rows]
related_pages: ["/#story/*", "docs.google.com/spreadsheets/*"]
---

# Export report to Google Sheets

From a built report, click `Export → Google Sheets`. A new tab opens (in the user's main Chrome window, NOT always inside the Chrome MCP tab group — see "MCP visibility" below) with the report data populated in a Google Sheet.

## Steps

### Step 1 — Open the Export dropdown
- **Action:** click the `Export` button at the top right of the report header (between `Change Settings` and `Preview & Share Report`).
- **Target (primary):** find with "Export dropdown button at top of report"
- **Assertion:** A dropdown appears containing exactly: `Google Sheets`, `CSV`, `TSV`, `XLS` (in that order).

### Step 2 — Click Google Sheets
- **Action:** click the `Google Sheets` option (it has class `lfm-dropdown-option`).
- **Target (primary):** find with "Google Sheets option in export dropdown"
- **Side effects:**
  - The Export button shows a loading spinner while the LFM backend generates the sheet.
  - A new tab opens via `window.open(...)` pointing to `https://docs.google.com/spreadsheets/d/<sheetId>/edit?gid=0#gid=0`.
- **Assertion (within 15s):** the spinner clears and the new tab is open.

### Step 3 — MCP visibility caveat (READ THIS BEFORE AUTOMATING)

**The new Google Sheets tab often opens OUTSIDE the Chrome MCP-managed tab group.** This means `tabs_context_mcp` will not list it and you cannot drive it directly. Symptoms observed:

- The Export button stays in a loading state because the LFM tab waits for a confirmation message from the new tab that never arrives in the MCP-isolated context.
- `window.open` is the mechanism, so a `window.open` hook on the LFM tab CAN capture the URL — install it BEFORE clicking Google Sheets:

```javascript
window.__openedUrls = [];
const origOpen = window.open;
window.open = function(url, ...rest) {
  window.__openedUrls.push(String(url));
  return origOpen.apply(this, [url, ...rest]);
};
```

  After the click, `window.__openedUrls[0]` contains the sheet URL. Extract the `<sheetId>` segment to validate later.

### Step 4 — Capture filename

Three viable paths, in order of preference:

1. **From the new tab title (if it lands in the MCP group):** read the tab title and strip the trailing ` - Google Sheets` suffix.
2. **From the captured `window.open` URL:** load the URL in a fresh MCP tab (`tabs_create_mcp` + `navigate`), then read the tab title.
3. **Ask the user to share the sheet:** if the previous two fail or the user's Google session prevents readable access, ask them to set the sheet to "Anyone with the link → Viewer" and paste the link. Then open it in an MCP tab.

- **Expected filename format:** `Brand - <Report Type> - <begin_date> - <end_date>` where dates use the format `Month D, YYYY` (e.g., `May 5, 2026`).
- **For TWC:** `<Brand> - Time Window Comparison - <begin_date> - <end_date>`

### Step 5 — Capture sheet contents

Once the sheet is loaded in an MCP-visible tab, read row 1 (headers) and rows 2 onward (data). For a single-metric TWC report the columns are: **Perspective, Brand, Date, &lt;Metric&gt;**.

Extraction snippet:

```javascript
const rows = [...document.querySelectorAll('.cell-input, [role="gridcell"]')]
  .map(c => c.textContent || '');
// Then group into rows of length 4 (or however many columns the report has)
```

Or simpler, if Google Sheets renders the cells in a static layout, read the visible text via the page's `read_page` and pattern-match rows.

## Important: sheet ownership

The Google Sheet is **not** owned by the test user's Google Drive. The LFM export creates the sheet under a service identity (or auto-shares to the test user). Consequence: `drive.google.com/drive/recent` and Drive search may NOT surface the sheet for the test user. Always use the direct sheet URL from the `window.open` hook.

## Notes on Google authentication

- This skill assumes the user is signed into Google in the attached browser session. If a `Choose an account` page or sign-in flow appears instead of the sheet, **STOP**, capture a screenshot, and ask the user whether to proceed with Google sign-in.
- Do not attempt to enter Google credentials yourself.

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| `window.__openedUrls` empty after 15s | BUG (export request failed) | check console + network for the request that should have created the sheet |
| New tab opens to `accounts.google.com/...` | User not signed in to Google | STOP, ask user |
| Tab title doesn't match `<Brand> - <Report Type> - <begin> - <end>` | BUG (filename generator broken) | report exact actual vs expected |
| Sheet opens empty or with #REF errors | BUG (data pipeline broken) | report with sheet ID and timestamp |
| Sheet opens but is inaccessible to the test user | Sheet ownership / sharing bug | flag; ask user to share to make readable |

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows; 40 historical defects (all closed) are catalogued there.

## Changelog
- **v2** (2026-05-13): Documented the MCP-visibility caveat (new tab often outside MCP group), `window.open` hook pattern, sheet ownership (service account, not user Drive), and the three-path filename capture (tab title / URL hook / user share).
- **v1** (2026-05-13): Initial draft from QA-5757. Google Sheets export from TWC report produced the expected filename and 7 rows of data matching the in-app table.

## 2026-06-11 batch-3 update — TWC Google Sheets export hang is now a CONFIRMED systemic bug

- Reproduced on a **second account/report**: Wasserman, TWC story 154443 (FIAWEC). Export → Google Sheets spins >60 s, `window.open` hook never fires, no Sheet tab anywhere.
- While the GS export is stuck, the **entire Export control is locked** (replaced by spinner) — CSV/TSV/XLS cannot be selected until a full page reload.
- Combined with the 2026-06-10 Adam Orfei repro (QA-5757, The Walking Dead story 154359): treat TWC GS export as **broken on dev**, not an MCP-visibility quirk. Do not wait beyond ~60 s; reload and use CSV (blob hook) for export-parity assertions; file/escalate the bug.
- Non-TWC GS exports still work (Audience "Metrics" export, dashboard-tile GS export QA-92841) — the breakage is TWC-specific.

## Changelog (cont.)
- **v4** (2026-06-11): TWC GS hang reconfirmed cross-account; Export-control lockout documented; CSV fallback canonicalized.
