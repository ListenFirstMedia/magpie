# QA-100879 — Brand Content > LFM vs Native > Threads Channel

**Run date:** 2026-11-18 · **Track:** Playwright MCP, headless `claude -p` (unattended) · **Env:** app.lfmdev.in (dev)
**Account / Brand:** not exercised (precondition: HBO Max account, brand 'HBO Max')

**Verdict: FAILED (blocked by open bug).** Per spec-adherence Rule 7 (open-bug auto-fail) the browser flow was not run. The case has an open linked defect: **LFMP-32113**.

## Rule 7 screen
- `cases/QA-100879.md` → "Open linked bugs (as of 2026-10-20)": `LFMP-32113 (Open): Brand Content > LFM vs Native - Past Date - native data is lower than LFM`.
- Re-checked against today's open-bug map, `results/open-bugs-2026-11-18.json`: `QA-100879` → `LFMP-32113 [Open] Brand Content > LFM vs Native - Past Date - native data is lower than LFM`. The bug is still open as of 2026-11-18.
- The bug is on the same surface as this case's assertion (LFM metric values compared with Native). Per the open-bug auto-fail directive, no judgement of interference is made.

## Steps executed
| # | Step | Result |
|---|------|--------|
| 1–7 | All steps (Brand > Content, select HBO Max, Threads channel only, note first-post metrics, open the native post, note native metrics) | NOT EXECUTED (Rule 7 — open linked bug, browser not opened) |

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A7 | 7 | LFM metric values should not have big variations compared with Native | Not evaluated. Case blocked by open bug LFMP-32113 (native data lower than LFM for past dates). | FAILED (blocked by open bug) |

## Evidence
- No browser session was started and no screenshots were taken, so `.playwright-out/QA-100879/` has no artifacts.
- The only evidence is the open-bug map entry quoted above.

## Known bugs checked
- **LFMP-32113 (Open)** — Brand Content > LFM vs Native - Past Date - native data is lower than LFM. This is the bug the case is attributed to.
- Pre-fetched grep of `knowledge-base/bug-history.md` and `knowledge-base/known-quirks.md` for QA-100879: no entries.
- The case file lists no other linked bugs, closed or open.

## Bugs filed
None. The failure is attributed to the existing LFMP-32113, and no new bug is filed.

## Cleanup
None (read-only; nothing was created).

## Re-run note
The case will be picked up automatically once LFMP-32113 closes and the open-bug map and case cache are refreshed.
