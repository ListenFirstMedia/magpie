# QA-29235 — Brand Content > Video Views Data Set > Past date range data test - TikTok

**Run date:** 2026-10-30 (Friday) · **Track:** Playwright MCP, headless `claude -p` · **Env:** dev (app.lfmdev.in), login `lfiqa@listenfirstmedia.com` via Cognito "With existing account" · **Data set:** Video Views (`table_data_set=video_views`) · **Date range:** Jan 01, 2024 – Dec 31, 2024 · **Channel:** TikTok only (`channels=tiktok`) · **View:** Table View · **Skill:** `brand-content-grid-math` (+ `_shared/playwright-helpers/devprod-helpers.js`)

**Verdict: PASS** (Hulu / Hulu, the only brand the Friday row names). Both assertions held on 200/200 rendered posts and on the Sum row. The Robinhood and PlayOn! Sports rotation entries have no brand in the spec, so they were not run.

| Friday pair (case Description table) | Verdict |
|---|---|
| Hulu → Hulu | PASS (200/200 rendered of 1,019 posts, both identities) |
| Robinhood → (blank) | NOT RUN: spec names no brand (Rule 1: no substitute) |
| PlayOn! Sports → (blank) | NOT RUN: spec names no brand (Rule 1: no substitute) |

## Pre-screen
- Case file "Open linked bugs (as of 2026-10-20)": none open, so the Rule 7 screen passed.
- Pre-fetched bug-history and known-quirks greps for QA-29235: no entries. No skill was pre-resolved; `brand-content-grid-math` was picked by flow keyword from the REGISTRY.
- Case-file inconsistency: the Notes line says "Fri Hulu/Ralph Lauren", but the Description table says Friday = accounts Hulu / Robinhood / PlayOn! Sports, brands Hulu / (blank) / (blank). The Description table is the spec and was followed, as in earlier runs of this case and the sibling QA-29234 run today.

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Login (Cognito "With existing account"), then account switch via the profile menu "Search Account" | OK, `ACCOUNT: HULU` (account_id=336) |
| 1 | Hover Brand in the top nav, click Content | OK, `#explore/brand/content` |
| 2 | Brand selector, typed "Hulu", clicked the exact "Hulu" result; Data Set dropdown, "Video Views" | OK, brand_id=5670, `table_data_set=video_views`. Hulu was already the account's default brand; it was re-selected from the typeahead anyway |
| 3 | Date picker: START Jan 01, 2024, END Dec 31, 2024 | OK, picker fields read back "Jan 01, 2024 / Dec 31, 2024", `from=2024-01-01&to=2024-12-31` |
| 4 | Channel toggles: clicked TikTok on and every other channel off, then Apply | OK, `.channel-ghost.enabled` = [tiktok], `channels=tiktok` |
| 5-6 | Table View (`[title="Table View"]`), scraped `table.lfm-table` (Rank header present), evaluated both identities in page JS | OK |

The data set was selected before the channel, per the skill. Final URL: `brand_id=5670&account_id=336&from=2024-01-01&to=2024-12-31&channels=tiktok&perspective=extended&table_data_set=video_views`.

## Data (Table View, TikTok, Video Views data set)
Headers: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Video Response Rate, Video Views, Organic Views, Paid Views, Unclassified Views, Viewers, Video Duration, Watch Time (Minutes), Video Views (with Cross-Posts), Actions.

