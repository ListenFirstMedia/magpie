---
id: QA-54202
title: Brand Listing Radaac Report with Filter options
run_date: 2026-07-11
mode: unattended-headless (Playwright MCP)
component: Radaac
skill: radaac-report / radaac-report-runner
verdict: PASS
---

# QA-54202 — Brand Listing Radaac Report with Filter options

**Verdict: PASS (4/4 assertions)**

## Environment
- Radaac dev: `https://radaac.lfmdev.in/` (separate OAuth client `6ep4l754u2dglosjdqggbt2mjr`)
- Logged in via the Cognito hosted UI "With existing account" form (`lfiqa@listenfirstmedia.com`)
- Data date shown: Thursday, July 2, 2026

## Steps executed
1. **Search for report 'Brand Listing'** — typed "Brand Listing" into the Radaac home DataTables Search box; filtered to a single row: ID 7 "Brand Listing (not full definition)" (Owner Phil, defined 2018-02-06). ✔
2. **Click "Brand Listing (not full definition)"** — modal opened, title "Brand Listing (not full definition)", description "A basic listing of all brands in the LFM 'movies' table." Fields: Subscriber Name select, Title Category select, Company IDs (csv), Brand set IDs (csv), Brand IDs (csv). ✔
3. **Select Title Category = 'Automotive'** — selected on the `select[name="category"]` dropdown. ✔
4. **Click Submit** — trusted `browser_click` submitted (no JS-resistance under Playwright); download fired: server filename `brands_20260711-1254.tsv`. ✔

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Title Category dropdown lists all active Title Categories | Dropdown listed placeholder `(category)` + 49 categories: Automotive, Beverages, Breweries, CPG, Consumer Electronics, Education, Energy, Fashion, Film Studio, Financial Services, Food Products, Government Entities, Health & Beauty, Health/Wellness/Fitness, Hospital & Health Care, Hospitality, IT/Internet/Computing, Insurance, Internet Services, Legal, Manufacturing & Infrastructure, Marketing/Advertising and Research, Materials and Construction, Media, Movies, Music and Entertainment, Non-Profit/Charity/Philanthropy, Other, Pets/Pet Foods & Pet Supplies, Pharmaceuticals, Podcasts, Publishers, Radio, Real Estate, Restaurants, Retail, Sports Franchise, Sports Organizations and Bodies, Stocks, Supermarket/Grocery/Food & Convenience Stores, TV Network, TV Shows, Talent, Tourism Boards, Travel, Utilities, Venues/Events & Attractions, Video Game, Video Game Publishers, Wireless and Telecom | PASS |
| A2 | 4 | File name displays as "brands_YYYYMMDD-1032.tsv" | Download event server filename `brands_20260711-1254.tsv` (matches pattern `brands_YYYYMMDD-HHMM.tsv`; date 20260711, time 1254). Local saved path `brands-20260711-1254.tsv` — Playwright MCP sanitizes `_`→`-` in the on-disk name (tooling artifact; true name from the download event) | PASS |
| A3 | 4 | Columns present: brand_id, brand_name, created_at, updated_at, tc_title, tc_display | Header (6 cols, tab-separated): `brand_id  brand_name  created_at  updated_at  tc_title  tc_display` — exact match, exact order | PASS |
| A4 | 4 | Only the selected Title Category (Automotive) appears in tc_display and tc_title | Across all 1,285 data rows: `sort -u` on tc_title = single value `AUTOMOTIVE`; `sort -u` on tc_display = single value `Automotive` | PASS |

## Evidence
- Download event: `Downloading file brands_20260711-1254.tsv ...`
- On-disk file: `.playwright-out/brands-20260711-1254.tsv` — 115,836 bytes, 1,286 lines (1 header + 1,285 data rows)
- Sample rows (brand_id / brand_name / created_at / updated_at / tc_title / tc_display):
  - `88690 / #1 Cochran - DAR / 2018-04-20 14:26:19 / 2024-10-28 17:48:18 / AUTOMOTIVE / Automotive`
  - `34001 / Abarth - DAR / 2016-06-24 15:09:01 / 2025-10-31 21:15:00 / AUTOMOTIVE / Automotive`
  - `233001 / ACCELER8 - DAR / 2021-02-25 02:03:00 / 2026-01-16 22:38:35 / AUTOMOTIVE / Automotive`
- Snapshots under `.playwright-out/page-2026-07-11T12-54-*.yml`

## Known bugs checked
- Case file has no "## Open linked bugs" section (pre-baked screen absent) → treated as none listed.
- `knowledge-base/bug-history.md` grep for QA-54202: only a prior-run note (2026-06-04 QA-4325 batch 5, PASS 4/4). No open linked bug.
- `radaac-report-runner` skill cites LFMP-30870 (Ads Account IDs cycling Fetch/Failed) — a different report; does not touch Brand Listing. No interference observed; download completed synchronously.
- The historic "Cognito safety-blocked" note against QA-54202/QA-43914 (2026-06-13 retro-audit) did NOT recur — login via the existing-account form succeeded on this Playwright track.

## Bugs filed
None.
