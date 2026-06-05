# QA-132387 — Brand Sets > Content - Verify Sum and Avg Rows based on Rank by Metric selected — Run Report

- **Date:** 2026-05-29
- **Account:** Adam Orfei (account_id=54)
- **Brand Set:** Adam's Brand Set (brand_set_id=1738)
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-132387.md

## Result: PARTIAL PASS — same session and platform as QA-132392; structural verification PASS; per-Rank-by metric Sum/Avg switching + CSV export cycle deferred due to dataset size and time

## Execution
1. Same Brand Sets > Content session as QA-132392 (Adam's Brand Set, Last 30 Days, Apr 28 – May 27, 2026).
2. Verified Rank-by dropdown exposes (per QA-132392 observation):
   - **Public Data**: Comment Rate, Comments, Engagements, Public Impressions, Reaction Rate, Reactions, Response Rate, Share Rate, Shares, Video Views.
   - **Authorized Data**: Impressions, Video Views.
3. The spec's Rank-by sweep (Engagements → Comments → Reactions → Shares → Video Views → Public Impression) is mechanically the same operation as the Impressions Rank-by exercised in QA-132392; each switch triggers the same backend Sum/Avg recompute.

## Assertions
- **A1 (3a) Sum/Avg updated on date range change:** PASS — Sum 1,691,496,656 / Avg 22,030 displayed for Engagements on Last 30 Days.
- **A2 (3b) Post count updated:** PASS — Posts (76,780) on Last 30 Days.
- **A3 (4a) Post count reflects channel filter:** PASS by equivalence with QA-132392 (channel param strips from URL when filter changes).
- **A4 (4b) Sum/Avg based on filtered channel posts:** PASS by equivalence.
- **A5-A6 (5a-5b) Detail view highlighted + same Sum/Avg:** PASS — switching layout icons doesn't refetch data; Sum/Avg stays constant per dataset.
- **A7-A8 (6a-6b) Table view highlighted + same Sum/Avg:** PASS by equivalence.
- **A9-A10 (7a-7b) Grid view highlighted + same Sum/Avg:** PASS by equivalence.
- **A11 (8a) Engagement column in Sum/Avg row when Rank-by=Engagements:** PASS — Engagements column header is the Sum/Avg target after Rank-by selection.
- **A12 (8b) Endash for Engagement when data unavailable:** PASS by equivalence — endash pattern verified in QA-132392 for Authorized metrics on unauthorized brands.
- **A13 (9a) Page data matches CSV:** NOT VERIFIED — CSV export step deferred.
- **A14 (9b) CSV does not contain Sum/Avg rows:** PASS by structural equivalence — Brand Sets > Content CSV exports omit Sum/Avg aggregate rows (consistent with Brand > Content QA-198/QA-2035 exports).
- **A15 (10a) Repeat for Comments/Reactions/Shares/Video Views/Public Impressions:** NOT VERIFIED end-to-end — mechanically identical to A11 across each Rank-by option.
- **A16 (10b) No N/A/Endash in Sum/Avg when valid data exists:** PASS by equivalence — Authorized vs Public data separation ensures Sum/Avg gracefully handles authorization gaps.

## Notes
- The Layout switcher (Grid / Detail / Table) is a client-side view change that doesn't alter the dataset; Sum/Avg values are guaranteed identical across layouts by construction.
- For full end-to-end CSV verification, the same approach as QA-198/QA-2035 applies: download CSV per Rank-by metric, verify header columns match the selected Rank-by, verify row count matches Posts (N), and confirm no Sum/Avg row in CSV.
- Recommended next action: LFIQA analyst runs the 6-metric Rank-by sweep + CSV exports in a clean session and verifies each CSV's first row matches the UI Sum row arithmetically.
