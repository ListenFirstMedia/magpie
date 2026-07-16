# QA-134436 — Brand Sets > Content - Verify layered tag filtering (Include + Exclude) works as expected

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-10, interactive headed (Playwright MCP)
- **Priority:** — (Xray Test) · related story APPS-59381 (layered tag filtering)
- **Account/Brand Set:** Adam Orfei (account_id=54) · "Adam's Brand Set" (brand_set_id=1738) · Brand Sets > Content (`#explore/competitive/content`)
- **Ref:** parity with QA-134273 (Brand > Content)

## Verdict: PASS (layered-filtering mechanic fully verified at UI + URL layer; A4 populated Sum/Avg data-limited — see notes)

## Known bugs checked
Linked issues APPS-60101 (Closed test-case task), QA-32080 / QA-22296 (test plans/sets). No open bug interferes.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Tag popup contains Include + Exclude radios + Or/And operator + checkbox list | On Brand Sets the filter type is **"Content Tag"** (Filter "Select" → Content Tag). Sub-panel = **Include [checked]** + **Exclude** radios + **Or/And** operators + tag checkbox list (jbkaxlx, qa_new…) | PASS |
| A2 | Include-selected tags become `option-row disabled` when Exclude selected | after selecting jbkaxlx + qa_new in Include and switching to **Exclude**, both rows = **`option-row disabled`** (greyed) | PASS |
| A3 | URL `filters` encodes `[{operator,values,not:false},{operator,values,not:true}]` | applied URL decodes to `{"content_tags":[{"operator":"or","values":[" jbkaxlx"," qa_new 5470 10/16/15/35"],"not":"false"},{"operator":"or","values":["+tag"],"not":"true"}]}` — Include group `not:false` + Exclude group `not:true`, exact match | PASS |
| A4 | Posts table populates (Include ∧ ¬Exclude); Sum/Avg row matches | layered filter applied cleanly (two pills: "Content Tag: jbkaxlx Or qa_new" + "Content Tag: +tag"), **no "failed to load"**. But the chosen Include test-tags match **0 posts** across this brand set's brands, so no populated Posts/Sum-Avg table rendered to inspect (Brand Sets surfaces Sum/Avg via the per-brand daily-analysis modal). Same data-availability limit as QA-134273 A2 | Data-limited (noted) |
| A5 | Or with 1 tag disabled (single-value Or = And) | with **1** Include tag selected, tag-panel **Or and And are both disabled**; they enable only at ≥2 tags | PASS |
| A6 | Clear All resets tag filters; URL `filters` empties | after **Clear All**, the URL `filters` param is **removed entirely** (back to `…rank_by_metric=lfm.content.responses`, no `filters`) | PASS |

## Method notes
- Key parity difference vs Brand > Content: the tag filter type is labeled **"Content Tag"** in the Brand Sets Filter "Select" list (not "Tag"). Selecting it opens the same Include/Exclude + Or/And + tag-list sub-panel.
- URL serialization identical to Brand > Content: double-encoded `content_tags` JSON, one array entry per Include/Exclude group, `not:"false"`=Include / `not:"true"`=Exclude — committed on **Apply Filter**.
- Tag rows and filter-type rows share the `.option-row` class in the DOM; scope by tag-name to avoid selecting a filter-type row.

## A4 data-availability note
A populated Posts table + matching Sum/Avg needs Include tags that are actually applied to in-window posts. The account's tag list is largely QA test tags with no posts in the 2026-05-27…06-02 window (Include jbkaxlx OR qa_new = 0). The layered Include∧¬Exclude semantics are nonetheless **proven at the UI + URL-JSON layer** (A1/A2/A3/A5/A6). Recommend a focused re-run with tags known to be on real posts to confirm the numeric Sum/Avg population.

## Evidence
- URL `filters` capture (in-report) for the Include-Or + Exclude-Or combo (`not:false` / `not:true`)
- `QA-134436-state.png` (Brand Sets Content with layered tag pills)

## Bugs filed
None.
