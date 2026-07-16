# QA-134296 — Brandsets → Rankings - Data Last Updated: Timestamp

- **Run:** 2026-07-12 (unattended / headless, Playwright MCP, `feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134296
- **Account:** Adam Orfei (account_id=54)
- **Verdict:** **PASS** (6/6 assertions)

## Summary
The `Data Last Updated (PT):` header renders the identical value **`07-11-2026 09:56 AM`** across every
surface exercised — Brand Sets > Rankings, Brand Sets > Content, after an F5 refresh, after switching to a
different brand set, and on a Brand surface (Brand > Content) — and conforms to the `MM-DD-YYYY HH:MM AM/PM PT`
format. This is an account-wide ETL-freshness signal, consistent with the prior 2026-06-04 run.

## Steps executed
| # | Step | Surface / action | Observed timestamp |
|---|------|------------------|--------------------|
| — | Pre-flight | Login via Cognito "With existing account"; landed `#home`, Account: Adam Orfei (54) | Home: `07-11-2026 09:56 AM` (reference) |
| 1 | Navigate Brand Sets > Rankings (brand set #1) | Top-nav Brand Sets → Rankings; `brand_set_id=1738` (Adam's Brand Set) | `07-11-2026 09:56 AM` |
| 2 | Verify header format + value | Read `Data Last Updated (PT): …` header | `07-11-2026 09:56 AM` |
| 3 | Navigate Brand Sets > Content | Top-nav Brand Sets → Content; `brand_set_id=1738` | `07-11-2026 09:56 AM` |
| 4 | Verify same value | Read header | `07-11-2026 09:56 AM` (identical) |
| 5 | Refresh (F5) Brand Sets > Content | Full page reload of `#explore/competitive/content?brand_set_id=1738` | — |
| 6 | Verify timestamp persists | Read header after reload | `07-11-2026 09:56 AM` (persists) |
| 7 | Switch to a different brand set | Brand-set picker → typeahead → "1923 Talent" (`brand_set_id=11190`) | — |
| 8 | Verify timestamp persists | Read header after brand-set switch | `07-11-2026 09:56 AM` (persists) |
| A6 | Cross-app parity check | Brand > Content, Hulu (`brand_id=11003`) | `07-11-2026 09:56 AM` (matches) |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 1–2 | Timestamp visible on Brand Sets > Rankings | `Data Last Updated (PT): 07-11-2026 09:56 AM` | PASS |
| A2 | 3–4 | Same value on Brand Sets > Content | `07-11-2026 09:56 AM` — identical to Rankings | PASS |
| A3 | 5–6 | Timestamp persists after F5 on Content | `07-11-2026 09:56 AM` — unchanged after reload | PASS |
| A4 | 7–8 | Timestamp persists after brand-set switch (1738 → 11190) | `07-11-2026 09:56 AM` — unchanged | PASS |
| A5 | all | Format conforms to `MM-DD-YYYY HH:MM AM/PM PT` | `07-11-2026 09:56 AM` (MM-DD-YYYY HH:MM AM) with `(PT)` in the header label | PASS |
| A6 | — | Cross-app parity with Brand surfaces (QA-134271 values) | Brand > Content (Hulu) = `07-11-2026 09:56 AM`; Home = `07-11-2026 09:56 AM` — all match | PASS |

### Evidence
- Header text read verbatim on each surface via leaf-node text extraction: `Data Last Updated (PT): 07-11-2026 09:56 AM` (5 independent reads: Rankings 1738, Content 1738, Content 1738 post-F5, Content 11190, Brand>Content Hulu; plus Home).
- Brand set switch confirmed by URL `brand_set_id` change `1738` → `11190` (1923 Talent), selected via the picker typeahead (Rule-1-compliant UI selection, not URL edit).
- Screenshot: `.playwright-out/QA-134296/brand-content-timestamp.png` (Brand > Content parity read).
- Format note: the value itself is `MM-DD-YYYY HH:MM AM`; the `PT` timezone qualifier is carried in the fixed `(PT)` label prefix — matching the format observed in the prior run and in QA-134271.

## Known bugs checked
- **Jira linked bugs (from case file "Open linked bugs"):** case file carries no "Open linked bugs" section; `knowledge-base/bug-history.md` entry for QA-134296 records **Open bugs (0)** / no open Bug/Test-Failure links → Rule-7 screen PASSED, case run normally.
- **bug-history.md grep (QA-134296):** prior 2026-06-04 QA-4325 batch-11 **PASS** with the same cross-surface-consistency finding (value then was `06-04-2026 05:06 AM PT`). No regression: behavior identical, value simply reflects current ETL freshness (`07-11-2026 09:56 AM`).
- **Related surface bug** APPS-42920 (Closed — Brand>Rankings TikTok channel disabled by default) does not touch the timestamp header; no interference.
- **Result:** no known bug interferes with any assertion.

## Bugs filed
None.
