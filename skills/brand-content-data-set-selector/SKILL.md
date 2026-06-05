---
name: brand-content-data-set-selector
version: 1
last_verified: 2026-05-13
last_passed_run: 2026-05-13
trust: untrusted
pass_streak: 1
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

## Changelog
- **v1** (2026-05-13): Initial draft from QA-109059. Section presence verified; creation-order assertion flagged as a bug.
