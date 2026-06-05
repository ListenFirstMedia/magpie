# QA-51442 — Brand > Stories - Impressions - Tile level export - PNG (re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-51442
- **Run date:** 2026-06-04 (QA-4325 batch-4)
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018) — Hulu first attempted but lacks Authorized-data Stories on Adam Orfei context
- **Date ranges tried:** May 27–Jun 2, 2026 / May 15–20, 2026 / May 29, 2026 single day
- **Channels:** Instagram
- **Perspective:** Authorized Data (`perspective=extended` confirmed via URL + toggle position)
- **Result:** **PARTIAL — tile-level Export menu confirmed present with PNG/CSV/Google Sheets/Metrics options; PNG download could not complete because the Impressions visualization tile is in a persistent skeleton-shimmer / "tile failed to load" state across multiple date ranges on MTV**

## Spec
See `/Users/yashsharma/git/magpie/testcases/english/QA-51442.md`. Affordance and option ordering verified; download verification blocked by upstream tile-render failure.

## Reused skills
- `audience-metrics-export` (untrusted, pass_streak 8) — same tile-level Export dropdown pattern applies (PNG/CSV/GS/Metrics ordering matches QA-20988 Brand>Paid pattern)
- `switch-account` (untrusted, pass_streak unchanged this run — Adam Orfei context persisted)
- `view-perspective-toggle` (untrusted, pass_streak 3) — re-verified the perspective toggle is required on Hulu (Public default) and `extended` is needed for Stories tab to appear

## Steps executed

| Step | Action | State |
|---|---|---|
| 1 | Navigate to `#explore/brand/stories?brand_id=11003 (Hulu) &perspective=extended` | PARTIAL — Stories sub-tab not visible on Hulu nav on Adam Orfei (toggle stuck on Public Data; Stories tab hidden); switched to MTV (brand_id=4018) which exposes Stories tab in nav |
| 2 | Navigate Stories for MTV Authorized + IG channel + Last 7 Days (May 27–Jun 2) | Stories tab loaded with Sum/Avg row populated; 4 tiles (Engagements, Impressions, Taps Back, Exits) all rendered "This tile failed to load. Please try again." + Reload button. Stories(19) table also rendered with 19 stories. |
| 3 | Click Reload on Impressions tile (date range May 27–Jun 2) | Tile re-enters skeleton state for ~6 s then returns to skeleton (no rendered chart) |
| 4 | Try shorter date range May 15–20 | Same 4 tiles fail; Stories(11) data table populated with Sum Impressions 199,265 / Avg 18,115 |
| 5 | Click `Export` on the Impressions tile-level dropdown | Menu opens: `PNG` / `CSV` / `Google Sheets` / `Metrics` — confirmed all 4 options listed |
| 6 | Click PNG | No download produced (Downloads folder unchanged); tile in failed/skeleton state lacks renderable canvas |
| 7 | Try single-day window May 29 | Same 4-tile failure; Stories(4) data populated, Sum Impressions 121,106; Impressions tile re-Reload → skeleton-hang again |
| 8 | Verify Export dropdown UI behavior again | Confirmed dropdown exists below each tile (consistent across 5+ tile×date combos), 4 options visible, PNG is first |

## Assertions table

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 1-2 | Brand > Stories loads with at least one Impressions tile rendered | Stories tab is reachable on MTV (Authorized) but all 4 tiles (Engagements, Impressions, Taps Back, Exits) render in failed-load or persistent-skeleton state across all 3 tested date ranges. Stories table data IS populated. | FAIL on chart visualization, PASS on data |
| A2 | 5 | Per-tile Export menu with PNG option | Dropdown opens with `PNG`, `CSV`, `Google Sheets`, `Metrics` — confirmed | PASS |
| A3 | 6 | Clicking PNG triggers download | No file landed in Downloads folder; the failed/skeleton tile state appears to block the canvas serialization that PNG export needs | BLOCKED — upstream tile-render failure |
| A4 | post-A3 | Filename matches `{Brand}-Stories-Impressions-{ChartType}-{from}-{to}.png` | N/A — no file produced | NOT VERIFIED |
| A5 | A4 | PNG content embeds brand + chart + legend + date range | N/A | NOT VERIFIED |
| A6 | A5 | No render errors / blank canvases | A persistent "tile failed to load" / skeleton-hang on the in-page visualization tile is itself a render error | FAIL |

## Bugs filed (NEW finding for 2026-06-04 re-run findings)

**Brand > Stories visualization tiles persistently fail to load on MTV (Authorized) across multiple date windows.**
- Repro environment: dev `app.lfmdev.in`, account_id=54 (Adam Orfei), brand_id=4018 (MTV), Authorized View, IG channel only, Insights data set.
- 3 date windows tested: May 27–Jun 2 (range), May 15–20 (range), May 29 (single day).
- All 4 chart tiles (Engagements, Impressions, Taps Back, Exits) fail with either "This tile failed to load. Please try again." + Reload button (immediate fail), OR enter a persistent skeleton-shimmer state after Reload click that never resolves (waited 10+ s after each reload).
- Sum/Avg row at the bottom of the page DOES populate correctly (Sum Impressions = 121,106 / 199,265 across the two tested windows), so the underlying data is available.
- Tile-level Export dropdown exists and lists PNG/CSV/Google Sheets/Metrics, but clicking PNG when the tile is in failed/skeleton state produces no file download (because the chart canvas is empty/missing).
- **Impact:** QA-51442 cannot be passed end-to-end until the chart visualization tile renders. Flag for product/eng triage. Suspect server-side metric fetch is failing for the Stories chart tile specifically (the table-level fetch is succeeding on the same page).

## New findings (non-blocking)
- Brand > Stories sub-tab is **conditionally hidden** based on perspective + brand. On Hulu (Public-only on Adam Orfei context), Stories tab does not appear in the sub-nav. On MTV (Authorized), Stories tab is present.
- The tile-level `Bar | Export | Save to Dashboard` pattern is consistent with QA-20988 (Brand > Paid) — same skill family applies.
- "Data Visualization" pill above the tiles suggests a future toggle to switch between chart vs table layout for the Stories page — not exercised this run.

## Files
- `testcases/english/QA-51442.md` (spec)
- `runs/2026-06-02/QA-51442-report.md` (this report)
- No PNG produced — see "Bugs filed" above for blocking factor.
