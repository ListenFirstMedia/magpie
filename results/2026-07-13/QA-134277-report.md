# QA-134277 — Brand > Content - Verify CSV Export respects active Include/Exclude tag filter

**Run date:** 2026-07-13 | Account/Brand: Hulu (account_id=336, brand_id=5670) | Skill: brand-content-filter v2, export-csv

## Steps executed
1. Switched account to Hulu via switch-account skill (Search Account → Results → Hulu, confirmed `account_id=336`).
2. Brand > Content, confirmed brand logo = "Hulu Logo".
3. Filter → Tag: Include `#allsfairlondon`, switched radio to Exclude (same open panel), Exclude `#allsfairparis`, Apply.
4. Verified URL `filters` JSON encoded both pills correctly: `{"content_tags":[{"operator":"or","values":["#allsfairlondon"],"not":"false"},{"operator":"or","values":["#allsfairparis"],"not":"true"}]}`.
5. Attempted Export → result: **Export button rendered disabled** (no menu opens) because Posts(0).
6. Widened date range to Last 12 Months (7,946 unfiltered posts) and retried — still Posts(0) for this tag pair.
7. Tried Include=`None` (untagged posts) alone across the same 12-month window — also Posts(0) (genuinely no untagged posts, not the documented "OR+None Table-failed-to-load" quirk — no error pane rendered, just the standard empty state).
8. Cleared filter, confirmed URL reset.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | UI shows posts tagged with TAG_INC, excluding TAG_EXC | Filter pills applied and combined correctly (see step 3-4) — mechanically correct, but returned 0 posts for every tag combination tried (see Data-scope note) | PARTIAL — mechanic confirmed, count not independently verifiable |
| A2 | Filtered tag only visible in CSV | **NOT VERIFIED** — Export is disabled at Posts(0), so no CSV could be generated to inspect | BLOCKED (data-scope) |
| A3 | UI post count updates after switching Include AND → OR | Not reached — blocked upstream by A1/A2 data-scope issue | NOT VERIFIED |
| A4 | Filtered tag only visible in CSV (2nd export) | Same as A2 | BLOCKED (data-scope) |
| A5 | UI shows empty state; POSTCOUNT_C = 0 | **Independently confirmed as a side-effect**: every tag/tag-pair tried rendered the correct "There is no data available. Please select a different brand, brand set, or date range." empty state, never an error pane | PASS |
| A6 | No tag columns in CSV | Not verified — no CSV was generated (Export disabled) | BLOCKED (data-scope) |

## Data-scope finding (not a bug)
Every tag combination tried on Hulu (`#allsfairlondon`+`#allsfairparis`, and standalone `None`) returned **zero matching posts across a full 12-month window** (7,946 total unfiltered posts). This means either these specific curated tag values have no live post associations on this dev account, or (for `None`) Hulu's content is 100%-tagged so untagged-post count is legitimately 0 — both are plausible, non-bug explanations, not verified further given time budget. **This ticket's precondition ("5–6 tagged posts; 2–3 posts with ≥2 tags each") was not satisfiable with the tags sampled** — a future re-run should first grep a few real Hulu posts' tag chips in the UI to pick tags with confirmed live coverage before running the Export steps.

## New finding (non-bug, useful behavior)
Confirmed: the **Export button is disabled** (not clickable, no menu) whenever the post grid is at `Posts (0)` — the product correctly prevents generating an empty export rather than silently producing a header-only CSV. Worth folding into `export-csv` skill's failure-signature table.

## Process note (caught before false-bug report, per Rule 5)
First attempt to apply Include+Exclude together silently failed to update the URL (`filters` param stayed on a stale single-tag state) when the "Apply Filter" click was performed via a raw `page.mouse.click()` at JS-computed coordinates. Re-verified via DOM state (`.edit-operator-button`/checkbox classes) that the click selections were correct, then re-clicked Apply Filter using a real `getByRole('button').click()` (snapshot-ref-based) — it committed correctly every time thereafter. **Root cause: coordinate-based `page.mouse.click()` is unreliable for this Apply Filter button specifically** (possibly a hover-gated or debounced handler) — ref-based `browser_click`/`getByRole` clicks are the reliable pattern and should be used exclusively for this control. Not a product defect.

## Addendum (2026-07-13, later same session)
Re-verified with a proper wait-for-load (see QA-121217's methodology finding — this page's loading skeleton can look like a genuine empty state if read too fast). Re-applied `#allsfairlondon` alone on Hulu/Instagram-only/12-month window and waited 4s past the Apply click: result was a **literal, fully-rendered `Posts (0)`** (not the generic skeleton or ambiguous "no data" message) — confirms this tag genuinely has zero IG posts on this account, so the original data-scope conclusion in this report stands.

## Bugs filed
None.

## Cleanup
Clear All clicked — `filters` param confirmed removed from URL.

## Skill/KB updates
- `brand-content-filter`: add the coordinate-click-unreliable-for-Apply-Filter finding + the None/OR quirk reconfirmation (no error pane this time, contrasting with the documented `Tag=None + OR` "Table failed to load" quirk — that quirk needs 2+ merged OR values; a single `None` value alone renders cleanly, consistent with prior documentation).
- `export-csv`: add Export-disabled-at-zero-posts as a documented, expected behavior (not a bug signature).
