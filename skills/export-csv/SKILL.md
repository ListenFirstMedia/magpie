---
name: export-csv
version: 2
last_verified: 2026-05-18
last_passed_run: 2026-05-18
trust: untrusted
pass_streak: 2
preconditions: [report-built]
postconditions: [csv-blob-captured]
inputs: []
outputs: [csv_filename, csv_text]
related_pages: ["/#story/*", "/#explore/brand/content"]
---

# Export report to CSV

From a built report, click `Export → CSV`. The browser triggers a download (no new tab). To capture content for assertions, install a Blob-interception hook BEFORE clicking.

## Steps

### Step 1 — Install Blob/anchor download hook
Before clicking CSV, run this JavaScript in the report tab to capture the download content:

```javascript
window.__capturedBlobs = [];
const origCreate = URL.createObjectURL;
URL.createObjectURL = function(blob) {
  if (blob instanceof Blob) {
    blob.text().then(t => {
      window.__capturedBlobs.push({ type: blob.type, size: blob.size, text: t });
    });
  }
  return origCreate.call(this, blob);
};
const origClick = HTMLAnchorElement.prototype.click;
HTMLAnchorElement.prototype.click = function() {
  if (this.download) {
    window.__capturedDownloads = window.__capturedDownloads || [];
    window.__capturedDownloads.push({ href: this.href, download: this.download });
  }
  return origClick.call(this);
};
```

### Step 2 — Open the Export dropdown and click CSV
- **Action:** click `Export` button → click `CSV` option.
- **Assertion:** The dropdown closes, the `CSV` div momentarily receives the `.selected` class, and the browser triggers a download silently.

### Step 3 — Read captured blob
- **Action:** wait 3-5s, then run:

```javascript
const blob = window.__capturedBlobs[0];
const dl = window.__capturedDownloads[0];
({ filename: dl.download, lineCount: blob.text.split(/\r?\n/).filter(l=>l.length>0).length });
```

- **Note:** If the captured blob text contains URL-like strings, Chrome MCP may refuse to return the full content in one call. Read row-by-row using `lines[i]` indexing — return each line's content as a string concatenation, not as nested objects. (See QA-5757 run for the working pattern.)
- **Expected filename format:** `Brand - <Report Type> - <begin_date> - <end_date>.csv`
- **Expected content format:** CSV with all values double-quoted. First line = headers. Subsequent lines = data rows.

