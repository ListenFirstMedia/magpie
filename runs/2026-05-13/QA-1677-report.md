# QA-1677 — Brand Content - Tag Post

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-1677
- **Run date:** 2026-05-20
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Adam Orfei
- **Brand:** MTV
- **Priority:** P2 (Critical)
- **Mutating:** YES — added & removed tag QA-1677-TEST-20260520-104121
- **Rules applied:** All 6 from `_shared/spec-adherence-rules.md`
- **Result:** ✅ **9/9 PASS**

## Steps executed

| Step | Action | State |
|---|---|---|
| 1 | Click Brand → Content (already on Content page for MTV) | ✓ |
| 2 | Brand dropdown - MTV already selected | ✓ |
| 3 | Confirm MTV brand from list | ✓ |
| 4 | Click 'Tag' link on first post (MTV Sat May. 16, 2026 04:26 PM PDT — Eurovision2026 winner #darnadude post, IG Gallery, 158,152 engagements) | ✓ |
| 5 | Type `QA-1677-TEST-20260520-104121` in input → click Add (platform lowercased to `qa-1677-test-20260520-104121`) → click Done | ✓ |
| 6 | Refresh page (F5) | ✓ |
| 7 | Filter dropdown → search "Tag" → select Tag | ✓ |
| 8 | Tick 'None' checkbox in child dropdown (Include default) → Apply Filter | ✓ |
| 9 | Toggle chip from Include → Exclude → Apply Filter | ✓ |
| 10 | Click Table View (leftmost layout icon) | ✓ |
| 11 | Click Detail View (rightmost layout icon) | ✓ |
| Cleanup | Switch back to Grid View → click Tag (1) on post #1 → Delete All Tags → confirm "Delete 1 tag(s) from 1 post(s)" → click Done | ✓ |

## Assertion results

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 4a | Tag button visible in postcard | Confirmed — every postcard shows "Tag" or "Tag (N)" link at bottom alongside "Daily Analysis" link | ✅ PASS |
| A2 | 4b | Tag popup opens on click | Popup opened with: text input "Please enter up to 100 characters", Add link, Delete All Tags link, Done button | ✅ PASS |
| A3 | 5 | Tag count updates in posts | Tag link on post #1 changed from "Tag" → "Tag (1)" immediately after Add; Tag chip `qa-1677-test-20260520-104121 ×` visible above input | ✅ PASS |
| A4 | 6 | Correct tags present after refresh | After F5, post #1 still shows "Tag (1)" link. Tag persisted in DB | ✅ PASS |
| A5 | 7 | 'None' is first option in Tag filter child dropdown | "None" was the topmost (first) option in the alphabetically-ordered tag list (before `jbkaxlx`, `qa_new 5470 10/16/15/35`, `""abc`, `'hooh`, ...) | ✅ PASS |
| A6 | 8 | Posts WITHOUT tags display | With `Tag: None Include` applied, post count went from 85 → **78** (85 - 7 tagged = 78). Post #1 in filtered view was MTV Fri May 15, 2026 10:25 AM PDT (untagged Music to Blank to post) | ✅ PASS |
| A7 | 9 | Posts WITH tags display | After flipping toggle to `Tag: None Exclude`, post count = **7** (matches the 7 tagged posts). Post #1 in this view is my tagged Eurovision post (Sat May 16, 04:26 PM PDT, 158,152 engagements) | ✅ PASS |
| A8 | 10 | Tagged posts display in Table View | Table View showed 7 rows with columns Rank, Date, Channel, Brand, Type, Live, Publish Type, Paid, Sponsor, Collaborated, Text, Engagements, Reactions, Comments, Shares, Response Rate, Video Views, Response Rate. Row 1 = my tagged post. Sum row shows 451,139 engagements / 446,962 reactions / 1,904 comments / 2,273 shares / N/A response / 4,178,352 video views | ✅ PASS |
| A9 | 11 | Tagged posts display in Detail View | Detail View showed each post in expanded form with image on left and labelled fields on right (Date, Channel, Brand, Type, Publish Type, Paid, Live, Collaborated, Engagements, Reactions, Comments, Response Rate). Post #1 detail: Date=Sat May 16 2026 04:26 PM PDT, Channel=Instagram, Brand=MTV, Type=Gallery, Publish Type=Original Post, Paid=–, Live=No, Collaborated=darnadude, Engagements=158,152, Reactions=156,822, Comments=1,330, Response Rate=0.75% | ✅ PASS |

## Evidence
- Tag added at 2026-05-20 10:41:21 PDT
- Tag persisted across page refresh
- 85 posts (total) → 78 posts (Tag: None Include = without tags) → 7 posts (Tag: None Exclude = with tags)
- Layout selector verified at all 3 positions (Table / Grid / Detail)
- Tag cleanup confirmed via "Delete 1 tag(s) from 1 post(s)" confirmation dialog

## Skill use
- New skill drafted: `brand-content-tag-post` (see skill file)
- `_shared/spec-adherence-rules.md` Rule 3 (every step) and Rule 6 (mutation cleanup) applied

## Observations / minor notes
- Platform automatically lowercases tag values (`QA-1677-TEST-20260520-104121` → `qa-1677-test-20260520-104121`). Not in spec but functional.
- The chip toggle for Include/Exclude requires a precise click on the toggle slider, not the chip text. Standard `input.toggle-switch-checkbox` pattern (see skill).
- The "Add Tags" header title was visible only after page scroll while popup open. UI nit, not a bug.

## Bugs filed
None.
