# QA-116173 — Sentiment Export Email, Notification & Auto Download

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-116173
- **Priority:** Minor
- **Run date:** 2026-07-15 (Playwright MCP track, QA-22296 remaining batch)
- **Account:** Adam Orfei (account_id=54) — Amazon Prime Video (brand_id=25864, exact-match Rule 1 result)

## Steps executed

1. Brand > Content → in-page brand picker → typed "Amazon Prime Video" → selected the exact-match top result (not any of the 65 country/franchise variants).
2. Clicked **sentiment** → `sentiment_mode=true`.
3. Clicked **sentiment export** → modal opened → clicked **Ok** (not Cancel, per spec).
4. Waited ~25s for the async export pipeline to complete.
5. Checked the notification bell.
6. Checked `.playwright-out/` for the native Playwright `download` event.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6 | Bell-icon notification with message containing "Download file" link | Confirmed — top entry: *"Your Sentiment Export for Amazon Prime Video from Jul. 08, 2026 to Jul. 14, 2026 is now ready."* + `Download file` link to `analytics-cdn.lfmdev.in/303132-aa9e9951abe45a2344949f0510489124.csv` | PASS |
| A2 | 6 | CSV file automatically downloaded | Confirmed — real Playwright `download` event fired ~25s after clicking Ok: `Amazon Prime Video-Brand Content-2026-07-08-2026-07-14-comments-sentiment.csv` saved to `.playwright-out/`, 16,810 lines, correct comment-sentiment columns (`Comment Date, ..., Comment Classified, Comment Emotion, Topic 1-8, Post Link`) | PASS |
| A3 | 6 | Same notification received on email; clicking the attachment downloads the file | **NOT INDEPENDENTLY VERIFIABLE** — this Playwright MCP session has no access to the `lfiqa@listenfirstmedia.com` email inbox. Per Rule 6, not claiming PASS without observing the actual outcome. The in-app modal text (confirmed in QA-116140) promises email delivery to the logged-in user's address, and the identical bell-notification content strongly implies email parity (same backend event), but this was not independently confirmed this run. | INCONCLUSIVE |

## Status: **PASS on A1/A2, INCONCLUSIVE on A3** (2/3 fully verified)

Recommend a future run with mail-inbox access (e.g., a mounted mailbox or IMAP check) to close out A3 definitively.

## Cleanup
Non-mutating test (export/download only, no data created) — no cleanup required.
