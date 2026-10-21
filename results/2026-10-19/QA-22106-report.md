# QA-22106 — Brand Content > LFM vs Native > Instagram Channel - Past Date

**Run date:** 2026-10-19 (Monday → rotation row: account **HBO Max**, brand **HBO Max**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no Instagram login)
**Account:** HBO Max (account_id=657) · **Brand:** HBO Max (brand_id=155614) · Date range Jan. 01, 2024 – Dec. 31, 2024 · Channel: Instagram only · Perspective: Authorized (default)
**Verdict: PASS (1/1) — native Instagram reel readable logged-out; LFM Reactions 598,193 vs native 590K likes (≈1.4% lower), no big variation**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand>Content, brand HBO Max, date range Jan 01 2024 – Dec 31 2024 (set during QA-22105 in the same session) | ✅ |
| 3 | Instagram channel only (enable instagram, disable twitter) → Apply | ✅ `channels=instagram`, **Posts (2,300)** |
| 4 | First post (sorted by Engagements): Reactions | ✅ **Reactions 598,193** (Comments 1,457; Engagements 599,650; Reel, May 25 2024 "Mama always said… #TrixieMotel: Drag Me Home premieres June 1 on Max.") |
| 5 | Click the image on the first post (`.image-card .image-link`) | ✅ new tab → `https://www.instagram.com/reel/C7Z6WkDJ6S0/` |
| 6 | Read Likes from the native post | ✅ Logged-out page renders behind a "Log in / Sign up" overlay; the post's `<meta name="description">` reads **"590K likes, 1,388 comments - hbomax on May 25, 2024"** |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 (step 6) | LFM Reactions should not have big variation vs native Likes | LFM 598,193 vs native 590K (abbreviated; delta ≈ 8K ≈ 1.4%). Comments LFM 1,457 vs native 1,388 (≈4.7%). Both within normal drift; native is slightly LOWER than LFM | ✅ PASS |

## Evidence
- `.playwright-out/QA-22106/01-instagram-posts-loaded.png` — Instagram-only 2024 grid, Posts (2,300)
- `.playwright-out/QA-22106/02-native-instagram.png` — native reel page (logged-out, login overlay)

## Known bugs checked
- LFMP-32113 (Open, Apple Services/Instagram) "native data is lower than LFM": the same direction reproduces here in miniature (native 590K < LFM 598,193), but at ~1.4% it is not a "big variation"; noted, verdict unaffected.
- Automation caveat: Instagram serves only an abbreviated count ("590K") logged-out and may serve a login wall to automated browsers on other days — treat this flow as fragile for unattended runs.

## Bugs filed
None.

## Cleanup
None (read-only).
