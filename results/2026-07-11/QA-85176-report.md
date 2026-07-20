# QA-85176 — Settings > Custom Metrics - Custom Metric Create Functionality

- **Verdict:** **PASS** (14/14 assertions)
- **Run:** 2026-07-11, headless Playwright MCP (`app.lfmdev.in`), unattended
- **Account:** Adam Orfei (account_id=54) — switched from Viacom (Custom Metrics is account-gated)
- **Skill reused:** `settings-custom-metrics` (v4, untrusted, streak 15)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-85176
- **Mutating:** Yes — created metric `QA-85176-TEST-2026-07-11-1538`, cleaned up at end (verified gone after reload).

## Known bugs checked
- **Case "Open linked bugs":** *None open — screen only, run normally.* (Rule 7 screen passed.)
- **bug-history.md (grep QA-85176):** 1 prior entry — a 2026-06-02 re-confirm PASS (formula `Post Comments + Shares`, create + Delete-cleanup cycle, A1-A14 PASS). No open defect tied to this flow.
- **Skill/KB notes watched:** copy drift `Constants` (spec) vs `Constant` (UI); APPS-60358 `× ÷` operators present (not a bug). Neither interferes with any assertion. No new bug reproduced.

## Steps executed
1. Pre-flight: programmatic login as `lfiqa@listenfirstmedia.com` → `#home` rendered.
2. Account was **Viacom**; switched to **Adam Orfei** via LFQA menu (hover) → Search Account typeahead → `Results` → "Adam Orfei". Breadcrumb confirmed `Account: Adam Orfei`.
3. Settings → Custom Metrics (`#custom-metrics`) — list page under Adam Orfei.
4. Clicked **Create a Custom Metric** → `#custom-metrics/create`. Save initially disabled (A1).
5. Entered Name `QA-85176-TEST-2026-07-11-1538` + Description `QA-85176 automated create-flow regression test`.
6. Clicked Formula input → dropdown `Metrics / Constant / Operators(disabled) / Parentheses` (A2).
7. Hovered Metrics → channel order ListenFirst/Facebook/Twitter/YouTube/Instagram/TikTok/Wikipedia (A3).
8. Hovered Facebook → metrics rendered as icon + name + DCR key (A4).
9. Typed "Post Comments" → filtered to FB + TikTok matches (A5); selected FB `Post Comments` → chip added, icon + name only (A6).
10. Reopened dropdown → `Operators` enabled, `Metrics`/`Constant`/`Parentheses` disabled (A7). Hovered Operators → `+ − × ÷` (A8); clicked `+` → operator chip added (A9).
11. Reopened dropdown → hovered Metrics → ListenFirst → sub-list of 13 metrics in a fixed-height scroll container showing ~10 (A10); selected `Shares`.
12. Reopened dropdown → Operators → clicked `−`; searched "Post Likes" → selected FB `Post Likes`. Formula: `Post Comments + Shares − Post Likes`.
13. Clicked X on last metric (Post Likes) → removed, Save disabled (A11).
14. Clicked X on last operator (−) → removed, formula `Post Comments + Shares`, Save enabled (A12).
15. Clicked Save → Success modal `Custom metric successfully created!` + Ok (A13).
16. Clicked Ok → redirected to `#custom-metrics`, saved row visible (A14).
17. **Cleanup:** Actions ellipsis → Delete → confirm modal (`Are you absolutely sure you want to delete your custom metric "QA-85176-TEST-2026-07-11-1538"?`) → Ok. Reloaded page → row absent (F5-persistent).

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 2 | Save button initially disabled | `button "Save" [disabled]` on fresh Create page | PASS |
| A2 | 4 | Dropdown shows Metrics, Constants, Operators; Operators initially disabled | `Metrics`, `Constant`*, `Operators [disabled]`, `Parentheses` | PASS |
| A3 | 5a | Channels in order: ListenFirst, Facebook, Twitter, YouTube, Instagram, TikTok, Wikipedia | Exact order match | PASS |
| A4 | 5b | Facebook sub-dropdown: channel icon + metric name + DCR key | e.g. Post Comments → icon + "Post Comments" + `facebook.page.total_post_comments_c` | PASS |
| A5 | 6a | Typing metric name shows matching options | "Post Comments" → FB `...total_post_comments_c` + TikTok `tiktok.post.comments_c` | PASS |
| A6 | 6b | Selecting metric adds chip (channel icon + metric name only) | Chip "Post Comments" with FB icon, no DCR key, X button | PASS |
| A7 | 7a | Selecting metric enables Operators, disables Metrics in dropdown | `Operators` enabled; `Metrics`/`Constant`/`Parentheses` disabled | PASS |
| A8 | 7b | + and − operators available | `+ − × ÷` present (× ÷ per APPS-60358; + and − both present) | PASS |
| A9 | 7c | + operator added to formula row | `+` chip appended after Post Comments | PASS |
| A10 | 8 | Hover ListenFirst shows up to 10 metrics with scroll bar | 13 metrics in fixed-height container; ~10 visible, rest clipped/scrollable (screenshot A10-listenfirst-scroll.png) | PASS |
| A11 | 10 | Last metric removed from formula row | X on Post Likes → removed; Save disabled | PASS |
| A12 | 11 | Last operator removed from formula row | X on `−` → removed; formula `Post Comments + Shares`; Save enabled | PASS |
| A13 | 12 | Success popup "Custom metric successfully created!" | Modal heading `Success` + body `Custom metric successfully created!` + Ok | PASS |
| A14 | 13 | Page refreshes, shows saved metric name on Custom Metrics page | Row: `QA-85176-TEST-2026-07-11-1538` / desc / `Jul. 11 2026` / `LFQA Testing` / formula `...total_post_comments_c + ...public_shares_v5` | PASS |

\* Spec writes "Constants" (plural); UI renders "Constant" (singular) — long-documented copy drift, not a defect.

## Evidence
- Formula persisted on saved row: `facebook.page.total_post_comments_c + lfm.cross_channel_shares.public_shares_v5` (= Post Comments + Shares).
- Screenshots under `.playwright-out/QA-85176/`: `A10-listenfirst-scroll.png` (ListenFirst 10-metric scroll flyout), `formula-row-minus.png` (formula row `Post Comments + Shares −`, minus glyph + Save disabled).
- Success modal, delete confirmation modal, and post-delete absence all captured in session snapshots.

## Notes
- A 4th formula-dropdown option `Parentheses` and `× ÷` operators (both post-spec additions, APPS-60358 / parentheses work) are present. Neither is a spec violation — the spec's stated elements are all present and correctly ordered/gated.
- Account had to be switched to Adam Orfei first (Custom Metrics account-gating). All steps executed in full via UI interaction; no substitutions.

## Bugs filed
None. No defect reproduced; the only spec/UI deltas (Constant/Constants copy drift, extra Parentheses option, × ÷ operators) are documented known/accepted behavior.
