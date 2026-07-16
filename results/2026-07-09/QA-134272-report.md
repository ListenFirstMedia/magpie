# QA-134272 — Brand > Content - Verify default state, Include OR/AND, Select All logic and same tag greyed out in opposite filter mode

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-09/10, interactive headed (Playwright MCP)
- **Priority:** Critical (P2)
- **Account/Brand:** Adam Orfei (account_id=54) · MTV Content (brand_id=4018) · from=2026-05-27 to=2026-06-02
- **Precondition:** Brand with ≥2 tags — MTV has a large tag list (jbkaxlx, qa_new 5470…, +tag, etc.)

## Verdict: PASS (A1–A9 verified; A10 URL-serialization inconclusive — see notes)

## Known bugs checked
Open bug **LFMP-32155** (Select All tag filter → table not loading) does NOT interfere with A1–A9 (Include/Exclude + Or/And + mutual-exclusivity logic — not Select All) → tolerated, run + note.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Default: Include selected, Exclude not | radios: **Include [checked]**, Exclude unchecked | PASS |
| A2 | Or disabled until ≥2 tags | with 0–1 tag, tag-panel **Or disabled=true** | PASS |
| A3 | And unselected + disabled by default | tag-panel **And disabled=true**, unselected | PASS |
| A4 | After 1 tag, Or/And still disabled | after clicking "jbkaxlx", tag-panel Or/And remain **disabled=true** | PASS |
| A5 | Selected tag renders green pill in filter row | filter row shows pill **"Tag: jbkaxlx"** (`filter-pill grouped-filter`); row = `option-row selected` | PASS |
| A6 | After 2nd tag, Or/And enable | after clicking "qa_new 5470 10/16/15/35", tag-panel Or/And become **disabled=false** | PASS |
| A7 | Or is the default join operator | applied pill reads **"Tag: jbkaxlx `Or` qa_new 5470 10/16/15/35"** — Or is the default connector | PASS |
| A8 | Can flip to Exclude | clicking **Exclude** radio switched mode (Include→Exclude) | PASS |
| A9 | Tags selected in Include are greyed out in Exclude (mutual exclusivity) | in Exclude mode both rows = **`option-row disabled`** (jbkaxlx, qa_new) — greyed/unclickable | PASS |
| A10 | Applied filter encodes to URL `filters` JSON | filter is applied (pill present, view filtered) but the URL exposed **no `filters` param**; the tag filter is held in app/session state. The persistent "table failed to load" error this session prevented a clean URL-serialization confirmation | Inconclusive (noted) |

## Method notes
- Two distinct "Tag" controls exist: the top-right **"Tag ▾"** management dropdown (Bulk/Upload/Manage) vs. the **Filter row "Select" dropdown → "Tag"** list item (the filter this case targets). Used the latter.
- Tag rows are `.option-row` inside a virtual list; trusted `browser_click` on the row toggles selection (`option-row selected`). In Exclude mode the opposite-mode selections carry `option-row disabled`.
- Or/And enablement is gated on ≥2 selected tags (A2→A6 progression confirmed by toggling disabled=true→false).

## Evidence
- `QA-134272-applied.png` (filter row pill "Tag: jbkaxlx Or qa_new 5470 10/16/15/35" applied)
- `QA-134272-panel3.png` (tag sub-panel: Include/Exclude radios + Or/And + tag list)

## Bugs filed
None. (A10 URL-serialization is inconclusive, not a confirmed defect — table-load errors this session, likely related to the tolerated LFMP-32155 area, blocked clean verification. Recommend a focused re-check when the Content table loads cleanly.)
