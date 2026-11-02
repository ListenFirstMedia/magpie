# QA-573 — YouTube Lifetime Public Data QA

**Run date:** 2026-10-26 (Monday) — case is fixed to Viacom / LF // TV // Episodic / The Daily Show
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` (skill `brand-sets-content-vs-brand-content`)
**Account:** Viacom (account_id=181) · **Brand set:** LF // TV // Episodic (brand_set_id=756) · **Content Brand filter:** The Daily Show (brand_id=9973) · Channel: YouTube only · Mode: Lifetime · Date range: default week Oct. 18, 2026 – Oct. 24, 2026
**Verdict: PASS — every Daily Show YouTube post carries identical values on Brand Sets > Content and Brand > Content: Comments 35/35, Reactions (= YouTube Likes) 35/35, Video Views 26/26 (0 mismatches, 0 posts missing)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 6–9 | Brand > Content → The Daily Show → YouTube only → Table View | ✅ 35 posts (YouTube-only table: Video Views / Likes / Comments) |
| 1–2 | Brand Sets > Content → LF // TV // Episodic | ✅ `brand_set_id=756` (the page first came up remembering "LF // TV // Episodic Plus" and sat on Loading for minutes; selecting the Episodic set directly fixed it) |
| 4 | Filter → Content Brand: The Daily Show → Apply | ✅ `filters={"content_brand_ids":{"values":[9973]}}`, Posts (168) |
| 3, 5 | Table View, YouTube only (re-applied after every Rank change) | ✅ |
| 10–13 | Rank By **Comments** → compare | ✅ 35 rows, 35 matched, 0 mismatches (top JjI3TM__A5o 6,862) |
| 14–17 | Rank By **Reactions** → compare with Content "Likes" | ✅ 35 rows, 35 matched, 0 mismatches (top BH5wXOeCGFs 179,098) |
| 18–21 | Rank By **Video Views** (public) → compare | ✅ 26 rows, 26 matched, 0 mismatches (top JjI3TM__A5o 6,603,298) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A13 | Comments match | 35/35 identical | ✅ PASS |
| A17 | Reactions match | 35/35 identical (Content YouTube table labels the column "Likes") | ✅ PASS |
| A21 | Video Views match | 26/26 identical (Brand Sets lists 26 rows under the Video Views rank) | ✅ PASS |

## Evidence
- Session result `ctx._bs.q573` (`cmp.Comments`, `cmp.Reactions` re-run against `Likes`, `cmp['Video Views']`).

## Known bugs checked
- None open on QA-573.

## Bugs filed
None.

## Cleanup
None (read-only).
