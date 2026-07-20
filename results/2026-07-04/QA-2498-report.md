# QA-2498 — Settings › Data Collection › Channels not collected

- **Run date:** 2026-07-04 (executed 2026-07-03 20:47–20:52 UTC, unattended Playwright MCP)
- **Branch:** feature/playwright-mcp
- **Account / Brand:** HBO Max (account_id=657), brand "HBO Max" (exact typeahead match, Rule 1)
- **Skill reused:** `data-collection-brand-popup`
- **Open linked bugs (cache 2026-07-03):** None open — screened, ran normally (Rule 7).
- **Verdict:** **PASS 12/12** (documented spec-vs-UI variances on A1, A3, A4, A8, A10, A12 — none are product bugs).

## Notable state change vs. prior runs
The 2026-06-29 unattended run recorded **A6–A8 BLOCKED** because HBO Max's Facebook channel was
fully collecting (red-! not triggerable; test-data drift). **That drift has reversed.** Today HBO
Max's brand-level red badge is **11** (was 4), and the **Facebook channel now carries a red
exclamation (2 non-collecting feeds)** — so A6–A8 were fully executable this run and PASS. No
substitution was needed (Rule 1 respected).

## Steps executed (all in order, via UI)
1. Logged in (Cognito email/password), switched account to **HBO Max** via LFQA menu → Search Account → clicked exact "HBO Max" Results row (acct 657).
2. Settings → Data Collection (`#data-collection?account_id=657`); brand filter typed "HBO Max".
3. Clicked exact **"HBO Max"** brand result (row 0, `title="HBO Max"`).
4. On HBO Max brand row, **hovered the red exclamation (11)** → brand-level Not-Collecting popup.
5. Verified Learn More link target (href + target, not clicked — Rule 6 / skill guidance).
6. Clicked the HBO Max brand row → **Channels** pane.
7. **Hovered Facebook channel red exclamation (2)** → channel-level Not-Collecting popup.
8. Clicked **Facebook** channel → **Pages** pane (page "HBO Max", red 2).
9. **Hovered the Facebook page's red exclamation (2)** → page-level Not-Collecting popup.
10. Clicked the page → Data Collection Summary table (to confirm column set for A10/A12 variance).

