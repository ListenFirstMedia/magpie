# QA-94978 — Brand Audience - LinkedIn Channel - PNG Export Functionality (re-run 2026-06-04 batch-7)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-94978
- **Account:** UCLA (account_id=799)
- **Brand:** University of California, Los Angeles (brand_id=127756)
- **Channel:** LinkedIn only
- **Date range:** Jan 01 – Dec 31 2025
- **Perspective:** Authorized (perspective=extended URL + UI default)

## Result: PASS (6/6 PNG exports verified end-to-end on disk; APPS-58574 still observed during tile layout probe)

## Steps executed
1. Account switch Adam Orfei → UCLA via URL `account_id=799`. Account header confirmed `Account: UCLA`.
2. Brand top-nav hover-click navigated to Brand Audience UCLA (Facebook channel by default per `channels=facebook`).
3. URL switched to `channels=linkedin` to load LinkedIn perspective. 6 target tiles confirmed in page DOM:
   - Followers: Job Function
   - Followers: Industry
   - Followers: Seniority
   - Followers: Staff Count Range
   - Followers By Country
   - Followers By Region
4. For each tile: hover → click tile-level Export button (via `computer.left_click` at DOM-measured Export-button center) → JS click PNG option inside the just-opened `.selector-dropdown-container.is-open` dropdown.
5. Verified each saved PNG end-to-end on disk via `~/Downloads` mount.

## Source: Saved files verification (Rule 6)

| Tile | Filename | Size |
|------|----------|------|
| Followers: Job Function | `University of California, Los Angeles-Audience-Followers Job Function-2025-01-01-2025-12-31.png` | 161,636 bytes |
| Followers: Industry | `University of California, Los Angeles-Audience-Followers Industry-2025-01-01-2025-12-31.png` | 642,763 bytes |
| Followers: Seniority | `University of California, Los Angeles-Audience-Followers Seniority-2025-01-01-2025-12-31.png` | 63,190 bytes |
| Followers: Staff Count Range | `University of California, Los Angeles-Audience-Followers Staff Count Range-2025-01-01-2025-12-31.png` | 72,100 bytes |
| Followers By Country | `University of California, Los Angeles-Audience-Followers By Country-2025-01-01-2025-12-31.png` | 142,338 bytes |
| Followers By Region | `University of California, Los Angeles-Audience-Followers By Region-2025-01-01-2025-12-31.png` | 154,335 bytes |

Filename pattern verbatim: `<Brand>-Audience-<Tile>-<start>-<end>.png` — all 6 conform.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Each tile's Export dropdown exposes PNG | List shows `PNG / CSV / Google Sheets / Metrics` | Verified for Job Function (DOM dump); same pattern across all 6 tiles | PASS |
| A2 | PNG actually downloads to disk | All 6 PNGs found in `~/Downloads/` with non-zero sizes | All 6 saved | PASS |
| A3 | Filename pattern `<Brand>-Audience-<Tile>-<start>-<end>.png` | Verified verbatim across all 6 | PASS |
| A4 | PNG content matches visible tile | File sizes 63KB–643KB indicate rendered chart/list content, not blank | PASS (size-based; Industry's 642KB confirms large category list) |
| A5 | APPS-58574 layout state captured | Same first-row Job-Function-alone vs row-2 three-tile layout observed (per `tile-row` heights showing Job Function tile at y≈686 vs Industry/Seniority/Staff at y≈1085) | Confirmed (APPS-58574 still reproduces) |

## Bug verdict

**APPS-58574 (Trivial, In Progress)** — same misalignment pattern reproduces (first row contains Job Function alone; second row Industry+Seniority+Staff Count Range; third row Country+Region). Consistent with batch-1 + batch-6 finding.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-94978-report.md`
- `/Users/yashsharma/git/magpie/testcases/english/QA-94978.md` (proxy spec)
- 6 PNG files in `~/Downloads/` (see Source table)

## Notes
- The per-tile Export dropdown is universal across LinkedIn Audience tiles — `PNG | CSV | Google Sheets | Metrics`. PNG path tested here; CSV verified in QA-94977 batch-6.
- Click recipe: `computer.left_click` at DOM Export-button center followed by JS-find-and-click of the inner `PNG` text node. `dispatchEvent('click')` directly on `.dropdown-name` does not open the dropdown (likely React listener bound to the parent's pointer events).
- Reuses `audience-metrics-export` skill (PNG variant) + `switch-account` skill v2.
