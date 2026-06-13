---
name: response-rate-math-verifier
version: 2
last_verified: 2026-06-08
last_passed_run: 2026-06-08
trust: untrusted
pass_streak: 2
preconditions: [twc-report-built, google-sheet-exported]
postconditions: [per-day-RR-checked]
inputs: [report_id, channel, date_range, sheet_url]
outputs: [pass_matrix, mismatches]
related_pages: ["/#reporting/twc/*"]
---

# Response Rate Math Verifier (per-day + aggregate)

Verifies LFM's "Response Rate" math by computing the expected value from raw inputs (Engagements, Followers, Posts) and comparing it against both the UI cell and the exported Google Sheet cell, per day, for the entire date range.

Used by:
- **QA-129801** — Instagram daily RR exclude-no-follower-days
- **QA-129802** — YouTube daily RR exclude-no-subscriber-days
- **QA-129673** — Cross-channel **aggregate** RR (depends on QA-129608 footprints baseline)

## The formula

### Per-day (single channel)
```
Footprint_day = Total Followers_day × Posts_day
RR_day        = (Engagements_day / Footprint_day) × 100
```

**Exclusion rule:** Days where `Total Followers_day` is missing (data not collected that day) are EXCLUDED — the UI must render those days' RR as blank/en-dash, and the export must omit the row OR show blank for that cell.

### Aggregate (cross-channel)
```
SumFootprints   = Σ (TotalFollowers_channel × Posts_channel) across all channels
RR_aggregate    = (TotalEngagements / SumFootprints) × 100
```

The `SumFootprints` baseline is computed in **QA-129608**. Run QA-129608 first; save the result.

## Steps

### Step 1 — Capture UI table values
After running the TWC report (use `time-window-comparison-run` skill v4 to build), read the table grid. For a per-day report the columns are: `Date | Total Followers | Engagements | Posts | Response Rate`.

```javascript
(function(){
  const rows = Array.from(document.querySelectorAll('tr.twc-row, .twc-table-row'));
  return rows.map(r => {
    const cells = Array.from(r.querySelectorAll('td, .cell')).map(c => c.textContent.trim());
    return cells;
  }).filter(r => r.length > 0);
})()
```

Normalize commas in numbers (`"1,234"` → `1234`) and percent strings (`"3.42%"` → `3.42`).

### Step 2 — Capture Sheet values
Use the `export-google-sheets` skill v2 to open the exported sheet in a tab inside the MCP group. Then read the sheet's table via JS using the Google Sheets DOM (cells are `<td>` inside `.docs-grid` or similar). Map sheet rows by date.

### Step 3 — Compute expected RR for each day
For each row `i`:
```javascript
const TF = ui[i].totalFollowers, E = ui[i].engagements, P = ui[i].posts;
let expected = null;
if (TF != null && TF > 0 && P > 0) {
  expected = (E / (TF * P)) * 100;
}
```

If `expected` is null, the day should be excluded — assert UI cell is blank/en-dash AND sheet cell is blank.

### Step 4 — Three-way compare
For each day, three values: `ui_RR`, `sheet_RR`, `expected_RR`. Allow ε = 0.01% tolerance for floating-point. Three pass conditions:
1. `|ui_RR - expected_RR| < ε`
2. `|sheet_RR - expected_RR| < ε`
3. `ui_RR == sheet_RR` (string equality after normalization)

### Step 5 — Output pass-matrix

```
Date         UI_RR    Sheet_RR  Expected_RR  Match?
2025-09-26   3.42%    3.42%     3.4173%      ✓
2025-09-27   —        —         (excl: TF=0) ✓ (excluded)
2025-09-28   2.18%    2.18%     2.1812%      ✓
...
```

Any row where Match? is ✗ → file as bug.

### Step 6 — Aggregate (for QA-129673)
After per-day verification, compute:
```javascript
const totalE = days.reduce((s, d) => s + d.engagements, 0);
const totalFootprints = days.reduce((s, d) => s + d.totalFollowers * d.posts, 0);
const expectedAggRR = (totalE / totalFootprints) * 100;
```

Compare against the report's "Aggregate" row Response Rate, AND against the Sheet's aggregate cell, AND against `SumFootprints` from QA-129608.

## Failure signatures

