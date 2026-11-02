# QA-100877 — Brand > Content - Impressions Data Set - Threads

**Run date:** 2026-10-27 (Tuesday) · **Track:** Playwright MCP, unattended headless, dev `app.lfmdev.in`, skill `brand-content-grid-math` + shared devprod helpers · **Account:** HBO Max (header "ACCOUNT: HBO MAX", switched from the post-login default TIFFANY & CO. via profile menu Search Account → Results → `HBO Max`) · **Brand:** HBO Max (brand_id 155614; spec says "Max" — see Notes) · **Date range:** Jan 01, 2026 – Jan 15, 2026 (START/END picker; fields read back "Jan 01, 2026 / Jan 15, 2026") · **Data set:** Impressions (`table_data_set=impressions`) · **Channel:** Threads only (`channels=threads`; enabled ghosts = `threads` only) · **View:** default Authorized data (spec gives no perspective) · **Layout:** Table View.

**Verdict: FAIL** — Organic Impressions and Paid Impressions render "–" on all 13 Threads posts (and the Sum row) while Impressions is populated (e.g. 79,147 / 207,811 / 33,008), so Organic Impressions + Paid Impressions = Impressions cannot hold (A6). Reach / Organic Reach / Paid Reach are also "–" on every post, so A7 is not evaluable. Engagements ÷ Impressions = Engagement Rate holds 13/13 and Engaged User Rate shows the en-dash on all 13 posts. Result is identical to the 2026-10-20 (interactive) and 2026-10-26 (unattended) runs — no change, no regression.

