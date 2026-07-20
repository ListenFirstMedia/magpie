# QA-115716 — Brand > Insights - Fan Growth Rate - Export CSV

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-115716
- **Run date:** 2026-05-18
- **Env:** dev (`app.lfmdev.in`)
- **Account:** Hulu (account_id 336)
- **Brand:** Hulu (brand_id 5670)
- **Date range:** May 11 – May 17, 2026
- **Result:** ✅ **7/7 PASS**

## Assertion table

| Assertion | Expected | Observed | Status |
|---|---|---|---|
| A1 (3a) | Header format `Fan Growth Rate: -0.03% (->999%)` | Tile header: **`Fan Growth Rate: 0.55% (+63%)`** — exact format `<value>% (<delta>%)` | ✅ |
| A2 (3b) | Legend = Facebook, Twitter, Instagram, TikTok / `- Compared To` | Legend: `■ Facebook, Twitter, Instagram, TikTok` / `- Compared To` | ✅ |
| A3 (3c) | X axis dates, Y axis values | X: `May. 11, May. 12, …, May. 17`; Y: `0%, 0.01%, 0.02%, … 0.12%` | ✅ |
| A4 (4) | Tile updated to Bar | Bar chart rendered after graph-type dropdown set to `Bar` (default Bar verified) | ✅ |
| A5 (5a) | Filename = `Brand-Tab-Tile-YYYY-MM-DD(Start)-YYYY-MM-DD(End).csv` | Captured anchor `download` attribute: **`Hulu-Insights-Fan Growth Rate-2026-05-11-2026-05-17.csv`** — exact spec match | ✅ |
| A6 (5b) | Headers: Date, Brand Name, Channel, Fan Growth Rate | CSV line 1: `"Date","Brand Name","Channel","Fan Growth Rate"` | ✅ |
| A7 (5c) | Fan Growth Rate in decimal format | All rows show full-precision decimals: `0.0009443576876069059`, `0.00119158636410735`, `0.000666974580632275`, … | ✅ |

## Proof — first 6 lines of CSV

```
"Date","Brand Name","Channel","Fan Growth Rate"
"2026-05-17","Hulu","Cross-Channel","0.0009443576876069059"
"2026-05-16","Hulu","Cross-Channel","0.00119158636410735"
"2026-05-15","Hulu","Cross-Channel","0.000666974580632275"
"2026-05-14","Hulu","Cross-Channel","0.000696930924915812"
"2026-05-13","Hulu","Cross-Channel","0.000597231184141344"
```

## Capture details

- **anchor.download** attribute set client-side to `Hulu-Insights-Fan Growth Rate-2026-05-11-2026-05-17.csv` — so the browser respects the spec filename even with no `Content-Disposition` header from the server.
- This contrasts with **QA-531/BC-2** where the Brand > Content export anchor had `download=""` (empty) and produced a CDN-hashed filename. Insights tile exports use a different export pipeline that correctly sets the download filename client-side.

## Skill use
- Reused `export-csv` skill v2 — blob interceptor pattern worked first try for this tile (blob-based, not server-side queued).

## Bugs filed
None. Filename behavior is correct here, which makes the BC-2 finding in QA-531 a real inconsistency between the two export pipelines.
