# QA-21912 — Brand Content > LFM vs Native > Facebook Channel

**Verdict: PASS** — both Wednesday pairs executed in full. Viacom/MTV: Reactions 33,910 vs 34K, Comments 171 vs 190, Shares 1,037 vs 1K. Condé Nast/GQ - Japan: Reactions 39,600 vs 39.7K, Comments 430 vs 510, Shares 937 vs 941.

- Run: 2026-11-18 (Wednesday), unattended headless, Playwright MCP, dev (`app.lfmdev.in`), user `lfiqa@listenfirstmedia.com`
- Skill used: `brand-content-native-post-check` + `switch-account` mechanics (no skill/REGISTRY maintenance — deferred to harvest.sh)
- Spec row (Description table, Wednesday): Accounts **Viacom, Conde Nast** / Brands **MTV, GQ - Japan**. The Notes line in the case file (Wed = Apple Services/Wasserman) is stale and conflicts with the table; the table was followed.
- Date range: none specified by the case; app default **Nov 10 – Nov 16, 2026** (Lifetime attribution) used for both pairs. No dates invented.
- "Also use Amazon Prime Video on alternative days": optional note, not run.

## Steps executed

### Pair 1 — Account Viacom / Brand MTV
| # | Step | Result |
|---|------|--------|
| pre | Log in (Cognito "With existing account") | OK → `#home` |
| pre | Switch account → Viacom (profile menu → Search Account → Results list, single result "Viacom", real mouse click on `.lfm-ta-option`) | OK, `ACCOUNT: VIACOM`, `account_id=181` |
| 1 | Hover Brand → Content | OK, `#explore/brand/content` (initial load slow, ~1 min; no render hang) |
| 2 | Add a Brand | Account's default brand is already the exact spec name **MTV** (`brand_id=4018`); no substitution (Rule 1 ✔) |
| 3 | Enable Facebook channel only | Trusted clicks disabled twitter/instagram/linkedin/tiktok/threads (youtube/pinterest already disabled); Apply → URL `channels=facebook`; ghosts: only `facebook enabled`; **Posts (38)** |
| 4 | Note Reactions/Comments/Shares of first post | Card #1 (sort Engagements desc): SAT NOV. 14, 2026 09:10 AM PST, "Nothing beats this feeling: CARMELLE of the Philippines is the first-ever #EurovisionAsia winner!", Engagements 35,118 · **Reactions 33,910 · Comments 171 · Shares 1,037** · Response Rate 0.08% (33,910+171+1,037 = 35,118 ✔ internally consistent) |
| 5 | Click the image on the first post | First click attempt happened with the image below the fold and opened nothing; after scrolling the card into view, real mouse click on `.image-card .image-link` → new tab `https://www.facebook.com/MTV/posts/pfbid031aXPSJNADPNoC1bWgdudPFksnV4MimS9HxDm5P3N316He6MAzqAv2AocJxKnDL8Hl` (tile href `facebook.com/7245371700_1674585444708593`) |
| 6 | Note native Likes/Comments/Shares | Public post page rendered logged-out (login bar visible, content behind). Body text: "All reactions: **34K** · **190 comments** · **1K shares**" (abbreviated reactions/shares). og:description matches the LFM caption (same post). |

### Pair 2 — Account Conde Nast / Brand GQ - Japan
| # | Step | Result |
|---|------|--------|
| pre | Switch account → Conde Nast (single Results entry "Condé Nast", the accented spelling of the spec account; click) | OK, `ACCOUNT: CONDÉ NAST`, `account_id=487` |
| 1 | Hover Brand → Content | OK |
| 2 | Add a Brand | Default brand is the exact spec name **GQ - Japan** (`brand_id=170350`); no substitution (Rule 1 ✔) |
| 3 | Facebook channel only | Same trusted-click disable + Apply; only `facebook enabled`, `channels=facebook`; **Posts (144)** |
| 4 | Note first post | Card #1: TUE NOV. 10, 2026 11:06 PM PST, Japanese caption on Jungkook / Graff 65 Years event, type **Video**. Engagements 40,967 · **Reactions 39,600 · Comments 430 · Shares 937** · Response Rate 18.26% · Video Views 124,115 (39,600+430+937 = 40,967 ✔) |
| 5 | Click the image | Real mouse click on `.image-link` → new tab `https://www.facebook.com/reel/1843764430145003` (a Reel; LFM tile href `facebook.com/208325382515395_1613622077471595`) |
| 6 | Note native values | Reel page logged-out (a "See more on Facebook" login modal overlays the content, but the counts remain readable behind it). Counts, read from page text and confirmed visually in the screenshot: like **39.7K**, comments **510**, shares **941**. The Reel UI does not label the three icons in text; they are the like / comment / share icons in the side rail. The caption text matches the LFM caption (same post). |

