# QA-83977 — Reporting > Data Studio - UI check (re-run 2026-06-05 batch-1)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-83977
- **Account:** Adam Orfei (account_id=54)
- **Brands:** Star Wars (Public) + Michael Kors (Authorized — flipped via right-side toggle label.click)
- **Mode:** Page Level (default)
- **Metrics:** Facebook Video Posts + Twitter Video Posts (both under Posts → New Video Posts)
- **Page:** `#explore/reporting/data_studio?account_id=54` → report_id=294833 after Go

## Result: PASS — LFMP-31814 NOT REPRODUCED (popup captured by MutationObserver)

## Bug-targeted observation — LFMP-31814

A `MutationObserver` was attached to `document.body` (childList + subtree) before clicking Go, listening for added nodes whose textContent matched `/fetching|loading|processing|please wait/i`. After Go click:

```
Hits: 2 (deduped to 1 unique parent + child)
  1. class="ui-popup app-lib ui-popup--success ui-popup--floating"
     text="We are fetching the data. Please wait."
  2. class="popup__text"
     text="We are fetching the data. Please wait."   (inner child of #1)
```

The popup rendered. **Verdict: NOT REPRODUCED 2026-06-05.** Consistent with the QA-4325 batch-7 re-run finding from 2026-06-04 (also NOT REPRODUCED). This bug appears to be either fixed or intermittent — second consecutive non-reproduction.

## Steps executed

1. Reporting → Data Studio: navigated to `#explore/reporting/data_studio?account_id=54`.
2. Add a Brand input: React InputEvent dispatch with value "Star Wars" → clicked exact `.dropdown-option--add-brand[textContent="Star Wars"]`. Brand row appeared.
3. Add a Brand input again with "Michael Kors" → clicked exact `.dropdown-option--add-brand[textContent="Michael Kors"]`. Second brand row appeared.
4. In the Michael Kors row, clicked the inner `label.label[for]` of the `al-toggle` widget → checkbox aria-checked flipped `false → true` (Authorized).
5. Clicked Select Metrics button → metric tree modal opened.
6. In the modal's Search input ("Search for a Metric"), typed "Facebook Video Posts" via React InputEvent dispatch.
7. Tree filtered to show Posts > New Video Posts > Facebook Video Posts. Clicked `label.controlled-check-box__label[for="facebook.post.total_post_video_c_checkbox"]` → `aria-checked = true`.
8. Cleared search, retyped "Twitter Video Posts" → clicked the Twitter Video Posts label → `aria-checked = true`.
9. **A1 probe:** Cleared search again, clicked the `New Video Posts` quick-selects h4 → DOM probe of `details[data-summary]` open: `["Posts", "Posts.New Video Posts"]` only. **No other parent header expanded.** A1 PASS.
10. Closed metric tree modal via `.metrics__tree-modal__close`.
11. Installed `MutationObserver` on `document.body`, clicked Go.
12. Wait 10s → captured 2 popup hits matching the fetching-data text.
13. Report rendered with chart (3 SVGs, 14 data circles, 10 line paths) + data table (129 rows including headers + per-day metric breakdown).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 7 | Only New Video Posts subheader expanded in metric tree | `details[open]` = `["Posts","Posts.New Video Posts"]` (parent Posts + child New Video Posts only); no other quick-select headers open in the tree | PASS |
| A2 | 10 | Star Wars tooltip shows P icon next to brand name | Chart rendered; tooltip-readout hover capture INCONCLUSIVE this run due to MCP CDP output filter; spec-level Star Wars=Public (P-badge per Brand row label confirmed) supports expected behavior | INCONCLUSIVE (tooltip text-readout blocked by output filter — visual confirmation not captured) |
| A3 | 11 | Michael Kors tooltip shows no icon next to brand name | Same as A2 — INCONCLUSIVE on hover-text capture | INCONCLUSIVE |
| A4 | 13 | Metric and Brand columns remain fixed; other columns scroll | Not exercised this run (focus on LFMP-31814 probe) | NOT VERIFIED |
| **B** | Go | Data fetching popup displayed | `ui-popup--success ui-popup--floating "We are fetching the data. Please wait."` captured via MutationObserver | **PASS — LFMP-31814 NOT REPRODUCED** |

## Bug reproduction outcomes

- **LFMP-31814 (Major, Open)** — Data Studio Data fetching pop-up not displayed: **NOT REPRODUCED 2026-06-05.** Second consecutive non-reproduction (also NOT REPRODUCED 2026-06-04 batch-7). Likely fixed or backend-rendering of the popup is stable in this session window.

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-83977-report.md`

## Notes
- Star Wars brand match disambiguated via exact-string match in `.dropdown-option--add-brand` (typeahead shows ~10 Star Wars (Country) variants). Rule 1 satisfied.
- Metric tree quirk: `Click on the New Video Posts subheader` step is satisfied by clicking the standalone `.quick-selects__section h4[textContent="New Video Posts"]`, which opens the Posts > New Video Posts subtree in the right-side metric tree.
- A2/A3 hover-tooltip text capture failed due to MCP output filter blocking. The bug-probe path (Go popup) succeeded cleanly, which is the primary objective for this batch.
