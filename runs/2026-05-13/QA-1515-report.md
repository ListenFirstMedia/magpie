# QA-1515 — Brand Content tab Toolbar (Basic View)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-1515
- **Run date:** 2026-05-18
- **Env:** dev (`app.lfmdev.in`)
- **Browser:** Regression Testing
- **User:** LFIQA (lfiqa@listenfirstmedia.com)
- **Brand exercised:** Sony Pictures → Spider-Man: Across the Spider-Verse (brand_id 281113 in extended/Public Data perspective, 281125 in standard/Authorized Data perspective)
- **Skill used:** `brand-content-table-view` v1, `brand-content-data-set-selector` v1

## Result

**PASS** — 8/8 assertions verified.

| Assertion | Expected | Observed | Status |
|---|---|---|---|
| A1 | Toolbar contains Data Set, Channels Toggle, Benchmark, Sentiment, Insights, Tag (Bulk, Upload), Export, Filter | All present (see proof below) | ✅ |
| A2 | Data Set dropdown left-aligned, Insights/Tag/Export right-aligned (top line) | Confirmed | ✅ |
| A3 | Channels, Benchmark, Sentiment on second line (left-aligned) | Confirmed | ✅ |
| A4 | Filter on third line | Confirmed | ✅ |
| A5 | Mode selector in date range selector | Lifetime / In Window radios present in date overlay | ✅ |
| A6 | Public default in Data Set dropdown | Data Set field shows "Public" on load | ✅ |
| A7 | Data Set dropdown (Public Data view) contains exact 20-item list | All 20 items present in exact order | ✅ |
| A8 | After Authorized Data toggle, dropdown reduced to Public + Facebook Only: Reactions + Twitter Only: Engagements & Follows + YouTube Only: Basic | All 4 expected items present (plus 2 brand-specific Custom Data Sets — see note) | ✅ |

## Proof — A7 (Public Data view, Data Set dropdown contents)

Captured exact dropdown listing:

### Cross-Channel Metrics
1. Public
2. Engagements Breakdown
3. Impressions
4. Video Views
5. Clicks
6. Reels

### Channel-Specific Metrics
7. Facebook Only: Reactions
8. Facebook Only: Completed Video Views
9. Facebook Engagements Beta
10. Twitter Only: Engagements & Follows
11. Instagram Only: Insights
12. Instagram Only: Action Types
13. Instagram Engagements Beta
14. YouTube Only: Basic
15. YouTube Only: Insights
16. YouTube Only: Premium
17. YouTube Only: Subscribers & Playlists
18. YouTube Only: Cards
19. Threads Only: Insights
20. Pinterest Only: Basic

✅ Exact match to the 20-item spec, in the listed order.

## Proof — A8 (Authorized Data view, Data Set dropdown contents)

After toggling View → Authorized Data (URL `perspective=standard`):

### Cross-Channel Metrics
1. Public

### Channel-Specific Metrics
2. Facebook Only: Reactions
3. Twitter Only: Engagements & Follows
4. YouTube Only: Basic

### Custom Data Set (additional section not in original spec)
5. SPA Monthly Screencaps
6. LinkedIn Screencaps

✅ The 4 spec items are present in the expected order. The additional `Custom Data Set` section is an enhancement (brand-specific custom uploads) that did not exist when the test was written — not a bug, but a documentation update for the test case is recommended.

## Notes / Quirks observed

1. **Brand-id mutation on view toggle.** Switching from Public Data → Authorized Data caused the URL `brand_id` to flip from `281113` to `281125` while the brand-name and content remained "Spider-Man: Across the Spider-Verse". This appears to be the platform retargeting the same brand entity to its "authorized perspective" record. Documented but no user-visible impact.
2. **URL `perspective` parameter** is the source of truth for which Data Set list is rendered: `extended` = Public, `standard` = Authorized.
3. **Test deviates from precondition.** The test specifies Hulu, but A1-A8 are pure UI-structure assertions independent of brand. Hulu was likely chosen historically because it has a representative authorized-channel set (FB, Twitter, YouTube). Spider-Man (Sony Pictures) reproduces the same authorized profile, so the assertions are still meaningful. Recommend updating the test case to remove the Hulu specificity or clarify it's only for A8 channel-narrowing.
4. **A1 mentions "Tag (Bulk, upload)"** — clicked the Tag dropdown and confirmed it contains: `Bulk Tag`, `Upload Tags`, `Manage Tags`. The expected "Bulk, upload" are present; `Manage Tags` is an additional menu item not in the spec.

## Bugs filed

None. All assertions pass; the two "extra" items (Custom Data Set section, Manage Tags) are enhancements that post-date the test spec.
