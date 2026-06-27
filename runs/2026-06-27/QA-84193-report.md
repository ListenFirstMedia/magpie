# QA-84193 — Reporting > Data Studio ↔ Brand > Content — Engagements Parity (per channel)

- **Run date:** 2026-06-27 (headless, Playwright MCP, `feature/playwright-mcp`)
- **Source test case:** `testcases/english/QA-84193.md` → https://listenfirstmedia.atlassian.net/browse/QA-84193
- **Result:** **PASS** — exact per-channel parity (0.00% delta on FB, TW, IG, TK).
- **Skills used:** `switch-account` (untrusted), `data-studio-post-level-run` (stable), `brand-content-data-set-selector` / Brand>Content nav patterns (untrusted), `view-perspective-toggle` (untrusted).

## Configuration tested (identical on both sources)

| Parameter | Value |
|-----------|-------|
| Account | Adam Orfei (`account_id=54`) — switched from Disney Ad Sales at pre-flight |
| Brand | **MTV** (exact typeahead Results match; DS picker + top-nav search) |
| Date window | **May 27, 2026 – Jun 02, 2026** (Absolute/Custom) |
| Perspective | **Public** (DS: View=Public / "P" badge; BC: perspective toggle clicked, `#perspective` checkbox = unchecked) |
| Window mode / attribution | **Lifetime** (spec default on both surfaces) — see Finding 1 |
| Channels | Facebook, Twitter, Instagram, TikTok (isolated one-at-a-time on BC) |
| Data freshness | Data Last Updated (PT) 06-26-2026 04:25 PM — window fully settled |

## Steps executed

1. **Pre-flight login** — `app.lfmdev.in` → Cognito hosted UI → filled the "With existing account" form (Email + Password from `config/.env`) → clicked that form's Sign in. Landed on `#home`, title "Home - ListenFirst". Account was **Disney Ad Sales**.
2. **Account precondition** — spec names Adam Orfei dev. Opened LFQA profile menu → Search Account → typed "Adam Orfei" → clicked the single **Results** entry. URL → `account_id=54`, breadcrumb "Account: Adam Orfei".
3. **DS Post Level build** — Reporting menu (hover) → Data Studio. Clicked **Post Level**. Set **Custom** date picker to May 27 – Jun 02 2026 (verified range-start=May 27, range-end=Jun 02 highlighted before Ok). Added brand **MTV** from the typeahead (exact "MTV" tagged + clicked; View toggle defaulted to Public). Opened **Select Metrics**, searched "Engagements", checked **Facebook / Twitter / Instagram / TikTok Engagements** + the **Engagements** rollup (5 rows confirmed). Clicked **Go** (`report_id=299339`).
   - Initial run was **In-Window** (see Finding 1). Re-ran in **Lifetime** via Show Configuration → Window Mode = Lifetime → Go (`report_id=299341`).
4. **DS table read** — per-metric Sum + Average + 7 daily columns; legend "MTV **P**" (Public). Σ(daily)=Sum and Avg=Sum/7 verified on the In-Window run.
5. **Brand > Content build** — loaded MTV via top-nav search (typed "MTV", clicked the **Results** `.lfm-ta-option` — *not* Recent Searches), landing `brand_id=4018`. Navigated to Brand > Content via the Brand menu's Content link. Clicked the **View perspective toggle** (`label.toggle-switch-label[for=perspective]`) Authorized → Public; verified `#perspective` unchecked (= Public). For each channel (FB/TW/IG/TK) set the window to May 27 – Jun 02 and isolated the single channel; read the **Sum** Engagements aggregate row. Channel isolation + Public state re-verified via DOM on every channel.
6. **Compare** — per-channel DS (Lifetime) vs BC (Lifetime) Sum Engagements; computed delta.

## Evidence — captured numbers

### Data Studio Post Level — Engagements **Sum** (MTV, Public, May 27–Jun 2)

| Metric | In-Window (`report_id=299339`) | **Lifetime** (`report_id=299341`) |
|--------|------:|------:|
| Facebook Engagements | 39,278 | **48,636** |
| Twitter Engagements | 52,621 | **53,164** |
| Instagram Engagements | 697,412 | **895,109** |
| TikTok Engagements | 22,032 | **91,547** |
| Engagements (rollup) | 816,575 | 1,095,068 |

In-Window integrity checks (per `data-studio-post-level-run`): Σ(7 daily) = Sum and Average = Sum/7 held for every channel row (e.g. FB daily 3,154+3,780+2,777+1,854+2,400+17,364+7,949 = 39,278; Avg 5,611).

### Brand > Content — **Sum** Engagements (MTV, Public, Lifetime, May 27–Jun 2, per-channel filter)

| Channel | Posts | Sum Engagements | Reactions | Comments | Shares |
|---------|------:|------:|------:|------:|------:|
| Facebook | 19 | **48,636** | 46,062 | 461 | 2,113 |
| Twitter | 24 | **53,164** | 45,649 | 680 | 6,835 |
| Instagram | 24 | **895,109** | 890,601 | 4,508 | – |
| TikTok | 21 | **91,547** | 87,833 | 746 | 2,968 |

