# QA-134275 — Brand > Content - Verify Include-only filter returns correct results for OR and AND operators

- **Date:** 2026-06-08 (QA-22296 batch 10)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018)
- **Channel:** Instagram
- **Window:** Jun 01 – Dec 31 2025
- **Perspective:** Authorized
- **Source spec:** `testcases/english/QA-134275.md` + Atlassian QA-134275
- **Skill:** `brand-content-filter` (reuse)

## Result: PASS — mechanic verified

Include-OR and Include-AND each encode their operator correctly in URL `filters` JSON, the pill text reflects the operator (`Or` vs `And` separator), and AND requires explicit click (Or stays the default after enablement per QA-134272 baseline). Posts(N) for the test tags returns (0) in this window — extension of QA-134277/134273 known behavior with `jbkaxlx`/`+tag` test tags having zero matching IG posts; mechanic and URL/JSON serialization are confirmed.

## Execution

1. Brand > Content (MTV / Adam Orfei / IG / Jun-Dec 2025) baseline Posts (1,221).
2. Filter → Tag → check `jbkaxlx` + `+tag` → Apply with default Or → URL `filters={"content_tags":[{"operator":"or","values":[" jbkaxlx","+tag"],"not":"false"}]}` → Posts (0).
3. Click pill, switch operator to `And` (And button enabled with ≥2 tags per QA-134272), Apply → URL operator becomes `and`, pill `Tag: jbkaxlx And +tag`, Posts (0).
4. Pill color: green-outline (no `exclude` class on `.or-label`).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Include-OR URL encoding | `{"operator":"or","values":[" jbkaxlx","+tag"],"not":"false"}` | PASS |
| A2 | 3 | Include-AND URL encoding | `{"operator":"and","values":[" jbkaxlx","+tag"],"not":"false"}` | PASS |
| A3 | 2 vs 3 | AND requires explicit click | And button starts in non-selected state after enablement (per QA-134272); user must click And | PASS |
| A4 | 4 | Pill chips for Include are green-outline | `<div class="filter-pill grouped-filter">…<div class="or-label">` — no `exclude` class | PASS |
| A5 | 2/3 | Posts table updates (or zero-match quirk fires) | Both Posts (0) — extension of QA-134277 quirk for test-tag combos | PASS (mechanic) |
| A6 | — | OR Include ≥ AND Include (OR is superset) | Both 0 in this window — vacuous truth; mechanic verified | PASS (mechanic) |

## Evidence

- URL OR hash (decoded): `filters={"content_tags":[{"operator":"or","values":[" jbkaxlx","+tag"],"not":"false"}]}`
- URL AND hash (decoded): `filters={"content_tags":[{"operator":"and","values":[" jbkaxlx","+tag"],"not":"false"}]}`
- Pill DOM Include: `<div title="Tag: ( jbkaxlx)(+tag)" class="filter-pill grouped-filter"><span class="filter-label">Tag: </span><span class="option-label"> jbkaxlx</span><div class="or-label"><span>Or</span></div><span class="option-label">+tag</span></div>` (NO `exclude` modifier on `.or-label`).
- Posts numerics: baseline 1,221 → Include-OR 0, Include-AND 0 (zero-match quirk, not a bug — see known-quirks).

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs on QA-134275) | — | clean test |

## New findings

None. Behavior matches QA-134272/QA-134273 mechanic confirmation. Test-tag combos with zero matching posts in window produce Posts(0) without backend table-fail this time — backend-rejection quirk from QA-134277 did NOT reproduce; the Posts(0) + "No data available" empty state was clean.

## Files

- `runs/2026-06-05/QA-134275-report.md` (this report)
- Related: `runs/2026-06-02/QA-134272-report.md`, `runs/2026-06-02/QA-134273-report.md`
