# QA-21915 — Brand Content > LFM vs Native > Instagram Channel

- **Run date:** 2026-11-17 (Tuesday), unattended headless (`claude -p`), Playwright MCP, dev `app.lfmdev.in`
- **Test Set:** QA-21686 "Daily Data Testing -3" · **Case file:** cases/QA-21915.md
- **Date range:** default Brand > Content week Nov. 9 – Nov. 15, 2026 (not changed — spec has no date step)
- **Skill used:** `brand-content-native-post-check` (+ `devprod-helpers.js` login/switch/brand/channel helpers; dev only, prod not touched)

## Verdict: FAIL

The Tuesday Description row names two account/brand pairs, so both were run.

| Row | Account / Brand | Verdict |
| --- | --- | --- |
| 1 | UCLA / University of California, Los Angeles | PASS (Reactions +2.1%, Comments exact) |
| 2 | Wasserman / Gatorade | FAIL (native likes 13.4% below LFM Reactions) |

The spec gives no numeric threshold for "big variations". I used about 10% as the healthy bound, the same figure as the skill's prior observations (LinkedIn +10% was flagged but passed). The Gatorade row is 13.4% off and native is *lower* than LFM, which is the direction described by open bug LFMP-32113. The case is not formally linked to that bug, so the failure is judged on the data and the bug is cited as the likely cause. The call is borderline; a reviewer who sets the bar higher than ~13% would pass it.

## Steps executed

| # | Step | Result |
| --- | --- | --- |
| – | Login (dev, "With existing account") | Home loaded |
| 1 | Hover Brand → Content (top nav) | Brand > Content loaded for both rows |
| 2 | Add a Brand | Row 1: account UCLA, brand "University of California, Los Angeles" (127756), exact spec name, already selected as the account default. Row 2: account Wasserman, brand "Gatorade" (3580), exact name, already selected as default. No brand created (read-only rule). |
| 3 | Enable Instagram channel only | `.channel-ghost` clicks, Apply. URL `channels=instagram`; enabled = [instagram] on both rows |
| 4 | Note Reactions from the first post | See evidence |
| 5 | Click the image on the first post | `.image-link` real mouse click opened a native tab |
| 6 | Note Likes from the native post | Read from the logged-out `<meta name="description">` |

## Assertions

| ID | Step | Expected | Actual | Status |
| --- | --- | --- | --- | --- |
| A6a | 6 | UCLA: LFM metrics have no big variation vs native | Reactions 3,934 vs native 4,014 likes (+80, +2.0% native higher); Comments 10 vs 10 (0%) | PASS |
| A6b | 6 | Gatorade: LFM metrics have no big variation vs native | Reactions 10,015 vs native 8,672 likes (−1,343, −13.4% native lower); Comments 52 vs 50 (−3.8%) | FAIL |

## Evidence

**Row 1 — UCLA** (`.playwright-out/QA-21915/01-content-default.png`, `02-instagram-only.png`, `03-native-post.png`)
- Posts (9) with Instagram only. First post is a Gallery (carousel), Fri Nov. 13, 2026 09:03 AM PST, "This Friday the 13th, brush up on your Bruin lore. 👀 …".
- LFM: Engagements 3,944 · Reactions 3,934 · Comments 10 · Response Rate 0.72%.
- Native tab https://www.instagram.com/p/DfsH5ScFzGN/ → meta description: `4,014 likes, 10 comments - ucla on November 13, 2026`.

**Row 2 — Gatorade** (`04-wasserman-gatorade.png`, `05-gatorade-instagram.png`, `06-gatorade-native.png`)
- Posts (3) with Instagram only. First post is a Reel, Thu Nov. 12, 2026 06:00 PM PST, "Fly the MV-Pete ⚡️ …".
- LFM: Engagements 10,067 · Reactions 10,015 · Comments 52 · Response Rate 0.75% · Video Views 2,093,020 · Video Response Rate 0.48%.
- Native tab https://www.instagram.com/reel/Dfqgh8ztPOG/ → meta description: `8,672 likes, 50 comments - gatorade on November 12, 2026`.
- The native counter was re-read twice more in a fresh tab and returned 8,672 / 50 each time. The shortfall is not a one-off flaky read.
- Instagram's logged-out meta gives exact numbers below 10K and abbreviated ones (e.g. "220K") above it. Both reads here were exact.

## Known bugs checked

- Case file "Open linked bugs (as of 2026-10-20)": None open. The pre-fetched bug-history / known-quirks greps returned nothing for QA-21915. `results/open-bugs-2026-11-17.json` has no entry for QA-21915, so the Rule 7 screen passed and the case ran.
- Related, not linked: **LFMP-32113 [Open]** "Brand Content > LFM vs Native - Past Date - native data is lower than LFM" is linked to sibling case QA-21913. Row 2 reproduces its signature (native < LFM, −13.4%). The 2026-10-22 run of this case failed on the same pattern (Amazon Prime Video reel, −41%). Row 1 (UCLA) did not reproduce it.
- The `known-quirks.md` follow-up grep was not needed: I did not treat the Gatorade shortfall as accepted product behavior.

## Bugs filed

None (markdown-only). The Gatorade variance is attributed to the existing LFMP-32113 pattern. If the team decides LFMP-32113 covers this case, link it to QA-21915 in Jira so Rule 7 auto-fails it consistently.

## Cleanup

None (read-only). Nothing was created or saved. Native tabs closed; the app tab was left on Gatorade Brand > Content.

## Notes for harvest

- Skill `brand-content-native-post-check` reused unchanged. Instagram path confirmed: `.image-card .image-link` real mouse click → popup, meta description readable logged-out.
- The UCLA row passes while Gatorade fails on the same day and flow, so per-row verdicts matter for this case.
- The Playwright sandbox cannot read files (`require` / dynamic `import` unavailable), so credentials must be passed in by the caller. Pass `ctx._creds = null` to `devprod-helpers.js` first if you only want dev, otherwise its bootstrap also logs in to prod.
- No REGISTRY or skill maintenance done (deferred to harvest.sh).
