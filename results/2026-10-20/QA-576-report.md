# QA-576 — Instagram Lifetime Public Data QA

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in`, lfiqa user switched to **Netflix Sustainability Team**
**Account:** Netflix Sustainability Team (account_id=3454) · **Brand set:** LF // TV // Episodic Plus (brand_set_id=757) · Content Brand filter: The Walking Dead (brand_id 9654) · Channel: Instagram · Date range: default week Oct. 12, 2026 – Oct. 18, 2026 · Lifetime, Public data
**Verdict: PASS — both Instagram posts of The Walking Dead in the window carry identical Engagements, Comments and Reactions on Brand Sets > Content and Brand > Content (0 mismatches)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand Sets → Content → brand set "LF // TV // Episodic Plus" | ✅ brand_set_id 757 |
| 3 | Instagram only | ✅ (re-applied after the Content Brand filter and after each Rank By change, which reset the channels) |
| 4 | Filter → Content Brand: The Walking Dead → Apply | ✅ `filters={"content_brand_ids":{"values":[9654]}}`, Posts (7) across channels → 2 Instagram rows |
| 5–8 | New tab Brand > Content → The Walking Dead → Instagram only → Table View | ✅ Posts (2): reel DekaHI-gdjS (Engagements 65,565 · Reactions 64,320 · Comments 1,245) and post Deh22g1F-BO (58,917 · 58,743 · 174) |
| 9–10 | Brand Sets Rank by Engagements → compare top post | ✅ 65,565 vs 65,565; second post 58,917 vs 58,917 |
| 11–13 | Rank by Comments → compare | ✅ 1,245 / 174 identical |
| 14–16 | Rank by Reactions → compare | ✅ 64,320 / 58,743 identical |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Content tab Engagements == Brand Sets Content Engagements | 2/2 identical | ✅ PASS |
| A2 | Comments match | 2/2 identical | ✅ PASS |
| A3 | Reactions match | 2/2 identical | ✅ PASS |

## Evidence
- Session result `ctx._bs576` (rows for all three rank metrics plus the Brand > Content scrape).

## Known bugs checked
- None open on the case.

## Notes
- Small sample this week (2 posts). The first Engagements scrape returned an empty table while the channel re-applied; a stable-scrape retry (wait + re-scrape) fixed it and is now part of the skill.

## Bugs filed
None.

## Cleanup
None (read-only).
