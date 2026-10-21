# QA-20984 — Brand > Paid - Data QA - TikTok

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in`, lfiqa user switched to **Amazon Prime Video**
**Account:** Amazon Prime Video (account_id=342) · **Brand:** Amazon Prime Video (brand_id=25864) · Channel: TikTok · Date range: Feb 01, 2025 – Mar 31, 2025
**Verdict: FAIL — the Active Ads and Spend big-number tiles render "You'll need to authorize and connect your account to view this data" for TikTok while the Ads table for the same selection shows Spend $201,543.83 across 21 ads; the four big numbers that do render (Paid Impressions, Clicks, Reach, 100% Completed Views) all equal their aggregate-row counterparts**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand → Paid → Amazon Prime Video, date range Feb 01 – Mar 31 2025 | ✅ `from=2025-02-01&to=2025-03-31` |
| 4 | TikTok only → Apply | ✅ `channels=tiktok` |
| 5 | Table View, aggregate row (Engagements data set) | ✅ **Ads (21)**, 21 rows; aggregate: Spend $201,543.83 · Paid Clicks 145,516 · Paid Likes 244,990 · Paid Comments 1,142 · Paid Shares 2,395 · Paid Follows 4,253 · Paid Profile Visits 1,332 |
| 6 | Big numbers (exact `.count[title]`) | ⚠️ Paid Impressions **43,827,219** · Clicks **145,516** · Reach **43,807,251** · 100% Completed Views **459,968**; the **Active Ads** and **Spend** tiles show no value: "You'll need to authorize and connect your account to view this data. Go to Authorize" |
| 7–8 | Data set → Video Play; 100% Completed Views | ✅ aggregate Paid 100% Completed Views **459,968** (also Paid Video Views 43,657,205, 2s 9,689,175, 6s 3,475,786, 25% 1,636,103, 50% 1,002,112, 75% 754,986) |
| 9–10 | Data set → Reach; Reach big number | ✅ aggregate Paid Reach **43,807,251**, Paid Impressions **43,827,219** |
| 11 | Paid Impressions big number | ✅ 43,827,219 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A6a | Post-table header count == Active Ads big number | Ads (21) and 21 rows; Active Ads tile shows the authorization message instead of a number | ❌ FAIL (tile not populated) |
| A6b | Spend big number == aggregate Spend; Clicks big number == aggregate Paid Clicks | Spend tile not populated (authorization message) while the table aggregate shows $201,543.83; Clicks 145,516 == 145,516 | ❌ FAIL on Spend · ✅ Clicks |
| A8 | 100% Completed Views big number == aggregate Paid 100% Completed Views (Video Play set) | 459,968 == 459,968 | ✅ PASS |
| A10 | Reach big number == aggregate Paid Reach (Reach set) | 43,807,251 == 43,807,251 | ✅ PASS |
| A11 | Paid Impressions big number == aggregate Paid Impressions (Reach set) | 43,827,219 == 43,827,219 | ✅ PASS |

## Evidence
- Session result `ctx._paid.apv_tt` (tile values, three data-set aggregate rows). Tile text captured verbatim: "Active Ads | You'll need to authorize and connect your | account to view this data. | Go to Authorize".

## Known bugs checked
- None open on the case. The Spend/Active Ads tiles' authorization gate contradicts the table (which has Spend per ad) — raise with the Paid/TikTok ads-authorization owners; it may be an account-authorization scope issue on dev rather than a rendering bug.

## Notes
- Clicking the tile's "Go to Authorize" link (it is the tile's `.error-data-link a`, the same selector as the Reload link) navigates to Settings > Authorization; nothing was changed there.

## Bugs filed
None (needs triage first).

## Cleanup
None (read-only).
