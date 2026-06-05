# QA-3630 — Reporting > Content Performance Report - BPC filmstrip - Authorized

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-3630
- **Run date:** 2026-05-27
- **Account:** Michael Kors (account_id=328)
- **Brand:** Michael Kors (brand_id=3801, Authorized perspective)
- **Result:** ⏸ **BLOCKED on UI quirks — CPR builder's channel checkboxes, Visual Top Posts numeric input, and Least Engaging Content checkbox all hit the React-state-revert quirk documented in `known-quirks.md` (`controlled-check-box` ignores synthetic clicks). Configuration could not be completed to spec; report not run.**

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Switched account → Michael Kors via Search Account Results | ✓ |
| 1-2 | Reporting → Content Performance (`/#/content_performance`) | ✓ |
| 3 | Added brand `Michael Kors` (exact-match from Results, Rule 1). First attempt added `Michael Kors - CA` because the typeahead's first result row was misclicked; deleted and re-added the correct `Michael Kors`. View toggle clicked to Authorized (Rule 2 satisfied — pill text confirms current = Authorized) | ✓ |
| 4 | Date Range → Make a Selection → `Last 30 Days` (Apr 27 – May 26, 2026) | ✓ |
| 5 | Select Facebook, Twitter, Instagram, YouTube channels only (uncheck TikTok, LinkedIn, Threads) | ⚠ INCOMPLETE — `controlled-check-box` widget reverts state after each click; could not reach the exact (FB ✓, X ✓, IG ✓, YT ✓, TikTok ☐, LinkedIn ☐, Threads ☐) configuration |
| 6 | Most Engaging → Visual Top Posts = 5 | ⚠ Input shows 0 after blur — React reverts the value |
| 7 | Additional Top Post Table Rows = 5 | ⚠ Same React revert |
| 8 | Least Engaging Content checkbox + Visual Bottom posts = 5 | ⚠ Same React revert |
| 9 | Click Run Report | ⏸ Not clicked — configuration did not match spec |

## Why this hit the React-state-revert quirk

The CPR builder uses the same `controlled-check-box` widget pattern that we've previously documented (see `known-quirks.md`: "`controlled-check-box` ignores synthetic `.click()`; needs focus+Space or real coord click"). For this specific page:
- Channel checkboxes: same widget — synthetic clicks don't stick
- Visual Top Posts / Additional Top Post Table Rows: numeric inputs that take screenshot-coord clicks but the value doesn't commit when blurred via React's controlled-input pattern
- Least Engaging Content checkbox: same controlled-check-box widget

The workaround (`wrapper.focus(); dispatchEvent(KeyboardEvent('keydown', {key:' '}))`) works for the controlled-check-box but doesn't help with the numeric input. A user clicking with a real hardware mouse + typing on a real keyboard would have no trouble.

## Assertion results
All A1–A14 ⏸ DEFERRED. Report not generated.

## Recommended next-pass coverage
- LFIQA: run the test manually for ~5 min (real mouse clicks + real keyboard input on the channel checkboxes and post-count text fields, then Run Report). Then upload the resulting CPR PDF (or screenshots of the BPC filmstrip section) and I'll verify:
  - A1 header `Michael Kors: CONTENT PERFORMANCE`
  - A2-A3 tile headers FB / Twitter / IG / YouTube
  - A4-A7 5 posts per row, unique ranks, ordered desc by Engagements for Most Engaging / asc for Least Engaging
  - A8-A9 post type displayed + hyperlinked
  - A10 posts within Apr 27 – May 26 2026
  - A11-A14 per-channel metric columns

## Skill registry impact
- Add a new entry/note to `known-quirks.md`: the CPR builder UI's channel-checkboxes and post-count numeric inputs share the same React-state-revert quirk. Recommend a `cpr-report-run` skill that uses `find` + ref-element click pattern + form_input for numeric fields instead of synthetic JS events.
