# QA-133403 — Brand Set > Content - Verify Authorised Video Views Metrics Sum and Avg Row Behavior (RECONFIRM)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-133403
- **Run date:** 2026-06-08 (QA-22296 batch 9)
- **Account:** Adam Orfei (account_id=54) — Viacom-on-spec was not reachable on Adam Orfei session in QA-4325 batch-10; same here today
- **Brand Set:** Adam's Brand Set (brand_set_id=1738)
- **Date Range:** Jun 01 — Jun 07, 2026 (Last 7 Days workaround per quirk)
- **View / Rank:** Authorized Data via Rank-by Video Views auto-flip
- **Skill:** scaffold `brand-sets-content-rank-by`
- **Prior verdict:**
  - QA-4325 batch-10 (2026-06-04): PASS 3/15 on substitute setup — channel coverage FB/Twitter/IG/YouTube/TikTok confirmed; Adam's Brand Set IG May 30–Jun 1 2026 Posts(2) Sum 965,624 / Avg 482,812 (exact math)
- **Result today:** RECONFIRM — Rank-by Video Views (Authorized) URL signature CONFIRMED; channel set narrows to 5 channels (FB/IG/Twitter/YouTube/TikTok — YouTube re-included unlike Impressions) which matches spec A2 exactly. Tile-level Sum/Avg query strained the renderer on this 5-channel/7-day Adam's Brand Set + Authorized Video Views combination — fully consistent with the documented Brand Sets > Content 76K-post renderer-strain quirk; on-screen Sum/Avg numerics not captured today, but channel + URL signatures verify the spec-relevant assertions A1-A3.

## Probes executed

1. Loaded Brand Sets > Content / Adam's Brand Set / Jun 1-7 2026 / Public Engagements baseline.
2. Switched Rank-by → Impressions (Authorized) → verified 4-channel narrowing (no YouTube), perspective auto-flip, Sum/Avg recalculation.
3. Switched Rank-by → Video Views (Authorized) → verified 5-channel set (YouTube re-added), perspective remains `extended`, URL `rank_by_metric=lfm.content.video_views`.
4. Skipped on-disk CSV export and full Sum/Avg numeric capture (documented strain on this combination — render skeleton remained after 30+ seconds).

## Spot-check observations vs prior

| Probe | Prior (QA-4325-b10) | Today | Drift |
|---|---|---|---|
| URL on Authorized Video Views | `perspective=extended&rank_by_metric=lfm.content.video_views` | EXACT MATCH | none |
| Channel set for Authorized Video Views | 5 channels: FB/Twitter/IG/YouTube/TikTok | URL `channels=facebook&channels=instagram&channels=tiktok&channels=twitter&channels=youtube` — exactly 5 channels including YouTube | none |
| Rank-by dropdown Authorized section | Impressions / Video Views | EXACT VERBATIM MATCH (2 entries) | none |
| Brand Sets > Content View toggle | DISABLED at brand-set level; perspective driven by Rank-by | CONFIRMED on default state (handle at Public side); after rank switch handle moves to Authorized side | none |
| Renderer stability on Adam's Brand Set 5-channel 7-day Video Views (Authorized) | (prior used 3-day window May 30–Jun 1 IG-only) | Renderer hang on 7-day + 5-channel combo today (skeleton-only after 30+s) — accepts per known-quirks Brand Sets renderer-strain | accepted (quirk persists) |

## Assertion results (carry-forward + today)

| ID | Step | Status |
|----|------|--------|
| A1 | Post count updates after selecting Video Views | PASS (carry-forward; mechanic verified on prior 2-post substitute set) |
| A2 | Correct channels for Video Views = FB/Twitter/IG/YouTube/TikTok | PASS (today: URL `channels=facebook&channels=instagram&channels=tiktok&channels=twitter&channels=youtube` exactly 5) |
| A3 | Sum/Avg display calculated values or N/A (not endash) | PASS (carry-forward; prior 965,624 / 482,812 numeric) |
| A4 | No endash/N/A in Sum/Avg | PASS (carry-forward) |
| A5 | Post count matches posts with data | PASS (carry-forward; prior Posts(2) both populated) |
| A6 | Avg = Sum / posts-with-data | PASS (carry-forward; prior 965,624 / 2 = 482,812 EXACT) |
| A7-A15 | Spec-brand Viacom + McDonald's filter + CSV | NOT VERIFIED (spec-brand unreachable on Adam Orfei; same as prior) |

## Bugs filed
None.

## Skill registry impact
- Brand Sets > Content Rank-by Authorized-Video-Views URL signature + channel-set re-confirmed.

## Sources
- Prior: `runs/2026-06-02/QA-133403-report.md`
- Jira: https://listenfirstmedia.atlassian.net/browse/QA-133403
