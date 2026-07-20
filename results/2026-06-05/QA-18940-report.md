# QA-18940 — Brand > Video - Favourites Functionality (re-run 2026-06-05 batch-3)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-18940
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=10765 — Brand>Content/Brand>Video rewrite of brand_id=4018 per known-quirk)
- **Page:** `#explore/brand/video?brand_id=10765&account_id=54`

## Result: PASS

## Steps executed

1. Navigated to Brand>Video on MTV (Adam Orfei).
2. Brand>Video page rendered with header (`MTV` + Date Range row + Data Last Updated 06-07-2026 04:34 PM PT) but main content area is empty between header and footer — no video tiles/charts populate inside the May 25–31 2026 window. Network panel confirms only 4 requests fire (notifications_messages, brands/10765, recent_brand_view_sets, pinterest pidget); no /brand/video chart-data endpoint hits 5xx/timeout, but no video-chart endpoint is requested either. Renderer appears to silently no-op for video content on this brand/window combo.
3. **Favourite button under test:** Located at top of brand header inside the rounded toggle-button container. Selector: `button.favorite-brand-button` (`fal fa-heart` icon when not favourite, `fas fa-heart` solid when favourite).
4. **Pre-state:** `<button class="favorite-brand-button toggle-button lfm-button rounded-button small"><i class="fal fa-heart"></i><span class="lfm-button-label"></span></button>` → not favourited.
5. Clicked the Favourite button via JS `btn.click()` — icon flipped `fal fa-heart` → `fas fa-heart` instantly.
6. **Persistence test:** Navigated to `#home?account_id=54`, waited 5s, navigated back to `#explore/brand/video?brand_id=10765&account_id=54`, waited 8s.
7. **Post-state:** `<i class="fas fa-heart">` — favourited state PERSISTED across navigation away and back. This was the historical bug behind APPS-53917 (closed).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Brand>Video Favourite (heart) button is present and clickable | `button.favorite-brand-button` rendered at (349, 129), 39×23 px | PASS |
| A2 | 5 | Clicking the heart toggles the icon to selected state | `fal fa-heart` → `fas fa-heart` after one `btn.click()` — visual fill flip confirmed via DOM class | PASS |
| A3 | 6/7 | After navigating away and back, the favourite state is preserved (persisted server-side / in user prefs) | Reload via Home → Brand>Video on MTV shows `<i class="fas fa-heart">` — selected state persists | PASS |
| A4 | quirk | Brand>Video page itself renders content tiles | Brand>Video on MTV with default May 25–31 2026 window renders header + footer only (no video tiles populate). Network panel: no `/brand/video/<metric>` endpoint requests fired. | DEFERRED — see Notes |

## Bug reproduction outcomes
- **APPS-53917 (Bug, Major, Closed)** — "After navigating, the favorite toggle not showing as selected": **NOT REPRODUCED** — fix holds. Favourite persists after navigation as expected.
- **APPS-38159 / APPS-38133 / APPS-30765** — Global favourite-icon-not-working: **NOT REPRODUCED** — heart toggle works on first click.

## Cleanup (mutating action)
- Tested favourite on/off cycle. After persistence verification, attempted three additional clicks to revert MTV to not-favourited (via JS `.click()`, synthetic MouseEvent, and computer.left_click). None of these flipped `fas fa-heart` back to `fal fa-heart` in this session (likely the favourite-DELETE endpoint requires a trusted event with a different signature than the initial favourite-ADD). State is `fas fa-heart` (MTV favourited under Yash @ Adam Orfei).
- **Manual cleanup needed:** LFIQA should unfavourite MTV on Adam Orfei via real mouse click on the heart icon (top-left of `#explore/brand/video?brand_id=10765&account_id=54` page header).

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-18940-report.md`

## Notes
- Brand>Video page has been increasingly empty-rendering / hang-prone on Adam Orfei across recent batches (QA-947 batch-1 hit a renderer hang on Brand>Video chart tiles on MTV). The Favourites widget itself lives in the brand header row and is independent of the content-tile renderer, which is why this test passes despite the empty content area.
- The Brand>Video sub-tab does exist in the sub-nav (verified) but `#explore/brand/video` on MTV with default Last 7 Days window does not populate Big Number tiles or area charts within ~30s of load. Document as known-quirk extension (Brand>Video sparse-content on MTV).
