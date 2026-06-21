# QA-112583 — Reporting > Follower Demographics Vs Threads Audience - Export - Data QA — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei
- **Result:** 🚫 BLOCKED (carry-forward) — sibling of QA-109749; no Threads-audience data

## Rationale
- This Data-QA parity needs Threads Audience data to compare against Follower Demographics. Threads-audience data is absent on accessible brands (no Threads identity — QA-96045), so the comparison can't be exercised. Consistent with 2026-06-05 BLOCKED.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Follower Demographics ↔ Threads Audience export parity | Numbers reconcile | NOT REACHED — no Threads-audience data | 🚫 BLOCKED |

## Bugs filed
_None (test-data gap)._
