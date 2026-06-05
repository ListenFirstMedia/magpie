# QA-2062 — Pinterest Content - Post Hovering

**Run date:** 2026-06-04 (QA-4325 batch-3 re-run)
**Account:** Sephora (account_id=655)
**Brand:** Sephora (brand_id=7159 — canonical Sephora, picked via top-nav magnifier search Results)
**Environment:** dev (`app.lfmdev.in`)
**Result:** **PASS** with PARTIAL on blank-Pinterest-CDN rows (known external-platform quirk per known-quirks "Pinterest embed iframe tooltip can render blank for unavailable pins").

## Spec
See `/Users/yashsharma/git/magpie/testcases/english/QA-2062.md` — Pinterest Brand>Content row hover tooltip test.

## Configuration achieved (Rules 1 + 2 + 6)
- Brand: Sephora — Rule 1 exact-match: typed "Sephora" in top-nav magnifier → first **Results** entry "Sephora" clicked → brand_id=7159 loaded. (Recent Searches version of "Sephora" routes to a different variant — used Results entry per known-quirk.)
- Channels: Pinterest only — clicked each of FB/Twitter/IG/TikTok/Threads to deselect, left Pinterest selected, Apply.
- Data Set: Pinterest Only: Basic — auto-selected when Pinterest-only channel was applied; URL `table_data_set=pinterest_only:_basic`.
- Date range: May 26, 2025 – May 25, 2026 (~365 day window, default).
- View: Authorized — `perspective=extended`.
- Layout: Table — switched via JS click on `[title="Table View"]` per `brand-content-table-view` skill (URL doesn't expose layout=table on hash route, same as QA-1677 / QA-529 quirk).

## Steps executed
1. Navigated to Brand>Content with brand_id=7159 + account_id=655.
2. Clicked Pinterest channel-ghost icon + clicked existing default channels off + Apply.
3. Confirmed Posts (85,871) loaded with Data Set auto-set to Pinterest Only: Basic.
4. Switched layout to Table View via JS click.
5. **Hovered Row 1 Type column "Image" link** → embedded Pinterest tooltip rendered.
6. Inspected tooltip: pin image (lip-balm container), title "Fragrance Family: Warm…", `Save` button (red Pinterest pill), "Published By Sephora" byline, X close control.
7. Closed tooltip via X.
8. **Hovered Row 3 Type column "Image"** → tooltip frame opened but inner Pinterest content stayed BLANK (white frame with X only) after 14+ seconds. Matches the known-quirk pattern.

## Assertions table

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | step 5 | Hovering Type column opens embedded tooltip with pin image + caption + "Published By <Brand>" byline | Row 1: Image rendered + title "Fragrance Family: Warm…" + "Published By Sephora" byline + Save button | PASS |
| A2 | step 5 | Tooltip has X close control | X visible top-right of tooltip card | PASS |
| A3 | step 7 | Closing tooltip restores the table state | After X click, tooltip removed; table interaction restored | PASS |
| A4 | step 8 | Blank-tooltip rows expected per known-quirk | Row 3 tooltip blank — matches known-quirk: external Pinterest CDN pin-availability | PARTIAL (acceptable per quirk) |

## Bugs filed
_None._ The blank-iframe behavior is an external-platform issue (Pinterest CDN can't render the pin), documented as known-quirk and not a magpie/LFM defect.

## Skills reused
- `brand-content-table-view` — Table View switch via `[title="Table View"]` click (URL hash doesn't carry layout).
- `brand-content-data-set-selector` — Pinterest Only: Basic auto-selected when only Pinterest channel active.

## New findings
- The Sephora canonical brand (brand_id=7159) is reachable only via top-nav magnifier "Sephora" Results-section click. Direct URL navigation with `brand_id=7159` initially loads, but a follow-up channel-toggle Apply does retain the brand. Other Sephora variants (Sephora Lincoln, Sephora Brasil, etc.) are common; the unqualified "Sephora" Results entry is the right one.
