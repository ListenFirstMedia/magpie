# QA-24283 — Brand Content - Pinterest Only: Basic Data Set - Aggregate Data Test

**Run date:** 2026-10-26 · **Track:** Playwright MCP, headless unattended (`claude -p`) · **Env:** dev (app.lfmdev.in) · **Account:** Sephora (account_id 655) · **Brand:** Sephora (brand_id 7159, exact typeahead result) · **Data set:** Pinterest Only: Basic · **Channel:** Pinterest only · **View:** Authorized data (default), Table View
**Verdict: PASS (with data flag)** — Sum Engagements (670) = Pin Saves ("–" = 0) + Comments (670); Average row consistent (0 / – / 0); per-row identity holds on 200/200 rendered rows. The spec gives no date range and the default week (Oct 18–24, 2026) has 0 Pinterest posts, so the assertion was evaluated on Jun. 11, 2024 – Jun. 10, 2025 (same range as the 2026-10-20 run and QA-20334).

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Login (Cognito existing-account form; first attempt hit a transient `PostAuthentication ... Task timed out after 3.00 seconds` lambda error, 2nd click succeeded). Precondition: switch account to Sephora via profile menu → Search Account → Results item | ✅ breadcrumb "ACCOUNT: SEPHORA", account_id=655 |
| 1 | Hover Brand → click Content in the top nav | ✅ `#explore/brand/content`, header "Sephora" (`10-content-landing.png`) |
| 2a | Add a Brand: brand selector → typed "Sephora" → clicked exact-match result "Sephora" | ✅ brand_id=7159. The page then hung on a skeleton (>3 min, `13-stuck-skeleton.png`); one reload (per step budget) recovered it — Posts (34) on the default Public data set |
| 2b | Data Set dropdown → **Pinterest Only: Basic**; channel Pinterest enabled (all others disabled); Apply | ✅ `table_data_set=pinterest_only:_basic`, `channels=pinterest` (`15-pinterest-applied.png`) |
| 2c | Default week Oct 18–24, 2026 | Posts (0), "There is no data available" — no table/aggregate row rendered (`16-default-week-table.png`). Not evaluable |
| 2d | Date range via picker → Jun. 11, 2024 – Jun. 10, 2025 | ✅ Posts (62,031) |
| 3 | Table View (`[title="Table View"]`): columns Engagements / Pin Saves / Comments present; read aggregate **Sum** row; clicked the Sum↔Average toggle to **Average**, read again; scraped all 200 rendered rows | ✅ see below |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 (Sum) | Pin Saves sum + Comments sum = Engagements sum | Engagements 670; Pin Saves "–" (treated as 0 — structurally empty); Comments 670 → 0 + 670 = 670 ✓ | ✅ PASS |
| A2 | 3 (Average) | Pin Saves avg + Comments avg = Engagements avg | Engagements 0; Pin Saves "–"; Comments 0 (670 / 62,031 ≈ 0.011 rounds to 0) → 0 + 0 = 0 ✓ | ✅ PASS |
| A3 | 3 (rows, supplementary) | Engagements = Pin Saves + Comments per post | 200/200 rendered rows match; 0 mismatches; 0 skipped; 0 rows with a non-"–" Pin Saves | ✅ PASS |

## Evidence
- Default week, 0 posts, no table: `.playwright-out/QA-24283/16-default-week-table.png`
- Sum row, Jun 11 2024 – Jun 10 2025: `.playwright-out/QA-24283/18-aggregate-sum.png` (Engagements 670 · Pin Saves – · Comments 670)
- Average row after toggle click: `.playwright-out/QA-24283/19-aggregate-average.png` (0 · – · 0)
- Scrape headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Pin Saves, Comments, Actions. Top rows (Engagements desc): Dec 30 2024 27/–/27; Mar 6 2025 20/–/20; Jul 26 2024 19/–/19.
- Aggregate Sum text read from the DOM: `Rank "Sum Average"`, Engagements "670", Pin Saves "–", Comments "670".

## Data flags (not failures)
- **Pin Saves renders "–" on every pin** (62,031 in range) — same as 2026-10-20 and QA-20334 (2026-10-19). The identity holds only because Engagements equals Comments. If Pinterest still supplies save counts this is a collection gap for the data team; it is not an aggregate-math defect.
- Sephora has **no Pinterest posts in the default week** (Oct 18–24, 2026; none Sep 1 – Oct 18 either per the prior run), so the case cannot be evaluated on its default state. Total Pinterest engagements are tiny (670 across 62,031 pins), making Average round to 0 — the Average assertion is weak evidence.
- Dev flakiness this run: Cognito post-auth lambda timeout on first sign-in; Brand Content stuck on skeleton after brand re-select until a reload. Neither affected the assertions.
- Facebook Data Collection Disruption 9/27 banner is present; unrelated to the Pinterest-only data set.

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history / known-quirks had no QA-24283 matches (pre-fetched). No known bug reproduced.

## Bugs filed
None (markdown-only).

## Cleanup
None (read-only; no data mutated).
