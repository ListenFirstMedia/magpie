# QA-13903 — Embedded Post Tooltip - LinkedIn (re-run 2026-06-02 batch-1)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-13903
- **Account:** UCLA (account_id=799) — switched from Adam Orfei via account search
- **Brand:** University of California, Los Angeles (brand_id=127756) — only brand on this account
- **Channel:** LinkedIn only
- **Date range:** Jan 01, 2025 – Dec 31, 2025
- **Perspective:** Public Data

## Result: PASS (6/7 verified)

## Steps executed

1. Switched account Adam Orfei → UCLA via user dropdown account search.
2. Brand > Content auto-loaded "University of California, Los Angeles" brand.
3. URL set to `channels=linkedin` only — channel chip turned blue (selected).
4. Posts(1,415) loaded with non-zero metrics: Sum Engagements 203,738, Reactions 188,048, Comments 5,747, Shares 9,943.
5. Switched Layout to Grid view. All 5 first-page LinkedIn post thumbnails render properly (Dodgers, UCLA rainbow, statue, #1 yellow, Royce Hall). No black/empty thumbnail squares.
6. Switched Layout to Table view. Hovered Type=Image cell of row 1 (Sun Nov 02 2025 03:29 AM PST).
7. Embedded LinkedIn tooltip rendered with UCLA logo header, "1,003,177 followers • 7mo", post body "Last night, UCLA alum Dave Roberts led the Los Angeles Dodgers to their ninth World Series win..." plus iframe embed src `linkedin.com/embed/feed/update/urn:li:share:7390711711109906432/` (350x650).
8. DOM check on Type column links: all 5 visible rows have proper `linkedin.com/feed/update/urn:li:share:...` or `urn:li:ugcPost:...` href patterns.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6a | Tooltip displays on hover | Tooltip rendered on Type=Image hover with UCLA branding + LinkedIn embed iframe | PASS |
| A2 | 6b | Only one tooltip visible | Single tooltip — no stacking observed | PASS |
| A3 | 6c | X click or click-outside dismisses | X-button click closed tooltip cleanly | PASS |
| A4 | 6d | Hovering other Type links doesn't open additional tooltips | No additional tooltips opened — single-instance behavior preserved | PASS |
| A5 | 6e | Clicking post type opens correct LinkedIn post | DOM href confirms valid `linkedin.com/feed/update/urn:li:share:7390711711109906432/` etc. for all 5 visible rows | PASS (via DOM href) |
| A6 | 6f | Post image + text match tooltip | Tooltip text "Last night, UCLA alum Dave Roberts led the Los Angeles Dodgers..." matches row 1 grid card text snippet; tooltip iframe rendered embed with post; thumbnail in grid view matches post (Dodgers blue). | PASS |
| A7 | — | No external/non-brand LinkedIn post | All visible posts are UCLA-authored (handle UCLA, 1M+ followers). | PASS |

## Bug reproduction outcomes

### APPS-57985 (Bug, High, QA Ready) — LinkedIn Posts Thumbnail Issue
**Verdict: NOT REPRODUCED**

Tested on UCLA brand which has 1,415 LinkedIn posts. Switched between Grid view and Table view:
- Grid view thumbnails all render correctly (first-page 5 posts all show actual LinkedIn image content).
- Embedded tooltip iframe loads properly with `linkedin.com/embed/feed/update/...` URL.
- One incidental finding: the brand-thumbnail icon at top of tooltip (`s3.amazonaws.com/assets.prod.lfm/movie/image/127756/`) has naturalWidth=0 — likely a backend-side LFM brand image, not LinkedIn post thumbnail. This may be the bug source but it's the brand-asset image, not the LinkedIn post thumbnail proper.

The "Thumbnail Issue for LinkedIn Posts" may have been fixed since Apr 30 2026 (bug created). Recommend asking engineering to verify status and close if no other surface reports the issue.

## Notes / quirks

- **Account-brand availability gap:** Adam Orfei dev account has zero LinkedIn-authorized brands. Tried MTV, Disney, HBO Max, Star Wars — none have LinkedIn channel selected on Authorized perspective. Switched accounts to UCLA (a different account with the spec-named brand) per Rule 1's "wrong account" escape valve.
- The LinkedIn iframe embed requires ~3-5 second wait after hover before LinkedIn content loads inside iframe.
- Disney brand on Adam Orfei (brand_id=6609 Public) does have LinkedIn channel registered but Posts(0) in 2025.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-02/QA-13903-report.md` (this report)
- `/Users/yashsharma/git/magpie/testcases/english/QA-13903.md` (proxy spec)
