# QA-19701 — Brand Content - Facebook Only: Reactions DataSet - Data Test

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** current default week Oct. 11 – Oct. 17, 2026 · **Channel:** Facebook only · **Data set:** Facebook Only: Reactions (`facebook_only:_reactions`)
**Verdict: PASS (1/1) — Likes + Loves + Hahas + Wows + Sads + Angries + Others = Reactions on all 30 posts and on the Sum row**

## Steps
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand>Content, HBO Max, Data Set = Facebook Only: Reactions | ✅ Posts (30); columns Engagements, Reactions, Likes, Loves, Hahas, Wows, Sads, Angries, Others |
| 4 | Table View; all 30 rows scraped | ✅ |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4 | Σ(7 reaction types) = Reactions | 30/30 (rank 1: 40,707+1,363+364+57+4+1+0 = 42,496 ✓; rank 2: 26,864 ✓; rank 3: 24,978 ✓). Sum row 157,714+18,734+3,375+1,670+52+22+0 = 181,567 ✓ | ✅ PASS |

## Evidence
`.playwright-out/QA-19701/01-fb-reactions-table.png`

## Known bugs checked
No open linked bugs.

## Bugs filed
None. · **Cleanup:** none.
