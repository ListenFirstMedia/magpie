# QA-134516 — Reporting > Content Performance - Verify layered tag filtering (Include + Exclude)

- **Date:** 2026-05-29 (batch 4 re-run, end-to-end on real CPR builder)
- **Source spec:** testcases/english/QA-134516.md
- **Prior run:** runs/2026-05-27/QA-134516-report.md (PARTIAL — structural equivalence with Brand>Content)
- **Skills:** `switch-account`, `brand-content-filter` (extended to CPR layout)

## Result: FAIL (spec mismatch) — CPR Tag Filter does NOT support Include/Exclude sections

## Execution

1. Switched account from Hulu → HBO Max (account_id=657) via profile dropdown → "HBO Max" Results item.
2. Reporting → Content Performance opened `app-reporting.lfmdev.in/#/content_performance`.
3. Searched competitive sets for "LF // TV" and "Episodic" — **NO matching brand set found on HBO Max account**. Spec requires "LF // TV // EPISODIC" brandset. Per Rule 1, cannot substitute; proceeded with Add Brand By Name = "Euphoria" (HBO Max owned brand) to exercise the Tag Filter mechanic on this account.
4. Brand added via React-aware input setter (typeahead doesn't fire on Chrome MCP `type` action). Default View: Public Data toggle.
5. Scrolled to "Content and Tag Filters" section (below Options panel, above Report Title).
6. Filter dropdown → list shows: Branded Content, Content Type, Live Stream, Publish Day, Publish Time, Publish Type, Sponsor Name, Tag, Text Search.
7. Selected **Tag** → sub-popup opened. **Contents:** Search input + `Or | And` radios + tag checkboxes (None, ?, 100 days my prince, 1923, #20daysofkindness, …). **No Include section. No Exclude section. No Include/Exclude radios.**
8. DOM-verified: `document.querySelectorAll('input[type="radio"]')` near the tag popup yields zero Include/Exclude radios. Only `.edit-operator-button.or` / `.and` are present.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | Tag Filter panel opens with Include + Exclude sections visible/empty | Tag sub-popup contains Search, Or/And operator, and tag checkboxes — **no Include section, no Exclude section**. The Content Performance builder's Tag Filter does NOT have the Include/Exclude split that exists on Brand > Content. | **FAIL** |
| A2 | 5 | Tag added to Include; report reflects only posts matching that tag | N/A — no Include section exists to add a tag to. | N/A |
| A3 | 6 | Same tag greyed out/non-selectable in Exclude | N/A — no Exclude section exists. | N/A |
| A4 | 7 | Tag added to Exclude; data reflects Include AND NOT Exclude | N/A | N/A |
| A5 | 8 | OR/AND toggle updates report data | OR/AND radios DO exist but they're only for combining multiple Include-side tags; no Exclude semantics. Spec assertion partially satisfied but the meaning differs. | PARTIAL |
| A6 | 9 | Report shows only posts matching layered filter | N/A (no layered Include+Exclude on CPR) | N/A |
| A7 | 10 | Clear All empties both Include + Exclude sections | N/A (only single-section) | N/A |
| A8 | 11 | Removing only Exclude returns Include-only result | N/A (no Exclude on CPR) | N/A |
| A9 | 12 | Saved layered filter persists after reload | DEFERRED — without Include/Exclude to layer, the "layered filter" concept doesn't apply. | DEFERRED |
| A10 | 13 | Exported CPR (CSV/GS) contains only rows matching layered filter | DEFERRED — cannot construct the layered filter the spec describes. | DEFERRED |

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs on QA-134516) | — | bug-history shows 0 historical defects |

## New findings

1. **Reporting > Content Performance Tag Filter is structurally different from Brand > Content Tag Filter.** Brand > Content Tag Filter has Include/Exclude radios + OR/AND operator. Content Performance Tag Filter has ONLY OR/AND operator. There is no Exclude semantic on CPR.
   - Implication: QA-134516 spec is incorrect or the platform feature is incomplete. Either:
     (a) The CPR Tag Filter needs to gain Include/Exclude parity with Brand > Content (engineering ticket).
     (b) The QA-134516 test case needs to be rewritten to reflect actual CPR behavior (only OR/AND on inclusion tags).
   - Recommend product/eng triage to decide which is intended.

2. **HBO Max account does not contain a "LF // TV // EPISODIC" brand set.** Searched competitive-set list (with "LF // TV" and "Episodic" terms) on HBO Max — neither returned a hit. Per Rule 1, the test could be considered BLOCKED on test-data setup. If the brand set exists on a different account (e.g., Amazon Prime Video, where similar LF brand sets do exist per prior batch findings), the spec preconditions need clarification.

## Files

- testcases/english/QA-134516.md
- runs/2026-05-29/QA-134516-report.md (this report)
