# QA-6315 — Brand > Conversation - Basic view — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV (4018) · **Window:** May 1–31 2026 (90-day cap banner shown)
- **Result:** ❌ FAIL — layout assertions all PASS, but linked open bug **LFMP-31800 REPRODUCED** (consistent with 2026-06-05)

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Toolbar | Help Center / Guide / Info top-right | All three present top-right | ✅ |
| Tabs | Conversation is last tab | Conversation last + active | ✅ |
| Channel | Apply button present, disabled by default | Apply greyed/disabled | ✅ |
| Perspective | Default 'Authorized Data' | Toggle on Authorized (perspective=extended) | ✅ |
| Channels | Twitter + Instagram icons at View by channels | X + IG icons present | ✅ |
| Toolbar | Export dropdown right corner | Export dropdown present | ✅ |
| Toolbar | No Data Set dropdown | Absent (correct) | ✅ |
| Layout | Conversation Analysis below Overview; Filter below it | Sections present (Overview → tiles → Analyzed Posts) | ✅ |
| Tiles | Row1 Conversation Volume + Daily | Donut 334,497 / 100% + Daily area chart (Twitter+IG legend) | ✅ |
| Tiles | Sources + Sources (Daily) | Present | ✅ |
| Tiles | Hashtags + Hashtags (Daily) | Donut #mtv 100% + Daily area | ✅ |
| Table | Analyzed Posts N + Sort filter | Analyzed Posts (1) + Sort=Date dropdown | ✅ |
| Table | Columns Date/Channel/Author/Type/Publish Type/Source/Text/Keyword/Hashtag | All 9 columns present | ✅ |

## Open-bug verdict
- **LFMP-31800 (Major, Open) — "Click here to load Tweets" navigates to Listening page:** **REPRODUCED.** Clicking the "Click here to load Tweets" link on the Analyzed Posts table navigated away to the **Listening** surface (breadcrumb "Account: Adam Orfei | Listening > Conversation", URL `#explore/listening/conversation?...&channels=twitter`, showing Search Mentions / Load Tweets builder) instead of loading tweets inline within Brand>Conversation. Direct repro, same as 2026-06-05.

## Bugs filed
- LFMP-31800 still defective — recommend keeping open.

## Cleanup
_None (read-only)._
