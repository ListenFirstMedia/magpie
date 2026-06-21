# QA-137874 — Data Collection - Channel Collection Status Validation 2 — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** Suits · **Channel:** Twitter · **Page:** SuitsPeacock
- **Skill:** data-collection-channel-drill
- **Result:** ✅ PASS-with-partial-data — consistent with 2026-06-08

## Steps
- Settings > Data Collection → My Brands (5,233) → Suits → Channels(9) → Twitter → Page SuitsPeacock → Data Collection Summary (data-feeds table).

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| 5a Collecting (green check) | A feed shows Collecting | **Twitter Page (Public)** → ✅ Collecting (green check), Last Collection Jun 12 2026 | ✅ |
| 5b Last Collection Date | Dates populated | Apr 8 2022/Jun 12 2025, Jan 2 2017/May 28 2026, Apr 9 2012/Jun 12 2026, Jul 23 2012/Jan 30 2026 | ✅ |
| 5d Not Collecting (red exclamation) | A feed shows Not Collecting | 🔴 Not Collecting on Twitter Posts (Authorized), Twitter Earned Comments (Public), Twitter Posts (Public) | ✅ |
| 5e To Do (blue plus) | A feed shows To Do | Not present in this feed sample (blue + counts are channel-level; page-level feeds show only Collecting/Not Collecting + Authorized lock) | ⚠️ DEFERRED |

## Notes
- Authorized feed (Twitter Ads) shows lock icons + a status dropdown (Click to reauthorize). Brand status badges legend: red=issue, blue+=To Do, yellow=pending.

## Bugs filed
_None._
