---
name: settings-custom-data-sets
version: 2
last_verified: 2026-06-08
last_passed_run: 2026-06-08
trust: untrusted
pass_streak: 6
preconditions: [account-context]
postconditions: [custom-data-set-listed, brand-content-data-set-applied]
inputs: [data_set_name, metrics_list]
outputs: [data_set_id]
related_pages: ["/#custom-data-sets", "/#custom-data-sets/create", "/#explore/brand/content"]
---

# Settings > Custom Data Sets — Basic View, Create, Brand>Content support

End-to-end skill for the Custom Data Sets feature:
1. **Basic View** — list of all existing CDS, with create/edit/delete actions.
2. **Create a New Custom Data Set** — name + description + metric picker (per-channel sub-lists, same UI grammar as Custom Metrics formula builder).
3. **Brand > Content support** — selecting a custom CDS from the Data Set dropdown updates the columns in the post table, and CSV export reflects the selected CDS.

Used by:
- **QA-104870** (Basic View) — PASS 12/13 + 1 N/A. Spec's "blank table state" assertion is N/A on Adam Orfei (already has 6 custom CDS).
- **QA-106218** (Create flow) — PASS 13/14 + minor format variance. Spec writes `MM-DD-YYYY | HH:MM AM/PM PT` (pipe separator); UI uses space separator. Functional behavior matches.
- **QA-109062** (Brand>Content export) — PASS 7/7 end-to-end. CSV downloaded with spec-compliant filename, columns include all configured + breakdown metrics, no leaked LF data sets in export.

## Steps

### Step 1 — Navigate to Custom Data Sets list
- **Action:** Top nav → Settings → Custom Data Sets.
- **URL:** `/#custom-data-sets`.
- **Assertion:** Page renders a table with columns: `Name`, `Description`, `Created Date`, `Created By`, `Metrics Count`, `Actions`. `Create a New Custom Data Set` button (yellow) top-right.

### Step 2 — Create flow
- **Action:** Click `Create a New Custom Data Set`.
- **URL:** `/#custom-data-sets/create`.
- **Assertion:** `Save` button initially DISABLED (greyed). Inputs: Name, Description, Configure your metrics list.

### Step 3 — Metric picker (per-channel)
- **Action:** Click `Configure your metrics list` → dropdown shows `Metrics` and (no `Operators` row — this is a *set*, not a formula).
- Hover Metrics → channel sub-list in this order: `ListenFirst`, `Facebook`, `Twitter`, `YouTube`, `Instagram`, `TikTok`, `Wikipedia` (same as Custom Metrics).
- Each channel sub-list shows `<channel icon> + metric name + DCR key`.
- Click a metric → chip added with X close button. Order in the chip row = column order in the resulting Brand>Content table.

### Step 4 — Save
- **Action:** Click Save.
- **Assertion:** Modal popup `Success / Custom data set successfully created!` with `Ok`. After Ok → redirected to `/#custom-data-sets`; new row visible.

### Step 5 — Apply on Brand > Content
- Navigate to Brand > Content for any brand.
- Open the **Data Set** dropdown (top-right of the table).
- **Assertion:** the dropdown groups options under `My Data Sets` (user-created CDS) and `ListenFirst Data Sets` (system defaults). User-created CDS sorted alphabetically by name.
- Select the new CDS → table columns swap to the configured metrics + their breakdown sub-columns.

### Step 6 — CSV export reflects the active CDS
- Click `Export → CSV` (uses `export-csv` skill for the queued-export pipeline).
- **Assertion:** filename matches the queued-export naming pattern; columns in the CSV match the selected CDS's configured metrics, no extra LF-data-set columns leaked in.

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| Save enabled with empty metrics list | Spec violation | File bug |
| CDS list ordering not alphabetical within "My Data Sets" | UI regression | File bug |
| Brand>Content table doesn't refresh on Data Set switch | Either a refresh bug or you're on the wrong tab — verify URL has `data_set_id=<n>` | Investigate |
| CSV columns include metrics from a different data set | Data leak — file bug |
| Pipe-separator vs space-separator timestamps in CDS list | Known minor variance (QA-106218 noted) — non-blocking |

## Network expectations

| Endpoint | Method | Expected status | Notes |
|----------|--------|-----------------|-------|
| `/api/.../custom_data_sets` (list) | GET | 200 | Loads list page |
| `/api/.../custom_data_sets` (create) | POST | 201 | `{ name, description, metric_keys: [...] }` |
| `/api/.../brand_content?data_set_id=<n>` | GET | 200 | Posts data shaped by the selected CDS |

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows; 1 historical defects (all closed) are catalogued there.

## v2 — Delete flow (QA-104876 mutating create+delete cycle)

### Delete flow

The Actions ellipsis menu on each Custom Data Sets row exposes 3 options in order: `Edit / Delete / Duplicate`.

**Click Delete → confirmation modal:**
```
Title: Delete
Body:  Are you absolutely sure you want to delete your data set '<name>'? Click 'Ok' to continue.
Buttons: Cancel + Ok
```

**Verbatim modal text confirmed** in QA-104876 batch 6 run on 2026-06-08 with CDS name `QA-104876-test-1780915800`. Same confirmation-modal pattern as Custom Metrics (QA-135430) and Brand Sets (QA-110083) — consistent UX across Settings entities.

**On Ok click:**
- Row immediately removed from listing (<2 seconds).
- F5 refresh: deletion persistent.

### Mutating create+delete cycle pattern (for safe testing)

For tests that need both create + delete flow exercised in the same session:
1. **Create** with a unique timestamped name (e.g., `QA-104876-test-<epoch>` or `QA-104876-test-1780915800`).
2. **Verify row present** in listing.
3. **Delete** via Actions → Delete → Ok.
4. **F5** to confirm persistence.

Listing count returns to N-1 pre-create rows. No mutation persists across the test.

## Additional Failure signatures (v2)

| Signature | Interpretation | Action |
|---|---|---|
| Delete confirmation modal body missing the CDS name | UX consistency drift across Settings entities | File bug |
| Row not removed after Ok click | Delete API failed silently | Check console for 4xx/5xx |
| F5 refresh restores the deleted row | Delete not persisting server-side | File bug |
| Actions menu order ≠ `Edit / Delete / Duplicate` | UI regression | File bug |

## Changelog

- **v2** (2026-06-08): Delete flow (QA-104876 mutating create+delete cycle). Documents the verbatim confirmation modal text, the F5-persistent deletion behavior, and the consistent confirmation-modal pattern shared across Settings entities (custom metrics / custom data sets / brand sets / users).
- **v1** (2026-05-27): initial skill — QA-104870 (Basic View), QA-106218 (Create), QA-109062 (Brand>Content export). All PASS in original session; documented retroactively on 2026-05-29 as part of the cross-batch skill/KB sweep.
