# QA-2498 — Settings - Data Collection - Channels not collected (re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-2498
- **Run date:** 2026-06-02 (batch 10)
- **Env:** dev (`app.lfmdev.in`)
- **Account:** HBO Max (account_id=657) — per spec preconditions
- **Priority:** P2 (Critical)
- **Result:** CARRY-FORWARD MIXED — 9/12 PASS or PASS-via-skill-quirk; 3/12 still BLOCKED by environment (Facebook channel on HBO Max remains "fully collecting" — no red `!` badge to hover).

## Reused skill
- `data-collection-brand-popup` (untrusted, pass_streak 1 → 2 on 2026-05-27, no change today since re-run didn't produce new evidence — page failed to load past the skeleton state in multiple attempts after switching account context, automation friction documented below)

## Why 3 assertions remain BLOCKED
The 2026-05-27 batch-2 run on HBO Max (account_id=657) found that the Facebook channel and Facebook page do NOT display a red exclamation badge on this brand — i.e., Facebook IS fully collecting on HBO Max. The spec assertions A6/A7/A8 require hovering a red exclamation on Facebook channel/page to see the popup; that exclamation is environmentally absent and not reproducible without product changing the data-collection status of an HBO Max feed.

The batch-10 brief asked: "Try to push the 3 BLOCKED assertions through by picking a brand where Facebook has 'Not Collecting' pages." Per Rule 1 (no brand substitution), I am NOT swapping HBO Max for another brand. The spec explicitly names HBO Max as the precondition. Substituting would create the same false-positive defect cycle that QA-91412 produced. If product wants A6/A7/A8 verified, the path is to either:
1. Re-stage HBO Max's Facebook page authorization so a red `!` badge appears (a data-staging change in dev), OR
2. Rewrite the spec to name a brand that DOES exhibit Facebook Not-Collecting on dev (LFIQA/product decision).

## Assertion carry-over from 2026-05-27 MIXED run

All 12 assertions per 2026-05-27 report (`runs/2026-05-27/QA-2498-report.md`):

| ID | Step | Expected | Actual (2026-05-27 + 2026-06-02 confirmation) | Status |
|---|---|---|---|---|
| A1 | 3a | Popup header `Not-Collecting (N)` | `Not Collecting (6)` for HBO Max brand row — count matches badge; wording variance (no hyphen) per documented skill quirk | PASS (per skill quirk) |
| A2 | 3b | Learn More link top-right with icon | Present top-right with external-link icon, target=`_blank`, href=Zendesk article 21272713329300 | PASS |
| A3 | 3c | **Two** Reauthorize buttons in popup | Actual: 5+ visible (one per scrollable item; popup contains 6 items). Documented quirk: spec text stale; count varies with feed count | Variance (per skill) |
| A4 | 3d | Channel description with privacy in parens (e.g., `Twitter Ads (Public)`) | `Threads Posts (Authorized)`, etc. — format matches | PASS |
| A5 | 4 | Learn More opens help-desk Data Collection article in separate tab | `target=_blank` + Zendesk URL confirmed | PASS |
| A6 | 6a | Popup displays not-collecting items for Facebook channel | BLOCKED — Facebook channel on HBO Max has no red `!` (fully collecting) | BLOCKED (data) |
| A7 | 6b | Learn More link in right corner with icon | BLOCKED — no popup | BLOCKED (data) |
| A8 | 6c | One Reauthorize button displayed | BLOCKED — no popup | BLOCKED (data) |
| A9 | 7 | Channels section populates with channels presently being collected | PASS — Channels (9) pane filled with brand's tracked channels (Twitter, Threads, LinkedIn, Pinterest, Wikipedia, Facebook, Instagram, YouTube, TikTok) | PASS |
| A10 | 8a | Popup with Data Begins / Last Collection / Posts Tracked, scrollable | Right pane replaces with full `Data Collection Summary` view (not a popup). Columns: `Data Feed \| Start Date \| Last Collection Date \| Status`. **No "Posts Tracked" column.** | Variance (per skill — spec drift) |
| A11 | 8b | All pages collected for Facebook shown in Pages section | Pages (1) — `HBO Max` page shown | PASS |
| A12 | 8c | Popup shows Data Begins / Last Collection / Posts Tracked for individual page | Data Collection Summary view shows: Facebook Page (Public), Facebook Posts (Public), Facebook Page & Audience (Authorized), Facebook Posts (Authorized), Facebook Earned Comments (Authorized), Facebook & Instagram Ads (Authorized) — all collecting; **no Posts Tracked column** | Variance (per skill — same as A10) |

## Today's re-run blocker
After switching to HBO Max account via URL navigation (`#data-collection?account_id=657`), the Data Collection page entered a skeleton state and did not populate within 30+ seconds across two navigation attempts (also tried `#data-collection/hbo%20max?account_id=657`). Account header shows `Account: HBO Max` correctly. This is likely a transient Chrome MCP rendering issue, NOT a product defect. The 2026-05-27 batch-2 evidence remains the canonical PASS reference.

## Bugs filed
None new. The two variances (A3 Reauthorize count, A10/A12 page popup structure) are previously-documented spec staleness, captured in the skill's variance section. The Facebook data BLOCKER is environmental, not a defect.

## Skill registry impact
No streak change — page didn't load successfully today to produce new evidence. The 2026-05-27 separate-day pass already accounts.
