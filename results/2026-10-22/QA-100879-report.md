# QA-100879 — Brand Content > LFM vs Native > Threads Channel

**Run date:** 2026-10-22 (Thursday) — interactive re-run; the unattended runner had skipped it under its open-bug rule (LFMP-32113)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no Threads login), dev `app.lfmdev.in`
**Account:** HBO Max (account_id=657) · **Brand:** HBO Max · Channel: Threads only · Date range: Jun. 01, 2025 – Jun. 07, 2025 (the default week has no Threads posts for this brand)
**Verdict: PASS — first post "She has a type." (Sat Jun 07 2025): LFM Reactions 751 vs native 746 likes (−0.7%), Comments 8 vs 8 replies, Shares 48 vs native reposts 16 + quotes 31 = 47; same values as the 2026-10-20 run**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–4 | Brand > Content → HBO Max → Jun 01–07 2025 → Threads only | ✅ Posts (21) |
| 5 | First post metrics | ✅ Engagements 807 · Reactions 751 · Comments 8 · Shares 48 |
| 6 | Click image → native | ✅ https://www.threads.com/@hbomax/post/DKm2_-Kq1Ec — "192K views | hbomax | 07/06/2025 | She has a type. | 746 | 8 | 16 | 31" |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1–A3 | Reactions / Comments / Shares close to native | 751 vs 746 · 8 vs 8 · 48 vs 47 | ✅ PASS |

## Known bugs checked
- LFMP-32113 (Open, native lower than LFM): native is 0.7% lower here, within normal drift; the bug did not interfere.

## Bugs filed
None.

## Cleanup
Native tab closed.
