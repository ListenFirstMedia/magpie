# QA-20984 — Brand > Paid - Data QA - TikTok

**Run date:** 2026-11-18 (Wednesday)
**Track:** Playwright MCP, unattended (`claude -p`), dev `app.lfmdev.in`, login `lfiqa` switched to account **Amazon Prime Video** (account_id=342)
**Brand:** Amazon Prime Video (brand_id=25864, exact typeahead result) · Channel: TikTok only · Date range: Feb 01, 2025 – Mar 31, 2025 · URL `perspective=extended`
**Verdict: PASS** — all five assertions hold. The post-table header (21), table rows (21) and Active Ads tile (21) match. The Spend, Clicks, 100% Completed Views, Reach and Paid Impressions big numbers each equal the table's aggregate (Sum) row for the paired data set.

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Login (Cognito "With existing account"), then account switch via profile menu > Search Account > `.lfm-ta-option` "Amazon Prime Video" | OK on the first attempt. Breadcrumb "ACCOUNT: AMAZON PRIME VIDEO" |
| 1 | Hover Brand in Xnav, click Paid | OK. Loaded `#explore/brand/paid?brand_id=25864`. The brand picker already showed Amazon Prime Video, so there was no stale-brand redirect today |
| 2 | Click Brand dropdown, type "Amazon Prime Video" | OK. The typeahead listed the exact "Amazon Prime Video" and it was clicked (Rule 1) |
| 3 | Select Amazon Prime Video, date range Feb 01, 2025 – Mar 31, 2025 | OK. Picker START/END read "Feb 01, 2025 / Mar 31, 2025", URL `from=2025-02-01&to=2025-03-31` |
| 4 | TikTok channel only, Apply | OK. TikTok ghost enabled first, Facebook (default) turned off, Apply clicked. `channels=tiktok`, only the TikTok ghost `enabled` |
| 5 | Table View, scroll to bottom of post table | OK. Header **Ads (21)**, 21 data rows plus the Sum/Average row. Scrolled to the bottom (`05-table-bottom.png`) |
| 6 | Hover big numbers | OK. Hovered every tile (Active Ads, Paid Impressions, Spend, Clicks, Reach, 100% Completed Views). Exact values read from `.tile .count[title]` |
| 7 | Data Set dropdown > Video Play | OK, `table_data_set=video_play` |
| 8 | Hover 100% Completed Views big number | OK, 459,968 |
| 9 | Data Set dropdown > Reach | OK, `table_data_set=reach` |
| 10 | Hover Reach big number | OK, 43,807,251 |
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
- Big numbers (exact `.count[title]`): Active Ads 21 (-61%), Paid Impressions 43,827,219 (43.8M, -12%), Spend $201,543.83 ($202K, -6%), Clicks 145,516 (146K, +891%), Reach 43,807,251 (43.8M, -12%), 100% Completed Views 459,968 (460K, +174%). The values were identical across all three data-set views. No tile showed an authorization, failed or Reload message.
- Aggregate (Sum) rows:
  - Engagements: Spend $201,543.83, Paid Clicks 145,516, Paid Likes 244,990, Comments 1,142, Shares 2,395, Follows 4,253, Profile Visits 1,332.
  - Video Play: Spend $201,543.83, Paid Video Views 43,657,205, 2s 9,689,175, 6s 3,475,786, 25% 1,636,103, 50% 1,002,112, 75% 754,986, 100% 459,968, Avg View Time N/A.
  - Reach: Spend $201,543.83, Paid Impressions 43,827,219, Paid Reach 43,807,251, Paid Avg View Time per User N/A.
- Screenshots (`.playwright-out/QA-20984/`): `00-account.png`, `01-paid-landing.png`, `03-dates-set.png`, `04-tiktok-applied.png`, `05-table-bottom.png`, `06-hover-bignumbers.png`, `08-hover-100pct.png`, `10-hover-reach.png`, `11-hover-paid-impressions.png`.

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). The pre-fetched bug-history.md and known-quirks.md had no QA-20984 matches.
- Nothing reproduced. Every number is identical to the 2026-11-17 and 2026-10-22 PASS runs. The 2026-10-20 "authorize and connect your account" tile state did not reproduce.

## Notes
- Unlike 2026-11-17, the brand picker defaulted to Amazon Prime Video after the account switch, so Brand > Paid opened directly with no Insights redirect. The stale-brand redirect from yesterday is intermittent.
- The Playwright server cannot read files, so the credentials from `config/.env` were passed inline to `ctx._creds` (in memory only).

## Bugs filed
None.

## Cleanup
None (read-only).
