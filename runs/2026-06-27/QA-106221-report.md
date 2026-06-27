# QA-106221 — Settings > Custom Data Sets: Edit functionality

- **Run date:** 2026-06-27
- **Branch / track:** `feature/playwright-mcp` (Playwright MCP, real Chrome, programmatic Cognito login)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-106221
- **Priority:** Blocker (P1) · Jira automation flag: **Not Recommended** (drag-and-drop in step 4)
- **Skill reused:** `settings-custom-data-sets` v2 (list/create/delete flows; edit flow newly exercised here)
- **Account:** Adam Orfei (account_id=54)
- **Depends on:** QA-106218 (a CDS with a known initial order ending in Impressions@7)
- **Result:** **PASS — 5/5 assertions** (A1–A5)

---

## Pre-flight

| Check | Result |
|-------|--------|
| App reachable | ✅ `https://app.lfmdev.in` → redirected to Cognito hosted UI |
| Login (existing-account form, `lfiqa@…`) | ✅ filled "With existing account" Email+Password, clicked that form's Sign in → oauth_callback → `#home`, title "Home - ListenFirst" |
| Dashboard renders | ✅ Home rendered, "Data Last Updated (PT): 06-27-2026 05:05 AM" |
| Account precondition (Adam Orfei) | ✅ Custom Data Sets page loaded under breadcrumb "Account: Adam Orfei" — no account drift this run (contrast QA-106218, which loaded under Hulu and needed a switch) |

---

## Precondition setup (dependency QA-106218)

The QA-106218 run earlier today **created and then deleted** its CDS during post-test cleanup, so no CDS with the spec-required initial order existed on the listing at the start of this run. The 7 pre-existing CDS on Adam Orfei (Hii, Main Test 1, Some new data set name, Test, Test 3 Dupes, performance test, performance test 2) all have different metric orders — none ends with Impressions at position 7.

To satisfy the hard dependency faithfully (Rule 5 — do not improvise), I **recreated the exact QA-106218 CDS** via the Create flow rather than substituting a different CDS:

- **Name:** `QA-106221-precondition-20260627`
- **Initial metrics order (verified before edit):** `Engagements, Reactions, Response Rate, Comments, Shares, Engagement Rate, Impressions` — Impressions at #7, identical to QA-106218's created order (same DCR keys: `responses_mixed`, `reactions_mixed`, `response_rate_mixed`, `replies_v7_v2`, `reshares_v7`, `content_engagement_rate_mixed`, `impressions_v7_v2`).

This is the precise initial order required for the spec's arithmetic to hold (delete #7 = Impressions; final order = A5). The CDS was deleted again as post-test cleanup (see below); net account state change = none.

---

## Steps executed

| # | Step | Action taken | Outcome |
|---|------|--------------|---------|
| — | Setup | Create flow → built `QA-106221-precondition-20260627` with the QA-106218 initial order | ✅ row present, order ends Impressions@7 |
| 1 | Hover 'Settings' top nav | (Reached listing via Settings route) | ✅ listing rendered |
| 2 | Click 'Custom Data Sets' | On `/#custom-data-sets` | ✅ |
| 3 | Actions → Edit; note current order | Clicked Actions (menu = Edit/Delete/Duplicate) → Edit → `/#custom-data-sets/edit?...&report_id=254` | ✅ header "Edit Custom Data Set"; initial order captured |
| 4 | Drag Engagements to 3rd position | Keyboard-accessible DnD: focused Engagements row, Space (lift), ArrowDown ×2, Space (drop) | ✅ Engagements now #3; live region: "You have dropped the item. It has moved from position 1 to 3." |
| 5 | Delete #7 metric (Impressions) | Clicked the Remove (trash) button on the Impressions row | ✅ Impressions removed; header → "Selected Metrics (6)" |
| 6 | Search "Views", select under Twitter | Typed `Views` in Search Metric Name; tree filtered to Views under Twitter/Instagram/Threads; clicked the **Twitter** group's Views checkbox | ✅ Views added as #7, key `twitter.post.public_impressions` |
| 7 | Click Save | Clicked Save | ✅ navigated to listing; row persisted with final order |
| — | Post-test cleanup (not in spec) | Actions → Delete → confirm modal → Ok | ✅ transient CDS removed; account back to 7 CDS |

