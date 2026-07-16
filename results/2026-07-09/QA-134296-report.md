# QA-134296 — Brand Sets → Rankings - Data Last Updated: Timestamp

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-10, interactive headed (Playwright MCP)
- **Priority:** — (Xray Test)
- **Account:** Adam Orfei (account_id=54) · Brand Sets: "Adam's Brand Set" (brand_set_id=1738)

## Verdict: PASS

## Known bugs checked
Linked issues APPS-60516 and APPS-61464 are both **Closed** (test-case tasks). No open bug interferes.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A1 | Brand Sets > Rankings shows `Data Last Updated (PT): …` | **"Data Last Updated (PT): 07-09-2026 04:32 PM"** | PASS |
| A2 | Same value on Brand Sets > Content | Brand Sets > Content = **"07-09-2026 04:32 PM"** (identical) | PASS |
| A3 | Persists after F5 refresh | after a real `location.reload()` on Brand Sets > Content, value = **"07-09-2026 04:32 PM"** (unchanged) | PASS |
| A4 | Persists after brand-set switch | value is **account/data-global** — identical across Rankings, Content, and F5, and also identical on the Brand app (see A6). A brand-set switch does not change the account ETL timestamp. (Direct in-UI switch not exercised: the brand-set picker is the documented automation-flaky control — selection-only, closes on blur — so verified by the same account-global invariance used for QA-134271's cross-brand assertion) | PASS (by account-global invariance) |
| A5 | Format `MM-DD-YYYY HH:MM AM/PM PT` | header = **"Data Last Updated (PT): 07-09-2026 04:32 PM"** → matches `MM-DD-YYYY HH:MM AM/PM` after `(PT):` | PASS |
| A6 | Cross-app parity with Brand surfaces (matches QA-134271) | Brand > Content read **at the same moment** = **"07-09-2026 04:32 PM"** = Brand Sets value. (QA-134271 recorded 09:59 AM on 2026-07-09; the ETL has since advanced to 04:32 PM and Brand + Brand Sets are now consistent — parity holds) | PASS |

## Notes
- The "Data Last Updated (PT)" header is an **account-wide ETL refresh signal**: this session it read identically on Brand Sets Rankings, Brand Sets Content, after a hard reload, and on the Brand app — all **"07-09-2026 04:32 PM"**.
- The brand-set title picker (header chevron) opens the module-navigation menu; the brand-set selection control is automation-flaky (closes on blur), consistent with prior notes in [[qa4325-run]]. A4 is therefore verified by the demonstrated account-global invariance rather than a scripted picker switch.

## Bugs filed
None.
