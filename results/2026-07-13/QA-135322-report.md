# QA-135322 — Settings > Custom Metrics — Custom Metric Create Functionality (Constants)

- **Run:** 2026-07-13 (unattended, headless Playwright MCP, branch `feature/playwright-mcp`)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-135322
- **Account/precondition:** Logged in as `lfiqa@listenfirstmedia.com` → session resolved to **Adam Orfei** (account_id=54). Custom Metrics is account-gated to Adam Orfei; precondition met.
- **Skill reused:** `settings-custom-metrics` (v4) — Constant-value validation flow authored from this very case on 2026-07-10. This is a fresh separate-day re-run.
- **Metric created (mutating):** `QA-135322-PW-2026-07-13-022545`, formula `5 + Shares` (`5 + lfm.cross_channel_shares.public_shares_v5`). **Cleanup completed** (deleted + F5-verified gone).

## Verdict: **FAIL** — A5e (negative constants rejected; spec requires them accepted). All other 16 assertions PASS. A13b PARTIAL. The A5e failure is a **documented spec-vs-UI discrepancy** (not a fresh regression — matches skill v4 finding); flagged for QA triage, **not auto-filed**.

---

## Steps executed (all 13, in order)

1. Settings top-nav (hover) → Custom Metrics → `#custom-metrics`. ✓
2. Clicked "Create a Custom Metric" → `#custom-metrics/create`. ✓
3. Entered Name `QA-135322-PW-2026-07-13-022545` + Description. ✓
4. Clicked the Formula input → dropdown opened. ✓
5. Selected "Constant" → constant chip + `input.formula-constant-input` (type=number) rendered. ✓
6. Exercised the Constant field across the full validation matrix (see A5*), then set a valid `5`. ✓
7. Added `+` operator (Operators submenu → fa-plus leaf). ✓
8. Metrics → ListenFirst → selected "Shares". ✓
9. Added `-` operator, then typed "Post Likes" in the formula input (typeahead) → selected "Post Likes" (facebook.page.total_post_likes_c). ✓
10. Clicked X on the last metric (Post Likes). ✓
11. Clicked X on the last operator (`-`). ✓
12. Clicked Save. ✓
13. Clicked Ok in the Success popup → redirected to list. ✓

Formula evolution: `[5]` → `[5,+]` → `[5,+,Shares]` → `[5,+,Shares,-]` → `[5,+,Shares,-,Post Likes]` → (X) `[5,+,Shares,-]` → (X) `[5,+,Shares]` → saved.

