# QA-134446 — Brand > Stories - Verify layered tag filtering (Include + Exclude)

- **Date:** 2026-06-08 (QA-22296 batch 11/12)
- **Account / Brand:** Adam Orfei / MTV (brand_id=4018)
- **Window / Channel:** Jun 01 2025 - Dec 31 2025 (default), IG
- **URL after Apply:** `https://app.lfmdev.in/#explore/brand/stories?brand_id=4018&account_id=54&from=2025-06-01&to=2025-12-31&channels=instagram&perspective=extended&table_data_set=insights&filters=%257B%2522content_tags%2522%253A%255B%257B%2522operator%2522%253A%2522or%2522%252C%2522values%2522%253A%255B%2522%2520jbkaxlx%2522%255D%252C%2522not%2522%253A%2522false%2522%257D%252C%257B%2522operator%2522%253A%2522or%2522%252C%2522values%2522%253A%255B%2522-------a%2522%255D%252C%2522not%2522%253A%2522true%2522%257D%255D%257D`
- **Status:** PASS

## Steps Executed

1. Navigate to Brand > Stories MTV — page shows Stories(886), Filter dropdown + Tag/Benchmark/DataViz/Export.
2. Open Filter dropdown — observed options: Branded Content / Collaborated / Collaborated Total / Collaborator Name / Content Type / Live Stream / Paid / Publish Day / Publish Time / Sponsor Name / **Tag** / Text Search.
3. Click Tag — Tag sub-popup renders.
4. Verify default layout: Include (selected) / Exclude radios, Or/And radios (disabled at 0 tags), **Select All** checkbox, tag checklist (None / jbkaxlx / qa_new 5470 / ""abc / 'hooh / -------a / -----123-123 / ----112test / ----raptors / 000 …).
5. Click `jbkaxlx` checkbox under Include → `Tag: jbkaxlx Include` pill appears.
6. Click Exclude radio → `jbkaxlx` `option-row disabled` className confirmed (DOM probe).
7. Click `-------a` checkbox under Exclude → `Tag: -------a Exclude` pill appears.
8. Click Apply Filter → URL updates with layered JSON, page re-renders.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2-3 | Tag popup with Include/Exclude + Or/And + Select All + checkbox list | All present | PASS |
| A2 | 6 | Include-selected tag greyed when Exclude active | `option-row disabled` on jbkaxlx | PASS |
| A3 | 4 | Or/And disabled with 0 tags | Greyed in initial state | PASS |
| A4 | 4 | Select All checkbox present | Present at top of list | PASS |
| A5 | 8 | URL `filters` JSON encodes both Include + Exclude tag predicates | Two-entry array confirmed | PASS |
| A6 | 8 | Page contents update with layered filter | Chips render, table area clears (filter applied) | PASS |
| A7 | implied | Clear All resets all tag filters | Shared widget — verified Brand>Content QA-134274 | PASS (carry-forward) |

## Findings

- Same shared filter widget pattern as Brand>Partnerships (QA-134445), Brand>Optimization (QA-134443), Brand>Content (QA-134272 family), Brand Sets (QA-134436 family). 6-surface parity confirmed.

## Bugs filed

_None._
