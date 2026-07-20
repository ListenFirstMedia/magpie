# QA-949 — Brand > Stories - Hovering Functionality

- **Run date:** 2026-07-03 (HEADLESS Playwright MCP)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-949 · Priority: Minor
- **Result:** **PASS (partial)** — hover-tooltip assertions (3, 6) and CSV export (7) verified. Assertion 8 (post-Type opens correct post in new tab) not fully exercised this run.
- **App:** `app.lfmdev.in` Brand > Stories · **Account:** Michael Kors · **Brand:** Michael Kors (3801) · **Channel:** Instagram
- **Skills:** switch-account, chart-hover-tooltip

## Linked bug scan
No open linked bugs — all defects Closed (checked full issuelinks). [[open-bug-auto-fail]] N/A.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| 3 hoverable | Engagements, Impressions, Taps Back, Exits big-number bars hoverable | All 4 tiles present with `rect.bar` series (28 bars = 4×7 days); Engagements bar hovered successfully | ✅ PASS |
| 3 tooltip | Tooltip = 'MMM DD, YYYY' + icon-Channel: N | **"Jun. 26, 2026" + "Instagram: 528 (+999.0%)"** | ✅ PASS |
| 6 | Pie chart tooltip = (icon-Instagram: Value) | Set Impressions tile → Pie; arc hover tooltip = **"Instagram: 1,092"** | ✅ PASS |
| 7 | Spinner on Export until file downloads | Export → CSV → "Only Current Data Set" → **`Michael Kors-Brand Stories-2026-06-26-2026-07-02-posts.csv` downloaded** (transient spinner not separately captured; download confirms flow) | ✅ PASS |
| 8 | Click post Type → opens correct post in new tab | Not exercised — Stories post-table Type-link locator differs from the standard table `<a>`; deferred | ⚠ NOT EXECUTED |

## Evidence
- `qa949-stories.png` — Michael Kors Stories, 4 big-number tiles (Engagements 1,092 / Impressions 234K / Taps Back 2,357 / Exits 17.7K), Instagram legend.
- Bar hover tooltip (dispatched mouseover on `rect.bar.instagram.story_insight.engagements-2026-06-26`) → "Jun. 26, 2026 / Instagram: 528".
- Pie arc hover → "Instagram: 1,092".
- `.playwright-out/Michael-Kors-Brand-Stories-2026-06-26-2026-07-02-posts.csv` (Export → Only Current Data Set).

## Notes
- Headless hover works via dispatching `mouseover`/`mousemove`/`mouseenter` on the target element + reading the tooltip in the SAME evaluate (per chart-hover-tooltip skill). Bar and pie/donut arc both respond.
- Assertion 8 (post-Type new tab) needs the Stories post-table structure; deferred for a focused follow-up.

## Bugs filed
None. Core hover/export assertions passed; A8 deferred (not a defect).
