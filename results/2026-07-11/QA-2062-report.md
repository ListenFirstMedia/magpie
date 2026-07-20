# QA-2062 — Pinterest Content - Post Hovering

- **Run:** 2026-07-11 (unattended, headless Playwright MCP, `feature/playwright-mcp`)
- **App:** https://app.lfmdev.in
- **Account:** Sephora (account_id=655) — switched from Adam Orfei via switch-account skill
- **Brand:** Sephora (brand_id=7159)
- **Channel:** Pinterest only (`channels=pinterest`)
- **Data Set:** Pinterest Only: Basic (`table_data_set=pinterest_only:_basic`, auto-selected)
- **Date Range:** Jul 09, 2025 – Jul 09, 2026 (Last 12 Months; default 1-week window returned Posts (0))
- **Layout:** Table View
- **Perspective:** Authorized Data (`perspective=extended`, brand default — perspective-independent for this test)
- **Skills reused:** switch-account, brand-content-data-set-selector, brand-content-table-view, embedded-post-tooltip
- **Verdict:** **PASS** (A4 blank-tooltip rows are the expected external-platform behavior, flagged PARTIAL per spec — not a FAIL)

## Steps executed

1. Logged in via Cognito "With existing account" (config/.env lfiqa). Landed `#home`, Account: Adam Orfei.
2. Brand top nav → Content.
3. Spec brand Sephora lives on the Sephora account (655), not Adam Orfei (54). Switched account via LFQA menu → Search Account → typed "Sephora" (trusted slow keystrokes after the React value-setter surfaced only Recent Searches) → clicked the "Sephora" Results `.lfm-ta-option`. Session switched to Account: Sephora.
4. Brand nav → Content resolved to Sephora `brand_id=7159`. Header confirmed "Sephora".
5. Channel selector: enabled **Pinterest** and disabled the 6 defaults (FB/Twitter/IG/TikTok/LinkedIn/Threads) → Apply. URL settled to `channels=pinterest` with Data Set auto-switched to **Pinterest Only: Basic**.
6. Default week (Jul 3–9 2026) returned **Posts (0)** (expected per spec step-4 note). Widened Date Range via the Auto preset → **Last 12 Months** → **Posts (66,364)**.
7. Switched layout to **Table View** (`[title="Table View"]`; `layout=` URL not honored on hash route — known quirk).
8. Confirmed 200 Type-column post-type links (`.label-blob[data-ui-name="type_column"] > a`, hrefs = `pinterest.com/pin/<id>`).
9. Hovered Row 1 Type cell → embedded pin tooltip. Verified content, then clicked X to close.
10. Hovered Row 2, then Row 3 → confirmed one-at-a-time replacement and a blank-tooltip case.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | Hover Type column | Embedded tooltip with pin image + caption + "Published by" byline for resolvable pins | Row 1 (pin `4600567881373839104`): 370×386 tooltip — product pin image, red **Save** button, caption "Fragrance Family: Warm & Spicy… Scent Type: Warm & Sheer…", byline **"Published By Sephora"** with avatar, X control (screenshot `row1-tooltip.png`). Row 2 (pin `4609926933731494016`): caption "Parfum You Solid de Glossier…" + Published-by. | PASS |
| A2 | Tooltip close control | Tooltip has an X close control | `i.fas.fa-times.close-embed` present top-right on every tooltip; clickable | PASS |
| A3 | Close restores table | Closing the tooltip restores table state | After clicking X, `.embedded-post-tooltip` removed from DOM (present=false); table intact — 200 Type links, Posts (66,364) unchanged | PASS |
| A4 | Blank-tooltip rows | Blank tooltip (Pinterest CDN unavailable) is expected external behavior → PARTIAL not FAIL | Row 3 (pin `4600778950635531008`): tooltip frame rendered 370×350 but inner content BLANK (textLen 0, no image, no byline) — only the X (screenshot `row3-blank-tooltip.png`). Matches known-quirk (unavailable external pin; embed id carries `-undefined` suffix). Flagged expected/PARTIAL. | PARTIAL (expected) |

### One-at-a-time (single-tooltip guarantee)
Hovering Row 2 then Row 3 always left **exactly one** `.embedded-post-tooltip` in the DOM (count=1 each time); prior tooltip content is replaced, not stacked. Consistent with APPS-8258.

## Evidence
- `.playwright-out/QA-2062/row1-tooltip.png` — Row 1 resolvable pin tooltip (image + Save + caption + "Published By Sephora" + X).
- `.playwright-out/QA-2062/row3-blank-tooltip.png` — Row 3 blank tooltip (unavailable pin), single tooltip visible.
- Embed id observed: `embedded-post-686ee820ed60dc5c2686dc9dc4ddc84e-undefined` (`-undefined` suffix, per known finding).
- Type-link hrefs verified as `https://www.pinterest.com/pin/<id>`.

## Known bugs checked
- **Jira open linked bugs:** cached bug-history for QA-2062 lists **Open bugs (0)** — screen passed (Rule 7); ran normally. (Case file had no `## Open linked bugs` section; bug-history is authoritative and shows none open.)
- **knowledge-base/bug-history.md (grep QA-2062):** prior 2026-06-04 run PASS on the same Sephora/Pinterest flow; documented Row-3 blank tooltip for an unavailable external pin — reproduced identically this run.
- **known-quirks / embedded-post-tooltip skill:** blank tooltip when the external Pinterest pin is unavailable is accepted external-platform behavior (LFMP-31385 symptom, closed). Reproduced on Row 3; does not affect the A1–A3 assertions. Not a regression.

## Bugs filed
None. Blank-tooltip on Row 3 is the expected/accepted external-pin behavior (A4), not a defect.
