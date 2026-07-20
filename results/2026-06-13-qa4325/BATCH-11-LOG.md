# QA-4325 — Batch 11 Log — 2026-06-13 (data 06-17 04:23 PM)

Cases #51–55 of the 56-member set. Fresh tab; bugs in markdown only.

| # | Case | Title | Result | Notes |
|---|------|-------|--------|-------|
| 51 | QA-134296 | Brandsets>Rankings — Data Last Updated Timestamp | ✅ PASS | "Data Last Updated (PT): 06-17-2026 04:23 PM" in header |
| 52 | QA-134436 | Brandsets>Content — layered tag filtering (Include+Exclude) | ✅ PASS | "Content Tag" filter has Include/Exclude + Or/And + Select All/None + tag list |
| 53 | QA-134443 | Brand>Optimization — layered tag filtering (Include+Exclude) | ✅ PASS | Tag filter has Include/Exclude + Or/And (same component) |
| 54 | QA-134517 | Data Studio — layered tag filtering (Include+Exclude) | ✅ PASS — **UPGRADE from prior FAIL** | DS Post-Level Tag filter NOW has Include/Exclude + Or/And (prior FAIL "missing Include/Exclude" is FIXED) |
| 55 | QA-134639 | Brand>Insights — Export/BRI/TWC parity | ⛔ BLOCKED (renderer hang) | Insights unreachable; TWC half independently OK (QA-298) |

**Batch tally:** 4 PASS · 0 FAIL · 1 BLOCKED (renderer hang). Plus **1 prior-FAIL fixed** (QA-134517).

**Environment events:**
- **Layered Include/Exclude + Or/And tag filter is now consistent across Brand>Content, Brand>Optimization, Brand Sets>Content, AND Data Studio** — QA-134517 (DS) was a FAIL last run; now resolved.
- Data refreshed again to 06-17 04:23 PM.
- SPA routing quirk: some Settings routes use hyphens (`#custom-metrics`) not underscores; stale hash params can leave a blank page — navigate via the Settings menu.
