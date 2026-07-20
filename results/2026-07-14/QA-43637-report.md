# QA-43637 — Brand Content > Facebook Only: Reels Basic Early Access data set - All View - jMeter

**Run date:** 2026-07-14
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Viacom (account_id=181), Brand: MTV (brand_id=4018), Data Set: Facebook Only: Reactions, Publish Type: Reel filter, Last 12 Months
**Status:** ✅ PASS (5/5 assertions)

## Steps executed
1. MTV brand already active from prior case (session reuse).
2. Data Set dropdown → selected "Facebook Only: Reactions" under Channel-Specific Metrics.
3. Verified Facebook is the only enabled channel-ghost, others carry `disabled` class (data set enforces this, not just carried-over state from the prior case).
4. Filter → Publish Type → Reel → Apply Filter.
5. Switched to Detail View, then Table View (List layout was already the default for this data set) to inspect columns/aggregates.
6. Sampled 200 of 279 filtered rows' Publish Type column.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 (step 5) | Facebook channel only enabled, others disabled by default | `.channel-ghost` classes confirm: `facebook enabled`; all 7 others carry `disabled warning fa-stack` (genuinely disabled, not just toggled) | ✅ PASS |
| A2 (6a) | Reels post only displays | 0/200 sampled rows have `PublishType` ≠ "Reel" | ✅ PASS |
| A3 (6b) | Aggregate table displays Engagements, Reactions, Likes, Loves, Hahas, Wows, Sads, Angries | All 8 present in Sum/Average row (Sum: 3,771,566 / 3,546,554 / 2,666,624 / 816,910 / 50,908 / 8,989 / 1,697 / 1,426) | ✅ PASS |
| A4 (7) | Same metrics updated in Detail view | Detail view for post 1 shows Engagements/Reactions (with Likes/Loves/Hahas/Wows/Sads/Angries/Others nested under Reactions) — same metric set | ✅ PASS |
| A5 (8) | Table View columns: Rank, Date, Channel, Author, Type, Live, Publish Type, Paid, Sponsor, Text, Engagements, Reactions, Likes, Loves, Hahas, Wows, Sads, Angries, Others, Actions | All present except the spec's "Author" column, which renders as **"Brand"** in this build (same position/semantic — shows the post's brand/author name). Extra column present but not in spec: "Collaborated". | ✅ PASS (with naming note) |

## Note
The spec lists a column named "Author"; the actual UI renders this column as **"Brand"** (consistent with every other Brand>Content table in this app — same behavior observed in QA-35084's Reels data set). This reads as spec/copy drift (the ticket may predate a column rename) rather than a functional defect — the column shows the expected per-post brand/author name in the expected position. Not filed as a bug.

## Bugs filed
None.

## Cleanup
None — read-only verification, no mutation.

## Notes
Ticket title references "jMeter" (see also QA-73379) — a load-testing tool name likely carried over from an unrelated naming convention; executed as a standard UI verification, not a load test.
