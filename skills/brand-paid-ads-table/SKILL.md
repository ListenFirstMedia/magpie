---
name: brand-paid-ads-table
version: 1
last_verified: 2026-06-11
last_passed_run: 2026-06-11
trust: untrusted
pass_streak: 1
preconditions: [user-logged-in, account-set, brand-has-paid-data]
postconditions: [ads-table-rendered]
inputs: [brand_id, account_id, channel]
outputs: [ads_count, group_rows]
related_pages: ["/#explore/brand/paid"]
---

# Brand > Paid — ads table, channel selection, Group Table by

Verified on Amazon Prime Video (brand 25864, account 342), Instagram, Jun 3–9 2026 (QA-121438).

## Steps

### Step 1 — Navigate WITH full date params
- `https://app.lfmdev.in/#explore/brand/paid?brand_id={id}&account_id={acc}&from=…&to=…&compare_from=…&compare_to=…&channels={ch}`
- **BUG/trap:** navigating with `from/to` but WITHOUT `compare_from/compare_to` renders "Compared to: Invalid date - Invalid date" and ALL tiles fail to load ("This tile failed to load") — reload does not recover. Always pass compare params (or none at all).

### Step 2 — Channel selection is SINGLE-SELECT
- Paid channel icons behave radio-like (like Insights ghosts): clicking Instagram auto-deselects Facebook. Click the target channel ghost, then the real Apply button (recompute coordinates fresh — Apply sits right of the icons).
- Top tiles: Active Ads / Paid Impressions / Spend (e.g. APV IG: 262 / 57.8M / $443K).

### Step 3 — Table View + Group Table by
- Ads section header `Ads (N)`; Layout icons right (Table/Grid/Detail — Grid default). Switch to Table View (first icon, coordinate click; verify via `th` headers: Rank, Date, Campaign, Author, Ad Type, Ad Name, Publish Type, Text, Spend, Paid Actions, Clicks, Outbound Clicks, Inline Clicks…).
- `Group Table by:` dropdown appears ONLY in Table View. Options: None, **Delivery Type**, Ads Account ID, Ads Account, Ad Type, Ad Set, Campaign, Campaign Objective.

### Step 4 — Delivery Type grouping
- Groups render as `Dark (N Ads)` / `Promoted (M Ads)` with N+M = total (69+193=262 verified).
- Groups start **collapsed** (4 visible tr's: 2 group headers + sum rows). Clicking a group row expands (+~69 rows); clicking the expanded group row collapses back. Verify by visible `tbody tr` count.

## Known quirks
- Sum/Average toggle row present above table (Sum default).
- Full-page Paid degradation precedent: Michael Kors 2026-06-04 (all tiles failed + export queue stuck) — distinct from the Invalid-date trap above.

## Changelog
- **v1** (2026-06-11): Initial from QA-121438 PASS.
