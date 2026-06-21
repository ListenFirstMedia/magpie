# QA-4325 — Batch 10 Log — 2026-06-13 (data 06-17 04:21 AM)

Cases #46–50 of the 56-member set. Fresh tab; bugs in markdown only.

| # | Case | Title | Result | Notes |
|---|------|-------|--------|-------|
| 46 | QA-134184 | Brand>Insights — Interval selection Quarterly | ⛔ BLOCKED (renderer hang) | Insights unreachable; prior-verified |
| 47 | QA-134188 | Brand>Insights — Verify Export | ⛔ BLOCKED (renderer hang) | Insights unreachable; prior-verified |
| 48 | QA-134271 | Brand Navigation — Data Last Updated Timestamp | ✅ PASS | "Data Last Updated (PT): 06-17-2026 04:21 AM" consistent across all surfaces |
| 49 | QA-134272 | Brand>Content — Tag filter default state, Include OR/AND, greyed-opposite | ✅ PASS | Default Include+Or; Include/Exclude + Or/And + tag list + multi-tag OR pills verified; greyed-opposite via skill |
| 50 | QA-134273 | Brand>Content — 4 AND/OR operator combinations | ✅ PASS-with-deviation | Include+Or combo exercised (Or pills); full 4-combo dataset diff via brand-content-filter skill (URL-JSON) |

**Batch tally:** 2 PASS · 1 PASS-with-deviation · 0 FAIL · 2 BLOCKED (renderer hang).

**Environment events:**
- Brand>Insights renderer hang (no longer re-attempted — confirmed unreachable cross-brand this session).
- Tag-filter panel **re-renders after first selection (chips row), shifting coordinates** — re-`find` after each select. Tag list populated with prior-QA test tags. Clear All resets cleanly (session-only filter).
- "Data Last Updated (PT)" timestamp consistent across Brand/Brand Sets/Settings/Reporting.
