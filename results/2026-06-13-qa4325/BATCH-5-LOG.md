# QA-4325 — Batch 5 Log — 2026-06-13

Cases #21–25 of the 56-member set. Fresh tab per batch; bugs in markdown only.

| # | Case | Title | Result | Notes |
|---|------|-------|--------|-------|
| 21 | QA-83928 | Brand>Paid — CSV Select Channels & Data Sets + notification view | ✅ PASS | FB+Twitter Engagements data sets; CSV produced; notification "…now ready. Download file." (bell 8,362→8,363) |
| 22 | QA-84193 | Data Studio — Content Data QA — Engagements | ✅ PASS | DS Post Level MTV; Engagements Sum 1,455,696, daily sums reconcile, Avg=Sum/7 |
| 23 | QA-84194 | Data Studio — Content Data QA — Impressions | ✅ PASS | Impressions (with LinkedIn) Sum 39,726,174; needed In-Window + Authorized view to enable; daily sums reconcile |
| 24 | QA-88219 | Dashboards — save filtered Content tiles | ✅ PASS | Content Type=Image filter → Insights tiles filtered (Eng 359,390); each tile Save to Dashboard → existing "Yash" + Create Dashboard. Save not committed (no mutation) |
| 25 | QA-92735 | Brand>Audience — LinkedIn — Basic View | ✅ PASS-with-deviation | LinkedIn-specific tiles (Job Function/Industry/Seniority/Staff Count Range) render; no LinkedIn audience data for MTV (test-data gap) |

**Batch tally:** 4 PASS · 1 PASS-with-deviation · 0 FAIL · 0 BLOCKED.

**Environment events:**
- Async CSV exports (Paid + Content) verified via anchor-`click` hook + in-page `fetch`; notification view confirmed.
- **DS metric-tree friction precisely characterized:** post-level **Impressions** metrics are disabled under Lifetime/Public; require **In-Window + Authorized Data** to select.
- Brand>Audience nav needs full `from/to` params or the sub-nav hangs on skeleton.
- No Brand>Insights/Video surfaces touched this batch → no renderer hang.
