# QA-32526 — Brand Content Vs Brand Sets Content - Video Views - Private Data QA

**Run date:** 2026-10-28 (Wednesday) — case is fixed to Disney Ad Sales / Disney Channel
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in` (skill `brand-sets-content-vs-brand-content`)
**Account:** Disney Ad Sales (account_id=634) · **Brand set:** LF // TV // Episodic (brand_set_id=756) · **Content Brand filter:** Disney Channel (brand_id=3877) · Rank By: Video Views (Authorized Data), Rank Mode Filtered · Mode: Lifetime · Date range: default week Oct. 20, 2026 – Oct. 26, 2026
**Verdict: PASS — Video Views identical for every post on all five channels: Facebook 10/10, Twitter 1/1, Instagram 12/12, TikTok 13/13, YouTube 13/13 (0 mismatches, 0 posts missing on either surface)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 7–11 | Brand > Content → Disney Channel → data set **Video Views** → Table View, one channel at a time | ✅ Facebook 10 · Twitter 1 · Instagram 12 · TikTok 13 |
| 11 (YouTube) | YouTube is greyed out under the Video Views data set on Brand > Content (known quirk), so the YouTube leg used the **Public** data set (`table_data_set=youtube_only:_basic`, Video Views column present) | ✅ 13 YouTube posts |
| 1–2 | Brand Sets > Content → LF // TV // Episodic | ✅ `brand_set_id=756` |
| 3 | Rank By → **Video Views** (Authorized Data = 2nd "Video Views" option) | ✅ `rank_by_metric=lfm.content.video_views` |
| 5 | Filter → Content Brand: Disney Channel → Apply | ✅ `filters={"content_brand_ids":{"values":[19742]}}`, Posts (49) |
| 6 | Table View, Rank Mode **Filtered** | ✅ |
| 13–15 | Per channel (channel re-applied after the Rank change): join rows by permalink (Facebook by Date\|Text) and diff Video Views | ✅ see assertions |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A-FB | Facebook Video Views equal | 10 matched / 0 mismatches (top: Oct 20 "Happy 20th anniversary to Return to Halloweentown" 102,102) | ✅ PASS |
| A-TW | Twitter Video Views equal | 1 matched / 0 mismatches (status 2113676839134658886 4,020) | ✅ PASS |
| A-IG | Instagram Video Views equal | 12 matched / 0 mismatches (top reel DeubQbsCuEG 1,009,294) | ✅ PASS |
| A-TT | TikTok Video Views equal | 13 matched / 0 mismatches (top video 7700249258116599054 814,500) | ✅ PASS |
| A-YT | YouTube Video Views equal | 13 matched / 0 mismatches (top watch?v=CYAAW3TwDAY 24,180) | ✅ PASS |

## Evidence
- Session result `ctx._bs.q32526` (+ `.youtubePublic` for the YouTube leg).
- Content data set verified from the URL (`table_data_set=video_views`) before scraping; YouTube leg read from the YouTube-only Public table.

## Known bugs checked
- None open on QA-32526.

## Bugs filed
None.

## Cleanup
None (read-only).
