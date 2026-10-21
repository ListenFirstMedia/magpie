# QA-20527 — Brand Content > Data Test > UnPaid Posts

**Run date:** 2026-10-19 · **Track:** Playwright MCP interactive · **Account:** HBO Max (657) · **Brand:** HBO Max (155614) · **Date range:** current default week Oct. 11 – Oct. 17, 2026 · Table View · Filter **Paid: Organic** (dropdown `[data-ui-name=content_select_filter_cta]` → type "Paid" → value "Organic" → Apply Filter; URL `filters={"content_is_paid":{"values":["Unpaid"]}}`; Posts 147 → 145)
**Verdict: PASS (6/6) — every paid metric column shows "–" (or 0 for Completed Views) on every organic post across all six data sets**

| ID | Data set (channels auto-narrowed by the set) | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | Engagements Breakdown (TW+IG, 60 posts) | Paid Engagements / Reactions / Comments / Shares show "–" | 60/60 "–" in all four columns | ✅ |
| A6 | Impressions (TW+IG, 60) | Paid Impressions, Paid Reach "–" or 0 | 60/60 "–" | ✅ |
| A7 | Video Views (TW+IG, 53) | Paid Views "–" or 0 | 53/53 "–" | ✅ |
| A8 | Facebook Only: Completed & Live Videos (FB, 28) | Paid Completed Views "0" | 11 posts "0", 17 posts "–" (the rows with no video insight at all — same 17 as QA-19702); no non-zero value | ✅ (note "–" on no-insight rows) |
| A9 | Twitter Only: Engagements & Follows (TW, 23) | Paid Follows "–" | 23/23 "–" | ✅ |
| A10 | Instagram Only: Insights (IG, 37) | Paid Saves "–" | 37/37 "–" | ✅ |

## Evidence
`.playwright-out/QA-20527/01-filter-paid-organic.png` … `07-ig-insights.png`

## Known bugs checked
APPS-30184, APPS-32139, DATA-9890, DATA-12253 (closed) not reproduced. No open bugs interfere.

## Bugs filed
None. · **Cleanup:** filter cleared after the run (Clear All).
