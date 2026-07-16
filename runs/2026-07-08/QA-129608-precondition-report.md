# QA-129608 (precondition for QA-129673) — Aggregate Value Calculation Across Multiple Channels

**Run date:** 2026-07-08
**Note:** QA-129608 is NOT one of today's 15 assigned QA-4204 cases — it is executed here solely because QA-129673's own Jira preconditions explicitly require it ("Execute QA-129608 and note down the Sum of total footprints across all channels"). Recorded separately so it doesn't inflate today's 15-case count.

**Account:** Wasserman · **Brand:** FIA World Endurance Championship (FIAWEC) · **Report:** story/time_window_comparison/155738
**Config:** Absolute Dates, Aggregate interval, Feb 09–15, 2026, By Channel (5 individual channels, not the Cross-Channel node), each channel's Audience+Content metrics per the QA-129608 spec.

## Per-channel results

| Channel | Total Followers/Fans/Subscribers | Engagements | Posts | Response Rate | Footprint (TF×Posts) |
|---|---|---|---|---|---|
| Facebook | 596,609 (Total Fans) | 7,973 | 7 | 0.19% | 4,176,263 |
| Twitter | 457,601 | 2,573 | 7 | 0.08% | 3,203,207 |
| Instagram | 1,291,489 | 96,129 (Public Only) | 7 | 1.06% (Organic) | 9,040,423 |
| YouTube | 1,140,000 (Subscribers) | 16,750 | 11 | 0.13% | 12,540,000 |
| TikTok | 534,800 | 10,113 | 7 | 0.27% | 3,743,600 |
| **Sum** | **4,020,499** | **133,538** | **39** | — | **32,703,493** |

## Result

Sum of Total Footprints across channels = **32,703,493**. Sum of Total Followers (4,020,499) and Sum of Posts (39) and Sum of Engagements (133,538) all exactly match the aggregate values later returned by the dedicated "Cross-Channel" metric-tree node in QA-129673's own report (155739) — confirming the platform sums per-channel raw counts consistently across both query paths.

This baseline (32,703,493) is used for the QA-129673 aggregate Response Rate cross-check below.
