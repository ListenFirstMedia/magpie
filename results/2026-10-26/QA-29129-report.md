# QA-29129 — Brand Content - Impressions - Data Test - Linkedin

**Run date:** 2026-10-26 (Monday) · Track: Playwright MCP, unattended headless (`claude -p`), dev (`app.lfmdev.in`)
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · **Data set:** Impressions · **Channel:** LinkedIn only · **Date range:** Last 30 Days = Sep. 25, 2026 – Oct. 24, 2026 · **View:** Authorized data (default; URL `perspective=extended`)
**Verdict: PASS** — all 132 LinkedIn posts satisfy the Impressions-sum identity, the Reach-sum identity (all "–"), and Engagement Rate = Engagements / Impressions; Engaged User Rate is an en-dash on all 132 posts.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 0 | Open-bug screen (case file "Open linked bugs") | "None open" — screen passed |
| 0 | Login: app.lfmdev.in → Cognito "With existing account" (lfiqa user) | OK (`Brand Explorer` landing) |
| 0 | Precondition: switch to UCLA (profile menu → Search Account "UCLA" → `Results` row exactly "UCLA") | OK — `account_id=799`, breadcrumb "ACCOUNT: UCLA" |
| 1 | Hover **Brand** in top nav → click **Content** | OK — `#explore/brand/content` |
| 2 | Add Brand via brand picker; select **Impressions** data set | Brand: see note. Data Set dropdown → "Impressions" (URL `table_data_set=impressions`; selector reads "Impressions") |
| 3 | Enable LinkedIn only; select Last 30 Days | Clicked off every other channel, `.channel-ghost.linkedin` is the only `enabled`, clicked **Apply** → URL `channels=linkedin`. Date picker → "Make a Selection" dropdown → **Last 30 Days** (applied immediately, no Ok button needed) → URL `from=2026-09-25&to=2026-10-24`, header "Sep. 25, 2026 - Oct. 24, 2026", Posts (132) |
| 4 | Per post: Organic Impressions + Paid Impressions | Table View scraped (132 rows + Sum/Average row), evaluated in page JS |
| 5 | Per post: Organic Reach + Paid Reach | Same scrape |
| 6 | Note Engagements and Impressions | Same scrape |

### Brand selection note (Rule 1)
No brand is named exactly "UCLA" (the typeahead for "UCLA" returns only "UCLA …" sub-brands). The UCLA account's own brand, "University of California, Los Angeles" (127756), is the repo-documented brand for this account (`skills/brand-content-native-post-check/SKILL.md`; used by the earlier QA-29127 run). It was picked from the typeahead results by exact name (`setBrand` → `ok:true`). No sub-brand was substituted. Evidence: `.playwright-out/QA-29129/02-brand-selected.png`.

## Data (Table View, LinkedIn, Impressions data set, 132 posts; Posts (132) matches row count)
Columns: Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate.
- Paid Impressions: "–" on all 132 rows (no paid LinkedIn posts in window) → treated as 0.
- Reach, Organic Reach, Paid Reach: "–" on all 132 rows (structurally absent for LinkedIn).
- Engaged User Rate: "–" on all 132 rows.
- Sample rows: rank 1 Thu Oct. 01 12:07 PM — Eng 1,331 / Imp 80,685 (Org 80,685, Paid –) / Eng Rate 1.65% (calc 1.6497%); rank 2 Sat Oct. 24 11:52 AM — Eng 882 / Imp 16,991 / 5.19% (calc 5.1909%); rank 3 Tue Oct. 20 08:46 AM — Eng 857 / Imp 15,047 / 5.70% (calc 5.6957%).
- Post dates span Fri Sep. 25 08:00 AM PDT – Sat Oct. 24 08:00 PM PDT.
- Aggregate **Sum** row: Engagements 15,234 · Impressions 1,556,527 · Organic Impressions 1,556,527 · Paid Impressions – · Reach / Organic Reach / Paid Reach / Engagement Rate / Engaged User Rate "N/A". Column sums of the 132 rows: Engagements 15,234, Impressions 1,556,527, Organic 1,556,527, Paid 0 (all match the Sum row).

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | Organic Impressions + Paid Impressions = Impressions (each post) | 132/132 equal (Paid "–" = 0, Organic = Impressions on every row); Sum row 1,556,527 = 1,556,527 + 0 | PASS |
| A5 | 5 | Organic Reach + Promoted Reach = Reach (each post) | 132/132 rows have Reach, Organic Reach and Paid Reach all "–" (0 + 0 = no value). Holds, but vacuously: LinkedIn exposes no Reach data on this data set | PASS (vacuous — see note) |
| A6a | 6 | Engagements / Impressions = Engagement Rate | 132/132 match at the 2-decimal display (tolerance ±0.01 pp); max deviation 0.0050 pp | PASS |
| A6b | 6 | Engaged User Rate displays en-dash | 132/132 rows show "–" | PASS |

Notes: the Reach identity cannot detect a wrong Reach calculation on LinkedIn because every Reach metric is empty; the case's own spec (A6b) expects Engaged User Rate (Engagements / Reach) to be an en-dash, which is consistent with Reach being absent. The Sum row shows "N/A" (not "–") for Reach and Engaged User Rate — an aggregate-row convention, not a per-post value; the assertion is about the per-post grid.

## Evidence
Screenshots under `.playwright-out/QA-29129/`: `01-brand-content-initial.png`, `02-brand-selected.png`, `03-impressions-linkedin.png`, `04-datepicker.png`, `05-last30-selected.png`, `06-after-preset.png`, `07-table-view-sum.png` (other files in the folder are leftovers from an earlier aborted attempt).
Final URL: `#explore/brand/content?brand_id=127756&account_id=799&from=2026-09-25&to=2026-10-24&channels=linkedin&perspective=extended&stats_attribution_window=lifetime&table_data_set=impressions&…`
Console showed app errors on dev throughout (log under `.playwright-out/console-2026-10-26T09-16-33-805Z.log`); none affected the grid or the assertions.

## Known bugs checked
- Case file "Open linked bugs (as of 2026-10-20)": none open (Rule 7 screen passed).
- `knowledge-base/bug-history.md` and `knowledge-base/known-quirks.md`: no entries for QA-29129 (shell-side pre-fetch). The open APPS-60871 (en-dash across Twitter/Instagram/YouTube datasets) is tracked on QA-29128 and touches other channels; it does not apply to this LinkedIn case, and no unexpected en-dashes appeared in the metrics that carry data (Impressions, Organic Impressions, Engagements, Engagement Rate present on all 132 posts).

## Bugs filed
None.

## Observations for harvest
- UI: the "Make a Selection" date dropdown in the Brand Content date picker offers presets (Last 7/30/90 Days, 6/12 Months, quarters, months); picking one applies the range immediately and closes the picker (no Ok click). Worth adding to `brand-content-grid-math` (date range step).
- Fresh login lands on `app.lfmdev.in/` titled "Brand Explorer"; `switchAccount` still works from there.
