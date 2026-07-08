# QA-520 — Facebook Content - Table Data Set - Authorized & UnAuthorized

- **Run date:** 2026-07-03 (HEADLESS Playwright MCP)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-520 · Priority: Blocker
- **Result:** **PASS** — lock symbols, N/A, and dash behaviors all correct for the Impressions data set (unauthorized brand).
- **App:** `app.lfmdev.in` Brand > Content · **Account:** Adam Orfei · **Brand:** Star Wars (75007) · **Channel:** Facebook only · **Data Set:** Impressions · Table View
- **Skills:** switch-account, brand-content-data-set-selector

## Linked bug scan
No open linked bugs — [[open-bug-auto-fail]] N/A.

## Steps executed
1. Brand > Content. ✅
2. Selected **Star Wars** brand, **Facebook** only (deselected the other 5 channels → Apply → `channels=facebook`). ✅
3. Table Data Set dropdown → **Impressions** (`table_data_set=impressions`). ✅
4. **Table View** mode. ✅
5–7. Reviewed aggregate Sum then Average rows. ✅

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| 4 | Only Engagements shows a value; other metrics show Lock symbol | Post row 1: Engagements = 2,699 (value); Engagement Rate / Impressions / Organic Impressions / Paid Impressions / Reach / Organic Reach / Paid Reach / Engaged User Rate = **LOCK** icon | ✅ PASS |
| 5 N/A group | Engagement rate, Reach, Organic Reach, Paid Reach, Engaged User Rate → N/A (aggregate **sum**) | All five = **N/A** | ✅ PASS |
| 5 impressions | Impressions, Organic Impressions, Paid Impressions → "0" or "-" (aggregate sum) | All three = **–** | ✅ PASS |
| 7 | All metrics "-" for aggregate **avg** except Engagements | Avg row: Engagements = **1,156** (≈ 9,247÷8); all 8 other metrics = **–** | ✅ PASS |

## Evidence
- `qa520-table-sum.png` — Table View, Impressions data set, Sum aggregate row + post rows with lock icons.
- DOM extract — Sum row (Engagements 9,247; rates/reach N/A; impressions –) and Average row (Engagements 1,156; all others –); post-row lock icons.

## Notes
- Star Wars is an **unauthorized** brand for the Impressions (private) data set, hence lock icons on posts and N/A / – on the aggregate — exactly the intended Authorized-vs-Unauthorized behavior.
- Headless UI note: on Brand Content the brand picker opens by clicking **`.brand-selector-name-container`** (the name+chevron), not the outer `.brand-selector-dropdown-container` (which toggled without expanding). Aggregate Sum/Average is `input.toggle-switch-checkbox[data-aggfn="avg"]` — click its switch `label`, not the "Average" text.

## Bugs filed
None. All assertions passed.
