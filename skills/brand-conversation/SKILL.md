---
name: brand-conversation
version: 1
last_verified: 2026-06-08
last_passed_run: 2026-06-08
trust: untrusted
pass_streak: 2
preconditions: [account-context, brand-selected]
postconditions: [conversation-tab-rendered]
inputs: [brand_id, account_id]
outputs: [conversation_tiles, click_here_link_destination]
related_pages: ["/#explore/brand/conversation", "/#explore/listening/conversation"]
---

# Brand > Conversation tab — Basic view + redirect behavior

End-to-end read of the Brand > Conversation tab. Documents the LFMP-31800 "Click here to load Tweets" misroute, the Data Last Updated timestamp parity with other Brand surfaces, and the silent redirect on accounts/brands without Conversation enabled.

Used by:
- **QA-6315** (Brand > Conversation - Basic view) — LFMP-31800 REPRODUCED on MTV / Adam Orfei.
- **QA-134636** (Listening "Data Last Updated" timestamp) — A1 PASS on Brand>Insights timestamp; A2 INCONCLUSIVE because Listening surface not enabled on Adam Orfei. Documented as a Conversation-vs-Listening cousin flow.

## Key UI structure

Brand > Conversation page is the last brand-sub-tab (after Optimization / Partnerships / Paid). Default landing perspective is **Authorized Data** (`perspective=extended`). Default channels = `twitter + instagram`.

Header row (top-right):
- Help / Guide / Info icons: `.fa-question-square` + `.fa-question-circle` + `.fa-info-circle`.
- **Data Last Updated (PT)** timestamp in `MM-DD-YYYY HH:MM AM/PM PT` format (same value as the other Brand surfaces — see `brand-navigation-timestamp` skill).

Body in two stacked sections:
- **Conversation Overview** — Total Conversation Volume + Sources + Hashtags tiles.
- **Conversation Analysis** — same metric set rendered with the (Daily) variant; per-day chart per tile.

Filter dropdown sits below the Conversation Analysis tile.

## Steps

### Step 1 — Navigate to Brand > Conversation
- **Action:** Direct URL `https://app.lfmdev.in/#explore/brand/conversation?brand_id={brand_id}&account_id={account_id}` is the fastest path; the top-nav route also works.
- **Assertion:** URL stays on `/conversation` (does not redirect to `/insights`). Page renders with the three Help/Guide/Info icons in the top-right.
  - If the account or brand does NOT have Conversation enabled, the URL redirects silently to `#explore/brand/insights` (per QA-134636 carry-forward) — that's the correct fallback, not a bug.

### Step 2 — Verify sub-nav placement
- **Assertion:** `Conversation` is the last item in the brand sub-nav, after `Paid`.

### Step 3 — Verify channel + perspective defaults
- **Default channels:** twitter + instagram (other channels available via the channel row, with `Apply` button greyed until a change is pending).
- **Default perspective:** Authorized Data (`perspective=extended` in URL).
- **Assertion:** `.channel-icon.twitter` + `.channel-icon.instagram` both rendered in the View-by-channels row. Perspective labels show both `Public Data` and `Authorized Data` (per `view-perspective-toggle` skill — never trust URL param alone; visually confirm).

### Step 4 — Read Data Last Updated timestamp
- **Action:** Read top-right header text via zoomed screenshot.
- **Expected format:** `Data Last Updated (PT): MM-DD-YYYY HH:MM AM/PM PT`.
- **Cross-source consistency:** value should match Brand > Insights / Audience / Content / Channels / Stories / Optimization timestamps in the same session (per `brand-navigation-timestamp`).

### Step 5 — Verify Conversation Overview tile order
- **Assertion:** Row order:
  1. Conversation Volume + Conversation Volume (Daily)
  2. Sources + Sources (Daily)
  3. Hashtags + Hashtags (Daily)
  4. Analyzed Posts (N) + Sort filter

### Step 6 — Verify Conversation Analysis tile presence
- **Assertion:** Below Overview, the Conversation Analysis section is present. Below it, the Filter dropdown is rendered.

### Step 7 — Verify Export dropdown + absence of Data Set dropdown
- **Assertion:** Export button present in toolbar. No `Data Set` dropdown (this surface has no Custom Data Set selector unlike Brand>Content).

### Step 8 — LFMP-31800 probe — "Click here to load Tweets" link
- **Where:** Appears in the empty Twitter region of the Conversation Volume tile when Twitter has no data for the window.
- **DOM target:** `a.link-to-feature` with text `Click here to load Tweets`.
- **Probe:**
  ```javascript
  const link = document.querySelector('a.link-to-feature');
  // expected behavior: clicking should re-render the Twitter region with tweets in-place
  // actual behavior (LFMP-31800 REPRODUCED): clicking navigates to #explore/listening/conversation
  // and strips brand_id/account_id from the URL
  ```
- **Assertion:** Read `link.href`. Expected: hooks into the local Conversation surface (e.g. preserves `brand_id`/`account_id`). Actual under LFMP-31800: `https://app.lfmdev.in/#explore/listening/conversation` (NO brand context).
- **Verdict if `href` is the bare Listening URL:** LFMP-31800 REPRODUCED — file as the known bug, do not navigate via the click in subsequent assertions.

## Failure signatures

| Signature | Interpretation | Action |
|---|---|---|
| URL redirects to `#explore/brand/insights` immediately | Account/brand has no Conversation surface enabled (e.g., Adam Orfei + non-Conversation brand) | Not a bug — log as gating-by-account |
| `Click here to load Tweets` link href is `…/listening/conversation` (no brand context) | LFMP-31800 REPRODUCED | File against the known bug |
| Data Last Updated timestamp drifts from other Brand surfaces in same session | Cross-surface consistency regression | File bug — cross-reference `brand-navigation-timestamp` |
| Help / Guide / Info icons missing from top-right | UI regression | File bug |
| Conversation sub-nav item missing | Account configuration issue OR removed surface | Check via direct URL; if URL also redirects, treat as account-gated |
| Conversation Analysis tile missing below Overview | Layout regression | File bug |

## Network expectations

| Endpoint | Method | Expected status | Notes |
|---|---|---|---|
| `/api/.../brand/conversation` | GET | 200 | Renders tile values; 404/302 fallback indicates Conversation not enabled |

## Known bug history

See `knowledge-base/bug-history.md`. Highest-priority open bugs currently tied to this skill's flows:

- LFMP-31800 (Major) — Brand > Conversation > Click here to load Tweets navigates to Listening page instead of loading tweets in-place.     [from QA-6315]

## Changelog

- **v1** (2026-06-08): Initial draft from QA-6315 (LFMP-31800 REPRODUCED) and QA-134636 (Listening fallback + timestamp parity). Documents the Conversation tab landing UI, the `Click here to load Tweets` probe DOM pattern, the silent redirect to Insights on non-Conversation brands, and the cross-source Data Last Updated parity.
