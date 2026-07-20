# QA-1677 — Brand Content - Tag Post (re-run, MUTATING with cleanup)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-1677
- **Run date:** 2026-05-27
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018)
- **Tester:** LFIQA via Claude (Cowork)
- **Mutating identifier:** `qa-1677-test-20260527-102229` (stored lowercased per platform quirk)
- **Result:** ✅ **9/9 PASS, cleanup verified.**

## Reused skills
- `switch-account` (untrusted, pass_streak 6 → 7 after this run; separate-day pass)
- `brand-content-tag-post` (untrusted, pass_streak 1 → 2 after this run; separate-day pass)
- `brand-content-table-view` (untrusted, pass_streak 1 → 2 after this run; separate-day pass)
- `brand-content-filter` (untrusted, pass_streak 1 → 2 after this run; separate-day pass)

## Steps executed

| Step | Action | State | Notes |
|---|---|---|---|
| 0 | Switched account Sephora → Adam Orfei via Search Account Results | ✓ | account_id=54 |
| 1 | Brand → Content | ✓ | URL `/explore/brand/content?brand_id=4018&account_id=54`. MTV loaded automatically. Date range default May 19–25, 2026. View Authorized. Data Set: Public. |
| 2 | Brand dropdown showed MTV pill | ✓ | (auto-selected from account default; no need to retype) |
| 3 | MTV brand selected | ✓ | 287 posts loaded |
| 4 | Click `Tag` on post 1 (rank 1, Mon May 25 2026 07:55 PM PDT, Instagram Reel — BTS Artist of the Year) | ✓ | Popup `Add Tags` opened with `Filter Tags` input, text input, Add link, Delete All Tags, Done button |
| 5 | Typed unique tag `QA-1677-TEST-20260527-102229` → clicked `Add` | ✓ | Chip rendered as **`qa-1677-test-20260527-102229ǎ ×`** (lowercased per documented platform quirk). Bottom strip on post 1 immediately updated `Tag` → `Tag (1)` |
| 6 | Clicked `Done` | ✓ | Popup dismissed |
| 7 | F5 reload | ✓ | Page reloaded; post 1 retained `Tag (1)` count |
| 8 | Filter dropdown → typed/clicked `Tag` | ✓ | Child dropdown opened with Search input + Include/Exclude radio + Or/And radio + tag list |
| 9 | Ticked `None` checkbox + clicked `Apply Filter` | ✓ | Filter chip `Tag: None [Include]` with green outline. Posts dropped 287 → 278 (posts WITHOUT tags) |
| 10 | Toggled chip to `Exclude` + clicked `Apply Filter` | ✓ | Chip `Tag: None [Exclude]` with red outline. Posts dropped to **5** (posts WITH any tag) — including the just-tagged post 1 |
| 11 | Switched Layout to Table View | ✓ | Columns: Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Video Response Rate |
| 12 | Switched Layout to Detail View | ✓ | Side-by-side detail with Tags row visible — confirmed chip `qa-1677-test-20260527-102229 ×` on the tagged post |
| **CLEANUP** | Clicked × on the chip in Detail View | ✓ | Tag removed in place; row's Tags (1) field hidden |
| Verify cleanup | F5 reload with filter still active | ✓ | Posts dropped from 5 → **4** in `Tag: None [Exclude]` — proving my test tag is gone (4 remaining are pre-existing tagged posts from other users/tests) |

## Assertion results

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 4a | Tag button is visible in the postcard | "Tag | Daily Analysis" link visible at the bottom of every postcard | ✅ PASS |
| A2 | 4b | Tag popup opens by clicking the Tag button | `Add Tags` popup with Filter Tags input, text input, Add link, Delete All Tags, Done button opened | ✅ PASS |
| A3 | 5 | Added tag count updated in posts | Bottom strip on post 1 immediately changed `Tag` → `Tag (1)` after Add | ✅ PASS |
| A4 | 6 | Correct added tags are present after refreshing the page | After F5, post 1 still shows `Tag (1)`; chip `qa-1677-test-20260527-102229` confirmed in Detail View | ✅ PASS |
| A5 | 7 | None is the first option displaying in the child dropdown of Tag filter | None was the topmost item in the tag list (above alphabetical tags like `jbkaxlx`, `qa_new 5470...`, `""abc`, `'hooh`) | ✅ PASS |
| A6 | 8 | Posts without tags will be displayed | `Tag: None [Include]` → 278 posts (down from 287). Post 1 (tagged) absent. | ✅ PASS |
| A7 | 9 | Posts with the tag will be displayed (Exclude inverts) | `Tag: None [Exclude]` → 5 posts. Post 1 (just tagged) is the first row, the other 4 are pre-existing tagged posts. | ✅ PASS |
| A8 | 10 | Posts with tags displayed on Table View | Table View shows 5 rows; first row = Mon May 25 2026 07:55 PM PDT, Instagram, Reel, MTV, 917,667 engagements (the just-tagged post) | ✅ PASS |
| A9 | 11 | Posts with tags displayed on Detail View | Detail View shows each post with full attribute panel; Tags (1) row shows `qa-1677-test-20260527-102229 ×` chip on the tagged post | ✅ PASS |

## Evidence captured
- Tag value lowercased: `QA-1677-TEST-20260527-102229` → stored as `qa-1677-test-20260527-102229` (consistent with documented skill quirk).
- Pre-existing tags in the dev environment: `jbkaxlx`, `qa_new 5470 10/16/15/35`, `""abc`, `'hooh`, `*/-+56324792`, `+tag`, `,mcxnvlkdsncs`, `,sdjfbsdjcds`, `,zmbc djb cghwds`, etc. — many test-leftovers, indicating this brand is regularly used for tagging tests.
- Filter URL encoding observed: `filters={"content_tags":[{"operator":"or","values":[""],"not":"false"}]}` for None+Include; `"not":"true"` for None+Exclude. Empty string `""` is the None sentinel.
- Filter chip border color: green (Include) vs red/pink (Exclude). Helpful visual cue.

## Cleanup (mandatory per framework)
- ✅ Test tag `qa-1677-test-20260527-102229` removed from post 1 by clicking × on the chip in Detail View.
- ✅ Cleanup confirmed by F5 reload: `Tag: None [Exclude]` count dropped from 5 to 4 (my contribution removed).
- ✅ No leftover test-tag state on the MTV brand after the run.

## Bugs filed
None. End-to-end flow worked exactly as spec'd.

## Skill registry impact
- `switch-account` → pass_streak 6 → 7 (separate-day pass).
- `brand-content-tag-post` → pass_streak 1 → 2 (separate-day pass).
- `brand-content-table-view` → pass_streak 1 → 2 (separate-day pass).
- `brand-content-filter` → pass_streak 1 → 2 (separate-day pass).
- None reach 3 separate-day passes yet, so all remain `untrusted`.
