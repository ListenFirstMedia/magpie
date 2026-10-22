# QA-3936 — Topics Cloud - Facebook Sentiment - Data QA

**Run date:** 2026-10-22 (Thursday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com`, both logged in as lfiqa and switched to **Viacom**
**Account:** Viacom (account_id=181) · **Brand:** MTV (brand_id=4018) · Channel: Facebook only · Date range: default week Oct. 14, 2026 – Oct. 20, 2026 · Sentiment mode on
**Verdict: PASS (A7 cloud parity) — the Topics cloud (25 topics with identical weights) and the Top 7 Topics legend are identical on Dev and Prod; the A10 "hover Love → Read Comments" leg is not evaluable headless (hover tooltip never renders)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–4 | Brand > Content → MTV → Facebook only → Sentiment | ✅ both environments, `sentiment_mode=true`, Posts (23) |
| 5–7 | Topics cloud on Dev vs Prod | ✅ 25/25 identical, identical font-size weights: Mtv (64px), Una (23.3px), Aint (19.9px), Clark / Feng Shui / Illuminati / Jaafar / My Favorite / Rose / Tha / Zara Larsson (17.5px), Sara, Scotland, Sophie Cunningham, South Africa, Sydney Sweeney, Talentless, Tamara, Tia, Travis, Vmas, Wial, Woh, Yall, Youre (16px). Top 7 Topics legend identical (aint, mtv, my favorite, rosé, tha, una, zara larsson). Prod Classification 52% / 39% / 8%, Emotion 22% / 23% / 7% / 43%; the Dev donut tiles had not rendered their SVG text when captured (lazy tiles), so the donut percentages were not compared this run |
| 9–10 | Topic modal / hover Love / Read Comments | ⛔ not evaluable headless (as on 2026-10-20) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7 | Same cloud data on Dev and Prod | 25/25 topics and weights identical; Top 7 identical | ✅ PASS |
| A10 | Emotion comments table via hover | not evaluable headless | ⛔ BLOCKED (automation) |

## Evidence
- Session result `ctx._topics2`.

## Known bugs checked
- None open on the case.

## Bugs filed
None.

## Cleanup
None (read-only).
