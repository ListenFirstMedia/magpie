# QA-91412 — Brand Content > Public perspective Reels data check for Facebook channel

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-91412
- **Run date:** 2026-07-07 (Playwright MCP track)
- **Account:** FX Networks (account_id=204)
- **Brand:** FX (brand_id started at 4251, silently changed to 19746 on the perspective-toggle click — see Problems #1; header label stayed "FX" throughout, satisfying Rule 1's exact-name requirement)
- **Skills used:** `view-perspective-toggle` (v1), `brand-content-filter` (v2)
- **Historical context:** this is the origin ticket for Rule 1 (spec-adherence-rules.md) and the `view-perspective-toggle` skill — a prior Chrome-MCP run mis-tested on "It's Always Sunny in Philadelphia" before the brand was corrected to FX. This run confirms the current dev build resolves "FX" directly (no substitute needed) and re-validates the PASS result the corrected brand originally produced.

## Steps executed

1. Switched account to FX Networks via LFQA → Search Account (`pressSequentially`, not `.fill()`).
2. Brand → Content. Default-loaded brand's `.brand-selector-name` read exactly `FX` (brand_id=4251) — exact match, no substitution needed (Rule 1).
3. Set date range `2025-03-08` to `2026-03-07` via URL (date isn't a toggle/perspective concern; Rule 2 doesn't apply).
4. **Perspective → Public Data:** inspected `#perspective` checkbox — found `checked=true` (Authorized) despite `perspective=extended` in the URL (Rule 2's exact warning scenario). Clicked `label[for="perspective"]` to flip it. Confirmed `checked=false` (Public) afterward.
5. Channel selector: clicked `.channel-ghost` for Twitter/Instagram/TikTok to deselect, leaving Facebook only enabled. Clicked **Apply** (`[data-ui-name="channel_selector_apply_cta"]`). URL confirmed `channels=facebook`.
6. Applied the **Publish Type = Reel** filter (per `brand-content-filter` skill's documented `filters=` URL encoding for this exact case). Confirmed via DOM: filter pill "Publish Type:" rendered, `Posts (143)`.
7. Switched to **Table View** (`[title="Table View"]`) to read every post row's metric cells directly.

## Assertions

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 6 | All metrics show en-dash for Facebook Reels posts in Public perspective | Scanned all 143 post rows × 7 metric columns (Responses, Reactions, Replies, Reshares, Response Rate, Video Views, Video Engagement Rate) = **1,001 cells, all render `–` with `title="N/A"`**. Zero non-dash values found. | **PASS** |

## Evidence

Sample row (post 2 of 143, Mar 10 2025 Reel):
```html
<td class="lfm.content.responses mini dp"><span title="N/A">–</span></td>
<td class="lfm.content.reactions mini dp"><span title="N/A">–</span></td>
<td class="lfm.content.replies mini dp"><span title="N/A">–</span></td>
<td class="lfm.content.reshares mini dp"><span title="N/A">–</span></td>
<td class="lfm.content.response_rate mini dp"><span title="N/A">–</span></td>
<td class="lfm.content.public_video_views_v5 mini dp"><span title="N/A">–</span></td>
<td class="lfm.post_engagement_score.public_video_engagement_rate mini dp"><span title="N/A">–</span></td>
```
Full-dataset scan: `{ rowCount: 143, totalCells: 1001, nonDashCount: 0 }`.

## Problems encountered

1. **The "brand silently falls back to a different brand_id on perspective-toggle click" quirk (previously documented only for Threads channel, 2026-06-08 QA-98351) now reproduces with Facebook-only channel selection too.** Clicking the Public/Authorized toggle on brand_id=4251 (FX) silently changed the URL's `brand_id` to 19746 while the on-screen `.brand-selector-name` label kept reading "FX" for both. Data returned (143 Reel posts, all en-dash) still satisfies Rule 1 (exact displayed brand name never changed) and the assertion, but this is a broader-than-previously-known instance of the fallback bug — worth escalating to product/eng since it's no longer channel-specific.
2. **`#perspective` checkbox convention confirmed inverted from a naive read of the URL param**: `perspective=extended` in the URL rendered `checked=true` (Authorized) on first load — the opposite of the `known-quirks.md` "URL `channels=X` / `perspective=extended` usually maps to Public" heuristic. Rule 2 (never trust the URL, always verify+click) caught this correctly.
3. Brand-Content's channel-ghost elements responded correctly to real Playwright `.click()` (no JS-dispatch workaround needed here, unlike some other surfaces) — but require clicking each channel individually followed by a separate `channel_selector_apply_cta` Apply click; the click model here is **additive multi-select** (unlike Brand>Audience/Insights which are exclusive-select) — worth noting the inconsistency across surfaces for future skill authors.

## Skill updates

`view-perspective-toggle` — reusing as-is; the checkbox selector for Brand>Content is `#perspective` / `label[for="perspective"]` (different DOM than the `.al-toggle__checkbox` documented for other surfaces) — worth adding as a per-surface selector variant in a future revision.

## Bugs filed

None (all metrics correctly show en-dash, matching spec). Problem #1 (brand_id fallback broadening) is flagged for engineering re-confirmation, not filed as a formal bug in this pass — recommend linking to the existing QA-98351 finding rather than opening a duplicate.
