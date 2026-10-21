# QA-29111 — Brand Content > Basic Data Set > Past date range data test - (Twitter and Instagram)

**Run date:** 2026-10-20 (Tuesday → rotation row: account **UCLA**, brand **University of California, Los Angeles**) — interactive re-run; the unattended runner had skipped this case under its open-bug rule (APPS-61116)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in`, skill `brand-content-grid-math`
**Account:** UCLA (account_id=799) · **Brand:** University of California, Los Angeles (brand_id=127756) · Date range: Apr. 19, 2024 – Apr. 25, 2024 · Channels: Twitter, then Instagram · Lifetime
**Verdict: PASS (via the spec's fallback) — Instagram 4/4 posts satisfy Reactions + Comments + Shares = Engagements on the Public data set; Twitter is off by ±1 on 10 of 15 tweets on the Public set (open bug APPS-61116 reproduces) and reconciles 15/15 on the Engagements Breakdown data set, which the case prescribes when the Public set does not match**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Content → UCLA brand → START/END picker Apr 19 2024 → Apr 25 2024 | ✅ `from=2024-04-19&to=2024-04-25` (dev needed ~2 min to load the 2024 window) |
| 4–5 | Twitter only → Table View → every post: Reactions + Comments + Shares vs Engagements | ⚠️ 15 tweets: 5 equal, **10 off by exactly 1** (e.g. #1 511+15+41 = 567 vs Engagements 566; #3 96+9+11 = 116 vs 117; #4 23+63+3 = 89 vs 88) |
| 5b | Spec fallback: data set → **Engagements Breakdown**, Twitter only | ✅ 15/15 tweets: Reactions + Comments + Shares = Engagements (e.g. #1 511+15+40 = 566); Organic Reactions + Comments + Shares = Organic Engagements 14/14 (one tweet with all-dash organic/paid split skipped); Organic + Paid Engagements = Engagements 14/15 (tweet #15: Engagements 2 with both splits "–") |
| 6–7 | Instagram only (Public set) → every post | ✅ 4/4 posts: Reactions + Comments + Shares = Engagements |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A5 | Twitter: Reactions + Comments + Shares = Engagements | Public set 5/15 (10 tweets ±1); Engagements Breakdown set 15/15 | ✅ PASS per spec fallback (Public-set discrepancy = APPS-61116) |
| A7 | Instagram: Reactions + Comments + Shares = Engagements | 4/4 | ✅ PASS |

## Evidence
- Session result `ctx._rerun.q29111` / `ctx._rerun.q29111_eb` (per-identity pass/fail counts and the failing rows with values).

## Known bugs checked
- **APPS-61116 (Open)** "Twitter Sum of Reactions + Comments + Shares ≠ Engagements": reproduced on the Public data set (the Public set's Shares column is 1 higher than the Breakdown set's Shares on the affected tweets, e.g. 41 vs 40 — the Public Shares appears to count one extra retweet/quote). Not a new bug.

## Bugs filed
None (existing bug reproduced).

## Cleanup
None (read-only).
