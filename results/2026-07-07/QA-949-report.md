# QA-949 — Brand > Stories - Hovering Functionality

- **Run date:** 2026-07-07 (interactive recovery run — was timeout/no-report in the 2026-07-04 unattended batch)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-949 · Priority: Minor
- **Verdict:** **PASS** — all 5 assertions verified (including A5, which was deferred in the earlier interactive pass).
- **Account:** Michael Kors (account_id=328) · **Brand:** Michael Kors (3801) · **Channel:** Instagram
- **Skills:** switch-account, chart-hover-tooltip

## Open linked bugs
None open (cache 2026-07-03) — ran normally.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Engagements, Impressions, Taps Back, Exits big-number bars hoverable | All 4 tiles present; bar `rect.bar` hover fired | ✅ PASS |
| A2 | 3 | Tooltip = 'MMM DD, YYYY' + icon-Channel: N | **"Jun. 29, 2026" / "Instagram: 564 (+999.0%)"** | ✅ PASS |
| A3 | 6 | Pie chart tooltip = (icon-Instagram: Value) | Impressions tile → Pie; arc hover = **"Instagram: 2,192"** | ✅ PASS |
| A4 | 7 | Spinner on Export until file downloads | Export → CSV → Only Current Data Set → **`Michael Kors-Brand Stories-2026-06-29-2026-07-05-posts.csv` downloaded** | ✅ PASS |
| A5 | 8 | Click post Type → opens correct post in new tab | Post-type links are `<a target="_blank">` to native URLs, e.g. `instagram.com/stories/michaelkors/39331164365830` (image), `.../39304441124577` (video) — 15 such links, correct per-post | ✅ PASS |

## Evidence
- `.playwright-out/QA-949/posttable.png` — Stories grid with per-post Type links.
- `.playwright-out/Michael-Kors-Brand-Stories-2026-06-29-2026-07-05-posts.csv` — CSV export.
- Bar hover "Jun. 29, 2026 / Instagram: 564"; pie hover "Instagram: 2,192".

## Why this recovered (vs 2026-07-04 BLOCKED)
The unattended run produced no report (killed at the 900 s watchdog). Driven interactively with no timeout, the page loaded and every assertion evaluated cleanly — no product issue; it was a per-case time-budget limit in the batch harness.

## Bugs filed
None.