---

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| 2a | Create page | Save button initially disabled | `Save` rendered `[disabled]` on the fresh Create page | **PASS** |
| 4a | Formula dropdown | Shows Metrics, Constants, Parentheses, Operators; Operators initially disabled | Shows `Metrics ▶`, `Constant`, `Operators [disabled]`, `Parentheses ▶` (UI "Constant" singular vs spec "Constants" — documented copy drift). Operators disabled. | **PASS** |
| 5a | Constant range | Accepts −1000..1000; 1001/−1001/9999 rejected | `1001` → err + Save disabled; `9999` → err + Save disabled; `−1001` → err + Save disabled. (⚠ UI's real min is **1**, not −1000 — see A5e.) All three named values correctly rejected. | **PASS** |
| 5b | Empty constant | Empty not saveable; Save stays disabled | Empty `formula-constant-input` → Save disabled, no valid chip | **PASS** |
| 5c | Zero | 0 not accepted | `0` → "Constant must be between 1 and 1000." + Save disabled | **PASS** |
| 5d | Decimals | In-range decimals accepted, shown without rounding/truncation | `99.99` → no error, value held exactly `99.99`, no rounding (validation cleared). (`0.5` rejected — below UI min 1; negative decimals rejected — see A5e. UI's accepted-decimal band is 1..1000, narrower than spec's −1000..1000.) | **PASS** |
| 5e | Negatives | Negatives (−500, −1000) accepted; leading `−` allowed | Field **accepts the typed text** `-500`/`-1000` (leading `−` not stripped) but app **validation REJECTS** every negative → "Constant must be between 1 and 1000." + Save disabled. Spec requires negatives accepted. | **FAIL** |
| 5f | Alphabetic | Alpha chars (except `e`) rejected | `abc123` typed → field holds `123` (a/b/c stripped by number input) | **PASS** |
| 5g | Special chars | Special chars other than `-` `.` rejected | `1@2#$3*` typed → field holds `123` (`@#$*` stripped) | **PASS** |
| 5h | Invalid input | Save disabled while constant invalid | Save observed disabled for every invalid value (0, 1001, 9999, −1001, −500, −1000, 0.5) | **PASS** |
| 6a | Metric typeahead | Typing a metric name shows matching options | Typed "Post Likes" → dropdown filtered to `Post Likes` (facebook.page.total_post_likes_c) + `Page Post Likes` (instagram.page.total_likes_c) | **PASS** |
| 6b | Metric chip | Selecting a metric adds it to the row showing only channel icon + metric name | "Shares" chip rendered with ListenFirst icon + label "Shares" only (no DCR key visible in chip); Save enabled | **PASS** |
| 10a | Remove metric | Last metric removed from row | X on Post Likes → chip removed; formula back to `[5,+,Shares,-]` | **PASS** |
| 11a | Remove operator | Last operator removed from row | X on `-` → operator removed; formula `[5,+,Shares]`; Save re-enabled | **PASS** |
| 11b | Dangling/empty | Dangling operator / empty / invalid → Save disabled | After A10a the formula ended with `-` (dangling) → Save disabled | **PASS** |
| 12a | Success popup | Message "Custom metric successfully created!" | Modal heading "Success", body **"Custom metric successfully created!"**, Ok button | **PASS** |
| 13a | List refresh | Page refreshes; saved metric name shows on Custom Metrics page | Redirected to `#custom-metrics`; row present: name, desc, `Jul. 13 2026`, `LFQA Testing`, formula `5 + lfm.cross_channel_shares.public_shares_v5` | **PASS** |
| 13b | Neg/zero/decimal display | Metrics saved with negative, zero, decimal constants display correctly | Positive integer constant `5` displays correctly in the saved row. **Negative & zero constants are UNREACHABLE** (blocked at input — see A5e), so cannot be saved/verified. A decimal-constant metric was not separately created. | **PARTIAL** |

---

## Evidence

- Constant field validation message element: `div.formula-editor-validation-message` → "Constant must be between 1 and 1000."
- Constant input: `input.formula-constant-input` (type=number). Leading `-` accepted as text; app validation enforces **1..1000 positive**.
- Operator submenu leaves are empty-text `.menu-item` rows carrying FontAwesome icons `i.fa-regular.fa-{plus,minus,times,divide}` (4 operators present — APPS-60358 impl, not a bug).
- ListenFirst "Shares" metric key: `lfm.cross_channel_shares.public_shares_v5`. Post Likes: `facebook.page.total_post_likes_c`.
- Saved list row (A13a): `QA-135322-PW-2026-07-13-022545 | QA-135322 Constants validation sample metric | Jul. 13 2026 | LFQA Testing | 5 + lfm.cross_channel_shares.public_shares_v5`.
- Screenshot: `.playwright-out/QA-135322/list-saved-metric.png`.
- Delete confirm modal (verbatim): `Are you absolutely sure you want to delete your custom metric "QA-135322-PW-2026-07-13-022545"?Click "Ok" to continue.` → Cancel/Ok.

## Known bugs checked

- `knowledge-base/bug-history.md` grep for `QA-135322` → **no matches** (no linked bug history).
- Case file has **no "## Open linked bugs" section** (Rule 7) → treated as none-open; screen passed, case run normally.
- Skill `settings-custom-metrics` v4 lists no open bugs for this flow. The A5e negative-constant rejection is the pre-documented spec-vs-UI discrepancy (v4 changelog), reproduced again this run — **stable behavior, not a new regression**.

## A5e discrepancy detail (for QA triage — NOT auto-filed)

Spec 5a states min value **−1000** and 5e states **negatives accepted** with the negative sign allowed as the first character. The current build enforces a **positive 1–1000** range: `0`, `−500`, `−1000`, `−1001`, and `0.5` are all rejected with "Constant must be between 1 and 1000." and keep Save disabled. Consequences: A5e fails outright; A5d's accepted band is effectively 1..1000 (positive decimals only); A5c/A13b's negative/zero paths are unreachable. Either the field's validation is a product bug or the spec (5a/5c/5d/5e/13b) is outdated. Per magpie convention (Rule 1/5, no false-positive filing), this is flagged for QA triage — no Jira ticket created.

## Bugs filed

None (markdown-only; A5e discrepancy flagged above for human triage, not filed).

## Cleanup

Metric `QA-135322-PW-2026-07-13-022545` deleted via row Actions → Delete → Ok; re-navigated to `#custom-metrics` and confirmed the row is **absent** (metricStillPresent=false). Mutation fully reverted.
