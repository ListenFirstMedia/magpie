---
name: settings-custom-metrics
version: 2
last_verified: 2026-06-08
last_passed_run: 2026-06-08
trust: untrusted
pass_streak: 11
preconditions: [account-context]
postconditions: [custom-metric-row-present, info-mode-toggled-off]
inputs: [metric_name, metric_description, formula_tokens]
outputs: [new_metric_id]
related_pages: ["/#custom-metrics", "/#custom-metrics/create"]
---

# Settings > Custom Metrics — Create flow + Info View tooltip

Two tightly-coupled flows on Settings > Custom Metrics:
1. **Create a Custom Metric** — strict-alternation formula builder (metric/constant → operator → metric/constant) with X-removal on every chip.
2. **Info View** — a single Info button that toggles a persistent lower-left tooltip that dynamically updates as the user hovers form elements / columns.

Used by:
- **QA-85176** (Create flow) — full end-to-end PASS.
- **QA-134173** (Info View on list page) — PASS.
- **QA-134185** (Info View on Create page) — PASS, with N/A on the spec's missing `Metric Definition Link` element.

## Steps

### Step 1 — Navigate to Custom Metrics list
- **Action:** Top nav → Settings → Custom Metrics.
- **URL:** `/#custom-metrics`.
- **Assertion:** Table columns visible in order: `Metric`, `Description`, `Created Date`, `Creator`, `Formula`, `Actions`. `Create a Custom Metric` button (yellow) top-right.

### Step 2 — Verify Info-mode tooltip toggle on list page
- **Action:** Hover `Metric` column with Info OFF → no tooltip. Click `Info` button (top-right next to `Help Center`) → button switches to filled-blue state. Hover each column in turn.
- **Expected tooltip headers** (exact strings; note the `Created Date` ↔ `Date Created` swap, documented in known-quirks):
  - `Metric` → `The name of your custom metric`
  - `Description` → `The description of your custom metric`
  - `Date Created` → `The date when your custom metric was created`
  - `Creator` → `The user who created your custom metric`
  - `Formula` → `The formula that makes up your custom metric`
- Click Info again → returns to neutral; hovering produces no tooltip.

### Step 3 — Open Create Custom Metric
- **Action:** Click `Create a Custom Metric`.
- **URL:** `/#custom-metrics/create`.
- **Assertion:** `Save` button initially DISABLED (greyed). Three input rows: `Name`, `Description`, `Configure your metric formula`.

### Step 4 — Verify Info-mode tooltip toggle on Create page
- **Action:** Click `Info` button.
- **With cursor in empty area** → generic page tooltip: `Create Custom Metrics` / `This screen allows you to create your custom metrics`.
- **Hover Name** → `Name` / `Enter a name for your custom metric`.
- **Hover Description** → `Description` / `Enter a description for your custom metric`.
- **Hover Formula** → `Formula` / `Enter a formula for your custom metric`.
- The spec's `Metric Definition Link` element does NOT exist in the current build — mark that assertion N/A (see known-quirks: Custom Metrics page — spec/UI copy drift).
- Click Info again → no tooltip on hover.

### Step 5 — Enter Name and Description
- **Action:** Type into Name (e.g. `QA-85176 Sample Metric`) and Description fields.
- **Assertion:** Save still disabled; formula is empty.

### Step 6 — Open formula dropdown and verify initial state
- **Action:** Click `Configure your metric formula`.
- **Assertion:** Dropdown shows three options in order: `Metrics`, `Constant`, `Operators`. **`Operators` is initially DISABLED (greyed)** — a formula cannot start with an operator. (Spec writes `Constants` plural; UI shows `Constant` singular — known-quirks documented.)

### Step 7 — Hover Metrics to reveal channel sub-list
- **Action:** Hover `Metrics`.
- **Assertion:** Channel sub-list appears in this exact order: `ListenFirst`, `Facebook`, `Twitter`, `YouTube`, `Instagram`, `TikTok`, `Wikipedia`.

### Step 8 — Pick a metric
- **Action:** Hover a channel (e.g. `Facebook`), then click a metric (e.g. `Post Comments`).
- **Assertion:** Each metric in the sub-list renders as `<channel icon> + metric name + DCR key` (e.g. `Post Comments` → `facebook.page.total_post_comments_c`). Click adds a chip to the formula bar with X close button.

### Step 9 — Verify Operators enable
- **Action:** Reopen formula dropdown.
- **Assertion:** `Operators` is now ENABLED.
- Hover Operators → sub-list shows `+`, `−`, `×`, `÷`. Click `+` (or another operator). Operator chip appended.

### Step 10 — Verify Operators auto-grey after operator
- **Action:** Reopen formula dropdown.
- **Assertion:** `Operators` is GREYED again (cannot place two consecutive operators).

### Step 11 — Add second metric
- **Action:** Metrics → channel → metric → click. Formula bar now `<metric1> <operator> <metric2>`.
- **Assertion:** `Save` button is now ENABLED (yellow).

### Step 12 — Verify X-removal cycle
- **Action:** Click X on last metric chip → metric removed; trailing operator left; Save disabled. Click X on operator chip → operator removed; only first metric remains; Save still disabled.
- Re-add operator + metric to restore a valid formula and re-enable Save.

