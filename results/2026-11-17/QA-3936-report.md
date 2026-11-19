# QA-3936 — Topics Cloud - Facebook Sentiment - Data QA

**Run date:** 2026-11-17 (Tuesday)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`); dev tab `app.lfmdev.in` (user from `config/.env`) + prod tab `app.listenfirstmedia.com` (prod QA user from `config/.env.prod`), both switched to **Viacom**
**Account:** Viacom (account_id=181) · **Brand:** MTV (brand_id=4018 on both) · Channel: Facebook only · Date range: default week Nov. 09, 2026 - Nov. 15, 2026 · Sentiment mode on (`sentiment_mode=true` on both)
**Verdict: PASS (A7 cloud parity) — the Topics cloud (25 topics with identical weights), the Top 7 Topics legend and the Classification / Emotion donut percentages are identical on Dev and Prod; the A10 "hover Love → Read Comments" leg is not evaluable headless (the hover tooltip never renders)**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–4 | Brand > Content → MTV → Facebook only → Sentiment button (`[data-ui-name=earned_sentiment_cta]`) | ✅ both environments, Posts (38) |
| 5–7 | Topics cloud on Dev vs Prod | ✅ 25/25 topics, only-dev 0, only-prod 0, weight differences 0. Cloud (font-size = weight): Mtv (64.0px), Jamie Miller (56.7px), Didi (38.4px), Jamie (33.5px), Africa (25.3px), Lagos (25.3px), Anitta (22.1px), Anne (22.1px), Anne Hathaway (22.1px), Asia (22.1px), Mabuhay (22.1px), Alex (17.5px), Ashe (17.5px), Brasil (17.5px), Charles (17.5px), Charlotte (17.5px), Frederick (17.5px), Illinois (17.5px), Laos (17.5px), Musica (17.5px), Parabens (17.5px), Rosalia (17.5px), Spongebob (17.5px), Vmas (17.5px), Tecolutla (16.0px). Top 7 Topics legend identical (africa, didi, jamie, jamie miller, lagos, mabuhay, mtv). Classification 68% / 26% / 6% and Emotion 20% / 42% / 29% on both |
| 8 | Close out prod page | ✅ prod tab left on the sentiment view, no further action |
| 9 | Click a topic in the cloud (dev) | ✅ clicking "Mtv" opens the topic modal: "Mtv" Comments: 4.66%, Total Comments (13), Classification 62% / 31% / 8%, Emotion Love 8% / Joy 31% / Surprise 15% / Neutral 31% |
| 10 | Hover the Love emotion and click Read Comments | ⛔ the mouse was moved onto the Love slice (pink arc) and onto the Love legend entry; no tooltip with Read Comments rendered under headless Chrome (same as every earlier run) |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7 | Same cloud data on Dev and Prod | 25/25 topics and weights identical; legend and donut percentages identical | ✅ PASS |
| A10a–d | Emotion comments table opens via hover → Read Comments; emotion column only Love; topics column shows the clicked topic; Close returns to the topics popup | hover tooltip does not render headless; not evaluated | ⛔ not evaluable (automation limit) |

## Evidence
- `results/2026-11-17/_topics-QA-3936.json` (both clouds with weights, legends, tile texts).
- Screenshots: `.playwright-out/QA-3936/topic-modal-1117.png`, `.playwright-out/QA-3936/topic-modal-love-hover-1117.png`.

## Known bugs checked
- No open linked bug (LFMP-28465, LFMP-29900, APPS-45078, APPS-45611, APPS-46079, APPS-46376 all Closed). The closed Dev-vs-Prod Topics mismatch bugs did not reproduce.
- The prod QA user's default brand on Viacom is "Criminal Minds"; MTV was selected from the brand picker.

## Bugs filed
None.

## Cleanup
None (read-only — the MUTE and Save to Dashboard buttons were not touched).
