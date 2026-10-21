# QA-22107 — Brand Content > LFM vs Native > YouTube Channel - Past Date

**Run date:** 2026-10-19 (Monday → rotation row: account **HBO Max**, brand **HBO Max**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no YouTube login)
**Account:** HBO Max (account_id=657) · **Brand:** HBO Max (brand_id=155614) · Date range Jan. 01, 2024 – Dec. 31, 2024 · Channel: YouTube only (data set auto-switched to `youtube_only:_basic`, sorted by Public Video Views)
**Verdict: PASS (1/1) — LFM Likes 168,873 / Comments 4,672 vs native YouTube 168,948 likes / 4,676 comments (≤0.1% delta)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand>Content, brand HBO Max, date range Jan 01 2024 – Dec 31 2024 (set during QA-22105 in the same session) | ✅ |
| 3 | YouTube channel only (enable youtube, disable instagram) → Apply | ✅ `channels=youtube`, **Posts (1,750)** |
| 4 | First post: Likes and Comments | ✅ **Likes 168,873 · Comments 4,672** (Video Views 14,320,181; Mar 11 2024 "Ryan Gosling Performs \"I'm Just Ken\" \| Barbie \| HBO Max", video RIHExGaxfPE) |
| 5 | Click the image on the first post (`.image-card .image-link`) | ✅ new tab → `https://www.youtube.com/watch?v=RIHExGaxfPE` |
| 6 | Read Likes and Comments from the native post | ✅ like button aria-label **"like this video along with 168,948 other people"**; comments header **"4,676 Comments"** (logged-out, no consent wall) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 (step 6) | LFM Likes/Comments should not have big variation vs native | Likes 168,873 vs 168,948 (Δ 75, 0.04%); Comments 4,672 vs 4,676 (Δ 4, 0.09%). Native slightly HIGHER (video still accruing) | ✅ PASS |

## Evidence
- `.playwright-out/QA-22107/01-youtube-posts-loaded.png` — YouTube-only 2024 grid, Posts (1,750)
- `.playwright-out/QA-22107/02-native-youtube.png` — native watch page with 168K likes / 4,676 Comments

## Known bugs checked
- No open linked bugs on QA-22107. LFMP-32113 ("native lower than LFM") does not reproduce on YouTube (native is higher).
- Automation note: YouTube exposes the exact like count in the like button's `aria-label` logged-out; comments count needs a scroll to lazy-load `#comments #count`. Fully unattended-safe.

## Bugs filed
None.

## Cleanup
None (read-only).
