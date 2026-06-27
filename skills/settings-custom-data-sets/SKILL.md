---
name: settings-custom-data-sets
version: 3
last_verified: 2026-06-27
last_passed_run: 2026-06-27
trust: stable
pass_streak: 10
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
- **QA-104876** (Delete) — PASS 3/3 (2026-06-27 reconfirm). Create→Delete→reload cycle on Amazon Prime Video; verbatim confirmation modal; refresh-persistent.
- **QA-104870** (Basic View) — PASS 12/13 + 1 N/A (2026-06-27 reconfirm). Dropdown order, breadcrumb, description text, Actions menu order all match.
- **QA-106218** (Create) — PASS 14/14 (2026-06-27 reconfirm). 7-metric build with lock-icon parity; timestamp format variance non-blocking.
- **QA-106221** (Edit) — PASS 5/5 (2026-06-27, **edit flow first exercised**). Reorder via keyboard DnD, delete #7, search-add Twitter Views, save-persist.

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

## v3 — Edit flow (QA-106221 reorder / delete / search-add / save-persist)

The Actions ellipsis → **Edit** opens `/#custom-data-sets/edit?...&report_id=<n>` with header `Edit Custom Data Set` (sole `<h1>`). The Selected Metrics table is the same widget as Create, plus reorder affordances.

### Reorder a metric (keyboard-accessible DnD — preferred over synthetic mouse drag)
Jira flags step-4 drag as "Not Recommended" for automation; use the product's own accessible DnD instead of a mouse drag:
- Each row is `<tr aria-roledescription="You are currently at a draggable item at position N. Press space bar to lift.">` and exposes a Position `<input type=number min=1 max=7>` cell.
- **Sequence:** focus the row → `Space` (lift) → `ArrowDown`/`ArrowUp` ×k → `Space` (drop).
- **Verify** via the page's own `role=log` live region, e.g. `You have dropped the item. It has moved from position 1 to 3.` (Second reorder path: type the target rank into the Position spinbutton — available, not required.)

### Delete a metric within Edit
- Click the row's Remove (trash) button. Header count decrements, e.g. `Selected Metrics (7)` → `Selected Metrics (6)`. (Distinct from deleting the whole CDS — that is the v2 Actions→Delete flow.)

### Search-and-add a channel-scoped metric
- Type into **Search Metric Name** (e.g. `Views`) → tree filters to matching leaves under each channel.
- The **same metric label can appear under multiple channels** (e.g. `Views` under Twitter / Instagram / Threads, each a distinct DCR key). Pick the spec-named channel's leaf — verify by the single channel icon on the added row and the DCR key (e.g. Twitter `Views` = `twitter.post.public_impressions`).

### Save
- Click **Save** → navigates straight to the listing; the row's Metrics cell reflects the final order. **No success toast/modal is shown** on Save (same as Create — see note below).

### Dependency / precondition note
QA-106221's spec depends on a CDS with a known initial order (Impressions at #7) left by QA-106218 — but QA-106218 self-cleans (deletes its CDS). A faithful run **recreates the exact initial-order CDS via the Create flow** as setup, then deletes it post-test. Do not substitute a differently-ordered pre-existing CDS.

## Additional Failure signatures (v3)

| Signature | Interpretation | Action |
|---|---|---|
| Edit header ≠ `Edit Custom Data Set` | Wrong route / UI regression | Investigate |
| Reorder live-region not announcing position change | Keyboard DnD not wired | File bug |
| Added "Views" row shows >1 channel icon | Wrong leaf selected (label collides across channels) | Re-pick spec channel |

## Notes / Observations (carry-forward)

- **No "Success" toast/modal on Create or Save** under Playwright (v1 noted a `Custom data set successfully created!` Ok modal; not observed on the 2026-06-27 runs — navigation to the listing is the only confirmation). A11 (Create) and Save assertions require navigation only, so this is non-blocking; noted for skill accuracy.
- **Checkboxes/remove accept Playwright trusted clicks directly** — the Chrome-MCP `controlled-check-box` focus+Space workaround is **not** needed under Playwright.
- **Account context not inherited on the Settings surface** — the Custom Data Sets page may load under a Recent-Searches account (e.g. Hulu) instead of the active Home account; switch via user-menu → Search Account → Results entry before evaluating. See `known-quirks.md`.

## Changelog

- **v3** (2026-06-27): Edit flow (QA-106221) — keyboard-accessible DnD reorder + live-region verification, in-Edit metric delete, search-and-add of a channel-scoped metric (label-collides-across-channels caveat), save-persistence with no success toast, and the QA-106218→QA-106221 precondition-recreate pattern. **Promoted untrusted → stable** (passes on separate days 2026-06-02, 2026-06-08, 2026-06-27).
- **v2** (2026-06-08): Delete flow (QA-104876 mutating create+delete cycle). Documents the verbatim confirmation modal text, the F5-persistent deletion behavior, and the consistent confirmation-modal pattern shared across Settings entities (custom metrics / custom data sets / brand sets / users).
- **v1** (2026-05-27): initial skill — QA-104870 (Basic View), QA-106218 (Create), QA-109062 (Brand>Content export). All PASS in original session; documented retroactively on 2026-05-29 as part of the cross-batch skill/KB sweep.
