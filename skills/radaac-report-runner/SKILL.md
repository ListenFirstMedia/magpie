---
name: radaac-report-runner
version: 1
last_verified: 2026-06-28
last_passed_run: 2026-06-28
trust: untrusted
pass_streak: 8
preconditions: [user-logged-into-platform, cognito-sso-allowed]
postconditions: [radaac-report-downloaded-on-disk]
inputs: [report_name, filter_inputs, file_format]
outputs: [downloaded_filename, columns_verified]
related_pages: ["https://radaac.lfmdev.in/"]
related_skills: [export-csv]
---

# Radaac Report Runner — Cognito SSO + form submit + cached download

End-to-end skill for the Radaac admin reports surface at `radaac.lfmdev.in`. Covers Cognito SSO landing, jQuery-UI dialog form fill, the documented submit-button workaround, the cached `/cache/<filename>` download flow, and per-report column verification.

⚠ **Some reports are MUTATING** (Brand Definitions Apply, etc.). Read the per-report notes below before running.

Used by:
- **QA-51425** (Duplicate Brands and Social Pages) — TSV→CSV regression resolved, file_format dropdown verified.
- **QA-52776** (Brand Definitions Fetch — Exclude URL Manager) — read-only Fetch.
- **QA-52778** (Brand Definitions Fetch — Include URL Manager) — **see BC-5 retraction lesson below**.
- **QA-54202** (Brand Listing with Filter) — Title Category dropdown; TSV download.
- **QA-43914** (Facebook User Accounts) — no file_format dropdown, always TSV.
- **QA-43915** (Ads Account IDs) — **LFMP-30870** reproduces (Fetching → Failed-to-process cycle).
- **QA-63603** (Settings > Tags Upload Tags) — spec-drift finding; Upload Tags affordance is on Brand>Content not Settings>Tags.

## Pre-flight — Cognito SSO challenge

The Radaac landing routes through AWS Cognito → ListenFirst Google SSO. The session cookie from `app.lfmdev.in` does NOT carry directly; Radaac requires its own auth round.

**Sequence:**
1. Navigate to `https://radaac.lfmdev.in/`.
2. Browser redirects to Cognito hosted UI → ListenFirst Google SSO.
3. After SSO, browser returns to Radaac authenticated as `<user>@listenfirstmedia.com`.
4. Report list renders (~19 rows visible: Fuzzy Brand Match, Earned Engagement for Owned Posts, Duplicate Brands and Social Pages, Brand Definitions Fetch/Patch/Apply, Brand Listing, Facebook User Accounts, Ads Account IDs, etc.).

**Expected:** auth flow completes silently for already-logged-in Google users (Chrome MCP carries the Google cookie). If the SSO loop stalls, log out of Google account once and re-login.

## Steps

### Step 1 — Open a report's modal
- **Action:** click the report row's title link on the Radaac home table. Modal opens as a jQuery-UI dialog with title = report name, description text, and a form with filter inputs.
- **Assertion:** Modal description matches the spec text verbatim.

### Step 2 — Fill filter inputs

**React-controlled inputs** (most select dropdowns):
```javascript
const sel = document.querySelector('select[name="<field>"]');
sel.value = '<value>';
sel.dispatchEvent(new Event('change', {bubbles:true}));
```

**Text inputs** (e.g., `Brand IDs (CSV)`):
```javascript
const inp = document.querySelector('input[name="brand_ids"]');
inp.value = '236';
inp.dispatchEvent(new Event('input', {bubbles:true}));
```

**Checkboxes** (e.g., `Include URL Managers`):
```javascript
const cb = document.querySelector('input[name="include_url_mgrs"]');
cb.checked = true;
cb.dispatchEvent(new Event('change', {bubbles:true}));
```

### Step 3 — Submit the form

**⚠ KNOWN AUTOMATION QUIRK:** The jQuery-UI dialog's `Submit` input does NOT navigate via JS `.click()` nor `computer.left_click` coordinate-clicks in many cases — modal stays open.

#### Workaround A (safe for filter-only reports — QA-54202, QA-43914, QA-51425, QA-43915):
Direct URL navigation with form-encoded GET params equivalent to the form's `action`. Inspect the form:
```javascript
const f = document.querySelector('form');
const action = f.action;
const method = f.method;
// Build GET URL: action + '?' + each input as name=value
```
Then `navigate` to that URL. Page transitions to "Fetching report" → "File is Ready" → `/cache/<filename>` link.

#### Workaround B — Brand Definitions Fetch with `Include URL Managers` checked (QA-52778):
**❗ THE BC-5 RETRACTION LESSON — DO NOT USE Workaround A FOR BRAND DEFINITIONS WITH `Include URL Managers`.**

The Radaac backend for Brand Definitions depends on **session-form state** set up by the real Submit handler. Submitting via direct URL GET with `include_url_mgrs=on` returns the 40-column schema (no `url_managers` column) — the backend silently ignores the flag.

The QA-52778 2026-06-04 sub-agent reported this as bug BC-5 ("Include URL Managers has no effect"). LFIQA then drove the same flow through the **real Submit button via hardware mouse** and got the full 42-column schema with `url_managers` populated. **BC-5 was retracted on 2026-06-05** as a Chrome-MCP-only artifact, not a product bug.

**Correct approach for Brand Definitions:** drive the Submit button via a focused pointer-event sequence:
```javascript
const btn = document.querySelector('.ui-dialog-buttonset button:not(.ui-button-disabled)') 
         || document.querySelector('input[type=submit]');
btn.focus();
btn.dispatchEvent(new PointerEvent('pointerdown', {bubbles:true}));
btn.dispatchEvent(new PointerEvent('pointerup',   {bubbles:true}));
btn.click();
```
If that fails, ask LFIQA to drive Submit by hardware mouse.

