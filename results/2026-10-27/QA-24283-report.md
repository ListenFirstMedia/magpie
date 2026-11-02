# QA-24283 — Brand Content - Pinterest Only: Basic Data Set - Aggregate Data Test

**Run date:** 2026-10-27 · **Track:** Playwright MCP, headless unattended (`claude -p`) · **Env:** app.lfmdev.in · **Account:** Sephora (account_id 655) · **Brand:** Sephora (brand_id 7159, exact name in header) · **Data set:** Pinterest Only: Basic (`table_data_set=pinterest_only:_basic`, only Pinterest channel enabled) · **View:** Authorized data (default `perspective=extended`), Table View
**Verdict: PASS (with data flag) — Sum Engagements (670) = Pin Saves ("–" = 0) + Comments (670); Average row consistent (0 = – + 0); per-row identity holds on 200/200 rendered rows. Spec gives no date range; the default week (Oct 19–25, 2026) has 0 Pinterest posts, so the assertion was evaluated on Jun. 11, 2024 – Jun. 10, 2025 (same range as the 2026-10-20 run and QA-20334).**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Precondition: login as lfiqa; account was VIACOM → switched via profile menu → Search Account "Sephora" → Results item | ✅ breadcrumb "ACCOUNT: SEPHORA" |
| 1 | Hover Brand → click Content in top nav | ✅ `#explore/brand/content?brand_id=7159&account_id=655`, brand header "Sephora" (exact name; no substitution) |
| 2 | Data Set dropdown → **Pinterest Only: Basic**; channel Pinterest enabled; Apply | ✅ `channels=pinterest`, `table_data_set=pinterest_only:_basic` |
| 2a | Default week Oct 19–25, 2026 | Posts (0); no Table View rendered (screenshot 02). Not evaluable |
| 2b | Date picker START Jun 11, 2024 / END Jun 10, 2025 → Ok | ✅ `from=2024-06-11&to=2025-06-10`; Posts (62,031) |
| 3 | Table View; aggregate row **Sum** read; toggle clicked to **Average** and read; toggled back; scrape of all 200 rendered rows | ✅ see below |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 (Sum) | Pin Saves sum + Comments sum = Engagements sum | Engagements 670; Pin Saves "–" (treated as 0); Comments 670 → 0 + 670 = 670 ✓ | PASS |
| A2 | 3 (Average) | Pin Saves avg + Comments avg = Engagements avg | Engagements 0; Pin Saves "–"; Comments 0 (670 / 62,031 ≈ 0.011 displays as 0) → 0 + 0 = 0 ✓ | PASS |
| A3 | 3 (rows, supplementary) | Engagements = Pin Saves + Comments per post | 200/200 rendered rows match; 0 mismatches; 0 rows with a non-"–" Pin Saves | PASS |

## Evidence
- Landing (Sephora, default Public data set): `.playwright-out/QA-24283/01-content-landing.png`
- Pinterest Only: Basic applied, default week 0 posts: `.playwright-out/QA-24283/02-pinterest-applied.png`
- Date range set: `.playwright-out/QA-24283/03-daterange-set.png`
- Sum row (Engagements 670 · Pin Saves – · Comments 670): `.playwright-out/QA-24283/04-aggregate-sum.png`
- Average row (toggle `checked=true`: Engagements 0 · Pin Saves – · Comments 0): `.playwright-out/QA-24283/05-aggregate-average.png`
- Scrape headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Pin Saves, Comments, Actions; 200 rows, 200 ok, 0 bad. Toggle returned to Sum afterwards (670 / – / 670).

## Data flags (not failures)
- **Pin Saves is "–" on every scraped pin** — same finding as QA-20334 (2026-10-19) and the 2026-10-20 run of this case. The identity only holds because Engagements equals Comments. If Pinterest still supplies saves, this is a collection gap for the data team, not an aggregate-math defect. The assertion is weak as a test of Pin Saves summation until saves data exists.
- Sephora has no Pinterest posts in the current/default week, so the case cannot be evaluated in its default state; the date range was chosen to match the earlier run (no range in the spec).
- Average shows 0 for Engagements/Comments because the per-post mean is ~0.01.

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history / known-quirks had no QA-24283 matches (pre-fetched). No known bug reproduced; the `Pinterest Only: Basic` data-set quirk (generic data set shows Posts (0)) was handled by selecting the channel-specific data set.

## Bugs filed
None (markdown-only).

## Cleanup
None (read-only).
