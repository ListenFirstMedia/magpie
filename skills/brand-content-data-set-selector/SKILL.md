---
name: brand-content-data-set-selector
version: 1
last_verified: 2026-06-28
last_passed_run: 2026-06-28
trust: stable
pass_streak: 34
preconditions: [user-logged-in, account-set]
postconditions: [data-set-applied-on-brand-content]
inputs: [brand_id, data_set_name]
outputs: [active_data_set_name, custom_data_set_count_visible]
related_pages: ["/#explore/brand/content"]
---

# Pick a Data Set on Brand > Content

Open the **Data Set** dropdown on Brand > Content and select a specific data set, including any user-created custom data set from Settings > Custom Data Sets.

## Steps

### Step 1 — Navigate to Brand > Content for the target brand
- Direct URL: `https://app.lfmdev.in/#explore/brand/content?brand_id={brand_id}&account_id={account_id}`

### Step 2 — Open the Data Set dropdown
- The dropdown is labeled `Data Set:` above the channel ghost row.
- Click it; the dropdown is divided into three sections by visible headers:
  1. **Cross-Channel Metrics** — Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels.
  2. **Channel-Specific Metrics** — Facebook Only / Twitter Only / Instagram Only / YouTube Only / Threads Only / Pinterest Only variants.
  3. **Custom Data Set** — the test user's saved sets from Settings > Custom Data Sets. (Header is singular `Custom Data Set`, not "Custom Data Sets".)

### Step 3 — Click a custom data set by name
- Locate the entry under the `Custom Data Set` header using JS that filters by `compareDocumentPosition` after the header element:

```javascript
const header = [...document.querySelectorAll('*')].find(el =>
  (el.textContent || '').trim() === 'Custom Data Set' && el.children.length === 0
);
const target = [...document.querySelectorAll('*')].find(el =>
  (el.textContent || '').trim() === '<data_set_name>' &&
  el.children.length < 3 &&
  el.offsetWidth > 0 &&
  (header.compareDocumentPosition(el) & Node.DOCUMENT_POSITION_FOLLOWING)
);
target?.click();
```

### Step 4 — Verify the data set is applied
- The dropdown trigger label should change from `Public` (or whatever was previously selected) to the chosen data set name.
- The metrics shown in the page below should match the metrics defined for that custom data set in Settings.

## Known finding (verify each run)

**The display order in this dropdown does NOT match the creation order from Settings > Custom Data Sets** (observed during QA-109059 run on 2026-05-13). The first N items are in ascending created-at order, but older items appear at the bottom out of place. If a test asserts "displayed in created order", flag the mismatch and capture the actual order alongside the creation timestamps. Possibly fixed in future builds — re-verify each run.

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| No `Custom Data Set` section in the dropdown | The account has zero custom data sets, OR the section was removed | check Settings > Custom Data Sets in a new tab; report if sets exist but section is missing |
| Clicking a custom data set doesn't change the trigger label | Selection didn't take | re-try with a real coordinate click on the option |
| Section header reads something other than `Custom Data Set` | Copy change — STALE SKILL CANDIDATE | flag |

## Known bug history

See `knowledge-base/bug-history.md` for the full per-ticket bug list. Highest-priority open bugs currently tied to this skill's flows:

- APPS-57985 (High) — Thumbnail Issue for LinkedIn Posts     [from QA-98368]
- LFMP-31886 (Minor) — Data Display Inconsistency: Benchmark Owned Average Row value missing parentheses in Video views column     [from QA-2706]

## Headed-Playwright mechanics + Impressions-data-set lock behavior (QA-520, 2026-07-02)

- **Change the brand on Brand>Content:** click the **chevron next to the heart** (`.brand-selector-dropdown-container i.fa-chevron-down`, TRUSTED click) → a **`textarea.lfm-textarea` placeholder "Search for a Brand"** appears (it's a textarea, NOT an `<input>`; set via React textarea setter + `input` event) → click the `.lfm-ta-option` result.
- **Channel = single (e.g. Facebook only):** the channel toggles are `.channel-ghost.<name>.enabled`; disable the unwanted ones with **TRUSTED clicks** (synthetic no-op), then click **Apply** (`channels=facebook` in URL).
- **Data Set dropdown** (`.lfm-dropdown-select-box`) needs a **TRUSTED click** to fully render the option list (a synthetic click showed a truncated list of only Public/Engagements); then click the `.lfm-dropdown-option` (e.g. "Impressions"). Full FB list incl. Impressions/Video Views/Clicks/Reels/etc.
- **Impressions data set on an UNAUTHORIZED brand (e.g. Star Wars, Facebook):** aggregate shows **only Engagements** with a value; all Impression/Reach metrics are **locked** (`.fa-lock`). Verified pattern — **Sum:** Engagements value, Engagement Rate/Reach/Organic Reach/Paid Reach/Engaged User Rate = **N/A**, Impressions/Organic/Paid Impressions = **–**. **Average:** Engagements = avg, all others = **–**. (Aggregate Sum/Average toggle: see brand-content-table-view — Table-View-only.)

## Export pop-up — context-dependent data-set enablement (QA-1519, 2026-07-02)

The **Export** button (`.cta-wrapper.call-to-action-button.content-export-btn`; click the inner CTA, the outer `.content-export-btn` div intercepts pointer events; it's briefly `disabled` while a new data set's table loads — wait) opens **"Export Select Data Sets"** (View: CSV / Google Sheets toggle). The pop-up:
- Pre-checks **only the currently-active data set** (e.g. selecting "Engagements Breakdown" as the table data set → only that box is checked on open).
- The **enabled vs disabled** set of checkboxes depends on the active data set's **channel compatibility**:
  - **Engagements Breakdown** → Instagram-Only sets ENABLED, Facebook-Only sets DISABLED.
  - **Clicks** → Facebook-Only sets ENABLED, Instagram-Only sets DISABLED.
  - In both, **Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, Twitter Only: Engagements & Follows, YouTube Only: Basic/Insights/Premium/Subscribers & Playlists/Cards** stay enabled; **Threads-Only, Pinterest-Only, and custom (brand-specific) sets** are disabled.
- Detect state in JS: iterate `.controlled-check-box`/`label` rows; `disabled` = class `disabled` OR ancestor `[class*=disabled]` OR `opacity<0.6` OR `input.disabled`; `checked` = `input.checked`/`aria-checked`.
- **Export delivery is async by EMAIL** (banner: "an email to lfqa@listenfirstmedia.com"), NOT a synchronous file download (unlike TWC/Stories). Verifying the emailed CSV/filename/columns and Google Sheets is **out of scope** on the Playwright track (email inbox + Google 2FA). Verify the in-app pop-up (selection + enablement) and defer the emailed-artifact assertions.

## Changelog
- **v1** (2026-05-13): Initial draft from QA-109059. Section presence verified; creation-order assertion flagged as a bug.
- **v1.1** (2026-07-02): Headed-Playwright brand-change (chevron→textarea→.lfm-ta-option), single-channel trusted-click + Apply, data-set dropdown trusted-click, Impressions-data-set lock/N-A/– aggregate pattern (QA-520).
