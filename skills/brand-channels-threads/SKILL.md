---
name: brand-channels-threads
version: 1
last_verified: 2026-06-08
last_passed_run: 2026-06-08
trust: untrusted
pass_streak: 1
preconditions: [account-context, brand-selected]
postconditions: [threads-channel-tile-rendered, cross-source-consistency-verified]
inputs: [brand_id, account_id, date_window]
outputs: [total_followers_value, new_posts_value]
related_pages: ["/#explore/brand/channels", "/#explore/brand/insights", "/#explore/brand/content"]
---

# Brand > Channels — Threads Basic View

End-to-end skill for verifying the Threads channel tile on Brand > Channels: tile metric set, cross-page consistency against Brand>Content's `Posts(N)`, and recovery from the documented Brand>Insights renderer freeze when filtered to Threads.

Used by:
- **QA-95190** (Brand > Channels - Threads Basic View) — A1+A2+A3+A5+A6 PASS; A4 (Brand>Insights cross-check) DEFERRED due to known renderer freeze.

## Key UI structure

Brand > Channels page header is the standard Brand header (Data Last Updated, perspective toggle, channel row). Body is a grid of per-channel tiles (Facebook / Twitter / Instagram / YouTube / TikTok / LinkedIn / Threads).

Each Threads tile shows 7 metrics:
```
Threads
Total Followers      <integer>          (<comparison-delta>)
New Followers        <integer or –>     (+<delta>)
Fan Growth Rate      <pct>              (+<delta>)
New Posts            <integer>          (<delta>)
Engagements          <integer>          (<delta>)
Engagement Rate      <pct>              (+<delta>)
Views                <integer>          (<delta>)
Insights | Content | Save to Dashboard
```

The 3-link footer (`Insights | Content | Save to Dashboard`) is the per-tile action row.

## Steps

### Step 1 — Navigate to Brand > Channels with Threads filter
- **Action:** Direct URL `https://app.lfmdev.in/#explore/brand/channels?brand_id={brand_id}&account_id={account_id}&channels=threads`.
- **Assertion:** Page renders without freeze. Channel row shows Threads selected.

### Step 2 — Verify Threads tile presence + metric set
- **DOM probe** by scrolling to Threads section and reading text:
  ```javascript
  const tile = [...document.querySelectorAll('.al-channel-tile, .channel-tile')]
    .find(t => /Threads/.test(t.textContent));
  ```
- **Assertion:** Tile contains all 7 metrics in the order listed above. The `Total Followers` value should be a populated integer (e.g., `2,248,267` for MTV on 2026-06-08). Low-activity windows can leave New Followers as `–` and other metrics at `0` — that's expected, not a bug.

### Step 3 — Verify per-tile actions
- **Assertion:** `Insights | Content | Save to Dashboard` links present at the bottom of the tile.

### Step 4 — Cross-source consistency: Brand > Content Threads
- **Action:** Navigate to `https://app.lfmdev.in/#explore/brand/content?brand_id={brand_id}&account_id={account_id}&channels=threads`.
- **Assertion:** `Posts (N)` count on Brand>Content matches the `New Posts` tile value on Brand>Channels (same date window). For MTV May 25–31 2026: `Posts(0)` on Brand>Content === `New Posts=0` on Brand>Channels.
- **URL auto-rewrite:** Brand>Content may auto-append `sentiment_mode=false` — the Threads channel filter still holds.

### Step 5 — Cross-source consistency: Brand > Insights Threads (KNOWN-QUIRK)
- **Action:** Navigate to `https://app.lfmdev.in/#explore/brand/insights?brand_id={brand_id}&account_id={account_id}&channels=threads`.
- **⚠ KNOWN QUIRK: Brand>Insights `channels=threads` renderer freeze** — CDP `Runtime.evaluate` 45s timeout, page hangs.
- **Recovery:** close the hung tab via `tabs_close_mcp`; open a fresh tab with the same URL. If the fresh tab also hangs, mark this cross-check as **DEFERRED** in the report (per QA-95190 A4 outcome).
- **Assertion (if reachable):** Brand>Insights Threads `Total Followers` value matches Brand>Channels Threads tile.

## Failure signatures

| Signature | Interpretation | Action |
|---|---|---|
| Threads tile missing from Brand>Channels grid | Account/brand has no Threads channel data | Verify via direct URL; treat as account-gated, not a bug |
| Tile renders with all metrics at `0` AND `–` | Low-activity window — expected | Not a bug; record values as-is |
| `Total Followers` = `Go To Authorize` text | APPS-53104 historical (closed) regression | File against the closed bug if observed |
| Brand>Content `Posts(N)` ≠ Brand>Channels `New Posts` for same window | Cross-source consistency drift | File bug; capture both surfaces' values |
| Brand>Insights Threads URL hangs CDP eval | Known renderer freeze quirk | Recovery via fresh tab; if still hung, defer the cross-check |

## Network expectations

| Endpoint | Method | Expected status | Notes |
|---|---|---|---|
| `/api/.../brand/channels` | GET | 200 | Drives the per-channel tile grid |
| `/api/.../brand/insights?channels=threads` | GET | 200 (in fresh tab) | Subject to renderer-freeze quirk on stale-tab navigation |

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows; historical closed defects APPS-53076 ("No data view") and APPS-53104 ("Go To Authorize popup") confirmed NOT REPRODUCED on 2026-06-08.

## Changelog

- **v1** (2026-06-08): Initial draft from QA-95190 PASS. Documents the Threads-tile 7-metric format, the per-tile `Insights | Content | Save to Dashboard` action row, the Brand>Content `Posts(N)` cross-source consistency check, and the Brand>Insights `channels=threads` renderer-freeze known quirk + fresh-tab recovery.
