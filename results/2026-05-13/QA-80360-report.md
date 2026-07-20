# QA-80360 — Reporting > Data Studio - Adding Page-Level Metrics Functionality

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-80360
- **Run date:** 2026-05-18
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Adam Orfei (account_id 54)
- **Brand:** Michael Kors (Authorized perspective)
- **Result:** ✅ **4/4 PASS**

## Assertion table

| Assertion | Expected | Observed | Status |
|---|---|---|---|
| A1 (3) | Perspective changes to Authorized | Michael Kors `al-toggle__checkbox` flipped from unchecked → checked; **NOT disabled** for this brand on this account (contrast with Hulu's IG-Authorized in QA-111213) | ✅ |
| A2 (6) | Selected metrics displayed under Metric column with trash icon | After checking Facebook Video Posts + Twitter Video Posts + Instagram Video Posts + YouTube Posts in the metric tree, all 4 appeared as rows in the Page Level Metrics table, each with a trash icon | ✅ |
| A3 (7) | Selected metrics displayed with channel icon, metric name, trash icon | All 4 metric rows render in this exact format: ⬜channel-icon  metric-name  🗑trash | ✅ |
| A4 (8) | Twitter Video Posts removed from section | After clicking trash next to Twitter Video Posts, the row was removed; remaining rows: Facebook Video Posts, Instagram Video Posts, YouTube Posts | ✅ |

## Proof

Final Page Level Metrics state (after step 8):
```
[FB icon]     Facebook Video Posts    🗑
[IG icon]     Instagram Video Posts   🗑
[YT icon]     YouTube Posts           🗑
```

(Twitter Video Posts row, formerly between FB and IG, is gone.)

## Notes
- Michael Kors's Authorized toggle is **enabled** on Adam Orfei (unlike Hulu in QA-111213 on Sony Pictures). Confirms that authorize-toggle-disabled is a brand-specific data gap, not a Data Studio bug.

## Bugs filed
None.
