# QA-134271 — Brand Navigation - Data Last Updated: Timestamp (RECONFIRM)

- **Date:** 2026-06-08 (QA-22296 batch 10)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018), cross-brand check on Tory Burch (brand_id=21648)
- **Source spec:** `testcases/english/QA-134271.md` + Atlassian QA-134271
- **Skill:** none dedicated; cross-cuts every Brand surface
- **Prior runs:** QA-4325 batch 11 2026-06-04 (PASS, value `06-04-2026 05:06 AM PT`)

## Result: PASS — RECONFIRM

`Data Last Updated` timestamp renders identically across all visited Brand sub-tabs, persists across F5 reload, and persists across brand switches. Today's account-wide ETL freshness signal: **`06-08-2026 04:29 AM PT`** (different value from 2026-06-04 run as expected with daily ETL).

## Execution

Sequentially visited every Brand sub-tab on MTV (brand_id=4018) / Adam Orfei, JS-probed the page header `Data Last Updated (PT): …`, then cross-brand-verified on Tory Burch (brand_id=21648) and F5-refreshed Home.

## Assertions

| ID | Surface | Expected | Actual | Status |
|----|---------|----------|--------|--------|
| A1 | `#home` | `MM-DD-YYYY HH:MM AM/PM PT` | `Data Last Updated (PT): 06-08-2026 04:29 AM PT` | PASS |
| A2 | `#brand/insights` (MTV, IG) | Same value | `Data Last Updated (PT): 06-08-2026 04:29 AM PT` | PASS |
| A3 | `#brand/audience` (MTV, IG) | Same value | `Data Last Updated (PT): 06-08-2026 04:29 AM PT` | PASS |
| A4 | `#brand/content` (MTV, IG) | Same value | `Data Last Updated (PT): 06-08-2026 04:29 AM PT` | PASS |
| A5 | `#brand/channels` (MTV, IG) | Same value | `Data Last Updated (PT): 06-08-2026 04:29 AM PT` | PASS |
| A6 | `#brand/stories` (MTV, IG) | Same value | `Data Last Updated (PT): 06-08-2026 04:29 AM PT` | PASS |
| A7 | `#brand/optimization` (MTV) | Same value | `Data Last Updated (PT): 06-08-2026 04:29 AM PT` | PASS |
| A8 | `#brand/insights` Tory Burch (brand_id=21648) — different brand | Same value (account-wide signal) | `Data Last Updated (PT): 06-08-2026 04:29 AM PT` | PASS |
| A9 | Home after F5 reload | Persists | `Data Last Updated (PT): 06-08-2026 04:29 AM PT` | PASS |
| A10 | Format conformance | regex `\d{2}-\d{2}-\d{4} \d{2}:\d{2} (AM\|PM) PT` after `(PT):` | Matches | PASS |

## Evidence

- 9 sequential JS-probe captures all returned `Data Last Updated (PT): 06-08-2026 04:29 AM PT`.
- Brand switch evidence: `brand_id=4018` (MTV) → `brand_id=21648` (Tory Burch) at same account; timestamp unchanged.
- F5 evidence: pressed F5 on `#home?account_id=54`; post-reload value identical.

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs on QA-134271) | — | clean test |

## New findings

None — behavior identical to 2026-06-04 run with daily-refreshed timestamp value. Day-over-day delta confirms account-wide ETL signal updates daily (5:06 AM → 4:29 AM PT).

## Files

- `runs/2026-06-05/QA-134271-RECONFIRM-report.md` (this report)
- Prior: `runs/2026-06-02/QA-134271-report.md`
