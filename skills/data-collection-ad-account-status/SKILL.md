---
name: data-collection-ad-account-status
version: 1
last_verified: 2026-05-13
last_passed_run: 2026-05-13
trust: untrusted
pass_streak: 1
preconditions: [user-logged-in]
postconditions: [ad-account-statuses-visible]
inputs: [brand_name, channel_name, page_name]
outputs: [ad_account_ids, ad_account_statuses, parent_row_has_status]
related_pages: ["/#data-collection"]
---

# Inspect Ad Account collection status in Settings > Data Collection

Drill into a brand → channel → page in Data Collection and expand a data feed that uses ad accounts to see per-AA statuses.

## Steps

### Step 1 — Navigate
- Direct URL: `https://app.lfmdev.in/#data-collection?account_id={account_id}` (or hover Settings → Data Collection).

### Step 2 — Search and select the brand
- The brand list shows "My Brands (N)" with a search box at top.
- Type `{brand_name}` (e.g., `Scorpion`); a single matching row appears.
- Click the row. URL becomes `/#data-collection/{brand_slug}?account_id=...`.

### Step 3 — Select channel
- The Channels column (middle) lists channels with page counts (e.g., `Facebook 1 PAGE`).
- Click the target channel row.

### Step 4 — Select page
- The Pages column (right) shows pages for the selected brand+channel.
- Click the page row.

### Step 5 — Read the Data Collection Summary table
- The right pane now shows a table with columns: `Data Feed | Start Date | Last Collection Date | Status`.
- Data feeds that aggregate multiple sub-accounts (typically the `Facebook & Instagram Ads (Authorized)` row) have an Expand chevron (˅) on the right and an empty Status cell.

### Step 6 — Expand the ad-account-bearing data feed
- Click the chevron on the right of the row.
- A nested sub-table appears with header `Ad Account` and rows: `act_XXXXXXXXX | <Start> | <Last Collection> | <Status>`.

## What to capture

```javascript
// Detect the parent row's status text and child row statuses
const parentRow = [...document.querySelectorAll('tr,[role="row"]')].find(r => /Facebook & Instagram Ads/.test(r.textContent||''));
const parentHasStatus = /Collecting|Not Collecting/.test(parentRow?.textContent||'');
// Children with `act_` IDs are the ad-account rows
const adRows = [...document.querySelectorAll('tr,[role="row"]')]
  .filter(r => /act_\d+/.test(r.textContent||''))
  .map(r => (r.textContent||'').trim());
```

## Assertion patterns

For tests like QA-127567:
- **Single AA → overall reflects that AA's status:** If the parent data-feed has exactly 1 child, the parent's Status cell should match the child's Status text.
- **Multiple AAs → parent Status is empty:** When `>=2` children exist, `parentHasStatus === false`.
- **Per-row only:** Each child row has its own Status; parent does NOT (the same condition as the previous assertion).

## Known quirks observed

- The expand chevron has no `data-testid` — locate by row text + position. The clickable area is the rightmost column of the parent row.
- The Status column is empty (no whitespace) for multi-AA parents — `textContent` won't return "Empty" or any placeholder.

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows; 0 historical defects (all closed) are catalogued there.

## Changelog
- **v1** (2026-05-13): Initial draft from QA-127567 run. Verified for Scorpion/Facebook/Scorpion-page with 2 ad accounts both showing "Not Collecting".
