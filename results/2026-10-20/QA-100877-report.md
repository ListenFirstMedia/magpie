# QA-100877 — Brand > Content - Impressions Data Set - Threads

**Run date:** 2026-10-20 (Tuesday) — interactive re-run; the unattended runner had marked this BLOCKED because the spec names the brand "Max" (the account's brand is "HBO Max")
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in`, skill `brand-content-grid-math`
**Account:** HBO Max (account_id=657) · **Brand:** HBO Max (brand_id=155614; spec says "Max") · Data set: Impressions · Channel: Threads only · Date range: Jan. 01, 2026 – Jan. 15, 2026
**Verdict: FAIL — Organic Impressions and Paid Impressions (and all Reach columns) render "–" on all 13 Threads posts while Impressions is populated (e.g. 79,147 / 207,811 / 33,008), so Organic + Paid = Impressions cannot hold; Engagements ÷ Impressions = Engagement Rate holds 13/13 and Engaged User Rate shows the expected en-dash**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Content → brand HBO Max (spec "Max"; the only matching brand on the account) → Jan 01–15 2026 | ✅ `from=2026-01-01&to=2026-01-15` |
| 4 | Data set → Impressions | ✅ |
| 5 | Threads only → Table View | ✅ 13 posts; aggregate Impressions 419,745, Organic Impressions –, Paid Impressions –, Reach N/A |
| 6 | Organic + Paid Impressions vs Impressions, every post | ❌ 0/13 — both components "–" on every post (sample #1: – + – vs 79,147) |
| 7 | Organic + Promoted Reach vs Reach | n/a — Reach, Organic Reach, Paid Reach all "–" on every post |
| 8 | Engagements ÷ Impressions vs Engagement Rate; Engaged User Rate en-dash | ✅ 13/13 within ±0.01 pp (#1 5,886 / 79,147 = 7.44%; #2 3,065 / 207,811 = 1.47%; #3 2,152 / 33,008 = 6.52%); Engaged User Rate "–" on every post |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A6 | Organic Impressions + Paid Impressions = Impressions | components "–" on all 13 posts, Impressions populated | ❌ FAIL (split not provided for Threads) |
| A7 | Organic Reach + Paid Reach = Reach | all three "–" | ⚠️ not evaluable (no Reach for Threads) |
| A8a | Engagements ÷ Impressions = Engagement Rate | 13/13 | ✅ PASS |
| A8b | Engaged User Rate displays en-dash | "–" on all posts | ✅ PASS |

## Evidence
- Session result `ctx._rerun.q100877` (identity counts, failing rows, aggregate row).

## Known bugs checked
- None open on the case. The same "–" split appeared identically on Dev and Prod in QA-100880 today, so this is how Threads impressions are modelled (no organic/paid split), not an environment defect — the case's A6 expectation needs a product decision (either populate Organic Impressions = Impressions for Threads, or drop A6/A7 from the Threads case).

## Notes
- Spec brand "Max" → "HBO Max" (case text should be updated; the unattended runner refuses substitutions).

## Bugs filed
None (triage needed on A6).

## Cleanup
None (read-only).
