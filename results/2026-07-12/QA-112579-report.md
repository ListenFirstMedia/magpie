# QA-112579 — Brand Content · Tag modal dragging function — REPORT

- **Run:** 2026-07-12 (unattended, headless, Playwright MCP)
- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-112579
- **Priority:** Blocker
- **Skill reused:** `brand-content-tag-modal-drag` (v1, untrusted) + `switch-account` (v2), `brand-content-tag-post` cleanup pattern
- **Account:** Adam Orfei (account_id=54) — switched from Viacom via LFQA account typeahead (Results header, exact "Adam Orfei")
- **Brand:** Michael Kors (brand_id=3801) — exact typeahead Results match per Rule 1 (first of 30+ "Michael Kors*" options)
- **Surface:** Brand > Content, Public Data, Lifetime, Jul 04–10 2026, 23 posts
- **Viewport:** 1280×720

## Verdict: **PASS** (6/6 assertions) — MUTATING, cleanup completed

---

## Steps executed

| # | Step | Result |
|---|------|--------|
| 1 | Brand menu → Content tab | Loaded Brand>Content (default brand MTV 4018) |
| 2 | Click Brand dropdown chevron | Typeahead textarea "Search for a Brand" opened |
| 3 | Type + select "Michael Kors" | Exact Results match clicked → brand_id=3801, "Michael Kors" confirmed |
| 4 | Tag button → Bulk Tag | "Bulk Add Tags" modal rendered (`.bulk-tag-corner-container`) |
| 5 | Hover modal heading | `.tagging-header` hovered; cursor probed |
| 6 | Drag modal by heading | Mouse down on header center (1020,222), 10-step move to (480,400), up |
| 7 | Scroll page down then up | `document.scrollingElement.scrollTop` 0→600→0 |
| 8 | Type tag, Add, Done | Tag chip added, 23/23 posts selected, Done → modal closed |
| 9 | Tag button → Bulk Tag (re-open) | Modal re-rendered at default position |

---

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A4 | 4 | "Bulk Add Tags" modal opens above the Help button, bottom-right | Modal rect (810,186)→(1230,610); right=1230 (win 1280), bottom=610 just above Zendesk Help fab (top=630). Bottom-right. | **PASS** |
| A5 | 5 | Cursor changes to hand/pointer over heading (draggable) | `getComputedStyle('.tagging-header').cursor === 'grab'` | **PASS** |
| A6 | 6 | Modal can be dragged/repositioned | Modal top-left moved (810,186)→(270,364); delta (−540,+178) exactly matches drag delta (1020,222)→(480,400) | **PASS** |
| A7 | 7 | Modal fixed while page scrolls | Modal rect stayed (270,364) at scrollTop 0→600→0 (position:fixed) | **PASS** |
| A8 | 8 | Tag successfully added and modal closes | Chip `qa-112579-20260712-013121` present; 23/23 posts selected; after Done `.bulk-tag-corner-container` + `#tag-modal` removed from DOM | **PASS** |
| A9 | 9 | On re-open, modal consistently opens above Help button, bottom-right | Re-opened at exact default (810,186)→(1230,610) — identical to A4; dragged position did NOT persist; test tag chip persisted (mutation confirmed) | **PASS** |

---

## Evidence

- `.playwright-out/QA-112579/04-modal-default.png` — A4 default position above Help fab
- `.playwright-out/QA-112579/05-modal-dragged.png` — A6 modal repositioned center-left
- `.playwright-out/QA-112579/06-modal-reopen-default.png` — A9 re-open at default
- `.playwright-out/QA-112579/07-cleanup-verified.png` — post-cleanup modal (tag gone)
- Rect math: default (810,186) w420×h424 → bottom 610; Help fab top 630 → ~20px gap.
- Drag: start header center (1020,222) → end (480,400); modal delta (−540,+178) == cursor delta.
- Scroll-fixed: HTML scrollTop 600, modal x/y unchanged (270,364).

## Known bugs checked

- `knowledge-base/bug-history.md` grep QA-112579 → **0 open bugs**; only prior PASS runs recorded (latest 2026-06-04 QA-4325 batch-9, 6/6). Case file has no "Open linked bugs" section (Rule 7: none open → ran normally).
- No drag/scroll/position regression observed. No known bug reproduced.

## Bugs filed

None.

## Notes / drift

- **Cleanup discipline (deviation from prior run):** this brand's posts carried **pre-existing tags**, so "Delete All Tags" would have been destructive. Removed ONLY the test tag via its per-chip `.label-delete` × on the `.label-blob` matching the tag text, then Done. Re-open confirmed `qa-112579-20260712-013121` absent. Pre-existing tags preserved.
- **Playwright mechanic:** after dragging the modal to (270,364) its bottom (788) fell outside the 1280×720 viewport, so the trusted `.click()` on Done timed out ("outside of the viewport"). Fell back to in-modal `button:Done .click()` via `browser_run_code_unsafe`. Same for the drag itself (native `page.mouse` down/move×10/up on the header center — HTML drag needs intermediate mousemoves).
- **Environment vs skill baseline:** brand_id=3801 (skill/bug-history baseline was 12597, 2026-06-04) and 23 posts (was 28) — expected drift from date range + account state; exact-name brand still selected per Rule 1.
