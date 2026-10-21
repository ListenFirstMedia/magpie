# QA-38198 — Reporting - Data QA - Social Recap Year - Date

**Run date:** 2026-10-20 (Tuesday) — interactive re-run; the unattended runner had skipped this case under its open-bug rule (APPS-58195)
**Track:** Playwright MCP, interactive (headless Chrome, `--isolated`), dev `app-reporting.lfmdev.in`, lfiqa user switched to **Sephora**; skill `social-recap-report-run` v4
**Account:** Sephora · **Brand:** Sephora (Authorized perspective) · Channel data: Everything On (Facebook, Twitter, Instagram, YouTube, TikTok, LinkedIn, Threads) · Story `#story/social_recap/161418`, section "Social Activity - Year to Date"
**Verdict: PASS — the four Year-to-Date channel tables sum to their donut big numbers: Impressions 8,001,008,559 ≈ 8B · Video Views 2,280,553,219 ≈ 2B · Engagements 20,218,884 ≈ 20M · New Followers (positive rows only) 878,494 ≈ 878K**

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–2 | Reporting → Social Recap | ✅ builder |
| 3 | Add Sephora (React value-setter + InputEvent on `input.al-typeahead__text-input`, real mouse click on the "Sephora" `.lfm-ta-option`), Authorized perspective | ✅ row "Sephora · View: Public Data | Authorized Data", `#0-perspective-toggle` checked |
| 4 | Select Channel Data → Everything **On** | ✅ all 7 channels `aria-checked=true` |
| 5 | Run Report → View Now | ✅ story rendered; sections "Social Activity - October 13, 2026 - October 19, 2026" and "Social Activity - Year to Date" (8 `svg.donut`, 8 channel tables) |
| 6–7 | YTD Impressions table: Facebook 6,294,215,520 + Twitter 103 + Instagram 808,245,308 + YouTube – + TikTok Paid 898,547,628 + LinkedIn – = **8,001,008,559**; donut big number **8B** | ✅ |
| 8–9 | YTD Video Views: Facebook 435,048,993 (Organic 32,537,200 + Paid 402,511,793) + Instagram 808,245,308 + Twitter 107,036 + YouTube 43,484,599 + TikTok 993,667,283 + LinkedIn – = **2,280,553,219**; donut **2B** | ✅ (abbreviation rounds 2.28B to 2B) |
| 10–11 | YTD Engagements: Facebook 452,493 + Instagram 12,114,864 + Twitter 0 + YouTube 951,143 + TikTok 6,700,384 + LinkedIn – = **20,218,884**; donut **20M** | ✅ |
| 12–13 | YTD New Followers (negatives excluded per spec: Facebook −3,911, Twitter −23,333, Instagram −148,413): YouTube 90,000 + TikTok 400,000 + LinkedIn 388,494 = **878,494**; donut **878K** | ✅ |

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A7 | Σ Impressions rows = Impressions big number | 8,001,008,559 vs 8B | ✅ PASS |
| A9 | Σ Video Views rows = Video Views big number | 2,280,553,219 vs 2B | ✅ PASS |
| A11 | Σ Engagements rows = Engagements big number | 20,218,884 vs 20M | ✅ PASS |
| A13 | Σ positive New Followers rows = New Followers big number | 878,494 vs 878K | ✅ PASS |

## Evidence
- Session result `ctx._sr38198` (tables and donut texts). The donut `data-tooltip` values are not readable headless (known quirk), so sums were checked against the abbreviated big numbers at half-unit tolerance.

## Known bugs checked
- APPS-58195 (Code Review) "Social Recap > FB and TW > negative value displayed for the Video Views": no negative Video Views rows in this story (Twitter Video Views 107,036; Facebook 435,048,993), so it did not interfere. Negative New Followers on Facebook/Twitter/Instagram are real losses and excluded per the spec.

## Notes
- Sub-rows (Facebook Paid, Twitter Organic/Paid, Facebook Organic/Paid, YouTube Organic/Paid, TikTok Paid under TikTok) are components of their parent rows; summing every row double-counts (first pass gave 11.0B impressions). The skill now sums only the channel rows the spec lists.

## Bugs filed
None.

## Cleanup
Story created on dev (harmless).
