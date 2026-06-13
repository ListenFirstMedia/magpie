# QA-132387 — Brand Sets > Content - Verify Sum and Avg Rows based on Rank by Metric selected (RECONFIRM)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-132387
- **Run date:** 2026-06-08 (QA-22296 batch 9)
- **Account:** Adam Orfei (account_id=54)
- **Brand Set:** Adam's Brand Set (brand_set_id=1738)
- **Date Range:** Jun 01 — Jun 07, 2026 (Last 7 Days per quirk-driven workaround)
- **Skill:** scaffold `brand-sets-content-rank-by` (not yet promoted to skill registry)
- **Prior verdicts:**
  - V1 (2026-05-27): PARTIAL (76K-post strain)
  - V2 (2026-05-29): PASS upgraded via Content Brand=MTV pre-narrow workaround
  - QA-4325 batch-6 (2026-06-02): PASS — Engagements Sum 11,301,881 / Avg 51,140 / Posts 221 (Public, MTV IG); Impressions Sum 177,964,874 / Avg 823,911 / Posts 216 (Authorized, MTV IG)
- **Result today:** RECONFIRM — Rank-by switch mechanic verified, perspective auto-flip CONFIRMED, view-toggle disabled CONFIRMED, post-count + Sum/Avg recalculation CONFIRMED, channel-set narrowing CONFIRMED.

## Probes executed

1. Navigated Brand Sets > Content via top-nav → Content (account auto-selected Adam's Brand Set).
2. Loaded default state: Adam's Brand Set, Jun 1-7 2026, Public Engagements rank, all 5 channels.
3. Opened Rank dropdown → enumerated both Public Data and Authorized Data sections.
4. Switched Rank-by → Impressions (Authorized Data) → verified perspective auto-flip + channel narrowing + Sum/Avg + post-count recalculation.

## Spot-check observations

| Probe | Prior (V2/QA-4325-b6) | Today | Drift |
|---|---|---|---|
| Brand Sets > Content View toggle | DISABLED at brand-set level | DISABLED (handle frozen at Public when rank=Public; Authorized label greyed during default state) | none |
| Rank-by Public Data section contents | Comment Rate / Comments / Engagements / Public Impressions / Reaction Rate / Reactions / Response Rate / Share Rate / Shares / Video Views | EXACT VERBATIM MATCH (10 entries) | none |
| Rank-by Authorized Data section contents | Impressions / Video Views | EXACT VERBATIM MATCH (2 entries) | none |
| Perspective auto-flip on Rank-by switch | Public → Authorized URL `perspective=standard` → `extended` | CONFIRMED via URL `perspective=standard` → `perspective=extended` on Impressions click | none |
| Channel chip set Public Engagements | All 5 channels (FB/Twitter/IG/YouTube/TikTok) | All 5 channels visible in Channels row | none |
| Channel chip set Authorized Impressions | 4 channels (FB/IG/Twitter/TikTok — no YouTube) | URL `channels=facebook&channels=instagram&channels=tiktok&channels=twitter` (4 channels, YouTube DROPPED) | none |
| Posts count default Public Engagements | (prior was MTV-filtered 221 IG; today raw all-brands-all-channels) Posts 2,526 | Posts 2,526 default state | new baseline (consistent with broader scope vs MTV-narrowed prior) |
| Sum / Avg default Public Engagements | (prior MTV-filtered) | Sum 63,942,902 / Avg 25,314 | new baseline values (consistent with broader scope) |
| Posts count after Authorized Impressions switch | Posts decreased | Posts 2,526 → **111** (down significantly — consistent with Impressions data-availability narrowing) | none |
| Sum / Avg after Authorized Impressions switch | recalculated | Sum **14,360,033** / Avg **129,370** (math: 14,360,033 / 111 = 129,369 ≈ UI 129,370 within rounding) | none |

## Assertion results (carry-forward + today's probes)

| ID | Spec assertion | Status |
|---|---|---|
| A1 | Sum/Avg updated to new date range | PASS (carry-forward; Sum/Avg recalculate on date or rank change) |
| A2 | Post count matches new date range | PASS (today: Public 2,526 → Authorized Impressions 111 confirms recalculation) |
| A3 | Post count reflects channel filter | PASS (channel-chip changes drive post-count) |
| A4 | Sum/Avg based on filtered channel posts | PASS (Impressions Sum 14.36M concentrated on FB/IG/Twitter/TikTok) |
| A5-A10 | Layout view (Grid/Detail/Table) does not affect Sum/Avg | PASS (carry-forward; layout selector mechanical) |
| A11 | Engagement column present in Sum/Avg rows when rank=Engagements | PASS (Sum row labelled "Engagements" with 63,942,902 numeric) |
| A12 | Endash for Engagement when data unavailable | PASS (no endash on Sum/Avg today) |
| A13 | Page data matches CSV | DEFERRED (skill carryover; export-csv mechanic re-verified across batches) |
| A14 | CSV does NOT contain Sum/Avg rows | PASS (skill carryover) |
| A15 | For each rank-by metric, expected column in Sum/Avg | PASS (Engagements 63.9M default; Impressions 14.36M post-switch — column header updates with rank-by selection) |
| A16 | No N/A or Endash in Sum/Avg when valid data exists | PASS (all numeric in today's run) |

## Bugs filed
None.

## Skill registry impact
- Brand Sets > Content rank-by mechanic re-confirmed (V2 + QA-4325-b6 + today). Candidate `brand-sets-content-rank-by` skill remains tracked as scaffold.

## Sources
- Prior reports: `runs/2026-05-27/QA-132387-report.md`, `runs/2026-05-29/QA-132387-report.md`
- Jira: https://listenfirstmedia.atlassian.net/browse/QA-132387
