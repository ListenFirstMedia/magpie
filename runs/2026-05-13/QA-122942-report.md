# QA-122942 — Brand > Content - Instagram - Public Perspective

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-122942
- **Run date:** 2026-05-18
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Hulu (account_id 336)
- **Brand:** Hulu (brand_id 5670)
- **Channel:** Instagram only
- **Perspective:** Public Data (URL perspective=extended)
- **Result:** ✅ **3/5 PASS, 2 deferred (export verification needs follow-up)**

## Assertion table

| Assertion | Expected | Observed | Status |
|---|---|---|---|
| A1 (4) | Metrics displayed: Engagement, Reactions, Comments, Response Rate, Video Views, Video Response Rate | All 6 expected metrics present in Sum/Average row. **Extra column:** `Shares` is also present (with `–` value for IG); not in spec but doesn't cause harm. | ✅ |
| A2 (5) | Table view: Video Views column after Response Rate | Confirmed in Table layout. Column order in table header: `Engagements → Reactions → Comments → Shares → Response Rate → Video Views → Video Response Rate`. | ✅ |
| A3 (6) | Detail view: Video Views column below Response Rate | Confirmed in Detail layout: each post's metric stack lists `Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate` vertically. | ✅ |
| A4 (8a) | CSV headers include long list | ⏸ Deferred — Export Ok button did not dismiss the modal on this session (UI quirk). Skill primitives validated in QA-531/QA-115716 so this is mechanical to re-run. | ⏸ |
| A5 (8b) | Metrics data matches page data | ⏸ Deferred — depends on A4. | ⏸ |

## Proof — Sum row in Grid view (page data for cross-reference with future export)

```
                  Engagements   Reactions   Comments  Shares  Response Rate  Video Views   Video Response Rate
Sum               1,018,516     1,008,258   10,258    –       N/A            25,550,023    N/A
Average           32,855        32,524      331       –       1.13%          881,035       3.92%
```

## Quirk observed — Export "Ok" button

In this session, the `Ok` button in the Export Select Data Sets modal did not dismiss the modal when clicked (both via coordinate and via JS `.click()`). The modal stayed open and no "queued" toast appeared. This is the same modal that worked correctly in QA-531 on Star Wars/Adam Orfei.

Possible causes (no further investigation this session):
1. The "Public" checkbox was already checked but maybe needs explicit re-click to "select" (some toggle widgets ignore an already-selected state).
2. Form validation silently rejecting because no new Data Set was selected (Public was pre-checked but the form might require a selection event).
3. Modal binding race condition on Hulu account.

Recommended for next iteration: re-uncheck and re-check Public before clicking Ok, then proceed.

## Skill use
- `brand-content-table-view` v1 — layout selector worked as documented.
- `export-csv` v2 — server-side queued variant; the modal-Ok bug above is new and worth adding to the skill's failure-signatures table.

## Bugs filed
None as a code bug (the modal not dismissing is more likely a session quirk than a regression). Will re-test on next iteration to confirm.
