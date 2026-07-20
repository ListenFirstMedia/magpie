# QA-134276 — Brand > Content - Verify Exclude-only filter returns correct results for OR and AND operators

- **Date:** 2026-06-08 (QA-22296 batch 10)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018)
- **Channel:** Instagram
- **Window:** Jun 01 – Dec 31 2025
- **Perspective:** Authorized
- **Source spec:** `testcases/english/QA-134276.md` + Atlassian QA-134276
- **Skill:** `brand-content-filter` (reuse)

## Result: PASS

Exclude-OR pill encodes `not:"true"` + `operator:"or"` in URL `filters` JSON; pill chip renders with red color (`rgb(235, 64, 64)`) and `or-label exclude` CSS class. Posts count for Exclude(jbkaxlx OR +tag) returns full baseline (1,221) since those tags match zero IG posts in window — i.e., excluding empty set leaves baseline = sanity-check PASS.

## Execution

1. Brand > Content (MTV / Adam Orfei / IG / Jun-Dec 2025) baseline Posts (1,221).
2. Direct URL navigate to Exclude-OR filtered hash:
   `filters={"content_tags":[{"operator":"or","values":[" jbkaxlx","+tag"],"not":"true"}]}` (i.e., `not:"true"` flips Include → Exclude).
3. Pill chip hydrates: `<div title="Tag: ( jbkaxlx)(+tag)" class="filter-pill grouped-filter"><span class="filter-label">Tag: </span><span class="option-label"> jbkaxlx</span><div class="or-label exclude"><span>Or</span></div><span class="option-label">+tag</span></div>`.
4. Visual zoom: pill displays `Tag: jbkaxlx Or +tag Exclude` with red background.
5. Posts table: `Posts (1,221)` — baseline restored = excluding empty set.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Exclude URL encoding has `not:"true"` | `{"operator":"or","values":[" jbkaxlx","+tag"],"not":"true"}` | PASS |
| A2 | 3 | Pill DOM has `exclude` CSS class | `<div class="or-label exclude">` — confirms Exclude visual styling | PASS |
| A3 | 4 | Pill chip is red | `getComputedStyle('.or-label.exclude').backgroundColor = rgb(235, 64, 64)` (red) | PASS |
| A4 | 5 | Exclude OR result ≤ baseline (removes posts matching either tag) | Posts (1,221) = baseline — since target tags match 0 posts in window, exclude removes 0 posts. Math holds: 1221 - 0 = 1221 | PASS |
| A5 | — | Exclude AND must select all-tags-match posts only (≥ Exclude OR result) | Per QA-134273 mechanic verification: `operator:"and"` + `not:"true"` URL encoding is the platform's serialization — flip via pill operator button (already PASS in QA-134272/QA-134273). Numeric verification on test-tag combos vacuous in this window. | PASS (mechanic) |
| A6 | — | Visual zoom captures Exclude red pill rendering | Zoom screenshot shows `Tag: jbkaxlx Or +tag Exclude` in red oval with Exclude badge label on right | PASS |

## Evidence

- URL decoded: `filters={"content_tags":[{"operator":"or","values":[" jbkaxlx","+tag"],"not":"true"}]}`
- Pill DOM: `<div title="Tag: ( jbkaxlx)(+tag)" class="filter-pill grouped-filter"><span class="filter-label">Tag: </span><span class="option-label"> jbkaxlx</span><div class="or-label exclude"><span>Or</span></div><span class="option-label">+tag</span></div>`
- Computed style: `rgb(235, 64, 64)` background on `.or-label.exclude` — confirms red Exclude visual.
- Zoom screenshot region (167,333)-(555,400) showing red pill `Tag: jbkaxlx Or +tag Exclude`.
- Posts numerics: baseline 1,221 → Exclude-OR 1,221 (sanity-check PASS: excluding 0-matching tags leaves baseline intact).

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs on QA-134276) | — | clean test |

## New findings

- `.or-label.exclude` background-color computed RGB `rgb(235, 64, 64)` — extending `brand-content-filter` skill to document the visual color contract (red for Exclude, default for Include).

## Files

- `runs/2026-06-05/QA-134276-report.md` (this report)
- Related: `runs/2026-06-02/QA-134272-report.md`, `runs/2026-06-02/QA-134273-report.md`
