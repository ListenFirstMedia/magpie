# QA-129608 — Handle Abnormally High Response Rate – Aggregate Value Calculation Across Multiple Channels — 2026-06-13

- **Env:** Dev (app.lfmdev.in) · **Account:** Adam Orfei · **User:** Yash · **Brand Set:** Adam's Brand Set (1738) · **Window:** Jun 1–15 2026
- **Skills:** response-rate-math-verifier
- **Result:** ✅ PASS

## Steps
1. Brand Sets > Content for Adam's Brand Set (Table View), **Rank → Response Rate** (Public). Posts (5,839) across **multiple channels** (FB/X/IG/YT/TikTok) and **multiple brands** (NBA, WWE, Nashville SC, The Walking Dead, MTV, Adam Orfei).
2. Inspected the Sum/Average aggregate row and individual post Response Rates.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| Aggregate handles cross-channel RR | No abnormally-high aggregate value | **Sum/Average row = N/A** (rate not naively summed/averaged across brands/channels) | ✅ |
| Individual RR values sane | No blown-up (>100%/1000%) rates | Max **74.80%** (Nashville SC), then 20.92% / 12.99% / 8.44% … down to ~0.75% — all sane | ✅ |
| Cross-channel/brand scope | Multiple channels + brands represented | TikTok/IG/Gallery/Video across NBA/WWE/Nashville SC/TWD/MTV/Adam Orfei | ✅ |

## Notes / automation learning
- The "abnormally high response rate" is **handled by showing N/A in the cross-channel/cross-brand aggregate** row — the app does NOT compute a misleading aggregate rate by naively summing/averaging per-post rates across different brands' follower bases. Per-post RRs remain individually correct and bounded (max 74.80%).
- Consistent with the `response-rate-math-verifier` pattern: rate metrics aren't aggregated into a single nonsensical value; aggregate = N/A (analogous to the em-dash/N/A handling). For a single-brand RR aggregate the formula `Engagements / (Total Followers × Posts) × 100` applies; across a multi-brand set it's correctly N/A.

## Bugs filed
_None._