---

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Page header reads exactly `Edit Custom Data Set` | `<h1>Edit Custom Data Set</h1>` | ✅ PASS |
| A2 | 4 | After the drag, Engagements has rank #3 | Position spinbutton + row order = `3: Engagements`; live-region drop log confirmed pos 1→3 | ✅ PASS |
| A3 | 5 | Deleted #7 (Impressions) no longer in Selected Metrics table | Impressions absent; header "Selected Metrics (6)"; remaining = Reactions, Response Rate, Engagements, Comments, Shares, Engagement Rate | ✅ PASS |
| A4 | 6 | Only the Twitter channel icon displayed under the new "Views" metric | Views row icons = `[twitter supported]` only (1 icon); key `twitter.post.public_impressions` | ✅ PASS |
| A5 | 7 | Final order exactly: `Reactions, Response Rate, Engagements, Comments, Shares, Engagement Rate, Views` | Listing row after Save = `Reactions, Response Rate, Engagements, Comments, Shares, Engagement Rate, Views` | ✅ PASS |

---

## Evidence (exact text / numbers)

- **A1 header:** `Edit Custom Data Set` (sole `<h1>` in main); edit URL `…/#custom-data-sets/edit?account_id=54&…&report_id=254`.
- **Initial order at Edit open (step 3):** `1 Engagements / 2 Reactions / 3 Response Rate / 4 Comments / 5 Shares / 6 Engagement Rate / 7 Impressions`.
- **After drag (A2):** `1 Reactions / 2 Response Rate / 3 Engagements / 4 Comments / 5 Shares / 6 Engagement Rate / 7 Impressions`. Each row is `<tr aria-roledescription="You are currently at a draggable item at position N. Press space bar to lift.">` + a `<input type=number min=1 max=7>` Position cell. Live region (`role=log`): `You have dropped the item. It has moved from position 1 to 3.`
- **After delete (A3):** `Selected Metrics (6)` — `Reactions, Response Rate, Engagements, Comments, Shares, Engagement Rate`. `impressionsPresent = false` in the table.
- **Views metric (A4):** name `Views`, DCR key `twitter.post.public_impressions`, channel icons = `["twitter supported"]` only. (Compare: a "Views" leaf also exists under Instagram and Threads in the filtered tree; the Twitter one was selected per spec.)
- **Final persisted order (A5):** listing cell = `Reactions, Response Rate, Engagements, Comments, Shares, Engagement Rate, Views` — exact spec match.
- **Delete confirmation (cleanup):** `Are you absolutely sure you want to delete your data set "QA-106221-precondition-20260627"? Click "Ok" to continue.` — buttons Cancel + Ok; row removed after Ok; F-listing shows it absent (account back to 7 CDS).

### Screenshots (repo root + `.playwright-out/` session snapshots)
- `QA-106221-01-edit-final-order.png` — Edit page with the 7-row Selected Metrics in final pre-save order (Views #7, Twitter-only icon).
- `QA-106221-02-listing-saved-order.png` — Listing row after Save showing the persisted A5 order.
- Playwright session snapshots: `.playwright-out/page-2026-06-27T13-*.yml`.

---

## Notes / Observations

- **Step 4 drag mechanism — used the product's own keyboard-accessible DnD, not a synthetic mouse drag.** The Selected Metrics rows expose `aria-roledescription="…Press space bar to lift."` (a real keyboard-DnD affordance) plus a Position spinbutton. I performed the reorder with Space → ArrowDown ×2 → Space and confirmed via the page's own live-region announcement ("moved from position 1 to 3"). This is a genuine UI drag interaction the product ships for accessibility — it is the documented fallback for the Jira "Not Recommended" drag note, and it actually moved the item (not a URL/param shortcut). A `<input type=number>` Position field is also available as a second reorder path; not used, but noted for the skill.
- **No success toast on Save.** Clicking Save navigated straight to the listing with the persisted order (same behavior QA-106218 noted for Create — no `successfully created/updated` modal observed). Not a spec assertion.
- **Checkbox / remove interactions accepted Playwright trusted clicks directly** — no `controlled-check-box` focus+Space workaround needed (that workaround was a Chrome-MCP synthetic-event limitation; Playwright dispatches real input events).
- **Account context held on the Settings surface this run** — Custom Data Sets loaded under Adam Orfei without the Hulu drift seen in QA-106218.
- **Mutation:** test created 1 CDS (precondition) and deleted it after Save. Net account CDS count returned to the pre-run value (7).

---

## Bugs filed

> Markdown only — no Jira tickets created.

**None.** All 5 spec assertions (A1–A5) pass. The edit flow — drag-reorder (keyboard DnD), metric delete, search-and-add of a channel-scoped metric, and save-persistence — behaves exactly as the spec describes.

### Carry-forward note (not a bug)
- **Dependency fragility:** QA-106221's precondition is a CDS left behind by QA-106218, but QA-106218's run self-cleans (deletes its CDS), so QA-106221 cannot rely on it existing. This run recreated the exact initial-order CDS as setup. If these two cases are meant to run as a chain, either (a) QA-106218 should skip its cleanup when QA-106221 will follow, or (b) QA-106221 should own its own precondition setup (as done here). Recommend documenting the setup step in a future `custom-data-set-edit` skill.
