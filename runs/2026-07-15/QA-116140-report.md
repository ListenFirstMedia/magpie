# QA-116140 — Brand Sentiment - Sentiment Export CTA

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-116140
- **Priority:** Critical
- **Run date:** 2026-07-15 (Playwright MCP track, QA-22296 remaining batch)
- **Account:** Adam Orfei (account_id=54) — MTV (brand_id=4018)

## Steps executed

1. Brand > Content, MTV, Jul 8-14 2026 (default window).
2. Clicked the **sentiment** button → `sentiment_mode=true`.
3. Clicked **sentiment export** button (rendered immediately right of the sentiment button).
4. Modal opened with the export message; clicked **Cancel**.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Sentiment Export button appears only when Sentiment is enabled | Confirmed — button `sentiment export` was absent before clicking `sentiment`, appeared immediately after (verified via `browser_find` before/after) | PASS |
| A2 | 3 | Sentiment Export button appears to the right of the Sentiment button | Confirmed in DOM order: `benchmark`, `sentiment` (active), `sentiment export` | PASS |
| A3 | 4 | Popup message = "We're hard at work preparing your export. While some exports can finish quickly, larger exports may take longer to complete. Once it's ready, your export will automatically download or open. You can also find the link to download the export in our app notifications menu, bell icon, and in an email to <EMAIL>." | Exact match: "...in an email to lfiqa@listenfirstmedia.com." (the logged-in user's email correctly substituted for `<EMAIL>`) | PASS |
| A4 | 5 | Message closes | Clicked Cancel; `browser_find` for "hard at work" returned no matches — modal closed | PASS |

## Status: **PASS** (4/4 assertions)

## Cleanup
Non-mutating test (Cancel was clicked, no export was actually queued) — no cleanup required.
