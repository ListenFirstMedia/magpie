---
name: settings-custom-metrics
version: 3
last_verified: 2026-07-14
last_passed_run: 2026-07-14
trust: untrusted
pass_streak: 12
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
- **Assertion:** Dropdown shows options in order: `Metrics`, `Constant`, `Operators`, `Parentheses` (4th item added since 2026-07-14 — see v3 changelog). **`Operators` is initially DISABLED (greyed)**, others enabled — a formula cannot start with an operator. (Spec writes `Constants` plural; UI shows `Constant` singular — known-quirks documented.)

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

## v3 — Parentheses menu, account-gating, BODMAS (QA-139187)

### Parentheses in the formula builder
The formula dropdown now has a **4th top-level option: `Parentheses ▶`** (order: Metrics / Constant / Operators / **Parentheses**). Its submenu offers two chips: **`(`** and **`)`**. A parenthetical formula like `( Comments + Engagements × 2 )` is built as: Parentheses→`(`, Metrics→ListenFirst→Comments, Operators→`+`, Metrics→ListenFirst→Engagements, Operators→`×`, Constant→`2`, Parentheses→`)`. **Save stays disabled while a `(` is unclosed; closing `)` enables Save.** On Save: standard "Custom metric successfully created!" modal, no validation error (QA-139187 A3 PASS).

### Custom Metrics is ACCOUNT-GATED
"Custom Metrics" appears in the Settings menu for some accounts (e.g. **Adam Orfei**) but NOT others (e.g. **Hulu**). Under a non-entitled account, navigating `#custom-metrics` renders a **blank page**. When a case's precondition names an account (e.g. "logged in as Adam Orfei"), switch to it first — the feature won't be reachable otherwise. ([[account-precondition]])

### BODMAS verification via TWC
To prove operator precedence (QA-139187 A5): create the metric, then in TWC (Authorized, e.g. MTV) select the **custom metric AND its component metrics** (same names, e.g. ListenFirst `Comments` + `Engagements` via the metric Filter box), run, and check `custom == Comments + 2×Engagements` per row (NOT `(Comments+Engagements)×2`). All 7 daily rows matched exactly → precedence correct.
- ⚠ **TWC gotcha:** toggling the per-brand Authorized switch (`label[for="0-perspective-toggle"]`) **AFTER** selecting metrics DROPS the earlier selections — the custom metric silently fails to render in the output. **Set Authorized FIRST, then select all metrics**, then Run.

### Max-limit validation (A7/A8) — NOT YET CAPTURED
QA-139187 A7/A8 expect, at an 11-part formula: "You've reached the max limit of metric selection in your Custom Metric. You can still close ')' to finish the formula." (Save disabled while `(` open) → closing `)` keeps a max-limit message and enables Save. **Not yet verified** — building 11 operands via the dropdown is very high-interaction, and under automation a re-entered **Constant replaces the trailing operand instead of appending** (state hard to track). Needs a focused run; document the exact max-count when captured.

## v4 — Constant value validation (QA-135322)

The Constant chip's input is `input.formula-constant-input` (type=number). App-level validation enforces a **positive range 1–1000**:
- **1001 / 0 / negatives** → inline error **"Constant must be between 1 and 1000."**, chip invalid, **Save disabled**.
- **Positive decimals** (e.g. `99.99`) accepted, no rounding; the error clears on a valid value.
- Non-numeric chars (letters except `e`, special chars except `-` `.`) are stripped by the number input (`ab@5` → `5`).
- **⚠ Spec discrepancy (QA-135322 A5e = FAILED):** the test case expects **negatives accepted** (e.g. `-500`, negative sign as first char), but the field **rejects all negatives** with the 1–1000 message. Either a product bug or an outdated spec — flag for QA triage, do NOT auto-file. Because negatives/0 can't be entered, any assertion about *saving* a metric with a negative/zero constant (e.g. A5c/A5e/13b) is unreachable on this build.
- **Automation note:** the operator submenu leaves render as FontAwesome icons (`i.fa-regular.fa-plus/minus/times/divide`) with **empty text** — after hovering the `Operators ▶` `.menu-item` row (real hover), click the empty-text `.menu-item` carrying the `fa-plus` icon (text-based selectors miss them). A lone metric or lone constant leaves **Save disabled** — a saveable formula needs a full expression (operand + operator + operand).

## Additional Failure signatures (v2)

