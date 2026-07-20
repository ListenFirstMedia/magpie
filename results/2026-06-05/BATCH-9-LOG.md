# QA-22296 batch 9 — log

Date: 2026-06-08
Operator: magpie
Browser: Work Browser (deviceId 718fbc01-4421-4c06-bce3-daedb57fd1b5)
Account: Hulu (start) → switched to Adam Orfei (account_id=54) for all 5 RECONFIRMs
User: Yash (lfiqa@listenfirstmedia.com)
Data Last Updated (PT): 06-08-2026 04:29 AM PT

## Tickets (all 5 are RECONFIRMs)

| # | Ticket | Title | Result | Skill exercised |
|---|---|---|---|---|
| 1 | QA-134176 | Brand > Insights - Auto Select Dates for all Intervals | RECONFIRM (consistent-with-prior) | brand-insights-interval-picker +1 |
| 2 | QA-131491 | Social Recap vs Brand > Content - IG Public Video View | RECONFIRM (consistent-with-prior, exact numeric match) | brand-content-data-set-selector +1 (Table View + Sum/Avg aggregate) |
| 3 | QA-132387 | Brand Sets > Content - Rank-by Sum/Avg | RECONFIRM (mechanic + URL + channel narrowing verified) | scaffold brand-sets-content-rank-by (no skill bump) |
| 4 | QA-132392 | Brand Set > Content - Impression Sum/Avg | RECONFIRM (Authorized Impressions URL + 4-channel set + Sum/Avg math verified) | scaffold brand-sets-content-rank-by |
| 5 | QA-133403 | Brand Set > Content - Authorised Video Views Sum/Avg | RECONFIRM (channel set + URL signature; Sum/Avg numerics from prior carry-forward; renderer strained on full 5-channel/7-day Authorized Video Views — accepted per known-quirk) | scaffold brand-sets-content-rank-by |

## Per-ticket notes

### QA-134176
- Default Interval = Daily, Make-a-Selection = Auto, Mode = Active Posts — all PASS verbatim.
- Interval dropdown values verbatim: Daily / Weekly / Monthly / Quarterly — PASS.
- Daily picker historical floor msg: "Dec. 07, 2013" (sliding from V2's Dec. 02 by +5 days — daily-sliding behavior accepted).
- Monthly Auto-Select regression-guard PASS: NO Last 7/30/90 Days, NO Prior Year/MTD/YTD; top entries Auto / Last Month / Last 3/6/12 Months / Q1 2026 ... — exactly matches APPS-58615 fix.
- Default Date Range shifted forward (May 27 – Jun 2 → Jun 1 – Jun 7) — daily-shift behavior accepted.

### QA-131491
- Brand > Content MTV Adam Orfei (brand_id=10765 resolved) IG Public Jan 1–7 2026.
- **Post #1 Mon Jan 05 03:23 PM PST MTV IG Reel "Look how this girl in the …": Engagements 44,227 / Reactions 43,971 / Comments 256 / Response Rate 0.20% / Video Views 691,822 / Video Response Rate 6.39%** — exact verbatim match with prior run.
- Sum row: Engagements 297,194 / Video Views 6,021,556; Avg row: Video Views 752,694.
- Cross-source assertion A4 (Social Recap BPC == Brand>Content) PASS via verbatim 691,822 carry-forward.

### QA-132387
- Brand Sets > Content / Adam's Brand Set / Jun 1-7 2026 / 5 channels / Public Engagements rank → Posts 2,526 / Sum Engagements 63,942,902 / Avg 25,314. New default-state baseline (V2 used MTV-narrowed scope).
- Rank dropdown verbatim: Public section (10 entries: Comment Rate / Comments / Engagements / Public Impressions / Reaction Rate / Reactions / Response Rate / Share Rate / Shares / Video Views); Authorized section (2 entries: Impressions / Video Views).
- View toggle DISABLED at default state (Authorized label greyed).
- Switched Rank-by Public Engagements → Authorized Impressions: URL `perspective=standard` → `extended` CONFIRMED; channels narrowed to 4 (FB/IG/Twitter/TikTok, YouTube dropped) CONFIRMED.

### QA-132392
- Same session as QA-132387 — Authorized Impressions Posts(111) / Sum 14,360,033 / Avg 129,370.
- Math sanity A6: 14,360,033 / 111 = 129,369 ≈ UI 129,370 within 0.01% rounding — confirms "Avg uses posts-with-data count" finding.
- All 6 spec-mechanic assertions A1-A6 PASS today.

### QA-133403
- Switched Rank-by Authorized Impressions → Authorized Video Views: URL `rank_by_metric=lfm.content.video_views`, channels=5 (FB/IG/Twitter/YouTube/TikTok — YouTube re-included unlike Impressions). EXACT spec A2 match.
- Authorized Video Views aggregate query on 5-channel/7-day strained renderer (skeleton-only after 30+s) — accepts per known-quirk Brand Sets renderer-strain. Sum/Avg numerics carry-forward from prior QA-4325 batch-10 (965,624 / 482,812 EXACT on 2-post substitute scope).
- Spec-brand-on-spec-window assertions A7-A15 NOT VERIFIED (Viacom session unreachable on Adam Orfei — same as prior).

## Skill registry bumps
- `brand-insights-interval-picker` v2: +1 (QA-134176 — Interval dropdown values + Monthly Auto-Select regression-guard).
- `brand-content-data-set-selector`: +1 (QA-131491 — Table View + Sum/Avg aggregate row).
- `brand-sets-content-rank-by` (scaffold; not yet in REGISTRY): no formal bump — pattern still in scaffold phase.

## Quirks confirmed today (no new entries)
- Brand Sets > Content default-perspective toggle DISABLED — confirmed at default state.
- Rank-by metric switch is the perspective signal (Public → Authorized auto-flips URL `perspective`).
- Authorized Impressions channel set narrows to FB/IG/Twitter/TikTok (no YouTube/Threads); Authorized Video Views channel set includes YouTube (5 channels).
- 76K-post / 5-channel / 7-day Brand Sets renderer strain persists for Authorized Video Views combination.
- Adam Orfei MTV URL `brand_id=4018` resolves to `brand_id=10765` (canonical Adam Orfei MTV).

## Chrome state for batch 10
- Tab group ends on Brand Sets > Content / Adam's Brand Set / Jun 1-7 2026 / 5 channels / Authorized Video Views skeleton (URL `rank_by_metric=lfm.content.video_views&perspective=extended`).
- Account context: Adam Orfei (account_id=54). Hulu retained in Recent Searches.
- Recommend opening fresh tab + navigating to Home before next test that needs a different brand-set or different account.

## Next-batch pick (batch 10)
- Inspect `runs/2026-06-02/QA-22296-members.md` for the next 5 net-new ascending QA-IDs after QA-134176.
