# QA-24283 — Brand Content - Pinterest Only: Basic Data Set - Aggregate Data Test

**Run date:** 2026-10-20 · **Track:** Playwright MCP, headless unattended (`claude -p`) · **Account:** Sephora (account_id 655) · **Brand:** Sephora (brand_id 7159, exact name in header) · **Data set:** Pinterest Only: Basic (auto-selects Pinterest channel; all other channels greyed) · **View:** Authorized data (default), Table View layout
**Verdict: PASS (with data flag) — Sum Engagements (670) = Pin Saves ("–" = 0) + Comments (670); Average row consistent; per-row identity holds on 200/200 rendered rows. Spec gave no date range; the default week has 0 Pinterest posts, so the assertion was evaluated on Jun. 11, 2024 – Jun. 10, 2025 (the same range as QA-20334).**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Precondition: log in as lfiqa, switch account to Sephora via profile menu → Search Account → Results item | ✅ account_id=655, breadcrumb "ACCOUNT: SEPHORA" |
| 1 | Hover Brand → click Content in the top nav | ✅ `#explore/brand/content?brand_id=7159`, brand header "Sephora" |
| 2 | Data Set dropdown → **Pinterest Only: Basic**; channel Pinterest enabled; Apply | ✅ `table_data_set=pinterest_only:_basic`, `channels=pinterest` |
| 2a | Default week Oct 12–18, 2026 | Posts (0); aggregate Sum/Average show "–" for Engagements / Pin Saves / Comments (screenshot 02). Not evaluable |
| 2b | Date range widened via the picker: Sep 1 – Oct 18, 2026 | Posts (0) — no recent Pinterest data for Sephora |
| 2c | Date range → Jun. 11, 2024 – Jun. 10, 2025 | ✅ Posts (62,031) |
| 3 | Table View aggregate row: read **Sum**, click toggle to **Average**, read again; scrape all 200 rendered rows | ✅ see below |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 (Sum) | Pin Saves sum + Comments sum = Engagements sum | Engagements 670; Pin Saves "–" (treated as 0 — structurally empty); Comments 670 → – + 670 = 670 ✓ | ✅ PASS |
| A2 | 3 (Average) | Pin Saves avg + Comments avg = Engagements avg | Engagements 0; Pin Saves "–"; Comments 0 (670 / 62,031 ≈ 0.011 rounds to 0) → consistent ✓ | ✅ PASS |
| A3 | 3 (rows, supplementary) | Engagements = Pin Saves + Comments per post | 200/200 rendered rows match; 0 mismatches; 0 rows with a non-"–" Pin Saves | ✅ PASS |

## Evidence
- Default week (0 posts, aggregate "–"): `.playwright-out/QA-24283/02-pinterest-applied.png`
- Sum row, Jun 11 2024 – Jun 10 2025: `.playwright-out/QA-24283/04-aggregate-2024-25.png` (Engagements 670 · Pin Saves – · Comments 670)
- Average row (toggle moved to Average): `.playwright-out/QA-24283/05-aggregate-average.png` (0 · – · 0)
- Scrape: headers Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Pin Saves, Comments, Actions; 200 rows, 200 ok, 0 bad, 0 skipped.

## Data flags (not failures)
- **Pin Saves renders "–" on every pin** (62,031 in the range) — same finding as QA-20334 (2026-10-19). The identity only holds because Engagements equals Comments. If Pinterest still supplies save counts, this is a collection gap for the data team; it is not a math defect in the aggregate.
- Sephora has **no Pinterest posts from Sep 1 – Oct 18, 2026**, so the default-week view is empty. The case cannot be evaluated on its default state.
- Average shows "0" for Engagements/Comments because the per-post mean is ~0.01.

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history / known-quirks had no QA-24283 matches. No known bug reproduced; the Facebook Posts Insights Disruption banner is unrelated to the Pinterest-only data set.

## Bugs filed
None (markdown-only).

## Cleanup
None (read-only).
