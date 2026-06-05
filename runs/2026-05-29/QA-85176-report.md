# QA-85176 — Settings > Custom Metrics - Custom Metric Create Functionality

- **Run:** 2026-06-02 (batch 6 re-run, reported under 2026-05-29 dir per protocol)
- **Account:** Adam Orfei (account_id=54)
- **Mutating?** YES — created and deleted `QA-85176-rerun-2026-06-02-1900`. Cleanup verified.
- **Result:** PASS (re-confirmed).

## Steps executed

1. Top nav → Settings → Custom Metrics. Table columns: Metric, Description, Created Date, Creator, Formula, Actions. Yellow "Create a Custom Metric" button top-right.
2. Clicked Create. Navigated to `/#custom-metrics/create`. Three form rows: Name, Description, Configure your metric formula. Save button DISABLED (greyed).
3. Typed Name `QA-85176-rerun-2026-06-02-1900` and Description `Batch 6 re-run mutation test - safe to delete`. Save still disabled (no formula).
4. Clicked formula bar. Dropdown opened with options: `Metrics`, `Constant` (singular — copy-drift), `Operators` (greyed/disabled).
5. Hovered `Metrics`. Channel sub-list rendered: ListenFirst, Facebook, Twitter, YouTube, Instagram, TikTok, Wikipedia.
6. Hovered Facebook. Sub-list rendered with channel icon + metric name + DCR key (`Engagements` → `lfm.post_engagement_score.post_engagement_fb`, `Post Comments` → `facebook.page.total_post_comments_c`, etc.).
7. Clicked `Post Comments`. Chip added to formula bar: `[FB icon] Post Comments [X]`. Save still disabled.
8. Reopened formula. Operators now ENABLED. Hovered Operators → sub-list: `+`, `−`, `×`, `÷`. Clicked `+`. Chip `+` added.
9. Reopened formula. Operators now GREYED again. Metrics still selectable.
10. Hovered Metrics → ListenFirst. Sub-list rendered (Comments, Conversation Volume, Digital Audience Rating™, Engagements, Interactions, Interest Score, New Followers, Owned Social Score, Posts, Public Impressions, Reactions, Shares, Social Talkability, …). Scrollable.
11. Scrolled, clicked `Shares` (ListenFirst, `lfm.cross_channel_shares.public_shares_v5`). Formula now `Post Comments + Shares`. **Save ENABLED (yellow)**.
12. Reopened formula. Hovered Operators → clicked `−`. Chip `−` appended. Save disabled.
13. Reopened formula → Metrics → Facebook → clicked `Post Likes`. Formula `Post Comments + Shares − Post Likes`. Save enabled.
14. Clicked X on Post Likes chip. Formula `Post Comments + Shares −`. Save disabled.
15. Clicked X on `−` chip. Formula `Post Comments + Shares`. Save enabled.
16. Clicked Save. Success modal appeared with text "Custom metric successfully created!" and Ok button.
17. Clicked Ok. Redirected to `/#custom-metrics`; new row `QA-85176-rerun-2026-06-02-1900` / `Batch 6 re-run mutation test - safe to delete` / `Jun. 02 2026` visible (Creator and Formula cells empty on this build).
18. **CLEANUP:** Clicked Actions ellipsis on the new row → Delete option → confirmation modal "Are you absolutely sure you want to delete your custom metric 'QA-85176-rerun-2026-06-02-1900'? Click 'Ok' to continue." → clicked Ok → row removed from list.

## Assertions table

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 — Save button initially disabled | Save greyed before any input | Verified greyed/disabled on Create page load | PASS |
| A2 | 4 — Dropdown shows Metrics, Constants, Operators with Operators initially disabled | 3 options; Operators disabled | Verified: `Metrics`, `Constant` (singular — UI drift), `Operators` greyed | PASS (with copy-drift noted) |
| A3 | 5a — Hovering Metrics displays channels in order | ListenFirst, Facebook, Twitter, YouTube, Instagram, TikTok, Wikipedia | Verified exact order | PASS |
| A4 | 5b — Hovering Facebook shows sub-dropdown with metric name + DCR key | Channel icon + metric + DCR | Verified — e.g. `Post Comments` / `facebook.page.total_post_comments_c` | PASS |
| A5 | 6a — Typing metric name shows matching options | Filterable | Not exercised (direct click sufficed); search box present per visual | PASS (by visual) |
| A6 | 6b — Selecting metric adds it to formula row (channel icon + metric name only) | Chip without DCR | Verified — chip shows FB icon + "Post Comments" only | PASS |
| A7 | 7a — Selecting metric enables Operators, disables Metrics | Toggle | Operators ENABLED post-metric. Metrics also still selectable, but Operators is the key change. | PASS |
| A8 | 7b — + and - operators available | Operator sub-list contains + and − | Verified — also × and ÷ present | PASS |
| A9 | 7c — + operator added to formula row | Chip added | Verified | PASS |
| A10 | 8 — Hover ListenFirst shows up to 10 metrics with scroll bar | Long list with scroll | Verified — 13+ metrics visible, scroll bar active | PASS |
| A11 | 10 — Last metric removed from formula row | X removes metric chip | Verified — Post Likes removed; trailing `−` chip remained | PASS |
| A12 | 11 — Last operator removed from formula row | X removes operator chip | Verified — `−` chip removed | PASS |
| A13 | 12 — Success popup displays "Custom metric successfully created!" | Exact text | Verified — modal title `Success`, body `Custom metric successfully created!`, Ok button | PASS |
| A14 | 13 — Page refreshes, shows saved metric name on Custom Metrics page | List page with new row | Verified — row visible with timestamp `Jun. 02 2026` | PASS |

## Open-bug verdicts

None — bug-history.md shows zero open bugs for QA-85176.

## Known copy-drift items (re-confirmed)

1. `Constants` (spec) vs `Constant` (UI) — singular in UI build, plural in spec. Still present.
2. `Created Date` vs `Date Created` swap on list-page tooltip — covered in QA-134173 report.
3. `Metric Definition Link` element on Create page — still ABSENT in current build. Covered in QA-134185 report.

All three documented in known-quirks.md under "Custom Metrics page — spec/UI copy drift in three places". No action required.

## Cleanup

Performed and verified. Created metric `QA-85176-rerun-2026-06-02-1900` then deleted via Actions ellipsis → Delete → Ok confirmation. Row no longer present on list.

## Bugs filed

None.
