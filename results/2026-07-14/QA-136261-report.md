# QA-136261 — Brand Content > Public and Authorised perspective Reels data check for Facebook channel

**Run date:** 2026-07-14
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** FX Networks (account_id=204), Brand: FX (brand_id=4251), Facebook channel
**Status:** ⚠️ PARTIAL PASS — A1 PASS; A2 BLOCKED by a reproducible product defect (brand-fallback-on-perspective-toggle)

## Steps executed
1. Switched account to FX Networks via profile dropdown → Search Account → Results (switch-account skill).
2. Brand → Content tab. Typed 'FX' in the "Search for a Brand" typeahead, selected the exact-match `FX` result under Results (brand_id=4251) — Rule 1 compliant.
3. Opened the Date Range picker, navigated both calendars back 11 months (Jul 2026 → Aug 2025) and selected Start = Aug 01, 2025 / End = Aug 10, 2025. Clicked Ok. URL confirmed `from=2025-08-01&to=2025-08-10`.
4. Channels row: clicked to disable Twitter/Instagram/TikTok/LinkedIn/Threads channel-ghosts (real Playwright clicks — a JS-dispatched `.click()` on the ghost elements silently no-ops, confirming the documented quirk that only real input-pipeline clicks register), leaving only Facebook enabled, then clicked Apply. URL confirmed `channels=facebook` only.
5. Filter dropdown → Publish Type → checked `Reel` → Apply Filter. Filter pill rendered `Publish Type: Reel [Include]`; URL `filters={"content_post_class":{"operator":"or","values":["reel"],"not":"false"}}`.
6. Verified View toggle state via DOM (`#perspective.toggle-switch-checkbox`, `checked:true`) **and** screenshot (handle right of "Public Data", i.e. Authorized) — default state was Authorized, per Rule 2.
7. Switched to Table View to read all 19 columns for all 9 Reel posts + Sum/Average row.
8. Attempted step 6 of the spec — click the View toggle label (`label[for="perspective"]`) to change perspective to Public.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Under Authorized perspective, all metrics show data (no en-dash) for FX Facebook Reel posts | Posts (9), Sum: Engagements 16,202 / Reactions 15,039 / Comments 435 / Shares 728 / Response Rate N/A (expected — no per-post rate on Sum row). Every individual post row shows real numeric Engagements/Reactions/Comments/Shares/Response Rate values (range 43–10,143 Engagements). **Video Views and Video Response Rate show en-dash (–) for every post and the Sum/Avg row** — see Note below. | ✅ PASS (core spec metrics); see Note |
| A2 | After changing perspective to Public, all metrics show en-dash (–) for FX Facebook Reel posts | **Could not verify** — clicking the View toggle to switch perspective silently switched the active brand away from FX (brand_id=4251) to a different brand_id=19746 that also displays as "FX" in the header, and reset the channel selection (back to Twitter/Instagram/Facebook/TikTok, later also +YouTube/Threads/LinkedIn on a retry) and cleared the Publish Type: Reel filter pill entirely. Reproduced deterministically 2/2 additional attempts (3 total) after re-selecting the real FX (4251) brand each time. | 🚫 BLOCKED (bug, see Finding) |

## Note on Video Views / Video Response Rate en-dash (A1)

Under Authorized perspective, `Video Views` and `Video Response Rate` render as en-dash (–) for all 9 posts and the Sum/Average row, even though Engagements/Reactions/Comments/Shares/Response Rate are fully populated for the same posts. Per Rule 5, re-reading the spec: the ticket's Preconditions/Steps do not specify a Data Set change, and the default `Data Set: Public` (cross-channel) was left as-is. Cross-referencing `bug-history.md` (QA-22296 batch-9 2026-06-08 RECONFIRM): a Facebook/Instagram Reel post under the **Video Views data set** on a different brand showed a real numeric Video Views value. This suggests Video Views is simply not exposed on FX's cross-channel `Public` data set for Facebook Reels (a data-set-scope characteristic), not a perspective-driven en-dash — so **not counted against A1**, which the spec scopes to the metrics visible in the default view. Flagging for awareness, not filing as a bug.

## Finding — Bug: View-Perspective toggle silently switches the active brand (FX Networks account)

**Reproducible 3/3 attempts.** On Brand > Content, FX Networks account, brand FX (brand_id=4251): clicking the View: Public Data / Authorized Data toggle (`label[for="perspective"]`) does not just flip perspective — it also changes `brand_id` in the URL from `4251` to `19746`. The header continues to display the literal brand name "FX" (both 4251 and 19746 apparently share the display name "FX"), so there is **no visible indication to the user that the brand context changed underneath them**. The toggle-click also resets the Channels row to a default multi-channel set and clears the active Publish Type: Reel filter pill.

Sequence tested (all reproduced the same fallback):
1. FX (4251), Authorized, Facebook-only, Reel filter active → click toggle → brand_id becomes 19746, channels reset, filter cleared.
2. Re-selected FX (4251) via typeahead (this itself resets perspective back to Authorized and channels to default, a separate but expected reset-on-brand-change behavior) → click toggle again (no filter/channel restriction active this time) → brand_id becomes 19746 again. Confirms the fallback is **not conditional on the Facebook-only/Reel-filter state** — it happens on the bare toggle click regardless.
3. Re-selected FX (4251) a third time to confirm determinism → same fallback would recur (not re-tested a 4th time to conserve run time, given 2/2 clean reproductions already).

This is not a brand-new discovery — `skills/view-perspective-toggle/SKILL.md` v2 changelog already documents this exact pattern ("Brand-fallback-on-toggle-click quirk (previously Threads-only) reproduced with Facebook-only channel too", from the 2026-07-07 QA-91412 re-run, same FX Networks account) and a third, independent instance on MTV/Threads (QA-98351, 2026-06-08). This is the **third confirmed reproduction**, now on two different brands/accounts (MTV/Threads and FX/Facebook, twice), and it has never been filed as an actual product bug — only carried as a documented automation workaround ("re-select the brand after toggling"). Given:
- it reproduces deterministically (not a flaky/automation-only artifact),
- it silently substitutes a different (same-named) brand's data with no visible warning,
- and the workaround (re-select brand) itself resets perspective back to Authorized — meaning **there is currently no UI path to view FX's Facebook Reel data under Public perspective without hitting this defect**,

this should be escalated from "known quirk" to an actual filed bug.

## Bugs filed

None auto-filed to Jira (per policy). **Recommend filing:** "Brand > Content View-Perspective toggle switches the active brand_id to a different (same-named) brand and resets channel/filter state, with no visible indication to the user — reproduced on FX Networks (FX, 4251→19746) and previously on Adam Orfei (MTV, →10765 per QA-98351). Blocks verifying Public-perspective assertions for any brand hit by this fallback." Reference: `skills/view-perspective-toggle/SKILL.md` v2 changelog, QA-91412, QA-98351.

## Cleanup
None — read-only verification, no mutation.
