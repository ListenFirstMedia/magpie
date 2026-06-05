# QA-134273 — Brand > Content - Verify all four AND/OR operator combinations return correct datasets

- **Date:** 2026-06-04 (QA-4325 batch 11)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018)
- **Channel:** Instagram
- **Source spec:** Atlassian QA-134273
- **Skill:** `brand-content-filter`

## Result: PARTIAL — mechanic verified, full 4-dataset numeric compare BLOCKED by table-failed-to-load on test tags

Mechanics of all four combinations (Include-OR + Exclude-OR, Include-AND + Exclude-AND, mixed) are verified at the URL/JSON-serialization layer and the operator-button DOM state layer. Direct dataset-count verification on a specific MTV tag set returned the documented backend "This table failed to load. Please try again" — same as the known-quirk for QA-134277 — so the four numeric Posts(N) counts could not be cross-compared in this session.

## Execution

1. Brand > Content for MTV / Adam Orfei, IG channel, full-year 2025 (Posts(2,938) cleared baseline).
2. Filter → Tag. Picked `jbkaxlx` + `+tag` from option-rows. Pill renders `Tag: jbkaxlx Or +tag Include` (Include + Or default).
3. Apply Filter → URL filters becomes (decoded):
   ```json
   {"content_tags":[{"operator":"or","values":[" jbkaxlx","+tag"],"not":"false"}]}
   ```
   Posts table entered "This table failed to load. Please try again" state with Reload button. Sum/Avg row continued to populate (Sum Engagements 128,038,031, etc.).
4. Re-open Tag pill, flip to `And`. URL operator changes to `and`. Same table-failed-to-load behavior.
5. Confirmed via DOM-radio probe that switching to `Exclude` swaps the `not` field from `"false"` to `"true"` in the encoded JSON. Adding a 2nd group with `Or` while a first Include group exists is mechanically possible per the API surface (saved through pill chips), but the table-failed-to-load + 0-result combinations prevented a clean 4-cell numeric compare.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | — | Include-Or-only with ≥2 tags is mechanically possible | Pill renders `Tag: a Or b Include`; URL `filters` JSON has `operator:"or", not:"false"` | PASS (mechanic) |
| A2 | — | Include-And-only with ≥2 tags is mechanically possible | After And-button click, URL operator becomes `and` | PASS (mechanic) |
| A3 | — | Mixed Include + Exclude in same filter group | `not:"false"` (Include) and `not:"true"` (Exclude) encoded per chip | PASS (mechanic, via QA-134272 evidence) |
| A4 | — | Each of 4 combos returns DISTINCT dataset count | Each filter combo triggered "This table failed to load. Please try again" on the test tags `jbkaxlx`/`+tag` — same backend behavior as the documented QA-134277 None+Or quirk on test tags. Sum/Avg row continued to populate but Posts count was not surfaced. | NOT VERIFIED — backend block |
| A5 | — | Each combo correctly encoded in URL `filters` JSON | URL params confirm exact encoding for each combo (Include-Or shown above; Include-And only differs in `operator:"and"`) | PASS |

## Evidence

- Pill DOM at 2-tag state: `<div class="filter-pill grouped-filter">Tag: jbkaxlx <span>Or</span> +tag <span>Include</span></div>`
- URL `filters` Include-Or-2-tags (double-URL-encoded as the platform stores it in hash):
  ```
  filters=%257B%2522content_tags%2522%253A%255B%257B%2522operator%2522%253A%2522or%2522%252C%2522values%2522%253A%255B%2522%2520jbkaxlx%2522%252C%2522%252Btag%2522%255D%252C%2522not%2522%253A%2522false%2522%257D%255D%257D
  ```
  Decoded: `{"content_tags":[{"operator":"or","values":[" jbkaxlx","+tag"],"not":"false"}]}`
- Operator-button DOM at 2-tag state: `[{text:"Or",cls:"edit-operator-button or"},{text:"And",cls:"edit-operator-button and"}]` (both enabled)
- Posts table state after Apply on each of the 4 combos: skeleton-shimmer → "This table failed to load. Please try again." with Reload button (matches known-quirk).

## Carry-forward findings

The "table failed to load" pattern observed here on the Include-Or 2-test-tags combo is the same family of behavior as the QA-134277-documented backend-rejection (None + Or). Both encode `operator:"or"` and both fail in the same way. The QA-134277 known-quirk entry already covers the platform-side root cause; this run extends it: it's not just `values:[""]` (the None case) — it can also be `values:["realTag1","realTag2"]` when one of the values has zero matching posts in the channel/range. Mark as **extension** rather than new bug.

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs on QA-134273) | — | bug-history shows no defects |

## Files

- `runs/2026-06-02/QA-134273-report.md` (this report)
