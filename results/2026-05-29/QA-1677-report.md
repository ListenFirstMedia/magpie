# QA-1677 — Brand Content - Tag Post (re-run, MUTATING with cleanup)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-1677
- **Run date:** 2026-06-02 (batch 10)
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018)
- **Mutating identifier:** `qa-1677-rerun-2026-06-02-0440`
- **Result:** PASS 9/9. Cleanup verified.

## Reused skills
- `switch-account` (untrusted, pass_streak 12 — no new account switch this run, already on Adam Orfei from batch 9; not credited)
- `brand-content-tag-post` (untrusted, pass_streak 2 → 3 after this run; separate-day pass) — promotes to stable on next run.
- `brand-content-table-view` (untrusted, pass_streak 1 → 2; separate-day)
- `brand-content-filter` (untrusted, pass_streak 9 → 10; separate-day)

## Steps executed

| Step | Action | State | Notes |
|---|---|---|---|
| 0 | Already on Adam Orfei (no account switch needed) | OK | account_id=54 inherited from batch 9 |
| 1 | Brand → Content (direct nav `brand_id=4018&account_id=54`) | OK | MTV loaded, Authorized perspective, May 25-31 2026, 267 posts |
| 2-3 | MTV brand auto-loaded | OK | brand_id 4018 |
| 4 | Click `Tag (18)` on post 1 (rank 1, Mon May 25 2026 07:55 PM PDT, IG Reel — BTS Artist of the Year) | OK | `Add Tags` popup opened with 7 pre-existing tags listed: `hi`, `tag-1677-1780302399091-682`, `tag-1677-1780299880546-650`, `tag-1677-1780301130640-410`, `tag-1677-1780307278765-182`, `tag-1677-1780307810424-999`, `tag-1677-1780308204775-665`, `tag-1677-1780308340268-178` |
| 5 | Typed `qa-1677-rerun-2026-06-02-0440` via React setter, clicked `Add` | OK | Chip rendered. Bottom strip on post 1 changed Tag (18) → Tag (19). |
| 6 | Clicked `Done` | OK | Popup dismissed |
| 7 | F5 reload | OK | Post 1 still showed `Tag (19)` after refresh |
| 8 | Filter dropdown → Tag → None checkbox (custom `option-row` widget — `.click()` works on the row div) → Apply Filter | OK | Tag chip `Tag: None Include` appeared with green border. URL filter applied: `filters={"content_tags":[{"operator":"or","values":[""],"not":"false"}]}`. Posts 267 → 264. |
| 9 | Flip toggle label (`<label for="content_tags_content_tags_1">.click()`) Include → Exclude → Apply Filter | OK | Chip turned red/pink. URL `not:true`. Posts → 3. |
| 10 | Layout → Table View (via `document.querySelector('[title="Table View"]').click()`) | OK | Table layout rendered with 3 rows |
| 11 | Layout → Detail View | OK | Detail layout — post 1 shown with full attribute panel |
| CLEANUP | Click `span.label-delete.far.fa-times` next to `qa-1677-rerun-2026-06-02-0440` chip in Detail View | OK | Chip removed. |
| Verify cleanup | F5 reload | OK | Post 1 strip now shows `Tag (18)` (back to original count). Test-tag gone. |

## Assertion results

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 4a | Tag button visible in postcard | `Tag (18)` link visible at bottom of every postcard | PASS |
| A2 | 4b | Tag popup opens on click | `Add Tags` popup with Filter Tags input, text input, Add link, Delete All Tags, Done | PASS |
| A3 | 5 | Tag count updates in posts | Post 1 strip changed Tag (18) → Tag (19) immediately after Add | PASS |
| A4 | 6 | Correct tags present after refresh | After F5, post 1 retained `Tag (19)` — tag persisted across reload | PASS |
| A5 | 7 | None is the first option in Tag filter child dropdown | None was the topmost row in the Tag panel (above `jbkaxlx`, `qa_new 5470 10/16/15/35`, `""abc`, `'hooh`, `*/-+56324792`, `+tag`, etc.) | PASS |
| A6 | 8 | Posts WITHOUT tags display | `Tag: None [Include]` → Posts 264 (down from 267). Tagged BTS Reel post correctly absent. | PASS |
| A7 | 9 | Posts WITH tags display (Exclude inverts) | `Tag: None [Exclude]` → Posts 3. Post 1 = the just-tagged BTS Reel (Engagements 1,240,885); posts 2 (Megan Thee Stallion FB Gallery) and 3 (FB Image) are pre-existing tagged posts. | PASS |
| A8 | 10 | Tagged posts display in Table View | Table View shows 3 rows. Row 1: Mon May 25 2026 07:55 PM PDT, IG, Video, Reel, MTV, Collaborated (cbstv), Engagements 1,240,885, Reactions 1,230,795, Comments 10,090, Response Rate 5.87%, Video Views 10,544,379. | PASS |
| A9 | 11 | Tagged posts display in Detail View | Detail View shows post 1 with all attribute rows + `Tags (19)` row carrying the chip `qa-1677-rerun-2026-06-02-0440` (DOM-verified via `span.label-value[title="qa-1677-rerun-2026-06-02-0440"]`). | PASS |

## Evidence captured
- Tag value stored exactly as typed (no lowercasing — the previous run noted lowercasing, but this run kept original case `qa-1677-rerun-2026-06-02-0440` because all chars were already lowercase + numerics + hyphens).
- Filter URL encoding: `filters={"content_tags":[{"operator":"or","values":[""],"not":"false"}]}` for None+Include; `"not":"true"` for None+Exclude. Empty string `""` is the None sentinel — matches previous documented pattern.
- Filter chip color: green (Include) vs red/pink (Exclude). Visual cue confirmed.
- Apply Filter button requires explicit click after each filter mutation (chip changes don't auto-apply).
- Layout=table URL param did NOT auto-apply the table layout on hash route; needed explicit click of `[title="Table View"]` icon.
- None checkbox is a custom `option-row` div with `i.check-box-icon` (not a native input). `.click()` on the `.option-row` correctly toggles the `selected` class + flips icon class to `fa-check-square`.
- Include/Exclude toggle is a real `<input type=checkbox>` with `<label for>`; `label.click()` correctly flips the checked state.

## Cleanup (mandatory)
- Test tag `qa-1677-rerun-2026-06-02-0440` removed from post 1 via `span.label-delete.click()` in Detail View.
- Cleanup confirmed by F5: post 1 strip changed `Tag (19)` → `Tag (18)` — my contribution removed.
- No leftover test-tag state on MTV/Adam Orfei after this run.

## Bugs filed
None. End-to-end flow worked exactly as spec'd. No deviations from previous runs.

## Skill registry impact
- `brand-content-tag-post` → pass_streak 2 → 3 (separate-day pass) — eligible for stable promotion next run.
- `brand-content-table-view` → pass_streak 1 → 2 (separate-day pass).
- `brand-content-filter` → pass_streak 9 → 10 (separate-day pass).
