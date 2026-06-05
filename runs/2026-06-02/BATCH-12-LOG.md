# BATCH-12 LOG — QA-4325 batch 12/12 (FINAL)

Date: 2026-06-04
Tickets: QA-134436, QA-134443, QA-134517, QA-134639, QA-135430
Account: Adam Orfei
Tab group: 15361554 (closed), 952125962 (closed), 1134788487 (Custom Metrics)

## Per-ticket result

| QA ID | Title | Skill | Result |
|-------|-------|-------|--------|
| QA-134436 | Brandsets > Content - layered tag filtering | `brand-content-filter` | PASS — Brand Sets Tag popup matches Brand>Content widget; URL `filters` JSON encodes layered Include + Exclude |
| QA-134443 | Brand > Optimization - layered tag filtering | `brand-content-filter` | PASS — same widget structure as Brand>Content; URL `filters` JSON correct |
| QA-134517 | Reporting > Data Studio - layered tag filtering | n/a (probe) | FAIL-with-finding — Tag filter on DS uses LEGACY `tag-filter-popover`/`filter__options-container` widget with only Or/And + checkbox list. NO Include/Exclude radios. SAME divergence as CPR (QA-134516). |
| QA-134639 | Brand > Insights - Export across Intervals + BRI + TWC parity | n/a | BLOCKED — Brand>Insights renderer hang reproduced across 3 brands (MTV, Michael Kors, Tory Burch) on Last 30 Days IG-only. CDP 45s timeout each time. Carry-forward to known-quirks. |
| QA-135430 | Settings > Custom Metrics - Delete (MUTATING) | `settings-custom-metrics` | PASS — Delete flow end-to-end verified: ellipsis → Delete option → confirmation modal with metric name → Ok → row removed (60→59) → refresh-persistent. Mutated stale scaffold row `QA134710-test 1780570036421` (cleanup-style). |

## New bugs found

- None NEW. Findings (carry-forward):
  - **DS Tag Filter parity-gap** (QA-134517): Reporting > Data Studio missing Include/Exclude radios from APPS-59381. Sibling of CPR Tag Filter divergence. Extend the known-quirks entry to cover Data Studio.
  - **Brand>Insights renderer hang broadened** (QA-134639): now reproduces on Tory Burch IG Last 30 Days; previously only Hulu/MTV multi-channel + 6/12-month ranges. Update known-quirks `Brand Insights with Last 6/12 Months range freezes Chrome MCP renderer` entry.

## Skill usage / streak updates

- `brand-content-filter` — Brand Sets > Content + Brand > Optimization (+2 surface extensions). Pass +2.
- `settings-custom-metrics` — Delete flow end-to-end (+1).

## QA-4325 sweep status

- All 56 members have ≥1 report in `runs/2026-06-02/` (verified via diff of members file vs report filenames; 0 missing).

## QA-4325 sweep bug-finding summary (cumulative across batches 1-12)

Counts (rough taxonomy by leading section of each report's Result line):

- **PASS / re-confirmed:** ~30 (includes RECONFIRM passes — QA-298, QA-461, QA-529, QA-2062, QA-19486, QA-28405, QA-43914, QA-48160, QA-54202, QA-81494, QA-88219, QA-92735, QA-92841, QA-94977, QA-94978, QA-95067, QA-99380, QA-99416, QA-103246, QA-107134, QA-110083, QA-111242, QA-111243, QA-112579, QA-114845, QA-130076, QA-134176, QA-134182, QA-134184, QA-134188, QA-134271, QA-134272, QA-134296, QA-134436, QA-134443, QA-135430).
- **PARTIAL** (Rule 6 / spec-drift / env-bounds): QA-51442 (Brand>Stories tile failure), QA-83928 (Paid CSV partial), QA-567, QA-569, QA-575, QA-581 (stage parity not testable from dev), QA-133403 (brand-set substitution), QA-2062 (Pinterest external CDN).
- **BLOCKED** (safety policy / spec drift / renderer hang / account-switch): QA-10387 (Brand>Insights spec-drift), QA-51457 (renderer hang + spec drift), QA-52778 (URL Managers column missing — flagged finding), QA-72455 (external-account password required), QA-113595 (Admin auth), QA-113722 (Admin auth), QA-129608 (Wasserman account needed), QA-134639 (Brand>Insights renderer hang).
- **FAIL-with-finding (parity-gap):** QA-134517 (Data Studio Tag Filter missing Include/Exclude, sibling of QA-134516 CPR).

Confirmed-still-reproduced known bugs (open or carry-forward):
- APPS-58574 (Brand>Audience LinkedIn cards misalignment) — confirmed in QA-92735, QA-94977, QA-95067.
- APPS-54603 (Settings Audit deep-linking URL replace) — confirmed in QA-107134.
- LFMP-31947 (IG sentiment Read Comments not displaying) — NOT REPRODUCED (mitigated) per QA-111242.
- DATA-12209 (TikTok Daily Post Analysis endash 2026-05-16) — confirmed in QA-103246.
- LFMP-31814 / LFMP-31936 — confirmed in QA-92841.

New bugs/findings filed in reports (no Jira created per protocol):
- DS Tag Filter parity-gap (QA-134517).
- CPR Tag Filter parity-gap (QA-134516).
- Brand>Insights renderer-hang broadened to Tory Burch (QA-134639).
- QA-52778 URL Managers Fetch xlsx column missing (A2 FAIL).
- Brand Sets `1738` (Adam's Brand Set) hang on Brand Sets > Content (QA-134436 narrowed workaround).
- Brand Sets > Content filter Clear-All-only behavior (QA-133403 carry-forward).
- Custom Metrics constant-input controlled-text-input quirk (QA-135430 new finding).

Not-reproduced bugs (confirmed still fixed): BC-2 (filename), BC-3 (FX), LFMP-31947 (sentiment popup), Radaac TSV regression — all stable across re-runs.
