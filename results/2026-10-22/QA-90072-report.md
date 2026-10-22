# QA-90072 — Brand Content > Reels Data Set - LFM vs Native

**Run date:** 2026-10-22 · **Track:** Playwright MCP, unattended headless (`claude -p`), dev `app.lfmdev.in`
**Account:** Amazon Prime Video (account_id=342) · **Brand:** Amazon Prime Video (brand_id=25864, exact typeahead match, first result) · **Data set:** Reels (`table_data_set=reels`) · **Channels (auto-applied by app):** Instagram + Facebook · **Date range:** default Oct. 14 – Oct. 20, 2026, Lifetime mode, Public/extended perspective · Posts (42)
**Verdict: FAIL (data variance) — first reel: LFM Reactions 373,304 vs native visible 430.8K (-13.3%); LFM Comments 2,485 vs native 2,006 (+23.9%); Shares not exposed natively. Native source itself is inconsistent (meta 220K vs visible 430.8K likes), so this needs human confirmation.**

## Steps executed
| # | Step | Result |
|---|------|--------|
| Pre | Login (Cognito "With existing account", `config/.env`), switch account VIACOM -> Amazon Prime Video via profile dropdown `Results` list | OK — header `ACCOUNT: AMAZON PRIME VIDEO` |
| 1 | Hover Brand -> Content | OK — `#explore/brand/content?brand_id=25864&account_id=342…` |
| 2 | Type and select 'Amazon Prime Video' (chevron -> `textarea` "Search for a Brand" -> `.lfm-ta-option`) | OK — first of 60+ results was the exact-name "Amazon Prime Video"; brand_id stayed 25864 |
| 3 | Data set dropdown -> 'Reels' | OK — URL `table_data_set=reels`; app auto-set `channels=instagram&channels=facebook`; `Posts (42)` rendered |
| 4 | Note Reel Reactions / Comments / Shares of first post | Post #1 (Fri Oct. 16, 2026 03:00 PM PDT, IG reel "Love makes you do ALL sorts of things"): Engagements 375,789 · **Reactions 373,304 · Comments 2,485 · Shares 58,110** · Reach 2,924,339 · Plays – · Initial – · Replays – · Avg Time Watched – · Video Views Total Time 1,666,870.96 · Total Reel Interactions 323,386 |
| 5 | Click the video on first post | OK — new tab https://www.instagram.com/reel/Dei-B_-Dpfy/ (logged-out; login overlay on top) |
| 6 | Note native Likes / Comments / Shares | Visible counter (screenshot `.playwright-out/QA-90072/native-popup.png`): **430.8K likes, "2K" comments**. `<meta name=description>`/og:description: **"220K likes, 2,006 comments"**. Shares not shown logged-out. Post is a collab (primevideo + amazonmgmstudios). |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A6a | 6 | LFM Reel Reactions ~ native Reel Likes (no big variation) | LFM 373,304 vs native visible 430.8K = **-13.3%** (-57.5K); vs meta "220K" = +69.7% (native sources disagree with each other) | FAIL (see note) |
| A6b | 6 | LFM Reel Comments ~ native comments | LFM 2,485 vs native 2,006 (meta; visible "2K") = **+23.9%** | FAIL (see note) |
| A6c | 6 | LFM Reel Shares ~ native shares | LFM 58,110; native share count not exposed on the logged-out page | NOT EVALUABLE (platform) |

Threshold: the spec gives none. I used >10% as "big", the drift the framework already tolerates (skill `brand-content-native-post-check`: IG -1.4%, YT +0.04%, LinkedIn +10%). The 2026-10-20 run of this case passed at +1.1% / +0.6% on a different first post.

## Supplementary evidence (NOT a substitute for the spec's first post)
Same Reels list, native read the same way, to judge whether the gap is systematic:
| Rank | Reel | LFM Reactions | Native likes (visible / meta) | Δ vs visible | LFM Comments | Native comments (visible / meta) | Δ |
|---|---|---|---|---|---|---|---|
| 1 | Oct 16 "Love makes you do ALL sorts of things" | 373,304 | 430.8K / 220K | -13.3% | 2,485 | 2K / 2,006 | +23.9% |
| 2 | Oct 17 "A speech worth remembering" (DemRTgmlHch) | 337,545 | 371.5K / 314K | -9.1% | 879 | 850 / 850 | +3.4% |
| 3 | Oct 20 "Leaving a lasting impression" (DeuDz19jerM) | 257,147 | 350.9K / 351K | -26.7% | 257 | 352 / 352 | -27.0% |
LFM likes are lower than the visible native counter on all three posts. LFM data last updated 10-21-2026 07:40 PM PT, about 5 h before this run. Post #1 shows two different native counters (430.8K vs 220K), so the native side is itself noisy. Likely contributors: LFM snapshot lag on young posts, collab-post counting, and LFM comment counts including replies. None of these is confirmed.

## Evidence
- Screenshots (`.playwright-out/QA-90072/`): `reels-selected.png`, `reels-loaded.png`, `native-popup.png` (post #1 native: heart 430.8K, comments 2K), `native-post2.png`, `native-post3.png`.
- Post #1 URL: https://www.instagram.com/reel/Dei-B_-Dpfy/

## Known bugs checked
- **APPS-60871 (Open)** — en-dash (–) rendered for multiple metrics across datasets. **Does NOT interfere.** Reactions / Comments / Shares (the compared metrics) all rendered numerically; the dashes appeared only on Plays / Initial / Replays / Avg Time Watched, which this case does not compare. It did not change the verdict. I ran the case rather than auto-failing under Rule 7, because the user's instruction and the open-bug-auto-fail memory limit auto-fail to bugs that interfere.
- LFMP-32113 (native lower than LFM) from the native-post-check skill is the opposite direction (native is higher on likes here), so it does not apply.
- `knowledge-base/bug-history.md` / `known-quirks.md`: no QA-90072 entries (pre-grepped).

## Bugs filed
None filed (markdown-only policy). **Candidate for human review:** LFM Instagram Reels Reactions run 9–27% below the visible native like counter on the top 3 reels of Amazon Prime Video (Oct 14–20), and Reel Comments differ by up to ±27%. Confirm on a logged-in IG session, or against a native Insights export, before filing.

## Cleanup
All native tabs closed; browser left on the Brand Content Reels view. No mutations were made.
