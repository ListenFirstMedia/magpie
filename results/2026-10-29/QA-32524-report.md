# QA-32524 — Brand Content Vs Brand Sets Content - Impressions - Private Data QA

**Run date:** 2026-10-29 (Thursday) — case is fixed to Disney Ad Sales / Disney Channel
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` (skill `brand-sets-content-vs-brand-content`)
**Account:** Disney Ad Sales (account_id=634) · **Brand set:** LF // TV // Episodic (brand_set_id=756) · **Content Brand filter:** Disney Channel (brand_id=3877) · Rank By: Impressions (Authorized Data), Rank Mode Filtered · Mode: Lifetime · Date range: default week Oct. 21, 2026 – Oct. 27, 2026
**Verdict: PASS — Impressions identical for every post on all three channels: Facebook 10/10, Instagram 13/13, TikTok 13/13 (0 mismatches, 0 posts missing on either surface)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 7–11 | Brand > Content → Disney Channel → data set **Impressions** → Table View, one channel at a time | ✅ Facebook 10 posts · Instagram 13 · TikTok 13 (columns Impressions / Organic / Paid / Reach …) |
| 12 | Facebook: Publish Type ≠ Reel | ℹ️ not needed — every Brand Sets Facebook row matched a Content row without the exclusion |
| 1–2 | Brand Sets > Content → LF // TV // Episodic | ✅ `brand_set_id=756` (the page stayed half-rendered or empty through 4 reloads while the unattended lanes were loading dev; a fresh Home → Brand Sets > Content navigation, applying the channel before the Rank and the Filter, finally rendered and the Brand Sets side resumed from the cached Content scrape) |
| 3 | Rank By → **Impressions** (Authorized Data) | ✅ `rank_by_metric=lfm.content.impressions_v7_v2` |
| 5 | Filter → Content Brand: Disney Channel → Apply | ✅ `filters={"content_brand_ids":{"values":[19742]}}`, Posts (37) |
| 6 | Table View, Rank Mode **Filtered** | ✅ |
| 13–15 | Per channel (re-applied after each Rank change): join Brand Sets rows to Content rows by permalink (Facebook by Date\|Text) and diff Impressions | ✅ see assertions |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A-FB | Facebook Impressions equal on both surfaces | 10 rows, 10 matched, 0 mismatches (top: Oct 26 "Comment ⚔️or 🍰to vote for your fave 🎥: Austin & Ally" 73,835) | ✅ PASS |
| A-IG | Instagram Impressions equal | 13 rows, 13 matched, 0 mismatches (top reel De4gB_mg2ns 884,558) | ✅ PASS |
| A-TT | TikTok Impressions equal | 13 rows, 13 matched, 0 mismatches (top video 7700249258116599054 846,300) | ✅ PASS |

## Evidence
- Session result `ctx._bs.q32524r` (Content side cached in `ctx._bsCache`) (per-channel row maps, Rank/filter URLs).

## Known bugs checked
- None open on QA-32524.

## Bugs filed
None.

## Cleanup
None (read-only).
