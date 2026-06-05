# QA-134272 — Brand > Content - Verify default state, Include OR/AND logic and same tag greyed out in opposite filter mode

- **Date:** 2026-06-04 (QA-4325 batch 11)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018)
- **Channel:** Instagram
- **Source spec:** Atlassian QA-134272 + parity with QA-135319/QA-135321 specs
- **Skill:** `brand-content-filter`

## Result: PASS

All four assertion families confirmed via direct DOM-state probes on the Brand>Content Filter → Tag sub-popup.

## Execution

1. Navigate to Brand > Content for MTV / Adam Orfei, IG channel, 7-day window.
2. Click Filter dropdown → Tag. Sub-popup opens.
3. Probe DOM via `javascript_exec`:
   ```js
   document.querySelectorAll('input[type=radio]');
   document.querySelectorAll('.edit-operator-button');
   ```
4. Click tag #1 `jbkaxlx` from the option-row list → green pill `Tag: jbkaxlx` (Include).
5. Re-probe operators: both `Or` and `And` still carry `disabled` class (need ≥2 tags).
6. Click tag #2 `+tag` from list → 2nd green-pill chip appended.
7. Re-probe operators: both `Or` and `And` NOW lack `disabled` class — enabled exactly when ≥2 tags selected.
8. Click Exclude radio → state flips to Exclude=true, Include=false.
9. Re-probe option-rows: `jbkaxlx` row → `option-row disabled`; `+tag` row → `option-row disabled` (both greyed out in Exclude because they're already in Include).
10. Clicked Include radio to flip back.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5a | Include selected by default; Exclude not selected | `Include` input radio `checked=true`, `Exclude` input radio `checked=false` | PASS |
| A2 | 5b | Or selected by default but disabled until >1 tag | `.edit-operator-button.or` class = `edit-operator-button or disabled`, `<i class="fa-dot-circle">` (visually selected) | PASS |
| A3 | 5c | And not selected, disabled | `.edit-operator-button.and` class = `edit-operator-button and disabled`, `<i class="fa-circle">` (unselected) | PASS |
| A4 | 7a | After 1 tag added (Include), Or/And still disabled | After click `jbkaxlx`: classes still `… or disabled` / `… and disabled` | PASS |
| A5 | 7b | After 1 tag added, green pill appears | `.filter-pill grouped-filter` containing `Tag: jbkaxlx` rendered (Include color) | PASS |
| A6 | 8a | After 2nd tag, Or/And enabled | After click `+tag`: classes = `edit-operator-button or` / `edit-operator-button and` (no `disabled`) | PASS |
| A7 | 8b | Or still visually selected by default | Or button retains `fa-dot-circle` (selected) post-enablement | PASS |
| A8 | 9 | Switching to Exclude: Include=false, Exclude=true | After radio click: Include checked=false, Exclude checked=true | PASS |
| A9 | 10 | Tags in Include greyed in Exclude (mutual-exclusivity) | `jbkaxlx` row class = `option-row disabled`; `+tag` row class = `option-row disabled` (greyed out, cannot be selected on Exclude) | PASS |
| A10 | — | Pill encodes operator + tags in `filters` URL | URL `filters=%7B%22content_tags%22%3A%5B%7B%22operator%22%3A%22or%22%2C%22values%22%3A%5B%22%20jbkaxlx%22%2C%22%2Btag%22%5D%2C%22not%22%3A%22false%22%7D%5D%7D` matches expected JSON shape | PASS |

## Evidence

- DOM probe results:
  - Default operator probe: `ops:[{text:"Or",cls:"edit-operator-button or disabled",hasDot:true},{text:"And",cls:"edit-operator-button and disabled",hasCircle:true}]`
  - 1-tag state operator probe: same as default (both disabled)
  - 2-tag state operator probe: `[{text:"Or",cls:"edit-operator-button or"},{text:"And",cls:"edit-operator-button and"}]` — no `disabled` class
  - Exclude-mode option-row probe (for added tags): `jbkaxlxCls:"option-row disabled"`, `ptCls:"option-row disabled"`
- Pill text after 2 tags + Apply: `Tag: jbkaxlx Or +tag Include`
- URL `filters` parameter (double-URL-encoded): `%257B%2522content_tags%2522%253A%255B%257B%2522operator%2522%253A%2522or%2522%252C%2522values%2522%253A%255B%2522%2520jbkaxlx%2522%252C%2522%252Btag%2522%255D%252C%2522not%2522%253A%2522false%2522%257D%255D%257D`

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs on QA-134272) | — | bug-history shows no defects |

## New findings

None — behaviors match spec exactly. The Or-disabled-with-1-tag and the Include/Exclude greyed-out-in-opposite-mode patterns are stable.

## Files

- `runs/2026-06-02/QA-134272-report.md` (this report)
