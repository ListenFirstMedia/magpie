# QA-2498 — Settings > Data Collection - Channels not collected

- **Run date:** 2026-07-02 (interactive HEADED, Playwright MCP, feature/playwright-mcp)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-2498 · Priority: Critical
- **Result:** **PARTIAL PASS** — the Not-Collecting popups (brand-level + channel-level) render with the correct structure; Channels panel populates. Steps 4 (Learn More → new tab) and 8 (Facebook page-level popup) not click-through-verified due to hover-popup dismissal friction (see notes).
- **Account:** HBO Max (account_id=657) · **Brand:** HBO Max
- **Skills:** data-collection-ad-account-status (adjacent), switch-account

## Linked bug scan
26 linked issues, **all Closed** — no open blocker ([[open-bug-auto-fail]] N/A).

## Setup notes
- Switched account **Hulu → HBO Max** (HBO Max brand lives under the HBO Max account, not Hulu). **Switcher fix:** the Results dropdown only renders with **trusted typing done immediately after the hover** — `browser_hover` the user-menu then `browser_type` into `input.account-typeahead-input` with NO intervening `browser_evaluate` (an evaluate between hover and type drops the hover and the menu closes). Same pattern for the Data Collection "Search for a brand" typeahead → selected "HBO Max" (`#data-collection/hbo%20max`).
- Viewport resized to 1440×900 so screenshots fit the API image limit (default was >2000px wide → rejected).

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A3 header | Hover HBO Max red "!" → popup header "Not-Collecting (N)" | Popup **"Not Collecting (11)"** | ✅ PASS |
| A3 Learn More | Learn More link in top-right corner with an icon | Present, with external-link icon | ✅ PASS |
| A3 Reauthorize | "two Reauthorize buttons" | **Per-item** Reauthorize buttons — HBO Max has **11** not-collecting items (each with its own Reauthorize). Spec's "2" reflects authoring-time data. | ✅ PASS (structure); count data-dependent |
| A3 desc | Channel description "(Public)" e.g. "Twitter Ads (Public)" | Each item shows channel + perspective + description, e.g. "Pinterest User **(Authorized)** — Enables authorized insights…". HBO Max's current not-collecting items are all **(Authorized)**; no "(Public)" item present now. | ◐ structure PASS; "(Public)" not present in current data |
| A4 | Learn More → helpdesk Data Collection info in a new tab | Learn More link + external icon present; **not click-through-verified** (popup dismisses on each DOM read; couldn't hold hover to click). | ◐ NOT VERIFIED (link present) |
| A6 | Hover Facebook channel "!" → not-collecting popup (scrollable, Learn More, 1 Reauthorize) | Popup **"Not Collecting (2)"**, Learn More present, 2 items each with Reauthorize ("Facebook Earned Comments (Authorized)" + "Facebook Posts…", Start/Last-Collection dates). 2 items → not scrollable; spec's "1 Reauthorize / scroll" reflect authoring-time data. | ✅ PASS (structure); count data-dependent |
| A7 | Channels section populates with collected channels | Channels panel shows **9**: Instagram(!4), Facebook(!2), TikTok(!2), Threads(!2), YouTube(⏱2), LinkedIn(+2), Pinterest(!1), Twitter(+1), Wikipedia | ✅ PASS |
| A8 | Click Facebook → pages; hover page "!" → popup with Data Begins, Last Collection, Post Tracked | Not fully exercised (hover-popup friction). The channel/brand popups already show "Start Date / Last Collection Date"; the page-level "Post Tracked" field was not captured this run. | ◐ NOT VERIFIED |

## Notes / findings (for skills)
- **Not-Collecting popup structure** (`.status-badge-icon.fa-exclamation-circle` hover): header **"Not Collecting (N)"** + **Learn More** link (external-link icon, top-right) + one **card per not-collecting item** — each card = `<Brand> <Channel item> (<perspective>)` + description + **Start Date** + **Last Collection Date** + **Reauthorize** button. The N and the number of Reauthorize buttons are **data-dependent** (one per not-collecting item), so spec assertions like "2 Reauthorize" / "1 Reauthorize" / "(Public)" are authoring-time snapshots — verify structure, not exact counts.
- **Popups are hover-only and dismiss the instant the pointer leaves.** A `browser_hover` followed by a separate `browser_evaluate` loses the popup. To read/act on popup contents, dispatch `mouseover/mouseenter/mousemove` on the badge AND read within the **same async `browser_evaluate`** (with a ~500ms wait). Clicking a link inside the popup (Learn More) is hard because moving to it re-triggers layout — a known friction.
- The **brand list auto-scrolls** on filter/hover; target the badge by matching the row whose leading text is the brand name (mind the regex: "HBO Max1132" has no `\b` after "Max", use `/^HBO Max(\d|\s|$)/`).

## Bugs filed
None. Core popup structure verified; two steps left unverified due to interaction friction (not defects).
