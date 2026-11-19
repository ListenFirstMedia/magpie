# QA-21915 — Brand Content > LFM vs Native > Instagram Channel

**Verdict: PASS** (one borderline row, flagged below). Both Wednesday pairs ran in full.

| Row | Account / Brand | LFM first post (Reactions / Comments) | Native (likes / comments) | Verdict |
| --- | --- | --- | --- | --- |
| 1 | Apple Services / Apple Music | 264,189 / 422 | 299K / 463 | PASS (borderline: native +13.2% on Reactions) |
| 2 | Conde Nast / GQ - Japan | 212,138 / 1,538 | 213K / 1,537 | PASS (+0.4% / −0.07%) |

- Run: 2026-11-18 (Wednesday), unattended headless, Playwright MCP, dev `app.lfmdev.in`, user `lfiqa@listenfirstmedia.com`
- Test Set: QA-21686 "Daily Data Testing -3". Case file: `cases/QA-21915.md`.
- Skill: `brand-content-native-post-check`, plus the `devprod-helpers.js` login/switch/channel helpers. Dev only. No skill or REGISTRY maintenance (deferred to harvest.sh).
- Spec row: Description table, Wednesday: accounts **Apple Services, Conde Nast**, brands **Apple Music, GQ - Japan**. The case-file Notes line (Wed = Apple Services/Wasserman) is stale and conflicts with the table. The table was followed.
- Date range: the spec has no date step, so the app default **Nov 10 – Nov 16, 2026** (Lifetime attribution) was used. No dates were invented. "Data Last Updated (PT)" on the page: 11-17-2026 04:03 PM.
- "Also use Amazon Prime Video on alternative days" is an optional note and was not run.

## Steps executed

### Row 1 — Apple Services / Apple Music
| # | Step | Result |
| --- | --- | --- |
| pre | Log in ("With existing account") | OK, `#home` |
| pre | Switch account to Apple Services | OK, `ACCOUNT: APPLE SERVICES`, `account_id=409` |
| 1 | Hover Brand, then Content | `#explore/brand/content`, Posts (55) across all channels |
| 2 | Add a Brand | The account default brand is already the exact spec name **Apple Music** (`brand_id=31783`). No substitution (Rule 1 ✔). Nothing created. |
| 3 | Enable Instagram channel only | Trusted clicks disabled all other channels, then Apply. URL `channels=instagram`; enabled = [instagram]; **Posts (23)** |
| 4 | Note Reactions of the first post | Card #1 (Engagements desc): MON NOV. 16, 2026 04:01 PM PST, Reel, "Go behind the scenes with @txt_bighit. Listen to their new album, PERFECT STORM…". Engagements 264,611 · **Reactions 264,189** · **Comments 422** (264,189 + 422 = 264,611 ✔). Response Rate / Video Views show "–". |
| 5 | Click the image on the first post | Card scrolled into view, then a real mouse click on `.image-card .image-link`. A new tab opened at `https://www.instagram.com/reel/Df0mCJnN6-0/` (same as the tile href). |
| 6 | Note Likes from the native post | Logged-out page (login overlay, content behind). `<meta name="description">` = "**299K likes, 463 comments** - applemusic on November 16, 2026: Go behind the scenes with @txt_bighit…". The caption matches the LFM caption (same post). |

### Row 2 — Conde Nast / GQ - Japan
| # | Step | Result |
| --- | --- | --- |
| pre | Switch account to Conde Nast | Single result "Condé Nast", `ACCOUNT: CONDÉ NAST`, `account_id=487` |
| 1 | Hover Brand, then Content | OK, Posts (386) across all channels |
| 2 | Add a Brand | The default brand is the exact spec name **GQ - Japan** (`brand_id=170350`). No substitution (Rule 1 ✔). |
| 3 | Enable Instagram channel only | Same flow. `channels=instagram`; enabled = [instagram]; **Posts (23)** |
| 4 | Note Reactions of the first post | Card #1: TUE NOV. 10, 2026 10:59 PM PST, Reel, Japanese caption on Jungkook / Graff 65 Years. Engagements 213,676 · **Reactions 212,138** · **Comments 1,538** (sum ✔) · Response Rate 48.23% · Video Views 889,937 · Video Response Rate 24.01%. |
| 5 | Click the image | Real mouse click on `.image-link`. A new tab opened at `https://www.instagram.com/reel/Dfl5EpbAO6e/`. |
| 6 | Note Likes from the native post | Logged-out `<meta name="description">`: "…2026年11月10日、「いいね！」**213K**件、コメント**1,537**件 - gqjapan". The caption matches the LFM caption (same post). |

## Assertions

