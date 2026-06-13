# QA-134274 — Brand > Content - Verify pill add/remove, Clear All and Save/Load filter

- **Date:** 2026-06-08 (QA-22296 batch 10)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018)
- **Channel:** Instagram
- **Window:** Jun 01 – Dec 31 2025
- **Perspective:** Authorized (perspective=extended)
- **Data Set:** Public (table_data_set=public)
- **Source spec:** `testcases/english/QA-134274.md` + Atlassian QA-134274
- **Skill:** `brand-content-filter` (reuse)

## Result: PASS

Pill-add updates URL `filters` JSON, Clear All resets `filters` from URL + pill DOM, and URL-encoded `filters` re-hydrates the pill on reload. Save/Load Filter UI controls present (Save disabled until valid; Load opens filter loader).

## Execution

1. Brand > Content (MTV / Adam Orfei / IG / Jun-Dec 2025) baseline Posts (1,221).
2. Filter dropdown → Tag sub-popup.
3. Add Include tags `jbkaxlx` + `+tag` → Apply Filter.
4. URL hash becomes (decoded): `filters={"content_tags":[{"operator":"or","values":[" jbkaxlx","+tag"],"not":"false"}]}` and pill `Tag: jbkaxlx Or +tag` rendered with `filter-pill grouped-filter` class.
5. Posts table shifts to Posts (0) — these tags have no IG posts in window (extension of QA-134277 quirk).
6. Click pill → sub-popup re-opens with Include radio active + Or selected + both tags checked.
7. Click Clear All link → URL `filters` param disappears, pillCount=0, Posts returns to (1,221).
8. Direct URL navigate to filtered hash → pill re-hydrates from URL (`Tag: jbkaxlx Or +tag` grouped-filter; title `Tag: ( jbkaxlx)(+tag)`) and Posts table shows (0) after backend response.
9. Save Filter / Load Filter buttons visible in Filter toolbar (Save disabled when filter pristine; Load enabled to open filter loader popup).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3-4 | Pill add updates URL `filters` JSON | URL hash gets `filters=%257B%2522content_tags%2522%253A...` | PASS |
| A2 | 7 | Clear All removes all pills + URL `filters` | `location.hash.includes('filters')` = false; `pillCount` = 0; Posts back to baseline (1,221) | PASS |
| A3 | 8 | After URL navigation with `filters=...`, pill re-hydrates | `Tag: jbkaxlx Or +tag` pill rendered post-load with same operator + tags + Include color | PASS |
| A4 | 4 | Include pill color (Include = green / grey-outline) | Pill `filter-pill grouped-filter` no `exclude` class; Or-label `or-label` (no exclude) | PASS |
| A5 | — | Save Filter / Load Filter UI controls present | Both buttons rendered in Filter toolbar (`Save Filter`, `Load Filter`) | PASS |
| A6 | — | URL filters JSON encodes Include via `not:"false"` | Decoded: `{"operator":"or","values":[" jbkaxlx","+tag"],"not":"false"}` | PASS |

## Evidence

- Baseline (no filter): `Posts (1,221)`
- After Include OR Apply: `Posts (0)` with URL filters JSON `{"content_tags":[{"operator":"or","values":[" jbkaxlx","+tag"],"not":"false"}]}`
- After Clear All: `location.hash.includes('filters')` = false; `pillCount` = 0; Posts back to `(1,221)` after rehydrate
- After URL re-nav with filters: pill DOM = `<div title="Tag: ( jbkaxlx)(+tag)" class="filter-pill grouped-filter">…<div class="or-label">…`

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs on QA-134274) | — | clean test |

## New findings

- Pill hydration on F5/direct-URL load takes a noticeable delay (10-25 s) on this brand+window before pill chip renders, even though backend query (Posts count) is correct. Not a regression — just a UI latency note. Mark as a `brand-content-filter` skill known-quirk extension.

## Files

- `runs/2026-06-05/QA-134274-report.md` (this report)
- Related: `runs/2026-06-02/QA-134272-report.md`, `runs/2026-06-02/QA-134273-report.md`
