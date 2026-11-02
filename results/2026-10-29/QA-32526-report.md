# QA-32526 — Brand Content Vs Brand Sets Content - Video Views - Private Data QA

**Run date:** 2026-10-29 (Thursday) — case is fixed to Disney Ad Sales / Disney Channel
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` (skill `brand-sets-content-vs-brand-content`)
**Account:** Disney Ad Sales (account_id=634) · **Brand set:** LF // TV // Episodic (brand_set_id=756) · **Content Brand filter:** Disney Channel (brand_id=3877) · Rank By: Video Views (Authorized Data), Rank Mode Filtered · Mode: Lifetime · Date range: default week Oct. 21, 2026 – Oct. 27, 2026
**Verdict: PASS — Video Views identical for every post on all five channels: Facebook 9/9, Twitter 1/1, Instagram 11/11, TikTok 12/12, YouTube 13/13 (0 mismatches, 0 posts missing on either surface)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 7–11 | Brand > Content → Disney Channel → data set **Video Views** → Table View, one channel at a time | ✅ Facebook 9 · Twitter 1 · Instagram 11 · TikTok 12 |
| 11 (YouTube) | YouTube is greyed out under the Video Views data set on Brand > Content (known quirk), so the YouTube leg used the **Public** data set (`table_data_set=youtube_only:_basic`, Video Views column present) | ✅ 13 YouTube posts |
| 1–2 | Brand Sets > Content → LF // TV // Episodic | ✅ `brand_set_id=756` (Brand Sets side scraped first today, straight after QA-32524, while the page was responsive; the Content side was read afterwards and joined offline) |
| 3 | Rank By → **Video Views** (Authorized Data = 2nd "Video Views" option) | ✅ `rank_by_metric=lfm.content.video_views` |
| 5 | Filter → Content Brand: Disney Channel → Apply | ✅ `filters={"content_brand_ids":{"values":[19742]}}`, Posts (37, Disney Channel filter carried over from QA-32524) |
| 6 | Table View, Rank Mode **Filtered** | ✅ |
| 13–15 | Per channel (channel re-applied after the Rank change): join rows by permalink (Facebook by Date\|Text) and diff Video Views | ✅ see assertions |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A-FB | Facebook Video Views equal | 9 matched / 0 mismatches (top: Oct 26 "They don’t build statues of critics 🎃 🎥: Austin & Ally" 36,781) | ✅ PASS |
| A-TW | Twitter Video Views equal | 1 matched / 0 mismatches (status 2113676839134658886 4,020) | ✅ PASS |
| A-IG | Instagram Video Views equal | 11 matched / 0 mismatches (top reel De4gB_mg2ns 884,558) | ✅ PASS |
| A-TT | TikTok Video Views equal | 12 matched / 0 mismatches (top video 7700249258116599054 846,300) | ✅ PASS |
| A-YT | YouTube Video Views equal | 13 matched / 0 mismatches (top watch?v=5nsDWEP3QvE 24,380) | ✅ PASS |

## Evidence
- Session result `ctx._bs.q32526` (Brand Sets rows in `ctx._bs.q32526bs`, Content maps in `ctx._bsCache.vv5`).
- Content data set verified from the URL (`table_data_set=video_views`) before scraping; YouTube leg read from the YouTube-only Public table.

## Known bugs checked
- None open on QA-32526.

## Bugs filed
None.

## Cleanup
None (read-only).
