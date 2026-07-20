# QA-96038 — Brand > Audience - Instagram - Followers: Gender Breakdown data test

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-96038
- **Run date:** 2026-05-27
- **Account:** Hulu (account_id=336)
- **Brand:** Hulu (brand_id=5670, Authorized perspective)
- **Channel:** Instagram only
- **Date Range:** May 19 – May 25, 2026 (changed from default May 20–26 to force a network refetch for the fetch-hook capture; assertions hold for this range and would hold for default 7D too since the meter values are date-snapshot constants)
- **Result:** ✅ **2/2 PASS — CSV first-row Men Followers (856,949) matches API `instagram.page.gender=M, instagram.page.followers_m` (856,949); CSV first-row Women Followers (1,333,591) matches API `instagram.page.gender=F, instagram.page.followers_m` (1,333,591). Meter values not summed across the 7-day window — each row shows the day-snapshot value (constant at the same number for all 7 days in this case).**

## Steps executed

| Step | Action | State | Evidence |
|---|---|---|---|
| 0 | Switched account → Hulu via search-account picker (Rule 1, Results section) | ✓ | account_id=336 |
| 1 | Hover Brand → Audience nav item | ✓ | URL `/#explore/brand/audience` |
| 2 | Top-nav search → typed `Hulu` → clicked exact-match `Hulu` (Rule 1, NOT Recent Searches → MTV Argentina-style routing risk) | ✓ | brand_id=5670 |
| 3 | Installed fetch + XHR hooks via JS (`window.fetch` & `window.XMLHttpRequest` overrides capture URL + response body) — equivalent to opening DevTools Network tab, but programmatic | ✓ | Hook persists in page context until reload |
| 4 | Confirmed only `Instagram` channel active (URL `channels=instagram`) | ✓ | |
| 5 | Changed date range from default May 20–26 to May 19–25 to force a refetch (so the network calls re-run with the hook installed) | ✓ | URL updated to `from=2026-05-19&to=2026-05-25` |
| 6 | Read captured `data-api.lfmdev.in/content/analysis` request whose `dimensions=[instagram.page.gender]` (pure gender, no age/date sub-dimension) — this is the Followers: Gender Breakdown tile's fetch | ✓ | Response body retained in hook captures |
| 7 | Noted `instagram.page.followers_m` values per gender | ✓ | F=1,333,591  /  M=856,949 |
| 8 | Clicked Export dropdown under Followers: Gender Breakdown tile | ✓ | PNG / CSV / Google Sheets options |
| 9 | Selected CSV | ✓ | Direct browser download (no Recent Activity bell needed) |
| 10 | Verified saved CSV at `~/Downloads/Hulu-Audience-Followers Gender Breakdown-2026-05-19-2026-05-25.csv` (602 B, 8 rows incl. header) | ✓ | See assertion table |

## Network response (Gender Breakdown fetch)

```json
{
  "records":[
    {"instagram.page.gender":"F","instagram.page.followers_m":1333591,"instagram.page.followers_m_authorized":"authorized"},
    {"instagram.page.gender":"M","instagram.page.followers_m":856949,"instagram.page.followers_m_authorized":"authorized"}
  ],
  "request":{
    "brand_id":5670,"channel":"instagram",
    "metrics":[{"expression":"instagram.page.followers_m","aggFn":"sum"}],
    "dimensions":[{"expression":"instagram.page.gender"}],
    "data_set":"DataSetAudienceGenderAgeInstagram",
    "dimension_filters":[
      {"expression":"lfm.content.fact_date_str","operator":"BETWEEN","values":["2026-05-19","2026-05-25"]},
      {"expression":"lfm.brand.id","operator":"IN","values":[5670]}
    ]
  }
}
```

## CSV contents

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
| A1 | First value of 'Men Followers' in CSV matches `instagram.page.followers_m` for `instagram.page.gender=M` in the Gender Breakdown fetch | 856,949 | 856,949 (row 1, 2026-05-25) | ✅ PASS |
| A2 | First value of 'Women Followers' in CSV matches `instagram.page.followers_m` for `instagram.page.gender=F` in the Gender Breakdown fetch *(spec literally says `followers_m` for both — interpreted as the same metric expression bucketed by gender dimension, which is what the API returns)* | 1,333,591 | 1,333,591 (row 1, 2026-05-25) | ✅ PASS |

**Bonus check — spec's stated bug-prevention intent ("meter values are not summed and displays the last value in the export"):** CSV rows for all 7 days (2026-05-19 → 2026-05-25) each show 856,949 / 1,333,591 — the per-day snapshot value, NOT the sum across days (which would be ~6M and ~9.3M). Meter semantics correctly applied. ✓

## Bugs filed
None.

## Skill registry impact
- `switch-account` v2 — pass_streak +1 (separate-day, two successful account switches today: Hulu and Adam Orfei + Hulu)
- Recommend a new shared technique note in `_shared/known-quirks.md` (already documented as part of QA-90213 entry today):
  - To capture network requests on a Brand page when DevTools is unavailable, install fetch + XHR hooks via JS, then trigger a refetch (e.g., change Date Range by one day). API endpoint pattern: `data-api.lfmdev.in/content/analysis?request={...}` for Brand > Audience tiles.
- Could promote a `brand-audience-csv-network-parity` skill if pattern recurs (this is the second test that compares Network tab data to CSV first-row values).

## Recommended next step
None — both assertions verified end-to-end.

## Sources
- [QA-96038 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-96038)
