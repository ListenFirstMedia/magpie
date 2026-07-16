# QA-106221 — Settings > Custom Data Sets: Edit functionality

- **Run date:** 2026-07-07
- **Branch / track:** `feature/playwright-mcp` (Playwright MCP, real Chrome, programmatic Cognito login)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-106221
- **Priority:** Blocker (P1) · Jira automation flag: **Not Recommended** (drag-and-drop in step 4)
- **Skill reused:** `settings-custom-data-sets` v3 (edit flow); this run **found a keyboard binding change** requiring a v4 update (see below)
- **Account:** Adam Orfei (account_id=54)
- **Depends on:** QA-106218 (a CDS with a known initial order ending in Impressions@7)
- **Result:** **PASS — 5/5 assertions** (A1–A5)

---

## Pre-flight

| Check | Result |
|-------|--------|
| App reachable | ✅ `https://app.lfmdev.in` → redirected to Cognito hosted UI |
| Login (existing-account form, `lfiqa@…`) | ✅ filled "With existing account" Email+Password, clicked that form's Sign in → oauth_callback → `#home`, title "Home - ListenFirst" |
| Dashboard renders | ✅ Home rendered, "Data Last Updated (PT): 07-06-2026 04:29 PM", Account: Adam Orfei |
| Account precondition (Adam Orfei) | ✅ Custom Data Sets page loaded directly under "Account: Adam Orfei" — no Hulu-drift this run |

---

## Precondition setup (dependency QA-106218)

