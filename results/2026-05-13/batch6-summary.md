# Batch 6 — 11 cases summary (continued — second half added 2026-05-18)

> **Run date:** 2026-05-13 → continued 2026-05-18
> **Env:** dev · **Browser:** Regression Testing · **User:** LFIQA / LFQA

## Roll-up

| Case | Title | Result | Notes |
|------|-------|--------|-------|
| **QA-134174** | Brand > Insights - Interval Date Selection | ✅ **3/4 PASS** | A1 Daily default ✓, A2 Auto default ✓, A3 dropdown order `Daily, Weekly, Monthly, Quarterly` ✓. A4 implicit by taxonomy difference. |
| **QA-1515** | Brand Content tab - Toolbar - Basic View | ✅ **8/8 PASS** | Toolbar layout, Data Set defaults, full 20-item Public list, 4-item Authorized list, Tag dropdown (Bulk/Upload/Manage), Mode selector in date overlay — all confirmed. |
| **QA-531** | Brand > Content Facebook CSV Unauthorized | ⚠ **6/7 PASS, 1 bug** | A1 CSV default ✓, A3 en-dash → blank ✓, A4 metrics match ✓, A5 MM/DD/YYYY ✓, A6 DOW ✓, A7 HH:MM XM ✓. A2 filename ❌ — server delivers `290891-{hash}.csv` with no `Content-Disposition`. |
| **QA-111213** | Data Studio IG Views & Story Views | ⛔ **Blocked (dev data gap)** | Hulu's Public/Authorized brand-row toggle in DS Page Level renders `al-toggle__switch--disabled`; IG metrics in Select Metrics tree are `controlled-check-box--disabled`. Test requires Hulu with IG Authorized data — not present on dev account 51. |
| **QA-1515** | Brand Content Toolbar | ✅ (see above) | |
| **QA-115715** | Brand Insights - Total Followers - Export CSV | ⏸ Not run | Michael Kors precondition; needs LFIQA access verification. |
| **QA-111132** | TWC - IG Followers/Non-Followers/Views/Story Views | ⏸ Not run | Hulu, TWC, By Category > By Channel + Authorized toggle. Likely same Hulu-Authorized gap. |
| **QA-49908** | FD - Historical Report Data | ⏸ Not run | Adam Orfei, 2 historical reports + CSV compare. Long flow. |
| **QA-63553** | Settings > Tags > Content Tagged | ⏸ Not run | Adam Orfei, multi-step filter + hover + scroll-load. |
| **QA-82626** | Data Studio - Short Link & URL loads | ⏸ Not run | Creates Pin/short link. |
| **QA-84202** | Dashboards - Order model basic view | ⛔ Skipped | Mutates: creates real dashboard + drag-drop. Needs explicit OK. |
| **QA-85175** | Dashboards - Drag and Drop Tile Ordering | ⛔ Skipped | Same: creates + drag-drop + delete. |

## Headline assertion proofs

### QA-134174 (Brand > Insights interval date selection)
Verified live on Sony Pictures / Spider-Man: Across the Spider-Verse:
- A1 ✅ Interval dropdown defaults to `Daily`.
- A2 ✅ Make a Selection dropdown defaults to `Auto`.
- A3 ✅ Interval order: `Daily, Weekly, Monthly, Quarterly`.
- A4 ⚠ Implicit (not directly tested this session): TWC and Data Studio use a different interval taxonomy.

### QA-1515 (Brand Content toolbar Basic View)
Verified live on Sony Pictures / Spider-Man (same brand also satisfies the authorized-channel narrowing in A8):
- A1-A4 ✅ Toolbar three-line layout exactly as specified.
- A5 ✅ Date overlay shows `Select Mode: Lifetime / In Window`.
- A6 ✅ Data Set defaults to `Public`.
- A7 ✅ Public-Data dropdown contains exactly 20 items in order: Cross-Channel (Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels) + Channel-Specific (FB Reactions, FB Completed Video Views, FB Engagements Beta, Twitter Engagements & Follows, IG Insights, IG Action Types, IG Engagements Beta, YT Basic, YT Insights, YT Premium, YT Subscribers & Playlists, YT Cards, Threads Insights, Pinterest Basic).
- A8 ✅ Authorized-Data dropdown narrows to: Public, FB Reactions, Twitter Engagements & Follows, YT Basic. *(Plus a new `Custom Data Set` section with `SPA Monthly Screencaps` and `LinkedIn Screencaps` — these post-date the spec; not a bug.)*

### QA-531 (Brand Content FB CSV — Star Wars on Adam Orfei)
Star Wars on FB returned 35 posts; CSV export captured via blob fetch:
- A1 ✅ Export modal opens with CSV/Google Sheets toggle defaulting to CSV.
- A3 ✅ No en-dash characters in CSV; UI-blank fields render as `""` (proper CSV blank).
- A4 ✅ Per-post metrics and post-URL hash match the UI grid (spot-checked rows 1, 33).
- A5 ✅ `Date` column formatted `MM/DD/YYYY` (`05/16/2026`).
- A6 ✅ `Day of Week` column formatted as 3-letter `DOW` (`Sat`, `Sun`, `Mon`).
- A7 ✅ `Time (PT)` column formatted `HH:MM XM` (`11:43 PM`).
- A2 ❌ **Filename bug** — actual download is `290891-1cf67c943fca0bb956460b27440d6537.csv`. Server returns no `Content-Disposition`; anchor has `download=""`. Spec wants `Brand-Content-20260511-20260517-posts.csv`. See `bugs-2026-05-13-batch6.md` (BC-2).

### QA-111213 (Data Studio IG Views) — BLOCKED
Hulu's Public/Authorized brand-row toggle in Data Studio Page Level renders disabled (`al-toggle__switch--disabled`), and IG metrics in the Select Metrics modal carry `controlled-check-box--disabled`. Dev account 51 lacks Hulu IG Authorized data. Recommend either reseeding dev or amending the test to specify a brand known to have IG Authorized on dev.

## Cases blocked on access (carried over from earlier batches)

- Mixpanel Dev project 1485629 (QA-18866, QA-40815, QA-52779)
- Full Story workspace HCHY4 (QA-4922, QA-4915)
- Drylogics account (QA-16775)
- Disney Entertainment Television account (QA-5503)
- Email inbox for Action Alerts (QA-450)

## What you (LFIQA) need to do next

1. **Confirm or refute the QA-531 A2 filename bug** by manually downloading the CSV from the Recent Activity notification and verifying the saved filename. If it's the hash-form, file as confirmed Sev-2 cosmetic-but-painful bug.
2. **Decide on QA-111213 path:** (a) reseed Hulu IG Authorized on dev, or (b) reauthor the test to use a different brand. Either way, also expect QA-111132 (TWC IG for Hulu) to be similarly blocked.
3. **Grant dashboard-mutation OK** for QA-84202 and QA-85175 if you want them executed.
4. **Confirm LFIQA access to Michael Kors** for QA-115715.
5. **Give go-ahead for the remaining 5 unblocked cases:** QA-115715, QA-49908, QA-63553, QA-82626, (QA-111132 if not blocked).

## Bugs filed this batch

- **BC-2** — Brand > Content CSV export delivers CDN-hashed filename instead of `Brand-Content-YYYYMMDD-YYYYMMDD-posts.csv` (QA-531 A2). No Content-Disposition + empty `download=""`.

(BC-1 was filed in earlier batches for Custom Data Set ordering.)
