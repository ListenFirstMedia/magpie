# QA-567 — Facebook Lifetime Private Data QA

- **Date:** 2026-06-04
- **Tester:** magpie (batch 2)
- **Account:** Hulu (account_id=336)
- **Brand:** Hulu (brand_id=5670)
- **Channel:** Facebook
- **Mode:** Lifetime
- **Result:** PARTIAL — dev side verified renders correctly; stage-vs-dev parity cannot be evaluated end-to-end from this session because stage is a separate environment not accessible from the same browser context as dev (`app.lfmdev.in`).
- **Linked open bugs:** none

## Pre-flight
- Switched account Michael Kors → Hulu via profile → Search Account → Hulu (Results).
- Navigated to `/#explore/brand/content?brand_id=5670&account_id=336&channels=facebook&perspective=extended&stats_attribution_window=lifetime&table_data_set=impressions&layout=table`.
- Note: URL `channels=facebook` did not narrow the channel set; page-render channel-ghost set kept all 6 default channels enabled (URL was re-expanded to `channels=twitter&channels=instagram&channels=facebook&channels=linkedin&channels=tiktok&channels=threads` after load). Known quirk: hash-route channel param merging (documented in `known-quirks.md`).

## Dev-side observations

- Default date range: May 27, 2026 - Jun 2, 2026 (last 7 days).
- Mode: Lifetime (default).
- View: Authorized Data (right toggle).
- Data Set: Impressions (changed via dropdown — sticks correctly).
- Posts (89) loaded.
- Sum row shows: Engagements 1,183,399 / ER N/A / Impressions 35,353,705 / Organic Imp 34,632,694 / Paid Imp 3,904 / Reach N/A / Organic Reach N/A / Paid Reach N/A / EUR N/A.
- Avg row: Engagements 13,297 / ER 3.35% / Impressions 397,228 / Organic Imp 389,131 / Paid Imp 44 / Organic Reach 167,919 / Paid Reach 44 / EUR 7.59%.
- First 5 posts visible in grid: all Instagram Reels (date range default has IG dominance, not pure FB).

## Spec-vs-environment limitations

The QA-567 spec requires the user to have **dev open in 1 browser AND stage open in another**, then compare:
- Step 6: Compare Impressions data between dev and stage.
- Step 10: Compare video views data between dev and stage.
- Step 11: Compare posts count between dev and stage.

magpie operates against `app.lfmdev.in` (dev) only — no stage environment is mounted in this session. Therefore A8 / A10 / A11 cannot be evaluated end-to-end without manual stage access.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | Impressions data set selectable | Data Set dropdown switches to "Impressions"; URL `table_data_set=impressions`; columns refresh to Impressions/Organic Imp/Paid Imp/Reach/Organic Reach/Paid Reach | PASS (dev) |
| A2 | 8 | Lifetime impressions match between dev and stage for same posts | Cannot evaluate stage from this session | NOT VERIFIED — needs manual stage access |
| A3 | 10 | Video Views data match between dev and stage | Cannot evaluate stage from this session | NOT VERIFIED — needs manual stage access |
| A4 | 11 | Post count matches between dev and stage | Cannot evaluate stage from this session | NOT VERIFIED — needs manual stage access |

## Bugs filed
- None.

## Skill usage
- `switch-account` (Michael Kors → Hulu).
- `brand-content-data-set-selector` (Public → Impressions).

## Notes for parent agent
- This test (and QA-569) are dev↔stage parity tests that magpie can only verify dev-side. Recommend marking these as "manual cross-env tests" for LFIQA.
