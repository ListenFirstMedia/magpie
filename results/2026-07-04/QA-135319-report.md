# QA-135319 — Brand > Content: Tag filter defaults, Include/Exclude interaction, filter removal

- **Run date:** 2026-07-04
- **Track:** Playwright MCP (headless, unattended), `feature/playwright-mcp`
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-135319
- **Skill reused:** `brand-content-filter` (v2)
- **Account / Brand:** Hulu (account_id=336, brand_id=5670) — spec brand HULU exact match (Rule 1)
- **Perspective:** Authorized (`perspective=extended`) — not material to these UI-default assertions
- **Date range:** Jun 26 – Jul 02, 2026 (default 7-day)
- **Verdict:** **PASS (10/10)**

## Pre-flight
- Navigated to `app.lfmdev.in` → redirected to Cognito hosted UI.
- Filled the "With existing account" form (`lfiqa@listenfirstmedia.com`) and clicked that form's Sign in.
- `oauth_callback` → `#home`, title "Home - ListenFirst". Account already resolved to **Hulu** (account_id=336). Pre-flight OK.

## Preconditions
- User logged in as HULU — **met** (account Hulu, favorite brand Hulu present on Home).
- 3–4 posts tagged — **met**: Tag filter list surfaced many existing Hulu tags (`#1 streaming premiere`, `#90s4eva`, `#aapiheritageheroes`, `#acmawards`, …). No tag add/cleanup needed.
- Baseline **Posts (121)** before any filter interaction.

## Steps executed
1. Go to Brand > Content (via Home → "Brand Content" suggested view; opened Hulu Brand>Content).
2. HULU brand selected (header "Hulu", brand_id=5670).
3. Opened Filter dropdown (`Filter: Select`).
4. Chose **Tag** filter type.
5. Observed default Tag panel state (before adding any tag).
6. Clicked **Exclude** radio.
7. Clicked **Include** radio again.
8. Selected TAG_1 = `#1 streaming premiere` as **Include**.
9. Switched radio to Exclude, selected TAG_2 = `#90s4eva` as **Exclude**.
10. Hovered the **Exclude** pill (`#90s4eva`) → clicked the hover **remove** button.
11. Observed page/results after removal.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5a | Include selected by default; Exclude not selected | Include radio `checked=true`, Exclude `checked=false`; Include filled blue, Exclude empty (screenshot 04/05) | PASS |
| A2 | 5b | OR selected by default but disabled until >1 tag selected | `Or` shows filled-but-greyed selected dot; both operator buttons `edit-operator-button … disabled` (color rgb(165,165,165)) with 0 tags (screenshot 05) | PASS |
| A3 | 5c | User cannot select AND until ≥2 tags selected | `And` button `edit-operator-button and disabled`, greyed/unselectable (screenshot 05) | PASS |
| A4 | 6 | Exclude now selected; Include unselected | After Exclude click: Exclude `checked=true`, Include `checked=false`; Exclude filled blue (screenshot 06) | PASS |
| A5 | 7 | Include selected again; Exclude unselected; smooth toggle | After Include click: Include `checked=true`, Exclude `checked=false`; toggled cleanly (screenshot 07) | PASS |
| A6 | 8a | Include remains selected by default; Exclude not | After selecting TAG_1: Include `checked=true`, Exclude `checked=false` | PASS |
| A7 | 8b | OR remains selected by default; AND not | Operator buttons still `or disabled` / `and disabled` — OR default retained, AND not selected (1 tag only) | PASS |
| A8 | 8c | Green filter pill for TAG_1 (Include) in active filters | Pill `Tag: #1 streaming premiere`, `.filter-selection` bg `rgb(229,252,241)` / border `rgb(76,237,159)` = green (screenshots 08b, 09c) | PASS |
| A9 | 9 | TAG_2 as red filter pill (Exclude) | Pill `Tag: #90s4eva`, `.filter-selection.exclude-filter` bg `rgb(252,229,229)` / border `rgb(236,76,76)` = red, Exclude toggle on (screenshot 09c) | PASS |
| A10 | 11 | Removing Exclude filter does not impact page or results (not yet applied) | After remove: Exclude pill gone (count 0); **Posts (121) unchanged**; URL has **no `filters=` param** (never applied); Include pill `#1 streaming premiere` still present (screenshot 11) | PASS |

## Evidence
- Baseline pre-filter count: **Posts (121)**; post-removal count: **Posts (121)** (no change).
- URL carried **no `filters=`** parameter at any point → confirms the tag selections were staged in the panel, never Applied (consistent with A10 "not yet applied").
- Include pill green RGB: bg `rgb(229,252,241)`, border `rgb(76,237,159)`.
- Exclude pill red RGB: bg `rgb(252,229,229)`, border `rgb(236,76,76)` (matches documented exclude-red ≈ rgb(235,64,64)).
- Screenshots under `.playwright-out/QA-135319/`:
  - `00-home.png` — Home (account Hulu)
  - `01-brand-content.png`, `02-posts-loaded.png` — Hulu Brand>Content, Posts (121)
  - `03-filter-dropdown.png` — Filter type list (Tag present)
  - `04-tag-panel-default.png`, `05-tag-panel-zoom.png` — A1/A2/A3 defaults (Include + Or selected, And disabled)
  - `06-exclude-selected.png` — A4
  - `07-include-reselected.png` — A5
  - `08-tag1-green-pill.png`, `08b-tag1-green-pill.png` — A8 green pill
  - `09-both-pills.png`, `09b-pills-row.png`, `09c-pills.png` — A8+A9 green + red pills
  - `10-exclude-hover-remove.png` — A10 hover state
  - `11-after-exclude-removed.png` — A10 result (Exclude gone, Posts 121, Include remains)

## Notes
- Google Sheets: not applicable (no GS step in this case).
- Tag panel operator buttons render as `.edit-operator-button` (Or/And), not radio inputs; disabled state = class `disabled` + grey text `rgb(165,165,165)`. Include/Exclude are `<input type=radio>`.
- Pills render as grouped chips (`.filter-pill-container` → `.filter-selection`) within the Tag dropdown panel; they carry a per-pill Include/Exclude toggle and a hover-revealed `.remove-filter-button-container` remove button. Removal here confirmed instant and side-effect-free because no Apply Filter occurred.

## Bugs filed
None. All 10 assertions passed; behavior matches spec.
