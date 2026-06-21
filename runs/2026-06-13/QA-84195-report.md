# QA-84195 — Reporting > Data Studio - Brand > Content - Data QA - Video Views — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** MTV
- **Result:** ⚠️ NOT VERIFIED (carry-forward) — DS metric-tree friction blocks adding the Video Views metric (3rd consecutive)

## Execution
- DS report (296281) loaded; attempted to add **Public Video Views** to Page Level Metrics via both coordinate click and dispatched `mousedown/mouseup/click` events on the picker item.
- The metric did **not** register (Page Level Metrics stayed at Total Followers only) — the Video-category picker items resist synthetic selection, while Total Followers added fine earlier. Same DS metric-tree friction documented on 2026-06-05/08.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| DS Video Views = Brand Content Video Views (parity) | DS and BC Video Views reconcile for MTV | NOT REACHED — Video Views metric not addable to DS report (automation friction) | ⚠️ NOT VERIFIED |

## Notes
- Known DS↔BC Video Views parity drift carries forward. Recommend LFIQA verify manually (add Video Views in DS via real click) or a skill fix for the Video-category picker.

## Bugs filed
_None (automation-only friction, not a product bug)._