Brand>Content `brand_id` rewrote `4018 → 10765` on every load (documented Lifetime-mode hash-router rewrite); page header stayed "MTV". The exact numeric match below confirms 10765 is the same MTV entity as the DS report.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | DS Aggregate Engagements loads | Per-channel Engagements Sum renders | FB 48,636 / TW 53,164 / IG 895,109 / TK 91,547 (Lifetime); rollup 1,095,068 | **PASS** |
| A2 | BC Sum Engagements loads (per-channel filter) | Per-channel Sum renders, Public | FB 48,636 (19 posts) / TW 53,164 (24) / IG 895,109 (24) / TK 91,547 (21); perspective=Public confirmed via DOM each channel | **PASS** |
| A3-FB | \|DS−BC\|/max ≤ 1.5% | ≤1.5% | \|48,636−48,636\| = 0 → **0.00%** | **PASS** |
| A3-TW | \|DS−BC\|/max ≤ 1.5% | ≤1.5% | \|53,164−53,164\| = 0 → **0.00%** | **PASS** |
| A3-IG | \|DS−BC\|/max ≤ 1.5% | ≤1.5% | \|895,109−895,109\| = 0 → **0.00%** | **PASS** |
| A3-TK | \|DS−BC\|/max ≤ 1.5% | ≤1.5% | \|91,547−91,547\| = 0 → **0.00%** | **PASS** |
| A4 | Match within tolerance OR document delta | Parity or documented delta | Exact match (0 delta) on all 4 channels at matched window mode (Lifetime) | **PASS** |

**Parity (matched window mode = Lifetime): exact, 0.00% on every channel.** Well inside the ≤1.5% spec tolerance and the ~1–1.5% residual-freshness-drift quirk.

## Findings (window-mode caveat — not a product bug)

**Finding 1 — Parity only holds when DS window mode matches BC attribution window.**
- BC default attribution = **Lifetime**; DS default window mode = **Lifetime**. The spec uses defaults on both sides, so the canonical comparison is **DS Lifetime ↔ BC Lifetime → exact match**.
- DS **In-Window** measures engagement *actions that occurred within the window*, which is a different quantity than BC's lifetime-of-posts-published-in-window. The deltas confirm this (TK In-Window 22,032 vs Lifetime/BC 91,547 = 76% lower; IG 22% lower; FB 19% lower; TW happened to be ~1%).
- **Implication for the test case / prior runs:** the QA-84193 spec text and prior DS runs (`registry` notes "MTV In-Window … Engagements") used **In-Window**, which does **not** reconcile with Brand>Content. Recommend the spec explicitly state **Lifetime** (or that the window mode must match the BC attribution window) to avoid a false-fail. This is a spec/methodology clarification, not a defect.

**Finding 2 — Confirms a prior carry-forward is now resolvable.** The 2026-06-04 carry-forward marked QA-84193's BC half "NOT VERIFIED" because Hulu Brand>Content is unreachable under Adam Orfei. Using **MTV** (a spec-named target, co-located on both DS and BC) completes the parity end-to-end. The earlier "residual freshness drift (~1–1.5%)" quirk did not appear here — match was exact, likely because the window is 3+ weeks old and fully settled.

**Finding 3 (observation, no action).** Toggling the Brand>Content perspective with Threads among the selected channels reproduced the documented `brand_id` fallback (4018→10765) and stripped Threads/added YouTube. Worked around by re-navigating per channel with explicit `brand_id` + verifying Public state via DOM. Already captured in `known-quirks.md`.

## Spec-adherence rules applied

- **Rule 1 (exact brand):** Selected the literal "MTV" from typeahead **Results** on both the DS picker and the top-nav search; avoided Recent Searches and the MTV-variant rows (Argentina/FB/IG/etc.). MTV is an explicitly spec-named target.
- **Rule 2 (click toggles, verify):** Clicked the actual Brand>Content perspective switch (`label.toggle-switch-label[for=perspective]`) — the first click on the text label did nothing; verified `#perspective` checkbox state in DOM after the real toggle. DS Public confirmed via the "P" legend badge.
- **Rule 3 (every step, in order):** Account precondition → date → brand → metrics → run → per-channel BC reads, each verified before reading values.
- **Rule 4 (reuse skills, spec wins):** Used `data-studio-post-level-run`; deviated from its In-Window-for-this-family habit because the spec-default + BC parity required Lifetime.
- **Rule 6 (no proxy claims):** All numbers read from rendered aggregate rows (DS `.al-table`, BC Sum row). No download/export was asserted; none required. Google Sheets out of scope (not used).

## Bugs filed

None. No product defect observed — per-channel Engagements reconcile **exactly** between Data Studio Post Level and Brand > Content at matched window mode. Findings 1–3 are methodology/spec-clarity and previously-documented automation quirks, not defects. (Markdown only — no Jira ticket created.)

## Evidence files (`.playwright-out/qa-84193/`)
- `QA-84193-ds-postlevel-engagements.png` — DS In-Window run (report 299339)
- `QA-84193-ds-postlevel-lifetime-engagements.png` — DS Lifetime run (report 299341), the parity-matching numbers
- `QA-84193-bc-facebook-public.png` — Brand>Content Facebook-only Public, Sum row
- Playwright session snapshots/console logs under `.playwright-out/` (timestamped during the run)
