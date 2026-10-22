# QA-20984 — Brand > Paid - Data QA - TikTok

**Run date:** 2026-10-22 (Thursday)
**Track:** Playwright MCP, unattended (`claude -p`), dev `app.lfmdev.in`, login `lfiqa` switched to account **Amazon Prime Video** (account_id=342)
**Brand:** Amazon Prime Video (brand_id=25864, exact typeahead result) · Channel: TikTok only · Date range: Feb 01, 2025 – Mar 31, 2025 · View: Authorized data
**Verdict: PASS** — all five assertions hold: post-table header (21), table rows (21) and Active Ads tile (21) match; Spend, Clicks, 100% Completed Views, Reach and Paid Impressions big numbers each equal the table's aggregate (Sum) row for the paired data set.

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Login (Cognito "With existing account"); account switch via profile menu > Search Account > `.lfm-ta-option` "Amazon Prime Video" | OK. Cognito PreAuthentication/PostAuthentication Lambda timeouts ("Task timed out after 3.00 seconds") on the first 2 sign-in attempts; the 3rd attempt succeeded (transient). Breadcrumb "ACCOUNT: AMAZON PRIME VIDEO" |
| 1 | Hover Brand in Xnav, click Paid | OK, `#explore/brand/paid` |
| 2 | Click Brand dropdown, type "Amazon Prime Video" | OK, typeahead listed the exact "Amazon Prime Video" first (plus many regional variants) |
| 3 | Select Amazon Prime Video, date range Feb 01, 2025 – Mar 31, 2025 | OK, `brand_id=25864`, `from=2025-02-01&to=2025-03-31` (picker START/END verified "Feb 01, 2025 / Mar 31, 2025") |
| 4 | Select TikTok only, Apply | OK, `channels=tiktok`; only the TikTok ghost `enabled`, others `disabled` |
| 5 | Table View, scroll to bottom of post table | OK, Ads table rendered after ~15s skeleton (within budget): header **Ads (21)**, 21 data rows + Sum/Average row |
| 6 | Hover big numbers | OK, exact values read from `.tile .count[title]` (see below) |
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
- Big numbers (exact `.count[title]`): Active Ads 21 (-61%), Paid Impressions 43,827,219 (43.8M, -12%), Spend $201,543.83 ($202K, -6%), Clicks 145,516 (146K, +891%), Reach 43,807,251 (43.8M, -12%), 100% Completed Views 459,968 (460K, +174%). Identical in all three data-set views; 0 tiles showed an authorization/failed/Reload message.
- Aggregate (Sum) rows: Engagements: Spend $201,543.83, Paid Clicks 145,516, Paid Likes 244,990, Comments 1,142, Shares 2,395, Follows 4,253, Profile Visits 1,332. Video Play: Spend $201,543.83, Paid Video Views 43,657,205, 2s 9,689,175, 6s 3,475,786, 25% 1,636,103, 50% 1,002,112, 75% 754,986, 100% 459,968. Reach: Spend $201,543.83, Paid Impressions 43,827,219, Paid Reach 43,807,251.
- Screenshots (`.playwright-out/QA-20984/`): `05c-dates-set.png`, `07-tiktok-applied.png`, `08-table-bottom.png`, `09-bignumbers-engagements.png`, `10-dataset-open.png`, `11-videoplay-100pct-hover.png`, `12-reach-hover.png`, `13-impressions-hover.png`.

## Known bugs checked
- Case file "Open linked bugs": none open (Rule 7 screen passed). bug-history.md and known-quirks.md had no QA-20984 matches (pre-fetched).
- **Prior-run discrepancy:** the 2026-10-20 run recorded FAIL because the Active Ads and Spend tiles showed "You'll need to authorize and connect your account to view this data" for TikTok. That did NOT reproduce today: both tiles populated (21 and $201,543.83) on first load and stayed populated across all three data sets. All other numbers are identical to the 10-20 run. Likely a transient / intermittent tile-authorization state; if it recurs, treat as a flaky tile-load issue and capture the screenshot at the time.

## Notes
- Cognito sign-in needed 3 attempts because of Lambda (Pre/PostAuthentication) 3s timeouts; unrelated to the case.
- The Brand picker already defaulted to Amazon Prime Video after the account switch; the spec's dropdown + type + select steps were still performed explicitly.
- Clicking `.date-selector` through a locator did not open the picker on one attempt (a coordinate click on the Date Range box did); `.channel-icon.tiktok` + `button.channel-selector-button` are reliable selectors for channel + Apply.

## Bugs filed
None.

## Cleanup
None (read-only).
