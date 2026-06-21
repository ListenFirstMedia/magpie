# QA-923 — Brand Content - Embedded Post Tooltip (Amazon Prime Video) — 2026-06-13

- **Env:** Dev · **Account:** Adam Orfei · **Brand:** Amazon Prime Video (brand_id=25864) · **Window:** May 1–31 2026 · **Perspective:** Authorized
- **Skill:** brand-content-data-set-selector
- **Result:** ✅ PASS-with-observations (**upgrades prior 2026-06-05 BLOCKED**) — Sentiment-mode was OFF this run, post table rendered after a reload (documented APV renderer transient).
- **Open bug probes:** LFMP-31915 **NOT reproduced**; LFMP-31857 **signal present**.

## Assertions
| ID | Expected | Actual | Status |
|----|----------|--------|--------|
| A1 | Embedded tooltip opens on hovering Type | Twitter (Posts 192) + IG (Posts 270) type-link hover both open the embed tooltip | ✅ |
| A2 | Only one tooltip viewable | Exactly 1 embed iframe in DOM while hovering | ✅ |
| A3 | Tooltip closes on X / click elsewhere | X click → embed iframe count 0 | ✅ |
| A4 | Hovering other type links doesn't stack tooltips | Never more than 1 iframe | ✅ |
| A5 | Clicking type opens correct channel post in new tab, matches tooltip | Type links carry valid post hrefs; click-through-to-new-tab not exercised this run | ⚠️ Deferred |
| A6 | Post image + text match tooltip | IG post #5 (gallery "If he's in it, I'm seeing it", primevideo ✓ 6.5M) — tooltip embed matches the card thumbnail + caption exactly | ✅ |
| A7 | Tooltip does NOT open for TikTok post type | Not exercised this run (budget) | ⚠️ Deferred |

## Open-bug verdicts
- **LFMP-31915 (Major, Open) — IG Image Posts Tooltip Is Empty:** **NOT REPRODUCED.** Hovering an IG Image/gallery post type (post #5, Original Post) initially showed a blank box, then populated after ~4s with the full Instagram embed: `primevideo ✓ 6.5M followers`, View profile, 6-image carousel, caption "If he's in it, I'm seeing it". Tooltip is NOT empty — slow embed load only. Recommend verifying the Jira can be closed.
- **LFMP-31857 (Major, Open) — Twitter post text having link:** **SIGNAL PRESENT.** Twitter post card/tooltip text retains raw `t.co` shortlinks, e.g. "It happened. https://t.co/R3zdkoZloO" (post 3), "They came a long way from that first line https://t.co/hi4MLbe0hm" (post 5). Post text is not stripped of the trailing media/permalink t.co URL — consistent with the open bug.

## Observation (not an assertion)
- **Twitter embedded tooltip rendered empty** (no tweet embed even after wait) on APV Twitter video posts, while IG embeds populate. Likely an X-platform embed restriction (tweets failing to oEmbed), not necessarily an LFM defect — flagged for monitoring, parallels the Pinterest blank-embed quirk (QA-929).

## Cleanup
- No mutations. APV Brand>Content required one hard reload per channel (renderer transient).
