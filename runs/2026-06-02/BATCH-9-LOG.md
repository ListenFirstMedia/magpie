# QA-4325 Batch 9 — Run Log (2026-06-04)

Batch 9/12 of QA-4325 regression sweep.

## Per-ticket

| Ticket | Result | Skill(s) | Notes |
|--------|--------|----------|-------|
| QA-112579 | PASS 6/6 (MUTATING + cleanup verified) | `brand-content-tag-post` | Michael Kors brand_id=12597. Bulk Add Tag modal: A4 default position above Help button bottom-right (rect 1162,289→1582,712); A5 cursor=grab; A6 drag from (1162,289) to (459,373); A7 stayed fixed during scroll down/up; A8 tag `qa-112579-rerun-2026-06-04` added to 28/28 posts then closed; A9 re-open at exact default position. Cleanup via Select All Posts + Delete All Tags. |
| QA-113595 | BLOCKED on safety policy (Admin page auth) | `settings-audit-logs` | Settings>Audit page renders. Key icon menu → Admin click redirects to Cognito sign-in (auth.lfmdev.in). Cannot enter password per safety rules. Steps 2-8 unverifiable. Brand-edit flow N/A. Today is Thursday (2026-06-04), test eligibility checks PASS. |
| QA-113722 | BLOCKED on safety policy (Admin page auth) | `settings-audit-logs` | Same Cognito blocker as QA-113595. Also spec requires Drylogics re-login with real password — explicit task instruction blocks that. User Creation mutation not performed. No cleanup required. |
| QA-114845 | PASS 5/5 | `chart-hover-tooltip`, `audience-metrics-export`, `brand-insights-interval-picker` | Brand>Insights renderer freeze re-confirmed on multi-channel Michael Kors. Recovery via IG-only channel filter. Donut tooltip `Facebook: 18,703,444 / Twitter: 2,898,886 / Instagram: 18,975,290 / TikTok: 2,100,000`. Bar tooltip `May. 28, 2026 Fan Growth Rate: >-0.01%`. PNGs verified end-to-end on disk: `Michael Kors-Insights-Total Followers-Pie-2026-05-27-2026-06-02.png` (49KB) and `Michael Kors-Insights-Fan Growth Rate-Bar-2026-05-27-2026-06-02.png` (73KB). |
| QA-129608 | BLOCKED — Wasserman account required | `time-window-comparison-run` + `response-rate-math-verifier` | Spec requires Wasserman; current session is Adam Orfei. FIA WEC brand not in Adam Orfei typeahead. Per Rule 1, no substitute. Account-switcher would need re-auth. Recommend SME/LFIQA executes on Wasserman directly. |

## Skill streak bumps

- `brand-content-tag-post` +1 (now 4): QA-112579 PASS 6/6 with cleanup. Drag mechanic newly verified via `left_click_drag`.
- `chart-hover-tooltip` +1 (now 9): QA-114845 PASS. New `.al-donut__tooltip` pattern documented (Channel: value rows); `.al-bar-chart__tooltip` rendered via precise bar-center hover.
- `audience-metrics-export` +1 (now 11): QA-114845 PASS — Brand>Insights tile-PNG schema confirmed identical to Brand>Audience. `Brand-Insights-<Tile>-<ChartType>-YYYY-MM-DD-YYYY-MM-DD.png` filename pattern.

## Chrome state for batch 10

- Two tabs open: tabId 1804438052 (Jira QA-129608 — can be closed), tabId 1804438062 (TWC builder on Adam Orfei). 
- ~/Downloads mounted.
- Recommend batch-10 opens fresh tab group via `tabs_close_mcp` of both then `tabs_context_mcp createIfEmpty:true`.

## Findings to escalate

- Brand>Insights multi-channel renderer freeze re-confirmed on Michael Kors (Adam Orfei). Recovery requires single-channel narrowing.
- Admin / Cognito auth path is unreachable from automation — Admin-page audit tests (QA-113595, QA-113722) require manual LFIQA execution under safety policy.
- Wasserman-account-only TWC tests (QA-129608) need an in-session account-switcher OR pre-existing Wasserman authentication. None of the QA-4325 batches so far provide a programmatic path.
