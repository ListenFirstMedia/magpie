# QA-134271 — Brand Navigation — Data Last Updated: Timestamp

- **Date:** 2026-06-04 (QA-4325 batch 11)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018), with cross-brand check on Tory Burch (brand_id=21648)
- **Source spec:** Atlassian QA-134271 (validates ETL Data Refresh Timestamp formatting and persistence across Brand navigation tabs)
- **Skill:** none dedicated; cross-cuts every Brand surface

## Result: PASS

Data Last Updated timestamp renders with identical format and identical value across all visited Brand sub-tabs, persists through F5 page-refresh, and persists across brand switches.

## Execution

Visited each Brand sub-tab in sequence on MTV (brand_id=4018) / Adam Orfei, capturing the top-right `Data Last Updated (PT): …` value via screenshot zoom of the header region.

After the per-tab sweep, switched the brand context to Tory Burch (brand_id=21648) and re-verified the timestamp. Finally pressed F5 on Home to verify persistence.

## Assertions

| ID | Surface | Expected | Actual | Status |
|----|---------|----------|--------|--------|
| A1 | Home (`#home`) | `Data Last Updated (PT): MM-DD-YYYY HH:MM AM/PM PT` | `Data Last Updated (PT): 06-04-2026 05:06 AM PT` | PASS |
| A2 | Brand > Insights (MTV, IG) | Same value as Home | `Data Last Updated (PT): 06-04-2026 05:06 AM PT` | PASS |
| A3 | Brand > Audience (MTV, IG) | Same value | `Data Last Updated (PT): 06-04-2026 05:06 AM PT` | PASS |
| A4 | Brand > Content (MTV, IG) | Same value | `Data Last Updated (PT): 06-04-2026 05:06 AM PT` | PASS |
| A5 | Brand > Channels (MTV, IG) | Same value | `Data Last Updated (PT): 06-04-2026 05:06 AM PT` | PASS |
| A6 | Brand > Stories (MTV, IG) | Same value | `Data Last Updated (PT): 06-04-2026 05:06 AM PT` | PASS |
| A7 | Brand > Optimization (MTV) | Same value | `Data Last Updated (PT): 06-04-2026 05:06 AM PT` | PASS |
| A8 | Brand > Insights — different brand (Tory Burch, IG) | Same value (timestamp is account-wide, not brand-specific) | `Data Last Updated (PT): 06-04-2026 05:06 AM PT` | PASS |
| A9 | Home after F5 refresh | Persists same value | `Data Last Updated (PT): 06-04-2026 05:06 AM PT` | PASS |
| A10 | Format conformance | `MM-DD-YYYY HH:MM AM/PM PT` after `(PT):` | Matches regex `\d{2}-\d{2}-\d{4} \d{2}:\d{2} (AM|PM) PT` | PASS |

## Evidence

- Header text captured via zoom on the upper-right region of each page:
  ```
  Data Last Updated (PT): 06-04-2026 05:06 AM PT
  ```
- Identical across all 9 capture points listed above (8 surfaces + 1 post-refresh).
- Brand-switch evidence: navigated `brand_id=4018` (MTV) → `brand_id=21648` (Tory Burch) at the same `account_id=54`; timestamp value unchanged confirming this is an account-level / ETL-level signal, not per-brand.
- F5 refresh evidence: pressed F5 on `#home?account_id=54`; after reload header re-rendered with the identical timestamp string.

## Bug reproduction outcomes

| Bug | Status | Notes |
|-----|--------|-------|
| (no open bugs on QA-134271) | — | bug-history shows no defects |

## New findings

None — all surfaces exhibit identical formatting and value. The behavior aligns with the spec's "remains consistent and persistent across navigation between different tabs" expectation.

## Files

- `runs/2026-06-02/QA-134271-report.md` (this report)
