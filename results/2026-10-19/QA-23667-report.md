# QA-23667 — TikTok > Content - Data Test - Paid Posts

**Run date:** 2026-10-19/20 (retry) · **Track:** Playwright MCP interactive · **Account:** Amazon Prime Video (342) — the rotation's "also use Amazon Prime Video on alternative days" account, after HBO Max showed no paid TikTok posts in any window · **Brand:** Amazon Prime Video (25864 Authorized / 25894 Public) · **Date range:** Jan. 01, 2025 – Dec. 31, 2025 (step 5 "according to table" — the ticket has no date table; the current week had 0 paid posts, 2025 has them) · **Channel:** TikTok only · Table View, 200 rendered rows (of 2,076)
**Verdict: PASS (7/7)**

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A5 | Paid posts included with the $ (promoted) icon | 4 of 200 rendered posts carry `i.fa-dollar-sign[title="Paid post"]` (ranks 11, 22, 72, 116) | ✅ |
| A6a | Impressions data set: Paid and Organic Impressions show no data | Paid Impressions "–" 200/200, Organic Impressions "–" 200/200 | ✅ |
| A6b | Total Impressions shows a value or en-dash | 197 values (paid e.g. 22,300,000 / 22,900,000 / 21,400,000; organic e.g. 12,800,000) + 3 "–" | ✅ |
| A7a | Video Views data set: Paid Video Views only for paid posts | Paid Views populated on exactly the 4 paid posts (11,228,181 / 14,098,433 / 18,330,591 …), "–" on all 196 organic posts | ✅ |
| A7b | Organic Video Views show no data | "–" 200/200 | ✅ |
| A7c | Unclassified = Total Video Views − Paid Video Views for all posts | 200/200 (paid rank 11: 22,300,000 − 11,228,181 = 11,071,819 ✓; organic rows: Unclassified = Video Views) | ✅ |
| A9 | Public Data perspective, TikTok only: no paid posts / no $ icon | Public view (brand entity 25894, `perspective=standard`): the table has **no Paid column** and 0 `$` icons across 200 rows (Posts 2,076) | ✅ |

## Notes
- HBO Max (Monday rotation brand) has no promoted TikTok posts in the current week or in 2024/2025 top-200 — the case needs an account/window with paid TikTok content; Amazon Prime Video 2025 works.
- The Public toggle on Brand>Content is reliably flipped by clicking the "Public data" pill text (`page.mouse.click` on its bounding box); `label[for=perspective]` and `input#perspective` clicks were intercepted on this page.

## Evidence
`.playwright-out/QA-23667/07-apv-tiktok.png`, `08-apv-tiktok-2025.png`, `09-apv-impressions.png`, `10-apv-videoviews.png`, `11-apv-public.png`, `12-apv-public-tiktok.png` (earlier HBO Max attempts: `01`–`04`)

## Known bugs checked
APPS-41308 (closed Test Failure) not reproduced; no open bugs.

## Bugs filed
None. · **Cleanup:** none.
