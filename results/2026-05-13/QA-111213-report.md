# QA-111213 — Data Studio IG Views & Story Views

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-111213
- **Run date:** 2026-05-18
- **Env:** dev (`app.lfmdev.in`)
- **Browser:** Regression Testing
- **User:** LFIQA (lfiqa@listenfirstmedia.com)
- **Skill used:** `data-studio-post-level-run` v1 (for the Post-Level branch)

## Result

**BLOCKED — dev environment test data gap.**

| Assertion | Status | Notes |
|---|---|---|
| A1 (step 5) Selected IG metrics displayed under nodes | ⛔ Blocked | Cannot select IG Views — the entire control is disabled when Hulu is added on this account. |
| A2 (step 6) Report loads with IG data | ⛔ Blocked | Cannot run because A1 cannot be satisfied. |
| A3 (step 9) Report shows IG Post Impressions on Post Level | ⛔ Blocked | Cannot proceed to Post Level config because Page Level run is gated by A1/A2. |

## Evidence of block

When Hulu is added to a Data Studio Page Level report on the Sony Pictures account (`account_id=51` on dev), the brand-row Public/Authorized switch renders **disabled**:

```html
<div class="al-toggle">
  <label class="al-toggle__label al-toggle__label--left">Public</label>
  <div class="al-toggle__switch al-toggle__switch--disabled">
    <input disabled class="al-toggle__checkbox" type="checkbox" id="1">
    <label class="label" for="1">...</label>
  </div>
  <label class="al-toggle__label al-toggle__label--right al-toggle__label--disabled">Authorized</label>
</div>
```

Note the `al-toggle__switch--disabled` and `al-toggle__label--disabled` modifiers, plus the `disabled` attribute on the underlying input.

Consequently, when opening **Select Metrics → Engagements → Impressions**, the **Instagram Views** option (and several other IG metrics) render with `controlled-check-box--disabled`:

```html
<span class="controlled-check-box controlled-check-box--disabled">
  <label class="controlled-check-box__label">Instagram Views</label>
</span>
```

So the test's required selection cannot be made on this dev account.

## Diagnosis

In QA-1515 we confirmed that the Brand → Content view of an authorized brand exposes IG-only datasets (e.g. `Instagram Only: Insights`) when the brand has IG Authorized data. Hulu likely has no IG Authorized perspective configured on the dev account `account_id=51`, so the brand-row toggle in Data Studio is disabled and IG metrics are filtered out.

This is consistent with the broader "Hulu test data is patchy on dev" theme we've seen across the batch (QA-1515's A8 row referenced FB/Twitter/YouTube only — no Instagram).

## Next-iteration plan

Two options:

1. **Re-run on prod or on a dev account where Hulu has IG Authorized data.** User to confirm which account on dev has Hulu IG, or grant access to a prod equivalent.
2. **Substitute brand.** If a brand other than Hulu has IG Authorized on dev (e.g. one of the Spider-Verse-family brands), the test could be re-pointed; this requires Jira-level approval since the precondition explicitly says Hulu.

Reusable skill `data-studio-post-level-run` v1 is unchanged — it already encodes the metric tree traversal pattern that will be needed once a brand with IG Authorized data is in scope.

## Bugs filed

None as a code bug — this is a dev-data gap. Flagging for the user to decide whether to (a) treat as a recurring dev-data setup gap and file a bug at the data ingestion layer, or (b) update the test case to specify a brand known to have IG Authorized data on dev.