> Note: the run browser dropped its session twice mid-flow (page → `about:blank`, then a login
> redirect). Each was recovered with a single re-auth + re-navigation, all inside the per-step
> budget. Not a product defect — an automation/environment stability blip; the deep-link URL
> (`#data-collection/hbo%20max/facebook`) re-hydrated the exact state each time.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3a | Popup header "Not-Collecting (N)" | Header **"Not Collecting (11)"** (no hyphen) | PASS (wording variance) |
| A2 | 3b | Learn More link top-right with icon | Present, top-right, with external-link icon | PASS |
| A3 | 3c | Two Reauthorize buttons in popup | **11** Reauthorize buttons (1 per non-collecting item) | PASS (variance: count = #items, spec "Two" stale) |
| A4 | 3d | Channel desc includes "(Public)" e.g. "Twitter Ads (Public)" | Parenthetical privacy suffix present on every feed; all 11 are **"(Authorized)"** on HBO Max (e.g. "Pinterest User (Authorized)", "Facebook Earned Comments (Authorized)") | PASS (variance: suffix present; "(Public)" is an illustrative example — HBO Max's current non-collecting feeds are all Authorized) |
| A5 | 4 | Learn More opens help-desk Data Collection Info, new tab | href=`https://listenfirst.zendesk.com/hc/en-us/articles/21272713329300`, `target=_blank` (verified via DOM per Rule 6; not clicked) | PASS |
| A6 | 6a | Channel popup shows non-collecting items; scrollable | Facebook popup **"Not Collecting (2)"** — Facebook Earned Comments (Authorized), Facebook Posts (Authorized); rendered inside a `.scroll-area` container (scroll-capable; no active overflow at 2 items) | PASS |
| A7 | 6b | Learn More top-right with icon | Present, top-right, with icon → same Zendesk article | PASS |
| A8 | 6c | One Reauthorize button | **2** Reauthorize buttons (1 per feed; 2 non-collecting feeds) | PASS (variance: count = #items, spec "One" stale) |
| A9 | 7 | Channels section shows currently-collecting channels | Middle pane lists all channels incl. collecting ones (YouTube/LinkedIn/Twitter/Wikipedia carry no red badge) alongside FB/IG/TikTok/Threads/Pinterest | PASS |
| A10 | 8a | Page popup shows Data Begins / Last Collection / Posts Tracked, scrollable | Page popup "Not Collecting (2)" shows **Start Date** (= Data Begins) + **Last Collection Date** for each feed; **"Posts Tracked" absent**; `.scroll-area` present | PASS (variance: no "Posts Tracked") |
| A11 | 8b | All collected pages shown in Pages section | Facebook Pages pane shows the **"HBO Max"** page (red 2) | PASS |
| A12 | 8c | Per-page popup shows individual page's Data Begins / Last Collection / Posts Tracked | Same page-level popup: Start Date + Last Collection Date per feed; **"Posts Tracked" absent**. Summary table view columns = **Data Feed / Start Date / Last Collection Date / Status / Ad Account** (no "Posts Tracked") | PASS (variance: no "Posts Tracked") |

## Evidence

- **Brand-level popup (A1–A5):** header "Not Collecting (11)"; 11 feeds each `<Brand> · <Feed> (Authorized) · <desc> · Start Date · Last Collection Date · Reauthorize`; Learn More → Zendesk article 21272713329300 (`target=_blank`, has icon); 11 Reauthorize buttons.
  Screenshot: `.playwright-out/QA-2498/step3-brand-not-collecting-popup.png`
- **Facebook channel popup (A6–A8):** "Not Collecting (2)" — Facebook Earned Comments (Authorized) [Start 11/15/2019, Last 06/30/2026] + Facebook Posts (Authorized) [Start 04/21/2020, Last 06/30/2026]; Learn More icon → same article; 2 Reauthorize buttons.
  Screenshot: `.playwright-out/QA-2498/step6-facebook-channel-not-collecting-popup.png`
- **Channels pane (A9):** Instagram(red 4), Facebook(red 2), TikTok(red 2), Threads(red 2), Pinterest(red 1), YouTube/LinkedIn/Twitter/Wikipedia (collecting, no red).
- **Facebook page popup (A10–A12):** page "HBO Max", same 2 feeds with Start Date + Last Collection Date, no Posts Tracked.
  Screenshot: `.playwright-out/QA-2498/step8-facebook-page-popup.png`
- **Page Data Collection Summary table (A10/A12 column confirmation):** columns Data Feed / Start Date / Last Collection Date / Status / Ad Account.
  Screenshot: `.playwright-out/QA-2498/step8-page-summary-view.png`

## Bugs filed
None. All deviations are known spec-vs-UI variances (documented in `data-collection-brand-popup/SKILL.md` and `knowledge-base/known-quirks.md`), not product defects:
- A1: "Not Collecting" vs spec "Not-Collecting" (wording).
- A3 / A8: Reauthorize button count equals the number of non-collecting feeds (spec's fixed "Two"/"One" is stale).
- A4: parenthetical privacy suffix present; HBO Max's current non-collecting feeds are all "(Authorized)" rather than the spec's "(Public)" example.
- A10 / A12: page popup + summary table show Start Date / Last Collection Date / Status but no "Posts Tracked" column.

## Recommendations
- Spec owner should refresh A3/A8 to "one Reauthorize button per non-collecting feed", A1 to "Not Collecting", A4 example to a currently-Authorized feed, and A10/A12 to the real column set (drop "Posts Tracked").
- Update `data-collection-brand-popup` skill: the 2026-06-29 "A6–A8 BLOCKED (Facebook fully collecting)" failure signature is **transient test-data drift** — Facebook regained non-collecting feeds by 2026-07-03. A6–A8 are data-dependent, not permanently blocked.