- Heading "Posts (1,019)". The table renders 200 posts per page, so ranks 1-200 were scraped; 819 posts were not rendered. The Channel cell is the `fa-tiktok` icon on 200/200 rows, and the Brand cell reads "Hulu" on the sampled rows.
- Oldest rendered post is dated Jan 03, 2024, inside the selected range; rank 3 is Sep 12, 2024.
- Rank 1 (Tue Feb 13, 2024): Engagements 1,055,588 / Video Response Rate 5.82% / Video Views 18,137,068 / Organic – / Paid 3,861,858 / Unclassified 14,275,210. 3,861,858 + 14,275,210 = 18,137,068. 1,055,588 / 18,137,068 = 5.820%.
- Rank 2 (Fri Jan 12, 2024): 958,628 / 6.58% / 14,563,640 / – / 9,706,791 / 4,856,849. 9,706,791 + 4,856,849 = 14,563,640. 958,628 / 14,563,640 = 6.582%.
- Rank 3 (Thu Sep 12, 2024): 922,810 / 7.60% / 12,135,388 / – / – / 12,135,388. 922,810 / 12,135,388 = 7.604%.
- Sum row (all 1,019 posts): Engagements 30,415,870 · Video Response Rate N/A · Video Views 1,065,274,655 · Organic – · Paid 675,058,663 · Unclassified 390,215,992 · Video Views (with Cross-Posts) 1,065,274,655. 675,058,663 + 390,215,992 = 1,065,274,655 exactly.
- Column totals over the 200 rendered rows: Σ Video Views 808,436,441, Σ Paid 483,675,903, Σ Unclassified 324,760,538, Σ Engagements 26,951,552. These sit below the Sum row, as expected, because 819 posts are not rendered.
- Organic Views is "–" on 200/200 posts (structurally absent for TikTok, treated as 0). Paid Views is numeric on 80 posts and "–" on 120. Unclassified Views, Video Views, Engagements and Video Response Rate are numeric on 200/200.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 | Organic Views + Unclassified Views + Paid Views = Video Views, in each grid post | 200/200 rendered posts exact, 0 mismatches, 0 skipped. 80 posts have both Paid and Unclassified numeric (e.g. rank 1: 3,861,858 + 14,275,210 = 18,137,068); 120 have Paid "–" so Unclassified = Video Views (e.g. rank 3: 12,135,388 = 12,135,388). Sum row: 675,058,663 + 390,215,992 = 1,065,274,655 | PASS (200 of 1,019 posts) |
| A6 | 6 | Engagements / Video Views = Video Response Rate | 200/200 within ±0.0051 pp of the 2-decimal display, 0 mismatches, 0 skipped. Samples above | PASS (200 of 1,019 posts) |

## Evidence
- `.playwright-out/QA-29235/00-login.png`: post-login home.
- `.playwright-out/QA-29235/10-hulu-brand.png`: Hulu account, Brand > Content before setup.
- `.playwright-out/QA-29235/11-hulu-setup.png`: Hulu brand, Video Views data set, Jan 01 – Dec 31, 2024, TikTok only.
- `.playwright-out/QA-29235/12-hulu-table.png`: Table View.
- All numbers were read from the `table.lfm-table` DOM. Screenshots were saved but not visually inspected; no verdict depended on one.

## Known bugs checked
- Case file: no open linked bugs. bug-history / known-quirks: no QA-29235 entries. No known bug reproduced or interfered with the assertions.
- Only ranks 1-200 of 1,019 posts were individually evaluated (page limit); the Sum row over all 1,019 posts also satisfies the Organic/Paid/Unclassified identity.
- The console showed errors on the app pages throughout; none related to the table data, and they were not investigated.

## Bugs filed
None filed. Possible spec gap for the QA team: the Friday row lists Robinhood and PlayOn! Sports but names no brand for either, so those legs cannot be run without substituting a brand (Rule 1). The case's Notes weekday line ("Fri Hulu/Ralph Lauren") also disagrees with its Description table and should be reconciled.
Nothing was mutated, so no cleanup was needed.

## Notes for harvest
- `brand-content-grid-math` reused unchanged (pass_streak +1; no new mechanics). `devprod-helpers.js` works loaded without `ctx._creds` (installs helpers only), then `m.login(page, host)` with creds set afterwards; creds must be written to a file under the repo root because `browser_run_code_unsafe` rejects `/tmp` paths and has no `require`/dynamic `import`.
- Hulu TikTok 2024 is a Paid/Unclassified mix (80 of 200 rendered posts carry a Paid value), unlike the all-Unclassified Sony/Ralph Lauren TikTok data.
