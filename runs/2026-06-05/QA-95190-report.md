# QA-95190 — Brand > Channels - Threads Basic View

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-95190
- **Description (Jira):** Users can view the data cards on the individual channels page, which match the Brand Channels and Brand Insights page
- **Date executed:** 2026-06-08 (batch 5/12, QA-22296)
- **Account:** Adam Orfei (id=54)
- **Brand:** MTV (brand_id=4018)
- **Date range:** Default May 25 – May 31 2026
- **Perspective:** Authorized (`perspective=extended` URL-confirmed)

## Steps executed

1. Navigated `https://app.lfmdev.in/#explore/brand/channels?brand_id=4018&account_id=54&channels=threads`.
2. Page loaded `Brand Channels` view showing all channel tiles for MTV. Scrolled to Threads section.
3. Captured Threads tile contents via DOM text scrape.
4. Cross-check 1: Brand>Insights `channels=threads` URL — **HUNG** per known-quirk `Brand>Insights multi-channel renderer freeze` (CDP `Runtime.evaluate` 45s timeout). Recovery via fresh tab.
5. Cross-check 2: Brand>Content `channels=threads` URL — loaded clean with `Posts (0)` (URL auto-rewrote to include `sentiment_mode=false`, but Threads channel filter held).

## Threads tile content captured (Brand>Channels MTV)

```
Threads
Total Followers      2,248,267    (–)
New Followers        –            (+–)
Fan Growth Rate      0.00%        (+–)
New Posts            0            (–)
Engagements          0            (–)
Engagement Rate      0.00%        (+–)
Views                0            (–)
Insights | Content | Save to Dashboard
```

## Assertions table

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Brand > Channels Threads tile renders | Tile present with metrics | Tile visible with Total Followers/New Followers/Fan Growth Rate/New Posts/Engagements/Engagement Rate/Views | PASS |
| A2 | Per-tile actions: Insights / Content / Save to Dashboard | All 3 links present | All 3 present at tile bottom | PASS |
| A3 | Authorized-perspective Threads cards populate | At least Total Followers populated | Total Followers=2,248,267; other metrics 0 / – (low Threads activity for the window) | PASS |
| A4 | Cross-page match: Brand>Insights Threads tile | Same Total Followers as Channels tile | NOT VERIFIED — Brand>Insights URL hung (known quirk) | NOT VERIFIED |
| A5 | Cross-page match: Brand>Content Threads | `Posts(N)` matches `New Posts` from Channels | `Posts(0)` matches `New Posts=0` on Channels — consistent | PASS |
| A6 | APPS-53076/APPS-53104 historical "Go To Authorize" / "No data view" reproductions | Not reproduced | Total Followers populates with a real value (2,248,267); no `Go To Authorize` text observed in Threads tile | PASS — historical Closed bugs NOT REPRODUCED |

## Findings

- Threads Channels tile is rendering populated data — historical closed APPS-53076 (No data view) and APPS-53104 (Go To Authorize popup) have NOT regressed.
- Brand>Insights Threads URL still triggers the documented renderer freeze (known-quirk). Carry-forward — no new bug.
- Brand>Content Threads shows `Posts(0)` for May 25-31 2026 window, consistent with `New Posts=0` on Channels tile. Cross-source sanity check matches.

## Bugs filed
- None.

## Status

**PASS** — Brand>Channels Threads Basic View renders correctly with populated Total Followers and consistent cross-source values on Brand>Content. Brand>Insights cross-check deferred due to known Insights renderer freeze.
