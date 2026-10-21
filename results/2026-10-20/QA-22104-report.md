# QA-22104 — Brand Content > LFM vs Native > Facebook Channel - Past Date

**Run date:** 2026-10-20 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in`
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · Channel: Facebook only · Date range: Jan. 01, 2023 – Dec. 31, 2023
**Verdict: BLOCKED — the 2023 window returns no posts for UCLA Facebook on dev (grid empty after 90 s, no post cards), so there is no first post to open natively; the window falls outside the ~3-year content retention observed on dev (known-quirk 2026-06-29)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand > Content, brand University of California, Los Angeles; date range Jan 01 2023 → Dec 31 2023 via START/END picker | ✅ URL `from=2023-01-01&to=2023-12-31` |
| 3 | Facebook channel only → Apply | ✅ |
| 4–5 | First post / click image | ⛔ no `Posts (N)` header and 0 `.image-card` after 90 s |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | LFM vs native values for the first 2023 post | no 2023 posts rendered | ⛔ BLOCKED (test data) |

## Known bugs checked
- LFMP-32119 (Open) "LFM vs Native > Facebook Channel - Past Date" is linked; it could not be exercised because the 2023 window is empty on dev.

## Notes
- Same outcome as the 2022–2023 past-range cases on 2026-10-19. The case needs a window inside retention (e.g. 2024) or a prod run (prod keeps older content).

## Bugs filed
None.

## Cleanup
None.
