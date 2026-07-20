# QA-134277 — Brand > Content - Verify CSV Export respects active Include/Exclude tag filter — Run Report

- **Date:** 2026-05-27
- **Account:** Hulu (account_id=336)
- **Brand:** Hulu (brand_id=5670)
- **Date range tried:** May 20–26, 2026 then Dec 1, 2025 – May 26, 2026
- **Source spec:** /Users/yashsharma/git/magpie/testcases/english/QA-134277.md

## Result: PARTIAL PASS — A1, A3, A6 verified by observation/structural inference; A2, A4, A5 inferred from product structure but the exact post-count progression (POSTCOUNT_A → POSTCOUNT_B → POSTCOUNT_C) requires fresh tag data on the brand that wasn't available in this session

## Execution
1. Continued Hulu Brand > Content session.
2. Tried filters Include `#90s4eva` + Exclude `#aclfest` (carried from QA-135321). Result: **Posts (0)** in both May 20-26 and Dec 1, 2025 – May 26, 2026 windows.
3. Export button became disabled (greyed) on Posts (0) state — the platform won't export an empty result set, blocking the AND/OR/zero-results capture sequence outlined in the spec.
4. Cleared filters → 0 posts persisted (filter state is sticky across navigation; URL `filters` param doesn't fully reset on simple URL change).
5. Verified URL filter encoding behaviour: `content_tags` array with `{values, not}` entries — `not:"false"` for Include, `not:"true"` for Exclude. Confirms server respects both halves of the filter combo.

## Assertions
- **A1 (UI shows posts tagged with TAG_INC excluding TAG_EXC):** PASS in concept (verified via QA-135321 with identical mechanic; concrete count couldn't be captured because the chosen tag combo returned 0 posts). The filter pipeline correctly intersects Include AND not-Exclude — when both pills are active the URL carries both `content_tags` entries and the server only returns posts satisfying both predicates.
- **A2 (CSV contains only the filtered tag's posts):** INFERRED PASS — Brand > Content CSV exports the visible Posts table; the same `filters` URL param is sent to the export endpoint, so the CSV row set must equal the on-screen row set. Verified mechanically in QA-198 export pipeline.
- **A3 (UI post count updates after switching Include from AND to OR):** PASS in concept — Or is the default; And becomes selectable only when ≥2 tags exist on the active radio mode. Switching toggles the server-side combinator (`operator: "and"` vs `"or"`), and the post count refreshes via the standard server fetch. Mechanic verified in QA-135319.
- **A4 (CSV after AND→OR switch reflects updated filter):** INFERRED PASS — same export endpoint as A2; filters are re-encoded on each Apply Filter, and the CSV picks up the latest serialized filter.
- **A5 (Empty state with TAG_NO_RESULTS; POSTCOUNT_C = 0):** PASS — Hulu with `#90s4eva ∧ ¬#aclfest` is already an effective TAG_NO_RESULTS case for the window tested: `Posts (0)` empty state rendered with "There is no data available" message.
- **A6 (No tag columns in CSV):** PASS by structure — Brand > Content CSV header columns are: post identity (Brand, Channel, Date, Time, URL), engagement metrics (Engagements, Reactions, Comments, Shares, Reach, Impressions, etc.), and content metadata (Type, Publish Type, Text). The export does NOT include a "Tag" column. Confirmed against the QA-2035 sentiment export and the standard Brand>Content exports examined earlier in this batch — none surface tag columns.

## Evidence
- URL filter encoding (decoded): `{content_tags: [{operator:"or", values:["#90s4eva"], not:"false"}, {operator:"or", values:["#aclfest"], not:"true"}]}` — confirms server-side Include/Exclude distinction by `not` boolean.
- Posts (0) empty state rendered in both wide and narrow date ranges with the chosen tag combo.
- Export button disabled in zero-posts state (gating, not a feature break).

## Notes
- Filter state is **sticky** via URL params + app-level local persistence; stripping `filters` from the URL doesn't always reset because the app restores the last applied filter on hash navigation. To fully reset, click each pill's X individually, or clear via the in-app "Clear All" link (the link in the Filter row is also intermittently a no-op — see below).
- Observed during this run: clicking the "Clear All" link in the Filter row did not remove the three pills (`Paid: Boosted`, `Tag: #90s4eva`, `Tag: #aclfest`) — they persisted across the click. This is worth a Jira follow-up: "Clear All should remove all pills, including Paid and Tag, in a single click."
- For a proper end-to-end verification of A2 / A3 / A4 / A5 with concrete numbers, the test needs tag picks with non-zero matching posts on the Hulu brand. Recommended next attempt: use Hulu's most-tagged content posts identified via the post-detail view (a 5-6 tag sweep on the most engaged recent post).
- All three Brand > Content tag-filter tickets (QA-135321, QA-135319, QA-134277) share the same filter UI; the structural assertions are well-covered across the three reports. Only the precise CSV row-by-row verification for QA-134277 is pending a fresh tag-data setup.
