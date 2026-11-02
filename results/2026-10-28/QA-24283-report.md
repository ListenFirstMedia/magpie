# QA-24283 — Brand Content - Pinterest Only: Basic Data Set - Aggregate Data Test

**Run date:** 2026-10-28 · **Track:** Playwright MCP, headless unattended (`claude -p`) · **Env:** app.lfmdev.in · **Account:** Sephora (account_id 655) · **Brand:** Sephora (brand_id 7159, exact name in header) · **Data set:** Pinterest Only: Basic (`table_data_set=pinterest_only:_basic`, channel Pinterest only) · **View:** Authorized data (default), Table View layout
**Verdict: PASS (with data flag) — Sum Engagements (670) = Pin Saves ("–" = 0) + Comments (670); Average row consistent; per-row identity holds on 200/200 rendered rows. The spec gives no date range and the default week has 0 Pinterest posts, so the assertion was evaluated on Jun. 11, 2024 – Jun. 10, 2025 (same range as the 2026-10-20 run of this case and QA-20334).**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Precondition: log in (config/.env), switch account to Sephora via profile menu → Search Account → Results item | ✅ `account_id=655`, header "ACCOUNT: SEPHORA" |
| 1 | Hover Brand → click Content in the top nav | ✅ `#explore/brand/content?brand_id=7159`, brand header "Sephora" |
| 2 | Brand = Sephora (already the account's brand, exact typeahead name); Data Set dropdown → **Pinterest Only: Basic**; Pinterest channel enabled; Apply | ✅ `table_data_set=pinterest_only%3A_basic`, `channels=pinterest` |
| 2a | Default week Oct 20–26, 2026 | Posts (0); no Table View rendered (`.playwright-out/QA-24283/02-pinterest-default-week.png`). Not evaluable |
| 2b | Date range via the picker: Jun. 11, 2024 – Jun. 10, 2025 | ✅ Posts (62,031) |
| 3 | Table View aggregate row: read **Sum**, click toggle to **Average**, read again; scrape all 200 rendered rows | ✅ see below |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 (Sum) | Pin Saves sum + Comments sum = Engagements sum | Engagements 670; Pin Saves "–" (treated as 0, structurally empty); Comments 670 → 0 + 670 = 670 ✓ | ✅ PASS |
| A2 | 3 (Average) | Pin Saves avg + Comments avg = Engagements avg | Engagements 0; Pin Saves "–"; Comments 0 (670 / 62,031 ≈ 0.011 rounds to 0) → consistent ✓ | ✅ PASS |
| A3 | 3 (rows, supplementary) | Engagements = Pin Saves + Comments per post | 200/200 rendered rows match; 0 mismatches; 0 rows with a non-"–" Pin Saves | ✅ PASS |

## Evidence
- Default week (0 posts): `.playwright-out/QA-24283/02-pinterest-default-week.png`
- Sum row, Jun 11 2024 – Jun 10 2025 (toggle on Sum; Engagements 670 · Pin Saves – · Comments 670): `.playwright-out/QA-24283/04-aggregate-sum.png`
- Average row (toggle moved to Average; 0 · – · 0): `.playwright-out/QA-24283/05-aggregate-average.png`
- Scrape: headers Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Pin Saves, Comments, Actions; 200 rows, 200 ok, 0 bad, 0 skipped, 0 with a numeric Pin Saves. Posts (62,031).
- Results are identical to the 2026-10-20 run.

## Data flags (not failures)
- **Pin Saves renders "–" on every pin** in 62,031 posts (same finding as QA-20334 and the 2026-10-20 run). The identity holds only because Engagements equals Comments. If Pinterest still supplies save counts, this is a collection gap for the data team, not an aggregate math defect.
- Sephora has **no Pinterest posts in the default current week**, so the case cannot be evaluated on its default state; the date range had to be widened (spec gives none).
- Average shows "0" for Engagements and Comments because the per-post mean is about 0.01.
- Cosmetic: an orange "Facebook Data Collection Disruption 9/27" banner overlays the page. It is unrelated to the Pinterest-only data set.

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history and known-quirks had no QA-24283 matches. No known bug reproduced.

## Bugs filed
None (markdown-only).

## Cleanup
None (read-only).
