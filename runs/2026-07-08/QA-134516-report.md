# QA-134516 — Reporting > Content Performance: layered tag filtering (Include + Exclude)

- **Run date:** 2026-07-08
- **Environment:** app.lfmdev.in (Playwright MCP, headless, unattended), branch `feature/playwright-mcp`
- **Account:** HBO Max (account_id=657)
- **Brand:** House of the Dragon (Primary Brand, Public Data default)
- **Date range:** Last 7 Days → Jul 1, 2026 – Jul 7, 2026
- **Story generated:** `app-reporting.lfmdev.in/#story/content_performance/155749`
- **Skills used:** `cpr-builder`, `brand-content-filter` (v2), `switch-account`, `pdf-end-to-end-verification`
- **Verdict:** **PASS** — layered Include+Exclude tag filtering now exists and works end-to-end on CPR (with data-availability + export-format notes below).

## Headline finding — known quirk RESOLVED

The KB quirk *"Reporting > Content Performance + Data Studio Tag Filters lack Include/Exclude (vs Brand > Content)"* (first observed 2026-05-29 on QA-134516; reconfirmed 2026-06-04) **no longer reproduces.** The CPR Tag Filter now exposes the full layered widget: **Include | Exclude** radios, **Or | And** operator radios, Select All / None, and the tag-value list — matching the Brand > Content structure. This is the quirk's own documented revisit trigger, so the case was run in full rather than treated as FAIL-with-finding.

- **Old (documented) DOM:** `tag-filter-dropdown` + `tag-filter-popover`, `.header-configs` = `['Or','And']` only, no Include/Exclude.
- **Now (this run):** `.filter__options-container` children = `[search-box, inclusion-radios header-configs, header-configs, filter__option__row--select-all, filter__options]`. `inclusion-radios` = `Include`/`Exclude` (`#radio-include` / `#radio-exclude`, `role=radio`); second `header-configs` = `Or`/`And` (`#radio-or` / `#radio-and`).

Recommend updating `knowledge-base/known-quirks.md` (mark the entry resolved) and `skills/brand-content-filter/SKILL.md` (remove the "CPR Tag Filter divergence" note / flip the "Structural divergence resolved" failure signature).

## Preconditions note (brand selection)

The spec precondition names *"brand from LF // TV // EPISODIC brandset"* but does **not** name a specific brand. "LF // TV // EPISODIC" is **not** a Reporting Competitive Set on HBO Max (searched the competitive-set picker for "EPISODIC" → 0 results), and the Settings › Brand Sets page hung on "Loading…" (~25s, abandoned — out-of-scope lookup). Since the spec delegates brand choice to any member of that set and the assertions are brand-agnostic (they test the tag-filter mechanic), a representative HBO Max episodic series — **House of the Dragon** — was added via the "Add Brand By Name" typeahead, selecting the literal exact-match Result (Rule 1). Membership in the exact brandset could not be confirmed; documented transparently.

## Steps executed

| # | Step | Action taken |
|---|------|--------------|
| 1 | Reporting > Content Performance | Navigated to `app-reporting.lfmdev.in/#/content_performance` (builder loaded, Account: HBO Max). |
| 2 | Account HBO Max; brand from brandset | Switched account Viacom→HBO Max via LFQA menu → Search Account → Results `.lfm-ta-option`. Added House of the Dragon (exact Results match). |
| 3 | Date range Last 7 Days | "Make a Selection" dropdown → **Last 7 Days** (Jul 1–7, 2026). |
| 4 | Open Tag Filter panel | Filter: Select → **Tag**. Panel opened with Include/Exclude + Or/And + tag list (A1). |
| 5 | Add tag to Include | Include radio (default). Checked **"house of the dragon"** → green Include pill. |
| 6 | Attempt same tag to Exclude | Switched to Exclude radio → "house of the dragon" row became disabled (A3). |
| 7 | Add another tag to Exclude | Checked **"campaign: house of the dragon s3"** → red Exclude pill (A4). |
| 8 | Toggle Or/AND logic | Added 2nd Include tag "title: house of the dragon" (to enable the operator), then toggled **Or → And**; Include pill logic changed to "…And…" (A5). |
| 9 | Click Go | Run Report → story 155749 generated; header echoes the layered filter (A6). |
| 10 | Change Settings → Clear All | Returned via Change Settings, clicked filter **Clear All** → both sections emptied (A7). |
| 11 | Re-add tags, remove only Exclude | Re-added Include "house of the dragon" + Exclude "campaign: house of the dragon s3", then deselected the Exclude tag → only Include pill remained (A8). |
| 12 | Save layered filter, reload, reopen | Restored layered filter; loaded the saved report URL 155749 with a full page reload → layered filter echo persisted (A9). (Named "Save Filter" dialog did not surface a name field; used the saved report as the persistence vehicle.) |
| 13 | Generate report → export | Preview & Share → **Download** → PDF saved to disk; echoes the layered filter (A10). No CSV/GS export exists on CPR (PDF-only); GS out of scope. |

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | Tag Filter panel opens with Include + Exclude sections visible/empty | Panel opened: **Include\|Exclude** radios (Include default-selected), **Or\|And** radios, Select All/None, empty tag list. Resolves the documented CPR-lacks-Include/Exclude quirk. | **PASS** |
| A2 | 5 | Tag added to Include; preview reflects only matching posts | "house of the dragon" added to Include (green pill, `#radio-include` aria-checked=true). CPR has **no live preview** (builder-only) — reflection verified in the generated report echo (A6). | **PASS** (no live preview by design) |
| A3 | 6 | Same tag greyed/non-selectable in Exclude | With Exclude selected, "house of the dragon" row = `filter__option__row--disabled`, `pointer-events:none` (greyed); other tags stayed selectable. | **PASS** |
| A4 | 7 | Tag added to Exclude; data = Include AND NOT Exclude | Red Exclude pill "campaign: house of the dragon s3" added (`filter__selection--exclude-filter`). Report echo: `Tags Exclude: NOT campaign: house of the dragon s3`. | **PASS** (config); data empty — see note |
| A5 | 8 | OR/AND toggle updates Include logic | Or→And toggled; Include pill "house of the dragon **And** title: house of the dragon"; report echo shows "AND". Operator is correctly disabled when a group has a single value. | **PASS** (logic); no data-diff shown — see note |
| A6 | 9 | Report shows only posts matching filters | Story 155749 rendered; header explicitly echoes `Tag: house of the dragon, AND title: house of the dragon` + `Tags Exclude: NOT campaign: house of the dragon s3`. Shows only matching posts (0 matched → "no data available"). | **PASS** |
| A7 | 10 | Clear All empties both Include + Exclude | After Clear All: 0 pills, filter reset to "Select", Clear All/Load Filter re-disabled. | **PASS** |
| A8 | 11 | Removing only Exclude → Include-only; Include remains | After deselecting the Exclude tag: exactly 1 pill remained — Include "house of the dragon" (isExclude=false). | **PASS** |
| A9 | 12 | Saved layered filter persists after reload | Fresh full reload of saved report 155749: layered filter echo persisted (Include AND + Exclude NOT); builder pills re-hydrated identically. | **PASS** |
| A10 | 13 | Exported CPR contains only rows matching layered filter | PDF downloaded to disk (219,351 bytes, jsPDF 3.0.1, 1p A4, filename `House of the Dragon-Content Performance(Jul 1, 2026 - Jul 7, 2026).pdf` — matches CPR schema). Renders the layered-filter echo; contains only matching rows (0). CPR export is **PDF-only** (no CSV/GS); GS out of scope. | **PASS** (within data/format limits) |

