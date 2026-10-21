# QA-32526 — Brand Content Vs Brand Sets Content - Video Views - Private Data QA - Lifetime Mode

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in`, lfiqa user on **Disney Ad Sales**
**Account:** Disney Ad Sales (account_id=634) · **Brand set:** LF // TV // Episodic (brand_set_id=756) · Content Brand filter: Disney Channel (19742 / brand_id 3877) · Rank: Video Views (Authorized Data, `rank_by_metric=lfm.content.video_views`) · Rank Mode: Filtered · Default week Oct. 12, 2026 – Oct. 18, 2026 · Lifetime · Brand > Content: Extended perspective, Video Views data set
**Verdict: PASS — Video Views identical for every post on all three channels: Facebook 14/14, Instagram 14/14, TikTok 14/14 (0 mismatches, 0 posts missing)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand Sets → Content → "LF // TV // Episodic" → Rank By Video Views (Authorized, last option) | ✅ |
| 4–6 | Content Brand: Disney Channel → Apply; Filtered rank mode; Table View; one channel at a time (re-applied after the filter/rank resets) | ✅ Posts (44) across channels → 14 per channel |
| 7–11 | Brand > Content → Disney Channel → Video Views data set → Facebook / Instagram / TikTok only → Table View | ✅ 14 / 14 / 14 posts |
| 12 | Facebook: exclude Reels | n/a — no Reel rows this week |
| 13–15 | Compare Video Views per post (permalink join; Facebook by Date + Text) | ✅ FB 14/14 (top "25 years after Halloweentown 2…" 42,853) · IG 14/14 (reel DeaUebTAVSW 1,680,701) · TikTok 14/14 (video 7696198252185554189 199,200) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Content tab Video Views match Brand Sets Content Video Views (Private Data) | 42/42 identical across the three channels | ✅ PASS |

## Evidence
- Session result `ctx._bs32526`.

## Known bugs checked
- None open on the case.

## Bugs filed
None.

## Cleanup
None (read-only).
