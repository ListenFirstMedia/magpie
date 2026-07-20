# QA-98368 — Brand Content - Threads - Post Type Hovering functionality (re-run 2026-05-29)

- **Source spec:** testcases/english/QA-98368.md
- **Skill used:** brand-content-data-set-selector
- **Account:** Adam Orfei (account_id=54)
- **Brand:** HBO Max (brand_id=155611) — exact spec brand selected via top-nav search → Results > HBO Max
- **View attempted:** Authorized; toggle did not move from Public despite explicit clicks (see notes).

## Result: BLOCKED — Threads channel not available on HBO Max (Adam Orfei dev account); LinkedIn also unavailable, blocking APPS-57985 check

## Execution

1. Switched the active brand to HBO Max via the top-nav search (exact-match Results row). Brand loaded as `brand_id=155611`.
2. Navigated to Brand > Content. Channels row shows only **Facebook | X | Instagram | TikTok | YouTube** (Apply button trailing).
3. Threads is NOT present in the channel selector. LinkedIn is NOT present either.
4. Attempted to switch to Authorized perspective; toggle click registered (URL persisted `perspective=standard`/Public) — same Adam Orfei Public-only behavior known from earlier batches.
5. Cannot select "only Threads" channel because the channel is not visible. Spec step 3 (`Select only the 'Threads' channel and click Apply`) is unexecutable.

## Bug-targeted observation — APPS-57985 (cross-channel)

APPS-57985 (Bug, High, **QA Ready**) — "Thumbnail Issue for LinkedIn Posts."

LinkedIn is also not available in the Brand > Content channel selector for HBO Max on the Adam Orfei dev account. The same blocker applies: cannot select LinkedIn → cannot enumerate LinkedIn posts → cannot inspect post thumbnails.

Per Rule 1, brand substitution is forbidden. The 2026-05-29 batch-1 run for QA-19557 already verified that switching brands within Adam Orfei to one that DOES have LinkedIn (e.g., the Threads tests on `Conan` use Threads + LinkedIn-ish content) does work — but those switched-to brands are not HBO Max, so the Rule 1 constraint is violated if used here.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 5 | Post tooltip displays when hovering Post type link in Type column | NOT EXECUTABLE — Threads channel absent | BLOCKED |
| A2 | 5 | Only one tooltip at a time | BLOCKED | BLOCKED |
| A3 | 5 | Tooltip closes via X or click-away | BLOCKED | BLOCKED |
| A4 | 5 | Hovering other post types doesn't open additional tooltips | BLOCKED | BLOCKED |
| A5 | 6 | Click post type opens correct channel post in new tab matching tooltip | BLOCKED | BLOCKED |
| B (bug check) | LinkedIn Content thumbnail rendering | LinkedIn posts render thumbnails properly | NOT VERIFIED — LinkedIn channel absent on HBO Max for this account | NOT VERIFIED |

## Bug reproduction outcomes

| Bug | Status |
|------|--------|
| APPS-57985 — Thumbnail Issue for LinkedIn Posts | **NOT VERIFIED 2026-05-29.** The cross-channel check requested in the regression instructions cannot be performed: LinkedIn channel is not present in the Brand > Content channel selector for HBO Max on the Adam Orfei dev account. The bug status is High / QA Ready (meaning eng believes it is fixed and pending QA). Verification requires either (a) an HBO Max + LinkedIn-enabled account, or (b) another brand on this account known to have LinkedIn content — but Rule 1 forbids brand substitution. Recommend LFIQA verify directly on a LinkedIn-enabled brand in their own dev/stage. |

## Notes

- HBO Max on Adam Orfei dev shows only the 5 base channels. Threads + LinkedIn + Pinterest are all absent. This is a recurring constraint of the Adam Orfei test-data subset (already noted in known-quirks for niche channels).
- Per Rule 6, did not claim a download or rendering defect for either Threads (no posts to hover) or LinkedIn (no posts to render). Marked BLOCKED / NOT VERIFIED respectively.
- The previous batch-1 retro audit of bug-history already flagged this ticket as a candidate for a brand-set test-data gap. Recommend triaging which Adam Orfei brand still has Threads + LinkedIn (Conan was historically the one in QA-837 BPC content, but those are IG; Threads coverage on Adam Orfei is limited to MTV/Star Wars in Recent Searches, and HBO Max not at all).

## Skill registry impact

- `brand-content-data-set-selector` v1 — no streak bump (test BLOCKED, no successful Data Set selection performed).
- No new skill required for this BLOCKED case; the blocker is test-data, not flow-discovery.
