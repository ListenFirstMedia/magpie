# QA-100764 — Brand > Content · Daily Post Analysis Modal · Threads

- **Run date:** 2026-07-04
- **Environment:** Playwright MCP track (`feature/playwright-mcp`), headless/unattended, `app.lfmdev.in`
- **Account:** Adam Orfei (account_id=54) — the account where the spec "Max" brand is reachable
- **Brand under test:** Max (brand_id=412264) — exact-match typeahead selection (Rule 1)
- **Verdict:** **BLOCKED — test-data gap: Max has no Threads channel on Brand > Content (step 3 unperformable)**
- **Skill:** `brand-content-dpa-modal` (v1) + `brand-content-data-set-selector` (brand typeahead)

## Summary

The case cannot be executed because **step 3 ("Enable Threads channel only") is impossible on the Max brand** — the Brand > Content channel selector for Max exposes only Facebook / Twitter / Instagram / TikTok / YouTube. There is **no Threads toggle**. Step 3 is the sole precondition for the Daily Post Analysis modal that A1–A6 all evaluate, so none of the assertions can be reached. Per spec-adherence Rules 1/3/5, no other channel was substituted.

This reproduces the documented known-quirk *"Max brand (Adam Orfei dev) has no Threads channel — Brand>Content AND Brand>Insights"* (first observed 2026-06-27 on this same case; re-confirmed 2026-07-01). The revisit trigger (Threads data collection enabled for Max) is **still not met** as of 2026-07-04.

## Steps executed

| # | Spec step | Result |
|---|-----------|--------|
| Pre | Programmatic Cognito login (existing-account form) → `#home` (Adam Orfei, acct 54) | OK — dashboard rendered, title "Home - ListenFirst" |
| 1 | Brand top-nav → Content | OK — landed on Brand > Content (default brand Liquid Death, brand_id=276319) |
| 2 | Brand dropdown → type & select 'Max' | OK — typeahead returned an **exact "Max"** option (first `.lfm-ta-option`); clicked it → brand_id=412264, header shows "Max" |
| 3 | Enable Threads channel only | **BLOCKED** — no Threads toggle exists in the Max channel selector (see evidence) |
| 4 | Click 'Daily Analysis' below first post | Not reached (depends on step 3) |
| 5 | Data Viz dropdown → 'Area' | Not reached |
| 6 | Click 'Close' | Not reached |

## Evidence — no Threads channel on Max

DOM probe of the channel selector (`div.channel-list-toolbar-selector[data-ui-name="channel_selector"]`) returned exactly five enabled channel toggles for Max:

```
channel-ghost facebook  enabled  → i.channel-icon.facebook.fa-facebook-square  [data-channel=facebook]
channel-ghost twitter   enabled  → i.channel-icon.twitter.fa-square-x-twitter  [data-channel=twitter]
channel-ghost instagram enabled  → i.channel-icon.instagram.fa-instagram       [data-channel=instagram]
channel-ghost tiktok    enabled  → i.channel-icon.tiktok.fa-tiktok             [data-channel=tiktok]
channel-icon  youtube   fa-youtube
```

No Threads (and no LinkedIn / Pinterest). The URL after selecting Max carries `channels=twitter&channels=instagram&channels=facebook&channels=tiktok` — Threads is not among the brand's channels.

`fab fa-threads` icons **do** appear elsewhere in the DOM, but only inside `dataset-tooltip__sub-header__…` data-set composition tooltips — **not** in the channel selector. This is exactly the known-quirk signature (channel-selector Threads absent; tooltip Threads icons present).

Contrast: the default brand (Liquid Death, brand_id=276319) on the same page/session **did** expose a Threads channel toggle — confirming the gap is Max-specific test-data, not a broken selector.

Screenshots:
- `.playwright-out/QA-100764/step3-channel-selector-no-threads.png` — the Channels: selector for Max (FB/X/IG/TikTok/YouTube only)
- `.playwright-out/QA-100764/step3-full-max-content.png` — full Brand>Content view for Max

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 4 | Threads channel icon in the right-side corner of the post | DPA modal never reachable — no Threads channel to select | NOT EVALUABLE (blocked) |
| A2 | 4 | Graph header + post header show brand name "Max" | Not reached | NOT EVALUABLE (blocked) |
| A3 | 4 | X-axis = date range, Y-axis = metric values | Not reached | NOT EVALUABLE (blocked) |
| A4 | 4 | No metrics highlighted in the post | Not reached | NOT EVALUABLE (blocked) |
| A5 | 5 | Area chart updates in the graph | Not reached | NOT EVALUABLE (blocked) |
| A6 | 6 | Window closes | Not reached | NOT EVALUABLE (blocked) |

## Why BLOCKED and not FAILED (not a product bug)

- The channel selector, the brand typeahead, and the DPA modal all function correctly (verified the selector renders and the exact "Max" brand resolves).
- The blocker is a **test-data / data-collection gap**: Max does not collect a Threads channel on this account, so the spec's Threads flow has nothing to exercise.
- Substituting a different channel (IG/TikTok/etc.) would violate Rule 1/3 and repeat the QA-91412 wrong-configuration false-positive pattern. No substitution was made.

## Bugs filed

None. This is a test-data gap, not a product defect — consistent with the standing known-quirk. No Jira ticket created (markdown-only per run policy).

**Recommendation to spec owner / LFIQA:** either enable Threads data collection for the Max brand on Adam Orfei (account 54), name the specific account where Max collects Threads, or update the stale brand/channel pairing in QA-100764. Until then this case remains BLOCKED and will re-block on every run.
