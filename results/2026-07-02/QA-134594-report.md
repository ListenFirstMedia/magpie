# QA-134594 — Brand > Video > Instagram > Public Data

- **Run date:** 2026-07-03 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134594 · Priority: Major
- **Result:** **PASS** — all assertions verified (5c is N/A: data present, no-data branch not triggered).
- **App:** `app.lfmdev.in` · **Account:** Hulu (account_id=336) · **Brand:** Hulu
- **Skills:** switch-account, chart-hover-tooltip (perspective entity swap), (brand-video-public-data — candidate)

## Linked bug scan
**No linked issues at all** (`issuelinks: []`) — [[open-bug-auto-fail]] N/A.

## Perspective/entity note
The **View: Public Data ⇄ Authorized Data** toggle (`#perspective` checkbox) is the "Public Data perspective" control. Toggling it swaps the brand entity + brand perspective in the URL: **Authorized = brand_id 5670 / perspective=extended**; **Public Data = brand_id 11003 / perspective=standard** (consistent with the known Insights 5670↔11003 entity swap). Under Public Data, LinkedIn drops from the channel set (4 channels: FB/Twitter/IG/TikTok).

## Steps executed
1. Brand nav → **Video**. ✅
2. Brand picker (`textarea "Search for a Brand"`) → typed "Hulu" → selected **Hulu** brand (brand_id 5670). ✅
3. Set **Public Data** perspective (toggle → brand 11003 / standard). ✅
4. Channel selector → deselected FB/Twitter/TikTok, left **Instagram** only → **Apply** (URL `channels=instagram`). ✅
5–7. Reviewed row-2 New Video Posts table, tiles, and private-metric exclusion. ✅
8. Toggled Public Data → **Authorized Data**. ✅

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| 3(a) | Instagram channel available in selector after Public Data | IG icon present & selectable in the channel selector (FB/X/IG/TikTok enabled, YouTube disabled) | ✅ PASS |
| 3(b) | New Video Posts, Public Page Video Views, Video Engagements show FB/Twitter/Instagram/TikTok + "- Compared To" legends | All 3 tiles show exactly Facebook, Twitter, Instagram, TikTok, - Compared To (no LinkedIn under Public) | ✅ PASS |
| 4(a) | Tiles present: New Video Posts (R1), Public Page Video Views, Video Engagements, New Video Posts (R2), Top 7 Videos (Daily), Best Performing Videos | All six present | ✅ PASS |
| 4(b) | With Instagram only, those 3 tiles show only Instagram + "- Compared To" legends | Legends became "Instagram - Compared To" only | ✅ PASS |
| 4(c) | Each tile displays Instagram data only | Charts show only purple (Instagram) series; values changed to IG-only (New Video Posts 30, Public Page Video Views 55.8M, Video Engagements 1.09M) | ✅ PASS |
| 5(a) | Tile tables contain Legend, Channel, Type, Text, Video Views columns | New Video Posts table headers = Legend, Channel, Type, Text, Video Views | ✅ PASS |
| 5(b) | Video Views column supports sorting | Header is `sortable-column`; clicking reordered rows to ascending (12,244 / 42,665 / 45,380 / 48,734) | ✅ PASS |
| 5(c) | If no new video posts → "There is no data available. Please select a different brand, brand set, or date range." | Data present (posts exist) — no-data branch not triggered | ⚪ N/A |
| 6(a) | Best Performing: only Instagram video content | Best Performing Videos shows IG-only thumbnails/metrics | ✅ PASS |
| 6(b) | Video Views sort option selected by default | Best Performing shows "Sort: Video Views" by default | ✅ PASS |
| 7 | "Page Video Views" does not display (Public Data) | Only "Public Page Video Views" present; plain "Page Video Views" absent | ✅ PASS |
| 8 | After switching to Authorized, "Public Page Video Views" does not display | Under Authorized Data the tile is "Page Video Views"; "Public Page Video Views" absent | ✅ PASS |

## Evidence
- `qa134594-publicdata.png` — Public Data, all channels: tile "**Public Page Video Views**", legends FB/Twitter/IG/TikTok/-Compared To (3a/3b/4a).
- `qa134594-ig-row1.png` — Instagram only: legends "Instagram - Compared To", purple IG-only series (4b/4c).
- `qa134594-ig-row2.png` — New Video Posts table (Legend/Channel/Type/Text/Video Views), Top 7 Videos (Daily), Best Performing Videos — all IG (4a/5a/6a).
- Sort test: Video Views header (`data-datapoint=lfm.content.public_video_views_v5`, class `sortable-column`) reordered rows ascending (5b).
- Authorized-view DOM check: `hasPublicPageVideoViews:false`, tile "Page Video Views" present (8).

## Bugs filed
None. All applicable assertions passed.
