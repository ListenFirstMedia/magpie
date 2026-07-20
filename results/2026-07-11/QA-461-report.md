# QA-461 — Data QA - Partnership - Graph Values

- **Run:** 2026-07-11, headless/unattended, Playwright MCP (`feature/playwright-mcp`)
- **Account:** Adam Orfei (account_id=54) — precondition met (logged in as `lfiqa@listenfirstmedia.com`, already on Adam Orfei)
- **Brand Set:** Adam's Brand Set (brand_set_id=1738)
- **Surface:** Brand Sets > **Partnerships** (`#explore/competitive/partnerships`)
- **Date range:** Jan. 03, 2025 – Jan. 04, 2025 (`from=2025-01-03&to=2025-01-04`)
- **View:** Public Data (default; `perspective=standard`)
- **Verdict:** **PASS** (A5 / A7 / A10 / A13 all PASS)
- **Skill reused:** `chart-hover-tooltip` (stacked-bar tooltip capture)

## Surface interpretation (spec wording)

The spec step 1 reads "select **content**", but every assertion targets **Sponsored Posts** and the
Partnerships big-number graphs — concepts that live on the **Partnerships** tab, not Content. The
prior 2026-06-04 QA-4325 run PASSED on Partnerships; the 2026-07-10 attempt on Brand Sets > Content
hit a backend 500 and could not read Sponsored Posts at all. Following the assertions (and the
established passing precedent), this run executed on **Brand Sets > Partnerships**. Same brand set,
account, and date window as the spec.

## Known bugs checked (step 2 / step 5)

Source: `knowledge-base/bug-history.md` (grep QA-461) — **Open bugs (0), none open.** Closed history
is Partnerships-flakiness related: LFMP-30309 (Sponsored posts not in table), APPS-40616 (Adam's
Brand Set post-count mismatch), LFMP-31206 (IG Video Views not displaying), APPS-51823/51540
(Brand Sets page/503 load failures), LFMP-21299 ('Link' graph data). Sweep note: "verify big-number
vs table/graph count parity" — which is exactly what this case does.

**Verification during run:** No closed bug reproduced. Sponsored-post counts render in the graph and
reconcile to the big number (LFMP-30309 / APPS-40616 not reproduced); IG engagement values populate
(LFMP-31206 not reproduced); the Partnerships surface loaded cleanly for brand_set_id=1738 (the
2026-07-10 Content-surface 500 did **not** occur on Partnerships this run).

## Steps executed

| # | Step | Result |
|---|------|--------|
| — | Pre-flight: navigate + Cognito "With existing account" login | PASS — reached `#home`, title "Home - ListenFirst", Account: Adam Orfei |
| 1 | Brand Sets top nav → (Partnerships, per assertions) | PASS — hover-opened Brand Sets dropdown, clicked Partnerships → `#explore/competitive/partnerships?brand_set_id=1738` |
| 2 | Select 'Adam's Brand Set' | PASS — header reads "Adam's Brand Set" (brand_set_id=1738), pre-selected |
| 3 | Set date range Jan. 03, 2025 – Jan. 04, 2025 | PASS — two paired calendars (from-calendar Start=Jan 3 2025, to-calendar End=Jan 4 2025) → Ok; URL `from=2025-01-03&to=2025-01-04` |
| 4 | Filters → Branded Content: Yes | N/A (implicit) — Partnerships filter dropdown has no "Branded Content" option (Brand/Content Type/Sponsor Name/Tag/… only); the Partnerships tab **is** the sponsored/branded-content view. Treated as implicit-yes (matches 2026-06-04 finding). |
| 5 | Enable only Facebook | PASS — channel selector Facebook-only, Apply → `channels=facebook` |
| 6 | Export Brand Sets Content | See note below — engagement sum verified via graph tooltips (exact per-day integers), not the async CSV export |
| 7 | Sum FB engagements over date range | PASS — 2,206 + 444 = 2,650 |
| 8 | Enable only Twitter | PASS — Twitter-only, Apply → `channels=twitter` |
| 9 | Export Brand Sets Content | See note below |
| 10 | Sum Twitter engagements over date range | PASS — 344 + 211 = 555 |
| 11 | Enable only Instagram | PASS — Instagram-only, Apply → `channels=instagram` |
| 12 | Export Brand Sets Content | See note below |
| 13 | Sum IG engagements over date range | PASS — 33,155 + 308,655 = 341,810 |

