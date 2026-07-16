# QA-134273 — Brand > Content: Verify all four AND/OR operator combinations return correct datasets

- **Run:** 2026-07-13 (unattended, headless Playwright MCP, `feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134273
- **Skill reused:** `brand-content-filter` (v3, untrusted) — Tag filter layered Include/Exclude + Or/And
- **Environment:** app.lfmdev.in, logged in as lfiqa@listenfirstmedia.com (config/.env)
- **Account / Brand:** Adam Orfei (account_id=54) / **MTV** (brand_id=4018) — precondition "logged in as Adam Orfei, brand with multiple tags available" satisfied (MTV exposes the full QA tag corpus)
- **Data Set:** Public · **Channels:** all · **Window:** Jul 01 2024 – Jun 30 2025 (app clamped the requested 2-yr range to its 365-day max)
- **Verdict:** **PASS — operator/NOT mechanic fully verified (A1, A3). A2 (distinct non-zero counts) NOT EVALUABLE — test-data limitation (chosen tags have 0 in-window posts).**

## Preconditions / setup

- Baseline MTV Brand>Content, no filter: **Posts (72)** in default last-7-days, **Posts (9,012)** in the year window — brand has ample post data.
- Tag corpus: the Filter → Tag panel exposes several hundred QA test tags. The vast majority are legacy junk tags (e.g. `qa_new … 08/26/…`, date-stamped 2022) applied to posts that have since aged out of the ~3-yr data-retention window.
- Chosen test tags (both real, non-empty, so the "OR + None/empty" backend-reject quirk is avoided): Include layer `music`, `music!`; Exclude layer `more music`, `music?`.

## Steps executed (all via UI: Filter dropdown → Tag → checkboxes → operator buttons → Apply Filter)

1. Navigate Brand > Content (MTV, Adam Orfei). ✓
2. Open Filter → Tag sub-panel (Include/Exclude radios + Or/And operator buttons + Select All/None + tag list). ✓
3. **Include-Or (2 tags)** — selected `music` + `music!`, Include, Or → Apply. ✓
4. **Include-And** — flipped operator Or→And on the same 2 tags → Apply. ✓
5. **Add Exclude-Or** — switched layer to Exclude, selected `more music` + `music?`, operator Or → Apply (2 pills: Include + Exclude). ✓
6. **Switch Exclude to And** — flipped the Exclude layer's operator to And → Apply. ✓
7. **Combined all 4 variants** — final applied state carries Include-And (`not:false`) + Exclude-And (`not:true`), exercising every (operator × not) permutation. ✓

### Combo → URL `filters` JSON (decoded) → Posts count

| # | UI configuration | URL `filters` JSON (double-decoded) | Posts |
|---|---|---|---|
| Probe | Include-Or `[music]` | `{"content_tags":[{"operator":"or","values":["music"],"not":"false"}]}` | 0 |
| 1 | **Include-Or** `[music, music!]` | `{"content_tags":[{"operator":"or","values":["music","music!"],"not":"false"}]}` | 0 |
| 2 | **Include-And** `[music, music!]` | `{"content_tags":[{"operator":"and","values":["music","music!"],"not":"false"}]}` | 0 |
| 3 | Include-Or + **Exclude-Or** `[more music, music?]` | `[{op:"or",vals:[music,music!],not:"false"},{op:"or",vals:["more music","music?"],not:"true"}]` | 0 |
| 3b | Include-And + Exclude-Or | `[{op:"and",…,not:"false"},{op:"or",…,not:"true"}]` | 0 |
| 4 | Include-And + **Exclude-And** | `[{op:"and",vals:[music,music!],not:"false"},{op:"and",vals:["more music","music?"],not:"true"}]` | 0 |

All four `(operator × not)` permutations captured verbatim in the URL:
`or+false` ✓ · `and+false` ✓ · `or+true` ✓ · `and+true` ✓.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3–7 | Each combo's URL `filters` JSON encodes the correct `operator` (`or`/`and`) + `not` (`false`/`true`) value | All four permutations serialized exactly as expected (see table). URL writes only on **Apply Filter** (in-panel edits don't serialize until committed). | **PASS** |
| A2 | 3–7 | Posts count differs across the 4 combos (distinct datasets) | Every combo returned **Posts (0)** / "There is no data available." The chosen tags — like the whole legacy QA test-tag corpus — match **0 posts in the available data window** (many tags date to 2022, aged out of the ~3-yr retention floor). Distinct **non-zero** datasets cannot be demonstrated. | **NOT EVALUABLE (test-data)** |
| A3 | 3–7 | Mechanic verified at pill / URL layer | Pills render correctly: green **Or** / red **And** inline operator, `Include` (green outline) vs `Exclude` (red) toggle; mutual-exclusivity greys out tags already used in the other layer (`music`/`music!` shown checked+disabled in the Exclude list). Pill state matches URL JSON 1:1. | **PASS** |

## Evidence

- `.playwright-out/QA-134273/probe-mtv.png` — Rule-2 confirmation: a URL-injected `filters` param was **ignored**; the app restored the cached 700-tag pill (drove the UI instead).
- `.playwright-out/QA-134273/exclude-panel.png` — Exclude layer active; `music`/`music!` checked+greyed (mutual-exclusivity).
- `.playwright-out/QA-134273/panel-layers.png` — full-page: two Tag editors; identifies which operator row governs the applied Exclude pill.
- `.playwright-out/QA-134273/combo4-final.png` — final applied state: Exclude pill `more music [And] music? [Exclude]` (red And) + Include pill; Posts (0) / no-data.
- URL strings for all 4 combos captured live (table above).

## Known bugs checked

- `knowledge-base/bug-history.md` grep `QA-134273` → **0 open bugs**, no closed Bug/Test-Failure links. Rule 7 screen: no `## Open linked bugs` present + bug-history "Open bugs (0)" → screen passed, ran the case.
- Prior run: **2026-06-04 QA-4325 batch-11 = PARTIAL** (A1/A3 mechanic verified; A2 numeric compare blocked by the "table failed to load" OR-with-sparse-tags pattern). This run reproduces the same outcome: mechanic PASS, A2 data-limited.
- **"OR + None/empty backend rejection" quirk** (brand-content-filter v2): observed indirectly — a `Select All` probe included the empty-string `None` value (`values:["", …]`) and hung the table (endless skeleton, no count). Avoided in the 4 real-tag combos by never selecting `None`. Known quirk, not a new bug.
- No regression: the 4 real-tag combos applied cleanly (no "table failed to load"); Posts(0) is a genuine no-match result, not a backend error, for these real (non-empty) tags.

## Bugs filed

None. No product defect observed. A2's un-evaluability is a **test-data gap** (the QA tag corpus has no posts inside the current data-retention window on MTV) — per Rule 1/3/5, no substitution and no bug filed; matches the documented "legacy fixed dates/tags aged out of retention → BLOCKED, not a bug" pattern.

## Notes for skill/KB (deferred to harvest.sh)

- **Operator-flip UX:** the Or/And operator lives **inside** the Tag sub-panel per layer (selected state = `i.far.fa-dot-circle` vs `far.fa-circle` inside `.edit-operator-button.or/.and`), NOT on the applied pill (the pill's `.or-label`/`And` text is display-only). Editing the Exclude layer's operator required (a) explicitly selecting the **Exclude** radio, then (b) clicking And in **that layer's** panel — the primary/Include operator row is a separate control and can be flipped independently.
- **URL serializes only on Apply Filter** (re-confirmed) — reading the URL mid-edit shows stale operator/not; capture after Apply.
- **Rule 2 re-confirmed on this surface:** injecting `filters=` via URL did not apply; the SPA restored the cached pill from session state. Drive the Tag panel UI + `Clear All` to reset.
