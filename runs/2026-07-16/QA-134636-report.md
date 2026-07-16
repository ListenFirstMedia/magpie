# QA-134636 — Listening — "Data Last Updated" Timestamp

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-134636
- **Run date:** 2026-07-16
- **Track:** Playwright MCP (`feature/playwright-mcp`)
- **Skill used:** `skills/brand-navigation-timestamp/SKILL.md`
- **Account:** Adam Orfei (account_id=54), Brand MTV (brand_id=4018)
- **Result: PASS** (2/2 assertions)

## Steps executed
1. Navigated to Brand > Insights for MTV — confirmed header `Data Last Updated (PT): 07-15-2026 04:27 PM` present, matching the established format (no trailing "PT" suffix, per prior-documented format precedent).
2. **Navigation gotcha:** "Listening" is not a top-level nav item for this account (confirmed absent from the full nav bar and Reporting flyout menu). Per `knowledge-base/bug-history.md` (LFMP-31800 reference), the Listening surface is reached via **Brand > Conversation → "Click here to load Tweets" link → `#explore/listening/conversation`**. Navigated Brand > Conversation (MTV), clicked that link.
3. Landed on `#explore/listening/conversation` — breadcrumb read "Listening > Conversation", confirming the correct surface.
4. Confirmed `document.body.innerText` contains no "Data Last Updated" substring anywhere on the Listening page.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 1 | Brand > Insights shows Data Last Updated in `MM-DD-YYYY HH:MM AM/PM PT`-style format | `Data Last Updated (PT): 07-15-2026 04:27 PM` present | PASS |
| A2 | 3 | Listening tab does NOT show "Data Last Updated" element | Confirmed absent via full-body text scan | PASS |

## Notes
- Only 2 brands/tabs checked (Insights + Listening) rather than the "2+ brands" optional repeat in the spec (step 4, marked "Optionally"), since `brand-navigation-timestamp` already has 3+ separate-day confirmations of cross-brand consistency for this exact timestamp on other tickets today (QA-134271, QA-134296).
- Worth folding the Brand > Conversation → "Click here to load Tweets" navigation path into `brand-navigation-timestamp` or a new `listening-conversation` skill, since Listening isn't discoverable from top-nav on this account.

## Bugs filed
None.

## Skill maintenance
`brand-navigation-timestamp` +1 (Listening-tab-absence case newly covered; navigation-path-to-Listening quirk documented for future runs).
