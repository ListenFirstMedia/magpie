# QA-111132 — Reporting > TWC - IG Followers/Non-Followers/Views/Story Views Metrics

**Run date:** 2026-07-08
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Skill used:** [time-window-comparison-run](../../skills/time-window-comparison-run/SKILL.md) v6 (Playwright notes) — reused for brand-add, Authorized toggle, metric-tree navigation, Run Report, CSV export
**Account:** Hulu (account_id=336), brand = Hulu (brand_id=5670)
**Precondition match:** Spec says "logged in as Hulu" — session was already Hulu after account switch; brand added via exact "Hulu" match in TWC's "Add Brand By Name" Results list.
**Report:** `report_id=155748`

## Steps executed

1. Reporting menu (hover) → Time Window Comparison link → builder loaded (`app-reporting.lfmdev.in/#/time_window_comparison`).
2. Typed "Hulu" into "Search for a Brand" → clicked exact "Hulu" listitem → brand row added.
3. Clicked "Use Authorized Data" button on the Hulu row → confirmed via DOM (`toggle.checked === true`) — perspective explicitly toggled per Rule 2, not inferred from URL.
4. Clicked "By Category" view-switcher (already selected by default; clicked explicitly to perform the spec step).
5. Expanded `Content (0/263)` → `Impressions & Reach (0/35)` → `Channel Breakdown (0/25)` nested category — read the full leaf list (did not check any boxes here, this was the observation-only "By Category" pass called for by step 4).
6. Clicked "By Channel" view-switcher.
7. Expanded `Instagram (0/99)` → `Impressions & Reach (0/17)` → checked all 4 target leaves: `Instagram Views`, `Instagram Follower Views`, `Instagram Non-Follower Views`, `Instagram Story Views` (verified `aria-checked=true` on each `i.controlled-check-box__icon` after click — real Playwright `browser_click`, no focus+Space workaround needed).
8. Options section → checked "Show Metrics" (`#check-box_show-metrics`, verified `aria-checked=true`).
9. Clicked "Run Report" → navigated to `#story/time_window_comparison/155748`, waited for "Building Your Story" to complete.
10. Export dropdown → clicked CSV. Playwright captured a real `download` event; file read from disk.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | "Data Last Updated" timestamp visible below Help Centre, format `MM-DD-YYYY \| HH:MM AM/PM PT` | `Data Last Updated (PT): 07-07-2026 04:31 PM` visible on both builder and report pages — same `MM-DD-YYYY HH:MM AM/PM` content with "PT" in the label prefix rather than a trailing pipe-separated suffix (established app-wide format, not unique to this page) | PASS |
| A2 | 4 | Channel Breakdown shows Instagram Views, IG Follower Views, IG Non-Follower Views, IG Story Views | By-Category → Content → Impressions & Reach → Channel Breakdown leaf list included exactly `Instagram Views`, `Instagram Follower Views`, `Instagram Non-Follower Views`, `Instagram Story Views` (full "Instagram" word used instead of "IG" abbreviation — same metrics) | PASS |
| A3 | 8a | Report loads with data for all 4 metrics | All 4 charts + tables rendered with full 7-day data (Jun 30 - Jul 6, 2026), no em-dash/missing values | PASS |
| A4 | 8b | Timestamp retains format, not clickable | Same `Data Last Updated (PT): 07-07-2026 04:31 PM` text on report page; DOM check confirmed `tagName=DIV`, not inside an `<a>`, `cursor:auto` | PASS |
| A5 | 9a | Page data matches CSV data | Spot-checked all 7 days × 4 metrics — exact match, e.g. Jun 30 Instagram Views page=10,012,508 / CSV=10012508 | PASS |
| A6 | 9b | CSV shows metric names + keys when Show Metrics enabled | CSV includes a second table: `"Display Name","Key"` with all 4 rows (e.g. `"Instagram Views","instagram.page_insight.views_authorized"`) matching the on-page Metrics section exactly | PASS |
| A7 | 9c | Data Last Updated NOT in CSV export | Confirmed absent from the downloaded CSV content | PASS |

**Result: PASS 7/7**

## Evidence

- Downloaded file (Rule 6, verified on disk): `.playwright-out/Hulu---Time-Window-Comparison---Jun-30-2026---Jul-6-2026.csv`
  ```
  "Perspective","Brand","Date","Instagram Views","Instagram Follower Views","Instagram Non-Follower Views","Instagram Story Views"
  "Authorized","Hulu","06/30/2026","10012508","619928","19363934","20168"
  ...
  "Display Name","Key"
  "Instagram Views","instagram.page_insight.views_authorized"
  "Instagram Follower Views","instagram.page_insight.follower_views_authorized"
  "Instagram Non-Follower Views","instagram.page_insight.non_follower_views_authorized"
  "Instagram Story Views","instagram.story_insight.views_authorized"
  ```
- On-page report text extract confirms per-day numerics exactly matching CSV (see steps above).

## Findings (documented for KB, not filed as bugs)

- **`li.leaf` lazy-nesting confirmed nested `<details>` inside `<details>`** — e.g. `Content > Impressions & Reach > Channel Breakdown` is a 3rd level of nesting (35 metrics at level 2 include a 25-metric nested subcategory, not 35 flat leaves). Extends the known "metric tree renders lazily" quirk with a concrete nesting-depth example.
- **Playwright `browser_click` on `.controlled-check-box__label` works natively** for both metric-tree leaves and the Options "Show Metrics" checkbox — no focus+Space dispatch workaround needed, consistent with prior Playwright-track findings for TWC.

## Cleanup

None required — read-only test (no dashboard/entity mutation).

## Bugs filed

None.
