# QA-32524 — Brand Content Vs Brand Sets Content - Impressions - Private Data QA

**Run date:** 2026-10-28 (Wednesday) — case is fixed to Disney Ad Sales / Disney Channel
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` (skill `brand-sets-content-vs-brand-content`)
**Account:** Disney Ad Sales (account_id=634) · **Brand set:** LF // TV // Episodic (brand_set_id=756) · **Content Brand filter:** Disney Channel (brand_id=3877) · Rank By: Impressions (Authorized Data), Rank Mode Filtered · Mode: Lifetime · Date range: default week Oct. 20, 2026 – Oct. 26, 2026
**Verdict: PASS — Impressions identical for every post on all three channels: Facebook 11/11, Instagram 14/14, TikTok 14/14 (0 mismatches, 0 posts missing on either surface)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 7–11 | Brand > Content → Disney Channel → data set **Impressions** → Table View, one channel at a time | ✅ Facebook 11 posts · Instagram 14 · TikTok 14 (columns Impressions / Organic / Paid / Reach …) |
| 12 | Facebook: Publish Type ≠ Reel | ℹ️ not needed — every Brand Sets Facebook row matched a Content row without the exclusion |
| 1–2 | Brand Sets > Content → LF // TV // Episodic | ✅ `brand_set_id=756` (page half-rendered without the Rank dropdown once; a reload fixed it and the Brand Sets side resumed from the cached Content scrape) |
| 3 | Rank By → **Impressions** (Authorized Data) | ✅ `rank_by_metric=lfm.content.impressions_v7_v2` |
| 5 | Filter → Content Brand: Disney Channel → Apply | ✅ `filters={"content_brand_ids":{"values":[19742]}}`, Posts (40) |
| 6 | Table View, Rank Mode **Filtered** | ✅ |
| 13–15 | Per channel (re-applied after each Rank change): join Brand Sets rows to Content rows by permalink (Facebook by Date\|Text) and diff Impressions | ✅ see assertions |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A-FB | Facebook Impressions equal on both surfaces | 11 rows, 11 matched, 0 mismatches (top: Oct 20 "Happy 20th anniversary to Return to Halloweentown" 208,733) | ✅ PASS |
| A-IG | Instagram Impressions equal | 14 rows, 14 matched, 0 mismatches (top reel DeubQbsCuEG 1,009,294) | ✅ PASS |
| A-TT | TikTok Impressions equal | 14 rows, 14 matched, 0 mismatches (top video 7700249258116599054 814,500) | ✅ PASS |

## Evidence
- Session result `ctx._bs.q32524` (per-channel row maps, Rank/filter URLs).

## Known bugs checked
- None open on QA-32524.

## Bugs filed
None.

## Cleanup
None (read-only).
