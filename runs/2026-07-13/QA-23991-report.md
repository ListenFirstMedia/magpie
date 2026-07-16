# QA-23991 — Reporting > Content Performance Report - Download

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54), Brand: MTV
**Status:** ✅ PASS

## Steps executed
1. Navigated directly to `app-reporting.lfmdev.in/#/content_performance` (CPR Builder).
2. Added brand **MTV** — typed via real Playwright keystrokes (`pressSequentially`), selected exact match. Note: the `cpr-builder` skill's documented "JS-set workaround" for the brand picker is Chrome-MCP-era and not needed here — same as other builders on this track.
3. Clicked **Run Report** (default date range: current week, Jul 5–11 2026; default 7 channels) → built story `155911`.
4. Waited for "Building Your Story" to resolve → clicked **Preview & Share Report**.
5. Clicked the **Download** tab (sibling of Share) → PDF downloaded synchronously via Playwright `download` event.
6. Verified the file on disk per Rule 6: `MTV-Content-Performance-Jul-5-2026---Jul-11-2026-.pdf`, 352,230 bytes, `file` confirms genuine "PDF document, version 1.3, 1 page" (not a corrupt/empty stub).

## Assertions

| Step | Expected | Actual | Status |
|------|----------|--------|--------|
| Builder | Story builds successfully for MTV | Story 155911 rendered, header "MTV / Content Performance / (Jul 5, 2026 - Jul 11, 2026)" | ✅ PASS |
| Download | Preview & Share Report → Download produces a real PDF | 352KB valid single-page PDF confirmed on disk via `file` | ✅ PASS |

## Bugs filed

None.

## Cleanup

Not applicable — no mutation.
