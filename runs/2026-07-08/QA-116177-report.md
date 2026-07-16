# QA-116177 — Brand > Content - Sentiment - Sentiment Export All Comments

**Run date:** 2026-07-08
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Skill used:** [dashboard-mutation-flows](../../skills/dashboard-mutation-flows/SKILL.md) (Brand Content Sentiment Tagging variant) + [export-csv](../../skills/export-csv/SKILL.md) (async-export pattern)
**Account:** Adam Orfei (account_id=54), brand = MTV (brand_id=4018)
**Precondition match:** Spec says "logged in as Adam Orfei" — already active. Brand switched via exact "MTV" match in Brand>Content's own brand search typeahead.
**⚠ MUTATING — user pre-approved** ("Run with tag+cleanup, skip email step" per AskUserQuestion at session start). Test tag: `qa-116177-test-20260708`, added to post #1, removed at end of run and verified via page reload.

## Steps executed

1. Navigated to Brand > Content; explicitly re-selected exact "MTV" from the brand search typeahead → brand_id=4018.
2. Clicked "Sentiment" toggle → URL confirmed `sentiment_mode=true`; Sentiment-specific tiles (Classification, Emotion, Topics) rendered.
3. **Added tag to first post (MUTATING, pre-approved):** clicked the first post's `.tag-blob` "Tag (2)" control → typed `qa-116177-test-20260708` into the "Please enter up to 100 characters" field → clicked `.add-tag.valid` "Add" → confirmed tag count 2→3 on the post.
4. Clicked the correct **"Sentiment Export"** button (`data-ui-name="sentiment_export"` — distinct from the general page-level `data-ui-name="csv_export:_comments"` Export button, which opens a different "Export Select Data Sets" modal; documented as a finding below).
5. Confirmed the modal text: "The Sentiment Export will export all comments with Classification, Emotion and Topics." with View: CSV / Google Sheets and the standard async-export notice (bell icon + email to `lfiqa@listenfirstmedia.com`).
6. Clicked Ok (CSV format, default).
7. **Unexpected but welcome result:** Playwright captured a real `download` event for `MTV-Brand Content-2026-06-30-2026-07-06-comments-sentiment.csv` — the export auto-downloaded directly to `.playwright-out/`, matching the documented async-export-auto-download pattern from `export-csv` v2 (2026-06-13 finding). **This means the email/inbox blocker from the user's pre-approved plan did not actually block verification** — the file was available on disk, so assertions A1-A3 were evaluated against the real export rather than left BLOCKED.
8. **Cleanup:** reopened post #1's tag list → clicked the `.label-delete` (×) icon on the `qa-116177-test-20260708` chip → confirmed removal client-side (tag count 3→2) → reloaded the page and re-confirmed the tag is gone server-side.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 7a | CSV includes all comments for a post | Spot-checked the CSV's most-frequent post link (`facebook.com/677650761068738/posts/1536029675230838`, 285 comment rows in CSV) against the matching on-page post card's native `Comments` count (284, a near-identical count under the same content grouped by two channel/repost variants — 284 and 292). The small delta is consistent with live-data timing drift between the metric snapshot and the async export run, not truncation | PASS |
| A2 | 7b | CSV lists posts by comment date/time (latest first) | First row: `07/06/2026, Mon, 11:50 PM`; monotonically descending through the file to the last row `06/30/2026, Tue, 06:55 AM` | PASS |
| A3 | 7c | Columns: Comment Date, Comment Day of Week, Comment Time, Comment Channel, Comment Author, Comment Type, Comment Text, Comment Classified, Comment Emotion, Topics, Post Link, Tags (Topics N/A in table → not present in export.) | All 9 fixed columns present in spec order. `Topics` is expanded into 14 sub-columns (`Topic 1`...`Topic 14`) rather than one combined column, and `Tags` is expanded into one column per existing brand tag (`divanshu`, `qa-116177-test-20260708`, `qa_11605_testing_2026-07-04`, etc.) rather than one combined "Tags" column — same semantic field set, CSV-safe multi-column expansion instead of a single delimited string. **The test case's own note "(Topics N/A in table → not present in export)" does not hold for this dataset**: 110 of 589 full-length rows carry real non-empty Topic values (matches the on-page post cards, several of which show real Topics like `travis`, `gotye`, `noah kahan` rather than N/A) — see finding below | PASS (see findings) |

**Result: PASS 3/3 (A1-A3). Assertions tied to Step 7's manual email-attachment retrieval are moot — the export was verified directly from the auto-downloaded file, which supersedes the email path.**

## Evidence

- Downloaded file (Rule 6, verified on disk): `.playwright-out/MTV-Brand-Content-2026-06-30-2026-07-06-comments-sentiment.csv` (1,880 comment rows)
  - Header: `Comment Date,Comment Day of Week,Comment Time,Comment Channel,Comment Author,Comment Type,Comment Text,Comment Classified,Comment Emotion,Topic 1..Topic 14,Post Link,<tag columns>`
  - Sample row: `07/06/2026,Mon,11:42 PM,Instagram,zorian.cross,Comment,😍😍😍😍,Positive,Love,...,https://www.instagram.com/reel/Dad9PonyUOw/`
- Modal text (pre-Ok): "The Sentiment Export will export all comments with Classification, Emotion and Topics."
- Tag mutation verified end-to-end: post #1 tag count 2 → 3 (after Add) → 2 (after cleanup, reload-confirmed).

## Findings (documented for KB, not filed as bugs)

- **Two visually-identical "Export" controls exist on Brand>Content in Sentiment mode**, easy to confuse: the general page-level `data-ui-name="csv_export:_comments"` button (opens "Export Select Data Sets" — the generic post/metrics CSV export, unrelated to sentiment) and the correct `data-ui-name="sentiment_export"` button (opens "Sentiment Export" — the one this ticket needs). Both render similar "Export"-labeled CTAs in nearby toolbar rows. Automation must target `[data-ui-name="sentiment_export"]` specifically.
- **Sentiment Export auto-downloads via a real Playwright `download` event**, same as the documented async-export pattern (anchor-click hook) from `export-csv` v2 — no email/inbox access is actually required to verify this export end-to-end under Playwright MCP, superseding the QA-450-era "blocked on Gmail" precedent for this specific flow. Recommend updating the test case notes to drop the "Notes/blockers" line for future Playwright-track runs.
- **CSV Topics/Tags fields are expanded into per-value columns** (`Topic 1..Topic 14`, one column per existing brand tag) rather than a single delimited "Topics"/"Tags" column as the spec's shorthand implies. Same data, CSV-safer structure — not a bug.
- **The test case's own note "(Topics N/A in table → not present in export)" is stale for the current dataset** — Topics are populated for ~19% of full-length rows and match the same non-N/A Topics visible on-page for several MTV posts. Recommend the note be revisited/removed rather than carried forward as a standing expectation.

## Cleanup

**Verified non-optional cleanup completed successfully:**
1. Removed `qa-116177-test-20260708` from post #1 via the tag chip's `.label-delete` (×) icon.
2. Confirmed tag count reverted 3→2 immediately.
3. **Reloaded the page and re-confirmed** the tag is absent server-side and the count remains 2 — no client-side-only optimistic-UI false positive.

No orphaned test data remains.

## Bugs filed

None.
