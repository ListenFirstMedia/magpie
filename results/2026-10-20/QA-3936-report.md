# QA-3936 — Topics Cloud - Facebook Sentiment - Data QA

**Run date:** 2026-10-20 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` + prod tab `app.listenfirstmedia.com`, both logged in as lfiqa and switched to **Viacom**
**Account:** Viacom (account_id=181) · **Brand:** MTV (brand_id=4018) · Channel: Facebook only · Date range: default week Oct. 12, 2026 – Oct. 18, 2026 · Sentiment mode on (`sentiment_mode=true`)
**Verdict: PASS (A7 data parity) — Topics cloud, Classification donut, Emotion donut, Top-7 topics and Most Vocal table are identical on Dev and Prod; the A10 "hover Love → Read Comments" leg is NOT evaluable headless (the donut hover tooltip that carries the Read Comments button never renders in headless Chrome, same quirk as Social Recap donuts)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–3 | Brand > Content → brand MTV (account default on Viacom) → Facebook only | ✅ Posts (14) on both environments |
| 4 | Click the **Sentiment** button (`button.sentiment-button`) | ✅ URL gains `sentiment_mode=true`; sentiment tiles render: Classification donut, Classification (Daily), Emotion donut, Emotion (Daily), Topics (cloud), Top 7 Topics (Daily), 9 Most Vocal |
| 5 | Observe the Topics data (cloud `svg text` with font-size as weight) | ✅ 25 topics on dev: Mtv (64px), Xtina (36.6px), Beastality / Britney Spears / Kim Petras / My Favorite / Tove Lo / Zara Larsson (20.1px), Jenna, Jenna Ortega, Lmao, Maria, Ooo, Pedro, Primera, Qveen Herby, South Africa, Sydney Sweeney, Talentless, Tamara, Tia, Tranquility, Una, Vmas, Y 2 K (16px) |
| 6 | Same page on Prod (Viacom → MTV → Facebook → Sentiment) | ✅ |
| 7 | Compare the cloud data | ✅ 25/25 topics identical, identical weights (font sizes); Classification donut 54% / 41% / 100% on both; Emotion donut 20% / 24% / 47% / 100% on both; Top 7 Topics legend identical (britney spears, kim petras, mtv, my favorite, tove lo, xtina, zara larsson); 9 Most Vocal first rows identical (Mario Sila Sila 7 Positive/Joy, Cool Nico 4 Neutral, San Yuri 3 Neutral/chappel …) |
| 8 | Close out prod page | ✅ (prod tab left on the page; not needed further) |
| 9 | Click the topic "Mtv" in the cloud (dev) | ✅ Topic modal (`.lfm-modal-inner`): **"Mtv" Comments: 11.54%**, Total Comments (6), Classification 50% / 33% / 17%, Emotion 33% / 17% / 50%, MUTE and Close buttons |
| 10 | Hover the Love emotion and click "Read Comments" | ⛔ Hovering the Love legend item (`[data-datapoint="sentiment-Love"]`, real mouse move) and every arc of the modal's emotion donut produced no tooltip and no `read-comments` button — headless Chrome does not render these hover tooltips (known quirk, 2026-10-19 Social Recap). Not evaluable in this mode. |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7 | Same data displays on Dev and Prod | Cloud (25 topics + weights), both donuts, Top-7 legend and Most Vocal rows identical | ✅ PASS |
| A10a | Emotion comments table opens | Not reachable (hover tooltip absent headless) | ⛔ BLOCKED (automation) |
| A10b | Emotion column only shows "Love" | not evaluated | ⛔ BLOCKED (automation) |
| A10c | Topics column shows the clicked topic | not evaluated | ⛔ BLOCKED (automation) |
| A10d | Topics sentiment popup shows again after Close | not evaluated | ⛔ BLOCKED (automation) |

## Evidence
- Dev/Prod sentiment tile text and cloud arrays are in the session result (`ctx._topics`); the comparison flags `cloudEqual`, `classEqual`, `emotionEqual` were all true.

## Known bugs checked
- None open on the case.

## Notes
- A10 needs either a headed run (tooltips render on real hover) or a direct call to the comments endpoint; mark the A10 leg "manual" when this case is scheduled unattended.

## Bugs filed
None.

## Cleanup
Topic modal closed; sentiment mode left on in the dev tab (read-only).
