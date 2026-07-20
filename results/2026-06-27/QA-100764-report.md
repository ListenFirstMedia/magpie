# QA-100764 — Brand > Content - Daily Post Analysis Modal - Threads

- **Run date:** 2026-06-27
- **Branch:** feature/playwright-mcp (Playwright MCP track)
- **Environment:** app.lfmdev.in, Account: Adam Orfei (account_id=54), user: lfiqa@listenfirstmedia.com
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-100764
- **Priority:** Critical (P2)
- **Skill reused:** `brand-content-dpa-modal` (+ `brand-channels-threads` for Threads context); brand picker per `brand-content-data-set-selector` / Rule 1.
- **Overall verdict:** **BLOCKED** — test-data gap. The **Threads** channel is not available for the **Max** brand on this account, so Step 3 ("Enable Threads channel only") cannot be performed and assertions A1–A6 (all gated on a Threads post in the Daily Analysis modal) cannot be evaluated. Per spec-adherence Rule 1, no substitute channel was used.

---

## Pre-flight

| Check | Result |
|---|---|
| App reachable | PASS (initial SPA load hung on "Loading…"; re-nav to `#home` triggered Cognito redirect) |
| Cognito "With existing account" login | PASS — filled Email + Password, clicked that form's Sign in |
| Dashboard renders | PASS — landed on `app.lfmdev.in/#home`, title "Home - ListenFirst" |

---

## Steps executed

| # | Spec step | Action taken | Result |
|---|---|---|---|
| 1 | Click Brand in top nav → Content | Hovered the **Brand** top-nav dropdown, clicked **Content** | PASS — landed on `#explore/brand/content` (brand_id=4018 / MTV default) |
| 2 | Click Brand dropdown, type & select 'Max' | Clicked brand name → "Search for a Brand" textarea → typed `Max` → clicked the **exact-match `Max` row** (first entry under Results; idx 0 of 99) | PASS — brand switched to **Max** (brand_id=412264). Header shows "Max". (Rule 1 satisfied — literal "Max" chosen over "MAX Cinema", "Max (2015)", "Max (Band)", etc.) |
| 3 | Enable Threads channel only | Inspected Brand>Content channel selector for Max | **BLOCKED** — no Threads toggle exists for Max (see Finding below) |
| 4 | Click 'Daily Analysis' below first post | — | NOT EXECUTED (depends on Step 3 + a Threads post) |
| 5 | Data Viz dropdown → select 'Area' | — | NOT EXECUTED |
| 6 | Click 'Close' | — | NOT EXECUTED |

---

## Blocking finding — Threads channel not available for Max

The Brand>Content channel selector for the **Max** brand (brand_id=412264, Adam Orfei account) offers only **Facebook, X (Twitter), Instagram, TikTok, YouTube**. There is **no Threads channel toggle**. Two independent signals confirm (Rule 6 — verified against actual outcome, not a single proxy):

1. **UI (authoritative):** The visible channel row contains exactly 5 channel icons + Apply — Facebook / X / Instagram / TikTok / YouTube. No Threads (and no LinkedIn/Pinterest) toggle is rendered. Evidence: `.playwright-out/qa-100764-max-channels-toolbar.png`.
2. **DOM probe:** `document.querySelectorAll('.channel-icon')` visible set = `["Facebook","Twitter","Instagram","TikTok","YouTube"]`. `.channel-ghost` set = facebook / twitter / instagram / tiktok / youtube only. Threads absent.
3. **URL probe:** Navigating `…/content?brand_id=412264&account_id=54&channels=threads` is rewritten by the hash router with the `channels=threads` param **stripped** (final URL carries no Threads channel). Evidence: `.playwright-out/qa-100764-threads-stripped-state.png`.

Because Threads is a hard precondition for every assertion in this case (A1 is literally "the Threads channel icon is displaying…"), the Daily Analysis modal cannot be opened on a Threads post. Per Rule 1, no other channel was substituted; per Rule 3, the remaining ordered steps are not performable.

Most likely cause (per Rule 1 decision tree): **spec drift / test-data gap** — the Max brand on the dev Adam Orfei account has no Threads channel data collection configured. Less likely: the spec assumes Max under a different account where Threads is collected (the case names no specific account — precondition is only "logged in as Max"), so no account switch was indicated.

---

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A1 | 4 | Threads channel icon displays in the right-side corner of the post | Threads channel unavailable for Max; modal not openable on a Threads post | NOT VERIFIED (BLOCKED) |
| A2 | 4 | Graph header & post header show Brand name "Max" | Not reached | NOT VERIFIED (BLOCKED) |
| A3 | 4 | X-axis shows date range; Y-axis shows metric values | Not reached | NOT VERIFIED (BLOCKED) |
| A4 | 4 | No metrics highlighted in the post | Not reached | NOT VERIFIED (BLOCKED) |
| A5 | 5 | Area chart updates in the graph chart | Not reached | NOT VERIFIED (BLOCKED) |
| A6 | 6 | The window closes | Not reached | NOT VERIFIED (BLOCKED) |

---

## Evidence

- Brand picker open with "Search for a Brand" typeahead: `.playwright-out/qa-100764-after-brandname-click.png`
- Max channel selector (5 channels, no Threads): `.playwright-out/qa-100764-max-channels-toolbar.png`
- `channels=threads` stripped after URL nav: `.playwright-out/qa-100764-threads-stripped-state.png`
- Typeahead Results: exact `Max` was option 0 of 99 (followed by "MAX Cinema", "MAX-BONE", "Max & Erma's", "Max (2015)", "Max (Band)", …). brand_id resolved to **412264**.
- Post count under default channels (Jun 19–25 2026, Lifetime, Public): **Posts (0)** — "There is no data available." (recent-window emptiness; not the blocker — the blocker is the absent Threads channel).
- Data Last Updated (PT): 06-26-2026 04:25 PM.

---

## Bugs filed

> Markdown only — no Jira ticket created (per run policy).

**Candidate test-data gap (not auto-filed as a product defect):**

- **QA-100764 cannot run as written — Threads channel missing for Max.** The Max brand (brand_id=412264) on the Adam Orfei dev account exposes only Facebook / X / Instagram / TikTok / YouTube on Brand>Content; the case requires a Threads channel. Recommend LFIQA/product confirm one of:
  - (a) Threads data collection should be enabled for Max on this account (data-setup gap), **or**
  - (b) the case should name the specific account where Max has Threads (precondition fix), **or**
  - (c) the case brand/channel pairing is stale and the spec should be updated.
  - Until resolved, this case is **BLOCKED on test-data**, not a functional defect in the Daily Analysis modal. The DPA modal feature itself was **not** exercised this run (out of spec to test it on a non-Threads channel).

---

## Spec-adherence checklist

- Rule 1 (no brand substitution): followed — typed `Max`, clicked the literal exact-match Results row; did **not** pick a "Max …" variant. Likewise did **not** substitute another channel for the unavailable Threads.
- Rule 2/Rule 3 (explicit UI, every step in order): Steps 1–2 done via real UI clicks/typing; Step 3 blocked by missing UI control; downstream steps correctly not faked.
- Rule 6 (no proxy-only conclusions): the "Threads unavailable" conclusion rests on the rendered UI + DOM + URL behavior, with screenshots — not a single signal.
