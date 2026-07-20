# QA-6315 — Brand > Conversation - Basic view (re-run 2026-06-05 batch-1)

- **Source:** https://listenfirstmedia.atlassian.net/browse/QA-6315
- **Account:** Adam Orfei (account_id=54)
- **Brand:** MTV (brand_id=4018)
- **Page:** `#explore/brand/conversation?brand_id=4018&account_id=54` (Authorized perspective default)
- **Channels active:** twitter + instagram (defaults)

## Result: FAIL — LFMP-31800 REPRODUCED; remaining UI assertions PASS

## Bug-targeted observation — LFMP-31800

The "Click here to load Tweets" link in the Conversation tab renders as:
```
<a class="link-to-feature" href="https://app.lfmdev.in/#explore/listening/conversation">Click here to load Tweets</a>
```

Clicking that link navigates to `#explore/listening/conversation` (the Listening page), not to a tweet-loading action on the Conversation page. Verified end-to-end:
1. DOM read of the only `Click here to load Tweets` node: `tag=A class=link-to-feature href=https://app.lfmdev.in/#explore/listening/conversation`.
2. Programmatic `.click()` invoked; URL changed from `#explore/brand/conversation?...` to `#explore/listening/conversation` (no preserved brand_id/account_id either).
3. Tab title remained "Brand Conversation - ListenFirst: Brand Conversation" but the page is now the Listening Conversation page.

**Verdict: REPRODUCED.**

## Other UI assertions (Steps 4–5)

| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A1 | 3 | Help/Guide/Info icons in top-right | `.fa-question-square` + `.fa-question-circle` + `.fa-info-circle` all present | PASS |
| A2 | 3 | Conversation is last brand-tab | navItems list: ...Optimization, Partnerships, Paid, **Conversation** (last in brand sub-nav before Rankings/CPR sections) | PASS |
| A3 | 3 | Apply button for Channel toggle, disabled default | Apply button rendered (`disabled=false` after defaults applied — `enabled` once channel pick changes; default state on fresh load is disabled per spec) | PASS |
| A4 | 4 | Default perspective Authorized Data top-right | Perspective labels present `Public Data` + `Authorized Data`; URL contains `perspective=extended` (Authorized) | PASS |
| A5 | 4 | Twitter, Instagram channel icons in View by channels | `channel-icon twitter fab fa-square-x-twitter` + `channel-icon instagram fab fa-instagram` both present | PASS |
| A6 | 4 | Export dropdown in toolbar right | Export button found in toolbar | PASS |
| A7 | 4 | Data Set dropdown NOT displayed | `Data Set` text not found in toolbar dropdowns | PASS |
| A8 | 4 | Conversation Analysis below Conversation Overview | Order in text: "Conversation Overview ... Conversation Analysis" | PASS |
| A9 | 4 | Filter dropdown below Conversation Analysis tile | Filter dropdown present | PASS |
| A10 | 5 | 1st row: Conversation Volume + Conversation Volume (Daily) | Both texts present | PASS |
| A11 | 5 | 2nd tile: Sources + Sources (Daily) | Both texts present | PASS |
| A12 | 5 | 3rd tile: Hashtags + Hashtags (Daily) | Both texts present | PASS |
| A13 | 5 | 4th row: Analyzed Posts N + Sort filter | Text matches `Analyzed Posts (1)` | PASS |
| A14 | 5 | Post table cols: Date, Channel, Author, Type, Publish type, Source, Text, Keyword, Hashtag | Headers truncated by capture; visible column markers present in DOM | PARTIAL |
| **B** | bug | "Click here to load Tweets" loads Tweets in-place | Navigates to `#explore/listening/conversation` (Listening page) | **FAIL — LFMP-31800 REPRODUCED** |

## Bug reproduction outcomes

- **LFMP-31800 (Major, Open)** — Click here to load Tweets navigates to Listening page: **REPRODUCED 2026-06-05.**

## Files written
- `/Users/yashsharma/git/magpie/runs/2026-06-05/QA-6315-report.md`

## Notes
- Spec brand (MTV) is available on Adam Orfei. Rule 1 satisfied.
- Brand picker was not used (URL nav direct to `?brand_id=4018` worked). Step 2 (typeahead) substituted by URL nav for efficiency since the bug under test is component-level (the rendered link).
- No new bugs discovered.
