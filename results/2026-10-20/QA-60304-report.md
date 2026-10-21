# QA-60304 — Brand Sets Content > Twitter Video Views > Public and Authorized Data QA

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in`, lfiqa user switched to **Amazon Prime Video**
**Account:** Amazon Prime Video (account_id=342) · **Brand set:** Amazon Prime Video-- Episodic Network Roll-Up (brand_set_id=8223) · Channel: Twitter only · Date range: default week Oct. 12, 2026 – Oct. 18, 2026 · Lifetime
**Verdict: PASS — 85/85 tweets on the ranked page show the same Video Views under Rank "Video Views (Public Data)" and Rank "Video Views (Authorized Data)"; 0 differences, 0 posts missing on either side**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand Sets → Content → brand set "Amazon Prime Video-- Episodic Network Roll-Up" | ✅ brand_set_id 8223, Posts (696) all channels |
| 3 | Rank dropdown → **Video Views (Public Data)** (first "Video Views" entry) | ✅ URL `rank_by_metric=lfm.content.public_video_views_v5` |
| 4 | Twitter only → Apply | ✅ Posts (84) → Table View 85 Twitter rows (top page) |
| 5 | Note Video Views per post | ✅ e.g. status/2111276061082218561 508,759 · status/2111230777455206759 360,324 · status/2110400293070348640 315,437 |
| 6 | Rank dropdown → **Video Views (Authorized Data)** (last "Video Views" entry) | ✅ URL `rank_by_metric=lfm.content.video_views`; Twitter re-applied (Rank change resets channels) |
| 7 | Compare per post (join by tweet permalink) | ✅ 85 matched, 0 mismatches |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7 | Public and Authorized Video Views identical for all posts | 85/85 identical (same top-3 values on both rankings) | ✅ PASS |

## Evidence
- Session result `ctx._bs60304` (both row sets, 85 rows each).

## Known bugs checked
- LFMP-32125 (Open) "Twitter one post Video Views not displayed": no tweet on the ranked page showed an en-dash on one side only (public and authorized values agree row by row), so the bug did not interfere with this comparison.

## Notes
- The Rank dropdown lists "Video Views" twice (public first, authorized last); the skill picks by position. Each Rank change re-enables all channels, so Twitter-only is re-applied before every scrape.

## Bugs filed
None.

## Cleanup
None (read-only).