## Assertions
Spec Assertion 6: "LFM value of metrics should not have big variations when compared with Native". No numeric threshold in spec.

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A6-MTV-R | 6 (Viacom/MTV) | LFM Reactions ≈ native | 33,910 vs 34K (rounded display; 34K ⇒ 33.95–34.05K, delta ≤ +0.4%) | PASS |
| A6-MTV-C | 6 (Viacom/MTV) | LFM Comments ≈ native | 171 vs 190 → native +19 (+11.1%) | PASS |
| A6-MTV-S | 6 (Viacom/MTV) | LFM Shares ≈ native | 1,037 vs 1K (rounded; ≤ +4% at most) | PASS |
| A6-GQ-R | 6 (Conde Nast/GQ - Japan) | LFM Reactions ≈ native | 39,600 vs 39.7K → native +~100 (+0.25%) | PASS |
| A6-GQ-C | 6 (Conde Nast/GQ - Japan) | LFM Comments ≈ native | 430 vs 510 → native +80 (+18.6%) | PASS (largest drift of the run, see note) |
| A6-GQ-S | 6 (Conde Nast/GQ - Japan) | LFM Shares ≈ native | 937 vs 941 → native +4 (+0.4%) | PASS |

Notes on the verdict:
- Drift is one-directional (native ≥ LFM) in every metric, consistent with the posts accruing engagement after LFM's last stats pull (Data Last Updated 11-17-2026 04:03 PM PT) — same pattern as prior runs (2026-11-17 UCLA +5.9% / +18% of a tiny base / +10.4%; 2026-10-20 UCLA +3.2%).
- The GQ comments delta (+18.6%) is the largest, and the native count likely includes replies, and the post is a Reel. I judged it not a "big variation" given the base of ~500 and reactions/shares matching within 0.4%; flagged here for human review if the team wants a stricter threshold.
- Native MTV and GQ values are abbreviated by Facebook (34K / 1K / 39.7K) so exact deltas for those cannot be computed; ranges stated above.

## Evidence
- `.playwright-out/QA-21912/01-viacom-content.png`, `02-viacom-after-wait.png` — Viacom/MTV Content load
- `.playwright-out/QA-21912/03-mtv-fb-only.png` — MTV Facebook-only, Posts (38)
- `.playwright-out/QA-21912/04-native-mtv.png` — native MTV Facebook post (values taken from page text)
- `.playwright-out/QA-21912/05-conde-content.png`, `06-gq-fb-only.png` — Condé Nast / GQ - Japan, Facebook-only, Posts (144)
- `.playwright-out/QA-21912/07-native-gq.png` — native GQ Japan Reel (login modal overlay; counts 510 / 941 visible on the side rail)

## Known bugs checked
- Case file "Open linked bugs": **None open** → Rule 7 screen passed, case run.
- bug-history / known-quirks: no QA-21912 entries (pre-fetched). Skill's LFMP-32113 (native far lower than LFM) — not reproduced; native was ≥ LFM everywhere.
- Prior runs of this case: 2026-10-20 PASS (UCLA), 2026-10-22 BLOCKED (FX Networks — Facebook native login wall), 2026-11-17 PASS (UCLA; Gatorade had no FB posts). This run the logged-out Facebook pages rendered (post page + Reel with overlay modal).

## Bugs filed
None.

## Cleanup
None (read-only data test). Native tabs closed; nothing was created or saved.

## Notes for the human / harvest
1. Weekday Notes line in `cases/QA-21912.md` is stale vs the Description table (Wed = Apple Services/Wasserman there; table says Viacom-MTV / Conde Nast-GQ - Japan).
2. Skill `brand-content-native-post-check` additions: (a) Facebook native read — post page body shows "All reactions: N · N comments · N shares" (abbreviated K); Reels show unlabelled like/comment/share counts in the side rail behind a login modal; (b) `.image-link` must be scrolled into view before a mouse click (first card sits below the fold at y≈742, otherwise no popup); locate card 1 via `evaluateHandle` on `innerText` (Playwright `hasText` regex does not match the multi-line text); (c) account "Conde Nast" appears as "Condé Nast".
3. In-session sandbox note: `require`/dynamic `import` are unavailable in `browser_run_code_unsafe`, so credentials had to be passed in the code string.
