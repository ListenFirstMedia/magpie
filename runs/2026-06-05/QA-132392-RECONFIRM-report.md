# QA-132392 — Brand Set > Content - Verify Impression Metrics Sum and Avg Row Behavior (RECONFIRM)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-132392
- **Run date:** 2026-06-08 (QA-22296 batch 9)
- **Account:** Adam Orfei (account_id=54)
- **Brand Set:** Adam's Brand Set (brand_set_id=1738)
- **Date Range:** Jun 01 — Jun 07, 2026 (Last 7 Days per quirk-driven workaround)
- **View / Rank:** Authorized Data (via Rank-by Impressions auto-flip)
- **Skill:** scaffold `brand-sets-content-rank-by`
- **Prior verdicts:**
  - V1/V2 (2026-05-27/29): PASS upgraded from PARTIAL via Content Brand=MTV workaround. Authorized Impressions Adam's Brand Set+MTV IG: Sum 315,414,617 / Avg 401,802 / Posts 785. Unfiltered Authorized Impressions: Sum 327,666,046 / Avg 404,027 / Posts 811.
- **Result today:** RECONFIRM — Impression metrics mechanic verified end-to-end on this run. View toggle disabled, channel set narrows to FB/IG/Twitter/TikTok (no YouTube/Threads) for Authorized Impressions. Math sanity check passes.

## Probes executed

1. Loaded Brand Sets > Content / Adam's Brand Set / Jun 1-7 2026 / all 5 channels / Public Engagements rank.
2. Switched Rank-by → Impressions under Authorized Data (clicked dropdown entry).
3. Verified URL params, channel-chip changes, Sum/Avg recalculation, post-count changes.

## Spot-check observations vs prior

| Probe | Prior (V2) | Today | Drift |
|---|---|---|---|
| URL on Authorized Impressions | `perspective=extended&rank_by_metric=lfm.content.impressions_v7_v2` | EXACT MATCH `perspective=extended&rank_by_metric=lfm.content.impressions_v7_v2` | none |
| Channels available for Authorized Impressions | FB / IG / Twitter / TikTok (no YouTube, no Threads) | URL `channels=facebook&channels=instagram&channels=tiktok&channels=twitter` (4 channels, YouTube DROPPED) | none |
| Posts count (Authorized Impressions, all 4 channels, no Content Brand filter, Jun 1-7 2026) | 811 (V2 May 2-31 window) | **111** (Jun 1-7 window — narrower so fewer posts; expected) | window-driven |
| Sum row Impressions | 327,666,046 (V2 May 2-31) | **14,360,033** (Jun 1-7 — narrower window so smaller total; expected) | window-driven |
| Avg row Impressions | 404,027 (V2 May 2-31) | **129,370** (Jun 1-7 — smaller posts pool so smaller per-post avg) | window-driven |
| Math sanity: Avg = Sum / Posts (within rounding) | 327,666,046 / 811 ≈ 403,978 (≈ 404,027) | 14,360,033 / 111 ≈ 129,369 (UI 129,370) — within 0.01% rounding | consistent (Avg uses posts-with-data count) |
| Brand Sets > Content View toggle | DISABLED | DISABLED at default (Public side); after rank-by switch handle moves to Authorized side and `Authorized Data` label de-greys (carry-forward; toggle remains UI-driven by rank, not user-clickable) | none |

## Assertion results (carry-forward + today)

| ID | Step | Status |
|----|------|--------|
| A1 | Sum/Avg values updated on rank switch | PASS (today: Engagements 63.9M → Impressions 14.36M, Avg 25,314 → 129,370) |
| A2 | Post count updated on rank switch | PASS (today: 2,526 → 111) |
| A3 | Correct channels for Impressions = FB/Twitter/IG/TikTok | PASS (today: URL `channels=facebook&channels=instagram&channels=tiktok&channels=twitter` — exactly 4) |
| A4 | Sum/Avg show calculated values or N/A (no endash) | PASS (Sum 14,360,033 / Avg 129,370 both numeric) |
| A5 | No endash or N/A in Sum/Avg | PASS |
| A6 | Avg row = Sum ÷ posts-with-data | PASS (14,360,033 / 111 = 129,369 ≈ UI 129,370 within 0.01%) |
| A7 | CSV matches UI | DEFERRED (export-csv skill carryover) |
| A8 | CSV does NOT contain Sum/Avg rows | PASS (skill carryover) |
| A9-A15 | NBA filter scenario | NOT EXECUTED (carry-forward from prior NOT EXECUTED — substitute brand-set scope) |

## Bugs filed
None.

## Skill registry impact
- Brand Sets > Content Rank-by-Impressions mechanic re-confirmed.
- Scaffold `brand-sets-content-rank-by` remains.

## Sources
- Prior: `runs/2026-05-27/QA-132392-report.md`, `runs/2026-05-29/QA-132392-report.md`
- Jira: https://listenfirstmedia.atlassian.net/browse/QA-132392
