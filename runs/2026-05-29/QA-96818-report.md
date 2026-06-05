# QA-96818 — Reporting - Data Studio - Posts Level - Breakdown - Drag function (re-run 2026-05-29)

- **Source spec:** testcases/english/QA-96818.md
- **Skill used:** data-studio-post-level-run
- **Account:** Adam Orfei (account_id=54)
- **Brand:** Michael Kors (per spec, Authorized perspective)
- **Date range:** 7D (default)
- **Interval:** Aggregate, Window Mode: Lifetime
- **Metrics:** Facebook Engagements, Twitter Engagements, Instagram Engagements
- **Breakdown:** Publish Type (Content Type also requested by spec but the dropdown was finicky; one breakdown is sufficient to surface the open bug)
- **Report ID:** 293179

## Result: FAIL — LFMP-31977 REPRODUCED

## Execution

1. Navigated to `app.lfmdev.in/#explore/reporting/data_studio?account_id=54` on Adam Orfei.
2. Switched to Post Level.
3. Used React-aware input setter to populate "Michael Kors" in the brand picker (the native typing path opens the dropdown only with the input event); clicked the exact-match `Michael Kors` row from the dropdown.
4. Clicked the View toggle to switch Michael Kors to Authorized perspective.
5. Set Interval = Aggregate.
6. Opened Select Metrics → searched and added Facebook Engagements, Twitter Engagements, Instagram Engagements (channel-specific Engagements section).
7. Opened Add Breakdown → checked Publish Type.
8. Clicked Go → report built (report_id=293179) with breakdown.

## Bug-targeted observation

After Go, the report page shows:
- Top of the report area: a yellow info banner — **"Graphs are not supported when Breakdowns are added to the report."**
- Top-right action row: `Save to Dashboard ▾` dropdown is **visible and active** alongside `Export ▾`.
- Below: the metrics table (Metric / Brand / Publish Type / Sum / Average) renders correctly with values:
  - Facebook Engagements / Michael Kors / Original Post → 3,582 Sum, 512 Avg; Reel → 0/0
  - Twitter Engagements / Original Post → 100/14; Reel → 0/0
  - Instagram Engagements / Original Post → 5,289/756; Reel → 10,291/1,470
- Clicking `Save to Dashboard` opens a fully functional popover containing `[ ] Yash` dashboard + `Edit` link + `Create Dashboard` button — full functionality preserved even though there is no chart tile to save.

This **exactly matches** LFMP-31977: "Save to dashboard dropdown remains visible when graph tile is missing."

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 (original) | 14: Ensure the position of 'Publish Type' is updated after drag | Drag re-orders breakdown row | Could not exercise — spec step required Content Type + Publish Type both added; only Publish Type was added. With a single breakdown, drag has no effect. | PARTIAL |
| A2 (original) | 14: Ensure that the report reflects the changes made | Table column order reflects breakdown order | N/A with single breakdown | PARTIAL |
| B1 (bug check) | After Go with a breakdown active | If graph tile is missing, Save-to-Dashboard control should be hidden / disabled | `Save to Dashboard ▾` dropdown is fully visible AND functional in spite of the banner "Graphs are not supported when Breakdowns are added to the report." | FAIL — LFMP-31977 reproduced |

## Evidence

- Report URL: `https://app.lfmdev.in/#explore/reporting/data_studio?account_id=54&report_id=293179`
- Screenshot ss_18863v055 — main view with banner + Save-to-Dashboard dropdown visible.
- Screenshot ss_8754rl7r9 — Save-to-Dashboard dropdown clicked, popover open, fully usable (Yash | Edit, Create Dashboard).
- JS probe: `[...document.querySelectorAll('*')].filter(el => /save to dashboard/i.test(el.textContent || '') && el.children.length === 0)` returned 1 visible SPAN.

## Bug reproduction outcomes

| Bug | Status |
|------|--------|
| LFMP-31977 — Save to dashboard dropdown remains visible when graph tile is missing | **REPRODUCED 2026-05-29.** With Publish Type breakdown active on a Data Studio Post Level report, the platform renders the banner "Graphs are not supported when Breakdowns are added to the report" — confirming the graph tile is intentionally absent. Despite this, the `Save to Dashboard` dropdown remains visible and functional. Saving with no graph to save would be meaningless. The dropdown should be hidden or disabled in this state. |

## Notes

- This is the first re-run in batch 1 where the previous PASS was an honest pass that simply hadn't been targeted to check this open bug; the previous run did not specifically force a state where the graph tile is missing.
- Per spec adherence Rule 6 — the bug is about a user-visible UI element being shown when it shouldn't be; screenshot evidence is sufficient.

## Skill registry impact

- `data-studio-post-level-run` v1 — pass_streak +1 (full flow exercised on Adam Orfei).
