# QA-573 — YouTube Lifetime Public Data QA

**Run date:** 2026-10-27 (Tuesday) — case is fixed to Viacom / LF // TV // Episodic / The Daily Show
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` (skill `brand-sets-content-vs-brand-content`)
**Account:** Viacom (account_id=181) · **Brand set:** LF // TV // Episodic (brand_set_id=756) · **Content Brand filter:** The Daily Show (brand_id=9973) · Channel: YouTube only · Mode: Lifetime · Date range: default week Oct. 19, 2026 – Oct. 25, 2026
**Verdict: PASS — every Daily Show YouTube post carries identical values on Brand Sets > Content and Brand > Content: Comments 34/34, Reactions (= YouTube Likes) 34/34, Video Views 34/34 (0 mismatches, 0 posts missing)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 6–9 | Brand > Content → The Daily Show → YouTube only → Table View | ✅ 34 posts (YouTube-only table: Video Views / Likes / Comments); the brand typeahead needed the full name "The Daily Show" — "The Daily" lists only the first ten alphabetical matches |
| 1–2 | Brand Sets > Content → LF // TV // Episodic | ✅ `brand_set_id=756` (the page first came up remembering another set and sat on Loading; selecting the Episodic set directly fixed it; the Comments-ranked view needed a reload after ~6 min of Loading) |
| 4 | Filter → Content Brand: The Daily Show → Apply | ✅ `filters={"content_brand_ids":{"values":[9973]}}`, Posts (168) |
| 3, 5 | Table View, YouTube only (re-applied after every Rank change) | ✅ |
| 10–13 | Rank By **Comments** → compare | ✅ 34 rows, 34 matched, 0 mismatches (top 6o73cZMGQvg 7,291) |
| 14–17 | Rank By **Reactions** → compare with Content "Likes" | ✅ 34 rows, 34 matched, 0 mismatches (top BH5wXOeCGFs 179,098) |
| 18–21 | Rank By **Video Views** (public) → compare | ✅ 34 rows, 34 matched, 0 mismatches (top JjI3TM__A5o 6,974,251) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A13 | Comments match | 34/34 identical | ✅ PASS |
| A17 | Reactions match | 34/34 identical (Content YouTube table labels the column "Likes") | ✅ PASS |
| A21 | Video Views match | 34/34 identical | ✅ PASS |

## Evidence
- Session result `ctx._bs.q573` (`cmp.Comments` re-run after a reload, `cmp.Reactions` against `Likes`, `cmp['Video Views']`).

## Known bugs checked
- None open on QA-573.

## Bugs filed
None.

## Cleanup
None (read-only).
