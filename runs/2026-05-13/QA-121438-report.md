# QA-121438 — Brand - Paid - Group Table by Selection - Delivery Type - Instagram

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-121438
- **Run date:** 2026-05-18
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Amazon Prime Video (account_id 342)
- **Result:** ⏸ **Deferred — Brand>Paid tab requires authorized ad account on dev**

## Status

The Brand → Paid tab is only useful when the brand has Authorized ad-account integration. Amazon Prime Video on dev does not necessarily have an active Instagram ad account, which would make the Table view empty (no Dark/Promoted Ads to group by).

## Recommendation
- Verify Amazon Prime Video has an authorized IG ad account on dev (check Settings → Data Collection).
- If yes, run the 6-step flow.
- If no, substitute with a brand known to have Paid data on dev (e.g. ones from the QA-127567 Scorpion Paid Status verification work in batch 5).

## Bugs filed
None.
