# QA-575 — Instagram In Window Private Data QA

**Run date:** 2026-06-04 (QA-4325 batch-3 re-run)
**Account:** Hulu (account_id=336)
**Brand:** Hulu (brand_id=5670)
**Environment:** dev (`app.lfmdev.in`)
**Result:** **PARTIAL** — dev-side data collection complete; stage parity NOT VERIFIED (magpie operates on dev only)

## Spec
See `/Users/yashsharma/git/magpie/testcases/english/QA-575.md` — IG analogue of QA-569 / QA-567 pattern. Modeled from spec wording since Xray steps were not returned via Atlassian MCP fetch.

## Configuration achieved (Rules 1 + 2 + 6)
- Brand: Hulu via Add Brand By Name not applicable (direct URL load with `brand_id=5670` worked — Hulu account default).
- Perspective: Authorized — `perspective=extended` in URL + visual toggle handle on RIGHT side of `View: Public Data | Authorized Data` (screenshot-verified).
- Channels: Instagram only — confirmed via DOM `.channel-ghost.instagram.enabled`.
- Date range: May 25, 2026 – May 27, 2026 (default May 25–31 narrowed by -2 days end-date per spec step 6).
- Mode: In Window — Date Range modal `Select Mode: In Window` radio clicked + Ok → URL `stats_attribution_window=in_window` + Mode label "In Window".
- Data Set: Impressions, then Video Views (per spec steps 8 and 11).

## Steps executed
1. Navigated to Brand>Content with `brand_id=5670&account_id=336&channels=instagram&perspective=extended&stats_attribution_window=lifetime&table_data_set=impressions&layout=table`.
2. Confirmed Hulu, IG-only, Authorized via DOM probe + toggle screenshot zoom.
3. Posts (32) loaded under Lifetime mode (sanity check).
4. Opened Date Range modal (clicked `May. 25, 2026 - May. 31, 2026` chip).
5. Clicked `In Window` radio in modal.
6. Clicked end-date `27` in End Date calendar (back -2 days).
7. Clicked `Ok` → range = May 25–27; mode = In Window.
8. Initial "This table failed to load. Please try again." appeared; clicked **Reload**.
9. Posts (10) populated with In Window Impressions data set.
10. Switched Data Set dropdown to **Video Views** → Posts (10) populated with Video Views aggregates.

## Assertions table

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| Mode toggle | step 7 | Mode label flips Lifetime → In Window | Mode label = "In Window"; URL `stats_attribution_window=in_window` applied | PASS |
| Impressions data set load | step 8 | Posts populate with Impressions aggregates | Posts (10), Sum Engagements 172,283; Sum Impressions 5,532,668; Sum Organic Imp 5,524,462; Sum Paid Imp 8,206; Sum Reach N/A; Sum Organic Reach N/A; Sum Paid Reach N/A | PASS |
| Video Views data set load | step 11 | Posts populate with Video Views aggregates | Posts (10), Sum Video Views 5,530,219; Sum Organic Views 5,524,462; Sum Paid Views 5,757; Sum Unclassified Views 0; Sum Watch Time (Minutes) 1,324,151.18 | PASS |
| A10 (cross-env Impressions parity) | step 10 | Dev posts in range match stage posts | Stage NOT VERIFIED — magpie operates on dev only | NOT VERIFIED |
| A13 (cross-env Video Views parity) | step 13 | Number of posts matches between dev and stage | Stage NOT VERIFIED — magpie operates on dev only | NOT VERIFIED |

## Aggregate detail — In Window May 25–27 2026 Authorized IG Hulu

### Impressions data set
- Sum: Engagements 172,283 | ER N/A | Impressions 5,532,668 | Organic Imp 5,524,462 | Paid Imp 8,206 | Reach 8,206 | Organic Reach N/A | Paid Reach N/A | EUR N/A
- Avg: Engagements 17,228 | ER 3.11% | Impressions 553,267 | Organic Imp 552,446 | Paid Imp 821 | Reach 371,369 | Organic Reach 370,548 | Paid Reach 820 | EUR 4.64%

### Video Views data set
- Sum: Engagements 172,283 | Video Response Rate N/A | Video Views 5,530,219 | Organic Views 5,524,462 | Paid Views 5,757 | Unclassified Views 0 | Viewers — | Video Duration — | Watch Time (Minutes) 1,324,151.18
- Avg: Engagements 17,228 | Video Response Rate 3.12% | Video Views 553,022 | Organic Views 552,446 | Paid Views 576 | Unclassified 0 | Watch Time (Minutes) 132,415.12

Posts (10) all visible with Hulu/IG/Reel publish type.

## Bugs filed
_None._ Stage-comparison remains a manual cross-env test for LFIQA — same dev-only limitation as QA-567/QA-569.

## New findings (non-blocking)
- "This table failed to load. Please try again." render-lifecycle hiccup on first Mode flip — Reload resolves it. Same as QA-569; reconfirms render-lifecycle quirk not a data defect.
- URL programmatically: removing `compare_from` / `compare_to` is not necessary — backend applies In Window window from `from`/`to` cleanly.

## Skills reused
- `view-perspective-toggle` (URL `perspective=extended` + visual toggle confirm)
- `brand-content-data-set-selector` (Impressions → Video Views dropdown switch)
