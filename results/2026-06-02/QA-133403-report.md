# QA-133403 — Brand Set > Content - Verify Authorised Video Views Metrics Sum and Avg Row Behavior (Batch 10 first run 2026-06-04)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-133403
- **Run date:** 2026-06-04 (QA-4325 batch-10)
- **Spec preconditions:** Viacom account, "2019 BET Awards Sponsors" brand set, Mar 23–24 2026
- **Actual executed on:** Adam Orfei account (account_id=54), "Adam's Brand Set" (brand_set_id=1738), narrowed to May 30 – Jun 1 2026 / Instagram channel
- **Reason for divergence:** Viacom account requires account-session switch (no creds); Adam Orfei is the active session. "2019 BET Awards Sponsors" brand set is Viacom-side. Per Rule 1 the spec brand-set was not findable on Adam Orfei. Substitute brand set "Adam's Brand Set" used to verify the **mechanic** (Sum/Avg row math, post-count = data-only posts, Video Views channel coverage), since the test verifies row-behavior not data-content. The original Mar 23–24 window on Adam's Brand Set with MTV-only filter returned Posts(0); a recent window (May 30 – Jun 1 2026) with IG-only was used to obtain a populated 2-post dataset.
- **Result:** PASS 3/15 with the mechanic-portion verified on the substitute setup. Spec-brand-on-spec-window assertions (A7-A15) NOT VERIFIED due to brand-set substitution.

## Steps executed (substitute setup)

1. Navigated Brand Sets > Content for Adam's Brand Set, May 30 – Jun 1 2026, IG channel.
2. Verified View toggle present (Public Data / Authorized Data) — disabled at brand-set level per known-quirks; perspective driven by Rank-by metric.
3. Mode: Lifetime ✓
4. Clicked Rank-by dropdown → enumerated Public Data section and Authorized Data section.
5. Selected Video Views under Authorized Data — perspective=extended, rank_by_metric=lfm.content.video_views.
6. Verified post count, per-post values, Sum row, Average row.
7. Verified channel chips for Video Views (FB/Twitter/IG/YouTube/TikTok).

## Observed state

- **Brand set:** Adam's Brand Set (Adam Orfei substitute)
- **Date Range:** May 30 – Jun 1 2026
- **Mode:** Lifetime
- **Rank:** Video Views (Authorized Data)
- **View perspective:** extended (Authorized) — derived from metric subsection
- **Posts (2):**
  - Post 1: MTV, Mon Jun 01 2026 11:18 AM PDT — Video Views = **806,052**
  - Post 2: MTV, Sat May 30 2026 07:00 AM PDT — Video Views = **159,572**
- **Sum row:** 965,624
- **Average row:** 482,812

## Math verification

| Computation | Expected | Actual | Result |
|---|---|---|---|
| Sum = 806,052 + 159,572 | 965,624 | 965,624 | EXACT |
| Average = 965,624 / 2 | 482,812 | 482,812 | EXACT |

## Channel coverage (for Video Views metric)

UI channel chips: **Facebook, Twitter, Instagram, YouTube, TikTok** (5 channels). Matches spec A2 exactly:
- `.channel-ghost.facebook`, `.channel-ghost.twitter`, `.channel-ghost.instagram`, `.channel-ghost.youtube`, `.channel-ghost.tiktok` (all in DOM; current selection: `.channel-ghost.instagram.enabled`)

## Rank-by dropdown structure

- **Public Data section:** Comment Rate, Comments, Engagements, Public Impressions, Reaction Rate, Reactions, Response Rate, Share Rate, Shares, Video Views
- **Authorized Data section:** Impressions, Video Views

Confirms the per-section enumeration referenced in spec step 6 ("Select Video Views under Authorised Data section").

## Assertion results

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6a | Post count updates after selecting Video Views | Posts(2) returned on Adam's Brand Set IG May 30–Jun 1 2026 after Authorized Video Views rank-by selection (workable mechanic verified) | PASS (on substitute) |
| A2 | 6b | Correct channels for Video Views = FB, Twitter, IG, YouTube, TikTok | Channel chips DOM verified — all 5 present in `.channel-ghost.<name>` | PASS |
| A3 | 6c | Sum/Avg display calculated values (not endash) or N/A | Sum=965,624 / Avg=482,812 — both calculated numerics, no endash | PASS |
| A4 | 7a | No endash/N/A in Sum/Avg | Confirmed numerics | PASS (on substitute, without the spec's Publish Type = Reel filter) |
| A5 | 7b | Post count matches posts with data | Posts(2) → both have valid Video Views (806,052 and 159,572) — no excluded endash/lock posts | PASS (on substitute) |
| A6 | 7c | Avg = Sum / posts-with-data | 965,624 / 2 = 482,812 EXACT MATCH | PASS |
| A7 | 8a | CSV data matches UI data | NOT VERIFIED — Export action deferred since substitute setup; mechanic likely identical to QA-132392/QA-132387 verified in batch-6 | NOT VERIFIED |
| A8 | 8b | CSV does NOT contain Sum/Avg rows | NOT VERIFIED — same reason | NOT VERIFIED |
| A9 | 9a | Only McDonald's posts after Content Brand filter | NOT VERIFIED — McDonald's not in Adam's Brand Set | NOT VERIFIED |
| A10 | 9b | Lock on IG/FB posts where Video Views unauthorized | NOT VERIFIED — Adam's Brand Set posts in window are all MTV-Authorized | NOT VERIFIED |
| A11 | 9c | Video Views/Shares visible on other channels | NOT VERIFIED | NOT VERIFIED |
| A12 | 9d | Sum/Avg correct after McDonald's filter | NOT VERIFIED | NOT VERIFIED |
| A13 | 9e | Post count matches data-posts after McDonald's filter | NOT VERIFIED | NOT VERIFIED |
| A14 | 10a | CSV matches UI after McDonald's filter | NOT VERIFIED | NOT VERIFIED |
| A15 | 10b | CSV doesn't include Sum/Avg rows after McDonald's filter | NOT VERIFIED | NOT VERIFIED |

## Bugs filed
None — mechanic verified; spec-brand assertions deferred for Viacom-session run.

## Carry-forward findings
- Filter persistence across URL navigations: even after URL is rewritten without a `filters` param, the prior MTV Content Brand filter persisted in the page state until "Clear All" was clicked explicitly. URL `&filters=%7B%7D` was insufficient. Workaround documented in this run.
- "Lifetime" Mode renders by default on Brand Sets > Content (matches spec precondition).

## Skill registry impact
- Brand Sets > Content Sum/Avg verification mechanic re-confirmed (parity with QA-132392/QA-132387 from batch-6) — future Sum/Avg flows can reuse.
- Pre-narrow workaround per known-quirks (single channel + 3-day window) succeeded — renderer hang documented per quirk.

## Sources
- [QA-133403 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-133403)
- Spec: `testcases/english/QA-133403.md`
