# QA-19710 — Brand Content - Pinterest Only: Basic - Current Date Range Data Test

**Run date:** 2026-10-23 (Friday → rotation account/brand **Ralph Lauren**) · **Track:** Playwright MCP, unattended headless (`claude -p`) · **Date range:** default current week Oct. 15 – Oct. 21, 2026 · **Channel:** Pinterest (auto-selected by the data set) · **Data set:** Pinterest Only: Basic · **Perspective:** Authorized (default)
**Verdict: PASS (with caveat) — Pin Saves + Comments = Engagements on all 65 Ralph Lauren pins and on the Sum row. The identity holds only as 0 = 0 + 0 (see Caveats).**

## Preconditions
- Login: `lfiqa@listenfirstmedia.com` via Cognito "With existing account". The session landed on the UCLA account.
- Open-bug screen (Rule 7): the case file says "None open" → run normally. `bug-history.md` / `known-quirks.md` had no QA-19710 entries (pre-grepped).
- The precondition "Sephora | Ralph Lauren" names two accounts. I ran both legs: Sephora first, then Ralph Lauren, which is Friday's rotation account.

## Steps
| # | Step | Result |
|---|------|--------|
| 1 | Switch account to Sephora (LFQA menu → Search Account → Results row), then hover Brand → Content | Breadcrumb `ACCOUNT: SEPHORA`, landed on `#explore/brand/content?brand_id=7159` (header "Sephora", account 655). The first load hung on "Loading" for ~100 s; one page reload fixed it (Posts (38) across channels) |
| 2 | Brand: Sephora | Header shows **Sephora** (brand 7159, exact name, the account default) |
| 3 | Data Set → **Pinterest Only: Basic** (visible dropdown, trusted click) | Channel auto-switched to `channels=pinterest`, `table_data_set=pinterest_only:_basic`. **Posts (0)** for Oct 15–21. No Table View to read. Screenshot `02-sephora-pinterest-basic-0posts.png` |
| 4 | Sephora: read Pin Saves + Comments per pin | Not evaluable: 0 pins in the current week |
| 5 | Switch account to Ralph Lauren (same method), hover Brand → Content | Breadcrumb `ACCOUNT: RALPH LAUREN`, landed on `brand_id=7000` (account 732). Header shows **Ralph Lauren**, the exact name and the account default. The first load hung again; one reload fixed it (Posts (35) across channels) |
| 6 | Data Set → **Pinterest Only: Basic** | `channels=pinterest`, `table_data_set=pinterest_only:_basic`, **Posts (65)** |
| 7 | Table View (`[title="Table View"]`), then scrape every row and the Sum row via DOM | 65 pin rows plus the Sum/Average row. Columns: Engagements, Pin Saves, Comments |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 (Sephora) | 4 | Pin Saves + Comments = Engagements for each pin | Posts (0) in the current week, so no pins to evaluate | not evaluable (test-data gap, not counted against the case) |
| A4 (Ralph Lauren) | 7 | Pin Saves + Comments = Engagements for each pin | 65/65 pins match, 0 failures, 0 skipped. Every pin has Engagements 0, Pin Saves "–" (treated as 0 per the skill: structurally absent for Pinterest) and Comments 0, so 0 = 0 + 0. Sum row: Engagements 0, Pin Saves "–", Comments 0 → 0 = 0 + 0 ✓ | ✅ PASS |

## Caveats
- **Weak pass.** No Ralph Lauren pin has any engagement or comment (non-zero counts: Engagements 0, Comments 0, Pin Saves 0 of 65), so the identity is only tested as 0 = 0 + 0. The same all-zero / Pin Saves "–" pattern was reported for Ralph Lauren on 2026-10-20 and 2026-10-22 (QA-20279) and for the past-range sibling QA-20334 on 2026-10-19.
- Pin Saves is "–" on all 65 pins and the Sum row. Treating it as 0 follows the `brand-content-grid-math` rule for structurally absent Pinterest metrics, but a reviewer may want to know whether Pin Saves should show real values.
- On 2026-10-19/20 this case was BLOCKED because Sephora had 0 pins. Sephora still has 0 pins this week. Only the Ralph Lauren leg gave evaluable data.

## Evidence
- `.playwright-out/QA-19710/01-content-landing.png`: Sephora Brand > Content stuck on "Loading" before the reload.
- `.playwright-out/QA-19710/02-sephora-pinterest-basic-0posts.png`: Sephora, Pinterest Only: Basic, Posts (0).
- `.playwright-out/QA-19710/03-ralph-lauren-pinterest-table.png`: Ralph Lauren Pinterest Only: Basic Table View.
- Final URL: `…#explore/brand/content?brand_id=7000&account_id=732&from=2026-10-15&to=2026-10-21&channels=pinterest&perspective=extended&table_data_set=pinterest_only%3A_basic…`
- I read the data by scripted DOM scrape. Rank 65 (last row): Wed Oct. 21, 2026 01:19 PM PDT, Ralph Lauren, Video, Engagements 0, Pin Saves –, Comments 0.

## Known bugs checked
- No open linked bugs in the case file, and no entries for QA-19710 in `bug-history.md` or `known-quirks.md`.
- Related behavior: the Brand > Content page hung on "Loading" after an account switch, on both Sephora and Ralph Lauren. One reload fixed it each time. This is transient and did not affect any assertion.

## Bugs filed
None. · **Cleanup:** none (read-only case).
