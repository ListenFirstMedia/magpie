# QA-32526 — Brand Content Vs Brand Sets Content - Video Views - Private Data QA

**Run date:** 2026-10-27 (Tuesday) — case is fixed to Disney Ad Sales / Disney Channel
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` (skill `brand-sets-content-vs-brand-content`)
**Account:** Disney Ad Sales (account_id=634) · **Brand set:** LF // TV // Episodic (brand_set_id=756) · **Content Brand filter:** Disney Channel (brand_id=3877) · Rank By: Video Views (Authorized Data), Rank Mode Filtered · Mode: Lifetime · Date range: default week Oct. 19, 2026 – Oct. 25, 2026
**Verdict: PASS — Video Views identical for every post on all five channels: Facebook 11/11, Twitter 2/2, Instagram 11/11, TikTok 12/12, YouTube 11/11 (0 mismatches, 0 posts missing on either surface)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 7–11 | Brand > Content → Disney Channel → data set **Video Views** → Table View, one channel at a time | ✅ Facebook 11 · Twitter 2 · Instagram 11 · TikTok 12 |
| 11 (YouTube) | YouTube is greyed out under the Video Views data set on Brand > Content (known quirk), so the YouTube leg used the **Public** data set (`table_data_set=youtube_only:_basic`, Video Views column present) | ✅ 11 YouTube posts |
| 1–2 | Brand Sets > Content → LF // TV // Episodic | ✅ `brand_set_id=756` |
| 3 | Rank By → **Video Views** (Authorized Data = 2nd "Video Views" option) | ✅ `rank_by_metric=lfm.content.video_views` |
| 5 | Filter → Content Brand: Disney Channel → Apply | ✅ `filters={"content_brand_ids":{"values":[19742]}}`, Posts (47) |
| 6 | Table View, Rank Mode **Filtered** | ✅ |
| 13–15 | Per channel (channel re-applied after the Rank change): join rows by permalink (Facebook by Date\|Text) and diff Video Views | ✅ see assertions |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A-FB | Facebook Video Views equal | 11 matched / 0 mismatches (top: Oct 20 "Happy 20th anniversary to Return to Halloweentown" 100,725) | ✅ PASS |
| A-TW | Twitter Video Views equal | 2 matched / 0 mismatches (top status 2113676839134658886 3,991) | ✅ PASS |
| A-IG | Instagram Video Views equal | 11 matched / 0 mismatches (top reel DeubQbsCuEG 995,153) | ✅ PASS |
| A-TT | TikTok Video Views equal | 12 matched / 0 mismatches (top video 7700249258116599054 736,600) | ✅ PASS |
| A-YT | YouTube Video Views equal | 11 matched / 0 mismatches (top watch?v=CYAAW3TwDAY 21,930) | ✅ PASS |

## Evidence
- Session result `ctx._bs.q32526` (+ `.youtubePublic` for the YouTube leg).
- First pass showed small Facebook/Instagram deltas (e.g. 100,725 vs 100,845) because the Content tab was still on the Public data set (public views) when scraped; re-scraped with `table_data_set=video_views` verified in the URL → 0 mismatches. YouTube leg read from the YouTube-only Public table as on 2026-10-26.

## Known bugs checked
- None open on QA-32526.

## Bugs filed
None.

## Cleanup
None (read-only).
