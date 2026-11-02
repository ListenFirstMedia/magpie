# QA-24283 — Brand Content - Pinterest Only: Basic Data Set - Aggregate Data Test

**Run date:** 2026-10-30 · **Track:** Playwright MCP, headless unattended (`claude -p`) · **Env:** app.lfmdev.in · **Account:** Sephora (account_id 655) · **Brand:** Sephora (brand_id 7159, exact typeahead name) · **Data set:** Pinterest Only: Basic (`table_data_set=pinterest_only%3A_basic`, channel Pinterest only) · **View:** Table View
**Verdict: PASS (with data flag).** Sum Engagements (670) = Pin Saves ("–", treated as 0) + Comments (670). The Average row is consistent. The per-row identity holds on 200/200 rendered rows. The spec gives no date range and the default week (Oct 22–28, 2026) has 0 Pinterest posts, so the assertion was evaluated on Jun. 11, 2024 – Jun. 10, 2025. That is the same range used on 2026-10-20/26/27/28/29.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Precondition: log in (config/.env), switch account to Sephora via the profile menu (Search Account, then Results item) | PASS: `account_id=655`, header "ACCOUNT: SEPHORA" |
| 1 | Hover Brand, then click Content in the top nav | PASS: `#explore/brand/content`. Landing brand was already Sephora (brand_id 7159). |
| 2 | Add brand: Sephora from the typeahead (exact-name Results match). Data Set dropdown, then **Pinterest Only: Basic**. Pinterest channel only, Apply. | PASS: brand_id=7159, `channels=pinterest`, `table_data_set=pinterest_only%3A_basic` |
| 2a | Default week Oct 22–28, 2026 | Posts (0). Not evaluable (`.playwright-out/QA-24283/03-default-week-0posts.png`). |
| 2b | Date range via the picker: Jun. 11, 2024 – Jun. 10, 2025 | PASS: Posts (62,031) |
| 3 | Table View: read the aggregate row on **Sum**, click the toggle to **Average**, read again. Scrape all 200 rendered rows. | PASS: see below |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 (Sum) | Pin Saves sum + Comments sum = Engagements sum | Engagements 670; Pin Saves "–" (structurally empty, treated as 0); Comments 670. 0 + 670 = 670. | PASS |
| A2 | 3 (Average) | Pin Saves avg + Comments avg = Engagements avg | Engagements 0; Pin Saves "–"; Comments 0 (670 / 62,031 ≈ 0.011, rounds to 0). Consistent. | PASS |
| A3 | 3 (rows, supplementary) | Engagements = Pin Saves + Comments per post | 200/200 rendered rows match; 0 mismatches; 0 skipped; 0 rows with a numeric Pin Saves | PASS |

## Evidence
- Pinterest applied, default week: `.playwright-out/QA-24283/02-pinterest-applied.png`, `.playwright-out/QA-24283/03-default-week-0posts.png`
- Sum row (Engagements 670 · Pin Saves – · Comments 670): `.playwright-out/QA-24283/04-aggregate-sum.png`
- Average row after the toggle (0 · – · 0): `.playwright-out/QA-24283/05-aggregate-average.png`
- Scrape headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Pin Saves, Comments, Actions. 200 rows, 200 ok, 0 bad. Posts (62,031).
- Results are identical to the 2026-10-29 run.

## Data flags (not failures)
- **Pin Saves renders "–" on every scraped pin.** Same finding as QA-20334 and the earlier runs of this case. The identity holds only because Engagements equals Comments. If Pinterest still supplies save counts, this is a collection gap for the data team, not an aggregate-math defect.
- Sephora has **no Pinterest posts in the default current week**, so the case cannot be evaluated on its default state. The date range was widened (the spec gives none).
- The Average row shows "0" for Engagements and Comments because the per-post mean is about 0.01.
- The 200 scraped rows are only the first page of 62,031 posts. The Sum row is computed server-side over all posts.

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history and known-quirks had no QA-24283 matches. No known bug reproduced.

## Bugs filed
None (markdown-only).

## Cleanup
None (read-only).
