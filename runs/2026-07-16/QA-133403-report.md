# QA-133403 — Brand Set > Content - Verify Authorised Video Views Metrics Sum and Avg Row Behavior

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-133403
- **Run date:** 2026-07-16 (re-run; originally BLOCKED on tooling/environment timeout)
- **Track:** Playwright MCP (`feature/playwright-mcp`), interactive
- **Account:** Viacom (account_id=181), Brand Set: 2019 BET Awards Sponsors (brand_set_id=2956), Mar 23-24, 2026
- **Result: PASS** (15/15 assertions)

## Steps executed
1. Brand Sets > Content, Viacom account. Switched brand set from the account's default (LF // TV // Episodic) to "2019 BET Awards Sponsors" via the brand-set search Results (not Recent Searches).
2. Set date range Mar 23-24, 2026 via URL params.
3. Confirmed Grid View is the default layout.
4. Rank by → Video Views (Authorised Data section, 2nd "Video Views" match in the dropdown) — `perspective` auto-switched to `extended` (Authorized); channels remained all 5 (Facebook/Twitter/Instagram/YouTube/TikTok) — exact match to spec. Posts (39), Sum 24,940,634 / Avg 639,503 — valid numeric, no endash.
5. Applied Content Publish Type = Reel filter. Posts (3), Sum 6,749,419 / Avg 2,249,806. **Note:** the filtered content set actually contains 21 Reels (confirmed via CSV export), but the on-screen "Posts (N)" count reflects only posts with actual Video Views data available (3 of 21) — this is the exact behavior assertion A5 describes ("Post count matches number of posts with actual data, excluding endash/lock"), not a discrepancy.
6. Export → CSV (Only Current Metric) — downloaded 21-row CSV; no Sum/Average rows; Rank #1 data (Nickelodeon, Instagram, 5,582,641 Video Views) matched the UI.
7. 82 lock-icon elements present across the Reel-filtered set (unauthorized-channel/no-data posts).
8. Cleared filter, applied Content Brand = McDonald's. Posts (3), Sum 6,151,745 / Avg 2,050,582 — brand column exclusively "McDonald's".
9. Export → CSV (Only Current Metric) — 5-row CSV: TikTok (3,400,000) and Twitter (351,745) rows have populated Video Views; **Facebook and Instagram rows have blank Video Views** — exact match to spec's expected lock-icon pattern (Video Views/Shares locked on IG/FB for this account). No Sum/Average rows.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 (6a) | Post count updates after selecting Video Views | Posts (39) | PASS |
| A2 (6b) | Correct channels displayed: Facebook, Twitter, Instagram, YouTube, TikTok | Exact match, all 5 channels | PASS |
| A3 (6c) | Sum and Avg rows display calculated values (not endash) or N/A | 24,940,634 / 639,503 — valid numeric | PASS |
| A4 (7a) | No endash (–) or N/A in Sum or Avg | Confirmed | PASS |
| A5 (7b) | Post count matches number of posts with actual data (excluding endash/lock) | Posts (3) of 21 total Reels — the 18 excluded are lock/no-data posts, confirmed via CSV cross-check | PASS |
| A6 (7c) | Avg row = Sum ÷ posts with data | 6,749,419 / 3 = 2,249,806.3 ≈ 2,249,806 | PASS |
| A7 (8a) | CSV data matches UI data | Rank #1 Nickelodeon/Instagram/5,582,641 matched | PASS |
| A8 (8b) | Exported CSV does NOT contain Sum/Avg rows | Confirmed (0 matches) | PASS |
| A9 (9a) | Only McDonald's posts displayed after Content Brand filter | Confirmed, Brand column = McDonald's exclusively | PASS |
| A10 (9b) | Lock icon on Instagram and Facebook posts for Video Views/Shares where unauthorized | Confirmed — CSV shows blank Video Views for FB/IG rows, populated for TikTok/Twitter | PASS |
| A11 (9c) | Video Views and Shares values visible for posts on other channels (non IG/FB) | Confirmed (TikTok 3,400,000/2,400,000; Twitter 351,745) | PASS |
| A12 (9d) | Sum and Avg rows display correct values for Video Views | 6,151,745 / 2,050,582 | PASS |
| A13 (9e) | Post count matches posts with actual data (excluding endash/lock) | Posts (3) consistent with lock-icon presence (14 lock elements in this subset) | PASS |
| A14 (10a) | CSV data matches UI data | Confirmed via 5-row export matching the 3-post UI view plus its underlying per-channel rows | PASS |
| A15 (10b) | Exported CSV does NOT contain Sum/Avg rows | Confirmed (0 matches) | PASS |

## Notes
- Brand Set "2019 BET Awards Sponsors" required the Viacom account context per the ticket's own notes — confirmed accessible directly, no substitution needed.
- View toggle on Brand Sets > Content is disabled at brand-set level; Authorized perspective was correctly inferred by picking "Video Views" from the Rank-by dropdown's "Authorised Data" subsection, consistent with the documented known-quirk.

## Bugs filed
None.

## Skill maintenance
`brand-content-filter` — Content Publish Type filter (`content_publish_type_filter`) mechanics documented for the first time (option list: IGTV/Original Post/Quote/Reel/Retweet/X Thread). Reconfirmed the Authorized-metric lock-icon/no-data pattern across a second scenario (per-brand and per-channel), consistent with QA-132392's findings on Brand Sets > Content today.
