cl# QA-127567 — Settings – Data Collection – Ad Account Level Status

**Run date:** 2026-07-08
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Skill used:** [data-collection-ad-account-status](../../skills/data-collection-ad-account-status/SKILL.md) v1 (reused as-is)
**Account:** Adam Orfei · **Brand:** Scorpion · **Channel:** Facebook · **Page:** Scorpion

## Steps executed

1. Switched account LFQA → Adam Orfei.
2. Settings (hover) → Data Collection.
3. Searched "Scorpion" in My Brands, clicked the row.
4. Clicked Facebook in the Channels column (1 Page).
5. Clicked the Scorpion page row.
6. Data Collection Summary table rendered; clicked the expand chevron on the "Facebook & Instagram Ads (Authorized)" row (the ad-account-bearing feed).

## Results

- Parent row "Facebook & Instagram Ads (Authorized)": Start Aug 18, 2014 · Last Collection Apr 30, 2018 · **Status cell is empty** (no text at all).
- Expanded sub-table, header "Ad Account", 2 rows:
  - `act_246150802260022` — Feb 12, 2017 → Feb 18, 2017 — **Not Collecting**
  - `act_104851869627522` — Aug 18, 2014 → Apr 30, 2018 — **Not Collecting**

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6 | When only ONE Ad Account is connected, the overall status reflects that Ad Account's status | **NOT TESTABLE on this brand** — Scorpion/Facebook has exactly 2 Ad Accounts, no single-AA data feed available to exercise this path | N/A (see Problems) |
| A2 | 6 | When MULTIPLE Ad Accounts are connected, the overall summary status remains empty | Parent row's Status cell is empty with 2 connected Ad Accounts | PASS |
| A3 | 6 | Status is shown only for each Ad Account ID row, no separate overall data-feed status | Confirmed — only the 2 child `act_*` rows carry a Status value ("Not Collecting" each); the parent row has none | PASS |

**Result: PASS 2/3 assertions verifiable; A1 blocked on test-data availability (same limitation as the original 2026-05-13 run of this exact case)**

## Problems / deviations

1. **A1 could not be exercised** — this requires a brand/page/channel combination with exactly ONE connected Ad Account on an ad-account-bearing data feed. Scorpion (the brand named in the spec) has 2 Ad Accounts on Facebook & Instagram Ads, same as the original skill-authoring run. I did not substitute a different brand (Rule 1 — the spec explicitly names Scorpion), so this assertion remains unverified pending LFIQA identifying a single-AA test brand, or product/QA accepting the 2-AA verification as sufficient coverage for this ticket.
2. Page navigation to each drill-down level (`brand → channel → page`) needed an explicit 2-3 second wait after each click before the summary table populated — the SPA doesn't show a loading spinner during this transition, so a fixed wait was used rather than a `wait_for` on visible text (nothing distinguishing appears until the full table renders). Automation-only note, not a product issue.

## Skill maintenance

- `data-collection-ad-account-status` pass_streak +1 (2026-07-08, same Scorpion/Facebook/Scorpion-page 2-AA case as the 2026-05-13 origin run — reconfirmed with byte-identical results: both act_ IDs, both "Not Collecting", same date ranges). Given this is now 2 separate-day passes, flag as **stable-promotion candidate** pending one more separate-day run.

## Bugs filed

None.
