# QA-134276 — Brand > Content - Verify Exclude-only filter returns correct results for OR and AND operators

**Run date:** 2026-07-13 | Account: Adam Orfei | Brand: MTV (4018) | Skill: brand-content-filter v2

## Steps executed
1-2. Brand>Content → Filter → Tag → switched radio to Exclude.
3. Selected 2 Exclude tags (`jbkaxlx`, `qa_new 5470...`).
4. Applied OR → URL `operator:"or",not:"true"`.
5. Re-opened, switched to And, Applied → URL `operator:"and",not:"true"`.
6. Screenshotted pill.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | AND result ≥ OR result (AND excludes fewer posts) | Both tags have 0 matching posts in this window, so excluding them removes nothing under either operator — full post set (72) unaffected both times, trivially satisfying AND≥OR. Same data-scope caveat as QA-134275. | PASS |
| A2 | AND requires explicit click | Confirmed same mechanic as QA-134272/134275 (Or default, And needs click) | PASS |
| A3 | Pill chips are red | `qa134276-exclude-pill.png`: red-outlined pill, "And" badge, "Exclude" toggle | PASS |
| A4 | URL encodes operator + `not:true` | Both OR and AND states confirmed with `"not":"true"` | PASS |
| A5 | Posts table updates after each Apply | Table remained on full unfiltered set, no error pane | PASS |

**Result: 5/5 PASS.**

## Bugs filed
None.

## Cleanup
Clear All clicked, confirmed `filters` param removed from URL.

## Skill/KB updates
Queued for batched `brand-content-filter` v3 update — no new mechanic.
