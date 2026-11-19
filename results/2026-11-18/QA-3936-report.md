# QA-3936 — Topics Cloud - Facebook Sentiment - Data QA

**Run date:** 2026-11-18 (Wednesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`), both switched to **Viacom**
**Account:** Viacom (account_id=181) · **Brand:** MTV (brand_id=4018 on both) · Channel: Facebook only · Date range: default week Nov. 10, 2026 - Nov. 16, 2026 · Sentiment mode on (`sentiment_mode=true` on both)
**Verdict: PASS (A7 cloud parity) — the Topics cloud (25 topics with identical weights), the Top 7 Topics legend and all seven sentiment tiles (Classification, Emotion, Topics, Top 7 Topics, 25 Most Vocal) are identical on Dev and Prod; the A10 "hover Love → Read Comments" leg is not evaluable headless (the hover tooltip never renders)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–4 | Brand > Content → MTV → Facebook only → Sentiment button (`[data-ui-name=earned_sentiment_cta]`) | ✅ both environments, Posts (38) |
| 5–7 | Topics cloud on Dev vs Prod | ✅ 25/25 topics, only-dev 0, only-prod 0, weight differences 0. Cloud (font-size = weight): Mtv (64.0px), Jamie Miller (50.7px), Moin (44.7px), Didi (34.5px), Jamie (30.1px), Africa (22.9px), Lagos (22.9px), Anitta (20.1px), Anne (20.1px), Anne Hathaway (20.1px), Asia (20.1px), Mabuhay (20.1px), Raye (17.8px), Alex (16.0px), Ashe (16.0px), Brasil (16.0px), Charles (16.0px), Charlotte (16.0px), Frederick (16.0px), Illinois (16.0px), Laos (16.0px), Parabens (16.0px), Rosalia (16.0px), Spongebob (16.0px), Vmas (16.0px). Top 7 Topics legend identical (africa, didi, jamie, jamie miller, lagos, moin, mtv). Classification 68% / 27% and Emotion 19% / 42% / 29% on both; the text of all 7 sentiment tiles is identical |
| 8 | Close out prod page | ✅ prod tab left on the sentiment view, no further action |
| 9 | Click a topic in the cloud (dev) | ✅ clicking "Mtv" opens the topic modal with the Emotion legend Love 7% / Joy 29% / Surprise 14% / Neutral 36% |
| 10 | Hover the Love emotion and click Read Comments | ⛔ the mouse was moved onto the Love legend entry in the modal; no tooltip with Read Comments rendered under headless Chrome (same as every earlier run) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7 | Same cloud data on Dev and Prod | 25/25 topics and weights identical; legend and tile texts identical | ✅ PASS |
| A10a–d | Emotion comments table opens via hover → Read Comments; emotion column only Love; topics column shows the clicked topic; Close returns to the topics popup | hover tooltip does not render headless; not evaluated | ⛔ not evaluable (automation limit) |

## Evidence
- `results/2026-11-18/_topics-QA-3936.json` (both clouds with weights, legends, tile texts).
- Screenshots: `.playwright-out/QA-3936/topic-modal-1118.png`, `.playwright-out/QA-3936/topic-modal-love-hover-1118.png`.

## Known bugs checked
- No open linked bug (LFMP-28465, LFMP-29900, APPS-45078, APPS-45611, APPS-46079, APPS-46376 all Closed). The closed Dev-vs-Prod Topics mismatch bugs did not reproduce.
- The prod QA user's default brand on Viacom differs from dev's; MTV was selected from the brand picker on both.

## Bugs filed
None.

## Cleanup
None (read-only — the MUTE and Save to Dashboard buttons were not touched).