| Signature | Interpretation | Action |
|---|---|---|
| Operators dropdown shows only `+ −` (no `× ÷`) | APPS-60358 implementation regression | File bug |
| Edit option absent from Actions ellipsis | UI regression | File bug |
| Edit form does not prefill Name/Description/Formula | React state-restore regression | File bug |
| × chip renders without `fa-times` icon | Icon class regression | File bug |
| TWC custom-metric column renders blank instead of calculated value | Calc engine regression | File bug |
| Formula-popup doesn't reopen after first chip addition | Automation-only friction (React handler re-binding lag) | Wait 2-3s; refresh + restart if persistent |

## v3 — Parentheses option + Actions-menu row-mapping caution (2026-07-14)

### New "Parentheses" formula-builder option (QA-85176 reconfirm)

The formula dropdown now shows **4** top-level options — `Metrics`, `Constant`, `Operators`, `Parentheses` — not 3. `Parentheses` follows the same alternation rules as `Metrics`/`Constant` (enabled at formula start and after an operator, greyed immediately after a metric/constant/close-paren). Not a spec violation — the spec only asserts presence of the original 3 + Operators' disabled state, which still holds. Treat a 4-item dropdown as expected going forward; a 3-item dropdown would now be a regression (Parentheses removed).

### Actions-menu ellipsis button does NOT reliably map to its own row by DOM order (CAUTION)

**Symptom:** Clicking the Actions `...` button located in the same row as the target metric (found via `browser_find`/snapshot ref) can open the **dropdown for a different row** — observed opening Edit/Delete for an unrelated pre-existing metric ("PC Test 1") when the snapshot ref for the ellipsis button was taken from a stale/re-rendered snapshot after scrolling. The dropdown's visual position also does not reliably indicate which row it's bound to (it can render anchored near an adjacent row).

**Workaround (mandatory for Delete flows):** 
1. Tag the exact row via `browser_evaluate`: find `tr` whose `textContent` includes the unique test-metric name, `setAttribute('data-qa-target-row','true')`.
2. Click `tr[data-qa-target-row="true"] button` (not a snapshot ref).
3. **Before clicking Ok on the Delete confirmation modal, always read the modal body text and verify it names the exact expected metric** (e.g. `document.body.textContent.match(/Are you absolutely sure.{0,120}/)`). If it names the wrong entity, click Cancel — do not proceed.

This is a hard requirement, not a nice-to-have: a wrong-row Delete would destroy another user's data with no undo.

## Changelog

- **v4** (2026-07-10): +Constant value validation from QA-135322 (Constants) — positive 1–1000 range, 0/negatives/1001 rejected with "Constant must be between 1 and 1000.", decimals OK; **A5e FAILED** (spec expects negatives accepted, UI rejects — discrepancy flagged, no auto-file). Added operator-leaf-icon selector detail + "lone operand → Save disabled". QA-135430 (Delete) re-confirmed PASS with cleanup.
- **v3** (2026-07-03): +1 from QA-139187 (Parenthetical Expressions — A3 Save-with-parentheses + A5 BODMAS both PASS; A7/A8 max-limit not yet captured). Added the **Parentheses** formula-menu option (`(`/`)`), **account-gating** of the Custom Metrics feature (Adam Orfei yes, Hulu no — blank page otherwise), **BODMAS verification via TWC** (select custom + component metrics, compare per-row) with the **Authorized-toggle-drops-selections** gotcha (set Authorized before selecting metrics), and a note that the max-limit validation (A7/A8) remains uncaptured (Constant re-entry replaces trailing operand under automation).
- **v3** (2026-07-14): QA-85176 reconfirm PASS (14/14). Documents new 4th "Parentheses" formula-dropdown option (additive, not a regression). Adds mandatory Actions-menu row-verification workaround for Delete flows after a near-miss where the ellipsis click opened the wrong row's dropdown (caught before confirming, via modal-text verification — no data lost).
- **v2** (2026-06-08): Edit flow (QA-135429); × ÷ operators APPS-60358 implementation verified end-to-end via 4-icon FontAwesome enumeration (QA-137557 reaches Create; QA-137558 ↔ TWC verification); Save modal Constant-vs-Constants drift retained; Delete flow stays in this skill; APPS-60358 4-operator dropdown enumerated NOT REPRODUCED as a bug. +9 streak across batches: QA-85176, QA-134173, QA-134185, QA-135430, QA-75011, QA-85176 RECONFIRM, QA-135429, QA-137557, QA-137558.
- **v1** (2026-05-29): initial skill — created from QA-85176, QA-134173, QA-134185 (PASS / PASS / PASS). Documents formula-builder strict-alternation, X-removal cycle, Info-mode tooltip toggle on both list and create pages, and the three known spec/UI copy drifts.
