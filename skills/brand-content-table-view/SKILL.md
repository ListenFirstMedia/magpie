---
name: brand-content-table-view
version: 1
last_verified: 2026-05-13
last_passed_run: 2026-05-13
trust: untrusted
pass_streak: 1
preconditions: [user-logged-in, account-set]
postconditions: [brand-content-in-table-view]
inputs: [brand_id]
outputs: [post_row_full_texts, post_row_metrics]
related_pages: ["/#explore/brand/content"]
---

# Brand > Content in Table View (with full post text extraction)

The Brand > Content page has a Layout selector with three modes: **Table View** (default first icon), **Grid View** (middle, default selected), **Detail View** (third).

## Steps

### Step 1 — Navigate
- Direct URL: `https://app.lfmdev.in/#explore/brand/content?brand_id={brand_id}&account_id={account_id}`

### Step 2 — Switch to Table View
- Find the Layout selector in the Posts header (top-right, after Sort and Metric Display controls).
- The three icons map to:
  - `ref` first (≡-stacked-rows): **Table View**
  - `ref` second (▦-grid): **Grid View** (default)
  - `ref` third (≡-wider-rows): **Detail View**
- Click the Table View icon (use `find` with "Table view layout button" — returns the labeled element directly).

### Step 3 — Verify table layout

A table appears with columns: `Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate`.

The `Text` column shows ellipsed post text (e.g., `"Waiting for NASA to …"`).

### Step 4 — Extract full post text from ellipsed cells

The full post text is stored in the cell's `title` HTML attribute — that's how the browser shows the tooltip on hover. Extract via:

```javascript
// Find the text-cell element and walk up to the element bearing the title attribute
const cells = [...document.querySelectorAll('*')].filter(el =>
  (el.textContent || '').trim().startsWith('<known prefix>') &&
  el.children.length < 3 && el.offsetWidth > 0 && el.offsetWidth < 200
);
let cur = cells[0];
while (cur && !cur.title) cur = cur.parentElement;
const fullText = cur?.title;  // e.g. "Waiting for NASA to confirm you could hear @bts.bighitofficial’s Mexico City concerts from space 🚀💜  📸: BIGHIT MUSIC"
```

This bypasses the unreliable "hover and wait for tooltip" automation pattern — `title` is set on render.

## Assertion patterns

For tests like QA-533:
- **Columns display fully:** all column header `textContent` should not contain `…` and the headers should be visible at all (`offsetWidth > 0`).
- **Tooltip equals full post text:** assert that `cell.textContent` is a prefix of `cell.title` (after stripping the `…` from the cell's visible text).
- **Tooltip = source post text:** Since the `title` attribute is set to the canonical post text on render, this matches by construction. If the test requires verifying against the social-media source, do a follow-up by opening the post link in a fresh MCP tab.

## Known quirks

- The cells' `title` attribute may be set on a parent element rather than the textContent leaf — walk up the parent chain to find it.
- For "Original Post" labeled posts, the post link is usually on the Date column. For "Reel"/"Video"-typed posts the channel icon is the link.
- The Layout selector buttons have no `data-testid`; rely on the accessibility label ("Table View" / "Grid View" / "Detail View").

## Known bug history

See `knowledge-base/bug-history.md` for the full per-ticket bug list. Highest-priority open bugs currently tied to this skill's flows:

- LFMP-32016 (Major) — Story post data is not being displayed on the Brand > Content page     [from QA-19557]
- APPS-58817 (Major) — Brand Content - Posts deleted from Native are still visible in LF app     [from QA-19557]

## Changelog
- **v1** (2026-05-13): Initial draft from QA-533 run. Verified for MTV brand under Viacom account. Full post text successfully retrieved via `title` attribute.

## 2026-06-11 batch-3 update (QA-122942 Hulu IG public)

- Table View headers (IG public): Rank, Date, Channel, Brand, Type, Live, Publish Type, Sponsor, Text, Engagements, Reactions, Comments, **Shares**, Response Rate, Video Views, Video Response Rate, Actions — Video Views sits directly after Response Rate ✓. Detail View metric stack: Engagements, Reactions, Comments, Response Rate, Video Views (below RR ✓), Video Response Rate (no Shares row in Detail).
- Note: a `Shares` column shows for IG public with en-dash values — test specs often omit it; don't fail on its presence.
- Layout icon ref-clicks can silently not switch — verify via `th` headers after clicking; coordinate-click the first icon if needed.
