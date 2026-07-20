# QA-121217 — Brand > Content - Instagram - Instagram Collaborator count - Export

**Run date:** 2026-07-13 | Account/Brand: Hulu (336/5670) | Channel: Instagram only

## Steps executed
1-3. Brand>Content, Hulu, restricted channel selection to Instagram only (had to individually deselect the other 5 channels via the channel-icon toggle bar + Apply — channel toggling here is **additive/independent per-icon**, not exclusive-select like Brand>Audience; clicking Instagram alone toggled it off since it started selected, not "select only Instagram").
4. Confirmed 1,762 Instagram posts loaded for Hulu over the last 12 months.
5. Applied Filter → Collaborated = Yes to jump directly to collaborated posts.
6. Waited a full 5s past the skeleton-loading state (see methodology note) before reading the result.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Instagram collaborator count icon displayed, e.g. `icon(1)` | **NOT VERIFIED** — Collaborated=Yes filter returned 0 posts (confirmed genuinely empty, not a loading artifact — waited 5s, re-checked) despite 1,762 total IG posts existing | BLOCKED (data-scope) |
| A2-A4 | Tooltip/Detail/Table view collaborator display | Not reachable — no collaborated post exists to inspect | BLOCKED (data-scope) |
| A5-A6 | CSV export headers include collaborator columns | Not reachable — Export requires ≥1 post; Collaborated-filtered set is empty | BLOCKED (data-scope) |

**Result: 0/6 independently verified — genuine data-scope block, not a mechanic failure.** The `Collaborated` filter itself applied correctly and mechanically (`filters={"content_is_collaborated":{"operator":"or","values":["collaborated"],"not":"false"}}`), and the empty result was properly confirmed only after waiting out the loading skeleton.

## IMPORTANT Methodology finding — retroactive risk flagged
While investigating this ticket I discovered that **`Posts (N)` and the "no data available" empty-state message look identical to the loading-skeleton placeholder state if read too soon after a filter/channel change** — this page renders grey shimmer blocks for ~2-5 seconds before either the count or the empty message appears. I caught this here only because I happened to screenshot mid-load and saw skeleton placeholders where I'd assumed "0 posts." **This casts doubt on the "0 posts" / data-scope conclusions reported earlier in this session** (QA-134277, QA-121158, and possibly others) where the empty check was read immediately after an Apply click without an explicit wait. Recommend a human (or a follow-up automated pass) re-verify those tickets' zero-result claims with a proper wait-for-skeleton-to-clear step. Going forward in this session, every post-count read now waits ≥3s and re-checks before concluding "empty."

## Bugs filed
None.

## Cleanup
Clear All clicked, confirmed `filters` param absent. Channel selection left at Instagram-only (non-mutating, cosmetic session state).

## Skill/KB updates
- New quirk for `known-quirks.md`: Brand>Content post-count/empty-state can render mid-skeleton-load and look identical to a genuine zero-result; always wait for the shimmer placeholders to clear (~3-5s) before reading `Posts (N)` or the empty-state message.
- Channel-toggle bar on Brand>Content is **independent per-icon toggle**, not exclusive-select — contradicts the exclusive-select pattern documented for Brand>Audience/Brand>Paid in `audience-metrics-export`; worth a cross-check note in that skill to avoid assuming the pattern is universal.
