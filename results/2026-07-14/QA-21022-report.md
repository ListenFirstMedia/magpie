# QA-21022 — Brand Content > Dev vs Prod > Reels Data Set > Facebook Channel

**Run date:** 2026-07-14 (Tuesday → per spec's day-of-week login table, today's assigned account/brand is **UCLA / UCLA**)
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Status:** 🚫 BLOCKED — dev-side steps completed; prod-side comparison not executable this run

## Blocker
Step 7 of the spec requires navigating to `https://app.listenfirstmedia.com/#home` — the **production** ListenFirst platform, a real customer-facing system distinct from the `app.lfmdev.in` dev sandbox this framework is scoped to (see `config/env.md`). `config/.env` only provisions dev credentials (`LFM_EMAIL`/`LFM_PASSWORD` for `app.lfmdev.in`). Navigating to prod confirmed it is reachable and redirects to its own Cognito login (`auth.listenfirstmedia.com`) — a separate, real authentication surface. Attempting the dev credentials there without confirmation would mean probing a live production login with unverified credentials, which risks a false-credential/lockout signal against a real system. Per Rule 1's "test-data gap" guidance (don't invent a substitute, don't guess), this half of the test is **BLOCKED pending confirmed prod credentials** — not attempted.

## Steps executed (dev side only, steps 1–6)
1. Navigated to `https://app.lfmdev.in/` (already authenticated this session).
2. Brand → Content, account UCLA, brand "University of California, Los Angeles" (brand_id=127756) — see QA-136264's note on why this is the correct brand for the "UCLA" shorthand.
3. Data Set → "Video Views" (Cross-Channel Metrics).
4. Enabled Facebook channel only (disabled Twitter/Instagram/TikTok/LinkedIn).
5. Filter → Publish Type → Reel → Apply Filter.
6. Default date range (current week) returned 0 posts; broadened via Make a Selection → Last 12 Months → Posts (14).
7. Recorded per-post values (Table View) for the top 4 (of 14) posts:

| Rank | Date | Engagements | Video Response Rate | Video Views |
|---|---|---|---|---|
| 1 | Aug 12, 2025 | 1,528 | 5.07% | 30,114 |
| 2 | Sep 09, 2025 | 1,393 | 2.89% | 48,233 |
| 3 | Jul 25, 2025 | 1,191 | 3.25% | 36,631 |
| 4 | Sep 22, 2025 | 588 | 2.08% | 28,246 |

Sum row (14 posts): Engagements 7,660; Video Views 260,792 (with cross-posts); Video Response Rate N/A (Sum row, expected).

## Assertion

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 (13) | Dev post values should match prod post values | Not evaluated — prod side blocked | 🚫 BLOCKED |

## Note — "Resolution" metric not present
The spec's step 6/12 asks to note "[Engagements, Video Response Rate, Video Views, Resolution]" per post. This build's Video Views data set has no column literally named "Resolution" — the closest analog is **Video Duration** (e.g., "21s", "17s", "13s" per post), which is a clip length, not an image/video resolution (e.g., 1080p). This reads as spec drift (a metric that may have existed in an older build or was renamed) rather than a product defect. Flagging for awareness; not filed as a bug.

## Bugs filed
None.

## Cleanup
None — read-only verification, no mutation.

## Recommendation
If prod comparison testing is a recurring need for this framework, request dedicated prod QA credentials (distinct from the dev-only `config/.env`) and document them in `config/credentials.md` or a new `config/prod-credentials.md`, gated the same way dev creds are (gitignored, never committed).
