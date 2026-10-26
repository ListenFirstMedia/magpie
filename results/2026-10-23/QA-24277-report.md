# QA-24277 — Brand Content - Engagement Breakdown Data Set - Aggregate Data Test

**Run date:** 2026-10-23 (Friday → Hulu / Hulu) · **Track:** Playwright MCP, unattended headless · **Account:** Hulu (account_id 336; switched from the post-login default UCLA via profile menu → Search Account → Results → `Hulu`) · **Brand:** Hulu (brand_id 5670, exact `Hulu` row clicked from the brand typeahead Results — Rule 1) · **Date range:** app default Oct. 15 – Oct. 21, 2026 (spec gives none; not changed) · **Data set:** Engagements Breakdown (auto-narrows channels to Twitter + Instagram; `table_data_set=engagements_breakdown`) · **Layout:** Table View, aggregate row read in Sum and Average modes (`#aggregate_row`, unchecked = Sum, checked = Average) · **Posts:** 85

**Verdict: FAIL — A4 does not hold on the Sum row (off by 1). A5 and A6 PASS.**
Cause: one Twitter post (rank 85, Mon Oct. 19 2026 02:00 PM PDT, a Gif, "(1/2) Raise your hand if you've been personally victimized by caricatu…") shows Engagements = 1 with Organic Engagements = "–" and Paid Engagements = "–". The total carries a value but has no organic/paid split, so the aggregate Organic + Paid is 1 short of Engagements. This is a data/product gap, not a test-setup error: I scraped all 85 rows and it is the only row where the identity breaks.

## Steps executed
1. Login via Cognito "With existing account" (lfiqa@listenfirstmedia.com). The first two sign-in attempts returned `PreAuthentication failed … Task timed out after 3.00 seconds` (transient auth Lambda timeout); the third attempt, after a ~20 s wait, succeeded. Landed on `#home` with ACCOUNT: UCLA, so switched account to Hulu (Friday precondition) → header "ACCOUNT: HULU".
2. Step 1: hovered **Brand** in the top nav → clicked **Content** → `#explore/brand/content?brand_id=5670&account_id=336`.
3. Step 2 (Add a Brand): opened the brand selector, typed "Hulu" slowly into "Search for a Brand", Results listed the exact `Hulu` first (alongside `Hulu (Brazil)`, `Hulu (Japan)`, `Hulu (LATAM)`, show-title brands), clicked the literal `Hulu` option → brand_id stayed 5670.
4. Switched to **Table View** (`[title="Table View"]`).
5. Step 3: opened the data-set dropdown and clicked **Engagements Breakdown** → URL `channels=twitter&channels=instagram&table_data_set=engagements_breakdown`, Posts (85).
6. Steps 4–6: read the aggregate row (Rank cell "Sum Average") in Sum mode, clicked the Sum/Average toggle and read it in Average mode. Also scraped all 85 post rows via DOM to find the source of any mismatch.

## Assertions
Column values read from the aggregate `tbody tr:first-child` of the visible `table.lfm-table` (Rank header).

| ID | Step | Expected | Actual (Sum row) | Actual (Average row) | Status |
|---|---|---|---|---|---|
| A4 | 4 | Organic Engagements + Paid Engagements = Engagements | 838,210 + 1,148 = **839,358** vs Engagements **839,359** (Δ −1) | 9,861 + 14 = 9,875 vs 9,875 ✓ | **FAIL** (Sum row Δ1; Average row passes, the 1-unit gap is hidden by rounding) |
| A5 | 5 | Organic Reactions + Organic Comments + Organic Shares = Organic Engagements | 831,952 + 5,142 + 1,116 = 838,210 vs 838,210 ✓ | 9,788 + 60 + 13 = 9,861 vs 9,861 ✓ | PASS |
| A6 | 6 | Paid Reactions + Paid Comments + Paid Shares = Paid Engagements | 1,141 + 7 + – (0) = 1,148 vs 1,148 ✓ | 13 + 0 + – (0) = 13 vs 14 (Δ1 = rounding of individually-rounded averages; exact 1,148 ÷ 85 = 13.5) | PASS (rounding noted) |

### Root-cause evidence for A4
- My own column totals over the 85 scraped rows equal the displayed Sum row exactly: Engagements 839,359 · Organic 838,210 · Paid 1,148 (so the Sum row is a faithful sum of the rows; the shortfall is in the rows).
- Per-post identity Organic + Paid = Engagements: 84 of 85 posts hold; exactly **1 breaks** — rank 85 (Twitter Gif, Oct. 19 2026 02:00 PM PDT, https://twitter.com/15033883/status/2112287743250485263): Engagements 1, Organic Engagements –, Paid Engagements –, Reactions 0, Organic/Paid Reactions –, Comments 1, Organic/Paid Comments –, Shares 0, Organic/Paid Shares –.
- Per-post A5 (Organic Reactions + Comments + Shares = Organic Engagements) and A6 (Paid …) hold on all rows where the total is present: 0 failures each.
- Same pattern as the "total value with no organic/paid split" candidates logged for QA-20321 on 2026-10-19 (Facebook); here it surfaces on a Twitter post in the live week.

## Evidence
Screenshots in `.playwright-out/QA-24277/`: `20261023-01-hulu-eb-sum.png` (Sum row, Engagements Breakdown, Hulu), `20261023-02-hulu-eb-post85-nosplit.png` (rank-85 post with "–" split), `20261023-03-hulu-eb-avg.png` (Average row). Numbers above are from DOM reads, not from the screenshots.

## Notes
- Judgment call: the A4 mismatch is 1 engagement out of 839,359 and traces to one post lacking a split, but the assertion is an equality on the aggregate and the Sum row does not satisfy it, so it is recorded as FAIL rather than PASS-with-rounding. The Sum row is exact integer arithmetic, so rounding cannot explain it. If the product owners treat "total present, split not yet collected" as expected for very recent posts (this post is ~3 days old; data last updated 10-22), the verdict could be revisited; I did not find a known-quirk covering it.
- Channel scope: Engagements Breakdown limits the table to Twitter + Instagram, so the aggregate covers those two channels only; no other channels were enabled or substituted.
- Previous run (2026-10-19, HBO Max, Monday row) PASSED all three; this run is a different weekday brand and week, so not a regression comparison.
- The account switch was required because the login lands on UCLA, not Hulu.
- Spec note "Also use Amazon Prime Video on alternative days" not applied; the weekday row (Friday: Hulu) was used.

## Known bugs checked
Case file "Open linked bugs": none open (Rule 7 screen passed). `knowledge-base/bug-history.md` and `knowledge-base/known-quirks.md`: no matches for QA-24277 (pre-fetched), plus one narrow known-quirks grep on organic/paid split / Engagements Breakdown — no match. No existing bug attributed to this mismatch; flagged below as a candidate.

## Bugs filed
None filed (markdown-only, no Jira auto-creation). **Candidate for the team:** Brand > Content (Engagements Breakdown, Hulu, Twitter) — a post can show a non-zero Engagements total with Organic/Paid Engagements both "–", making aggregate Organic + Paid ≠ Engagements. Repro: Hulu → Brand > Content → Table View → Engagements Breakdown, default week Oct. 15–21 2026, post at Oct. 19 2026 02:00 PM PDT. · **Cleanup:** none (read-only).
