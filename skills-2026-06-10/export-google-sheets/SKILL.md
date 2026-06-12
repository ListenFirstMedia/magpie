---
name: export-google-sheets
version: 3
last_verified: 2026-06-10
trust: untrusted
pass_streak: 0
preconditions: [report-built, user-google-authed-in-browser]
postconditions: [google-sheet-opened-in-new-tab]
related_pages: ["/#story/*", "docs.google.com/spreadsheets/*"]
---

# Export report to Google Sheets

From a built report, `Export → Google Sheets`. Dropdown order: **Google Sheets, CSV, TSV, XLS** (confirmed 2026-06-10).

## Steps
1. Install `window.open` hook BEFORE clicking (see v2 snippet below).
2. Click Export → Google Sheets. Button shows a blue spinner while backend generates the sheet.
3. New tab → `https://docs.google.com/spreadsheets/d/<sheetId>/edit...`; may open outside the MCP tab group.

```javascript
window.__openedUrls = [];
const origOpen = window.open;
window.open = function(url, ...rest) { window.__openedUrls.push(String(url)); return origOpen.apply(this, [url, ...rest]); };
```

## Failure signatures (v3 update)
| Signature | Interpretation | Action |
|-----------|----------------|--------|
| Spinner >30 s, `__openedUrls` empty, no new tab | **BUG: export hang** (observed 2026-06-10 on TWC, >90 s, no console/network errors) | report; ask user to check other windows for a sheet tab; retest |
| New tab at accounts.google.com | user not signed into Google | STOP, ask user |
| Tab title mismatch vs `<Brand> - <Report Type> - <begin> - <end>` | filename generator bug | report actual vs expected |

Comparison point: the Audience `Export → Metrics` sheet generated in seconds the same day — Google integration itself was healthy; the TWC hang is product-side.

## Changelog
- **v3** (2026-06-10): Export-hang failure mode (QA-5757 FAIL); dropdown order confirmed.
- **v2/v1** (2026-05-13): MCP-visibility caveat, hook pattern, sheet ownership notes.
