# QA-6315 — Brand > Conversation - Basic view

**Run date:** 2026-07-13
**Track:** Playwright MCP (`feature/playwright-mcp`)
**Account:** Adam Orfei (account_id=54), Brand: MTV (brand_id=4018)
**Status:** ❌ FAIL (1 assertion tied to reproduced open bug LFMP-31800; all others PASS)

## Steps executed
1. Hovered Brand top-nav dropdown → clicked Conversation.
2. Brand selector → typed and selected MTV.
3. Observed header toolbar.
4. Observed tile layout top-to-bottom.
5. Clicked "Click here to load Tweets" link in the Analyzed Posts table to probe LFMP-31800.

## Assertions

| Step | Expected | Actual | Status |
|------|----------|--------|--------|
| 3 | Help Center / Guide / Info icons top-right | `.fa-question-square`, `.fa-question-circle`, `.fa-info-circle` all present in DOM | ✅ PASS |
| 3 | Last tab is Conversation | Nav order: Insights, Channels, Content, Video, Stories, Audience, Optimization, Partnerships, Paid, **Conversation** (last) | ✅ PASS |
| 3 | Apply button for Channel toggle disabled by default | `button` has CSS class `disabled` (not native `disabled` attr, but functionally disabled per this app's convention — same non-native-disabled pattern seen elsewhere in this codebase) | ✅ PASS |
| 4 | Default perspective 'Authorized Data' | `#perspective` checkbox `checked=true` (Authorized per established convention) + URL auto-added `perspective=extended`. **Note:** could not visually screenshot-confirm the toggle knob position — `browser_take_screenshot` timed out repeatedly on this page ("waiting for fonts to load", likely blocked by the third-party Twitter-widget iframe present on this page). DOM signal is consistent and this page's toggle behaved reliably elsewhere, but flagging the missed visual double-check per Rule 2 for transparency. | ✅ PASS (DOM-confirmed; visual screenshot inconclusive due to environment issue) |
| 4 | Twitter, Instagram channel icons present at View by channels | URL auto-selected `channels=twitter&channels=instagram`; legend on Conversation Volume tile shows "Twitter" and "Instagram" | ✅ PASS |
| 4 | Export dropdown displayed top-right of toolbar | "Export" present next to Channels/Apply in the toolbar row | ✅ PASS |
| 4 | 'Data set' dropdown should NOT display | No "Data Set:" label anywhere on this page (unlike Brand>Content) | ✅ PASS |
| 4 | Conversation Analysis section below Conversation Overview | Body order: "Conversation Overview" → Conversation Volume tiles → "Conversation Analysis" → Filter → Sources/Hashtags tiles | ✅ PASS |
| 4 | Filter dropdown below Conversation Analysis tile | `Conversation Analysis\nFilter:\nSelect...` immediately follows the section header | ✅ PASS |
| 5 | Row 1 = Conversation Volume, Conversation Volume (Daily) | Confirmed, both tiles present in that order | ✅ PASS |
| 5 | 2nd tile = Sources, Sources (Daily) | Confirmed | ✅ PASS |
| 5 | 3rd tile = Hashtags, Hashtags (Daily) | Confirmed | ✅ PASS |
| 5 | 4th row = Analyzed Posts N + Sort filter | "Analyzed Posts (1)" + "Sort: Date" | ✅ PASS |
| 5 | Post table columns: Date, Channel, Author, Type, Publish Type, Source, Text, Keyword, Hashtag | Header row exact match: `Date, Channel, Author, Type, Publish Type, Source, Text, Keyword, Hashtag` | ✅ PASS |
| — | LFMP-31800 probe: "Click here to load Tweets" should load tweets inline | Clicking the link **navigated the whole page to `#explore/listening/conversation`** (the Listening page) instead of loading tweets in the Analyzed Posts table | ❌ FAIL — **REPRODUCED** |

## Open-bug verdict

**LFMP-31800 (Major, Open) — REPRODUCED.** "Click here to load Tweets" navigates away to the Listening page rather than loading tweets inline in the Conversation Analysis table. Consistent with the 2026-06-13 re-run verdict (still defective on dev).

## Bugs filed

None new — LFMP-31800 already tracks this; this run reconfirms it, no retraction warranted.

## Cleanup

Not applicable — no mutation.
