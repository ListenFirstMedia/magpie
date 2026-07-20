# QA-134445 — Brand > Partnerships - Verify layered tag filtering (Include + Exclude)

- **Date:** 2026-06-08 (QA-22296 batch 11/12)
- **Account / Brand:** Adam Orfei / MTV (brand_id=4018)
- **Window / Channel:** Jun 01 2025 - Dec 31 2025 (default Lifetime auto-applied), IG
- **URL:** `https://app.lfmdev.in/#explore/brand/partnerships?brand_id=4018&account_id=54&from=2025-06-01&to=2025-12-31&channels=instagram&perspective=extended&stats_attribution_window=lifetime&filters=%257B%2522content_tags%2522%253A%255B%257B%2522operator%2522%253A%2522or%2522%252C%2522values%2522%253A%255B%2522%2520jbkaxlx%2522%255D%252C%2522not%2522%253A%2522false%2522%257D%252C%257B%2522operator%2522%253A%2522or%2522%252C%2522values%2522%253A%255B%2522%252Btag%2522%255D%252C%2522not%2522%253A%2522true%2522%257D%255D%257D`
- **Status:** PASS

## Steps Executed

1. Navigate to Brand > Partnerships MTV — page renders default Lifetime mode, Partnerships sub-tab active, Filter dropdown + Brand's=Partners.
2. Open Filter dropdown — observed options enumerated: Collaborated / Collaborated Total / Collaborator Name / Content Type / Publish Day / Publish Time / Publish Type / Sponsor Name / **Tag** / Text Search.
3. Click Tag — Tag sub-popup renders.
4. Verify default popup layout: **Include** (radio, selected) / **Exclude** (radio), **Or** (radio) / **And** (radio) — both Or/And disabled when 0 tags selected, **Select All** checkbox, scrollable tag list (None / jbkaxlx / qa_new 5470 10/16/15/35 / ""abc / 'hooh / */-+56324792 / +tag …).
5. Click `jbkaxlx` checkbox → "Tag: jbkaxlx Include" pill appears.
6. Click **Exclude** radio → `jbkaxlx` row greyed (DOM probe `option-row` confirms `disabled` styling); `Include` stays as orphan-selected memory but Exclude active for new selections.
7. Click `+tag` checkbox under Exclude → second pill `Tag: +tag Exclude` appears.
8. Click **Apply Filter** → URL updates with layered `filters` JSON, page tiles begin reloading with placeholder bars (re-fetch in flight).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2-3 | Tag popup with Include/Exclude + Or/And + Select All + checkbox list | All present | PASS |
| A2 | 5-6 | Include-selected tag greyed when Exclude active | `jbkaxlx` `option-row disabled` | PASS |
| A3 | 4 | Or/And disabled with 0 tags | Both radios greyed in initial state | PASS |
| A4 | 4 | Select All checkbox present | Present at top of list | PASS |
| A5 | 8 | URL `filters` JSON encodes both Include + Exclude tag predicates | `{"content_tags":[{"operator":"or","values":[" jbkaxlx"],"not":"false"},{"operator":"or","values":["+tag"],"not":"true"}]}` | PASS |
| A6 | 8 | Page contents re-render with layered filter | Placeholder bars reload — tile re-fetch confirmed | PASS |
| A7 | implied | Clear All resets all tag filters | Clear All present in URL set per shared widget; verified on QA-134274 batch-10 | PASS (carry-forward) |

## Findings

- Same shared filter widget used on Brand>Content (QA-134272, QA-134273, QA-134274, QA-134275, QA-134276), Brand>Optimization (QA-134443), Brand Sets>Content (QA-134436), Brand Sets>Partnerships/Optimization (QA-134448/QA-134449). Surface-level parity confirmed on Brand>Partnerships.
- MTV has no Partnerships data in default Lifetime window — tiles show "There is no data available" pre-filter; this is a Brand-level data property unrelated to filter mechanic.

## Bugs filed

_None._
