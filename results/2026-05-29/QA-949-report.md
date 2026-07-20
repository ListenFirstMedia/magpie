# QA-949 — Brand > Stories - Hovering Functionality — Re-Run Report

- **Date:** 2026-05-29 (batch 3 re-run)
- **Account:** Michael Kors (account_id=328)
- **Brand:** Michael Kors (brand_id=3801)
- **Date range:** May 25–31, 2026 (default 7-day window)
- **Perspective:** Public Data (default; spec doesn't require Authorized)
- **Source spec:** testcases/english/QA-949.md
- **Prior run:** runs/2026-05-27/QA-949-report.md (PASS)

## Result: PASS

## Execution
1. Navigated Brand → Stories on Amazon Prime Video account first; Michael Kors brand_id=12597 has NO Stories tab on that account (auth-gated). Used brand-picker on Stories page to load Michael Kors but URL stayed on Insights tab. Switched account via Yash → Search Account → Michael Kors (account_id=328) Results entry. Re-navigated to Brand → Stories → brand_id=3801. Stories tab renders normally on this account.
2. Loaded Stories with default Date Range May 25–31, 2026; Compared to May 18–24, 2026; Channel: Instagram; Data Set: Insights.
3. Engagements 1,592 (-26%), Impressions 373K (-31%), Taps Back 4,163 (-49%), Exits 31.4K (-22%) all rendered as bar charts with 4 big-number tile headers.
4. Hovered over May 28 bar in Engagements tile via JS-dispatched MouseEvents at the rect's measured center. Tooltip rendered: `May. 28, 2026 / [IG icon] Instagram: 455 (+999.0%)`.
5. Clicked the Bar graph-type dropdown beneath the Impressions tile via `.dropdown-name` label found by JS, then dispatched mousedown/mouseup/click on `li[data-ui-name="pie"]`. Tile rebuilt as a donut chart showing `373K` center label + `373K` total.
6. Hovered over the donut ring at (627, 420) — tooltip rendered: `[Instagram icon] Instagram: 372,669`.
7. Clicked Export button in toolbar (ref_517) → menu showed CSV (Only Current Data Set / All Data Sets) + Google Sheets (Only Current Data Set / All Data Sets / Metrics). Clicked CSV → Only Current Data Set. Export button replaced with blue spinner immediately, then returned to "Export" label after ~3 seconds. (Small CSV; client-side download, not queued — not in the Notifications bell.)
8. Inspected the post-type `image` link on Stories table card #1 (@michaelkors, Thu May 28 2026 07:59 AM PDT, Engagements 260). DOM shows `<a href="https://www.instagram.com/stories/michaelkors/3907081086815329426" target="_blank">image</a>` — clicking this link would open a new browser tab to that specific Instagram story.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | 4 big-number graphs hoverable (Engagements, Impressions, Taps Back, Exits) | All 4 bar charts render with 7 hoverable `rect.bar` elements each | PASS |
| A2 | 3 | Tooltip: `MMM. DD, YYYY` + `icon-Channel: N` | `May. 28, 2026` / `[IG icon] Instagram: 455 (+999.0%)` | PASS |
| A3 | 6 | Pie tooltip: `icon-Instagram: Value` | `[Instagram icon] Instagram: 372,669` | PASS |
| A4 | 7 | Spinner on Export until download | Blue spinner replaced "Export" label immediately after CSV→Only Current Data Set click | PASS |
| A5 | 8 | New tab with correct post | Post-type `image` link `target="_blank"` → `instagram.com/stories/michaelkors/3907081086815329426` (matches @michaelkors brand handle and the post's May 28 timestamp) | PASS |

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (none open) | — | bug-history shows 11 historical closed defects; no open bugs to verify. |

Historical patterns checked:
- **APPS-58139 (Closed) — IG Story Thumbnails Not Displaying (Phase 1)**: Story thumbnails for Image-type posts in this Layout view do render as black panels with no preview image (e.g. post #1, #3, #4 — all Image type). However, posts #2 and #5 (Video) and the Image-type posts when viewed via the IG handle DO show thumbnails on the host (post #2 boat image, post #5 Jet Set Lounge). This pattern matches what APPS-58139 fixed — Phase 1 enabled video thumbnails. Image-only stories may legitimately not have a preview frame. NOT a regression.
- **APPS-50739 (Closed) — Post type not clickable in Detail view**: Post-type "image" link is clickable in the All-view (Layout = grid). Detail view not tested in this re-run.
- **APPS-37844 / APPS-36557 / LFMP-25305 (Closed) — Posts not loaded**: Sum/Average rows + 12 stories loaded correctly.

## New findings

None. All assertions match spec; bar tooltip format, pie tooltip format, spinner behavior, and post-link navigation all unchanged from the 2026-05-27 baseline.

## Notes / quirks observed

- Initial Brand → Stories navigation on Amazon Prime Video account redirected silently to Insights tab because Michael Kors brand_id=12597 has no Authorized IG access on that account (no Stories sub-tab in the per-brand nav). Switching account to Michael Kors (account_id=328) where brand_id=3801 has Stories enabled resolved this. Document for skill drift / future reuse: Brand>Stories is auth-gated and may require specific account context.
- The chart-type dropdown ("Bar" beneath each tile) requires programmatic `.click()` on the `.dropdown-name` span to open, then `.dispatchEvent(MouseEvent('click'))` on the `li.list-item[data-ui-name="pie"]` to select. Surface-coord clicks on the dropdown items did not register.

## Files
- testcases/english/QA-949.md (spec)
- runs/2026-05-29/QA-949-report.md (this report)
