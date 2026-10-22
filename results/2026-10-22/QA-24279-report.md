# QA-24279 — Brand Content - Video Views Data Set - Aggregate Data Test

**Run date:** 2026-10-22 (Thursday) — interactive re-run; the unattended runner blocked it because the Thursday rotation brands ("Spotify News", "Robinhood") do not exist on dev
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app.lfmdev.in`, skill `brand-content-grid-math`
**Account:** Amazon Prime Video (account_id=342), the alternative account the case description allows ("Also use Amazon Prime Video on alternative days") · **Brand:** Amazon Prime Video · Data set: Video Views · Date range: default week Oct. 14, 2026 – Oct. 20, 2026
**Verdict: PASS — Organic Views + Paid Views + Unclassified Views = Video Views holds on every post with data: Facebook 41/41 (1 post without Video Views skipped), Twitter 22/22 (1 skipped), Instagram 42/42, TikTok 41/41; LinkedIn has 0 video posts in the week (not evaluable)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Brand > Content → Amazon Prime Video → Video Views data set | ✅ |
| 3–4 | Facebook only → Table View → identity on every post and the aggregate row | ✅ 41/41; aggregate Video Views 25,159,549 = Organic 25,159,549 + Paid 0 + Unclassified 0 |
| 5–6 | Twitter only | ✅ 22/22; aggregate 308,204 = Organic 308,204 + Paid – + Unclassified 0 |
| 7–8 | Instagram only | ✅ 42/42; aggregate 53,440,823 = Organic 51,808,507 + Paid 1,632,316 + Unclassified 0 |
| 9–10 | TikTok only | ✅ 41/41; aggregate 36,653,300 = Organic – + Paid – + Unclassified 36,653,300 |
| 11–12 | LinkedIn only | n/a — Posts (0) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A4/A6/A8/A10 | Organic + Paid + Unclassified = Video Views (Facebook, Twitter, Instagram, TikTok) | 146/146 posts with data | ✅ PASS |
| A12 | LinkedIn | no LinkedIn video posts this week | n/a |

## Evidence
- Session result `ctx._rerun2.q24279`.

## Known bugs checked
- None open on the case.

## Notes
- Test-data drift: the Thursday rotation row names "Spotify News", which does not exist on the Spotify account (dev or prod). The case's own note permits Amazon Prime Video, which was used.

## Bugs filed
None.

## Cleanup
None (read-only).