### Step 4 — Parse and assert
- Headers expected (for TWC single-metric): `"Perspective","Brand","Date","<Metric>"`
- Data rows: one row per day in the date range, each row 4 quoted fields.
- Date format in CSV cells: `MM/DD/YYYY` (e.g., `05/05/2026`).
- Numeric values: raw integers, no thousands separator (`6329`, not `6,329`).

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| `__capturedBlobs` empty after 5s | BUG (CSV generation didn't fire) OR hook installed too late | check console; re-run with hook installed earlier |
| Filename does not match `Brand - <Report Type> - <begin> - <end>.csv` | BUG | report with exact actual filename |
| Header row count or order differs from Google Sheets export | BUG (export consistency broken) | report with both header rows |
| Numeric values are formatted (e.g., `6,329`) in CSV | BUG (formatting bleeding into data) | report with all rows |
| CSV uses a different date format than `MM/DD/YYYY` | Potential test-spec drift; flag as quirk | check `known-quirks.md` first |

## Security / safety note

This skill triggers a real file download to the user's Downloads folder. By design, the hook captures the content in-memory for assertion before the file lands on disk — so we don't need to read the user's Downloads to verify the export. The on-disk file is left in place for the user's normal use.

## Variant — server-side queued export (Brand > Content)

Brand > Content uses a different export pipeline than TWC. The flow:

1. Click `Export` (top-right) → opens "Export Select Data Sets" modal with CSV/Google Sheets toggle (CSV default).
2. Check the data sets you want (Public is pre-checked) → click `Ok`.
3. Toast appears: "Your export has successfully been queued." No immediate blob, no anchor download.
4. Wait ~30s. The bell icon (top-right notification badge) increments. Open Recent Activity panel.
5. The new entry reads:
   ```
   Select Data Sets Export
   <timestamp>
   Your Content Export with Select Data Sets for <Brand> from <date> to <date> is now ready. Download file.
   ```
6. The `Download file` link points to `https://analytics-cdn.lfmdev.in/<job_id>-<hash>.csv` with `download=""` (empty).

Capture flow:

```javascript
// Find the Download file link in the bell-icon panel
const link = Array.from(document.querySelectorAll('a'))
  .find(a => a.textContent.includes('Download file'));
const url = link.href;
// Fetch with credentials (the CDN respects the LFM session cookie)
const r = await fetch(url, {credentials: 'include'});
const text = await r.text();
```

Then parse `text` for assertions. No Blob-interception hook needed for this variant — the CDN URL is directly fetchable.

### Known quirk — filename is the CDN object key, not the spec format

The CDN returns `content-type: binary/octet-stream` and **no** `Content-Disposition` header. The anchor's `download` attribute is empty. So when the user clicks the link, the browser saves the file as `<job_id>-<hash>.csv` — NOT as `Brand-Content-YYYYMMDD-YYYYMMDD-posts.csv`.

This is documented as bug **BC-2** (QA-531 A2 failure). When asserting filename:
- For the spec-compliant scenarios (TWC, etc.): expect `Brand - <Report Type> - <begin_date> - <end_date>.csv`.
- For Brand > Content exports: expect the CDN-hashed filename and explicitly note BC-2 in the report.

## ⚠ Critical caveat — DOM signals are NOT proof of download outcome

**Do not file a "filename is broken" bug based solely on:**
- The anchor's `download=""` attribute being empty
- The CDN response (via in-page `fetch`) lacking `Content-Disposition` header

These signals look suggestive but the actual filename the browser saves can differ when a real user click happens. React handlers may set the filename programmatically before saving; the CDN may serve a different response to an authenticated click than to a `fetch()` reproduction; the browser may use other signals.

**Anti-pattern:** BC-2 (filed 2026-05-18, retracted 2026-05-20) claimed the Brand>Content CSV export was saving with a CDN-hashed filename based on DOM/network inspection alone. In reality, when LFIQA clicked the download link in normal use, the filename was correct.

**To validly verify a download filename, do ONE of:**
1. Allow the click to complete a real download → read the filename in the Downloads folder.
2. Observe the browser's Save As dialog (if "Always ask where to save" is on) and read the proposed filename.
3. Ask the user to verify on their end and report back.

If none of these are possible in your session, mark the assertion as **INCONCLUSIVE**, not FAIL.

## Known quirk — Export modal "Ok" button sometimes doesn't dismiss

Observed in **QA-122942 (Hulu)** and **QA-71007 (Disney Ad Sales)** this session. When the "Export Select Data Sets" modal is open with a single Data Set pre-checked (because the user picked Impressions etc. as the active Data Set), clicking `Ok` does NOT always dismiss the modal — even via both coordinate-click and JS `.click()`.

Workarounds (try in order):
1. **Uncheck and re-check the Data Set** before clicking Ok. The modal may need a fresh `change` event to enable the submit handler.
2. **Click the underlying `<input type="checkbox">`** for Public (or whichever Data Set you want) explicitly, then Ok.
3. **Close the modal (X button), reopen, click Ok immediately.** Sometimes fresh modal state fixes it.

Failure signature: after Ok, modal stays open; no "Your export has successfully been queued" toast appears; bell-icon count doesn't increment.

If queued successfully, the toast appears within ~1 second, and the bell-icon notification arrives within ~30 seconds.

## Changelog
- **v1** (2026-05-13): Initial draft from QA-5757. CSV content matched Google Sheets content cell-by-cell (7 rows × 4 columns, 0 mismatches).
- **v2** (2026-05-18): Added server-side-queued export variant from QA-531. Documents BC-2 (CDN filename bug). Records new working pattern: fetch the CDN URL directly with `credentials: 'include'` instead of intercepting blobs.
- **v2.1** (2026-05-18): Added "Export modal Ok button quirk" failure signature from QA-122942 and QA-71007.
