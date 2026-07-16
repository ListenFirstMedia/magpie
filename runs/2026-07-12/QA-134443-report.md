# QA-134443 — Brand > Optimization: Verify layered tag filtering (Include + Exclude)

**Verdict: PASS**

- **Run:** 2026-07-12 (unattended, headless, Playwright MCP)
- **Account:** Adam Orfei (id=54) — confirmed in header
- **Brand:** MTV (brand_id=4018) — selected via typeahead Results (Rule 1), exact-match "MTV" clicked
- **Page:** Brand > Optimization (`#explore/brand/optimization`)
- **Date range:** Jul. 04, 2026 – Jul. 10, 2026 (default representative window)
- **Perspective:** Authorized (`perspective=extended`, auto-applied on MTV load) — not gating for tag-filter mechanic
- **Skill reused:** `brand-content-filter` v3 (documents Brand>Optimization layered Tag widget)

## Known bugs checked

- **knowledge-base/bug-history.md** grep `QA-134443`: entry present, **"No open Bug/Test-Failure links."** Prior run 2026-06-04 (QA-4325 batch 12) PASS on MTV all-channels; same widget as Brand>Content; URL `filters` JSON encodes both Include/Exclude predicates.
- Case file has no `## Open linked bugs` section; bug-history is authoritative → **screen passed, ran the case** (Rule 7).
- No open bug interfered with any step or assertion during the run.

## Steps executed

1. Logged in (Cognito existing-account form) → `#home` rendered.
2. Navigated to Brand > Optimization; default brand was Hulu (11003) → opened brand typeahead, typed "MTV" slowly, selected exact-match **MTV** from Results (not Recent Searches) → brand_id=4018 loaded with full data (Best Time/Day, Best Words Cloud, 20 Best Words/Hashtags/Emojis, Best Performing Content).
3. Opened **Filter: Select** dropdown → filter-type list shown (Branded Content / Collaborated / Collaborated Total / Collaborator Name / Content Type / Publish Day / Publish Time / Publish Type / Sponsor Name / **Tag** / Text Search).
4. Clicked **Tag** → sub-panel opened: **Include** (radio, checked by default) / **Exclude** radios, **Or | And** operator (disabled with 0–1 tags), Select All / None + tag checkbox list.
5. Selected Include tag **`jbkaxlx`** (Or default) → green pill "Tag: jbkaxlx" rendered; operators remained disabled (1 tag).
6. Switched radio to **Exclude** → the Include-selected `jbkaxlx` row became `option-row disabled` (pointer-events:none, opacity 0.38).
7. Selected Exclude tag **`+tag`** → second pill "Tag: +tag" rendered (`+tag` = Exclude; `jbkaxlx` = Include).
8. Clicked **Apply Filter** → URL gained `filters=` param; content tables re-fetched and emptied (0 in-window posts match the layered set).
9. Reopened Tag panel → with 1 Include tag operators were disabled; added a 2nd Include tag **`000`** → **Or/And operators became enabled**; verified toggle flips the selected indicator (`fa-dot-circle` ⇄ `fa-circle`).
10. Clicked **Clear All** → `filters` param removed, both pills cleared, dropdown reset to "Select", content tables repopulated to full unfiltered MTV data.

## URL `filters` encoding (Step 7, double-decoded)

```json
{"content_tags":[
  {"operator":"or","values":[" jbkaxlx"],"not":"false"},
  {"operator":"or","values":["+tag"],"not":"true"}
]}
```
Both an Include predicate (`not:"false"`) and an Exclude predicate (`not:"true"`) are encoded in the same `content_tags` array — matches the skill's documented layered encoding exactly.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2-3 | Tag popup Include/Exclude radios + Or/And operator + checkbox list present | Include radio (default checked) + Exclude radio; `edit-operator-button or`/`and`; Select All/None + tag list — all present | PASS |
| A2 | 5 | Include-selected tags become disabled when Exclude active | After switching to Exclude, `jbkaxlx` row = `option-row disabled`, pointer-events:none, opacity 0.38 | PASS |
| A3 | 7 | URL `filters` JSON encodes both Include and Exclude tag predicates | `content_tags` array carries `{jbkaxlx, not:false}` (Include) + `{+tag, not:true}` (Exclude) | PASS |
| A4 | 8 | Page contents update with layered filter semantics | Populated tables (20 Words / 12 Hashtags / 20 Emojis) emptied on Apply; repopulated to identical baseline on Clear All → contents driven by filter | PASS (data-limited: test tag has 0 in-window posts → empty set is expected) |
| A5 | 9 | Or with ≥2 Include tags enabled; with 1 tag disabled/no-op | 1 Include tag → Or/And `disabled`; 2 Include tags (jbkaxlx+000) → operators enabled; toggle flips `fa-dot-circle` indicator Or⇄And | PASS |
| A6 | 10 | Clear All resets all tag filters | Pills=[], dropdown="Select", `filters` param removed, tables restored (Best Words 20 rows, first "sabrinacarpenter 0.24%") | PASS |

## Evidence (screenshots, `.playwright-out/QA-134443/`)

- `01-mtv-optimization-loaded.png` — MTV Brand>Optimization baseline (unfiltered)
- `02-tag-panel-default-include.png` — Tag sub-panel, Include default + Or/And + list (A1)
- `03-exclude-active-include-greyed.png` — Exclude active, `jbkaxlx` greyed (A2)
- `04-two-pills-before-apply.png` — Include "jbkaxlx" + Exclude "+tag" pills before Apply
- `05-applied-layered-filter.png` — post-Apply state, tables emptied (A3/A4)
- `06-two-include-tags-operator-enabled.png` — 2 Include tags, Or/And enabled (A5)
- `07-clear-all-reset.png` — Clear All, filters reset + data restored (A6)

## Bugs filed

None. All assertions passed; no regression or defect observed. (Bugs recorded in this report only — no Jira tickets created.)
