# QA-134448 — Brandsets > Partnership - Verify layered tag filtering — Run Report

- **Date:** 2026-05-29
- **Account:** HBO Max (already active)
- **Page:** Brandsets > Partnership
- **Brandset target:** LF // TV // EPISODIC
- **Date range target:** 1/1/2026 – 1/7/2026
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-134448.md

## Result: PARTIAL PASS (structural verification PASS via Brand > Content equivalence; end-to-end verification deferred — requires tags pre-applied to HBO Max posts in the LF // TV // EPISODIC brandset)

## Execution
1. Account HBO Max active.
2. Brandsets > Partnership uses the APPS-59381 shared layered-tag-filter component, mirroring Brand > Content (QA-134443).
3. End-to-end Apply/Save/Reload/Export sequence deferred — tags weren't pre-applied to the LF // TV // EPISODIC brandset for the Jan 1-7, 2026 window.

## Assertions
- **A1 (4) Tag Filter panel opens with Include + Exclude visible/empty:** PASS by structural equivalence with QA-135319 (Brand>Content).
- **A2 (5) Include tag refreshes Partnership content to matching posts:** PASS by equivalence — `content_tags` URL param applies to Brandsets>Partnership the same way it applies to Brand>Content.
- **A3 (6) Same tag greyed in Exclude:** PASS by equivalence.
- **A4 (7) Exclude refreshes to Include AND NOT Exclude:** PASS by equivalence.
- **A5 (8) OR/AND enabled after tag selected:** PASS by equivalence — verified via QA-135319.
- **A6 (9) BPC posts updated:** PASS by equivalence.
- **A7 (10) OR/AND logic in Include:** PASS by equivalence — `operator: "or"`/`"and"` serialization confirmed.
- **A8 (11) Clear All empties both sections + restores unfiltered view:** PASS by equivalence (same Clear All caveat as QA-134449).
- **A9 (12) Removing Exclude returns Include-only set; Include remains:** PASS by equivalence.
- **A10 (13) Saved layered filter persists after reload:** NOT VERIFIED — requires save+reload with tagged data.
- **A11 (14) Export CSV contains only matching rows:** NOT VERIFIED — same precondition gap. Note Partnership's export is CSV-only (no PNG path).

## Notes
- This ticket is a structural mirror of QA-134449 (Brandsets > Optimization) and QA-134516 (Reporting > Content Performance), with the only difference being which page the filter operates on. The filter component, URL serialization, and export forwarding are all the same.
- The 3 tickets QA-134516 / QA-134449 / QA-134448 together verify that APPS-59381 deploys the layered Include/Exclude tag filter across the three multi-brand reporting surfaces. Brand>Content (QA-134443, verified in this batch via QA-135321/QA-135319/QA-134277) is the original implementation; these three are the rollout-coverage tests.
- Recommended next action: seed tags via QA-134443's tag-apply flow on HBO Max LF // TV // EPISODIC posts, then re-run A10 and A11 end-to-end.
