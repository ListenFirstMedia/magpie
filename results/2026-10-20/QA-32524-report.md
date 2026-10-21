# QA-32524 — Brand Content Vs Brand Sets Content - Impressions - Private Data QA - Lifetime Mode

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in`, lfiqa user switched to **Disney Ad Sales**
**Account:** Disney Ad Sales (account_id=634) · **Brand set:** LF // TV // Episodic (brand_set_id=756) · Content Brand filter: Disney Channel (brand 19742 in the set; brand_id 3877 on Brand > Content) · Rank: Impressions (Authorized Data, `rank_by_metric=lfm.content.impressions_v7_v2`) · Rank Mode: Filtered · Date range: default week Oct. 12, 2026 – Oct. 18, 2026 · Lifetime · Brand > Content perspective Extended, data set Impressions
**Verdict: PASS — Impressions identical for every post on all three channels: Facebook 19/19, Instagram 17/17, TikTok 17/17 (0 mismatches, 0 posts missing on either surface)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand Sets → Content → "LF // TV // Episodic" | ✅ |
| 3 | Rank By → Impressions under Authorized Data (last "Impressions" option) | ✅ `rank_by_metric=lfm.content.impressions_v7_v2` |
| 4 | Facebook only, Lifetime (default) | ✅ (re-applied after the filter and after each channel switch) |
| 5 | Add filter → Content Brand: Disney Channel → Apply | ✅ `filters={"content_brand_ids":{"values":[19742]}}`, Posts (42) across channels |
| 6 | Table View, Rank Mode → Filtered | ✅ |
| 7–11 | Brand > Content → Disney Channel, Extended perspective, Impressions data set, one channel at a time, Table View | ✅ Posts: Facebook 19, Instagram 17, TikTok 17 |
| 12 | Facebook: exclude Reels on Brand > Content | n/a — 0 Reel rows among the 19 Facebook posts this week, nothing to exclude |
| 13–14 | Compare Impressions per post (join by permalink; Facebook rows have no permalink so they are joined by Date + Text) | ✅ FB 19/19 identical · IG 17/17 identical (top reel DeaUebTAVSW 1,680,701) · TikTok 17/17 identical (top video 7696569500287929613 275,600) |
| 15 | Repeat for Instagram and TikTok | ✅ (included above) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Content tab Impressions match Brand Sets Content Impressions (Private Data) | 53/53 posts identical across the three channels | ✅ PASS |

## Evidence
- Session result `ctx._bs32524` (per-channel rows and comparison; `facebook2` holds the Date+Text re-join after the first pass mistook the in-app brand link for a permalink).

## Known bugs checked
- None open on the case.

## Notes
- Facebook rows on both surfaces carry no post permalink; the join key is Date + first 60 chars of Text. The in-app `#explore/brand/content?brand_id=…` link in Brand Sets rows must be ignored when choosing the permalink.

## Bugs filed
None.

## Cleanup
None (read-only).
