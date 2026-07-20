# QA-929 — Pinterest Content - Embedded Post Tooltip

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-929
- **Run date:** 2026-05-20
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Sephora
- **Priority:** P4 (Minor)
- **Result:** ⚠ **BLOCKED — no test data**

## Status: Blocked (no Pinterest posts in spec date range)

The test requires hovering over Pinterest posts in Brand → Content on Jun 21–22, 2023 to verify tooltip behavior. The brand has **no Pinterest posts** in the specified date range.

## Steps executed
| Step | Action | State |
|---|---|---|
| 1 | Switched account to Sephora | ✓ |
| 2 | Brand → Content (URL: `/explore/brand/content?brand_id=7159&account_id=655&from=2023-06-21&to=2023-06-22&channels=pinterest`) | ✓ |
| 3 | Confirmed Sephora brand selected | ✓ |
| 4 | Selected only Pinterest channel via URL parameter | ✓ |
| 5 | Date range = Jun 21 – Jun 22, 2023 | ✓ |
| 6 | View result | ⚠ **Posts (0) — "There is no data available"** |
| Retry | Toggled to Authorized Data — Sephora Authorized brand (brand_id=30515) **does not have Pinterest channel at all** (only FB, X, IG, TikTok, YouTube visible in channel icons) | ⚠ confirmed unavailable |

## Why blocked
- Sephora Public Data has Pinterest channel but no posts published Jun 21–22, 2023
- Sephora Authorized Data doesn't include Pinterest channel
- All 6 assertions (A1–A6) require hovering over Type column links on existing Pinterest posts — impossible with 0 posts

## What was verified anyway
- Pinterest icon DOES exist in the channel filter row (showing the channel is supported by the platform for this account)
- Date range UI accepted Jun 21–22, 2023 without issue
- "There is no data available" empty-state message rendered correctly with warning icon

## Suggested next steps
- QA team / Product: update QA-929 spec to use a Sephora date range that actually has Pinterest posts, OR use a different brand with Pinterest activity in 2023 (e.g., a brand with consistent Pinterest publishing)
- Alternatively, re-test on prod (this is dev env) — the data set may differ

## Bugs filed
None (test cannot proceed; no actual platform defect observed).

## Note from spec
> Check some random posts that no external pin appears → if found, raise a bug.

This implies the test is also a data-availability check on Pinterest pin embedding. With no posts visible, neither path is testable.
