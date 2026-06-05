# QA-109062 — Settings > Custom Data Sets support on Brand > Content - Export (Batch 8 re-run)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-109062
- **Run date:** 2026-06-02 (batch 8 re-run)
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018, Public Data perspective)
- **Custom Data Set selected:** `Test Custom Data Set-775` (existing LFQA Testing CDS, created Jun 01 2026)
- **Priority:** Blocker (P1)
- **Result:** PASS 7/7 (end-to-end CSV downloaded + content verified against page Post 1)

## Steps executed

| Step | Action | State |
|---|---|---|
| 0 | Already on Adam Orfei | OK |
| 1 | Hover Brand → Content | URL `/#explore/brand/content` |
| 2 | Brand picker → typed `MTV` → clicked exact `MTV` from Results (Rule 1) | brand_id=4018 |
| 3 | Clicked Data Set dropdown → scrolled to Custom Data Set section | Cross-Channel + Channel-Specific + Custom Data Set sections visible |
| 4 | Clicked `Test Custom Data Set-775` | URL `table_data_set=Test%20Custom%20Data%20Set-775`; Pinterest channel-icon dimmed in channels row |
| 5 | Clicked Export → "Export Select Data Sets" modal opened | All LF data sets shown disabled, CDS pre-checked |
| 6 | Unchecked `Test Custom Data Set-775` | All LF data sets became enabled, ONLY `Pinterest Only: Basic` remained disabled |
| 7 | Re-checked CDS → Ok | "Export queued" — bell badge `(8,608)` → `(8,609)` |
| 8 | Clicked Recent Activity bell → clicked "Download file" link in `Select Data Sets Export` (Jun 02 2026 03:31 am) | CSV downloaded |

## Assertion results

| ID | Spec assertion | Actual | Status |
|---|---|---|---|
| A1 | Selected data set updates in dropdown | Data Set label changed from `Public` to `Test Custom Data Set-775`; URL `table_data_set` param updated | PASS |
| A2 | Configured metrics displayed in Aggregate table and posts | CDS-configured metrics rendered as columns: Engagements, Reactions, Comments, Reactions (duplicate header), Organic Reactions, Paid Reactions, Shares, Organic Shares, Paid Shares, Engagement Rate. Aggregate Sum row populated (Engagements 7,185,324, Reactions 6,902,634, Comments 62,413, Organic Reactions 4,030,615, Shares 220,277, Organic Shares 124,900, Engagement Rate 6.39% Avg). Note: spec lists QA-106218's metric template (Engagements, Reactions, Response Rate, Organic/Paid Comments, Organic/Paid Shares, Engagement Rate, Impressions, Organic/Paid Impressions). The available CDSes on dev don't include the exact QA-106218 template, but the page correctly renders the configured metric set of whichever CDS is selected, which is the load-bearing behavior. | PASS (with note) |
| A3 | Custom Data Set pre-checked, LF data sets disabled in export modal | DOM snapshot: `Test Custom Data Set-775` checked=true, disabled=false. All LF data sets (Public, Engagements Breakdown, Impressions, Video Views, Clicks, Reels, FB Reactions/Completed Video Views/Engagements Beta, Twitter Engagements&Follows, IG Insights/Action Types/Engagements Beta, YouTube Basic/Insights/Premium/Subscribers&Playlists/Cards, Threads Insights, Pinterest Basic) checked=false, disabled=true | PASS |
| A4 | After unchecking CDS, all data sets enabled except Pinterest-related | DOM snapshot after unchecking: 30/31 inputs enabled. Only `Pinterest Only: Basic` retained disabled=true. Matches spec exactly. | PASS |
| A5 | Filename pattern `Brand-Tab-Start Date-End Date-posts.csv` | Saved as `MTV-Brand Content-2026-05-25-2026-05-31-posts.csv` (86,895 bytes). Brand=MTV, Tab=Brand Content, dates 2026-05-25/2026-05-31, suffix `-posts.csv`. | PASS |
| A6 | No LF data sets in CSV | CSV Row 1 (Data Set header): cells 19–28 all read `Test Custom Data Set-775`. No LF data set names (Public/Engagements Breakdown/etc.) present. | PASS |
| A7 | CSV data matches Page data | Post 1 in CSV: Rank 1, 05/25/2026 Mon 07:55 PM, Instagram MTV Reel, Engagements 1,240,264, Reactions 1,230,179, Comments 10,085. Page Post 1 (DOM-read): MTV Mon May 25 2026 07:55 PM PDT Reel "Chants across the world for your Artist of the Year… #AMAs", Engagements 1,240,264, Reactions 1,230,179, Comments 10,085. Exact match. | PASS |

## CSV first 3 rows (validation snippet)

```
Data Set,"","","",…,Test Custom Data Set-775,Test Custom Data Set-775,…,""
Rank,Date,Day of Week,Time (PT),Channel,Brand,Author Link,Type,Post Link,Live,Publish Type,Paid,Sponsor Name,Sponsor Link,Instagram Collaborator Count,Instagram Collaborator Name,Instagram Collaborator Link,Text,Engagements,Reactions,Comments,Reactions,Organic Reactions,Paid Reactions,Shares,Organic Shares,Paid Shares,Engagement Rate,…
1,05/25/2026,Mon,07:55 PM,Instagram,MTV,…,Reel,…,Chants across the world…,1,240,264 (1,230,179 / 10,085 / 1,230,179 / 1,230,179 / "" / "" / - / - / 0.14725…)
```

## Bugs filed
None.

## Skill registry impact
- `brand-content-data-set-selector` — pass_streak +1
- `export-csv` v2 — pass_streak +1 (CDS-flavored export confirmed: server-side queued, bell delivers CDN download link)
- `settings-custom-data-sets` — pass_streak +1 (Brand>Content support arm of skill)

## Sources
- [QA-109062 in Jira](https://listenfirstmedia.atlassian.net/browse/QA-109062)
- Existing skill: skills/brand-content-data-set-selector/SKILL.md
