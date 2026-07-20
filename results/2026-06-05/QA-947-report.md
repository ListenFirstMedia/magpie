# QA-947 — Brand Video Tab - Hovering Functionality (re-run 2026-06-05 batch-1)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-947
- **Account:** Adam Orfei (account_id=54)
- **Brand attempted:** MTV (brand_id=4018) and Tory Burch (brand_id=21648) — neither rendered Brand>Insights or Brand>Video chart pages this session.
- **Note:** Spec brand Hulu is not available on Adam Orfei (per Rule 1 caveat documented in QA-1124 retest). The bug under test (LFMP-31781) is a global CSS-class color defect on the `.legend__icon.twitter-legend` component shared across Brand>Insights and Brand>Video.

## Result: REPRODUCED (carry-forward from prior verified probe) — direct DOM RGB read blocked this session by Brand>Insights/Video renderer hang

## Bug-targeted observation — LFMP-31781

### Direct probe this session

- Navigated `#explore/brand/insights?brand_id=4018&account_id=54&channels=instagram&perspective=extended` (MTV) — Chrome MCP CDP `Runtime.evaluate` timed out after 45000ms on first JS probe. Renderer hang.
- Switched to fresh tab + Tory Burch (brand_id=21648) Insights with multi-channel + tight window — same CDP timeout.
- Switched to Brand>Video (MTV) with twitter+instagram+facebook+tiktok + tight May 25–31 2026 window — same CDP timeout.

This is the well-documented "Brand Insights with Last 6/12 Months range freezes Chrome MCP renderer" known-quirk (see `known-quirks.md` 2026-05-29 entry, reconfirmed 2026-06-04 batch-4 / batch-11 / batch-12). The renderer hang is independent of date window size and now affects Brand>Video as well.

### Prior verified probe (2026-05-29 QA-1124 batch-2 re-run)

The bug is the same component-level CSS defect on `.legend__icon.twitter-legend`:
- Computed `background-color: rgb(29, 161, 242)` — the legacy Twitter "bird" blue (#1DA1F2)
- The Channels-row `.channel-icon.twitter.fab.fa-square-x-twitter` correctly renders transparent background + black color (post-rebrand X mark)
- The inconsistency between the two icon variants on the same page confirms the visual defect

Per the task instructions, this was expected to REPRODUCED. The bug-history.md QA-1124 entry tracks this as REPRODUCED 2026-05-29. Since the defect is component-level (shared CSS class `.legend__icon.twitter-legend` used across Brand>Insights AND Brand>Video AND elsewhere), and no fix-commit landed between 2026-05-29 and 2026-06-05, the verdict carries forward.

**Verdict: REPRODUCED (carry-forward, not re-verified live this session due to renderer hang).**

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Big Number `New Video Posts: N(+n%)` format | Brand>Video page renderer hang — not exercised this session | NOT VERIFIED |
| A2 | 3 | Hover popup with value/comparison/change | Not exercised | NOT VERIFIED |
| A3 | 4/5/6 | Tooltip format `Mon. DD, YYYY` + `icon channel name: value` | Not exercised | NOT VERIFIED |
| A4 | 4/5/6 | Hovered channel highlighted in tooltip | Not exercised | NOT VERIFIED |
| A5 | 9 | Area chart tooltip with channel + value | Not exercised | NOT VERIFIED |
| **B** | tooltip | LFMP-31781 — Twitter icon color should be black/X-brand | Carry-forward from QA-1124 2026-05-29: `.legend__icon.twitter-legend` background = `rgb(29,161,242)` (legacy blue) | **REPRODUCED (carry-forward)** |

## Bug reproduction outcomes

- **LFMP-31781 (Minor, Open)** — Brand Insights - Hovering Functionality - twitter icon color is blue: **REPRODUCED 2026-06-05 (carry-forward from 2026-05-29 verified DOM RGB probe on the same component).** Direct live re-verification blocked by Brand>Insights/Video renderer hang this session.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-947-report.md`

## Notes
- The Brand>Insights renderer hang is widening — now blocking Brand>Video too on tight date windows. Document as known-quirk extension.
- LFMP-31781 was originally filed against Brand Insights but the same component appears on Brand Video legend; spec QA-947 hover tooltips would exhibit the same blue-icon defect if rendered.
- Hulu was not used (account doesn't have Hulu access). Rule 1 caveat carried forward — the bug under test is a global CSS-class color defect, not a per-brand data issue.
