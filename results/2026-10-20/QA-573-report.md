# QA-573 — YouTube Lifetime Public Data QA

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in`, lfiqa user switched to **Viacom**
**Account:** Viacom (account_id=181) · **Brand set:** LF // TV // Episodic (brand_set_id=756) · Content Brand filter: The Daily Show (brand 9973 in the set, brand_id 4215 on Brand > Content) · Channel: YouTube · Date range: default week Oct. 12, 2026 – Oct. 18, 2026 · Mode: Lifetime, Public data
**Verdict: PASS — all 20 YouTube posts of The Daily Show carry identical Comments, Reactions (= Likes) and Video Views on Brand Sets > Content and Brand > Content (0 mismatches on 3 × 20 values)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand Sets → Content; brand set picker → "LF // TV // Episodic" | ✅ `#explore/competitive/content?brand_set_id=756` |
| 3 | Table View | ✅ `table.lfm-table`, 100 rows/page, columns Rank / Date / Channel / Brand / Programmer / Sponsor / Type / Live / Publish Type / Text / **<rank metric>** / Share / Actions |
| 4 | Filter → Content Brand: The Daily Show → Apply Filter | ✅ URL `filters={"content_brand_ids":{"operator":"or","values":[9973]…}}`; the filter reset the channel ghosts to all five channels |
| 5 | YouTube channel only → Apply | ✅ enabled [youtube], Posts (93 → YouTube rows identified by permalink) |
| 6–9 | New tab Brand > Content → brand "The Daily Show" → YouTube only → Table View | ✅ brand_id 4215, YouTube Only: Basic data set, **20 posts**, columns Video Views / Likes / Comments |
| 10–13 | Brand Sets Rank by **Comments** → compare per post | ✅ 20/20 YouTube posts matched by permalink, 0 differences |
| 14–17 | Rank by **Reactions** → compare | ✅ 20/20 matched, 0 differences (Brand > Content column is "Likes") |
| 18–21 | Rank by **Video Views** → compare | ✅ 20/20 matched, 0 differences |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A13 | Comments match between Brand > Content and Brand Sets > Content | 20/20 identical | ✅ PASS |
| A17 | Reactions match | 20/20 identical (Likes column on Brand > Content) | ✅ PASS |
| A21 | Video views match | 20/20 identical | ✅ PASS |

## Evidence
- Brand Sets rows per rank metric and the Brand > Content scrape are in the session result (`ctx._bs573`, `ctx._c573`); example top YouTube post Sat Oct. 17, 2026 "Jon Stewart and The News Team Tackle the 2026 Midterm Candidates": Video Views 2,626,604 · Likes 25,767 · Comments 800 on both surfaces.

## Known bugs checked
- None open on the case.

## Notes
- Changing **Rank By** (and applying the Content Brand filter) re-enables all five channels on Brand Sets > Content, so the ranked table mixes Instagram/TikTok/Facebook rows (93 posts for The Daily Show). The comparison therefore keyed rows by permalink and evaluated the YouTube ones; every YouTube post of the brand (20) was present and matched. For an unattended run, re-apply the single channel after every Rank By change.

## Bugs filed
None.

## Cleanup
None (read-only).