## Steps executed
1. Precondition: logged in via Cognito "With existing account" (lfiqa@listenfirstmedia.com); landed on TIFFANY & CO.; switched account to **HBO Max** (header confirmed "ACCOUNT: HBO MAX").
2. Hovered **Brand** in top nav → **Content** → `#explore/brand/content`.
3. Brand dropdown: typed "Max"; **99 typeahead options, no exact "Max"** (first: `Max & Harvey`, `Max & Shred`, `Max (2015)`, `Max (Band)`, …; none matching `^Max$`, none containing "HBO"; screenshot `02-brand-typeahead-Max.png`). Per Rule 1 documented below; used the account's own brand `HBO Max` (selected via typeahead "HBO Max" exact result; brand selector reads "HBO Max"), same resolution as 2026-10-20 / 2026-10-26.
4. Date picker → START Jan 01, 2026, END Jan 15, 2026 → Ok → URL `from=2026-01-01&to=2026-01-15`.
5. Data set dropdown → **Impressions** (`table_data_set=impressions`).
6. Channels: enabled Threads, disabled all others (trusted clicks) → Apply → `channels=threads`, `Posts (13)`.
7. Switched to Table View (`[title="Table View"]`); scraped all 13 rows + aggregate row from the Rank-header `table.lfm-table` (all 13 rows carry the Threads icon; every Brand cell = HBO Max).
8. Evaluated in page JS: Organic + Paid Impressions vs Impressions; Organic + Paid Reach vs Reach; Engagements ÷ Impressions vs Engagement Rate; Engaged User Rate display.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A6 | 6 | Organic Impressions + Paid Impressions = Impressions (each post) | 0/13 hold. Organic Impressions "–" and Paid Impressions "–" on every post and the Sum row; Impressions populated (#1 79,147; #2 207,811; #3 33,008; #4 22,490; #5 41,592; #6 4,019; #7 4,341; #8 7,054; #9 3,985; #10 4,791; #11 8,028; #12 1,521; #13 1,958; Sum 419,745) | FAIL |
| A7 | 7 | Organic Reach + Paid Reach = Reach | Reach, Organic Reach, Paid Reach all "–" on all 13 posts; aggregate row "N/A" — no Threads Reach data, nothing to compare | Not evaluable (neither pass nor fail) |
| A8a-1 | 8 | Engagements ÷ Impressions = Engagement Rate (#1) | 5,886 / 79,147 = 7.437%; shown 7.44% | PASS |
| A8a-2 | 8 | same (#2) | 3,065 / 207,811 = 1.475%; shown 1.47% | PASS |
| A8a-3 | 8 | same (#3) | 2,152 / 33,008 = 6.520%; shown 6.52% | PASS |
| A8a-4 | 8 | same (#4) | 778 / 22,490 = 3.459%; shown 3.46% | PASS |
| A8a-5 | 8 | same (#5) | 730 / 41,592 = 1.755%; shown 1.76% | PASS |
| A8a-6 | 8 | same (#6) | 496 / 4,019 = 12.341%; shown 12.34% | PASS |
| A8a-7 | 8 | same (#7) | 346 / 4,341 = 7.971%; shown 7.97% | PASS |
| A8a-8 | 8 | same (#8) | 324 / 7,054 = 4.593%; shown 4.59% | PASS |
| A8a-9 | 8 | same (#9) | 292 / 3,985 = 7.327%; shown 7.33% | PASS |
| A8a-10 | 8 | same (#10) | 114 / 4,791 = 2.379%; shown 2.38% | PASS |
| A8a-11 | 8 | same (#11) | 88 / 8,028 = 1.096%; shown 1.10% | PASS |
| A8a-12 | 8 | same (#12) | 24 / 1,521 = 1.578%; shown 1.58% | PASS |
| A8a-13 | 8 | same (#13) | 13 / 1,958 = 0.664%; shown 0.66% | PASS |
| A8a-Sum | 8 | Sum row identity | Sum Engagements 14,308 / Sum Impressions 419,745 = 3.409% (both equal independent column sums); Sum row's own Engagement Rate cell shows "N/A" | Informational |
| A8b | 8 | Engaged User Rate displays en-dash | "–" on 13/13 posts (aggregate row "N/A") | PASS |

A8a comparisons are within ±0.01 pp of the 2-decimal display (skill rounding tolerance).

## Evidence
- Screenshots in `.playwright-out/QA-100877/`: `01-content-landing.png`, `02-brand-typeahead-Max.png`, `03-brand-dates.png`, `04-impressions-threads.png`, `05-table-view.png` (Data Set: Impressions, Threads-only channel selector, View: Authorized data, Posts (13), Sum row Engagements 14,308 / Engagement Rate N/A / Impressions 419,745 / Organic Impressions "–").
- Numbers read from the Table View DOM. Column headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate, Actions.
- Aggregate (Sum) row: Engagements 14,308 · Engagement Rate N/A · Impressions 419,745 · Organic Impressions – · Paid Impressions – · Reach N/A · Organic Reach N/A · Paid Reach N/A · Engaged User Rate N/A.
- No "This table failed to load" occurred; the post counter was slow to settle after Apply but Posts (13) rendered.

## Notes
- **Spec brand "Max" vs "HBO Max" (Rule 1):** the HBO Max account's brand typeahead has no exact "Max". The separate "Max" brand (brand_id 412264) lives on the Adam Orfei account and has no Threads channel (known-quirks, first observed 2026-06-27), so it cannot satisfy this Threads case; the case's precondition is "User logged in as HBO Max", and the account's own brand `HBO Max` has Threads data. Treated as the spec's intended brand (identical to the 2026-10-20 and 2026-10-26 resolution). The case text should be updated to "HBO Max".
- **A6 cause:** Threads impressions on dev carry no organic/paid split (components "–" while the total is populated). The same pattern was identical on Dev and Prod in QA-100880 (2026-10-20), so it reflects how Threads impressions are modelled, not an environment defect. The spec's A6/A7 expectation needs a product decision (populate Organic Impressions = Impressions for Threads, or drop A6/A7 from the Threads case). A narrow `known-quirks.md` grep for Threads organic/paid impression split found no accepted-quirk entry, so the verdict stays FAIL.
- Treating "–" as 0 (skill rule for structurally-absent components) does not rescue A6: 0 + 0 ≠ Impressions.

## Known bugs checked
Case file "Open linked bugs": none open (Rule 7 screen passed). `bug-history.md` and `known-quirks.md`: no matches for QA-100877 (pre-fetched). No known bug explains the A6 failure; A8a/A8b held on every row.

## Bugs filed
None filed in Jira (markdown-only policy). **Candidate for triage:** Brand > Content, Impressions data set, Threads — Organic/Paid Impressions and all Reach columns render "–" for every post although total Impressions is populated, contradicting the spec's Organic + Paid = Impressions identity.

## Cleanup
None (read-only).

**Verdict: FAIL**
