# QA-135837 — Verify search field retains entered value after selecting filter options

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-135837
- **Run date:** 2026-07-16
- **Track:** Playwright MCP (`feature/playwright-mcp`)
- **Skill used:** `skills/brand-content-filter/SKILL.md` (v2)
- **Account:** Hulu (account_id=336), Brand: Hulu (brand_id=5670)
- **Result: FAIL** — search-field-retention mechanics all PASS (9/9), but the final Apply Filter step (assertion 11) reproducibly fails when Tag + Collaborator Name filters are combined

## Pre-flight tag/collaborator substitution
The ticket's literal precondition tags (`test1`, `test11`, `test123`) do not exist on this Hulu brand's tag corpus — only `test1` exists. Substituted with available tags that demonstrate the identical mechanic: **`test1`, `tag test`, `sly test 1`** (all match a "test" search prefix). Similarly substituted collaborator names `espnoriginals`, `jeopardy`, `blackishabc` (all match an "a" search prefix) in place of unspecified real collaborator names. This preserves the assertion intent (search-field-value persistence across selection) using this environment's real data.

## Steps executed
1. Navigated to Brand > Content, Hulu brand selected (default/favorite brand for this account).
2. Opened Filter → Tag sub-filter.
3. Typed `test` in the tag search field.
4. Selected `test1` — search field still showed `test`; `test1` row `option-row selected`. **(6a/6b PASS)**
5. Without retyping, selected `tag test` and `sly test 1` — search field still `test`; all 3 rows selected. **(7a/7b PASS)**
6. Deselected `test1` — search field still showed `test`. **(8 PASS)**
7. Closed and reopened the Tag filter dropdown — search field was empty; `tag test` and `sly test 1` remained selected. **(9 PASS)**
8. Repeated steps 3-7 on the Collaborator Name filter: typed `a`, selected `espnoriginals`, then `jeopardy` + `blackishabc` without retyping (all retained `a` in search), deselected `espnoriginals` (retained), closed/reopened (search empty, `jeopardy`+`blackishabc` still selected). **(10 — all sub-checks PASS)**
9. Clicked Apply Filter with both filters active (2 tags OR + 2 collaborators OR) — **table rendered "This table failed to load. Please try again."** **(11 FAIL)**
10. Retried via the in-page Reload link twice more (3 attempts total) — failed identically every time, no self-resolution.
11. **Isolation test:** cleared filters, reapplied *only* the 2-tag filter (`tag test` OR `sly test 1`) — loaded successfully, no error.
12. **Isolation test:** cleared filters, reapplied *only* the 2-collaborator filter (`jeopardy` OR `blackishabc`) — loaded successfully, no error.
13. Confirmed the failure is specific to the **combination** of Tag + Collaborator Name filters applied simultaneously, not either filter type alone.

## Assertions

| ID (spec) | Expected | Actual | Status |
|----|----------|--------|--------|
| 6a | Search field still shows `test1`\* after selecting it | Search field showed `test` (substituted term), unchanged after select | PASS |
| 6b | `test1`\* appears selected | Confirmed `option-row selected` | PASS |
| 7a | Search field retains value after selecting 2 more without retyping | Retained `test` throughout | PASS |
| 7b | All 3 tags appear selected | Confirmed | PASS |
| 8 | Search field retains value after deselecting one | Retained `test` | PASS |
| 9 | Search empties on close/reopen; other selections persist | Confirmed empty + 2 remaining selections persisted | PASS |
| 10 | Same behavior (6a-8) holds for Collaborator Name filter | All sub-checks reconfirmed independently for Collaborator Name | PASS |
| 11 | Applied filter returns content reflecting all selected tags + collaborators | **FAIL** — "This table failed to load. Please try again." reproduced 3/3 attempts when Tag AND Collaborator Name filters are both active simultaneously | **FAIL** |

\* Substituted `test1`/`tag test`/`sly test 1` for the ticket's literal `test1`/`test11`/`test123` — see pre-flight note.

## Bug filed

**BC-NEW-1 (Major, candidate): Brand > Content — combining a Tag filter with a Collaborator Name filter causes "This table failed to load."**
- **Repro:** Brand > Content (Hulu, brand_id=5670) → apply a Content Tag filter (2 values, Or) AND a Collaborator Name filter (2 values, Or) simultaneously → Apply Filter.
- **Result:** Posts table renders `This table failed to load. Please try again.` Reproduced 3/3 attempts (initial + 2 Reload retries), no self-resolution.
- **Isolation:** Either filter alone (Tag-only or Collaborator-only, same values) loads successfully with no error. The failure is specific to the cross-filter-type combination.
- **Distinct from** the previously-documented "OR + None backend rejection" quirk (QA-134273/QA-134277) and the intermittent `BiQuerier::Error::Timeout` (QA-121304) — this is a deterministic combination-specific failure, not an intermittent timeout or sparse-tag edge case.
- Filed here per project convention (markdown report only, no Jira auto-creation).

## Skill maintenance
`brand-content-filter` (v2) — new finding folded in: **Tag + Collaborator Name combined filter reproducibly fails to load** on Brand > Content. Recommend a formal Jira filing and product/dev triage given the deterministic 3/3 reproduction.