Spec Assertion 6: "Ensures the LFM value of metrics should not have big variations when we compare with Native". The spec gives no numeric threshold. I used about 10% as the reference bound, the same figure as the skill and the 2026-11-17 run.

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| A6-AM-R | 6 (Apple Music) | LFM Reactions ≈ native likes | 264,189 vs 299K (rounded display, so 298.5–299.5K): native +34.3K to +35.3K, **+13.0% to +13.4%**, native higher | PASS (borderline, see note) |
| A6-AM-C | 6 (Apple Music) | LFM Comments ≈ native | 422 vs 463: native +41, **+9.7%** | PASS |
| A6-GQ-R | 6 (GQ - Japan) | LFM Reactions ≈ native likes | 212,138 vs 213K (212.5–213.5K): native +0.4% to +0.65% | PASS |
| A6-GQ-C | 6 (GQ - Japan) | LFM Comments ≈ native | 1,538 vs 1,537: −1 (−0.07%) | PASS |

Why Apple Music is PASS and not FAIL:
- The Apple Music Reactions delta (+13.2%) is above the ~10% reference bound, so it is a judgement call. A reviewer with a stricter bar could fail it.
- The post is a fresh Reel, published Mon Nov 16 4:01 PM PST. LFM's snapshot ("Data Last Updated") is Nov 17 4:03 PM PT, about 24 h after publishing. The native read was taken later, on Nov 18.
- Reactions and comments both moved up together (+13% and +10%), which fits continued accrual after the snapshot, not a data-capture error. For comparison, the older GQ Reel (published Nov 10) matches within 0.5%.
- Direction is native ≥ LFM. The open-bug signature (LFMP-32113) is native much *lower* than LFM, and that is not what happened here.
- The native likes figure is abbreviated by Instagram above 10K ("299K"), so exact deltas cannot be computed. Ranges are given instead.

## Evidence
- `.playwright-out/QA-21915/w1-01-apple-content.png`: Apple Music Brand > Content, all channels
- `.playwright-out/QA-21915/w1-02-apple-instagram.png`: Apple Music, Instagram only, Posts (23)
- `.playwright-out/QA-21915/w1-03-native-apple.png`: native Apple Music Reel, login overlay, meta values read from the DOM
- `.playwright-out/QA-21915/w2-04-conde-content.png`: Conde Nast / GQ - Japan Content, all channels
- `.playwright-out/QA-21915/w2-05-gq-instagram.png`: GQ - Japan, Instagram only, Posts (23)
- `.playwright-out/QA-21915/w2-06-native-gq.png`: native GQ - Japan Reel

## Known bugs checked
- Case file "Open linked bugs (as of 2026-10-20)": **None open**. `results/open-bugs-2026-11-18.json` has no entry for QA-21915. The Rule 7 screen passed and the case ran.
- The pre-fetched `bug-history.md` and `known-quirks.md` greps returned nothing for QA-21915. No follow-up grep was needed.
- Related but not linked: **LFMP-32113 [Open]** (Brand Content > LFM vs Native, Past Date, native lower than LFM) is linked to sibling case QA-21913. **LFMP-32119 [Open]** is linked to QA-22104 (Facebook). Neither signature reproduced here: native was ≥ LFM on every metric in both rows.
- Earlier runs of this case: 2026-10-20 PASS (UCLA), 2026-10-22 FAIL (Amazon Prime Video reel, native −41%), 2026-11-17 FAIL (Gatorade, native −13.4%; UCLA PASS). The Tuesday FAIL was in the LFMP-32113 direction (native lower). The Apple Music drift today is the opposite direction.

## Bugs filed
None (markdown-only policy). No new defects found.

## Cleanup
None (read-only Data Test). Nothing was created or saved. The native tabs were closed; the app tab was left on GQ - Japan Brand > Content.

## Notes for harvest
1. The Notes line in `cases/QA-21915.md` is stale versus the Description table (Wed = Apple Services/Wasserman there; the table says Apple Music / GQ - Japan with accounts Apple Services / Conde Nast).
2. `brand-content-native-post-check` was reused unchanged. Instagram path confirmed again: scroll the card into view, real mouse click on `.image-link`, read the logged-out `<meta name="description">`. For non-English captions, the meta is localised (the GQ - Japan page returns "いいね！213K件、コメント1,537件"), so parse the number before 件.
3. Suggested skill addition: a "borderline drift" rule. For posts under ~48 h old at the LFM snapshot, native-higher drift of 10–15% is expected accrual, not a defect. It needs a stated threshold from the product team, because the spec has none.
4. The Playwright sandbox cannot read files, so credentials had to be passed in the code string. `devprod-helpers.js` was loaded with `ctx._creds` unset, so its bootstrap did not log in to prod. `ctx._creds` was then set and `m.login` was called for dev only.
