# QA-134636 — Listening — "Data Last Updated" Timestamp

- **Date:** 2026-06-08 (QA-22296 batch 11/12)
- **Account / Brand:** Adam Orfei / MTV (brand_id=4018)
- **Status:** PARTIAL — A1 PASS (Brand>Insights timestamp verified); A2 INCONCLUSIVE — Listening tab not surfaced on Adam Orfei account

## Steps Executed

1. Navigate to Brand > Insights MTV — top-right shows `Data Last Updated (PT): 06-08-2026 04:29 AM PT` in `MM-DD-YYYY HH:MM AM/PM PT` format.
2. Search Adam Orfei nav (top-nav + sub-nav + Reporting nav) for "Listening" — not found.
3. Attempt direct URL `https://app.lfmdev.in/#explore/brand/listening?brand_id=4018&account_id=54` → 302 redirect to `brand/insights`.
4. Attempt direct URL `https://app.lfmdev.in/#listening?brand_id=4018&account_id=54` → 302 redirect to Brand Explorer.
5. DOM probe: no nav link contains "listen" (case-insensitive) anywhere on the page.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 1 | Brand > Insights shows Data Last Updated in `MM-DD-YYYY HH:MM AM/PM PT` format | `Data Last Updated (PT): 06-08-2026 04:29 AM PT` | PASS |
| A2 | 3 | Listening tab does NOT show "Data Last Updated" element | Listening tab not surfaced on Adam Orfei — direct URL nav redirects back to Brand>Insights | INCONCLUSIVE |

## Findings

- The "Listening" surface appears not to be enabled for the Adam Orfei test account. Per Rule 1, no substitution; spec assertion A2 cannot be verified end-to-end.
- A1 carry-forward: QA-134271 (batch-10 RECONFIRM PASS) and QA-134296 (batch-10 RECONFIRM PASS) both verified the `MM-DD-YYYY HH:MM AM PT` format on Brand and Brand Set surfaces. Same value re-confirmed here.
- Recommend manual LFIQA verification on an account with Listening access (e.g., Hulu / HBO Max) to close A2.

## Bugs filed

_None._
