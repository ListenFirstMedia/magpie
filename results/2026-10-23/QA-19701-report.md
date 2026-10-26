# QA-19701 — Brand Content - Facebook Only: Reactions DataSet - Data Test

**Run date:** 2026-10-23 (Friday) — headless, unattended, dev (app.lfmdev.in), user lfiqa@listenfirstmedia.com
**Skill used:** `brand-content-grid-math` (Table View DOM scrape) + `switch-account` (hover LFQA → Search Account → `.lfm-ta-option`)

## Verdict: PASS

Friday rotation row = Account/Brand **Hulu / Hulu** and **Ralph Lauren / Ralph Lauren**. Both legs executed in full; every post satisfies Reactions = Likes + Loves + Hahas + Wows + Sads + Angries + Others, and the Sum row matches too.

## Known bugs checked
- Case file "Open linked bugs": **None open** (Rule 7 screen passed). bug-history.md / known-quirks.md: no QA-19701 entries (pre-grepped).
- Related surface: dev status banner "Facebook Data Collection Disruption 9/27" is showing. It did not interfere — all 51 Facebook posts had complete reaction splits (no "–" cells), so no row was skipped.
- No known bug reproduced.

## Steps executed (per account)
1. Logged in via Cognito "With existing account" (`config/.env`). Switched account via LFQA hover menu → Search Account → `.lfm-ta-option` (Results row): **Hulu** (account_id=336; breadcrumb `ACCOUNT: HULU`), later **Ralph Lauren** (account_id=732; breadcrumb `ACCOUNT: RALPH LAUREN`).
2. Step 1 — hovered **Brand** in the top nav and clicked **Content** (`#explore/brand/content`).
3. Step 2 — opened the brand picker, typed the brand, clicked the exact-name result (Rule 1): `Hulu` (brand_id=5670), `Ralph Lauren` (brand_id=7000). Hulu was already pre-selected as the default brand; it was re-picked explicitly from the typeahead.
4. Step 3 — Data Set dropdown → **Facebook Only: Reactions**. URL `table_data_set=facebook_only:_reactions`, only `channel-ghost facebook enabled`, clicked Apply. Date range Oct 15 – Oct 21, 2026 (app default), View = Authorized data (app default; spec does not name a perspective).
5. Step 4 — switched to **Table View** (`[title="Table View"]`), scraped every `tbody tr` of `table.lfm-table` (header includes Rank), and evaluated the identity per row in page JS.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A4-Hulu | 4 | For every grid post: Reactions = Likes+Loves+Hahas+Wows+Sads+Angries+Others | 44 of 44 posts match exactly (0 failures, 0 skipped, 0 "–" component cells). Samples: rank 1 = 5057+1160+6+5+14+2+0 = 6244 = Reactions 6,244; rank 2 = 4602+85+1699+1+1+0+0 = 6388 = Reactions 6,388 | PASS |
| A4-Hulu-Sum | 4 | Sum row: Reactions = sum of components | Reactions 32,164 = 25,390 + 3,948 + 2,722 + 63 + 30 + 11 + 0 = 32,164; also equals sum of the 44 post rows | PASS |
| A4-RL | 4 | For every grid post: Reactions = Likes+Loves+Hahas+Wows+Sads+Angries+Others | 7 of 7 posts match exactly (2401, 2032, 1574, 1462, 1172, 662, 16; 0 failures, 0 skipped, 0 "–") | PASS |
| A4-RL-Sum | 4 | Sum row: Reactions = sum of components | Reactions 9,319 = 8,071 + 1,229 + 4 + 9 + 0 + 6 + 0 = 9,319; equals sum of the 7 post rows | PASS |

## Evidence
- Hulu: Posts (44); Sum row Engagements 33,908 / Reactions 32,164 / Likes 25,390 / Loves 3,948 / Hahas 2,722 / Wows 63 / Sads 30 / Angries 11 / Others 0.
- Ralph Lauren: Posts (7); Reactions 9,319 / Likes 8,071 / Loves 1,229 / Hahas 4 / Wows 9 / Sads 0 / Angries 6 / Others 0.
- Screenshots (`.playwright-out/QA-19701/`): `10-dataset-selected.png`, `11-applied.png`, `12-table-view.png` (Hulu); `16-rl-search.png`, `17-rl-applied.png`, `18-rl-table.png` (Ralph Lauren); account-switch/menu shots `02`–`05`, `14`.

## Notes / scope
- The case's "Amazon Prime Video on alternative days" note was not run: it applies on alternating days, not defined for this Friday run; the Friday row (Hulu, Ralph Lauren) was fully covered.
- Account switching on dev takes 15–60 s on the "Loading..." splash; waited within the 5-minute step budget, no render-hang.
- Nav tip (for harvest): after the Ralph Lauren switch, Playwright's visibility-based locator on the Brand menu "Content" link timed out; a real mouse move onto Brand (452,28) then click on the Content link (486,153) worked.
- A stray download (`Hulu-Cross-Channel-Paid-2024-07-23-...csv`) was reported by the MCP at the Apply step; it is unrelated to this case (not triggered by any step here).

## Bugs filed
None.
