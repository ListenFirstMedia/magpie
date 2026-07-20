# QA-134636 — Listening "Data Last Updated" Timestamp — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Result:** ⚠️ PARTIAL (consistent with 2026-06-08)

## Findings
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Data Last Updated on data surfaces | 06-12-2026 04:25 PM uniform (verified QA-134271) | ✅ |
| A2 | Data Last Updated on Listening surface | Listening > Conversation is a **live Twitter-query builder** (Search Mentions / Load Tweets) with **no Data Last Updated timestamp element** — N/A on this surface | ⚠️ INCONCLUSIVE/N-A |

Listening has no freshness-dated dashboard timestamp (it's a live-query tool), so A2 is not applicable. Same as prior PARTIAL.

## Bugs filed
_None._
