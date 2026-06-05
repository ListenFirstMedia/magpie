# QA-19557 — Brand Content - Impressions Data Set - Instagram Stories (re-run 2026-05-29)

- **Source spec:** testcases/english/QA-19557.md
- **Skill used:** brand-content-data-set-selector, switch-account
- **Account:** Adam Orfei (per re-run brief; spec brand UCLA not used because the re-run goal is to reproduce APPS-58817 / LFMP-32016 on Adam Orfei per bug-history sweep notes)
- **Brand:** MTV (brand_id=4018)
- **Date range:** May 24–30, 2026 (default Last 7 Days on Adam Orfei)
- **View:** Authorized Data (`.toggle-switch-checkbox input.checked === true`; toggle slider on the right per Rule 2 visual confirmation)
- **Channels:** all (Twitter, Instagram, Facebook, LinkedIn, TikTok, Threads)

## Result: FAIL (LFMP-32016 reproduced)

## Execution

1. Switched account to Adam Orfei via profile dropdown → Search Account → Results section → click "Adam Orfei" (account_id=54). Verified breadcrumb `Account: Adam Orfei`.
2. Navigated to Home → "Brand Content" suggested view tile. Default brand = MTV.
3. Confirmed View perspective is Authorized Data (slider on right, checkbox.checked=true).
4. Opened Data Set dropdown → selected `Impressions`. URL changed to `table_data_set=impressions`.
5. On the right of the table the "View Analysis with: [ ] Instagram Stories" checkbox appeared (this is the spec's step-5 control). Clicked it. URL changed to `table_data_set=impressions_with_stories`.
6. Page displayed loading skeletons → then "This table failed to load. Please try again." error tile with Reload button.
7. Clicked Reload → waited 20 s → same failure tile.
8. As a cross-check, navigated to Brand > Stories tab (same brand, same date range). Stories tab rendered correctly: IG Engagements 3,902 (+748%), Impressions 979K (+295%), Taps Back 26K (+174%), Exits 66.9K (+578%). Reach 889K (+301%). So IG Stories data IS being collected and is available to other pages.
9. Returned to Brand > Content and the table continued to fail (Public data set then back to impressions_with_stories) — failure reproducible across multiple reloads.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Step 5: Impressions metric shows data for all Story Publish Type posts on Brand > Content | Posts table populated with Story-type rows + Impressions column | Table fails to load ("This table failed to load. Please try again.") on both first render and Reload | FAIL |
| A2 | Step 6 (LinkedIn) | LinkedIn posts show Impressions data | Not reachable — table never loaded after enabling Instagram Stories | BLOCKED |

## Evidence

- URL: `https://app.lfmdev.in/#explore/brand/content?brand_id=4018&account_id=54&from=2026-05-24&to=2026-05-30&...&table_data_set=impressions_with_stories&...&perspective=extended`
- Sequence of screenshots: ss_2764rb6vl (initial fail), ss_0444t29vt (post-Reload still failing), ss_3137u67xt (continuing to fail after channel re-pivot).
- Stories tab control screenshot ss_79855pfr0 shows IG Stories data healthy at the Brand>Stories tab level.

## Bug reproduction outcomes

| Bug | Status |
|------|--------|
| LFMP-32016 — Story post data not displayed on Brand > Content | **REPRODUCED 2026-05-29.** Enabling the Instagram Stories checkbox on Impressions data set causes the table to fail with the generic "This table failed to load" error. Stories data exists (verified on Brand > Stories tab same date range) so this is a Content-page rendering / API failure, not a data-availability issue. |
| APPS-58817 — Posts deleted from Native still visible in LF app | **NOT VERIFIED.** Could not enumerate any posts because of the table-failure above. Would need either a brand whose impressions_with_stories table renders, or a comparison of native IG account state vs LF post list — neither feasible inside this run. |

## Notes

- The "View Analysis with: Instagram Stories" control is rendered on the right side of the Impressions table (under a "View Analysis with:" label). Spec wording "Enable Instagram stories checkbox in the view analysis" maps to this control. URL signal: `table_data_set=impressions_with_stories` after the click.
- Adam Orfei MTV per Last 7 Days returns 271 posts on Public data set without Stories — known to load. The failure is specific to the impressions_with_stories data-set request and is reproducible at the page level.
- Per Rule 1 — UCLA is the spec's brand but the re-run brief explicitly directed Adam Orfei to chase the two open bugs. This report is filed as a re-run finding, not a substitute pass/fail against the original UCLA spec.
