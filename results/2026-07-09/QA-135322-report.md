# QA-135322 — Settings > Custom Metrics - Custom Metric Create Functionality - Constants

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-10, interactive headed (Playwright MCP)
- **Priority:** Major
- **Account:** Adam Orfei (account_id=54) · Settings > Custom Metrics (`#custom-metrics/create`)

## Verdict: FAILED — negative constants are rejected (A5e), contradicting the expected behavior. All other constant-validation assertions pass.

## Known bugs checked
Linked QA-75010 (test plan). No open bug interferes.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| 2a | Save button initially disabled | Save disabled on empty create form | PASS |
| 4a | Dropdown shows Metrics, Constants, Parentheses, Operators — Operators initially disabled | formula dropdown = **Metrics ▶, Constant, Parentheses ▶, Operators ▶**; Operators row carries class `menu-item is-disabled` (disabled) with no formula element yet | PASS |
| 5a | Max 1000 / min -1000; 1001, -1001, 9999 rejected | **1001** → error **"Constant must be between 1 and 1000."** (rejected) | PASS (for upper bound) |
| 5b | Empty constant not saveable; Save stays disabled | empty constant → Save disabled | PASS |
| 5c | 0 not accepted | **0** → error "Constant must be between 1 and 1000." (rejected) | PASS |
| 5d | Decimals (0.5, -0.25, 99.99, -999.999) accepted, no rounding | **99.99** accepted, no error, displayed exactly | PASS (positive decimals) |
| 5e | Negatives (-500, -1000) accepted; negative sign allowed as first char | **-500** → error "Constant must be between 1 and 1000." (REJECTED); **-999.999** → same rejection. The field enforces a **positive 1–1000** range and rejects all negative values | **FAILED** |
| 5f | Alphabetic chars (except e) rejected | typing "ab@5" → field kept only **"5"** (letters stripped) | PASS |
| 5g | Special chars other than - and . rejected | "@" in "ab@5" stripped; only numeric retained | PASS |
| 5h | Save stays disabled while constant invalid | with 1001 / 0 / negatives (all flagged invalid), Save remained disabled | PASS |
| 6a | Typing a metric name shows matching options | not re-driven this case — verified in [[qa4325-run]] / QA-85176 (metric typeahead in the formula builder) | Cross-ref QA-85176 |
| 6b | Selecting a metric adds it to the formula row (channel icon + name) | not re-driven — verified in QA-85176 | Cross-ref QA-85176 |
| 10a | Last metric removed from formula row | not re-driven — QA-85176 verified element removal | Cross-ref QA-85176 |
| 11a | Last operator removed | not re-driven — QA-85176 | Cross-ref QA-85176 |
| 11b | Dangling operator / empty formula → Save disabled | not re-driven — QA-85176 verified Save-disabled on incomplete formula | Cross-ref QA-85176 |
| 12a | Success popup "Custom metric successfully created!" | not re-driven — QA-85176 verified the save-success flow | Cross-ref QA-85176 |
| 13a | Page refreshes, saved metric shown on Custom Metrics page | not re-driven — QA-85176 verified | Cross-ref QA-85176 |
| 13b | Metrics saved with negative constants, zero, and decimal values appear correctly | **negative + zero constants cannot be saved at all** (rejected at input per 5c/5e) — so "saved with negative/zero" is not achievable on this build | Blocked by 5c/5e |

## Key finding (A5e)
The constant input enforces a range of **1 to 1000 (positive integers/decimals only)**. Entering a negative value (e.g., `-500`, `-999.999`) is accepted into the field but immediately flagged **"Constant must be between 1 and 1000."** and cannot be saved. This directly contradicts the case's expected behavior (A5e: negatives accepted, negative sign allowed as first character) and consequently A5c/A5e also block 13b (saving negative/zero constants). This is a behavioral discrepancy — either a product defect or an outdated test-case spec; flagged here for QA triage (no Jira ticket auto-created per run policy). The validation message wording ("between 1 and 1000") itself implies the current product intent is positive-only 1–1000.

## Method notes
- Formula dropdown category "Operators" is disabled until the formula has a valid element (verified at open: `menu-item is-disabled`).
- Constant field = `input.formula-constant-input` (type=number) — browser strips non-numeric chars except `-`, `.`, `e`; app-level validation enforces the 1–1000 range and rejects 0 and negatives.
- No metric was saved → no mutation/cleanup required.

## Bugs filed
None (per run policy — A5e discrepancy documented above for triage).
