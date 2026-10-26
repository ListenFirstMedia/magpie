# QA-26352 — Brand > Insights - Content Engagement Rate - Data Test

**Run date:** 2026-10-23 · **Track:** Playwright MCP, unattended headless (`claude -p`) · **Account:** Hulu (account_id=336, breadcrumb `Account: Hulu`) · **Brand:** Hulu (brand_id=5670, exact name) · **Date range:** Oct. 15 – Oct. 21, 2026 (default week; compared to Oct. 08 – Oct. 14) · **Channels:** Facebook + Twitter + Instagram only · **View:** Authorized data (default)

**Verdict: PASS (1/1) — Content Engagement Rate 1.17% equals (1,505,907 / 129,186,302) × 100 = 1.1657 → 1.17%**

## Preconditions
- Login: `lfiqa@listenfirstmedia.com` via Cognito "With existing account" → `#home`. The session landed on account UCLA (799), so I switched to **Hulu** through the LFQA menu: hover, type `Hulu` slowly into Search Account, click the `.lfm-ta-option` under `Results`. The URL changed to `account_id=336` and the breadcrumb read `Account: Hulu`.
- Open-bug screen (Rule 7): the case file says "None open" → ran normally.

## Steps
| # | Step | Result |
|---|------|--------|
| 1 | Navigate to Brand Insights tab | Home → Brand Insights card (it opened in a new tab) → `#explore/brand/insights?brand_id=5670&account_id=336&from=2026-10-15&to=2026-10-21&compare_from=2026-10-08&compare_to=2026-10-14`. Landed on the Insights sub-tab |
| 2 | Add Hulu brand | The page header shows **Hulu** (brand 5670, the account's default brand, exact name — no substitution, Rule 1). No other brand was needed |
| 3 | Enable Facebook, Twitter, Instagram only | The default load had Facebook, Twitter, Instagram and TikTok enabled. I clicked the TikTok ghost to turn it off (trusted click) and verified `facebook/twitter/instagram enabled`, `tiktok` and all others `disabled`. Clicked **Apply** → URL `channels=twitter&channels=instagram&channels=facebook`. Legends then read "Facebook, Twitter, Instagram" |
| 4 | Hover Engagements big number, note value | Real `browser_hover` on the count → tooltip **Value 1,505,907** (Comparison 1,411,098, Change +94,809). Tile header shows 1.51M, `.count[title]` = `1,505,907` |
| 5 | Hover Impressions big number, note value | Tooltip **Value 129,186,302** (Comparison 155,738,173, Change −26,551,871). Tile header shows 129M, `.count[title]` = `129,186,302` |
| 6 | Hover Content Engagement Rate big number, note value | Tooltip **Value 1.17%** (Comparison 0.91%, Change +0.26%). Tile header shows 1.17%, `.count[title]` = `1.17%` |
| 7 | Compute (Engagements / Impressions) × 100 and compare | 1,505,907 / 129,186,302 × 100 = **1.16569 %** → 1.17% at 2 decimals. The difference from the displayed 1.17% is 0.0043 pp, within the ±0.01 pp tolerance |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A7 | 7 | Content Engagement Rate equals (Engagements / Impressions) × 100 | Calculated 1.1657% (rounds to 1.17%); displayed 1.17% (tooltip and tile header). Difference 0.0043 pp | ✅ PASS |

## Evidence
- Screenshots in `.playwright-out/QA-26352/`: `03-insights-landing.png` (Hulu header, skeleton load), `04-insights-loaded.png` (Hulu header, Authorized data, 4 channels before the change), `05-hover-engagements.png`, `06-hover-impressions.png`, `07-hover-cer.png` (each tooltip with its Value row).
- Tile headers after Apply: Engagements 1.51M (+7%), Content Engagement Rate 1.17% (+29%), Impressions 129M (−17%).
- Exact values come from the hover tooltips and match the `.count[title]` attributes.
- Cross-check on the comparison period: 1,411,098 / 155,738,173 × 100 = 0.906% → 0.91%, which matches the tooltip's Comparison of 0.91%.
- Render time: the 7 big-number tiles showed "Loading" for about 75 s after Apply, then all rendered. That is within the 5-minute budget, so no retry or reload was needed.

## Known bugs checked
- The case file says no open linked bugs. `bug-history.md` and `known-quirks.md` had no entries for QA-26352 (pre-fetched).
- A "Facebook Data Collection Disruption 9/27" platform banner was showing. It did not affect the identity: the displayed rate agrees with the displayed Engagements and Impressions.
- Neither the Data Collection Status chip (5 red / 2 blue / 24 green) nor the other tiles interfered with the assertion.

## Bugs filed
None. · **Cleanup:** none (read-only case).
