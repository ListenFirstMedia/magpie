# QA-23892 — BPC > Brand Content vs Brand Insights

**Run date:** 2026-10-19 (retry; first attempt the tile failed to load) · **Track:** Playwright MCP interactive · **Account:** Hulu (336) · **Brand:** Hulu (5670) · Window Oct. 12 – Oct. 18, 2026 · Brand > Insights "Best Performing Content Per Channel (Lifetime)" tile (sorted by Engagements; YouTube variant sorted by Video Views) vs Brand > Content Table View rank-1 post, one channel at a time (FB, IG, TW, YT, TikTok)
**Verdict: FAIL — 1 known mismatch and 1 new one. Twitter Reactions: BPC 4,839 vs Content 4,836 (open bug LFMP-31958 reproduces). Facebook Video Views: BPC "–" vs Content 2,705,050. Every other metric on all five channels matches exactly; Twitter Public Impressions matches (246,843)**

## Per-channel comparison (same post on both surfaces)
| Channel / post | Metric | BPC (Insights) | Brand > Content | Match |
|---|---|---|---|---|
| **Facebook** — Oct 14 "The snap at the end was personal… #TheFreshPrinceOfBelAir" | Engagements / Reactions / Comments / Shares | 145,666 / 140,562 / 1,289 / 3,815 | 145,666 / 140,562 / 1,289 / 3,815 | ✅ |
| | Video Views | **–** | **2,705,050** | ❌ new |
| | Impressions | – | (n/a in Public set) | — |
| **Instagram** — Oct 16 "Man or Superman? #Smallville…" | Engagements / Reactions / Comments | 243,219 / 242,217 / 1,002 | 243,219 / 242,217 / 1,002 | ✅ |
| | Impressions | 3,237,181 | (n/a in Public set) | — |
| **Twitter** — Oct 13 "Spectacle: Michael Jackson at the Super Bowl…" | Engagements | 6,909 | 6,909 | ✅ |
| | Reactions | **4,839** | **4,836** (Public set) — the Twitter-Only set's "Likes" column shows 4,839 | ❌ **LFMP-31958** |
| | Comments / Shares / Video Views | 141 / 1,931 / 90,023 | 141 / 1,931 / 90,023 | ✅ |
| | Impressions / Public Impressions | 247,987 / 246,843 | Impressions set 247,987 / "Views" 246,843 | ✅ (A8b) |
| **YouTube** — Oct 13 "The Land \| Official Trailer" | Video Views / Likes / Comments | 7,662,122 / 3,255 / 282 | 7,662,122 / 3,255 / 282 | ✅ |
| **TikTok** — Oct 17 "Saturday the 17th… #HIMYM" | Engagements / Reactions / Comments / Shares / Video Views | 96,917 / 88,500 / 246 / 8,171 / 386,400 | 96,917 / 88,500 / 246 / 8,171 / 386,400 | ✅ |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A8a | BPC post data = Content post data (all channels) | 24 of 26 compared cells match; Twitter Reactions off by 3 (known), Facebook Video Views missing on BPC | ❌ |
| A8b | Twitter Public Impressions match | 246,843 = 246,843 | ✅ |

## Evidence
`.playwright-out/QA-23892/02-insights-bpc-fb-retry.png`, `03-insights-bpc-channels.png`, `04-content-tiktok-table.png`, `05-content-twitter-impressions.png`

## Known bugs checked
- **LFMP-31958** (Open) "Twitter Reactions mismatched between BPC and Brand Content" — **reproduces** (4,839 vs 4,836; BPC appears to use the Twitter-Only "Likes" figure while the Public set's Reactions differs by 3).
- Facebook BPC Video Views "–" while Content shows 2,705,050 — not covered by an open bug; candidate for a new ticket (BPC tile not reading FB video views, same post).
- First attempt earlier today: tile "failed to load" even after RELOAD (environment flakiness — retry succeeded).

## Bugs filed
None auto-filed (one known, one candidate documented). · **Cleanup:** none.