### Step 13 — Save
- **Action:** Click Save.
- **Assertion:** Modal popup `Success / Custom metric successfully created!` with `Ok` button.
- Click Ok → redirected to `/#custom-metrics`; new row visible with the entered Name, Description, and today's `Created Date`.

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| Operators not greyed when formula is empty | Spec violation — formula builder no longer enforces alternation start | File bug |
| Operators not greyed after an operator chip | Spec violation — two-operator sequences possible | File bug |
| Save enabled with dangling operator | Spec violation | File bug |
| Success modal does not appear after Save | Likely server error — read network panel for 4xx/5xx on `/api/.../custom_metrics` | File bug |
| Channel sub-list order differs from spec | UI regression | File bug with screenshot |
| Tooltip header does not match the documented exact strings | Either copy regression (file bug) OR new spec/UI drift (file copy-sync ticket) | Investigate |
| `Metric Definition Link` element appears | Element was restored — update this skill + remove the corresponding known-quirks entry | Skill update |

## Network expectations

| Endpoint | Method | Expected status | Notes |
|----------|--------|-----------------|-------|
| `/api/.../custom_metrics` (list) | GET | 200 | Loads the list page |
| `/api/.../custom_metrics` (create) | POST | 201 | Body: `{ name, description, formula }`. Returns new `id`. |

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows; 1 historical defects (all closed) are catalogued there.

## v2 — Edit flow + × ÷ operators + Delete flow (2026-06-08)

### Edit flow (QA-135429)

The Actions ellipsis menu on each Custom Metrics row exposes an `Edit` option in addition to `Delete` / `Duplicate`.

- **URL on Edit click:** `#custom-metrics/edit?report_id={id}`.
- **Form prefills:**
  - `Name` text input: the metric name.
  - `Description` textarea: the metric description.
  - Formula builder area: each chip re-rendered with its channel icon + label.
- **Buttons:** `Cancel` + `Save`.
- **Cancel:** returns to `#custom-metrics` list with the row unchanged.

**Safety:** A1+A2 (presence + prefill) can be verified read-only. A3+A4 (Save mutates) require a **self-owned sandbox metric** to exercise — never edit a metric owned by another user.

### × ÷ operators — APPS-60358 implementation (QA-137557, QA-137558)

The formula-builder Operators dropdown now exposes 4 operators (was 2 before APPS-60358):

| Operator | Icon class | Label |
|---|---|---|
| `+` | `fa-plus` | Addition |
| `−` | `fa-minus` | Subtraction |
| `×` | `fa-times` | Multiplication |
| `÷` | `fa-divide` | Division |

**Probe:**
```javascript
const items = [...document.querySelectorAll('.lfm-dropdown-option i[class*="fa-"]')]
  .map(i => i.className).filter(c => /fa-(plus|minus|times|divide)/.test(c));
// items.length === 4 → APPS-60358 implementation present
```

**Verdict:** if exactly 4 operator-icon items are enumerated under Operators → APPS-60358 implementation present (NOT REPRODUCED as a bug).

The `×` chip renders with `i.fa-regular.fa-times` in the formula editor. Selecting `×` after `Post Comments` produces the 2-chip formula `[Post Comments, ×]` — Save remains disabled until a 3rd chip is added per strict-alternation rule.

### TWC verification of all-operators custom metric (QA-137558)

After creating a metric with all 4 operators (e.g., `[Post Comments, +, Post Likes, −, Shares, ×, 2, ÷, 100]`):
1. Reporting > TWC.
2. Add brand.
3. In Filter Metrics search input, type the custom metric name.
4. Click the custom-metric checkbox (Custom Metrics section).
5. Run Report → results table column renders with the custom metric value cell.

### Automation-only friction: formula-popup re-open after chip add

After each chip addition, the React click-handler on the formula input gets unmounted/remounted. Subsequent coordinate clicks at the formula input row often DON'T re-trigger the builder popup until React re-binds.

**Workaround:** wait ~2-3s after each chip addition before clicking the formula input again. If that fails, refresh the page and re-build from start. Automation-only — end-users with hardware mouse click normally.

### Delete flow stays in this skill (QA-135430, QA-104876 carry-pattern)

The Delete flow stays in `settings-custom-metrics` rather than being split off, because the confirmation modal pattern is shared across all Settings entities (custom metrics, custom data sets, brand sets, users):
```
Title: Delete
Body:  Are you absolutely sure you want to delete your <entity> '<name>'? Click 'Ok' to continue.
Buttons: Cancel + Ok
```

After Ok click: row immediately removed from listing; F5-refresh-persistent.

## Additional Failure signatures (v2)

| Signature | Interpretation | Action |
|---|---|---|
| Operators dropdown shows only `+ −` (no `× ÷`) | APPS-60358 implementation regression | File bug |
| Edit option absent from Actions ellipsis | UI regression | File bug |
| Edit form does not prefill Name/Description/Formula | React state-restore regression | File bug |
| × chip renders without `fa-times` icon | Icon class regression | File bug |
| TWC custom-metric column renders blank instead of calculated value | Calc engine regression | File bug |
| Formula-popup doesn't reopen after first chip addition | Automation-only friction (React handler re-binding lag) | Wait 2-3s; refresh + restart if persistent |

## Changelog

- **v2** (2026-06-08): Edit flow (QA-135429); × ÷ operators APPS-60358 implementation verified end-to-end via 4-icon FontAwesome enumeration (QA-137557 reaches Create; QA-137558 ↔ TWC verification); Save modal Constant-vs-Constants drift retained; Delete flow stays in this skill; APPS-60358 4-operator dropdown enumerated NOT REPRODUCED as a bug. +9 streak across batches: QA-85176, QA-134173, QA-134185, QA-135430, QA-75011, QA-85176 RECONFIRM, QA-135429, QA-137557, QA-137558.
- **v1** (2026-05-29): initial skill — created from QA-85176, QA-134173, QA-134185 (PASS / PASS / PASS). Documents formula-builder strict-alternation, X-removal cycle, Info-mode tooltip toggle on both list and create pages, and the three known spec/UI copy drifts.
