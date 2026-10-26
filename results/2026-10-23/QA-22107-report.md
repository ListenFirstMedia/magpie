# QA-22107 — Brand Content > LFM vs Native > YouTube Channel

**Run date:** 2026-10-23 (Friday → rotation row: account **Hulu**, brand **Hulu**)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`, no YouTube login), dev `app.lfmdev.in`
**Account:** Hulu (account_id=336) · **Brand:** Hulu (brand_id=5670) · Channel: YouTube only · Date range: Jan. 01, 2024 – Dec. 31, 2024 · Data set: Public (page switched to `youtube_only: basic`)
**Verdict: PASS — first video ("Death and Other Details | Trailer | Hulu", Wed Jan 3 2024): LFM Likes 8,781 / Comments 353 vs native YouTube "8,781 other people" like / "353 Comments" — exact match**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand > Content → Hulu → date range Jan 01 – Dec 31 2024 | ✅ `from=2024-01-01&to=2024-12-31` |
| 3 | YouTube only → Apply | ✅ Posts (756) |
| 4 | First post metrics (grid card) | ✅ Video Views 17,343,562 · Likes 8,781 · Comments 353 |
| 5 | Click image → native tab | ✅ https://www.youtube.com/watch?v=YIn-D8FVvwA ("Unlisted", Hulu, 17m views) |
| 6 | Note native Likes / Comments | ✅ like button aria-label "like this video along with **8,781** other people"; comments header "**353** Comments" |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A6 | LFM Likes/Comments ≈ native | 8,781 = 8,781 · 353 = 353 (native views 17m ≈ LFM 17,343,562) | ✅ PASS |

## Evidence
- Session result `ctx._nat.q22107`.

## Known bugs checked
- None open on QA-22107.

## Bugs filed
None.

## Cleanup
Native tab closed.
