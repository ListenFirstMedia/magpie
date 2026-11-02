# QA-100877 — Brand > Content - Impressions Data Set - Threads

**Run date:** 2026-10-30 (Friday) · **Track:** Playwright MCP, unattended headless, dev `app.lfmdev.in`, skill `brand-content-grid-math` + shared devprod helpers · **Account:** HBO Max (header "ACCOUNT: HBO MAX", switched from the post-login default HULU via profile menu Search Account → Results → `HBO Max`) · **Brand:** HBO Max (brand_id 155614; spec says "Max" — see Notes) · **Date range:** Jan 01, 2026 – Jan 15, 2026 (START/END picker; fields read back "Jan 01, 2026 / Jan 15, 2026", URL `from=2026-01-01&to=2026-01-15`) · **Data set:** Impressions (`table_data_set=impressions`) · **Channel:** Threads only (`channels=threads`; enabled ghosts = `threads` only) · **View:** default Authorized data (`perspective=extended`; spec gives no perspective) · **Layout:** Table View.

**Verdict: FAIL** — Organic Impressions and Paid Impressions render "–" on all 13 Threads posts (and the Sum row) while Impressions is populated (e.g. 79,189 / 208,049 / 33,035), so Organic Impressions + Paid Impressions = Impressions cannot hold (A6). Reach / Organic Reach / Paid Reach are also "–" on every post, so A7 is not evaluable. Engagements ÷ Impressions = Engagement Rate holds 13/13 and Engaged User Rate shows the en-dash on all 13 posts. Same pattern as the 2026-10-20 (interactive) and 2026-10-26 → 10-29 (unattended) runs; only the live Threads counts drifted slightly (e.g. post #1 Impressions 79,147 → 79,189) — no regression.

## Steps executed
1. Precondition: logged in via Cognito "With existing account" (lfiqa@listenfirstmedia.com); landed on account HULU; switched account to **HBO Max** (header confirmed "ACCOUNT: HBO MAX").
2. Hovered **Brand** in top nav → **Content** → `#explore/brand/content` (default brand HBO Max, 194 posts for the default week Oct 22–28).
3. Brand dropdown: typed "Max"; **no exact "Max" option** (95 options, first: `Max & Harvey`, `Max & Shred`, `Max (2015)`, `Max (Band)`, `Max Aaron`, …; none matching `^Max$`; screenshot `s3-typeahead-max.png`). Typed "HBO Max" → exact `HBO Max` option clicked (brand selector reads "HBO Max", `brand_id=155614`). Same resolution as every prior run — see Notes (Rule 1).
4. Date picker → START Jan 01, 2026, END Jan 15, 2026 → Ok.
5. Data set dropdown → **Impressions** (`table_data_set=impressions`; Posts (436) across all channels).
6. Channels: enabled Threads, disabled all others → Apply → `channels=threads`, `Posts (13)`; no "failed to load" or render hang this run (the known-quirks Threads render-hang entry did not reproduce).
7. Switched to Table View (`[title="Table View"]`); scraped all 13 rows + aggregate row from the Rank-header `table.lfm-table` (every post row shows the Threads icon; every Brand cell = HBO Max).
8. Evaluated in page JS: Organic + Paid Impressions vs Impressions; Organic + Paid Reach vs Reach; Engagements ÷ Impressions vs Engagement Rate; Engaged User Rate display.

## Assertions
| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A6 | 6 | Organic Impressions + Paid Impressions = Impressions (each post) | 0/13 hold. Organic Impressions "–" and Paid Impressions "–" on every post and the Sum row; Impressions populated (#1 79,189; #2 208,049; #3 33,035; #4 22,553; #5 41,592; #6 4,025; #7 4,352; #8 7,058; #9 3,988; #10 4,802; #11 8,032; #12 1,524; #13 1,962; Sum 420,161). Column sums: Organic 0 + Paid 0 vs Impressions 420,161 | FAIL |
| A7 | 7 | Organic Reach + Paid Reach = Reach | Reach, Organic Reach, Paid Reach all "–" on all 13 posts; aggregate row "N/A" — no Threads Reach data, nothing to compare | Not evaluable (neither pass nor fail) |
| A8a-1 | 8 | Engagements ÷ Impressions = Engagement Rate (#1) | 5,866 / 79,189 = 7.408%; shown 7.41% | PASS |
| A8a-2 | 8 | same (#2) | 3,052 / 208,049 = 1.467%; shown 1.47% | PASS |
| A8a-3 | 8 | same (#3) | 2,141 / 33,035 = 6.481%; shown 6.48% | PASS |
| A8a-4 | 8 | same (#4) | 776 / 22,553 = 3.441%; shown 3.44% | PASS |
| A8a-5 | 8 | same (#5) | 730 / 41,592 = 1.755%; shown 1.76% | PASS |
| A8a-6 | 8 | same (#6) | 492 / 4,025 = 12.224%; shown 12.22% | PASS |
| A8a-7 | 8 | same (#7) | 346 / 4,352 = 7.950%; shown 7.95% | PASS |
| A8a-8 | 8 | same (#8) | 324 / 7,058 = 4.591%; shown 4.59% | PASS |
| A8a-9 | 8 | same (#9) | 291 / 3,988 = 7.297%; shown 7.30% | PASS |
| A8a-10 | 8 | same (#10) | 112 / 4,802 = 2.332%; shown 2.33% | PASS |
| A8a-11 | 8 | same (#11) | 88 / 8,032 = 1.096%; shown 1.10% | PASS |
| A8a-12 | 8 | same (#12) | 24 / 1,524 = 1.575%; shown 1.57% | PASS |
| A8a-13 | 8 | same (#13) | 12 / 1,962 = 0.612%; shown 0.61% | PASS |
| A8a-Sum | 8 | Sum row identity | Sum Engagements 14,254 / Sum Impressions 420,161 = 3.393% (both equal independent column sums); Sum row's own Engagement Rate cell shows "N/A" | Informational |
| A8b | 8 | Engaged User Rate displays en-dash | "–" on 13/13 posts (aggregate row "N/A") | PASS |

A8a comparisons are within ±0.0051 pp of the 2-decimal display (skill rounding tolerance).

## Evidence
- Screenshots in `.playwright-out/QA-100877/`: `s0-account-hbomax.png`, `s1-brand-content-landing.png`, `s3-typeahead-max.png`, `s3-brand-selected.png`, `s3-dates.png`, `s5-threads.png`, `s6-table-view.png` (viewed: Data Set "Impressions", only the Threads ghost enabled, Posts (13), Sum row Engagements 14,254 / Engagement Rate N/A / Impressions 420,161 / Organic & Paid Impressions "–"; first post row shows Threads icon, HBO Max, Engagements 5,866, Engagement Rate 7.41%, Impressions 79,189, Organic/Paid Impressions "–").
- Numbers read from the Table View DOM. Column headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Engagement Rate, Impressions, Organic Impressions, Paid Impressions, Reach, Organic Reach, Paid Reach, Engaged User Rate, Actions.
- Aggregate (Sum) row: Engagements 14,254 · Engagement Rate N/A · Impressions 420,161 · Organic Impressions – · Paid Impressions – · Reach N/A · Organic Reach N/A · Paid Reach N/A · Engaged User Rate N/A.
- Column sums computed independently (hand-checked): Engagements 14,254, Impressions 420,161, Organic Impressions 0, Paid Impressions 0, Reach 0 ("–" treated as 0).
- Final URL: `brand_id=155614&account_id=657&from=2026-01-01&to=2026-01-15&channels=threads&perspective=extended&table_data_set=impressions`.
- Console showed the usual dev errors (log `.playwright-out/console-2026-10-30T06-59-51-299Z.log`); none affected the Content table.

## Notes
- **Spec brand "Max" vs "HBO Max" (Rule 1):** the HBO Max account's brand typeahead has no exact "Max". The separate "Max" brand (brand_id 412264) lives on the Adam Orfei account and has no Threads channel (known-quirks), so it cannot satisfy this Threads case; the case's precondition is "User logged in as HBO Max", and the account's own brand `HBO Max` has Threads data. Treated as the spec's intended brand (identical to the 2026-10-20 interactive, user-confirmed → 10-29 resolution). Strictly this is a spec-vs-test-data gap — the case text should be updated to "HBO Max".
- **A6 cause:** Threads impressions on dev carry no organic/paid split (components "–" while the total is populated). The same pattern was identical on Dev and Prod in QA-100880 (2026-10-20), so it reflects how Threads impressions are modelled, not an environment defect. The spec's A6/A7 expectation needs a product decision (populate Organic Impressions = Impressions for Threads, or drop A6/A7 from the Threads case). `known-quirks.md` has no accepted-quirk entry for the Threads organic/paid impression split (one narrow grep), so the verdict stays FAIL.
- Treating "–" as 0 (skill rule for structurally-absent components) does not rescue A6: 0 + 0 ≠ Impressions.

## Known bugs checked
Case file "Open linked bugs": none open (Rule 7 screen passed). `bug-history.md` and `known-quirks.md`: no matches for QA-100877 (pre-fetched). No known bug explains the A6 failure; A8a/A8b held on every row.

## Bugs filed
None filed in Jira (markdown-only policy). **Candidate for triage (unchanged since 2026-10-20):** Brand > Content, Impressions data set, Threads — Organic/Paid Impressions and all Reach columns render "–" for every post although total Impressions is populated, contradicting the spec's Organic + Paid = Impressions identity.

## Cleanup
None (read-only; no mutations).

**Verdict: FAIL**
