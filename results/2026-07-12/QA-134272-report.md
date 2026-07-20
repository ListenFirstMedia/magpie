# QA-134272 — Brand > Content: Tag filter default state, Include OR/AND logic, same-tag greyed in opposite mode

- **Run:** 2026-07-12 (unattended, headless Playwright MCP, `app.lfmdev.in`)
- **Skill used:** `brand-content-filter` (v3, untrusted, streak 27) — reused, no drift
- **Account/Brand:** Adam Orfei (account_id=54) / **MTV** (brand_id=10765), Brand > Content, Public data, Jan 01–31 2026
- **Tags used:** `jbkaxlx` (1st) and `+tag` (2nd)
- **Verdict:** **PASS (10/10 assertions)**

## Preconditions
- Logged in via programmatic Cognito email/password (lfiqa) → `#home` rendered.
- Precondition "User logged in as Adam Orfei" satisfied by Adam Orfei account context (breadcrumb "Account: Adam Orfei").
- Precondition "Brand with at least 2 tags" satisfied by MTV (33+ tags in the Tag filter list).

## Steps executed
1. Navigated to Brand > Content for MTV/Adam Orfei (brand_id=10765). Brand header "MTV", account "Adam Orfei" confirmed.
2. Opened Filter dropdown (`.add-filters-btn-container` → "Select") → clicked **Tag** filter type (`.option-row` → `option-row selected`). Sub-panel `.dropdown.content-type-dropdown.add-filter` opened with Include/Exclude radios, Or/And operator buttons, Select All/None + tag-value list.
3. Probed default state (DOM): Include radio `checked=true`, Exclude `checked=false`; Or = `edit-operator-button or disabled` + `far fa-dot-circle`; And = `edit-operator-button and disabled` + `far fa-circle`.
4. Clicked 1st tag `jbkaxlx` → row `option-row selected` (checkbox `far fa-check-square`); Or/And **both still `disabled`**.
5. Clicked 2nd tag `+tag` → Or/And **both `disabled=false` (enabled)**; Or still `far fa-dot-circle` (selected), And still `far fa-circle`.
6. Clicked **Exclude** radio → Include `checked=false`, Exclude `checked=true`.
7. Verified the two Include tags (`jbkaxlx`, `+tag`) rendered as `option-row disabled` (pointer-events:none, opacity 0.38, colour rgb(165,165,165)) while an unrelated tag (`000`) stayed normal.
8. Flipped back to Include and clicked **Apply Filter** → filter pill rendered + URL `filters` JSON populated.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Default | Include selected by default; Exclude not | Include radio `checked=true`, Exclude `checked=false` | PASS |
| A2 | Default | Or selected by default but disabled until ≥2 tags | Or = `far fa-dot-circle` (selected) + class `disabled` | PASS |
| A3 | Default | And not selected, disabled | And = `far fa-circle` (unselected) + class `disabled` | PASS |
| A4 | After 1 tag | Or/And still disabled | Both `edit-operator-button … disabled` after selecting `jbkaxlx` | PASS |
| A5 | After 1 tag | Green pill renders for selected tag | In-panel row highlights + checkbox; applied **Include Or-chip `.or-label` bg `rgb(0,207,11)` (green)** confirmed after Apply | PASS |
| A6 | After 2nd tag | Or/And enabled | Both `disabled=false` after selecting `+tag` | PASS |
| A7 | After 2nd tag | Or still visually selected after enablement | Or icon remains `far fa-dot-circle`; And `far fa-circle` | PASS |
| A8 | Flip to Exclude | Include=false, Exclude=true | Include `checked=false`, Exclude `checked=true` | PASS |
| A9 | Exclude mode | Include's tags greyed (mutual-exclusivity) | `jbkaxlx` & `+tag` → `option-row disabled`, `pointer-events:none`, opacity 0.38; control tag `000` unaffected | PASS |
| A10 | Apply | Pill encodes operator + tags in URL `filters` JSON | URL `filters` decodes to `{"content_tags":[{"operator":"or","values":[" jbkaxlx","+tag"],"not":"false"}]}` | PASS |

### A10 URL evidence (double-decoded)
```
filters = {"content_tags":[{"operator":"or","values":[" jbkaxlx","+tag"],"not":"false"}]}
```
Raw: `filters=%257B%2522content_tags%2522%253A%255B%257B%2522operator%2522%253A%2522or%2522%252C%2522values%2522%253A%255B%2522%2520jbkaxlx%2522%252C%2522%252Btag%2522%255D%252C%2522not%2522%253A%2522false%2522%257D%255D%257D`

Applied pill text: `Tag: jbkaxlx [Or] +tag [Include]` (green Or-chip, Include toggle).

## Evidence / screenshots (`.playwright-out/QA-134272/`)
- `01-content-loaded.png` — MTV Brand>Content, Adam Orfei, Filter: Select.
- `03-tag-default-state.png` — Tag sub-panel open, default state.
- `04-one-tag-selected.png` — `jbkaxlx` selected, Or/And still disabled.
- `05-two-tags-orand-enabled.png` — `+tag` added, Or/And enabled.
- `06-exclude-greyed.png` — Exclude selected, two Include tags greyed.
- `07-applied-pill-url.png` — applied green Include pill `Tag: jbkaxlx Or +tag`.

## Known bugs checked
- **bug-history.md (QA-134272):** 0 open Bug/Test-Failure links; no closed defects tied to this case. Rule 7 screen passed → ran normally.
- Case file has no "## Open linked bugs" section (older cache format); bug-history is the authoritative screen → clean.
- No known quirk applies to this default-state/enablement/URL-encoding flow. The `Posts (0)` result is expected data-limitation (the chosen test-tags `jbkaxlx`/`+tag` have no in-window posts for Jan 2026) — documented in the `brand-content-filter` skill v3 note; it does not gate any A1–A10 assertion (all are widget-state/URL checks, not post-count checks).

## Bugs filed
None. All assertions pass; no new defects observed.