**Lesson:** for filter-only reports, the URL-GET fallback is safe. For Brand Definitions (Fetch/Patch/Apply) the URL-GET fallback silently drops the flag.

### Step 4 — Wait for "File is Ready"
- **Page transitions:** `Fetching report` (h1) → `File is Ready` with a `Download: /cache/<filename>` link and a `Report URL: ?<params>` echo.
- **Filename schema:** `YYYYMMDD<ReportNameCamelCase>_<6charhash>.<ext>` (e.g., `20260601DuplicateBrandSocialPages_37a06f.csv`, `20260603FacebookUserAccounts_8c53d5.tsv`, `brands_YYYYMMDD-HHMM.tsv` for Brand Listing).

### Step 5 — Click Download link
- **Action:** click the `/cache/<filename>` link. File saves to `~/Downloads/`.
- **Assertion:** file on disk; size > header-only byte count for the expected row count.

### Step 6 — Verify file contents
- Open via `awk -F'<delim>' …` to count fields per row.
- Check that the header row matches the spec's expected columns verbatim (lowercased on some reports — `brand id` not `Brand ID` for Duplicate Brands report).
- For filtered reports (e.g., Brand Listing + Title Category=Automotive), assert `sort -u` on the filter column returns exactly 1 unique value.

## Per-report quick reference

| Report | Format | Filter inputs | Mutating? | Quirks |
|---|---|---|---|---|
| Duplicate Brands and Social Pages | tsv/csv/xls dropdown | none | No | CSV→TSV regression watched in known-quirks (resolved 2026-05-29) |
| Brand Definitions Fetch | xlsx | Brand IDs (CSV), Include URL Managers | No | BC-5 lesson — drive Submit via focused pointer-events for Include URL Managers |
| Brand Definitions Patch | xlsx | Fetch xlsx upload | Potentially | Reads but writes a patch xlsx for review |
| Brand Definitions Apply | xlsx | Patch xlsx upload | **YES (writes to dev brand)** | Withhold execution unless explicitly OK'd |
| Brand Listing | tsv only | Subscriber Name, Title Category (50 options), Company IDs, Brand set IDs, Brand IDs | No | Filename `brands_YYYYMMDD-HHMM.tsv` |
| Facebook User Accounts | tsv only (no file_format dropdown) | Account, Token | No | 9-column TSV; empty result is just the header row |
| Ads Account IDs | tsv/csv/xls dropdown | Subscriber, PDA, file_format, column_headers, cache | No | **LFMP-30870 REPRODUCES** — cached filename appears in DOM before job completes, click returns "File not found"; H1 cycles `Fetching report` → `Failed to process` |

## LFMP-30870 probe (Ads Account IDs cycling failure)

**Symptoms:**
- After Submit, page renders H1 `Fetching report` + visible `/cache/<filename>.csv` link.
- Click the link → page shows body `File not found. Some reports require a bit more time.`
- Wait 30s, reload → page TITLE flips to `Failed to process.` while H1 stays `Fetching report`.
- After ~100s the file never materializes in `~/Downloads`.

**Verdict if symptoms present:** LFMP-30870 REPRODUCED — file against the closed bug; needs re-opening by triage.

## Failure signatures

| Signature | Interpretation | Action |
|---|---|---|
| Cognito SSO loop doesn't return to Radaac | Google session expired | Re-login to Google; retry |
| Modal Submit button JS-resistant | Known automation friction | Use Workaround A for filter-only OR Workaround B for Brand Definitions |
| Brand Definitions Fetch returns 40-col schema with `include_url_mgrs=on` | URL-GET fallback dropping the flag (NOT a product bug — see BC-5 lesson) | Drive Submit via focused pointer-events, OR ask LFIQA for hardware mouse |
| `/cache/<filename>` link clicks return "File not found" | Possible cycling failure (LFMP-30870 for Ads Account IDs) | Wait 100s; if file never arrives, file the bug |
| Downloaded `.csv` is tab-separated | CSV→TSV regression (historic) | Document in known-quirks; check separator with `cat -A` |
| File on disk is header-only (no data rows) | Filter matched zero records (expected for token/scope mismatches) | Not a bug if filter narrow; verify spec expectation |

## Network expectations

| Endpoint | Method | Expected status | Notes |
|---|---|---|---|
| `https://<cognito>.amazoncognito.com/oauth2/authorize` | GET | 302 | SSO redirect chain |
| `https://radaac.lfmdev.in/<report_action>` | GET | 200 | Form submit (URL-GET workaround) |
| `https://radaac.lfmdev.in/cache/<filename>` | GET | 200 (when ready) / 404 (cycling failure) | Download |

## Known bug history

See `knowledge-base/bug-history.md`. Highest-priority open bugs currently tied to this skill's flows:

- LFMP-30870 (Major, Closed-but-reproducing) — Radaac > Ads Account IDs > The Export failed to download.     [from QA-43915]

## Changelog

- **v1** (2026-06-08): Initial draft from QA-51425, QA-52776, QA-52778, QA-54202, QA-43914, QA-43915, QA-63603. Documents the Cognito SSO landing, the jQuery-UI Submit JS-resistance + URL-GET workaround for filter-only reports, the **BC-5 retraction lesson** (Brand Definitions session-form-state dependency — never URL-GET fallback for include_url_mgrs), the cached `/cache/<filename>` download flow, and the LFMP-30870 cycling Fetch/Failed pattern as a known-bug probe for Ads Account IDs.
