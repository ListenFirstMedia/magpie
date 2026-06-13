---
name: data-collection-channel-status
version: 1
last_verified: 2026-06-08
last_passed_run: 2026-06-08
trust: untrusted
pass_streak: 1
preconditions: [account-context]
postconditions: [channel-status-icons-validated]
inputs: [brand_slug, channel, page_id]
outputs: [feed_status_map, last_collection_date]
related_pages: ["/#data-collection", "/#data-collection/<brand>/<channel>/page/<page_id>"]
related_skills: [data-collection-ad-account-status, data-collection-brand-popup]
---

# Settings > Data Collection — Channel / Page Status Icon Validation

End-to-end skill for the per-page Data Collection Summary at Settings > Data Collection drilled down to a brand → channel → page. Validates the status-icon mapping (Collecting green / Not Collecting red / To Do blue) and the `Last Collection Date = current_date - 1` rule for actively-collecting feeds.

Distinct from `data-collection-ad-account-status` — that skill is for ad-account-level status; this skill is for channel/page-level feeds (e.g., Twitter Posts (Authorized), Twitter Page (Public), Twitter Earned Comments (Public)).

Used by:
- **QA-137874** (Data Collection - Channel Collection Status Validation 2) — PASS on Adam Orfei / Suits / Twitter (3 Not Collecting + 1 Collecting feeds verified; To Do state DEFERRED).

## Key UI structure

### Drill-down URL hash schema
```
#data-collection                                            → My Brands (5,231 rows)
#data-collection/<brand-slug>                               → Channels(9) panel for the brand
#data-collection/<brand-slug>/<channel>                     → Pages(N) panel for that channel
#data-collection/<brand-slug>/<channel>/page/<page-id>      → Data Collection Summary page
```

### Data Collection Summary page
- Header: `Attributed to <Brand> Jan 3, 2000 - Dec 31, 2027` + helper text `Click to reauthorize collection on any data feed`.
- Data Feed table (4 columns):
  - `Data Feed` — e.g., `Twitter Page (Public)`, `Twitter Posts (Public)`, `Twitter Earned Comments (Public)`, `Twitter Posts (Authorized)`, `Twitter Ads (Authorized)`.
  - `Start Date` — `MMM D YYYY`.
  - `Last Collection Date` — `MMM D, YYYY` (omitted for not-in-scope feeds like Twitter Ads).
  - `Status` — one of Collecting / Not Collecting / To Do (icon + label).

## Status icon mapping

| Status | Icon class | Computed color |
|---|---|---|
| **Collecting** | `icon fas fa-check-circle` | `rgb(0, 135, 128)` (teal-green) |
| **Not Collecting** | `icon fas fa-exclamation-circle` | `rgb(214, 79, 66)` (red) |
| **To Do** | `icon fas fa-plus-circle` (or `fa-plus`) | (blue — exact RGB not yet captured; pattern asserted) |

## Steps

### Step 1 — Navigate to Settings > Data Collection
- **Action:** `https://app.lfmdev.in/#data-collection?account_id={account_id}`.
- **Assertion:** My Brands panel renders with the account's brand list.

### Step 2 — Drill into a brand → channel → page
- **Action:** click the target brand row → `Channels(N)` panel renders with per-channel page counts → click the target channel row → `Pages(M)` panel renders → click the target page row.
- **URL transitions through:** `#data-collection/<brand-slug>` → `#data-collection/<brand-slug>/<channel>` → `#data-collection/<brand-slug>/<channel>/page/<page-id>`.
- **Assertion:** Data Collection Summary page renders with the 4-column data-feed table.

### Step 3 — Read the data-feed table
- **DOM probe per row:**
  ```javascript
  const rows = [...document.querySelectorAll('tr')]
    .filter(r => /Collecting|Not Collecting|To Do/.test(r.textContent));
  const cells = rows.map(r => {
    const tds = [...r.querySelectorAll('td')].map(c => c.textContent.trim());
    const icon = r.querySelector('i.icon');
    const rgb = icon ? getComputedStyle(icon).color : null;
    return { feed: tds[0], start: tds[1], last: tds[2], status: tds[3], iconClass: icon?.className, rgb };
  });
  ```

### Step 4 — Verify Collecting feed assertion
- **For each row where `status === 'Collecting'`:**
  - Icon class includes `fa-check-circle`.
  - Computed color = `rgb(0, 135, 128)`.
  - `Last Collection Date` parses to **current_date − 1** (e.g., today=Jun 8 2026 → Last=Jun 7 2026).
- **Assertion:** all three conditions hold.

### Step 5 — Verify Not Collecting feed assertion
- **For each row where `status === 'Not Collecting'`:**
  - Icon class includes `fa-exclamation-circle`.
  - Computed color = `rgb(214, 79, 66)`.
- **Assertion:** both conditions hold. `Last Collection Date` may be older than yesterday — that's the signal the feed has stopped.

### Step 6 — Verify To Do feed assertion (if surface exposes one)
- **For each row where `status === 'To Do'`:**
  - Icon class includes `fa-plus` (typically `fa-plus-circle`).
  - Computed color is blue (RGB not yet captured for regression-locking — log in run report when encountered).
- **NOTE:** QA-137874 DEFERRED this assertion because SuitsPeacock Twitter only exposed Collecting + Not Collecting rows. Pick a brand+channel where a feed has been configured but not yet attempted collection (e.g., a freshly-onboarded brand) to exercise this branch.

## Cross-source consistency

- For a `Collecting` feed (e.g., `Twitter Page (Public)`), the brand's Brand>Insights / Brand>Audience tile for that channel should populate with data through the `Last Collection Date`. (Cross-reference `brand-content-data-set-selector` skill.)
- For a `Not Collecting` feed, expect endash markers on Brand>Insights / Brand>Audience tiles for dates after the feed's `Last Collection Date`.

## Failure signatures

| Signature | Interpretation | Action |
|---|---|---|
| Collecting feed icon color ≠ `rgb(0, 135, 128)` | Color regression OR theme change | Capture RGB; if persistent across feeds, file UI ticket |
| Not Collecting feed icon color ≠ `rgb(214, 79, 66)` | Color regression OR theme change | Same |
| Collecting feed `Last Collection Date` ≠ today−1 | ETL ran later than usual OR feed actually delayed | If consistently off, file as freshness regression |
| To Do feed rendering with green check or red exclamation | Status enum drift | File bug |
| Drill-down URL stale (`/data-collection/<slug>/page/...` without channel) | URL schema regression | File bug |

## Network expectations

| Endpoint | Method | Expected status | Notes |
|---|---|---|---|
| `/api/.../data-collection/brands` | GET | 200 | My Brands list |
| `/api/.../data-collection/<brand>/channels` | GET | 200 | Channels(N) panel |
| `/api/.../data-collection/<brand>/<channel>/pages` | GET | 200 | Pages(M) panel |
| `/api/.../data-collection/page/<page-id>/feeds` | GET | 200 | Data feed table |

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows.

## Changelog

- **v1** (2026-06-08): Initial draft from QA-137874 PASS on Adam Orfei / Suits / Twitter. Documents the drill-down URL hash schema, the status icon class → RGB mapping (Collecting `fa-check-circle` rgb(0,135,128) / Not Collecting `fa-exclamation-circle` rgb(214,79,66) / To Do `fa-plus-circle` blue), and the `Last Collection Date = current_date − 1` rule for actively-collecting feeds. To Do state DEFERRED for future evidence capture.
