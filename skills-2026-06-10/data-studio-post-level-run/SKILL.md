---
name: data-studio-post-level-run
version: 2
last_verified: 2026-06-10
trust: untrusted
pass_streak: 2
preconditions: [user-logged-in, account-set]
postconditions: [report-built]
related_pages: ["/#explore/reporting/data_studio"]
related_skills: [csv-export-capture]
---

# Run a Data Studio report (Page or Post Level)

## Steps (delta from v1)
1. Direct URL `/#explore/reporting/data_studio?account_id=<id>`. Default = Page Level; click `Post Level` toggle when needed.
2. Interval: native-looking dropdown listing Days, Weeks, Months, Quarters, Aggregate (Post Level).
3. Brand picker responds to native typing; suggestions take ~3 s. Click exact-text option (`li`/option elements). For Authorized view flip the per-row `Public|Authorized` toggle.
4. Select Metrics modal: search box + category quick links; metric checkboxes work with plain coordinate clicks here; close via ×.
5. `Go` via JS button-text click. Report URL gains `&report_id=<n>`.

## Aggregate table reading (v2)
Row text concatenates `Metric|Brand|P/A|Sum|Avg` with no separators, e.g. `YouTube Video EngagementsMTVP7110` = Sum 71, Avg 10. Parse against known metric/brand names, or read cells individually. Math identity check (QA-84084): Engagements(71) = Likes(69) + Comments(2) ✓.

## Short link & URL config (QA-82626, v2)
- Pin icon: element `.short-link-button` (bottom-right circular ⚲) — **real coordinate click required** (JS .click() no-ops). Reveals input `https://app.lfmdev.in/#s/<slug>` + copy button.
- Opening the short link resolves to the full `data_studio?...&report_id=<n>` URL and renders the same report.
- `Show Configuration` restores the exact config; **Go is disabled** until config changes; deleting a metric (trash icon in metric list) enables Go; Go generates a NEW report_id.

## Changelog
- **v2** (2026-06-10): aggregate row concatenation; short-link flow; Go disabled/enabled semantics (QA-84084, QA-82626 PASS).
- **v1** (2026-05-13): initial.
