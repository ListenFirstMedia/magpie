# QA-21916 — Brand Content > LFM vs Native > YouTube Channel

**Run date:** 2026-11-18 (Wednesday) · unattended headless (`claude -p`, Playwright MCP) · dev `app.lfmdev.in` · login `lfiqa@…` via Cognito "With existing account"
**Rows tested (Description table, Wednesday):** (1) Account **Apple Services** / Brand **Apple Music**; (2) Account **Condé Nast** / Brand **GQ - Japan**
**Channel:** YouTube only (data set auto-switched to `YouTube Only: Basic`) · **Date range:** default week Nov. 10, 2026 – Nov. 16, 2026 (Lifetime)

## Verdict: PASS
Both Wednesday rows have YouTube posts; LFM Likes/Comments of the first post track the native YouTube page closely (Likes +4.9% / +1.9%, Comments +1.5% / 0%), all inside the ~10% drift bound used for the native checks.

## Steps executed
| # | Step | Apple Services / Apple Music | Condé Nast / GQ - Japan |
|---|------|------|------|
| pre | Log in, switch account via profile menu > Search Account > **Results** option (real mouse click) | ✅ header `ACCOUNT: APPLE SERVICES` (account_id=409) | ✅ header `ACCOUNT: CONDÉ NAST` (account_id=487). Option text is "Condé Nast" (accent) = the case's "Conde Nast"; sole result, no substitution |
| 1 | Hover Brand > Content (top nav) | ✅ | ✅ |
| 2 | Add a Brand | ✅ default brand is the exact spec brand **Apple Music** (brand_id=31783) — no change needed | ✅ default brand is the exact spec brand **GQ - Japan** (brand_id=170350) |
| 3 | Enable YouTube Channel Only | ✅ disabled the 6 default ghosts, enabled `youtube` ghost, Apply → `channels=youtube`, Posts (2) | ✅ same → Posts (4) |
| 4 | Note Likes + Comments of first post | ✅ #1 "Lil Baby 'Fresh' Review, Busta Rhymes on 30 Years of The Coming & DILLAGENCE II \| Rap Life Review", THU NOV. 12 2026 02:00 PM PST — **Video Views 19,741 · Likes 369 · Comments 66** | ✅ #1 "#ジョングク …グラフ 65年にわたる輝きの回顧展…", TUE NOV. 10 2026 11:40 PM PST — **Video Views 40,298 · Likes 1,741 · Comments 31** |
| 5 | Click the image on the first post | ✅ real click on `.image-link` → popup `https://www.youtube.com/watch?v=9ZJfuRnYZVc` | ✅ popup `https://www.youtube.com/watch?v=5f6O1ep4NUE` |
| 6 | Note native Likes + Comments | ✅ like button label "like this video along with 386 other people" (→ 387 incl. the viewer's slot), comments header "67 Comments" | ✅ label "like this video along with 1,774 other people" (→ 1,775), "31 Comments" |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A6a | 6 | LFM metrics should not vary greatly from native — Apple Music, Likes | LFM 369 vs native 387 (386 "other people" + 1): native +18 / **+4.9%** (+4.7% if 386 taken literally) | ✅ PASS |
| A6b | 6 | Apple Music, Comments | LFM 66 vs native 67: native +1 / **+1.5%** | ✅ PASS |
| A6c | 6 | GQ - Japan, Likes | LFM 1,741 vs native 1,775 (1,774 + 1): native +34 / **+2.0%** (+1.9% if 1,774 literal) | ✅ PASS |
| A6d | 6 | GQ - Japan, Comments | LFM 31 vs native 31: **0%** | ✅ PASS |

Spec gives no numeric threshold; the framework bound from `brand-content-native-post-check` (~10%) is used. Drift is native-higher (post kept accruing after LFM's last collection), the opposite direction of LFMP-32113 (native lower than LFM).

## Evidence
- Screenshots: `.playwright-out/QA-21916/01-youtube-only.png` (Apple Music YouTube-only grid), `02-native-top.png` / `03-native-comments.png` (Apple Music native video), `04-gq-youtube-only.png` (GQ - Japan grid), `05-gq-native-top.png` / `06-gq-native-comments.png` (GQ native video).
- Apple Music grid #2 (not asserted): "His Majesty The King Praises RAYE", Video Views 8,765 · Likes 167.
- URLs: Apple Music `…brand_id=31783&account_id=409&from=2026-11-10&to=2026-11-16&channels=youtube&table_data_set=youtube_only:_basic`; GQ - Japan `…brand_id=170350&account_id=487&…&channels=youtube&table_data_set=youtube_only:_basic`.
- Quirks seen: (a) `.image-card` `hasText: /^1\n/` locator does not match — use `.image-card .image-link` `.first()` (card 1 is first in DOM) with a real `mouse.click` + `page.waitForEvent('popup')`; a `context.waitForEvent('page')` registered with `locator.click()` missed the popup this run. (b) Account option text carries accents ("Condé Nast") — match with the accent.

## Known bugs checked
- Case file "Open linked bugs": **None open** (Rule 7 screen passed). `bug-history.md` / `known-quirks.md`: no QA-21916 entries (pre-fetched).
- LFMP-32113 (native lower than LFM): did **not** reproduce (native ≥ LFM on all four values).

## Scope notes
- Description-table row for Wednesday used (Apple Services/Apple Music, Condé Nast/GQ - Japan). The case's own Notes line lists a different pairing (Wed Apple Services/Wasserman) — stale vs the table; flagged, not followed.
- "Also use Amazon Prime Video on alternative days": Wednesday is not an alternate day for the unattended lane (Amazon Prime Video was covered 2026-11-17 when both Tuesday rows had no YouTube posts); both Wednesday rows had YouTube posts, so not needed.

## Bugs filed
None.

## Cleanup
None (read-only — no brand, tag, data set or saved report was created).