At run start, Adam Orfei had 9 existing Custom Data Sets (ABcd, AbCd, Main Test 1, Test, Test 3 Dupes, Test Data 123, create-103, performance test, performance test 2) — none with the spec-required initial order (ends with Impressions at #7). Per the skill's documented precondition-recreate pattern, recreated the exact QA-106218 CDS via the Create flow:

- **Name:** `QA-106221-precondition-20260707`
- **Initial order (verified before edit):** `Engagements, Reactions, Response Rate, Comments, Shares, Engagement Rate, Impressions` — Impressions at #7, same DCR keys as prior runs (`lfm.content.responses_mixed`, `reactions_mixed`, `response_rate_mixed`, `replies_mixed`, `reshares_mixed`, `content_engagement_rate_mixed`, `impressions_v7_v2`).
- This created the account's 10th CDS — hit the account's documented 10-set cap; "Create a Custom Data Set" button correctly greyed out at 10/10.

---

## Steps executed

| # | Step | Action taken | Outcome |
|---|------|--------------|---------|
| — | Setup | Create flow → built `QA-106221-precondition-20260707` with the QA-106218 initial order | ✅ row present, order ends Impressions@7 |
| 1 | Hover 'Settings' top nav | Settings dropdown → 13 items incl. Custom Data Sets | ✅ |
| 2 | Click 'Custom Data Sets' | On `/#custom-data-sets` | ✅ |
| 3 | Actions → Edit; note current order | Actions menu = Edit/Delete/Duplicate → Edit → `/#custom-data-sets/edit?...&report_id=248` | ✅ header "Edit Custom Data Set"; initial order captured |
| 4 | Drag Engagements to 3rd position | Keyboard-accessible DnD — **see Problem #1 below**: `j`/`k` keys, not ArrowDown/ArrowUp | ✅ Engagements now #3; live region: "You have dropped the item. It has moved from position 1 to 3." |
| 5 | Delete #7 metric (Impressions) | Clicked the Remove (trash) button on the Impressions row | ✅ Impressions removed; "Selected Metrics (6)" |
| 6 | Search "Views", select under Twitter | Typed `Views` in Search Metric Name; tree filtered to Views under Twitter/Instagram/Threads; clicked the **Twitter** group's Views checkbox | ✅ Views added as #7, key `twitter.post.public_impressions`, single Twitter icon |
| 7 | Click Save | Clicked Save | ✅ navigated to listing; row persisted with final order |
| — | Post-test cleanup (not in spec) | Actions → Delete → confirm modal → Ok, verified gone via F5 | ✅ transient CDS removed |

---

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Page header reads exactly `Edit Custom Data Set` | `<h1>Edit Custom Data Set</h1>` | ✅ PASS |
| A2 | 4 | After the drag, Engagements has rank #3 | Position input + row order = `3: Engagements`; live-region: "moved from position 1 to 3" | ✅ PASS |
| A3 | 5 | Deleted #7 (Impressions) no longer in Selected Metrics table | Impressions absent; "Selected Metrics (6)" = Reactions, Response Rate, Engagements, Comments, Shares, Engagement Rate | ✅ PASS |
| A4 | 6 | Only the Twitter channel icon displayed under the new "Views" metric | icons = `["twitter supported"]` only; key `twitter.post.public_impressions` | ✅ PASS |
| A5 | 7 | Final order exactly: `Reactions, Response Rate, Engagements, Comments, Shares, Engagement Rate, Views` | Listing row after Save = exact match | ✅ PASS |

---

## Problems encountered during this run

### Problem #1 (workaround found, not a bug) — Keyboard DnD binding changed from Arrow keys to `j`/`k`

The 2026-06-27 run of this same skill documented the reorder sequence as `Space → ArrowDown ×2 → Space`. This run, pressing `ArrowDown` did nothing — the live region never updated. Inspecting the actual `aria-live` region text after lifting the row revealed the product now prompts:

> "You have lifted item at position 1. Press **j** to move down, **k** to move up**, space bar to drop and escape to cancel.**"

Switched to `j`/`k` per the on-page instruction and the reorder worked exactly as expected (live region confirmed each step). **This is a UI/keybinding change since the last run, not a defect** — the accessible DnD affordance still works, just with different keys. Skill updated to v4 to reflect this (see Skill changes below). Recommend always reading the live-region text after "lift" before sending movement keys, rather than hardcoding Arrow keys.

### Problem #2 (harder to diagnose) — Playwright's accessibility snapshot did not surface `aria-roledescription` on the draggable rows

The Selected Metrics `<tr>` elements carry `tabindex="0"` and `aria-roledescription="You are currently at a draggable item at position N..."` (confirmed via `browser_evaluate` reading the live DOM), but this attribute never appeared in the Playwright MCP `browser_snapshot` accessibility tree — the rows rendered as plain unlabeled `row` nodes. Clicking the inner metric-name `<span>` (a natural first attempt) does **not** move keyboard focus to the parent `<tr>`, so `Space` had no effect until I explicitly called `.focus()` on the row via `browser_evaluate`. Net effect: the documented "click the row, press Space" approach from the prior report doesn't work as literally described under Playwright MCP — it needs a JS-level `.focus()` call first. Not a product bug; a gap in the automation approach that cost several extra round-trips to diagnose.

### Problem #3 (unresolved anomaly, flagged not filed as a bug) — Two unrelated Custom Data Sets vanished from the account during this run

Before this run, Adam Orfei had 9 Custom Data Sets, including two near-duplicate entries **"ABcd"** and **"AbCd"** (same creator "Kumar Keshav Kashyap", both single-metric "Engagements", created the same day). After creating my precondition CDS (→10 total, confirmed present) and then editing + saving it, the listing dropped to 8 rows — **both "ABcd" and "AbCd" were gone**, confirmed persistent after a hard F5 reload (not a stale-cache artifact). I did not touch, reference, or interact with either of those rows at any point in this session.

I could not establish a network-level root cause — Playwright's network-request buffer had already rotated past the relevant timeframe by the time I investigated, and no console errors/logs mention those data sets or a delete call. Two plausible explanations:
1. **A genuine backend defect** in the Edit/Save flow for one CDS silently removing unrelated CDS records (severity would be high if true — silent data loss).
2. **Benign/unrelated** — this Adam Orfei account is shared across the whole QA team (creators on the list include Kumar Keshav Kashyap, Phil Cutler, James Butler, Sasikumar Drylogics, LFQA Testing), and another tester may have deleted their own scratch data (`ABcd`/`AbCd` look exactly like scratch/duplicate-test artifacts) concurrently in a separate session.

Per spec-adherence Rule 5/6 (verify before claiming, re-check alternate explanations), **this is not filed as a confirmed bug** — logged here as an open anomaly for a human to check (e.g., ask Kumar Keshav Kashyap directly, or check server-side audit/delete logs for `custom_data_set` deletes on account_id=54 around 07:12–07:19 UTC on 2026-07-07). If it recurs on a future run with no other tester active, escalate to a filed bug immediately.

---

## Evidence

- **A1 header:** `Edit Custom Data Set` (sole `<h1>` in main); edit URL `…/#custom-data-sets/edit?account_id=54&…&report_id=248`.
- **Initial order at Edit open:** `1 Engagements / 2 Reactions / 3 Response Rate / 4 Comments / 5 Shares / 6 Engagement Rate / 7 Impressions`.
- **Lift/move live-region text (verbatim):** "You have lifted item at position 1. Press j to move down, k to move up, space bar to drop and escape to cancel." → "You have moved the lifted item down to position 2..." → position 3 → drop: "You have dropped the item. It has moved from position 1 to 3."
- **After delete (A3):** `Selected Metrics (6)` — Reactions, Response Rate, Engagements, Comments, Shares, Engagement Rate.
- **Views metric (A4):** name `Views`, DCR key `twitter.post.public_impressions`, icons = `["twitter supported"]` only.
- **Final persisted order (A5):** `Reactions, Response Rate, Engagements, Comments, Shares, Engagement Rate, Views` — exact spec match.
- **Delete confirmation (cleanup):** `Are you absolutely sure you want to delete your data set "QA-106221-precondition-20260707"? Click "Ok" to continue.` — row removed after Ok, confirmed absent after F5.
- **Anomaly evidence (Problem #3):** pre-run listing (9 rows, incl. ABcd/AbCd) vs post-Save listing (8 rows, ABcd/AbCd both absent), confirmed persistent via hard F5 reload.

---

## Notes / Observations

- **No success toast on Save** — consistent with prior runs; Save navigates straight to the listing with the persisted order.
- **Checkbox / remove interactions accepted Playwright trusted clicks directly** — no workaround needed.
- **Account context held on the Settings surface this run** — no Hulu drift.
- **Mutation:** test created 1 CDS (precondition) and deleted it after Save. Net account CDS count: 9 → 7 (down 2, entirely attributable to the ABcd/AbCd anomaly in Problem #3, not to any test mutation of mine).

---

## Bugs filed

> Markdown only — no Jira tickets created.

**None confirmed.** All 5 spec assertions (A1–A5) pass — the edit flow behaves exactly as the spec describes. Problem #3 above is logged as an **open anomaly**, not a filed bug, pending human investigation (insufficient evidence to rule out a benign concurrent-tester explanation).

## Skill changes made

- `skills/settings-custom-data-sets/SKILL.md` bumped to **v4**: documents the `j`/`k` keyboard-DnD binding (superseding the v3 ArrowDown/ArrowUp instruction, which no longer works) and the Playwright-specific `.focus()`-before-`Space` requirement for the draggable row.
