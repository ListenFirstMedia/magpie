# QA-20984 — Brand > Paid - Data QA - TikTok

**Run date:** 2026-11-17 (Tuesday)
**Track:** Playwright MCP, unattended (`claude -p`), dev `app.lfmdev.in`, login `lfiqa` switched to account **Amazon Prime Video** (account_id=342)
**Brand:** Amazon Prime Video (brand_id=25864, exact typeahead result) · Channel: TikTok only · Date range: Feb 01, 2025 – Mar 31, 2025 · URL `perspective=extended`
**Verdict: PASS** — all five assertions hold. The post-table header (21), table rows (21) and Active Ads tile (21) match. The Spend, Clicks, 100% Completed Views, Reach and Paid Impressions big numbers each equal the table's aggregate (Sum) row for the paired data set.

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Login (Cognito "With existing account"), then account switch via profile menu > Search Account > `.lfm-ta-option` "Amazon Prime Video" | OK on the first attempt. Breadcrumb "ACCOUNT: AMAZON PRIME VIDEO" |
| 1 | Hover Brand in Xnav, click Paid | See Notes. The first two clicks redirected to Brand Insights because the stale brand (MTV) stayed selected after the account switch. After selecting Amazon Prime Video from the brand picker, the Paid click loaded `#explore/brand/paid?brand_id=25864` |
| 2 | Click Brand dropdown, type "Amazon Prime Video" | OK. The typeahead listed the exact "Amazon Prime Video" and it was clicked (Rule 1). Done again on the Paid page itself |
| 3 | Select Amazon Prime Video, date range Feb 01, 2025 – Mar 31, 2025 | OK. Picker START/END read "Feb 01, 2025 / Mar 31, 2025", URL `from=2025-02-01&to=2025-03-31` |
| 4 | TikTok channel only, Apply | OK. `channels=tiktok`, only the TikTok ghost `enabled` (Facebook default turned off) |
| 5 | Table View, scroll to bottom of post table | OK. The Ads table rendered within budget (no hang). Header **Ads (21)**, 21 data rows plus the Sum/Average row. Scrolled to the bottom (`05-table-bottom.png`) |
| 6 | Hover big numbers | OK. Hovered Active Ads, Spend, Clicks, Paid Impressions. Exact values read from `.tile .count[title]` |
| 7 | Data Set dropdown > Video Play | OK, `table_data_set=video_play` |
| 8 | Hover 100% Completed Views big number | OK, 459,968 |
| 9 | Data Set dropdown > Reach | OK, `table_data_set=reach` |
| 10 | Hover Reach big number | OK, 43,807,251. The first hover attempt hit the "Data Set: Reach" toolbar, so it was redone on the "Reach:" tile (`10-hover-reach.png`) |
| 11 | Hover Paid Impressions big number | OK, 43,827,219 |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A6a | 6 | Post-table header count == total posts in table == Active Ads | Header "Ads (21)"; 21 table rows; Active Ads tile `21` | PASS |
| A6b | 6 | Spend and Clicks big numbers == aggregate row (Engagements set) | Spend tile `$201,543.83` == aggregate Spend `$201,543.83`; Clicks tile `145,516` == aggregate Paid Clicks `145,516` | PASS |
| A8 | 8 | 100% Completed Views big number == aggregate row (Video Play set) | Tile `459,968` == aggregate Paid 100% Completed Views `459,968` | PASS |
| A10 | 10 | Paid Reach big number == aggregate row (Reach set) | Reach tile `43,807,251` == aggregate Paid Reach `43,807,251` | PASS |
| A11 | 11 | Paid Impressions big number == aggregate row (Reach set) | Tile `43,827,219` == aggregate Paid Impressions `43,827,219` | PASS |

## Evidence
- Big numbers (exact `.count[title]`): Active Ads 21 (-61%), Paid Impressions 43,827,219 (43.8M, -12%), Spend $201,543.83 ($202K, -6%), Clicks 145,516 (146K, +891%), Reach 43,807,251 (43.8M, -12%), 100% Completed Views 459,968 (460K, +174%). The values were identical across all three data-set views. No tile showed an authorization, failed or Reload message (`auth` check false in every view).
- Aggregate (Sum) rows:
  - Engagements: Spend $201,543.83, Paid Clicks 145,516, Paid Likes 244,990, Comments 1,142, Shares 2,395, Follows 4,253, Profile Visits 1,332.
  - Video Play: Spend $201,543.83, Paid Video Views 43,657,205, 2s 9,689,175, 6s 3,475,786, 25% 1,636,103, 50% 1,002,112, 75% 754,986, 100% 459,968, Avg View Time N/A.
  - Reach: Spend $201,543.83, Paid Impressions 43,827,219, Paid Reach 43,807,251, Paid Avg View Time per User N/A.
- Table: 21 ads, rank 1 "OMG_MyFaultLondon_Boosted" (Feb 16, 2025, $54,330.45). Ranks 19–21 are 2022 posts with $0 spend, as in earlier runs.
- Screenshots (`.playwright-out/QA-20984/`): `01-paid-landing.png`, `02-after-paid-click.png`, `03-dates-set.png`, `04-tiktok-applied.png`, `05-table-bottom.png`, `06a-hover-active-ads.png`, `06b-hover-spend.png`, `06c-hover-clicks.png`, `06d-hover-impr.png`, `08-hover-100pct.png`, `10-hover-reach.png`, `11-hover-paid-impressions.png`.

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). The pre-fetched bug-history.md and known-quirks.md had no QA-20984 matches.
- Nothing reproduced. Every number is identical to the 2026-10-22 PASS run. The 2026-10-20 "authorize and connect your account" tile state on Active Ads and Spend did not reproduce, and all tiles populated on first load.

## Notes
- **Paid → Insights redirect.** After the account switch the brand selector still held the previous account's brand (MTV, id 10765). Clicking Brand > Paid with MTV selected redirected to `#explore/brand/insights` while the tab title read "Brand Paid". The console showed 404s from `dsp-api.lfmdev.in` (`access_grants` and `data_collection_status` for brand 10765). Selecting Amazon Prime Video in the brand picker first fixed it, and Paid then loaded normally. This differs from the 10-22 run, where the picker defaulted to Amazon Prime Video after the switch. It looks like a stale-brand edge case, not a defect in this case. It is worth a skill note: select the brand before opening Paid when the picker shows a stale brand.
- Because of that redirect, the brand was selected once on Insights and again on the Paid page. Step 2 was still performed explicitly on Paid.
- The credentials were read from `config/.env`. The Playwright server cannot `require`/`import` files, so they were passed inline to `ctx._creds` and deleted after login.

## Bugs filed
None.

## Cleanup
None (read-only).
