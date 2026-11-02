# QA-576 — Instagram Lifetime Public Data QA

**Run date:** 2026-10-27 (Tuesday) — case is fixed to Netflix Sustainability Team / LF // TV // Episodic Plus / The Walking Dead
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` (skill `brand-sets-content-vs-brand-content`)
**Account:** Netflix Sustainability Team (account_id=3454) · **Brand set:** LF // TV // Episodic Plus (brand_set_id=757, Posts (87,293) unfiltered) · **Content Brand filter:** The Walking Dead (brand_id=9654) · Channel: Instagram only · Mode: Lifetime · Date range: default week Oct. 19, 2026 – Oct. 25, 2026
**Verdict: PASS — the single Walking Dead Instagram post in the window (reel De2TdcBAiyC) carries identical Engagements 1,786, Comments 19 and Reactions 1,767 on Brand Sets > Content and Brand > Content (0 mismatches)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 5–9 | Brand > Content → The Walking Dead → Instagram only → Table View | ✅ 1 post |
| 1–2 | Brand Sets > Content → LF // TV // Episodic Plus | ✅ `brand_set_id=757` (the helper now waits for the filter control, which renders minutes after the header on this 87k-post set) |
| 4 | Filter → Content Brand: The Walking Dead → Apply | ✅ `filters={"content_brand_ids":{"values":[9654]}}`, Posts (4) across channels |
| 3 | Instagram only (re-applied after every Rank change) | ✅ 1 row |
| 9–10 | Rank By **Engagements** → compare top post | ✅ 1,786 = 1,786 |
| 11–13 | Rank By **Comments** → compare | ✅ 19 = 19 |
| 14–16 | Rank By **Reactions** → compare | ✅ 1,767 = 1,767 |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Engagements match | 1/1 identical | ✅ PASS |
| A2 | Comments match | 1/1 identical | ✅ PASS |
| A3 | Reactions match | 1/1 identical | ✅ PASS |

## Evidence
- Session result `ctx._bs.q576` (single pass).

## Known bugs checked
- None open on QA-576.

## Bugs filed
None.

## Cleanup
None (read-only).
