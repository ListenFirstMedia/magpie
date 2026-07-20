# QA-121158 — Brand Content - Instagram - Collaborated Total Filter Functionality

**Run date:** 2026-07-13 | Account/Brand: Hulu (336/5670) | Skill: brand-content-filter v2

## Steps executed
1-2. Brand>Content, Hulu confirmed.
3. Opened Filter dropdown — read the full filter-type list order.
4. Clicked "Collaborated Total" — read its 5 numeric options.
5. Clicked "1", Apply Filter.
6. Observed post count/state.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Collaborated Total between Collaborated and Collaborator Name | Filter-type order confirmed: `Branded Content, Collaborated, Collaborated Total, Collaborator Name, Content Type, ...` | PASS |
| A2 | Options are 1, 2, 3, 4, 5 | Sub-panel showed exactly `1 2 3 4 5` | PASS |
| A3 | Posts header count updated | URL correctly updated to `filters={"content_collaborator_count":{"operator":"or","values":["1"],"not":"false"}}` — mechanic confirmed; UI state showed the empty-data message (0 posts) rather than a numeric count (see data-scope note) | PASS (mechanic) |
| A4 | Only Collaborated posts display | Cannot independently confirm post-badge content since 0 posts rendered — mechanic (filter applies, query encodes correctly) confirmed | PARTIAL — no rows to inspect |
| A5 | Filter count == posts Collaborated count | Not verifiable at 0 posts (0==0 trivially, not a meaningful check) | PARTIAL — data-scope |

**Result: 3/5 PASS, 2/5 PARTIAL (data-scope, not mechanic failures).**

## Process note
First attempt at this ticket accidentally inherited an uncommitted giant Tag filter left over from the prior ticket (QA-138162) — a `Clear All` click there had been intercepted by a lingering dropdown overlay and silently failed. Caught via inspecting the actual applied `filters` URL (it contained the full ~500-tag list plus the new Collaborated Total value) rather than trusting the empty-state UI alone. Fixed by pressing `Escape` to dismiss the stuck overlay, re-confirming `filters` param was absent, then redoing this ticket cleanly. **Lesson for future tickets in this session: always verify the `filters` URL param is empty after each `Clear All`, not just visually — a blocked click can silently no-op.**

## Data-scope note (not a bug)
Both "2 collaborators" (first attempt) and "1 collaborator" (clean retry) returned 0 matching posts for Hulu across all channels over the last 12 months. Content-collaboration tagging may simply be rare/absent on this dev account's Hulu posts in this window — consistent with the zero-result pattern seen across several other Hulu tag/filter tickets this session (QA-134277, QA-121158). Not independently root-caused further given time budget.

**Addendum:** QA-121217 (same session, later) independently confirmed via IG-only channel + `Collaborated=Yes` that Hulu genuinely has **zero collaborated Instagram posts** in the dev account, despite 1,762 total IG posts existing — this corroborates (rather than contradicts) the "1"/"2" collaborator-count zero-results found here. Both tickets' data-scope conclusions are mutually consistent.

## Bugs filed
None.

## Cleanup
Clear All clicked and confirmed (`filters` param absent from URL) before moving to next ticket.

## Skill/KB updates
Queued for `brand-content-filter` v3 — adds the "always verify Clear All actually took effect via the URL, not just visually" lesson.
