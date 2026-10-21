---
name: brand-content-native-post-check
version: 1
last_verified: 2026-10-19
last_passed_run: 2026-10-19
trust: untrusted
pass_streak: 3
preconditions: [user-logged-in, account-set]
postconditions: [native-post-values-read]
inputs: [account_name, brand_name, from_date, to_date, channel]
outputs: [lfm_first_post_metrics, native_post_metrics]
related_pages: ["/#explore/brand/content"]
---

# Brand > Content — LFM vs Native post check (QA-22105..22108, Test Set QA-27628)

Read the first post's metrics on Brand > Content for ONE channel and a fixed past date range, click the post image to open the native platform post in a new tab, and read the native counts logged-out. Verified 2026-10-19 on HBO Max (Twitter/Instagram/YouTube) and UCLA (LinkedIn).

## Steps (Playwright MCP, headless Chrome `--isolated`)

### 1 — Account + Brand > Content
- `switch-account` skill. Dev gotcha (2026-10-19): the Search Account **Results** list can take 10–20 s on a slow dev API and may only appear after re-typing one character (Backspace + retype). Poll for the visible `Results` header, then click `.lfm-ta-option` with the exact account text.
- Hover `Brand` in `.navigation-menus` → click `Content`. The account's default brand loads (HBO Max → "HBO Max" 155614; UCLA → "University of California, Los Angeles" 127756 — exact spec names, no typeahead needed).

### 2 — Absolute date range (Brand > Content picker)
- Click the date button (`getByRole('button', {name: '<current range>'})` next to "Date Range:"). Popup root: `.date-selector-container.display-date-picker` with `Make a Selection: Auto`, `Select Mode: Lifetime | In Window`, **START DATE / END DATE** buttons (`.date-range-fields`), ONE paginated bootstrap datepicker (`.paired-calendar … focus-start`), and **Ok**.
- Click the START DATE button, then in the VISIBLE datepicker: `.datepicker-days .datepicker-switch` → `.datepicker-months .datepicker-switch` → `span.year` (use `th.prev` to page back) → `span.month` → `td.day:not(.old):not(.new)`. Then click the END DATE button and repeat. Always filter locators with `{visible:true}` (a hidden duplicate datepicker exists). Verify `.date-range-fields` text, then **Ok** → URL `from=YYYY-MM-DD&to=…`.
- A year-long range over all six channels can hang on "Loading" / "This table failed to load" → click the **Reload** link (`.error-data-link a`) once; narrowing to one channel first is much faster.

### 3 — Single channel
- `.channel-ghost.<name>.enabled` trusted clicks to disable others (youtube/pinterest start `disabled`; clicking a `.disabled` ghost enables it) → `Apply` button. Poll for `Posts (N)`.

### 4 — First post metrics (grid)
- Post cards are `.image-card`; the first is the one whose `innerText` starts with `1\n`. Its text lists `Engagements / Reactions / Comments / Shares / Response Rate / Video Views …` as label-value pairs (YouTube basic set: `Video Views / Likes / Comments`). Links inside: brand handle + the Type link (`Video`/`Image`) whose `href` is the canonical native URL.

### 5 — Click the image → native tab
- The image is `.image-card .image-link` (a div with a CSS background-image, cursor pointer; no `<img>`). Register `context.waitForEvent('page')` BEFORE clicking, then read the popup.

### 6 — Native reads (logged-out), per platform
| Platform | Result 2026-10-19 | Where the numbers are |
|---|---|---|
| **X / Twitter** | **HTTP 403 "Access to x.com was denied"** on the popup and on direct `x.com/...` and `twitter.com/...` navigations → **BLOCKED** (bot wall; needs a logged-in X session or another data path) | n/a |
| **Instagram** | Works (login overlay on top, content behind) | `<meta name="description">` = `"590K likes, 1,388 comments - hbomax on May 25, 2024: …"` — abbreviated likes; body text only shows per-comment likes |
| **YouTube** | Works, no consent wall | like button `[aria-label*="like this video"]` → `"like this video along with 168,948 other people"` (exact); scroll ~1200px then `#comments #count` → `"4,676 Comments"` |
| **LinkedIn** | Worked this run (public post page; header has Sign in / Join now but no `/authwall` redirect) | body text: reactions number right above `N Comments`; `document.title` = `"#tag \| UCLA \| 228 comments"`. Known to authwall intermittently |

## Assertion recipe
- Compare LFM vs native per metric, report absolute + % delta and direction. Spec says "no big variations" with no threshold; observed healthy drift: IG −1.4%, YT +0.04%, LinkedIn +10% (native higher on an old post = post kept accruing after LFM's stats window). If native < LFM by a lot, cite open bug **LFMP-32113**.

## Failure signatures
| Signature | Interpretation | Action |
|---|---|---|
| popup URL `chrome-error://chromewebdata/`, title `x.com`, HTTP 403 | X bot wall | BLOCKED on native access, not a product bug |
| LinkedIn popup URL contains `/authwall` | LinkedIn gating automated traffic | retry once; else BLOCKED on native access |
| Instagram page text only "Log in / Sign up" and no `meta[name=description]` | IG login wall | BLOCKED on native access |
| "This table failed to load" after Apply | slow dev analytics | click Reload once, then wait up to 90 s |

## Changelog
- **v1** (2026-10-19): initial skill from QA-22105 (BLOCKED, X 403), QA-22106 (PASS), QA-22107 (PASS), QA-22108 (PASS, 10% drift flagged).
