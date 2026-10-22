# QA-21912 — Brand Content > LFM vs Native > Facebook Channel

**Verdict: BLOCKED — native Facebook post not readable (login wall on every public URL form), so the LFM-vs-Native comparison (A6) cannot be evaluated.**

- Run: 2026-10-22 (Thursday), unattended headless, Playwright MCP, dev (`app.lfmdev.in`), user `lfiqa@listenfirstmedia.com`
- Skill used: `brand-content-native-post-check` (+ `switch-account`); no skill maintenance done (deferred to harvest.sh)

## Setup / spec resolution
- Day = Thursday → Description table row: Account **FX Networks**, Brand **FX Networks** (second pair: Robinhood / Robinhood).
- The case's own "Notes" weekday line (Thu = Spotify / Conde Nast) contradicts the Jira Description table and appears stale; the Description table (the spec) was followed. Flag: fix the Notes line in `cases/QA-21912.md`.
- Only the first Thursday pair (FX Networks) was executed. The Robinhood pair was not run: the blocker below is native Facebook access, which is platform-wide and not account-specific.
- No date range is specified in the case; the app default (Oct 14 – Oct 20, 2026, Mode: Lifetime) was used.
- Rule 1: brand typeahead for "FX Networks" returned exactly one result, **"FX Networks Composite"** (brand_id=62693) — the known dev name for FX Networks. The account's default brand "FX" (4251) was NOT used.

## Steps executed
| # | Step | Result |
|---|------|--------|
| pre | Log in (Cognito "With existing account") | OK, landed on `#home` (was on Amazon Prime Video account) |
| pre | Switch account → FX Networks (LFQA menu hover → Search Account → `.lfm-ta-option` under Results) | OK, breadcrumb `ACCOUNT: FX NETWORKS`, `account_id=204` |
| 1 | Hover Brand → Content | OK, `#explore/brand/content?brand_id=4251` (default brand "FX") |
| 2 | Add a Brand: chevron → "Search for a Brand" → type `FX Networks` → click result | OK, **FX Networks Composite**, `brand_id=62693` |
| 3 | Enable Facebook channel only (trusted clicks on twitter/instagram/linkedin/tiktok/threads ghosts → disabled; Apply) | OK, URL `channels=facebook`; ghosts: only `facebook enabled`; **Posts (54)** |
| 4 | Note Reactions / Comments / Shares of first post | OK — values below |
| 5 | Click image on first post | OK — new tab opened to `https://www.facebook.com/200060813363243_1669083231243076` (first attempt via locator click produced no popup; real mouse click at image-link center opened it) |
| 6 | Note native Likes / Comments / Shares | **BLOCKED** — no values visible (see below) |

## Evidence
**LFM first post (Posts #1, sort = Engagements desc, FB-only, Oct 14–20 2026):**
- Brand/handle: American Horror Story (`facebook.com/americanhorrorstory`), type Video, published SAT OCT 17 2026 12:00 PM PDT
- Caption: "Marie Laveau and Papa Legba make a powerful duo FX's AHS: 13. Watch now on FX | Hulu."
- Engagements **49,547** · Reactions **46,521** · Comments **572** · Shares **2,454** · Response Rate – · Video Views 1,758,307 · Video Response Rate 2.82%
- (Reactions 46,521 + Comments 572 + Shares 2,454 = 49,547 = Engagements ✔ internally consistent)
- Screenshot: `.playwright-out/QA-21912/04-fb-posts-loaded.png`

**Native (logged-out Facebook), all attempts:**
| URL tried | Result |
|---|---|
| `facebook.com/200060813363243_1669083231243076` (href from the LFM tile) | "This content isn't available at the moment" + Log in form; no `og:description` |
| `facebook.com/americanhorrorstory/videos/1669083231243076/` | "This video is no longer available" + Log in prompt (generic Watch shell) |
| `facebook.com/watch/?v=1669083231243076` | same — "This video is no longer available" |
| `m.facebook.com/200060813363243_1669083231243076` (redirected to www) | "This content isn't available at the moment" |
| `facebook.com/permalink.php?story_fbid=1669083231243076&id=200060813363243` | "This content isn't available at the moment" |
- Screenshots: `.playwright-out/QA-21912/05-native-fb.png`, `.playwright-out/QA-21912/06-native-fb-fallbacks.png`
- Interpretation: Facebook gates logged-out/automated sessions; the message text is the standard login-wall state, not proof the post was deleted (the post is live in LFM data from 2026-10-17, 5 days old). No Facebook credentials exist in `config/.env`, so a logged-in read is not possible in this run. Nothing was inferred or fabricated for the native values.

## Assertions
| ID | Step | Expected | Actual | Status |
|----|------|----------|--------|--------|
| A6 | 6 | LFM Reactions/Comments/Shares of first post show no big variation vs Native Likes/Comments/Shares | LFM: 46,521 / 572 / 2,454. Native: unreadable (Facebook login wall on all 5 URL forms) — no comparison possible | BLOCKED |

## Known bugs checked
- Case file "Open linked bugs": none open → Rule 7 screen passed, case run.
- `knowledge-base/bug-history.md` / `known-quirks.md` had no QA-21912 entries (pre-fetched). The skill mentions LFMP-32113 (native < LFM by a lot); not applicable since no native value was obtained.
- Environment note: the home page showed a banner "Facebook Posts Insights Disruption (+1 more incident)" at login. It did not prevent Facebook posts from rendering (54 posts, full metrics), and cannot be tied to this blocker; recorded as context only.

## Bugs filed
None. (Native-access wall is a test-environment limitation, same class as the X/Twitter 403 in QA-22105.)

## Follow-ups for the human
1. To make this case runnable, provide a logged-in Facebook session (or a read-only FB test account / Graph API token) for the native-side read; alternatively mark the FB LFM-vs-Native cases as manual.
2. Fix the stale weekday-rotation line in `cases/QA-21912.md` Notes (conflicts with the Jira Description table).
3. Skill update for harvest (not done now): `brand-content-native-post-check` should list **Facebook** in its native-reads table → logged-out wall ("This content isn't available at the moment"), BLOCKED on native access; and note that the first-post `.image-link` needs a real mouse click at its center (locator `.click()` after a `hasText:/^1\n/` filter did not match; first locator click opened no popup).