| Signature | Interpretation | Action |
|-----------|----------------|--------|
| `expected_RR ≠ ui_RR` on >1 day | Math bug or rounding bug | File with full diff matrix |
| `ui_RR ≠ sheet_RR` on any day | UI/export divergence | File as cross-source consistency bug |
| Day with TF=0 has non-blank RR in UI or sheet | Exclusion rule broken | Possible bug — this is exactly what QA-129801 guards against |
| `ui_RR` formatted differently than `sheet_RR` (e.g. `3.42%` vs `0.0342`) | Format normalization issue | Document as quirk; not a bug |

## Notes
- Skill assumes report is already built. Combine with `time-window-comparison-run` v4 upstream.
- Skill assumes sheet is in MCP tab group. Combine with `export-google-sheets` v2 upstream.
- For YouTube (QA-129802), substitute "Total Subscribers" for "Total Followers" — formula is identical.

## Known bug history

See `knowledge-base/bug-history.md`. No open bugs currently tied to this skill's flows; 0 historical defects (all closed) are catalogued there.

## v2 — Cross-channel aggregate verified end-to-end (2026-06-08)

### First real PASS runs

- **QA-129606** (Wasserman cross-channel) — PASS on Twitter + TikTok for FIA WEC Sep 26 – Oct 3 2025 window. Per-day formula `Engagements / (Total Followers × Posts) × 100` confirmed; em-dash exclusion for missing-follower days verified Sep 26-29 (all `–`) → Sep 30-Oct 3 populated with math matching to rounding.
- **QA-129803** (Facebook variant) — PASS using `Total Fans` instead of `Total Followers` for the FB denominator; same em-dash exclusion logic Sep 26-29 → `–`, Sep 30-Oct 3 → 0.10 / 0.43 / 0.19 / 0.18% all match computed to rounding.
- **QA-129608** (Wasserman cross-channel aggregate) — confirms that aggregate RR equals `Engagements / (Total Footprint) × 100` where `Footprint = Followers × Posts` summed across channels.

### Per-channel terminology

| Channel | Denominator field name |
|---|---|
| Instagram / Twitter / TikTok / generic | `Total Followers` |
| **Facebook** | **`Total Fans`** (not Followers) |
| YouTube | `Total Subscribers` |

### Em-dash exclusion rule (REPRODUCED across 3 channels)

For days where the denominator (`Total Followers` / `Total Fans` / `Total Subscribers`) is missing:
- **UI renders RR as `–` (em-dash)** for that day.
- **Export sheet** omits the metric value (blank cell) for that day.
- **Computation** treats the day as excluded — the day's Engagements DOES count toward Sum if rendered, but the RR calc is skipped.

This was verified for **Twitter (QA-129606)** Sep 26-29 all em-dashes, then real values Sep 30 onward; **Facebook (QA-129803)** identical em-dash pattern with `Total Fans` denominator; same per-day RR math matches.

### Account-switch friction blocker (QA-129608 batch 9)

The skill is functionally PASS but cross-channel aggregate verification per-spec sometimes requires switching to a specific account (e.g., Wasserman) that isn't in the current login session. The TWC builder mechanics are ready; the account-switching step requires Cognito re-auth or a documented account-switcher flow not currently automated. Document this as the only remaining gate before stable-promotion.

## Additional Failure signatures (v2)

| Signature | Interpretation | Action |
|---|---|---|
| FB denominator field = `Total Followers` (not `Total Fans`) | Schema regression on FB channel | Verify against latest spec |
| Em-dash day NOT excluded from RR calc | Exclusion rule broken (the bug QA-129801 guards against) | File bug |
| Per-day UI RR ≠ computed `E / (TF × P) × 100` within ε=0.01% | Math bug or rounding regression | File with full diff matrix |
| Spec brand not on current account | Account-switch gate (QA-129608 finding) | Ask LFIQA to run under correct account |

## Changelog
- **v2** (2026-06-08): Promoted from scaffold. Cross-channel aggregate verified end-to-end (QA-129608 Wasserman cross-channel; QA-129606 Twitter+TikTok; QA-129803 Facebook). Pattern: per-day RR + aggregate calculation = `Engagements / (Total Followers × Posts) × 100`. FB uses `Total Fans` not `Total Followers`. Em-dash exclusion confirmed across 3 channels.
- **v1** (2026-05-18): Initial scaffold from QA-129673/801/802 deferral. Not yet executed end-to-end.
