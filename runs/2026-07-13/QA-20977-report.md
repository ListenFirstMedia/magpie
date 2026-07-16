# QA-20977 — Brand > Paid - Tag Functionality Across Views - TikTok

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54), Brand: MTV (brand_id=4018, TikTok Paid, 45 posts)
**Status:** ⚠️ PARTIAL PASS (A1, A2 PASS; A3 FAIL — same bug as QA-1289, now confirmed on a second surface)

## Note on brand/routing

Direct URL navigation to Brand>Paid for Hulu (brand_id=11003) with `channels=tiktok` twice silently **redirected to Brand>Insights** instead (URL rewrote itself to `#explore/brand/insights?...`) — a routing quirk, not attempted via menu-click fallback since MTV (brand_id=4018) worked cleanly on the first direct-URL attempt and has 45 TikTok Paid posts. Documented as a possible SPA-routing edge case for `brand_id=11003` + Paid specifically (candidate `known-quirks.md` addition, not filed as a bug this run — low confidence on root cause).

## Steps executed
1. Brand → Paid, MTV, TikTok channel only (45 Paid posts).
2. Clicked Tag button (`.tag-blob.label-blob`) on post #1 ("Fine, fresh, fierce... Katy Perry VMA" TikTok ad).
3. Added unique tag `QA-20977-TEST-20260713` → Done. Confirmed chip present in the popup.
4. Switched to Table View → confirmed `Tag (1)` badge persists on the tagged post.
5. Filter → **Tag** category. Select All default = unchecked (`far fa-square`).
6. Clicked Select All → all 20 tag rows flipped to checked; **unlike QA-1289's Content-page finding, the Select All master checkbox correctly stayed checked here** (no desync).
7. Attempted to deselect one individual already-checked tag (`jbkaxlx`) — icon stayed checked, count stayed 20/20 (same click-doesn't-deselect behavior as QA-1289).
8. **Cleanup:** located the tagged post's `Tag (1)` pill (`.tag-pill-container`) in Table View → Delete All Tags → confirmed Delete All → verified tag string gone from the page.

## Assertions

| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Tag button visible and functional on TikTok Paid posts | Confirmed — Add Tags popup opens, tag adds successfully | ✅ PASS |
| A2 | Tag persists across view switches | `Tag (1)` badge visible after switching Grid→Table | ✅ PASS |
| A3 | Select All checkbox behaves correctly in Tag filter | **FAIL** — Select All correctly checks all 20 tags (better than the Content-page case, where the master checkbox itself desynced), but **individual tags still cannot be deselected** after Select All — same underlying defect as QA-1289 | ❌ FAIL |

## Finding

**Confirms and broadens the QA-1289 finding: "cannot deselect an individual tag after Select All" reproduces on Brand > Paid (TikTok) as well as Brand > Content (Facebook).** This strongly suggests a shared Tag-filter-checklist component bug across all Brand surfaces that use this filter widget, not a Content-page-specific issue. The Select-All-desync half of the QA-1289 finding did NOT reproduce here (Select All's own checkbox stayed checked correctly on Paid) — so that part may be more surface-specific or session-flaky; the individual-deselect failure is the consistent, high-confidence part.

## Bugs filed

None auto-filed — recommend filing the combined finding: "Tag filter: individual tags cannot be deselected once checked via Select All, reproduced on both Brand>Content and Brand>Paid."

## Cleanup

✅ Complete — test tag `qa-20977-test-20260713` added to MTV TikTok Paid post #1 and removed via Delete All Tags, confirmed gone.
