# QA-134586 — Brand > Channel > Instagram > Public Data

- **Set:** QA-4325 (Daily Regression Test Set - 2)
- **Run:** 2026-07-10, interactive headed (Playwright MCP)
- **Priority:** Major
- **Account/Brand:** Adam Orfei (account_id=54) · MTV (public entity brand_id=10765) · Brand > Channels · **Public Data** perspective · from=2026-07-02 to=2026-07-08

## Verdict: PASS

## Known bugs checked
No linked issues. No open bug interferes.

## Assertions
| ID | Expected | Actual | Status |
|---|---|---|---|
| A3 | Perspective changed successfully | perspective toggle flipped Authorized → **Public Data**; URL perspective=standard, brand entity switched to MTV's public id 10765 | PASS |
| A4a | Insights, Content, Save to Dashboard present below tile | IG tile footer = **Insights \| Content \| Save to Dashboard** | PASS |
| A4b | 7 metrics displayed | Total Followers, New Followers, Fan Growth Rate, New Posts, Engagements, Organic Response Rate, Video Views — all present | PASS |
| A4c | Video Views just below Organic Response Rate | order: …Organic Response Rate 0.11% (-5%) → **Video Views 6,249,706 (-30%)** | PASS |
| A4d | Values with percentages | Total Followers 21,092,775 (-<1%), New Followers -10,603 (-21%), Fan Growth Rate -0.05% (-21%), New Posts 19 (-27%), Engagements 429,359 (-31%), Organic Response Rate 0.11% (-5%), Video Views 6,249,706 (-30%) | PASS |
| A4e | Impressions NOT displayed (authorized-only) in public tile | IG public tile shows only the 7 metrics above — **no Impressions** | PASS |
| A6a | IG tile values match Brand Insights page | Insights tiles: Total Followers **21.1M** (-<1%), Fan Growth Rate **-0.05%** (-21%), New Posts **19** (-27%), Engagements **429K** (-31%), Public Video Views **6.25M** (-30%) — all match the channel tile | PASS |
| A6b | Same start/end dates on channel & insights | both from=**2026-07-02** to=**2026-07-08** | PASS |
| A8a | Content page = only Instagram channel + public perspective | Content URL: channels=**instagram**, perspective=**standard**, table_data_set=**public** | PASS |
| A8b | Same start/end dates on channel & content | both from=**2026-07-02** to=**2026-07-08** | PASS |

## Method notes
- Perspective toggle: `.perspective-toggle-selector` → click `.toggle-switch-label` (trusted). Switching to Public Data re-keys the brand to its public entity id (MTV: authorized 4018 → public 10765) — expected; brand name stays "MTV".
- Insights/Content buttons below the channel tile carry the channel (instagram), perspective (standard/public), brand, and date range through to the destination page.
- Insights summary-tile values are formatted (21.1M, 429K, 6.25M) but resolve to the same figures as the channel tile's full numbers (21,092,775 / 429,359 / 6,249,706).

## Bugs filed
None.
