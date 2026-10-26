# QA-20325 — Brand Content > Facebook Only: Completed Video Views Data Set > Past date range data test

**Run:** 2026-10-23 (Friday), unattended headless (`claude -p`, Playwright MCP) — dev env `app.lfmdev.in`
**Verdict: PASS**

## Setup (per weekday rotation — Friday)
- Account: **Hulu** (account_id=336) — switched from the default Viacom via the LFQA menu → Search Account → Results row `Hulu`. Breadcrumb confirmed `Account: Hulu`.
- Brand: **Hulu** (brand_id=5670) — the account's default brand on Brand > Content, exact name match with the spec (Rule 1). Ralph Lauren (second Friday row) not run — one account/brand row per weekday run.
- View: Authorized data (default, spec does not name a perspective).

## Steps executed
1. Hovered **Brand** in the top nav → clicked **Content** (`#explore/brand/content?brand_id=5670`). Page loaded after a slow dev start (~60 s on "Loading…", one reload of `#home`; no render-hang verdict needed).
2. Opened the Date Range picker (Mode: Lifetime), set START DATE via the datepicker (year 2024 → Jan → 1). Picker showed `START DATE Jan 01, 2024 / END DATE Dec 31, 2024`; clicked **Ok**. URL `from=2024-01-01&to=2024-12-31`. (Screenshot 06.)
3. Data Set dropdown → **Facebook Only: Completed Video Views** (URL `table_data_set=facebook_only:_completed_video_views`). Channel set auto-narrowed to Facebook only (`.channel-ghost.facebook.enabled`, all others disabled).
4. Switched to **Table View** (`[title="Table View"]`). `Posts (820)`; 200 posts rendered (top 200 by sort) plus the Sum/Average aggregate row, no table error. Scraped every rendered row in page JS: columns `Completed Views` (idx 15), `Organic Completed Views` (16), `Paid Completed Views` (17); checked Organic + Paid = Completed for each post, and for the aggregate Sum row.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 4 | Per post: Organic Completed Views + Paid Completed Views = Completed Views | 200 rendered posts: 198 satisfied exactly, 0 failed, 2 rows (rank 91, rank 154) show "–" on all three columns (no data → skipped per grid-math convention) | PASS |
| A2 | 4 | Aggregate (Sum row, toggle on Sum): Organic + Paid = Completed | 117,484,684 + 6,179,903 = 123,664,587 = Completed Views Sum 123,664,587 (diff 0) | PASS |

## Evidence
- Sum row: Engagements 13,017,554; Completed Views 123,664,587; Organic Completed Views 117,484,684; Paid Completed Views 6,179,903.
- Example post (rank 1, Sun Sep. 08, 2024 09:01 AM PDT, Video): Completed 373,181 = Organic 373,181 + Paid 0. Rank 200 (Tue Dec. 24, 2024): 43,796 = 43,796 + 0.
- Scrape result: `{total:200, pass:198, fail:[], partial:[], noData:["91","154"]}` — no row had a partial dash (one of the three present).
- Screenshots: `.playwright-out/QA-20325/` — 03/04 (Brand Content landing, Account: HULU), 05/06 (date picker, Jan 01 – Dec 31 2024), 07 (Facebook Only: Completed Video Views Table View).
- Limitation: the table renders only the top 200 of 820 posts (no pagination); the identity is verified on those 200 plus the aggregate row, which covers all 820.

## Known bugs checked
- Case file "Open linked bugs (as of 2026-10-19)": none open → Rule 7 screen passed. `knowledge-base/bug-history.md` and `known-quirks.md` pre-grepped for QA-20325: no matches. `results/open-bugs-2026-10-23.json` has no entry for QA-20325.
- Related surface note (from skill grid-math): Facebook Data Collection Disruption 9/27 banner is shown, but it affects current-week data, not the Jan–Dec 2024 range; it did not interfere with the assertions.
- Slow dev (`/me` call hanging, Brand Content "Loading…" ~30 s) observed — transient, no bug filed.

## Bugs filed
None.
