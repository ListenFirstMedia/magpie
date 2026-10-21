# QA-26352 — Brand > Insights - Content Engagement Rate - Data Test

**Run date:** 2026-10-19 · **Track:** Playwright MCP interactive · **Account:** Hulu (336) · **Brand:** Hulu (5670) · Brand > Insights, default week Oct. 11 – Oct. 17, 2026, channels **Facebook + Twitter + Instagram** (TikTok deselected in `[data-ui-name=channel_selector]` → Apply), Authorized perspective · Big-number exact values read from the tile `.count[title]` attribute and the hover tooltip `.big-number-tooltip__table`
**Verdict: FAIL (needs triage) — (Engagements ÷ Impressions) × 100 = 0.98%, but the Content Engagement Rate tile shows 1.11%; the same formula DOES reproduce the comparison-period value exactly (1.03%), so the current-period gap is most likely posts that lack impressions being excluded from the rate but not from the Engagements tile (cf. the Facebook data-collection disruption)**

## Steps
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Insights, Hulu, channels FB/TW/IG only | ✅ (`channels=twitter&channels=instagram&channels=facebook`) |
| 4 | Hover Engagements big number | **1,553,791** (tooltip: Value 1,553,791 · Comparison 1,447,244 · Change +106,547) |
| 5 | Hover Impressions big number | **158,728,902** (Comparison 140,495,795) |
| 6 | Hover Content Engagement Rate big number | **1.11%** (Comparison 1.03%, Change +0.08%) |
| 7 | Compute E ÷ I × 100 | 1,553,791 ÷ 158,728,902 × 100 = **0.979%** |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7 | Content Engagement Rate = (Engagements / Impressions) × 100 | 0.98% computed vs 1.11% displayed (Δ 0.13 pp, 13% relative). Cross-check: comparison period 1,447,244 ÷ 140,495,795 = 1.030% = displayed 1.03% ✓ — the formula is right, the current week's inputs differ | ❌ FAIL (triage: which posts are excluded from CER's denominator this week?) |

## Evidence
`.playwright-out/QA-26352/01-insights.png`, `02-insights-tiles.png`

## Known bugs checked
DATA-12253 (closed) — not the same symptom. No open bug covers it. Note the platform-wide "Facebook Data Collection Disruption 9/27" banner: in Brand>Content this week 17 of 30 Facebook posts have no impressions at all (QA-19698); if CER is computed only over posts with impressions while the Engagements tile sums all posts, the 1.11% vs 0.98% gap is explained — confirm with the data team before filing.

## Bugs filed
None auto-filed (candidate documented). · **Cleanup:** none.