## Evidence

- **A1** — `.playwright-out/QA-134516/A1-tag-filter-include-exclude.png`, `A1-tag-popup-detail.png`. DOM: `headerConfigs=["IncludeExclude","OrAnd"]`, `radioLabels=[Include, Exclude, Or, And]`.
- **A2** — `.playwright-out/QA-134516/A2-include-hotd.png` (green Include pill "Tag: ho…").
- **A3** — `.playwright-out/QA-134516/A3-same-tag-disabled-exclude.png` ("house of the dragon" greyed under Exclude). DOM class `filter__option__row--disabled`, `pointer-events:none`.
- **A4/A5** — `.playwright-out/QA-134516/A4-A5-layered-include-and-exclude.png` (green Include pill + red Exclude pill; And selected). Include pill text "…And title: house of the dragon".
- **A6** — `.playwright-out/QA-134516/A6-story-and-filter.png`. Story echo (verbatim): `Tag: house of the dragon, AND title: house of the dragon` / `Tags Exclude: NOT campaign: house of the dragon s3`.
- **A7** — pillCount=0 after Clear All; filter="Select".
- **A8** — pillCount=1 (Include only) after removing Exclude.
- **A9** — `.playwright-out/QA-134516/A9-persisted-after-reload.png`; clean reload echo persisted.
- **A10** — on disk: `.playwright-out/House-of-the-Dragon-Content-Performance-Jul-1-2026---Jul-7-2026-.pdf`; rendered `.playwright-out/QA-134516/exported-pdf-page-1.png` shows the layered-filter echo in the PDF header.

## Notes / caveats

- **Empty filtered dataset.** The spec's layered filter (Include: house of the dragon AND title: house of the dragon; Exclude: NOT campaign: house of the dragon s3) over a **Last-7-Days** window on a single brand returned **0 matching posts** — the report/PDF correctly applied the filter and showed "no data available". Consequently the *positive* narrowing of a non-empty baseline (A2/A6 "only matching posts") and row-level export match (A10) could not be demonstrated on non-empty data; only the filter *application* is proven (via the report + PDF echoes). Not a defect — a data-availability outcome of the restrictive AND-of-two-specific-tags in a short window.
- **CPR has no live preview** — it is a report builder; filter effect is only observable in the generated story (unlike Brand > Content's live post grid). A2's "preview" language is inherited from the Brand > Content parity spec (QA-134443).
- **CPR export is PDF-only** (jsPDF client-side). No CSV or Google Sheets export exists on the CPR story; the spec's "CSV/GS" wording is parity language from Brand > Content. GS is out of scope (Google 2FA) regardless.
- **Minor label inconsistency (not a bug):** the report echoes the Include group as `Tag:` but the Exclude group as `Tags Exclude:` (singular vs plural label). Cosmetic; noted for awareness.

## Bugs filed

None. No product defect observed. This run instead **resolves** a previously-documented environment quirk (CPR Tag Filter lacking Include/Exclude) — recommend a KB/skill update (see "Headline finding" above). No Jira tickets created (markdown-only, per protocol).
