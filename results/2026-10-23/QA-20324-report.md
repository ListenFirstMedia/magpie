# QA-20324 — Brand Content > Engagements Breakdowns Data Set > Past date range data test

**Run date:** 2026-10-23 (Friday → Hulu / Hulu) · **Track:** Playwright MCP, headless `claude -p` · **Env:** app.lfmdev.in as lfiqa@listenfirstmedia.com · **Account:** HULU (account_id 336) · **Brand:** Hulu (brand_id 5670, the account's default brand; exact spec name) · **Data set:** Engagements Breakdown (`table_data_set=engagements_breakdown`) · **Date range:** Jun. 01, 2023 – Dec. 31, 2023 (`from=2023-06-01&to=2023-12-31`) · **Perspective:** Authorized data (`perspective=extended`, app default) · **View:** Table View, top 200 rendered rows per channel plus the Sum/Average row (Sum toggle state).

**Verdict: FAIL — Instagram holds on every assertion (200/200). Twitter A5 fails: 2 of the top-200 posts show a total Engagements value with "–" in both Organic and Paid Engagements, so Organic + Paid ≠ Engagements. The Twitter Sum row shows the same gap. A6 and A7 hold on Twitter.**

## Steps executed
1. Logged in via the Cognito "With existing account" form. Account was `lfiqa` default (account_id 597), so I switched to **Hulu** via the profile menu → Search Account → Results → real mouse click. Confirmed `ACCOUNT: HULU` and `account_id=336`.
2. Step 1: hovered **Brand** in the top nav and clicked **Content**. Brand Content loaded for brand "Hulu" (5670).
3. Step 2: brand "Hulu" was already selected as the account default. I did not substitute any brand. Selected data set **Engagements Breakdown** from the visible Data Set dropdown. URL shows `table_data_set=engagements_breakdown`. Channels auto-restricted to Twitter + Instagram enabled and all others disabled.
4. Step 3: opened the date picker and set START DATE **Jun 01, 2023** and END DATE **Dec 31, 2023**, then clicked **Ok**. URL shows `from=2023-06-01&to=2023-12-31`.
5. Step 4: Twitter was enabled and I clicked the Instagram ghost to disable it, so only Twitter was enabled (`.channel-ghost.twitter.enabled` only). Clicked **Apply**. Result: `channels=twitter`, **Posts (648)**.
6. Steps 5–7: switched to **Table View** (201 `tbody` rows = 200 posts + Sum/Average row) and evaluated all three identities on every rendered post in page JS.
7. Step 8: enabled Instagram, disabled Twitter (last-channel rule respected), clicked **Apply**. Result: `channels=instagram`, **Posts (549)**. All 200 rendered rows link to instagram.com and carry the Instagram channel icon.
8. Steps 9–11: same three identities on the Instagram table.

## Assertions

### Twitter only (Posts 648; top 200 evaluated)
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 | Organic Engagements + Paid Engagements = Engagements | **198/200 ✓** (rank 1: 557 + 22,512 = 23,069 ✓; rank 2: 608 + 12,998 = 13,606 ✓; Paid "–" treated as 0 on 166 organic-only posts). **2/200 ✗:** rank 69 (Fri Jun. 30, 2023 06:40 AM PDT, Text, @hulu) Engagements **743** with Organic "–" / Paid "–"; rank 152 (Fri Jun. 30, 2023 08:05 AM PDT, Video, @hulu) Engagements **239** with Organic "–" / Paid "–". **Sum row:** Organic 182,118 + Paid 112,936 = 295,054 vs Engagements **296,252** (gap 1,198 ≠ 0). | ❌ FAIL |
| A6 | 6 | Organic Reactions + Organic Comments + Organic Shares = Organic Engagements | **198/198 ✓** (rank 1: 0 + 171 + 386 = 557 ✓; rank 2: 0 + 65 + 543 = 608 ✓). 2 posts (rank 69, 152) have Organic Engagements "–" → no data, skipped and counted. **Sum row:** 120,888 + 32,748 + 28,482 = 182,118 ✓ | ✅ PASS |
| A7 | 7 | Paid Reactions + Paid Comments + Paid Shares = Paid Engagements | **34/34 ✓** (rank 1: 21,729 + 97 + 686 = 22,512 ✓; rank 2: 12,634 + 14 + 350 = 12,998 ✓). 166 organic-only posts have Paid Engagements "–" → no data, skipped. **Sum row:** 105,540 + 1,349 + 6,047 = 112,936 ✓ | ✅ PASS |

### Instagram only (Posts 549; top 200 evaluated)
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A9 | 9 | Organic Engagements + Paid Engagements = Engagements | **200/200 ✓** (rank 1: 617,452 + 195,264 = 812,716 ✓; rank 2: 522,410 + – = 522,410 ✓; rank 3: 156,449 + 183,070 = 339,519 ✓; Paid "–" treated as 0 on 158 organic-only posts). **Sum row:** 6,238,778 + 2,053,356 = 8,292,134 ✓ | ✅ PASS |
| A10 | 10 | Organic Reactions + Organic Comments + Organic Shares = Organic Engagements | **200/200 ✓** (rank 1: 617,137 + 315 + – = 617,452 ✓; rank 2: 521,121 + 1,289 + – = 522,410 ✓; rank 3: 156,170 + 279 + – = 156,449 ✓). Shares is "–" on every Instagram row and on the Sum row (structurally absent for Instagram → 0). **Sum row:** 6,193,376 + 45,402 + 0 = 6,238,778 ✓ | ✅ PASS |
| A11 | 11 | Paid Reactions + Paid Comments + Paid Shares = Paid Engagements | **42/42 ✓** (rank 1: 194,929 + 335 + – = 195,264 ✓; rank 3: 182,491 + 579 + – = 183,070 ✓; rank 5: 79,848 + 432 + – = 80,280 ✓). 158 organic-only posts have Paid Engagements "–" → no data, skipped. **Sum row:** 2,029,843 + 23,513 + 0 = 2,053,356 ✓ | ✅ PASS |

## Evidence
- Screenshots: `.playwright-out/QA-20324/01-brand-content.png`, `02-data-set-eb.png`, `03-datepicker-open.png`, `04-start-set.png`, `05-range-set.png`, `06-twitter-only-before-apply.png`, `07-twitter-applied.png`, `08-twitter-table.png`, `09-instagram-only-before-apply.png`, `10-instagram-table.png`.
- Twitter failing row 69: Fri Jun. 30, 2023 06:40 AM PDT, Type Text, Engagements 743, Organic Engagements "–", Paid Engagements "–", Reactions 385, Comments 336, Shares 22, all Organic/Paid Reactions/Comments/Shares "–"; text "💚this tweet and get a special reminder for @gofooji #Essenc…".
- Twitter failing row 152: Fri Jun. 30, 2023 08:05 AM PDT, Type Video, Engagements 239, Organic Engagements "–", Paid Engagements "–", Reactions 201, Comments 7, Shares 31, all Organic/Paid splits "–"; text "Working 5 days in a row is so yesterday. #HIMYF https://t.co…".
- Both Twitter rows have a total Engagements value that equals their Reactions + Comments + Shares (385 + 336 + 22 = 743; 201 + 7 + 31 = 239), so only the Organic/Paid split is missing.
- Rendered-row sums (200 posts) differ from the Sum row (which spans all 648 posts), as expected: Twitter rendered Engagements 257,232 vs Sum row 296,252.
- The two failing posts are both dated Jun. 30, 2023, which suggests a collection gap on that date for the Organic/Paid split.

## Known bugs checked
- Case file "Open linked bugs (as of 2026-10-19)": **None open**, so the Rule 7 auto-fail screen passed and the case was run.
- `knowledge-base/bug-history.md` and `known-quirks.md`: no entries for QA-20324 (pre-fetched). One targeted known-quirks grep for the Organic/Paid split pattern found nothing matching.
- Related surface: QA-20321 (2026-10-19, HBO Max Impressions) FAILED on the same pattern for Facebook, where a total value has "–" in the Organic/Paid split. That is the same class of defect (total populated without the split) on a different metric and channel. Triage should check whether it is one root cause. No linked bug explains the Twitter Jun. 30, 2023 gap.
- Sum-row mismatch (1,198) is larger than the two rendered posts account for (982). The remaining 216 likely comes from further unsplit posts outside the top 200 (Posts 648), not verified.

## Bugs filed
None auto-filed (markdown only). **Candidate for triage:** Hulu Twitter, Engagements Breakdown, Jun. 01 – Dec. 31, 2023. At least 2 of the top-200 posts (Jun. 30, 2023, ranks 69 and 152) have Engagements with no Organic/Paid split, and the Sum row's Organic + Paid is 1,198 short of Engagements. Expected Organic + Paid = Engagements.

## Cleanup
None needed (read-only test). The browser session was left open; no data was changed.
