# QA-81509 — Listening Analysis > LFM vs Native

**Verdict: BLOCKED — native X/Twitter post unreachable (HTTP 403 bot wall at steps 7/8); LFM values captured, assertion 8 cannot be evaluated**

- Run: 2026-11-17, unattended headless (`claude -p`), Playwright MCP, env `app.lfmdev.in`
- Login: `lfiqa@listenfirstmedia.com` via Cognito "With existing account" (first attempt hit the Corporate-email form's Sign in button; re-clicked the existing-account form's button). Account switched to **Robinhood** (account_id=805) via the profile menu (Results list, exact "Robinhood"). The Listening top-nav item appears only after the switch.
- Open-bug screen (Rule 7): case file says "None open" -> ran normally.

## Steps executed

| # | Step | Result |
|---|---|---|
| Pre | Logged in as Robinhood | Breadcrumb "ACCOUNT: ROBINHOOD"; nav = Home / Dashboards / Brand / Brand Sets / Listening / Reporting (`.playwright-out/QA-81509/01-after-switch.png`) |
| 1 | Click Listening in top nav | Landed on `#explore/listening/conversation?account_id=805&...&channels=twitter` (Search Mentions form rendered; `02-listening.png`) |
| 2 | Add `#Robinhood` in Search term | Textarea showed `#Robinhood` (`04-form-filled.png`) |
| 3 | Select "Last 7 days" in Time Range | Select showed "Last 7 days" (`04-form-filled.png`) |
| 4 | Click Search Twitter | Search ran, URL gained `report_id=436313`; chart showed **2,189 Tweets** for Nov 10–16 2026 (`05-after-search.png`). The form fields reset to empty/date pickers after search (same as prior runs). |
| 5 | Click Load Tweets | Loading state shown (`06-after-load-tweets.png`) |
| 6 | Click View Now in success popup | "Hooray" popup appeared (`07-success-popup.png`); View Now clicked. Report rendered: 20,000 tweets loaded, Posts (538), ranked by Engagements (`08-after-view-now.png`) |
| 7 | Click the image on the first post | First post = rank 1 `@funtokio` ("Top 10 Trending #Robinhood", Wed Nov 11 2026 11:25 AM PST, Image, Original Post). `.image-link` click opened a new tab to `https://twitter.com/tweets/status/2120598895243710580` -> **x.com HTTP 403 "Access to x.com was denied"** (`11-native-tab.png`). One retry by navigating the tab again: same 403 (`12-native-tab-after-retry.png`). |
| 8 | Note Engagements, Likes, Comments, Retweets, Bookmarks | LFM side captured (below). Native side NOT obtainable. |

## Evidence — LFM values for the first post (`@funtokio`)

| Metric | LFM value |
|---|---|
| Engagements | 127 |
| Likes | 65 |
| Replies (spec "Comments") | 22 |
| Retweets | 32 |
| Quotes | 8 |
| Bookmarks | 3 |
| Followers | 14,325 |
| Views | 2,559 |

Consistency check: Likes 65 + Replies 22 + Retweets 32 + Quotes 8 = 127 = Engagements (Bookmarks excluded from the sum).
Native values: **not obtained** (x.com 403).

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A8 | 8 | LFM values should not have a big difference vs native values | LFM: Eng 127 / Likes 65 / Replies 22 / RT 32 / Bookmarks 3. Native page returned HTTP 403 in headless Chrome (popup + one retry), so there are no native numbers to compare. | BLOCKED (native access) |

Not scored PASS: no native numbers were read. Not scored FAIL: no product defect observed; the block is on the test environment's access to x.com.

## Known bugs checked
- Case file: no open linked bugs. `knowledge-base/bug-history.md` and `known-quirks.md`: no QA-81509 matches (pre-fetched).
- Related known behavior (skill `brand-content-native-post-check`, 2026-10-19; QA-81509 runs 2026-10-20 and 2026-10-22): x.com / twitter.com return 403 to the headless Playwright browser. Reproduced again, so it is environmental, not new.
- LFMP-32113 (native < LFM discrepancy) not applicable since no native value was read.

## Bugs filed
None (markdown-only run; no product defect found).

## Recommendation
This is the third consecutive BLOCKED run for the same reason. A real verdict needs native X data from a logged-in X session (headed Chrome profile logged into X) or a manual read of https://twitter.com/tweets/status/2120598895243710580, compared against the LFM values above. Compare soon after the run, because the LFM top post is dynamic (ranked by Engagements over the last 7 days).

## Skill maintenance
Deferred to harvest.sh. Suggested new skill: `listening-conversation-twitter-search`. Reusable selectors confirmed this run:
- Top nav `.navigation-menus .navigation-menu` "Listening" (only after switching to Robinhood)
- `textarea.tca-text-input`, `select.tca-time-range-select` (label "Last 7 days"), `button.tca-button` "SEARCH TWITTER" / "LOAD TWEETS"
- Success popup text "Hooray…" + "View Now"
- Post cards `[id^="post-item-"]` (rank n = suffix `-(n-1)`), `.image-link`; metric labels Engagements/Likes/Replies/Retweets/Quotes/Bookmarks/Followers/Views in the card text
- Login gotcha: two "Sign in" buttons on the Cognito page; scripts must target the "With existing account" form, not the first visible button.