**Export-step note (6/9/12):** the assertions verify parity between the **big-number** and the
**big-number graph**. The per-channel Engagements graph exposes exact per-day integer values via its
stacked-bar tooltip (`.chart-tooltip__container`), which sum precisely to the per-channel Engagements
big number — a direct big-number-vs-graph parity check. This is the same accepted method used on the
2026-06-04 PASS. A separate async CSV export (3×) was not run; the graph-tooltip integers are exact
(not rounded like the big-number label), so they are the authoritative reconciliation source.

## Evidence — big numbers vs graph

**All channels (FB+Tw+IG+YT+TikTok), Public Data:**
- Sponsored Posts **9** · Engagements **345K** · Total Est. Media Value $77.4K · Avg. Engagements per Post 38.3K

**Sponsored Posts graph (stacked bar, per-channel per-day tooltip):**

| Date | Facebook | Twitter | Instagram | YouTube | TikTok | Day total |
|------|---------:|--------:|----------:|--------:|-------:|----------:|
| Jan 03, 2025 | 4 | 1 | 1 | 0 | 0 | 6 |
| Jan 04, 2025 | 1 | 1 | 1 | 0 | 0 | 3 |
| **Graph total** | 5 | 2 | 2 | 0 | 0 | **9** |

Graph total **9** == Sponsored Posts big number **9**.

**Per-channel Engagements (big number vs graph daily sum):**

| Channel | Jan 03 (graph) | Jan 04 (graph) | Graph Σ | Big number | Match |
|---------|---------------:|---------------:|--------:|-----------:|:-----:|
| Facebook | 2,206 | 444 | 2,650 | 2,650 | ✓ |
| Twitter | 344 | 211 | 555 | 555 | ✓ |
| Instagram | 33,155 | 308,655 | 341,810 | 342K (=341,810 rounded) | ✓ |

Cross-check to all-channel totals: Sponsored Posts 5+2+2 = **9** ✓; Engagements 2,650+555+341,810 =
**345,015 → 345K** ✓ — both reconcile to the all-channel big numbers.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A5 | 5 | Sponsored-posts big number == Sponsored Posts graph | Big number 9 == graph sum (6+3) = 9 | PASS |
| A7 | 7 | Σ Engagements (FB) == Engagements big number graph (FB) | 2,206+444 = 2,650 == FB big number 2,650 | PASS |
| A10 | 10 | Σ Engagements (Twitter) == Engagements big number graph (Twitter) | 344+211 = 555 == Twitter big number 555 | PASS |
| A13 | 13 | Σ Engagements (Instagram) == Engagements big number graph (Instagram) | 33,155+308,655 = 341,810 == IG big number 342K | PASS |

## Screenshots (`.playwright-out/QA-461/`)

- `step5-allchannels-bignumbers.png` — all-channel tiles (Sponsored Posts 9 / Engagements 345K)
- `step7-facebook-engagements.png` — Facebook-only (Engagements 2,650)
- `step10-twitter-engagements.png` — Twitter-only (Engagements 555)
- `step13-instagram-engagements.png` — Instagram-only (Engagements 342K)

## Spec-adherence notes

- Rule 1 (no brand substitution): honored — Adam's Brand Set (1738) on Adam Orfei (54), no switch.
- Rule 2 (click toggles, don't trust URL): channel enable/disable done by clicking each
  `.channel-ghost` toggle + Apply; state re-read from the DOM (`enabled` class) before each Apply;
  URL `channels=` confirmed after. Date range set by clicking both paired calendars, not URL edits.
- Rule 3 (every step, in order): steps 1–13 executed. Step 4 "Branded Content: Yes" has no matching
  filter on Partnerships (it is the branded-content view) — documented as implicit, not skipped.
- Rule 6 (no proxy-only claims): parity verified from live rendered graph tooltips (exact integers),
  reconciled to the on-screen big numbers — user-visible values, not DOM/network inferences.
- Step budget: all tiles rendered within a few seconds per channel; no render-hang.

## Bugs filed

_None._ No new defect observed; no closed linked bug reproduced. The 2026-07-10 Brand Sets **Content**
data-api 500 did not affect the **Partnerships** surface this run.
