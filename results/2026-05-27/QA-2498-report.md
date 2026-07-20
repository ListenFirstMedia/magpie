# QA-2498 — Settings - Data Collection - Channels not collected (re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-2498
- **Run date:** 2026-05-27
- **Env:** dev (`app.lfmdev.in`)
- **Account:** HBO Max (account_id=657)
- **Priority:** P2 (Critical)
- **Result:** ⚠ **6/12 PASS, 3/12 UI variance (per documented skill quirks), 3/12 BLOCKED — Facebook channel/page has no Not-Collecting badge on dev (fully collecting).**

## Reused skill
- `data-collection-brand-popup` (untrusted, pass_streak 1 → 2 after this run; separate-day pass)

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Switched account Sephora → HBO Max via Search Account Results | ✓ |
| 1 | Settings → Data Collection (URL `#data-collection?account_id=657`) | ✓ — 3-pane layout, 1,064 brands |
| 2 | Search "HBO Max", click exact match from typeahead | ✓ — landed at `#data-collection/hbo%20max?account_id=657`; HBO Max highlighted with badges 6 red / 3 blue |
| 3 | Hovered the red `6` exclamation badge on HBO Max | ✓ — Popup `Not Collecting (6)` opened |
| 4 | Verified Learn More target (per skill: do NOT click — opens in new tab and derails test) | ✓ — `href = https://listenfirst.zendesk.com/hc/en-us/articles/21272713329300`, `target = _blank` |
| 5 | Clicked HBO Max brand row → Channels (9) pane populated | ✓ — Twitter, Threads, LinkedIn, Pinterest, Wikipedia, Facebook, Instagram, YouTube, TikTok visible |
| 6 | Hover Red exclamation for Facebook channel | ⚠ BLOCKED — Facebook channel has no red exclamation badge on HBO Max (fully collecting). Other channels with red ! visible: Twitter (3), Threads (2), Pinterest (1). |
| 7 | Clicked Facebook channel → Pages (1) pane populated | ✓ — `HBO Max` page row |
| 8 | Hover Red exclamation for Facebook page | ⚠ BLOCKED — HBO Max page row has no red exclamation badge. |
| 9 | Clicked HBO Max page row | ✓ — right pane replaced with `Data Collection Summary` view (NOT a popup as spec describes) |

## Assertion results

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 3a | Popup header `Not-Collecting (N)` | `Not Collecting (6)` — count matches badge; wording variance (no hyphen) per documented quirk | ✅ PASS (per skill quirk) |
| A2 | 3b | Learn More link top-right with icon | Present top-right with external-link icon | ✅ PASS |
| A3 | 3c | **Two** Reauthorize buttons in popup | Actual: 5+ visible (one per scrollable item, popup contains 6 items). Documented quirk: spec text is stale; count varies with feed count | ⚠ Variance (per skill — not a bug) |
| A4 | 3d | Channel description with privacy in parens (e.g., `Twitter Ads (Public)`) | `Threads Posts (Authorized)`, `Threads Page & Audience (Authorized)`, etc. — format matches | ✅ PASS |
| A5 | 4 | Learn More opens help-desk Data Collection article in separate tab | `target=_blank` + `href = Zendesk article URL` (article id 21272713329300). Not clicked per skill safety note. | ✅ PASS |
| A6 | 6a | Popup displays not-collecting items for Facebook; scrollable | Facebook channel has no red ! → no popup to display | ⚠ BLOCKED (data) |
| A7 | 6b | Learn More link in right corner with icon | n/a — no popup | ⚠ BLOCKED (data) |
| A8 | 6c | One Reauthorize button displayed | n/a — no popup | ⚠ BLOCKED (data) |
| A9 | 7 | Channels section populates with channels presently being collected | ✓ — Channels (9) pane filled with the brand's tracked channels | ✅ PASS |
| A10 | 8a | Popup with Data Begins / Last Collection / Posts Tracked, scrollable | Right pane replaces with full `Data Collection Summary` view (not a popup). Columns shown: `Data Feed | Start Date | Last Collection Date | Status`. **No "Posts Tracked" column.** | ⚠ Variance (per skill — possible spec drift) |
| A11 | 8b | All pages collected for Facebook shown in Pages section | Pages (1) — `HBO Max` page shown ✓ | ✅ PASS |
| A12 | 8c | Popup shows Data Begins / Last Collection / Posts Tracked for individual page | Same Data Collection Summary view shows: Facebook Page (Public) — Jan 30 2020 / May 26 2026 / ✓ Collecting; Facebook Posts (Public) — Jan 30 2020 / May 26 2026 / ✓ Collecting; Facebook Page & Audience (Authorized); Facebook Posts (Authorized); Facebook Earned Comments (Authorized); Facebook & Instagram Ads (Authorized). All collecting; **no Posts Tracked column** | ⚠ Variance (per skill — same as A10) |

## Evidence captured
- Popup `Not Collecting (6)` JS-confirmed header + 5 visible Reauthorize buttons (6 total).
- Learn More href: `https://listenfirst.zendesk.com/hc/en-us/articles/21272713329300`, target `_blank`.
- Facebook channel selected → Pages (1) shows HBO Max.
- Data Collection Summary view title: `Attributed to HBO Max Jan 3, 2000 - Dec 31, 2027`, subtitle `Click to reauthorize collection on any data feed`. 6 Facebook feeds enumerated; 5 show ✓ Collecting; 1 (Facebook & Instagram Ads Authorized) shows expand caret (multi-source feed).

## Bugs filed
None new. The two variances (A3 Reauthorize count, A10/A12 page popup structure) are previously-documented spec staleness, captured in the skill's "Variances vs Spec" section. The Facebook data BLOCKER is environmental, not a defect.

## Skill registry impact
- `data-collection-brand-popup` v1 — pass_streak 1 → 2 (separate-day pass). Still `untrusted`; needs one more separate-day run to reach `stable`.
