# QA-96038 — Brand > Audience - Instagram - Followers: Gender Breakdown data test

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-96038
- **Run date:** 2026-06-02 (batch 12/12)
- **Account:** Hulu (account_id=336)
- **Brand:** Hulu (brand_id=5670, Authorized perspective default)
- **Channel:** Instagram only
- **Date Range:** May 19 – May 25, 2026
- **Result:** PASS 2/2 — re-confirmed end-to-end. CSV first-row Men Followers (856,949) matches API `instagram.page.gender=M, instagram.page.followers_m=856949`; CSV first-row Women Followers (1,333,591) matches API `instagram.page.gender=F, instagram.page.followers_m=1333591`. Meter values not summed across the 7-day window — every row shows the day-snapshot value, identical day-over-day.

## Reused skill

`audience-metrics-export` (now pass_streak 3+ across multiple separate days; promotion to `stable` already in registry).

## Steps executed

| Step | Action | State | Evidence |
|---|---|---|---|
| 0 | Direct URL nav with `account_id=336` → Hulu loaded (`Account: Hulu`) | OK | Verified via nav text |
| 1 | Brand → Audience for Hulu (brand_id=5670, channel=instagram, from=2026-05-19, to=2026-05-25) | OK | URL confirmed |
| 2 | Installed fetch hook on `window.fetch` before navigating (captures URL + body for `/content/analysis`) | OK | Persisted across navigation |
| 3 | Page loaded — 16 fetches captured, 4 hit `instagram.page.gender`. The Gender Breakdown tile's fetch is the one with `dimensions=[{expression:"instagram.page.gender"}]` (single dimension, no date/age) | OK | Response parsed |
| 4 | Verified the gender-only fetch response: `{"records":[{"instagram.page.gender":"M","instagram.page.followers_m":856949},{"instagram.page.gender":"F","instagram.page.followers_m":1333591}]}` | OK | (snippet below) |
| 5 | Located Followers: Gender Breakdown tile (donut chart 39%/61%/100%). Per Rule 2, donut shows Men 39%, Women 61%, indicator labels confirmed. | OK | Screenshot |
| 6 | Clicked Export dropdown at tile level (ref_540) → PNG / CSV / Google Sheets options visible | OK | Screenshot |
| 7 | Clicked CSV → file saved | OK | `~/Downloads/Hulu-Audience-Followers Gender Breakdown-2026-05-19-2026-05-25.csv` (340 B, 8 rows incl. header) |

## Network response (Gender Breakdown fetch)

```json
{
  "records":[
    {"instagram.page.gender":"M","instagram.page.followers_m":856949,"instagram.page.followers_m_authorized":"authorized"},
    {"instagram.page.gender":"F","instagram.page.followers_m":1333591,"instagram.page.followers_m_authorized":"authorized"}
  ],
  "request":{
    "brand_id":5670,"channel":"instagram",
    "metrics":[{"expression":"instagram.page.followers_m","aggFn":"sum"}],
    "dimensions":[{"expression":"instagram.page.gender"}],
    "data_set":"DataSetAudienceGenderAgeInstagram",
    "dimension_filters":[
      {"expression":"lfm.content.fact_date_str","operator":"BETWEEN","values":["2026-05-19","2026-05-25"]},
      {"expression":"lfm.brand.id","operator":"IN","values":[5670]}
    ],
    "response_style":"object"
  }
}
```

## CSV contents (saved to disk, observed via Read tool — Rule 6)

```
"Date","Brand Name","Channel","Men Followers","Women Followers","Men Followers Share","Women Followers Share"
"2026-05-25","Hulu","Instagram","856949","1333591","39.12%","60.88%"
"2026-05-24","Hulu","Instagram","856949","1333591","39.12%","60.88%"
"2026-05-23","Hulu","Instagram","856949","1333591","39.12%","60.88%"
"2026-05-22","Hulu","Instagram","856949","1333591","39.12%","60.88%"
"2026-05-21","Hulu","Instagram","856949","1333591","39.12%","60.88%"
"2026-05-20","Hulu","Instagram","856949","1333591","39.12%","60.88%"
"2026-05-19","Hulu","Instagram","856949","1333591","39.12%","60.88%"
```

## Assertion results

| ID | Spec assertion | Network value | CSV first value | Status |
|---|---|---:|---:|---|
| A1 | First value of 'Men Followers' in CSV matches `instagram.page.followers_m` for `instagram.page.gender=M` in Gender Breakdown fetch | 856,949 | 856,949 (row 1, 2026-05-25) | PASS |
| A2 | First value of 'Women Followers' in CSV matches `instagram.page.followers_m` for `instagram.page.gender=F` (spec typo says followers_m for women too; interpreted as same metric expr bucketed by gender — what API returns) | 1,333,591 | 1,333,591 (row 1, 2026-05-25) | PASS |

**Bonus check — spec's stated bug-prevention intent ("meter values are not summed and displays the last value in the export"):** All 7 CSV rows (2026-05-19 → 2026-05-25) each show 856,949 / 1,333,591 — the per-day snapshot value, NOT the sum across days (which would be ~6M and ~9.3M). Meter semantics correctly applied. Values identical to 2026-05-27 batch run — Hulu Instagram follower base hasn't moved.

## Bugs filed

None.

## Skill registry impact

- `audience-metrics-export` — pass_streak preserved (stable). Re-verified consistent CSV semantics and filename pattern `<Brand>-Audience-<Chart>-<from>-<to>.csv`.
- `fetch-hook-network-capture` shared technique — used successfully again.

## Sources

- [QA-96038 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-96038)
