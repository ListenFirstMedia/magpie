# QA-135429 — Settings > Custom Metrics — Edit functionality

- **Date:** 2026-06-08 (QA-22296 batch 11/12)
- **Account:** Adam Orfei (id=54)
- **Page:** Settings > Custom Metrics
- **URL:** `https://app.lfmdev.in/#custom-metrics`, edit URL `#custom-metrics/edit?report_id=18`
- **Status:** PARTIAL — A1+A2 PASS end-to-end; A3+A4 deferred (safety: would mutate someone else's metric)

## Steps Executed

1. Navigate to Settings > Custom Metrics — list of 18+ metrics renders with columns: Metric / Description / Created Date / Creator / Formula / Actions.
2. Pick `Test 09-05-20254` row (clearly a sandbox-named metric, owner Kumar Keshav Kashyap, formula `facebook.page.total_post_comments_c + lfm.cross_channel_shares.public_shares_v5`).
3. Click row Actions ellipsis → menu shows **Edit** option.
4. Click Edit → page navigates to `#custom-metrics/edit?report_id=18`, heading `Edit Custom Metric`.
5. Verify form prefilled:
   - **Name:** `Test 09-05-20254` (text input prefilled)
   - **Description:** `sample4` (textarea prefilled)
   - **Formula chips:** Facebook icon `Post Comments` + ListenFirst icon `Shares X` (formula builder area prefilled with the two metric chips)
   - **Buttons:** Cancel + Save
6. Click Cancel → returns to Custom Metrics list with row `Test 09-05-20254` unchanged.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Edit option present on ellipsis menu | "Edit" menu item present | PASS |
| A2 | 5 | Edit form prefilled with current metric values | Name + Description + Formula chips all prefilled correctly | PASS |
| A3 | 5-6 | Save updates row | NOT EXERCISED — would mutate a metric owned by another user; safety per Rule 1 (no substitution + no destructive cross-user mutations) | DEFERRED |
| A4 | 7 | Edit persists across refresh | NOT EXERCISED (A3 prerequisite) | DEFERRED |

## Findings

- Edit flow uses the same builder UI as Create (per QA-85176 pattern). Form is React-controlled — initial value injection confirmed by visible prefilled inputs without any user typing.
- Sister test QA-135430 (Delete flow, QA-4325 batch 12 PASS) validated the ellipsis-Actions-menu pattern end-to-end with mutation+cleanup. Edit-Save round-trip is structurally identical but would require a self-owned sandbox metric to exercise safely.
- Recommend creating a fresh sandbox metric (per QA-85176 mutation flow) then running QA-135429 end-to-end on the new metric. Out of scope for this batch — A3+A4 carry-forward to manual LFIQA verification.

## Bugs filed

_None._
