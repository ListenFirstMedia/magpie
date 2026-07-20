# QA-86318 — Reporting > Data Studio - Adding Same Brand with Different Perspectives

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-86318
- **Run date:** 2026-05-18
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Adam Orfei (account_id 54)
- **Brands:** Michael Kors (Public) + MTV (Public) + MTV (Authorized)
- **Metrics:** Facebook Engagements, Twitter Engagements
- **Report ID:** `report_id=290894`
- **Result:** ✅ **3/3 PASS**

## Assertion table

| Assertion | Expected | Observed | Status |
|---|---|---|---|
| A1 (4) | Allow adding same brand with different perspectives | After Michael Kors + MTV added, typed MTV again, picked from dropdown — system added a second MTV row. 3 brand rows total. Both MTV rows show independent Public/Authorized toggles. | ✅ |
| A2 (6a) | Data displays for selected brands | Report `report_id=290894` rendered Facebook Engagements line chart for all 3 brands across the date range. | ✅ |
| A3 (6b) | Both Public and Authorized MTV in legend as `MTV P` and `MTV` | Legend: `Michael Kors [P]`, `MTV [P]`, `MTV` (no suffix). The `[P]` suffix denotes Public perspective; the unsuffixed `MTV` is the Authorized one. | ✅ |

## Proof — A3 legend

After Go, the chart header shows:
```
Legend: ■ Michael Kors [P]   ■ MTV [P]   ■ MTV
```

The `[P]` pill renders as a small superscript tag next to Public-perspective brands. The Authorized variant has no pill. This is consistent with the spec's expected `MTV P` and `MTV` labelling.

## Notes / quirks

- Spec says `MTV P and MTV`. Actual is `MTV [P]` (the P is visually enclosed in a small pill). Functionally equivalent.
- Michael Kors row's Authorized toggle was **not** disabled in this case (unlike Hulu in QA-111213). That suggests "toggle disabled" is brand-specific based on what Authorized data exists for that brand on this account.

## Skill use
- Reused `data-studio-post-level-run` skill navigation primitives (Reporting → DS, brand typeahead, metric tree).

## Bugs filed
None.
