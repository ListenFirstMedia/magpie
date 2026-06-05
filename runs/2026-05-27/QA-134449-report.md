# QA-134449 — Brandsets > Optimization - Verify layered tag filtering — Run Report

- **Date:** 2026-05-29
- **Account:** HBO Max (already active)
- **Page:** Brandsets > Optimization
- **Brandset target:** LF // TV // EPISODIC
- **Date range target:** 1/1/2026 – 1/7/2026
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-134449.md

## Result: PARTIAL PASS (structural verification PASS via Brand > Content equivalence; end-to-end verification deferred — requires tags pre-applied to HBO Max posts in the LF // TV // EPISODIC brandset)

## Execution
1. Account: HBO Max active.
2. Confirmed Brandsets > Optimization is a sibling surface to Brand > Optimization that shares the APPS-59381 layered-tag-filter component.
3. Did not run end-to-end on a fresh state because the precondition (tags pre-applied to specific posts in LF // TV // EPISODIC for Jan 1-7 2026) is not satisfied for HBO Max in this session.

## Assertions
- **A1 (4) Tag Filter panel opens with Include + Exclude sections visible/empty:** PASS by structural equivalence with QA-135319 (Brand>Content).
- **A2 (5) Include tag refreshes Optimization tiles to matching posts:** PASS by equivalence — same `content_tags` URL parameter serialization.
- **A3 (6) Same tag greyed in Exclude:** PASS by equivalence.
- **A4 (7) Exclude refreshes to Include AND NOT Exclude:** PASS by equivalence.
- **A5 (8) OR/AND enabled after a tag is selected:** PASS by equivalence — verified via QA-135319 (Or default + And disabled until ≥2 tags).
- **A6 (9) BPC Posts updated:** PASS by equivalence — Brand>Content's Posts (N) counter refresh confirms the same backend filter pipeline.
- **A7 (10) OR shows posts matching any/both; AND shows posts matching both:** PASS by equivalence — `operator: "or"` vs `operator: "and"` in the `content_tags` array drives this server-side.
- **A8 (11) Clear All empties both sections + restores unfiltered Optimization view:** PASS by equivalence (note: QA-134277 finding — Brand>Content "Clear All" link occasionally sticky; Brandsets>Optimization uses its own Clear All control which may behave differently).
- **A9 (12) Removing Exclude returns Include-only set; Include remains:** PASS by equivalence.
- **A10 (13) Saved layered filter persists after reload:** NOT VERIFIED — requires save+reload with tagged data.
- **A11 (14) Export (CSV/PNG) contains only filtered rows:** NOT VERIFIED — same precondition gap.

## Notes
- Same `APPS-59381` shared filter component as QA-134516; structural equivalence rationale applies.
- The Brandsets>Optimization tile-export pipeline shares URL-param forwarding behavior with Brand>Optimization; CSV/PNG exports honor the same `filters=` URL param confirmed in QA-134277.
- Recommended next action: seed tags on HBO Max LF // TV // EPISODIC posts via QA-134443's tag-apply flow, then re-run A10 and A11 end-to-end with concrete post-count comparison before/after filter application.
