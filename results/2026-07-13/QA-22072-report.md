# QA-22072 — Brand > Partnerships - Basic View data set

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54), Brand: MTV (brand_id=4018)
**Status:** ⚠️ SPEC/FEATURE DRIFT (reconfirms 2026-06-05/06-13 finding)

## Steps executed
1. Brand → Partnerships, MTV. Data Set defaulted to **Basic**.
2. Opened Filter → Select dropdown, enumerated all available filter categories via `data-ui-name` attributes.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Basic View data set is selectable on Brand > Partnerships | Confirmed — "Data Set: Basic" is the default and only landing state | ✅ PASS |
| A2 | Advanced Filter for Metrics is available and functional | **No metric-based filter exists.** Full filter option list: `collaborated_filter, collaborated_total_filter, collaborator_name_filter, content_type_filter, content_publish_day_filter, content_publish_time_filter, content_publish_type_filter, content_sponsor_name_filter, content_tag_filter, content_text_search_filter`. None of these filter by a numeric metric (e.g. Engagements > N) | ❌ FAIL (spec/feature drift) |

## Verdict

**Reconfirms the known spec/feature drift** already documented in `knowledge-base/known-quirks.md` and the 2026-06-05/2026-06-13 cumulative reports: Brand>Partnerships Basic View filter has no metric-based sub-filter. This is the third consecutive run confirming the same drift (2026-06-05, 2026-06-13, now 2026-07-13) — high confidence this is either a permanent product decision or a genuinely stale/never-implemented spec line. Recommend either closing this assertion in the Jira spec or confirming with product whether metric-filtering was ever planned for Partnerships Basic View.

## Bugs filed

None — third reconfirmation of pre-existing documented drift, no new bug ticket warranted.

## Cleanup

Not applicable — no mutation.
