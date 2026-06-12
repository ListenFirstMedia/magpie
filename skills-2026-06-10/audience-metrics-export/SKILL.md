---
name: audience-metrics-export
version: 2
last_verified: 2026-06-10
last_passed_run: 2026-06-10
trust: untrusted
pass_streak: 1
preconditions: [user-logged-in, account-set, brand-set]
postconditions: [metrics-google-sheet-opened]
inputs: [brand_id, channel, date_from, date_to]
outputs: [sheet_tab_title, sheet_headers]
related_pages: ["/#explore/brand/audience"]
---

# Export Metrics from Brand > Audience

**v2 CORRECTION (2026-06-10):** `Export → Metrics` does NOT download a file. It generates a **Google Sheet** and opens it in a new tab (often inside the MCP tab group). All v1 guidance about Downloads-folder verification and blob/fetch hooks is obsolete for this export.

## Steps

### Step 1 — Navigate to Brand > Audience for the target brand
- Direct URL works: `https://app.lfmdev.in/#explore/brand/audience?brand_id={brand_id}&account_id={account_id}&from={YYYY-MM-DD}&to={YYYY-MM-DD}&perspective=extended`
- **Caveat (confirmed v2):** direct URL load can throw a transient "The application has encountered an unknown error." — reload the page once; it recovers.
- The URL `channels=X` param does NOT override the visible UI toggle state — you must also set the channel ghost(s) AND click `Apply`.

### Step 2 — Select only the desired channel(s)
- Channel ghosts: `.channel-ghost` with classes like `threads channel-ghost enabled|disabled`.
- **Coordinate clicks and programmatic `.click()` are both unreliable on ghosts.** What works: real click on the ghost AT the element box read from `getBoundingClientRect()` — or better, click once on the target channel: on Audience the ghosts behave **radio-like** (clicking Threads disables all others and enables Threads alone).
- Verify with: `[...document.querySelectorAll('[class*=channel-ghost]')].map(g=>g.className)`.
- Click `Apply` (find the element with exact text `Apply`); wait for the page to repopulate (URL gains `channels=threads`).

### Step 3 — Click Export → Metrics
- `Export` button top right of the channel row → dropdown options: `CSV`, `Google Sheets`, `Metrics`.

### Step 4 — Verify the Google Sheet
- A new tab opens titled `Brand-Audience-Metrics - Google Sheets` (URL `docs.google.com/spreadsheets/d/<id>`). It frequently lands INSIDE the MCP tab group — check `tabs_context_mcp`.
- Sheet content: A1=`Display Name`, B1=`Key`, one row per metric (e.g. `Threads Followers | threads.page.followers_m`).
- **Note:** the catalog includes ALL channels' metrics even when one channel is selected (FB/TW/IG/YT/LinkedIn/Threads rows all present). Not a bug per current test expectations.
- Google Sheets renders via canvas: `get_page_text` only returns the active cell. Use a screenshot to read cells.

## Assertions for QA-110071
- Tab title contains `Brand-Audience-Metrics` ✓
- Headers `Display Name` / `Key` in A1/B1 ✓

## Failure signatures
| Signature | Interpretation | Action |
|-----------|----------------|--------|
| "Application has encountered an unknown error" on direct URL | transient dev issue | reload once |
| `Apply` stays disabled after ghost toggle | toggle didn't register | element-targeted click on ghost; verify className |
| No new tab within 15 s of clicking Metrics | export failed | check console/network |

## Changelog
- **v2** (2026-06-10): Metrics export = Google Sheet in new tab (verified, QA-110071 PASS). Radio-like ghost behavior on Audience. Transient unknown-error on direct URL. Removed obsolete download-capture guidance.
- **v1** (2026-05-13): Initial draft (download-capture problem, now known moot).
