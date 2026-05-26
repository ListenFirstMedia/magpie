---
name: data-collection-brand-popup
version: 1
last_verified: 2026-05-20
last_passed_run: 2026-05-20
trust: untrusted
pass_streak: 1
preconditions: [on-data-collection-page]
postconditions: [brand-popup-inspected]
inputs: [brand_name]
outputs: [not_collecting_count, learn_more_href, reauthorize_count, channel_list, page_list]
related_pages: [Settings>DataCollection]
---

# Settings → Data Collection — Brand popup + drill-down (QA-2498 pattern)

End-to-end inspection of the Data Collection 3-pane drill-down: Brands → Channels → Pages, plus the hover popups at each level.

## Used by
- **QA-2498** (Channels not collected) — 5 PASS, 1 deviation, 2 UI variances documented in run report

## Steps

### Step 1 — Navigate to Data Collection
Settings (top-right) → Data Collection. URL: `/#data-collection?account_id=<id>`

Three-pane layout:
- Left: My Brands list (scrollable, ~1000+ brands)
- Middle: Channels (N) for selected brand (empty until brand clicked)
- Right: Pages (N) for selected channel (empty until channel clicked)

### Step 2 — Search and select brand
Search input above the brand list. Type brand name → autocomplete dropdown appears. Click the exact match per Rule 1.

URL updates to `/#data-collection/<brand-name>?account_id=<id>` (brand name is URL-encoded).

### Step 3 — Brand badges
Each brand row in left pane shows badge icons:
- 🔴 **red exclamation** (N): N not-collecting items
- 🔵 **blue +** (N): N other-status items (collection in setup / new)
- 🟡 **yellow !** (N): N warning items

### Step 4 — Brand-level Not-Collecting popup (hover red !)
**Hover** the red exclamation badge. Popup opens with:
- Header: "Not Collecting (N)" (no hyphen — spec says "Not-Collecting" but actual UI is "Not Collecting")
- Top-right: "Learn More" link with external-link icon → `https://listenfirst.zendesk.com/hc/en-us/articles/21272713329300` (Zendesk help article, target=_blank)
- For each not-collecting item:
  - Brand/feed identifier (e.g., "StreamOnMax")
  - Channel description with privacy suffix in parens — `Twitter Earned Comments (Public)`, `Pinterest User (Authorized)`
  - Italic description of the feed's purpose
  - Start Date and Last Collection Date
  - Reauthorize button

The popup is scrollable when items > visible area.

### Step 5 — Verifying Reauthorize button count (assertion-specific)
Use JS to count visible Reauthorize buttons across the popup:
```js
Array.from(document.querySelectorAll('button')).filter(b => b.textContent.trim() === 'Reauthorize' && b.offsetParent !== null).length
```
Note: spec may say "Two Reauthorize buttons" but actual count usually equals the number of reauth-eligible items. If discrepancy, document but don't file as bug — spec staleness.

### Step 6 — Verifying Learn More target (without clicking)
```js
const a = Array.from(document.querySelectorAll('a')).find(x => x.textContent.trim() === 'Learn More');
({href: a.href, target: a.target})
```
Don't click Learn More — it opens in a new tab and navigation can derail the test. Verifying via href + target is sufficient evidence for A5/A7 assertions.

### Step 7 — Click brand to open Channels pane
Click the brand row (anywhere). Middle pane fills with Channels (N) list.

Same badge convention applies to channels — channels with red ! have non-collecting state.

### Step 8 — Click channel to open Pages pane
Click channel row. Right pane fills with Pages (N) list.

### Step 9 — Click page to view Data Collection Summary
Click page row. **Different behavior than spec expects:** instead of a popup, the entire right pane is replaced with a "Data Collection Summary" view showing:
- Title: "Attributed to <Brand> <DateRange>"
- Subtext: "Click to reauthorize collection on any data feed"
- Table columns: **Data Feed | Start Date | Last Collection Date | Status**
- Status indicator: green ✓ Collecting or expand-caret for items with multiple data sources

Note: spec QA-2498 A10/A12 mentions "Data Begins / Last Collection / Posts Tracked" — actual columns differ; "Posts Tracked" not present.

### Step 10 — Back button
There's a back-arrow icon (top-left of right pane) to return from Pages view to Channels view.

## Variances vs Spec

| Spec text | Actual UI | Action |
|---|---|---|
| "Not-Collecting (N)" | "Not Collecting (N)" | Wording variance; mark as PASS |
| Two Reauthorize buttons | N Reauthorize buttons (= count of reauth-eligible items) | Document count, don't file as bug |
| Page popup shows Data Begins / Last Collection / Posts Tracked | Page view shows Start Date / Last Collection Date / Status (no Posts Tracked) | UI Variance — note in report, possibly file as spec-needs-update |

## Failure signatures

| Signature | Interpretation | Action |
|---|---|---|
| No red ! badge on target channel | Channel is fully collecting — can't test red-! flows | Document as BLOCKED, not bug |
| Popup doesn't open on hover | Need to wait longer (hover requires steady cursor for ~500ms) | Use `mouse_move` then sleep |
| Click on brand row doesn't open Channels | Need to click directly on brand name text, not badges | Use `find` for precise target |

## Changelog
- **v1** (2026-05-20): Initial draft from QA-2498 PARTIAL run. Captures the brand → channel → page drill-down, the "Not Collecting (N)" popup structure, and the spec deviations (Reauthorize count, page summary columns).
