# QA-574 — Instagram Lifetime Private Data QA

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54), Brand: MTV (brand_id=4018)
**Status:** ⚠️ PASS-with-deviation (spec ambiguity on "Recent tab" — see below)

## Steps executed
1. Navigated Brand → Content, MTV, Instagram-only channel filter (`channels=instagram`).
2. **Rule 2 finding:** initial page load rendered with the View toggle knob visually on **Public Data** despite `perspective=extended` already present in the URL and the underlying checkbox reporting `checked=true` — a real mismatch between DOM state and rendered position, not just URL-vs-truth. Clicking the toggle label (both directions, tried twice) triggered the documented brand-fallback quirk (`brand_id` 4018→10765, channel selection reset to a 4-5 channel default, `perspective` flipped to `standard`) — see Finding below.
3. **Workaround:** re-navigated directly via URL with `brand_id=4018&channels=instagram&perspective=extended` (no toggle click) — this time the visual knob correctly rendered on **Authorized Data**, confirmed both via `checked===true` AND a full-width screenshot showing the knob on the right with "Authorized Data" in the active/bold position.
4. Captured Sum/Avg + first 3 posts on default **Data Set: Public** (20 posts, Sum Engagements 283,362 / Reactions 280,785 / Comments 2,577).
5. Opened the **Data Set** dropdown to find a "Recent" data set per spec step 4 — **no option literally named "Recent" or "Lifetime" exists**. Available IG-relevant options: `Public`, `Instagram Only: Insights`, `Instagram Only: Action Types`, `Instagram Engagements Beta`. Used **Instagram Only: Insights** as the closest IG-specific lifetime/authorized comparator (per `knowledge-base/known-quirks.md` "Brand > Content default Data Set hides channel-specific data").
6. Captured Sum/Avg + first 3 posts on **Instagram Only: Insights** data set.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 1–3 | Authorized perspective indicator confirmed (URL `perspective=extended`, toggle handle right) | Confirmed via direct URL nav + screenshot after working around the toggle-click brand-fallback bug (see Finding) | ✅ PASS |
| A2 | 3 | Post-table populates with IG Authorized metrics; row count > 0 | 20 posts on both data sets. `Instagram Only: Insights` exposes additional Authorized-only columns not present under Public: **Saves, Organic/Paid Saves, Shares (populated, was `–` under Public), Views, Private Likes, Effectiveness** | ✅ PASS |
| A3 | 3 vs 5 | Per-post lifetime metric values on Content tab equal corresponding values on Recent tab to rounding | No literal "Recent" tab/data-set exists (spec ambiguity, Rule 5) — used `Instagram Only: Insights` as comparator. **Engagements Sum is identical across both data sets: 283,362.** Post #1 (madonna/sabrinacarpenter, Jul 06) Engagements = 50,447 on both. This is the best available cross-check given the spec's ambiguous terminology. | ⚠️ N/A (spec ambiguity) — proxy check PASSES |
| A4 | 3 | No "data is private — log in" placeholder rendered on Authorized rows | No such placeholder; real numeric Authorized/Private metrics render (Private Likes 49,860 / 42,719 / etc. on top posts) | ✅ PASS |

## Finding

**Brand>Content perspective-toggle click causes brand-fallback even for a plain Instagram-only channel selection (no Threads involved), reproducing bidirectionally.** Clicking `label[for="perspective"]` on MTV/Instagram-only silently changed `brand_id` 4018→10765, reset the channel filter to a 4–5-channel default, and flipped `perspective` to `standard` — regardless of which direction the click was intended to move the toggle. This broadens the existing known-quirk (previously scoped to Threads-channel and Facebook-only cases per `known-quirks.md` 2026-06-08 entries) to plain Instagram-only. **Workaround used:** never click the toggle; always re-navigate via direct URL with explicit `brand_id` + `perspective` params, then visually re-confirm via screenshot (URL/DOM `checked` alone is insufficient — the very first page load in this run showed `checked=true` + `perspective=extended` in the URL while the visual knob was still on Public Data). Recommend updating `known-quirks.md` and the `view-perspective-toggle` skill with this broadened finding.

## Bugs filed

None — documented as a known-quirk broadening + spec-ambiguity note (Rule 5), not a new bug ticket. Recommend a candidate bug for the toggle-click brand-fallback if not already tracked (currently only informally noted in `known-quirks.md`, no LFMP/APPS ticket number attached).

## Cleanup

Not applicable — read-only navigation, no mutation.
