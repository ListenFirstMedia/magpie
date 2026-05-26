# QA-121304 — Brand > Content - Instagram Collaborator Name Filtering

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-121304
- **Run date:** 2026-05-18
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Amazon Prime Video (account_id 342)
- **Brand:** Amazon Prime Video
- **Date range:** Sep 10 – Sep 16, 2025
- **Result:** ⏸ **Deferred — context budget exhausted on this session**

## Status

Account switch verified working (Amazon Prime Video now reachable from LFIQA's account list). Test setup is standard:

1. Brand → Content with brand = Amazon Prime Video, date range Sep 10–16, 2025.
2. Filter → Collaborator Name → select `amazonmgmstudios` → Apply Filter.
3. Verify: A1 filter ordering, A2 alphabetical unique names, A3-A5 filtered post results.

The filter dropdown pattern was verified working on FX Networks in QA-91412 this session. The Collaborator Name filter specifically should follow the same UX as Publish Type.

## Recommendation
Run in next session with a focus on the Collaborator dropdown ordering and the filtered post-set verification.

## Bugs filed
None.
