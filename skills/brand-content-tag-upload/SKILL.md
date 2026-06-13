---
name: brand-content-tag-upload
version: 1
last_verified: 2026-06-08
last_passed_run: 2026-06-08
trust: untrusted
pass_streak: 1
preconditions: [account-context, brand-content-page-loaded]
postconditions: [csv-template-downloaded]
inputs: [brand_id]
outputs: [downloaded_template_filename, template_columns_verified]
related_pages: ["/#explore/brand/content", "https://assets.listenfirstmedia.com/app/documents/LF%20Upload%20Tags%20Sample%20-%20Sheet1.csv"]
related_skills: [brand-content-tag-post]
---

# Brand > Content — Upload Tags — Download CSV Template

End-to-end skill for the Upload Tags modal (a.k.a. "Update Tag Modal" per spec wording) accessed via Brand > Content's Tag dropdown. Verifies the `Download CSV Template` link, the static CDN-hosted template URL, and the 2-column template schema covering 6 channels.

⚠ **Side-effect tag:** the bulk upload itself is MUTATING — this skill only covers the template download, which is read-only.

Used by:
- **QA-27292** (Brand > Content - Download CSV Template in Update Tag Modal) — PASS 4/4 end-to-end on disk; 696B template with 8 sample rows across 6 channels.

## Key UI structure

### Tag dropdown on Brand > Content
- Selector: `button.tag-dropdown.with-dropdown[data-ui-name="tags"]`.
- Coordinates approx (1300, 266) at default zoom.
- Dropdown options enumerated:
  1. `Bulk Tag` (default-selected for the primary `Tag` button text).
  2. **`Upload Tags`** ← this skill.
  3. `Manage Tags`.

### Upload Tags modal (a.k.a. "Update Tag Modal" per spec)
- Title: "Upload Tags" (spec writes "Update Tag Modal" — same modal).
- Contains a `Download CSV Template` link element:
  ```html
  <a href="https://assets.listenfirstmedia.com/app/documents/LF%20Upload%20Tags%20Sample%20-%20Sheet1.csv">
    Download CSV Template
  </a>
  ```
- File-picker / drop-zone for the user's prepared CSV (Mutation pathway — not exercised by this skill).
- Cancel / Upload buttons.

## Steps

### Step 1 — Navigate to Brand > Content
- **Action:** Direct URL `https://app.lfmdev.in/#explore/brand/content?brand_id={brand_id}&account_id={account_id}`.
- **Assertion:** Brand>Content page loads (Posts table renders for the default 7-day window).

### Step 2 — Open Tag dropdown
- **Action:** click the Tag dropdown chevron (use `[data-ui-name="tags"]` selector + JS click for reliability — the dual-button widget has a primary action that fires `Bulk Tag` if you miss the chevron).
- **Assertion:** dropdown options visible: `Bulk Tag / Upload Tags / Manage Tags`.

### Step 3 — Click Upload Tags
- **Action:** click the `lfm-dropdown-option` matching text `Upload Tags`.
- **Assertion:** Update Tag Modal (Upload Tags modal) opens.

### Step 4 — Click Download CSV Template
- **Action:** click the `Download CSV Template` link inside the modal.
- **Assertion:** browser downloads the CSV from the assets CDN. URL: `https://assets.listenfirstmedia.com/app/documents/LF%20Upload%20Tags%20Sample%20-%20Sheet1.csv`.

### Step 5 — Verify file on disk
- **File:** `~/Downloads/LF Upload Tags Sample - Sheet1.csv`.
- **Expected size:** 696 bytes (verify exact byte count for regression).
- **Expected Row 1 (header):** `Post URL,Post Tag` (2 columns).
- **Expected sample rows (8 rows across 6 channels):**
  - Facebook: `https://www.facebook.com/ListenFirstMedia/posts/...,performance`
  - Twitter: `https://twitter.com/listenfirst/status/...,holiday_performance`
  - Twitter: `https://twitter.com/listenfirst/status/...,performance`  (multi-tag-per-URL pattern, 3 rows for same Twitter URL)
  - Twitter: `https://twitter.com/listenfirst/status/...,holiday`
  - Instagram: `https://www.instagram.com/p/...,superbowl`
  - YouTube: `https://www.youtube.com/watch?v=...,social-media-analytics`
  - TikTok: `https://www.tiktok.com/@therock/video/...,workout`
  - LinkedIn: `https://www.linkedin.com/posts/...,social_analytics`

## Schema discipline

- **2 columns only:** `Post URL` + `Post Tag`. No header row variations (no `Brand ID`, no `Tag Category`).
- **Multi-tag per URL:** one row per `(URL, tag)` pair. To tag a single post with 3 tags, write 3 rows with the same URL and different `Post Tag` values.
- **6 channels covered** in the sample: Facebook, Twitter, Instagram, YouTube, TikTok, LinkedIn. (Threads and Pinterest are not in the sample but accept the same schema.)
- **Tag normalization:** the platform auto-lowercases on upload, just like Brand>Content Tag chip add (`brand-content-tag-post` skill). `superbowl` and `Superbowl` collapse to the same tag.

## Failure signatures

| Signature | Interpretation | Action |
|---|---|---|
| Download CSV Template link missing from modal | UI regression on Upload Tags modal | File bug |
| Downloaded file size ≠ 696B | Template content has been updated (could be intentional spec change) | Verify Row 1 + sample rows; if structure preserved, update this skill with new size |
| Row 1 ≠ `Post URL,Post Tag` | Schema regression — bulk upload will break for existing user CSVs | File bug urgently |
| Sample rows missing a channel | Documentation drift — bulk upload may still work but template is misleading | File doc-update ticket |
| Link `href` points to a per-tenant or per-brand path | Template moved off CDN | Verify still accessible from all account contexts; if not, file bug |

## Network expectations

| Endpoint | Method | Expected status | Notes |
|---|---|---|---|
| `https://assets.listenfirstmedia.com/app/documents/LF Upload Tags Sample - Sheet1.csv` | GET | 200 | Static CDN; same URL for all users/accounts |

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows. APPS-51167 historical (closed) "Brand content tab not loading" did NOT reproduce.

## Changelog

- **v1** (2026-06-08): Initial draft from QA-27292 PASS 4/4. Documents the dual-button Tag dropdown (use chevron not primary), the asset-CDN template URL, the 2-column `Post URL,Post Tag` schema, the multi-tag-per-URL pattern, the 6-channel sample coverage, and the spec's `Update Tag Modal` ↔ UI's `Upload Tags` naming drift.
