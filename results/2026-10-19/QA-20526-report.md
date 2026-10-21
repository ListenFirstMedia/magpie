# QA-20526 — Brand Content > Data Test > Paid Posts

**Run date:** 2026-10-19 · **Track:** Playwright MCP interactive · **Account:** Hulu (336) · **Brand:** Hulu (brand_id 5670) · **Date range:** Nov. 01, 2024 – Oct. 31, 2025 · Table View · Filter **Paid: Boosted** (URL `content_is_paid: ["Promoted"]`; Posts 6,579 → 616) · 200 rendered rows per data set
**Verdict: FAIL — paid metrics are populated for Engagements/Impressions/Video Views (A6–A8 largely hold), but A10 (Paid Follows) and A11 (Paid Saves) show en-dash on paid posts; A11 is the known open bug APPS-62446, A10 matches LFMP-32088 / APPS-60871**

| ID | Data set (channels auto-narrowed) | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A6 | Engagements Breakdown (TW+IG, 259 posts) | Paid Engagements / Reactions / Comments / Shares show values, no en-dash | Paid Engagements 200/200 values (e.g. 658,350); Paid Reactions 200/200; **Paid Comments 170 values + 30 "–"** (video posts); **Paid Shares 199 "–"** (Instagram has no paid-shares metric; 1 tweet shows 216) | ⚠ PARTIAL — Shares en-dash is structural for IG; the 30 Paid Comments en-dashes need a look (0 comments rendered as "–"?) |
| A7 | Impressions (TW+IG) | Paid Impressions and Promoted/Paid Reach show values | Paid Impressions 200/200 (e.g. 5,347,416); Paid Reach 199/200 (1 "–") | ✅ |
| A8 | Video Views (TW+IG, 218) | Paid Views show values | 198/200 values (e.g. 88,243); 2 "–" (ranks 167, 186) | ✅ (2 outliers noted) |
| A9 | Facebook Only: Completed & Live Videos (FB, 18) | Paid Completed Views show values | 14 values + 1 zero + **3 "–" (all Reels)** | ⚠ Reels carry no completed-views metric |
| A10 | Twitter Only: Engagements & Follows (TW, 3) | Paid Follows show values | **3/3 "–"** | ❌ LFMP-32088 / APPS-60871 pattern (no User Follows data) |
| A11 | Instagram Only: Insights (IG, 256) | Paid Saves show values | **177/200 "–"**, 2 zero, 21 values (e.g. rank 2: 8,419) | ❌ **APPS-62446** (Open) "En dash displayed for the Paid Saves metric" — reproduces |

## Evidence
`.playwright-out/QA-20526/01-hulu-paid-boosted.png` … `07-ig-insights.png`

## Known bugs checked
- APPS-62446 (Open) — **reproduces** (A11). LFMP-32088 (Open) — same symptom on Paid User Follows (A10). APPS-59251 (Open QA Task) is the JMeter→Playwright migration of this very case.

## Bugs filed
None (both failures map to open bugs). · **Cleanup:** filter cleared after the run.
