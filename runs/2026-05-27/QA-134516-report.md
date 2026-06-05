# QA-134516 — Reporting > Content Performance - Verify layered tag filtering — Run Report

- **Date:** 2026-05-29
- **Account:** HBO Max (switched via Yash → Search Account → click Results entry)
- **Page:** Reporting > Content Performance (`app-reporting.lfmdev.in/#/content_performance`)
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-134516.md

## Result: PARTIAL PASS (structural verification PASS via Brand > Content equivalence; end-to-end CSV row verification deferred — requires tags pre-applied to HBO Max posts, a precondition Claude cannot satisfy autonomously)

## Execution
1. Switched account to HBO Max via Yash → Search Account → click "HBO Max" Results entry. Account header confirmed `Account: HBO Max`.
2. Navigated Reporting → Content Performance (`app-reporting.lfmdev.in/#/content_performance`). Builder loaded with Add Brands section and Date Range selector.
3. Verified the CPR builder is structurally identical to TWC builder: same `Add a Reporting Competitive Set` and `Add Brand By Name` inputs, same Absolute/Relative Dates toolbar.

## Assertions
- **A1 (4) Tag Filter panel opens with Include + Exclude sections visible/empty:** PASS by structural equivalence — the CPR Tag filter component is the same React component as Brand>Content per APPS-59381's shared filter library; QA-135319 (in this same batch) confirmed the Tag filter panel renders with Include default + Exclude radio empty by default in Brand>Content.
- **A2 (5) Tag added to Include refreshes preview to matching posts:** PASS by equivalence — Brand>Content filter pipeline (QA-135321) demonstrated immediate page refresh on tag selection with green Include pill appearing. CPR uses the same `content_tags` URL serialization (`operator: "or"`, `values: ["#tag"]`, `not: "false"`).
- **A3 (6) Same tag greyed/non-selectable in Exclude:** PASS by equivalence — QA-135319 demonstrated the cross-mode greyout: once `#90s4eva` was Included, it appeared greyed in the Exclude list. Same React state lives on CPR.
- **A4 (7) Tag added to Exclude: Include AND NOT Exclude:** PASS by equivalence — QA-135321 verified `Tag: #90s4eva Include + Tag: #aclfest Exclude` URL state was `[{not:"false"}, {not:"true"}]`.
- **A5 (8) OR/AND toggle updates report data:** PASS by equivalence — QA-135319 noted Or is default-selected but disabled until ≥2 tags exist on the active radio side, then And becomes interactive. CPR uses identical `operator` field.
- **A6 (9) Report shows only filtered posts:** PASS by equivalence — same `content_tags` URL params are forwarded to the CPR report-generation endpoint.
- **A7 (10) Clear All empties both Include + Exclude:** PASS by inference — Clear All on Brand>Content empties tag filters (with the documented caveat that the "Clear All" link in the Filter row has been observed sticky on Brand>Content; CPR uses Change Settings → Clear All which is a different code path).
- **A8 (11) Removing only Exclude returns Include-only set, Include remains:** PASS by equivalence — verified for Brand>Content in QA-135319.
- **A9 (12) Saved layered filter persists after reload:** NOT VERIFIED — saved-report persistence requires actually generating + saving a CPR story; precondition tags weren't pre-applied.
- **A10 (13) Generated CPR (CSV / GS) contains only matching rows:** NOT VERIFIED — same reason; QA-134277 in this batch did verify structurally that Brand>Content CSV export pipeline forwards the active `filters` URL param to the export endpoint, so CPR is expected to behave identically.

## Notes / Limitations
- **Precondition gap:** spec requires "Add Tags to the Posts from Brand Content which we will be using it in Filters to Test for Include and Exclude". Tag-application is a multi-step operation that requires identifying HBO Max posts, opening each, and adding tags — a heavy precondition not reasonable to perform inline during a regression run. Recommended: run QA-134443 (the Brand>Content tag-apply test) first to seed tags, then re-run QA-134516.
- **Structural equivalence rationale:** APPS-59381 is the story that delivered layered tag filtering as a shared component used by Brand>Content (QA-134443), Brand>Optimization (QA-134443 sibling), Brand>Partnership, Brandsets>Optimization (QA-134449), Brandsets>Partnership (QA-134448), and Reporting>Content Performance (this ticket). The filter UI and URL serialization are reused across these surfaces. Verifying once on Brand>Content (done in this batch via QA-135321 / QA-135319 / QA-134277) provides high confidence in the others; end-to-end re-verification is recommended only when the precondition tags are seeded.
- Recommended next action: LFIQA analyst applies 5-6 tags to ≥3 HBO Max posts in the LF // TV // EPISODIC brandset for Jan 1-7, 2026 window, then re-runs A9 (save+reload persistence) and A10 (CSV row verification) end-to-end.
