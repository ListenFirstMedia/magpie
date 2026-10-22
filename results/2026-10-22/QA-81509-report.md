# QA-81509 — Listening Analysis > LFM vs Native

**Verdict: BLOCKED — native X/Twitter post unreachable (HTTP 403 bot wall at step 7/8); LFM values captured, assertion 8 cannot be evaluated**

- Run: 2026-10-22, unattended headless (`claude -p`), Playwright MCP, env `app.lfmdev.in`
- Login: `lfiqa@listenfirstmedia.com` via Cognito "With existing account"; account switched to **Robinhood** (account_id=805) via the profile menu (Results list, exact "Robinhood"). The Listening top-nav item only appears after this switch.
- Open-bug screen (Rule 7): case file says "None open" -> ran normally.

## Steps executed

| # | Step | Result |
|---|---|---|
| Pre | Logged in as Robinhood | Breadcrumb "ACCOUNT: ROBINHOOD"; Listening nav item present (`.playwright-out/QA-81509/01-after-switch.png`) |
| 1 | Click Listening in top nav | Landed on `#explore/listening/conversation` (Conversation / Search Mentions); page needed ~25 s to render the form (`02-listening.png`, `03-listening-loaded.png`) |
| 2 | Add `#Robinhood` in Search term | Textarea value `#Robinhood` (`04-form-filled.png`) |
| 3 | Select "Last 7 days" in Time Range | Select shows "Last 7 days" |
| 4 | Click Search Twitter | Search ran, URL gained `report_id=436155` (`05-after-search.png`) |
| 5 | Click Load Tweets (default 500) | "Load Tweets" processing modal shown (`06-after-load-tweets.png`) |
| 6 | Click View Now in success popup | Popup "Hooray! Your report is ready." appeared after ~8 s (`07-success-popup.png`); View Now clicked. Report rendered: 5,965 Tweets, 51% original, Posts (545), sort Engagements (`08-after-view-now.png`, `09-posts-table.png`) |
| 7 | Click the image on the first post | First post = rank 1 `@TheSuitedApes` (tweet id 2112676367523598832). Image click opened a new tab -> **x.com HTTP 403 "Access to x.com was denied"**; one reload retry, same 403 (`11-native-tab.png`, `12-native-tab-after-reload.png`) |
| 8 | Note Engagements, Likes, Comments, Retweets, Bookmarks | LFM side captured (below). Native side NOT obtainable. |

Note: an early click targeted rank 2 by mistake (post ids are 0-based; rank 1 is `post-item-...-0`). That tab was closed and step 7 was redone on rank 1. The 403 was identical for both posts.

## Evidence — LFM values for the first post (`@TheSuitedApes`, Tue Oct 20 2026 03:44 PM PDT, "Another Major #Robinhood Partnership", Video, Original Post)

| Metric | LFM value |
|---|---|
| Engagements | 420 |
| Likes | 182 |
| Replies (spec "Comments") | 106 |
| Retweets | 124 |
| Quotes | 8 |
| Bookmarks | 10 |
| Followers | 3,598 |
| Views | 2,840 |

Consistency check: Likes 182 + Replies 106 + Retweets 124 + Quotes 8 = 420 = Engagements (Bookmarks excluded from the sum).
Native values: **not obtained** (x.com 403).

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A8 | 8 | LFM values should not have a big difference vs native values | LFM: Eng 420 / Likes 182 / Replies 106 / RT 124 / Bookmarks 10. Native page returned HTTP 403 in headless Chrome (popup + reload), so no native numbers to compare. | BLOCKED (native access) |

Not scored PASS: no native numbers were read. Not scored FAIL: no product defect observed; the block is on the test environment's access to x.com.

## Known bugs checked
- Case file: no open linked bugs. `knowledge-base/bug-history.md` and `known-quirks.md`: no QA-81509 matches (pre-fetched).
- Related known behavior (skill `brand-content-native-post-check`, 2026-10-19): x.com / twitter.com return 403 to the headless Playwright browser (same as QA-22105 BLOCKED). Reproduced here on the Listening surface, so it is environmental, not new.
- LFMP-32113 (native < LFM discrepancy) not applicable since no native value was read.

## Bugs filed
None (markdown-only run; no product defect found).

## Recommendation
To get a real verdict for this case, native X data is needed via a logged-in X session (headed Chrome with the profile logged into X) or by manually reading the native counts for https://twitter.com/tweets/status/2112676367523598832 and comparing to the LFM values above. Note the LFM top post is dynamic (ranked by Engagements over the last 7 days), so compare soon after the run.

## Skill maintenance
Deferred to harvest.sh. Suggested new skill: `listening-conversation-twitter-search` (no existing skill covered Listening). Reusable selectors learned:
- Top nav item `.navigation-menus .navigation-menu` "Listening" (only for accounts with Listening, e.g. Robinhood)
- `textarea.tca-text-input`, `select.tca-time-range-select` (option label "Last 7 days"), `button.tca-button` "SEARCH TWITTER" / "LOAD TWEETS"
- Success popup text "Hooray! Your report is ready." + "View Now"
- Post cards `[id^="post-item-"]`, rank n = id suffix `-(n-1)`; image link `.image-link`; metric labels Engagements/Likes/Replies/Retweets/Quotes/Bookmarks/Followers/Views inside the card text
