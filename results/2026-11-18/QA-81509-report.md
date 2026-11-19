# QA-81509 — Listening Analysis > LFM vs Native

**Verdict: BLOCKED — the native X/Twitter post page is unreachable (HTTP 403 bot wall at steps 7/8). Assertion 8 cannot be fully evaluated. Supplementary evidence from X's public embed API matches the LFM values on the two fields it exposes (Likes 65 = 65, Replies 22 = 22).**

- Run: 2026-11-18, unattended headless (`claude -p`), Playwright MCP, env `app.lfmdev.in`
- Login: `lfiqa@listenfirstmedia.com` via Cognito "With existing account" form. The account was Adam Orfei after login. I switched to **Robinhood** (account_id=805) through the LFQA profile menu (Results list, exact "Robinhood"). The Listening top-nav item appears only after the switch.
- Open-bug screen (Rule 7): the case file says "None open", and `results/open-bugs-2026-11-18.json` has no QA-81509 entry, so I ran the case normally.
- Note: step 4 (Search Twitter) creates a server-side report entry (`report_id=436315`). This is inherent to the spec step. Nothing was saved, renamed or deleted by me.

## Steps executed

| # | Step | Result |
|---|---|---|
| Pre | Logged in as Robinhood | Breadcrumb "ACCOUNT: ROBINHOOD". Nav = Home / Dashboards / Brand / Brand Sets / **Listening** / Reporting (`.playwright-out/QA-81509/01-home.png` is the pre-switch Adam Orfei screen). |
| 1 | Click Listening in the top nav | Landed on `#explore/listening/conversation?account_id=805&from=2026-11-10&to=2026-11-16&...&channels=twitter`. |
| 2 | Add `#Robinhood` in Search term | `textarea.tca-text-input` value = `#Robinhood`. |
| 3 | Select "Last 7 days" in Time Range | `select.tca-time-range-select` selected = "Last 7 days" (`04-form-filled.png`). |
| 4 | Click Search Twitter | Search ran. URL gained `report_id=436315`, route `/conversation/twitter/summary`. Tweet counts on page: 20,000 (compare period) and **2,189** (Nov 10–16 2026) (`05-after-search.png`). |
| 5 | Click Load Tweets | "We're processing the Tweets you requested…" loading dialog shown (`06-after-load-tweets.png`). |
| 6 | Click View Now in the success popup | The "View Now" popup appeared (`07-success-popup.png`) and I clicked it. The report rendered with **Posts (538)**, ranked by Engagements (`08-after-view-now.png`). |
| 7 | Click the image on the first post | The first post is rank 1, `@funtokio` ("🔥 Top 10 Trending #Robinhood 🔥…", Wed Nov 11 2026 11:25 AM PST, Image, Original Post). The `.image-link` click opened a new tab to `https://twitter.com/tweets/status/2120598895243710580`, which returned **x.com HTTP 403 "Access to x.com was denied"** (`11-native-tab.png`). One retry (re-navigating the tab) gave the same 403 (`12-native-tab-after-retry.png`). |
| 8 | Note Engagements, Likes, Comments, Retweets, Bookmarks | LFM side captured (below). Native side only partly obtained, via the supplementary route below. |

## Evidence — LFM values for the first post (`@funtokio`, id 2120598895243710580)

| Metric | LFM value | Native (supplementary, X embed API) |
|---|---|---|
| Engagements | 127 | not exposed |
| Likes | 65 | `favorite_count` = 65 (exact match) |
| Replies (spec "Comments") | 22 | `conversation_count` = 22 (exact match) |
| Retweets | 32 | not exposed |
| Quotes | 8 | not exposed |
| Bookmarks | 3 | not exposed |
| Followers | 14,325 | not read |
| Views | 2,559 | not exposed |

- LFM consistency check: Likes 65 + Replies 22 + Retweets 32 + Quotes 8 = 127 = Engagements (Bookmarks excluded from the sum).
- Supplementary source: `GET https://cdn.syndication.twimg.com/tweet-result?id=2120598895243710580` (X's own public embed endpoint, HTTP 200, saved at `.playwright-out/QA-81509/syndication-tweet-result.json`). It is X's own data, but it is **not** the native post page the spec names. It returns only `favorite_count` and `conversation_count`. It was fetched with curl outside the browser, so the headless browser's 403 is not bypassed, only worked around for two fields.

## Assertions

| ID | Step | Expected | Actual | Status |
|---|---|---|---|---|
| A8 | 8 | LFM values should not have a big difference vs native values | The native post page returned HTTP 403 in headless Chrome (popup + one retry), so Engagements, Retweets and Bookmarks have no native number. On the two fields X's embed API exposes, LFM equals native exactly (Likes 65/65, Replies 22/22, 0% delta). | BLOCKED (native access); no discrepancy observed on the available fields |

I did not score this PASS because the spec's native read (the post page, with Retweets/Bookmarks/Engagements) was not performed. I did not score it FAIL because no product defect was observed. The block is the test environment's access to x.com.

## Known bugs checked
- Case file: no open linked bugs. `knowledge-base/bug-history.md` and `known-quirks.md` had no QA-81509 matches (pre-fetched), and the open-bugs map for 2026-11-18 has no QA-81509 entry.
- Related known behavior (skill `brand-content-native-post-check`, 2026-10-19; earlier QA-81509 runs, most recently 2026-11-17): x.com and twitter.com return 403 to the headless Playwright browser. This reproduced again, so it is environmental, not new.
- LFMP-32113 (native < LFM discrepancy on past dates) does not apply. Where native values were read, they equal LFM.

## Bugs filed
None (markdown-only run; no product defect found).

## Recommendation
This is the fourth consecutive BLOCKED run for the same reason. A full verdict needs the native X page from a logged-in X session (a headed Chrome profile logged into X) or a manual read of https://twitter.com/tweets/status/2120598895243710580, to cover Retweets, Bookmarks and Engagements. The supplementary embed-API read could be added to the skill as a partial native check (Likes + Replies). Note that the top post is dynamic (ranked by Engagements over the last 7 days). The post was the same `@funtokio` post as on 2026-11-17, with identical LFM numbers.

## Skill maintenance
Deferred to harvest.sh. Suggested new skill: `listening-conversation-twitter-search`. Selectors confirmed this run:
- Top nav `.navigation-menus .navigation-menu` "Listening" (only after switching to Robinhood).
- Profile menu: click the "LFQA" text → `[placeholder="Search Account"]` → `.lfm-ta-option` "Robinhood".
- `textarea.tca-text-input`, `select.tca-time-range-select` (option "Last 7 days"), `button.tca-button` "SEARCH TWITTER" / "LOAD TWEETS".
- Success popup "View Now" (text locator). Post cards `[id^="post-item-"]` (rank n = suffix `-(n-1)`), `.image-link`. Metric labels in the card text: Engagements / Likes / Replies / Retweets / Quotes / Bookmarks / Followers / Views.
- Login gotcha: two "Sign in" buttons on the Cognito page. Use the "With existing account" form's button. The Playwright MCP `run_code_unsafe` sandbox has no `require` or `import('fs')`, so pass credentials through `fill_form`.
