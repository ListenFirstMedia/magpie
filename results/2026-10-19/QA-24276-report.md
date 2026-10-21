# QA-24276 — Brand Content - Basic Data Set - Aggregate Data Test

**Run date:** 2026-10-19 (Monday → HBO Max / HBO Max) · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** current default week Oct. 11 – Oct. 17, 2026 · **Data set:** Public (Basic) · Aggregate row read in Table View, Sum then Average (toggle in `.aggregate-row-toggle-container`)
**Verdict: PASS (A4, A6) — Reactions + Comments + Shares = Engagements on both Sum and Average rows for Facebook and TikTok; A8 (LinkedIn) NOT EVALUABLE — HBO Max has 0 LinkedIn posts in the current week, so no aggregate row renders**

## Steps / Assertions
| Step | Channel | Sum row (Reactions + Comments + Shares vs Engagements) | Average row | Status |
|---|---|---|---|---|
| 3–4 | Facebook only (Posts 30) | 181,567 + 2,935 + 6,813 = 191,315 ✓ | 6,052 + 98 + 227 = 6,377 ✓ | ✅ A4 PASS |
| 5–6 | TikTok only (Posts 56) | 1,892,925 + 12,103 + 223,300 = 2,128,328 ✓ | 33,802 + 216 + 3,988 = 38,006 ✓ | ✅ A6 PASS |
| 7–8 | LinkedIn only | **Posts (0)** — empty table, no Sum/Average row | — | 🚫 A8 not evaluable (test-data gap: no LinkedIn posts Oct 11–17 2026 on HBO Max) |

## Evidence
`.playwright-out/QA-24276/01-fb-agg.png`, `02-tiktok-agg.png`, `03-linkedin-agg.png` (empty)

## Notes
- First attempt at the TikTok read had Facebook still enabled (the app ignores a click that would deselect the last enabled channel, so enable the new channel **before** disabling the old one); re-run with a verified single-channel state — numbers above are TikTok-only.
- Suggest the spec allow a fallback range (e.g. Last 30 Days) for channels with no posts in the default week, or pick a brand with weekly LinkedIn activity for the Monday row.

## Known bugs checked
No open linked bugs.

## Bugs filed
None. · **Cleanup:** none.
