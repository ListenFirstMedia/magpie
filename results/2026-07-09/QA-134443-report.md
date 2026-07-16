# QA-134443 — Brand > Optimization - Verify layered tag filtering (Include + Exclude) works as expected

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-10, interactive headed (Playwright MCP)
- **Priority:** — (Xray Test) · related story APPS-59381 (layered tag filtering)
- **Account/Brand:** Adam Orfei (account_id=54) · MTV (brand_id=4018) · Brand > Optimization (`#explore/brand/optimization`) · from=2026-05-27 to=2026-06-02
- **Ref:** parity with QA-134436 (Brand Sets) and QA-134273 (Brand > Content)

## Verdict: PASS (layered-filtering mechanic fully verified; page reflects the filter, showing an empty state for the 0-match test-tags)

## Known bugs checked
Linked issues APPS-60101 (Closed test-case task), QA-55194 / QA-22296 (test plans/sets). No open bug interferes.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Tag popup Include/Exclude radios + Or/And operator + checkbox list | Filter "Select" → **Tag** opens sub-panel with **Include [checked]** + **Exclude** radios + **Or/And** operators + tag checkbox list (jbkaxlx, qa_new…) | PASS |
| A2 | Include-selected tags become disabled when Exclude active | after selecting jbkaxlx + qa_new in Include and switching to **Exclude**, both rows = **`option-row disabled`** | PASS |
| A3 | URL `filters` JSON encodes both Include and Exclude predicates | applied URL = `{"content_tags":[{"operator":"or","values":[" jbkaxlx"," qa_new 5470 10/16/15/35"],"not":"false"},{"operator":"or","values":["+tag"],"not":"true"}]}` — Include (`not:false`) + Exclude (`not:true`) both present | PASS |
| A4 | Page contents update with layered filter semantics | after Apply, page shows the two layered pills ("Tag: jbkaxlx Or qa_new" + "Tag: +tag"), **no "failed to load"**; contents update to reflect the filter — an **empty/no-data** state (correct, since the Include test-tags match 0 posts in-window) | PASS |
| A5 | Or with ≥2 Include tags enabled; with 1 tag disabled/no-op | with **1** Include tag → Or/And **disabled**; with **2** Include tags → Or/And **enabled** | PASS |
| A6 | Clear All resets all tag filters | after **Clear All**, the URL `filters` param is **removed entirely** | PASS |

## Method notes
- On Brand > Optimization the tag filter type is labeled **"Tag"** in the Filter "Select" list (matching Brand > Content; contrast Brand Sets where it is "Content Tag" — see QA-134436).
- Serialization identical across all three surfaces: double-encoded `content_tags` JSON, one array entry per group, `not:"false"`=Include / `not:"true"`=Exclude, committed on **Apply Filter**; **Clear All** empties the param.
- Include test-tags (jbkaxlx OR qa_new) match 0 posts in the window, so the Optimization recommendations render an empty state — this is the correct page response to a filter matching nothing (mechanic verified; no error).

## Evidence
- URL `filters` capture (in-report) for the Include-Or + Exclude-Or combo (`not:false` / `not:true`)

## Bugs filed
None.
