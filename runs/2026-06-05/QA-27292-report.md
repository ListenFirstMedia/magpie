# QA-27292 — Brand > Content - Download CSV Template in Update Tag Modal (re-run 2026-06-05 batch-3)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-27292
- **Description (verbatim):** "This test case ensures Download CSV Template in Update Tag Modal"
- **Priority:** Minor
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018; URL rewrites to 10765 on Lifetime mode per known-quirk)
- **Page:** `#explore/brand/content?brand_id=4018&account_id=54&...&layout=table` (Brand>Content with default 6-channel)

## Result: PASS — CSV Template downloads end-to-end with valid structure

## Steps executed

1. Navigated to Brand>Content on MTV (default 6-channel + Lifetime + Public). Posts table renders normally — no Sentiment-mode lock this session.
2. Toolbar: located the `Tag` dropdown button (`button.tag-dropdown.with-dropdown`, `data-ui-name="tags"` at coords approx (1300, 266)).
3. Clicked Tag dropdown chevron → dropdown options enumerated: **Bulk Tag** (default-selected), **Upload Tags**, **Manage Tags**.
4. Clicked `Upload Tags` option (`lfm-dropdown-option` matching text `Upload Tags`).
5. Update Tag Modal (a.k.a. Upload Tags Modal) opened.
6. Inside modal, located the `Download CSV Template` link: `<a href="https://assets.listenfirstmedia.com/app/documents/LF%20Upload%20Tags%20Sample%20-%20Sheet1.csv">Download CSV Template</a>`.
7. Clicked the link → browser downloaded the CSV from the assets CDN.
8. Waited 10s for download to settle.

## On-disk verification

- **File:** `/Users/yashsharma/Downloads/LF Upload Tags Sample - Sheet1.csv`
- **Size:** 696 bytes
- **Created:** Mon Jun  8 10:13 2026 (matches click time)
- **Column headers:** `Post URL,Post Tag` (Row 1)
- **Sample rows (Row 2 onward):**
  - `https://www.facebook.com/ListenFirstMedia/posts/pfbid02TV2YB7QvhvZ7ukoRD2ktJqYP4AksxurrFZXj1vbanizrBVSFEMF42ugA5PkYENm8l,performance`
  - `https://twitter.com/listenfirst/status/1545082203956301824,holiday_performance`
  - `https://twitter.com/listenfirst/status/1545082203956301824,performance`
  - `https://twitter.com/listenfirst/status/1545082203956301824,holiday`
  - `https://www.instagram.com/p/CaIlxPzrTw5/,superbowl`
  - `https://www.youtube.com/watch?v=zb1f2H_FcbM,social-media-analytics`
  - `https://www.tiktok.com/@therock/video/7118885749507902762,workout`
  - `https://www.linkedin.com/posts/...,social_analytics`

Sample rows cover **6 channels** (FB, Twitter, IG, YouTube, TikTok, LinkedIn) and demonstrate the multi-tag-per-URL pattern (Twitter URL with 3 separate rows for 3 tags).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2-3 | Brand>Content Tag dropdown exposes Upload Tags option | Tag dropdown contains Bulk Tag / Upload Tags / Manage Tags | PASS |
| A2 | 4-5 | Clicking Upload Tags opens Update Tag Modal | Modal opens with Download CSV Template link present | PASS |
| A3 | 6-7 | Download CSV Template link triggers a CSV download | `LF Upload Tags Sample - Sheet1.csv` 696 bytes saved on disk from assets CDN | PASS |
| A4 | 8 | CSV has correct column structure (Post URL, Post Tag) and channel coverage | 2 cols: `Post URL,Post Tag` + 8 sample rows across 6 channels | PASS |

## Bug reproduction outcomes
- **APPS-51167 (Test Failure, Major, Closed)** — "The page is not loading on the Brand content tab": **NOT REPRODUCED** — page loads cleanly.
- No open LFMP bugs for QA-27292.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-27292-report.md`

## Notes
- The Tag dropdown is dual-button: the primary `Tag` text triggers the default action (`Bulk Tag` since that's `selected`), while the secondary chevron opens the option list. Use the `[data-ui-name="tags"]` selector + JS click to open the dropdown reliably.
- CSV template is hosted on the static assets CDN (`assets.listenfirstmedia.com/app/documents/`), not a per-tenant or per-brand resource. Same URL would serve all users/accounts.
- Spec wording "Update Tag Modal" matches the in-product flow opened from `Upload Tags` (the user-facing modal title is the bulk-tag-upload form, which the spec author labelled "Update Tag Modal").
